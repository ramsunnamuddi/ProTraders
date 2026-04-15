package com.protrdrs.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.beans.factory.annotation.Autowired;

import com.protrdrs.model.DashboardDetails;
import com.protrdrs.model.ProfileDetails;
import com.protrdrs.model.QrCode;
import com.protrdrs.service.DashboardService;
import com.protrdrs.service.ProfileService;
import com.protrdrs.service.QrCodeService;
import com.protrdrs.service.TransactionService;
import com.protrdrs.util.EncryptionUtil;
import com.protrdrs.service.AuthService;

import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;

import org.springframework.ui.Model;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.*;
import com.protrdrs.service.AdminDataService;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.TimeZone;

@Controller
public class HomeController {
	
	private static final String appendStr="";
	
	@Autowired
    private DashboardService dashboardService;
    @Autowired
    private ProfileService profileService;    
    @Autowired
	AdminDataService adminDataService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private QrCodeService qrCodeService ;    
    @Autowired
    private AuthService authService;
	
	@GetMapping("/")
	public String home() {
		return appendStr+"home";	
	}
	
	@PostMapping("/index")
    public String mainPage(@RequestParam String sid, @RequestParam String pid, Model model) {
		if(authService.validateSession(sid,pid)) {
			model.addAttribute("sid", sid);
			model.addAttribute("pid", pid);
			return appendStr+"index";// Load index.jsp 
		}
		return appendStr+"invalid";
        
    }
	
	@PostMapping("/dashboard")
    public String dashboard(@RequestBody Map<String, String> formData, Model model) throws Exception {
		 if(authService.validateSession(formData)) {
			 Long peopleId=getPeopleId(formData);
			DashboardDetails details = dashboardService.getDashboardDetails(peopleId);	
			model.addAttribute("dashboardDetails", details);
			return appendStr+"dashboard";
		}
        return appendStr+"invalid"; // Load dashboard.jsp
    }
	
	@GetMapping("/{token}")
	public String handleReferral(@PathVariable String token, Model model) {
		try {
	        String decrypted = EncryptionUtil.decrypt(token); // e.g. refId=123&position=left
	        String[] pairs = decrypted.split("&");
	        String referrerCustId="";
	        String position="";
	        for (String pair : pairs) {
	            String[] keyValue = pair.split("=");
	            if (keyValue.length== 2) {
	            	if("refId".equals(keyValue[0])) referrerCustId=profileService.getReferrCustomerId(Long.parseLong(keyValue[1]));
	            	else position="left".equals(keyValue[1])?"1":("right".equals(keyValue[1])?"2":"");
	            }
	        }
	        model.addAttribute("referrer", referrerCustId);
	        model.addAttribute("position", position);
	        model.addAttribute("showSignup", referrerCustId!=null&&referrerCustId.length()>0); // trigger flag
	    } catch (Exception e) {
	        model.addAttribute("error", "Invalid referral link");
	        model.addAttribute("showSignup", false);
	    }
	    return "home";
	}
	
	@PostMapping("/fndtrns")
	public String getFundsTransfer(@RequestBody Map<String, String> formData, Model model) {//FOR FUNDTRANSFER LANDING PAGE
		List<Object[]> fundRequests = null;
		if(authService.validateSession(formData)) {			
	        int pageSize = 5;
	        int page = formData.get("page") != null ? Integer.parseInt(formData.get("page")) : 1;
	        int offset = (page - 1) * pageSize;
	        Long userId = getPeopleId(formData);
        	fundRequests = transactionService.getFilteredFundRequests(userId, "", "", "", "DESC", offset, pageSize);
        	model.addAttribute("fundRequests", fundRequests);
        	int totalRecords = transactionService.countFundRequests(userId, "","", "");
	        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        List<QrCode> qrCodes = qrCodeService.getAllFiles(); // This should return List<QrCode>
	        List<String> base64QRCodes = new ArrayList<>();
	        
	        for (QrCode qrCode : qrCodes) {
	            String base64Data = Base64.getEncoder().encodeToString(qrCode.getFileData());
	            String fileType;
	            if (qrCode.getFilename().endsWith(".pdf")) {
	                fileType = "application/pdf";
	            } else {
	                fileType = "image/png"; // Adjust based on actual file types you support
	            }
	            String base64QRCode = "data:" + fileType + ";base64," + base64Data;
	            base64QRCodes.add(base64QRCode);
	        } 
	        model.addAttribute("qrCodesList", base64QRCodes);
    	    return appendStr+"fundtransfer";	
        }
		return appendStr+"invalid";	
	}    
	
	@PostMapping("/tpups")
	public String getTopups(@RequestBody Map<String, String> formData,Model model) {//FOR TOPUP LANDING PAGE
    	// If fromDate or toDate is not provided, pass null to the service (query will ignore them)
        List<Object[]> topUps = null;
        int pageSize = 5;
        int page = formData.get("page") != null ? Integer.parseInt(formData.get("page")) : 1;
        int offset = (page - 1) * pageSize;
        if(authService.validateSession(formData)) {
        	double balance=0.0;
        	Long userId = getPeopleId(formData);
    	 	topUps = transactionService.getFilteredTopUps(userId, "", "", "","","DESC", offset, pageSize);
    	 	balance=transactionService.getAvailableBalance(userId);
    	 	model.addAttribute("topups",topUps);
	        model.addAttribute("pkgs",adminDataService.getPackages());
	        model.addAttribute("balance",balance);
	        int totalRecords = transactionService.countTopups(userId, "","", "", "");	        
	        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        return "topup";
		}       
        return appendStr+"invalid";
    }
    
	@PostMapping("/wdw")
   	public String getWithdrawals(@RequestBody Map<String, String> formData,HttpServletRequest request, Model model) {//For Withdrawals LANDING PAGE
       	// If fromDate or toDate is not provided, pass null to the service (query will ignore them)
        List<Object[]> withdrawals = null;
        int pageSize = 5;
        int page = formData.get("page") != null ? Integer.parseInt(formData.get("page")) : 1;
        int offset = (page - 1) * pageSize;
        if(authService.validateSession(formData)) {
        	Long peopleId= getPeopleId(formData);
       	 	withdrawals = transactionService.getFilteredWithdrawals(peopleId, "", "", "", "DESC", offset, pageSize);
       	 	model.addAttribute("wdws",withdrawals);
	       	int totalRecords = transactionService.countWithdrawals(peopleId, "","", "", "");
	        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
       	 	return "withdrawals";
   		}           
        return appendStr+"invalid";
    }
	
	@PostMapping("/dl")
    public String showDownline(@RequestBody Map<String, String> formData) {
		 if(authService.validateSession(formData)) return appendStr+"downline";
		 return appendStr+"invalid";
    }
	
	@PostMapping("/bns")
    public String showBonus(@RequestBody Map<String, String> formData, HttpServletRequest request) {
		if(authService.validateSession(formData)) return appendStr+"bonus";
		return appendStr+"invalid";        
    }
	
	@PostMapping("/prfl")
    public String showProfile(@RequestBody Map<String, String> formData, Model model) {
		if(authService.validateSession(formData)) {
			ProfileDetails details = profileService.getProfileDetails(getPeopleId(formData));
			model.addAttribute("profileDetails", details);
			return appendStr+"profile";
		}
        return appendStr+"invalid";
    }
	
	@GetMapping("/invalid")
    public String showInvalid() {
        return appendStr+"invalid"; // This will look for /WEB-INF/views/portfolio.jsp
    }
	
	
	@GetMapping("/adfnds")
    public String showAdFnds(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) return appendStr+"/";
        return appendStr+"addFunds"; // This will look for /WEB-INF/views/portfolio.jsp
    }
    
    @GetMapping("/notify")
    public String showNotifications(HttpServletRequest request) {
    	HttpSession session = request.getSession(false);
    	System.out.println("Session is null=="+(session==null));
		if (session == null) return appendStr+"/";
        return appendStr+"notifications"; // This will look for /WEB-INF/views/portfolio.jsp
    }
    
    @GetMapping("/admin")
    public String admin() {
        return "admin_pages/adminLogin"; // Spring will look for /admin_pages/dashboard.jsp
    }
    
    @PostMapping("/admdashboard")
    public String admindashboard(@RequestParam String sid, @RequestParam String pid, Model model) {
    	if(authService.validateSession(sid,pid)) {
			model.addAttribute("sid", sid);
			model.addAttribute("pid", pid);
			Map<String, Object> details = adminDataService.getDashboardData();
			model.addAttribute("dshbrdDtls", details);
			return "admin_pages/dashboard";// Load index.jsp 
		}
    	return appendStr+"invalid";
    } 
    
    private Long getPeopleId(Map<String, String> formData) {
		String peopleId = formData.get("pid");
		Long userId =  Long.valueOf(peopleId);
		return userId;
   }
}
