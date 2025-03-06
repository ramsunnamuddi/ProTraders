package com.mlm.custprgm.srvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {
	@GetMapping("/")
	public String home() {
		return "home";
	}
	
	@GetMapping("/mainPage")
    public String mainPage() {
        return "index"; // Load index.jsp
    }
	
	@GetMapping("/dashboard")
    public String dashboard() {
        return "dashboard"; // Load dashboard.jsp
    }
	
	@GetMapping("/trxn")
    public String showPortfolio() {
        return "transactionView"; // This will look for /WEB-INF/views/portfolio.jsp
    }
	
	@GetMapping("/settings")
    public String showSettings() {
        return "settings"; // This will look for /WEB-INF/views/portfolio.jsp
    }
	
	@GetMapping("/dl")
    public String showDownline() {
        return "downline"; // This will look for /WEB-INF/views/portfolio.jsp
    }
	
	@GetMapping("/bns")
    public String showBonus() {
        return "bonus"; // This will look for /WEB-INF/views/portfolio.jsp
    }
}
