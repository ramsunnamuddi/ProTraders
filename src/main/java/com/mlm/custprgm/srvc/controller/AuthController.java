package com.mlm.custprgm.srvc.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
//import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

//import com.mlm.custprgm.srvc.services.AuthService;

import jakarta.servlet.http.HttpServletRequest;

@RestController 
@ResponseStatus
@RequestMapping("/api/auth")
public class AuthController {
    
   /* @Autowired
    private AuthService authService;*/
    
    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestParam String username, @RequestParam String password, HttpServletRequest request) {
    	 try {
    	        System.out.println("Login attempt for: " + username);
    	        String result = "SUCCESS";
    	        System.out.println("Login result: " + result);
    	        return ResponseEntity.ok(result);
    	    } catch (Exception e) {
    	        e.printStackTrace();  // Force error to be printed
    	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
    	    }
    }

    @GetMapping("/validate")
    public ResponseEntity<String> validateSession(HttpServletRequest request) {
    	String result = "VALID";
         return ResponseEntity.ok(result);//authService.validateSession(request);
    }

    @PostMapping("/logout")
    public String logout(HttpServletRequest request) {
        return "LOGGED_OUT";//authService.logout(request);
    }
    
}
