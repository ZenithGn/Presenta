package com.websocket;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@ServerEndpoint("/notifications")
public class NotificationEndpoint {

    private static final Logger logger = LogManager.getLogger(NotificationEndpoint.class);
    
    // Thread-safe set of all connected sessions
    private static final Set<Session> activeSessions = new CopyOnWriteArraySet<>();

    @OnOpen
    public void onOpen(Session session) {
        activeSessions.add(session);
        logger.info("New WebSocket session opened: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // Here we can handle incoming messages from clients if needed
        logger.info("Received message from client {}: {}", session.getId(), message);
    }

    @OnClose
    public void onClose(Session session) {
        activeSessions.remove(session);
        logger.info("WebSocket session closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        activeSessions.remove(session);
        logger.error("WebSocket error for session " + session.getId(), throwable);
    }

    /**
     * Gửi thông báo đến tất cả các client đang kết nối.
     * Có thể gọi hàm này từ bất kỳ đâu: NotificationEndpoint.broadcast("Hello!");
     */
    public static void broadcast(String message) {
        for (Session session : activeSessions) {
            if (session.isOpen()) {
                try {
                    session.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    logger.error("Failed to send message to session " + session.getId(), e);
                }
            }
        }
    }
}
