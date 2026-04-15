package com.protrdrs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.protrdrs.model.DashboardDetails;
import com.protrdrs.repository.DashboardRepository;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class DashboardService {

    @Autowired
    private DashboardRepository dashboardRepository;

    public DashboardDetails getDashboardDetails(Long userId) {
    	DashboardDetails dashboardDetails =  new DashboardDetails();
		dashboardDetails =  dashboardRepository.getDashboardDetails(userId);
		return dashboardDetails;
    }
}
