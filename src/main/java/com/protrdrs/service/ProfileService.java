package com.protrdrs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import com.protrdrs.model.ProfileDetails;
import com.protrdrs.repository.ProfileRepository;

import org.springframework.transaction.annotation.Transactional;
import java.util.Map;
import java.util.HashMap;

@Service
public class ProfileService {
	
	@Autowired
    private ProfileRepository profileRepository;
	
	public ProfileDetails getProfileDetails(Long userId) {
		ProfileDetails profileDetails =  new ProfileDetails();
		profileDetails =  profileRepository.getProfileDetails(userId);
		return profileDetails;
    }
	
	public String getReferrCustomerId(Long peopleId) {
		return profileRepository.getReferrCustomerId(peopleId);
	}
	
	public Long getPeopleIdByCustomerId(String customerId) {
		return profileRepository.getPeopleIdByCustomerId(customerId);
	}
    
    @Transactional
    public Map<String,String> updateUserDetails(Map<String, Object> formData) {
        String type = (String) formData.get("type");
        String peopleId= (String) formData.get("pid");
        String errMsg = "";
		String result = "";
    	Long userId =  Long.valueOf(peopleId);
    	if ("gnrl".equalsIgnoreCase(type))  result = profileRepository.updateGeneralInfo(userId, formData);
        else if ("pwd".equalsIgnoreCase(type)) result = profileRepository.updatePassword(userId, formData);
        else if ("bank".equalsIgnoreCase(type)) result= profileRepository.updateBankDetails(userId, formData);
        else  result="Invalid type specified";
        
		if("0".equalsIgnoreCase(result)) errMsg="Details saved successfully";
		else if("-1".equalsIgnoreCase(result)) errMsg ="Details are not saved, Please try agian";
		else if("-2".equalsIgnoreCase(result)) errMsg ="We couldn't find your details ";	
		else if("-99".equalsIgnoreCase(result)) errMsg ="Password dont match with our database";			
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put("errCd",result);
		resultMap.put("errMsg",errMsg);
		
		return resultMap;
    }
}
