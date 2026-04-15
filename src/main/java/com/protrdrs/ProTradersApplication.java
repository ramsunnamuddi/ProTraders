package com.protrdrs;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication(exclude = {SecurityAutoConfiguration.class})
@EnableScheduling
@EnableAsync
public class ProTradersApplication{

	public static void main(String[] args) {
		SpringApplication.run(ProTradersApplication.class, args);
	}
}
