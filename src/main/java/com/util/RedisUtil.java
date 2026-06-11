package com.util;

import io.github.cdimascio.dotenv.Dotenv;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.util.concurrent.ConcurrentHashMap;

public class RedisUtil {
    private static final Logger logger = LogManager.getLogger(RedisUtil.class);
    private static JedisPool jedisPool;
    private static boolean isRedisAvailable = false;

    // Local Fallback Cache in case Redis is not available
    private static final ConcurrentHashMap<String, CacheEntry> localCache = new ConcurrentHashMap<>();

    private static class CacheEntry {
        String value;
        long expireAt;

        CacheEntry(String value, long expireAt) {
            this.value = value;
            this.expireAt = expireAt;
        }
    }

    static {
        try {
            Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
            String host = dotenv.get("REDIS_HOST", "localhost");
            int port = Integer.parseInt(dotenv.get("REDIS_PORT", "6379"));
            String password = dotenv.get("REDIS_PASSWORD", ""); // if any

            JedisPoolConfig poolConfig = new JedisPoolConfig();
            poolConfig.setMaxTotal(50);
            poolConfig.setMaxIdle(10);
            poolConfig.setMinIdle(2);

            if (password != null && !password.isEmpty()) {
                jedisPool = new JedisPool(poolConfig, host, port, 2000, password);
            } else {
                jedisPool = new JedisPool(poolConfig, host, port, 2000);
            }
            
            // Test connection
            try (Jedis jedis = jedisPool.getResource()) {
                if ("PONG".equals(jedis.ping())) {
                    isRedisAvailable = true;
                    logger.info("Successfully connected to Redis at {}:{}", host, port);
                }
            }
        } catch (Exception e) {
            logger.warn("Could not connect to Redis. Local Map Caching will be used as fallback. Error: {}", e.getMessage());
            isRedisAvailable = false;
        }
    }

    public static Jedis getJedis() {
        if (!isRedisAvailable || jedisPool == null) {
            return null;
        }
        try {
            return jedisPool.getResource();
        } catch (Exception e) {
            logger.error("Failed to get Jedis resource from pool", e);
            return null;
        }
    }

    public static boolean isAvailable() {
        return true; // We always return true because we have a local fallback
    }

    public static void setCache(String key, String value, int expirationInSeconds) {
        if (isRedisAvailable) {
            try (Jedis jedis = getJedis()) {
                if (jedis != null) {
                    jedis.setex(key, expirationInSeconds, value);
                    return;
                }
            } catch (Exception e) {
                logger.error("Error setting cache for key: " + key, e);
            }
        }
        // Fallback
        localCache.put(key, new CacheEntry(value, System.currentTimeMillis() + expirationInSeconds * 1000L));
        logger.debug("Stored in local cache: {}", key);
    }

    public static String getCache(String key) {
        if (isRedisAvailable) {
            try (Jedis jedis = getJedis()) {
                if (jedis != null) {
                    return jedis.get(key);
                }
            } catch (Exception e) {
                logger.error("Error getting cache for key: " + key, e);
            }
        }
        // Fallback
        CacheEntry entry = localCache.get(key);
        if (entry != null) {
            if (System.currentTimeMillis() <= entry.expireAt) {
                return entry.value;
            } else {
                localCache.remove(key); // Expired
            }
        }
        return null;
    }

    public static void deleteCache(String... keys) {
        if (isRedisAvailable) {
            try (Jedis jedis = getJedis()) {
                if (jedis != null && keys != null && keys.length > 0) {
                    jedis.del(keys);
                    logger.debug("Deleted cache keys: {}", (Object) keys);
                    return;
                }
            } catch (Exception e) {
                logger.error("Error deleting cache keys", e);
            }
        }
        // Fallback
        if (keys != null) {
            for (String k : keys) {
                localCache.remove(k);
            }
        }
    }
    
    public static void deleteCacheByPattern(String pattern) {
        if (isRedisAvailable) {
            try (Jedis jedis = getJedis()) {
                if (jedis != null) {
                    java.util.Set<String> keys = jedis.keys(pattern);
                    if (keys != null && !keys.isEmpty()) {
                        jedis.del(keys.toArray(new String[0]));
                        logger.debug("Deleted cache keys by pattern: {}", pattern);
                        return;
                    }
                }
            } catch (Exception e) {
                logger.error("Error deleting cache by pattern: " + pattern, e);
            }
        }
        // Fallback (simple implementation since regex matching for maps is complex, 
        // we'll just match the prefix for '*' ending patterns which is most common)
        if (pattern.endsWith("*")) {
            String prefix = pattern.substring(0, pattern.length() - 1);
            localCache.keySet().removeIf(k -> k.startsWith(prefix));
        } else {
            localCache.remove(pattern);
        }
    }
}
