package com.protrdrs.scheduledjobs;

import java.time.LocalDateTime;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ScheduledTopupUpdate {
	@Autowired
    private JdbcTemplate jdbcTemplate;
	@Async
    @Scheduled(cron = "0 0 2 ? * MON-FRI",  zone = "Asia/Kolkata")  // Runs Monday to Friday at 2 AM
    public void updateViaStoredProcedure() {
        try {

        	System.out.println("Procedure execution Started at " + LocalDateTime.now());
            jdbcTemplate.execute("CALL add_interest()");
            System.out.println("Procedure execution completed at " + LocalDateTime.now());
        } catch (Exception e) {
        	System.out.println("Error executing procedure: " + e.getMessage());
        }
    }

}
