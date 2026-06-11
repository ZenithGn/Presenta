package com.listener;

import com.model.VoucherDAO;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger logger = LogManager.getLogger(AppContextListener.class);
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Application starting up! Initializing Task Scheduler...");

        // Khởi tạo một luồng chạy ngầm
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Định kỳ chạy mỗi 1 phút (hoặc 1 giờ tuỳ chỉnh)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                // Tác vụ: Xoá / Disable Voucher hết hạn
                VoucherDAO voucherDAO = new VoucherDAO();
                int expiredCount = voucherDAO.disableExpiredVouchers();
                
                if (expiredCount > 0) {
                    logger.info("Task Scheduler: Disabled " + expiredCount + " expired vouchers.");
                } else {
                    logger.debug("Task Scheduler: No expired vouchers found.");
                }
            } catch (Exception e) {
                logger.error("Error during scheduled task execution", e);
            }
        }, 0, 1, TimeUnit.MINUTES); // Chạy ngay lập tức (0), sau đó lặp lại mỗi 1 phút
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Application shutting down! Stopping Task Scheduler...");
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
        }
    }
}
