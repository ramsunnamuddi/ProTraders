package com.protrdrs.service;


import org.springframework.security.crypto.password.PasswordEncoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.protrdrs.repository.RegisterUserRepositoryImpl;

@Service
public class RegisterUserService {
	
	@Autowired
    private RegisterUserRepositoryImpl registerUserRepositoryImpl;
	@Autowired
	private PasswordEncoder passwordEncoder;

    public String registerUser(String sponsorId, String position, String fullName,
                             String mobileNumber, String email, String password) {
    	return registerUserRepositoryImpl.registerUser(sponsorId, position, fullName, mobileNumber, email, getHashedPassword(password) );
    }
    
    private String  getHashedPassword(String password) {
	    return passwordEncoder.encode(password);
    }

}
