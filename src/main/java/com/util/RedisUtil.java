package com.util;

import io.github.cdimascio.dotenv.Dotenv;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class RedisUtil {
    private static final Logger logger = LogManager.getLogger(RedisUtil.class);
    private static JedisPool jedisPool;
    private static boolean isRedisAvailable = false;

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
            logger.warn("Could not connect to Redis. Caching will be disabled. Error: {}", e.getMessage());
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
        return isRedisAvailable;
    }

    public static void setCache(String key, String value, int expirationInSeconds) {
        if (!isAvailable()) return;
        try (Jedis jedis = getJedis()) {
            if (jedis != null) {
                jedis.setex(key, expirationInSeconds, value);
            }
        } catch (Exception e) {
            logger.error("Error setting cache for key: " + key, e);
        }
    }

    public static String getCache(String key) {
        if (!isAvailable()) return null;
        try (Jedis jedis = getJedis()) {
            if (jedis != null) {
                return jedis.get(key);
            }
        } catch (Exception e) {
            logger.error("Error getting cache for key: " + key, e);
        }
        return null;
    }

    public static void deleteCache(String... keys) {
        if (!isAvailable()) return;
        try (Jedis jedis = getJedis()) {
            if (jedis != null && keys != null && keys.length > 0) {
                jedis.del(keys);
                logger.debug("Deleted cache keys: {}", (Object) keys);
            }
        } catch (Exception e) {
            logger.error("Error deleting cache keys", e);
        }
    }
    
    public static void deleteCacheByPattern(String pattern) {
        if (!isAvailable()) return;
        try (Jedis jedis = getJedis()) {
            if (jedis != null) {
                java.util.Set<String> keys = jedis.keys(pattern);
                if (keys != null && !keys.isEmpty()) {
                    jedis.del(keys.toArray(new String[0]));
                    logger.debug("Deleted cache keys by pattern: {}", pattern);
                }
            }
        } catch (Exception e) {
            logger.error("Error deleting cache by pattern: " + pattern, e);
        }
    }
}
