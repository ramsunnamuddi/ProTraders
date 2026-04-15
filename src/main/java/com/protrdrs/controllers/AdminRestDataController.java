package com.protrdrs.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.protrdrs.service.AuthService;
import com.protrdrs.service.DashboardService;
import com.protrdrs.service.QrCodeService;
import com.protrdrs.service.TransactionService;

import java.util.Map;
import java.util.stream.Collectors;
import java.io.IOException;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import com.protrdrs.model.DashboardDetails;
import com.protrdrs.model.EnhancedTreeNode;
import com.protrdrs.model.QrCode;
import com.protrdrs.model.TotalTeamDTO;
import com.protrdrs.service.AdminDataService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@RestController
@RequestMapping(value = "/admin/dt")
public class AdminRestDataController {
	
	@Autowired
	private AdminDataService adminDataService;
	@Autowired
	private QrCodeService qrCodeService;
	
	@Autowired
	AuthService authService;
	
	@Autowired
	DashboardService  dashboardService;
	
	@Autowired
	TransactionService transactionService;
	
	@GetMapping("/fundTransfer")
	public List<Map<String,Object>> getFundTransferData(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid, 
			@RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false, defaultValue = "1") int page
			, HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return Collections.emptyList();
	    }
		int pageSize = 5;
		int offset = (page - 1) * pageSize;
		return adminDataService.getFundTransferData(fromDate, toDate, status,offset, pageSize);
	}
	
	@GetMapping("/fundTransfercnt")
	public int getFundTransferCount(
			@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid, 
			@RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate
			, HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return 0;
	    }
		Long userPeopleId=null;
		return transactionService.countFundRequests(userPeopleId,status, fromDate, toDate);
	}
	
	@GetMapping("/topup")
	public Map<String,Object> getTopupData(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,  
			@RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) String packageId,
            @RequestParam(required = false, defaultValue = "1") int page
			, HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return Collections.emptyMap();
	    }
		int pageSize = 5;
		int offset = (page - 1) * pageSize;
		if(packageId!=null) packageId=packageId.replaceAll(",", "");	
		return adminDataService.getTopupData(fromDate, toDate, status,packageId,offset, pageSize);
	}
	
	@GetMapping("/topupcnt")
	public int getTopupCount(
			@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid, 
			@RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) String packageId
			, HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return 0;
	    }
		Long userPeopleId=null;
		if(packageId!=null) packageId=packageId.replaceAll(",", "");
		return transactionService.countTopups(userPeopleId,status, fromDate, toDate,packageId);
	}
	
	@GetMapping("/withdrawal")
	public List<Map<String,Object>> getWithdrawalData(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,  
    		@RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) String searchBy,
            @RequestParam(required = false, defaultValue = "1") int page
			, HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return Collections.emptyList();
	    }
		int pageSize = 10;
		int offset = (page - 1) * pageSize;
		return adminDataService.getWithdrawalData(fromDate, toDate, status,searchBy, offset,pageSize);
	}
	
	@GetMapping("/withdrawalcnt")
	public int getWithdrawalCount(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,  
    		@RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) String searchBy
			, HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return 0;
	    }
		return adminDataService.countWithdrawals(fromDate, toDate, status,searchBy);
	}
	
	@GetMapping("/users")
	public List<Map<String,Object>> getUsersData(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,  
    		@RequestParam(required = false) String searchBy,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate
			, HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return Collections.emptyList();
	    }
		return adminDataService.getUsersData(fromDate, toDate, searchBy);
	}
	
	@PostMapping("/saveDetails")
	public ResponseEntity<?> saveUserBankDetails(
			@RequestBody Map<String,Object> formData , 
			HttpServletResponse httpResponse) {
		if (!authService.validateSession(constructLoginFormData(formData))){	      
	        Map<String, Object> errorBody = new HashMap<>();
	        errorBody.put("error", "INVALID_SESSION");
	        errorBody.put("message", "Session expired. Please log in again.");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody);
	    }
		String result =  adminDataService.saveUserBankDetails(formData);
		Map<String, String> response = new HashMap<>();
        response.put("message", result);
        return ResponseEntity.ok(response);
	}
	
	@PostMapping("/chngpwd")
	public ResponseEntity<?> updateUserPassword(@RequestBody Map<String,Object> formData , HttpServletResponse httpResponse) {
		if (!authService.validateSession(constructLoginFormData(formData))) {	      
	        Map<String, Object> errorBody = new HashMap<>();
	        errorBody.put("error", "INVALID_SESSION");
	        errorBody.put("message", "Session expired. Please log in again.");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody);
	    }
		String result =  adminDataService.updateUserPassword(formData);
		Map<String, String> response = new HashMap<>();
        response.put("message", result);
        return ResponseEntity.ok(response);
	}
	
	@PostMapping("/addFunds")
	public ResponseEntity<?> addFunds(@RequestBody Map<String,Object> formData, HttpServletResponse httpResponse) {
		if (!authService.validateSession(constructLoginFormData(formData))) {	      
	        Map<String, Object> errorBody = new HashMap<>();
	        errorBody.put("error", "INVALID_SESSION");
	        errorBody.put("message", "Session expired. Please log in again.");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody);
	    }
		Map<String, Object> response =  adminDataService.addFunds(formData);
        return ResponseEntity.ok(response);
	}
	
	@PostMapping("/purchase")
	public ResponseEntity<?> purchasePkg(@RequestBody Map<String,Object> formData , HttpServletResponse httpResponse) {
		if (!authService.validateSession(constructLoginFormData(formData))) {	      
	        Map<String, Object> errorBody = new HashMap<>();
	        errorBody.put("error", "INVALID_SESSION");
	        errorBody.put("message", "Session expired. Please log in again.");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody);
	    }
		Map<String, Object> response =  adminDataService.purchasePackage(formData);
        return ResponseEntity.ok(response);
	}
	
	@PostMapping("/upload")
    public ResponseEntity<?> uploadQRCode(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,  
    		@RequestParam("file") MultipartFile file, 
            @RequestParam("data") String data
            , HttpServletResponse httpResponse) {
        try {
        	if (!authService.validateSession(sid,pid)) {	      
    	        Map<String, Object> errorBody = new HashMap<>();
    	        errorBody.put("error", "INVALID_SESSION");
    	        errorBody.put("message", "Session expired. Please log in again.");
    	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody);
    	    }
            QrCode savedQRCode = qrCodeService.storeFile(file, data);
            return ResponseEntity.ok("File uploaded successfully with ID: " + savedQRCode.getId());
        } catch (IOException e) {
            return ResponseEntity.ok("Failed to updload: ");
        }
    }
	
	@GetMapping("/gtFls")
    public ResponseEntity<List<Map<String, Object>>> getAllFiles() {
		List<QrCode> files = qrCodeService.getAllFiles();

		List<Map<String, Object>> result = files.stream().map(file -> {
	        Map<String, Object> fileMap = new HashMap<>();
	        fileMap.put("id", file.getId());
	        fileMap.put("filename", file.getFilename());

	        // Detect MIME type
	        String mimeType = URLConnection.guessContentTypeFromName(file.getFilename());
	        if (mimeType == null) {
	            mimeType = "application/octet-stream"; // Fallback
	        }
	        fileMap.put("type", mimeType);

	        // Convert to base64
	        String base64 = Base64.getEncoder().encodeToString(file.getFileData());
	        String dataUrl = "data:" + mimeType + ";base64," + base64;
	        fileMap.put("content", dataUrl);

	        return fileMap;
	    }).collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }
	
	@DeleteMapping("/dltFl")
    public ResponseEntity<?> deleteFile(@RequestBody Map<String, Object> request) {
		if (!authService.validateSession(constructLoginFormData(request))) {	      
		    Map<String, Object> errorBody = new HashMap<>();
		    errorBody.put("error", "INVALID_SESSION");
		    errorBody.put("message", "Session expired. Please log in again.");
		    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody);
		}
		Long id = Long.valueOf(request.get("id").toString());
		Map<String, Object> response = qrCodeService.deleteById(id);
		return ResponseEntity.ok(response);
    }
	
	@PostMapping("/hdlwdw")
    public ResponseEntity<?> handleWithdrwalStatus(@RequestBody Map<String, Object> request, HttpServletResponse httpResponse) {
		if (!authService.validateSession(constructLoginFormData(request))) {	      
	        Map<String, Object> errorBody = new HashMap<>();
	        errorBody.put("error", "INVALID_SESSION");
	        errorBody.put("message", "Session expired. Please log in again.");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody);
	    }
		String result = "-1";
		try {
			String type=request.get("type").toString();
			List<Map<String, String>> transactions = (List<Map<String, String>>) request.get("transactions");
			for (Map<String, String> txn : transactions) {
		        String transId = txn.get("transId");
		        String custId = txn.get("custId");
		        result =  adminDataService.handleWDWStatus(transId,type ,custId);
		    }
		}catch(Exception ex) {
			System.out.println("exception occured while updating withdrawal status");
			result= "-1";
		}
		Map<String, String> response = new HashMap<>();
        response.put("message", result);
        return ResponseEntity.ok(response);
    }
	
	@PostMapping("/admlogin")
    public ResponseEntity<?> checkLogin(@RequestBody Map<String, Object> request,HttpServletRequest httpRequest) {
		String username = (String) request.get("username");
        String password = (String) request.get("password");
        String ipAddress = (String) request.get("ipAddress");
        String browserInfo = (String) request.get("browserInfo");
		Map<String, String> resultMap = authService.loginUser(username, password, ipAddress, browserInfo, httpRequest,"ADMIN");
        return ResponseEntity.ok(resultMap);
    }
	
	@GetMapping("/usrdshbrd")
    public Map<String, DashboardDetails> userDashboard(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid, 
    		@RequestParam(required = true) String custId, 
    		HttpServletResponse httpResponse) {
		if (!authService.validateSession(sid,pid)) {
	        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
	        return Collections.emptyMap();
	    }
		Map<String, DashboardDetails> userDashboardDetails= adminDataService.getUserDashboardDetails(custId);
		return userDashboardDetails;
    }
	@GetMapping("/totTm")
    public List<TotalTeamDTO> getTotalTeamList(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
    		@RequestParam(required = true) String cid
    		,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
    	List<TotalTeamDTO> totalTeamData = null;
    	if (authService.validateSession(sid,pid)) {
        	totalTeamData = adminDataService.getTotalTeamByAncestorId(cid);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return Collections.emptyList();
        }
        return totalTeamData; // transactions.jsp
    } 
    
    @GetMapping("/orgcht")
    public EnhancedTreeNode getEnhancedTree(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
    		@RequestParam(required = true) String cid
    		, HttpServletResponse  httpResponse) {
    	EnhancedTreeNode root = null;
    	if (authService.validateSession(sid,pid)) {
        	root  =  adminDataService.getEnhancedTree(cid);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return new EnhancedTreeNode();
        }
        return root;
    }
    @GetMapping("/lvldl")
    public List<Map<String, Object>> getDownlineData(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
    		@RequestParam(required = true) String cid,
    		HttpServletResponse httpResponse){
    	List<Map<String,Object>> levelDownLineData = new ArrayList<Map<String,Object>>();
        if (authService.validateSession(sid,pid)) {
        	levelDownLineData = adminDataService.getDownlineData(cid);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return Collections.emptyList();
        }
    	return levelDownLineData;
    }
    @GetMapping("/actvusrs")
    public List<Map<String, Object>> getAllActiveUsers(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
    		@RequestParam(required = true) String cid,
    		HttpServletResponse httpResponse){
    	List<Map<String,Object>> actvUsersData = new ArrayList<Map<String,Object>>();
    	System.out.println("sid="+sid+", pid="+pid+", cid="+cid);
        if (authService.validateSession(sid,pid)) {
        	System.out.println("Valid session and calling getActvUsers");
        	actvUsersData = adminDataService.getActvUsers(cid);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return Collections.emptyList();
        }
    	return actvUsersData;
    }
	private Map<String, String> constructLoginFormData(Map<String,Object> formData) {
		Map<String,String> loginData =  new HashMap<>();
		loginData.put("sid", (String)formData.get("sid"));
		loginData.put("pid", (String)formData.get("pid"));
		return loginData;
	}
	
	@GetMapping("/encpwd")
    public String encryptPassword(@RequestParam(defaultValue = "User@123") String password) {
        return adminDataService.generateCommonPassword(password);
    }
	
}
