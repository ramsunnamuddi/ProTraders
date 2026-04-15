package com.protrdrs.controllers;

import org.springframework.web.bind.annotation.RestController;

import com.protrdrs.service.AuthService;
import com.protrdrs.service.ProfileService;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/prfl")
public class ProfileController {
	
	@Autowired
    private ProfileService profileService;
	
	@Autowired
	private AuthService authService;
    
	@PostMapping("/saveDetails")
    public Map<String,String> saveDetails(@RequestBody Map<String,Object> formData , HttpServletResponse response) {
		if (!authService.validateSession(constructLoginFormData(formData))) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
		    return Collections.emptyMap();
		}
		Map<String, String> resultMap = profileService.updateUserDetails(formData);
		return resultMap;
    }
	
	private Map<String, String> constructLoginFormData(Map<String,Object> formData) {
		Map<String,String> loginData =  new HashMap<>();
		loginData.put("sid", (String)formData.get("sid"));
		loginData.put("pid", (String)formData.get("pid"));
		return loginData;
	}
}
