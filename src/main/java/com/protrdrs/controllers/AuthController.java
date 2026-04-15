package com.protrdrs.controllers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.protrdrs.model.UserRegisterRequest;
import com.protrdrs.service.AuthService;
import com.protrdrs.service.RegisterUserService;

import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/auth")
public class AuthController {
	@Autowired
    private RegisterUserService registerUserService;
    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public Map<String, String> registerUser(@RequestBody UserRegisterRequest request) {
    	String customerId = registerUserService.registerUser(
            request.getSponsorId(), request.getPosition(), request.getFullName(),
            request.getMobileNumber(), request.getEmail(), request.getPassword()
        );
    	if(customerId!=null&&customerId.length()>0) {
    		try {
    			authService.generateLinks(customerId);
    		}catch(Exception ex) {
    			System.out.println("exception occured while creating the links");
    			ex.printStackTrace();
    		}
    	}
    	return Map.of("customerId", customerId);
    }

    @PostMapping("/login")
    public Map<String, String> login(@RequestBody Map<String, String> request, HttpServletRequest httpRequest) {
        String username = request.get("username");
        String password = request.get("password");
        String ipAddress = getClientIp(httpRequest);
        String browserInfo = getBrowserInfo(httpRequest);

        Map<String, String> resultMap = authService.loginUser(username, password, ipAddress, browserInfo, httpRequest);
       	return resultMap;
    }
    
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");  // Handles proxies and load balancers        
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();  // Fallback to direct IP
        }
        return ip;
    }
    private String getBrowserInfo(HttpServletRequest request) {    	
        return request.getHeader("User-Agent");  // Gets browser details
    }
    
    
    @GetMapping("/logout")
    public String logout(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
    		HttpServletRequest request, 
    		HttpServletResponse response) {
        authService.logout(sid,pid, request, response);
        return "Logged out successfully";
    }
    
    @GetMapping("/generate-all")
    public ResponseEntity<String> generateLinksForAllUsers() {
        try {
            authService.generateReferralLinksForAllUsers();
            return ResponseEntity.ok("Referral links generated successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Failed to generate referral links: " + e.getMessage());
        }
    }
}
