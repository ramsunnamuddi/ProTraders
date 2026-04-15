package com.protrdrs.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

import com.protrdrs.model.BinaryBonusResponseDTO;
import com.protrdrs.model.BinaryBonusResultDTO;
import com.protrdrs.model.EnhancedTreeNode;
import com.protrdrs.model.FundRequestDto;
import com.protrdrs.model.QrCode;
import com.protrdrs.model.TotalTeamDTO;
import com.protrdrs.service.AdminDataService;
import com.protrdrs.service.AuthService;
import com.protrdrs.service.QrCodeService;
import com.protrdrs.service.TransactionService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/txn")
public class TransactionController {
	@Autowired
    private TransactionService transactionService;
	@Autowired
	private QrCodeService qrCodeService;
	@Autowired
	private AdminDataService adminDataService;
	
	@Autowired
    private AuthService authService;
	
    @GetMapping("/withdrawal")
    public List<Object[]> getWdwTransactions(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false, defaultValue = "1") int page
			,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
        List<Object[]> withdrawals = null;
        if (authService.validateSession(sid,pid)) {
        	int pageSize = 5;
        	Long userId =  Long.valueOf(pid);
        	int offset = (page - 1) * pageSize;
			withdrawals = transactionService.getFilteredWithdrawals(userId, status, fromDate, toDate, "DESC",offset, pageSize);
		}else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
        	return Collections.emptyList();
        }
        return withdrawals;
    }
    
    @GetMapping("/withdrawalcnt")
    public int getWdwTransactionsCount(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false, defaultValue = "1") int page
			,HttpServletResponse httpResponse) {
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	return transactionService.countWithdrawals(userId, status,fromDate, toDate, "");
		}else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
        	
        }
        return 0;
    }
    @GetMapping("/fundTransfer")
    public Map<String, Object> getFundRequestTransactions(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false, defaultValue = "1") int page
            ,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
    	List<Object[]> fundRequests = null;
    	Map<String, Object> resultMap =  new HashMap<>();
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	int pageSize = 5;
        	int offset = (page - 1) * pageSize;
        	fundRequests = transactionService.getFilteredFundRequests(userId, status, fromDate, toDate, "DESC", offset, pageSize);
        	resultMap.put("data", fundRequests);
            Optional<QrCode> qrCodeOptional = qrCodeService.getFile();
            if (qrCodeOptional.isPresent()) {
                QrCode qrCode = qrCodeOptional.get();
                
                // Ensure you are encoding only the file data, not the entire object
                String base64Image = Base64.getEncoder().encodeToString(qrCode.getFileData());
                
                resultMap.put("QRCD", "data:image/png;base64," + base64Image);
            }
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
        	return Collections.emptyMap();
        }
        return resultMap;
    }
    
    @GetMapping("/fundTransfercnt")
    public int getFundTransferCount(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false, defaultValue = "1") int page
			,HttpServletResponse httpResponse) {
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	return transactionService.countFundRequests(userId, status,fromDate, toDate);
		}else  httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return 0;
    }
    
    @GetMapping("/topup")
    public List<Object[]>  getTopUpTransactions(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) String packageId,
            @RequestParam(required = false, defaultValue = "1") int page
            ,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
        List<Object[]> topUps = null;
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	int pageSize = 5;
        	int offset = (page - 1) * pageSize;
    	 	topUps = transactionService.getFilteredTopUps(userId, status, fromDate, toDate,packageId, "DESC",offset, pageSize);
		}else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
        	return Collections.emptyList();
        }
        return topUps; 
    }

    @GetMapping("/topupcnt")
    public int getTopupCount(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate,
            @RequestParam(required = false) String packageId,
            @RequestParam(required = false, defaultValue = "1") int page
			,HttpServletResponse httpResponse) {
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	return transactionService.countTopups(userId, status,fromDate, toDate,packageId);
		}else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
        	
        }
        return 0;
    }
    
    
    @PostMapping("/purchase")
    public ResponseEntity<Map<String, Object>> purchasePackage(
    		@RequestBody Map<String,Object> formData,
            @RequestParam(required = false, defaultValue = "1") int page
    		) {
    	String sessionId = (String) formData.get("sid");
    	String peopleId=(String) formData.get("pid");
    	String amount = (String) formData.get("amount");
    	Map<String, Object> response = new HashMap<>();
        if (authService.validateSession(sessionId,peopleId)) {
            Long userId =  Long.valueOf(peopleId);
	        String transactonId = transactionService.handleTransaction("TOPUP", Double.parseDouble(amount),userId);
	        if(transactonId!=null) {
	        	response.put("errorCode", "0");  // No error
	            response.put("message", "Your purchage is successfull and the transaction id is:"+transactonId);
	            response.put("balance", transactionService.getAvailableBalance(userId)); 
	            response.put("pkgs",adminDataService.getPackages());
	        	int pageSize = 5;
	        	int offset = (page - 1) * pageSize;
	            response.put("tpups", transactionService.getFilteredTopUps(userId, "", "", "","", "DESC",offset, pageSize));
	        }else {
	        	response.put("errorCode", "-1");  // No error
	            response.put("message", "Purchase unsuccessful");
	        }
	        return ResponseEntity.ok(response);
        }else {
        	response.put("errorCode", "BAD_REQ");
        	response.put("message", "Not a valid Session");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
    }
    
    @GetMapping("/balance")
    public ResponseEntity<Object> getAvailableBalance(HttpServletRequest httpRequest) {
    	HttpSession session = httpRequest.getSession(false);
        if (session != null) {
        	String peopleId = (String) session.getAttribute("PEOPLE_ID");
        	Long userId =  Long.valueOf(peopleId);
        	Double balance = transactionService.getAvailableBalance(userId);
            return ResponseEntity.ok(balance);
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("We are unable to fethc the balance");
       
    }
    
    @GetMapping("/roibns")
    public Map<String, List<Object[]>> getROIBonusTransactions(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String fromDate,
            @RequestParam(required = false) String toDate
            ,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
    	Map<String, List<Object[]>> roiBonnusData = new HashMap<>();
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	roiBonnusData = transactionService.getFilteredROIBonus(userId, status, fromDate, toDate, "DESC");
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return Collections.emptyMap();
        }
        return roiBonnusData; // transactions.jsp
    }
    
    @GetMapping("/bnrybns")
    public BinaryBonusResponseDTO  getBinaryBonusTransactions(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid
    		,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
    	BinaryBonusResponseDTO binaryBonusDt = null;
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	binaryBonusDt = transactionService.getBinaryBonusWithCustomerId(userId);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return new BinaryBonusResponseDTO();
        }
        return binaryBonusDt; // transactions.jsp
    }
    @GetMapping("/drctbns")
    public List<BinaryBonusResultDTO> getDirectBonusTransactions(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid
    		,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
    	List<BinaryBonusResultDTO> binaryBonusDt = null;
    	if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	binaryBonusDt = transactionService.getDirectBonusWithCustomerId(userId);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return Collections.emptyList();
        }
        return binaryBonusDt; // transactions.jsp
    }
    
    @GetMapping("/totTm")
    public List<TotalTeamDTO> getTotalTeamList(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid
    		,HttpServletResponse httpResponse) {

        // If fromDate or toDate is not provided, pass null to the service (query will ignore them)
    	List<TotalTeamDTO> totalTeamData = null;
    	if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	totalTeamData = transactionService.getTotalTeamByAncestorId(userId);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return Collections.emptyList();
        }
        return totalTeamData; // transactions.jsp
    } 
    
    @GetMapping("/orgcht")
    public EnhancedTreeNode getEnhancedTree(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid
    		, HttpServletResponse  httpResponse) {
    	EnhancedTreeNode root = null;
    	if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	root  =  transactionService.getEnhancedTree(userId);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return new EnhancedTreeNode();
        }
        return root;
    }
    
    @PostMapping("/wdwAmt")
    public ResponseEntity<Map<String, Object>> withdrawalAmount(@RequestBody Map<String, Object> request) {
    	String sessionId = (String) request.get("sid");
    	String peopleId=(String) request.get("pid");
    	Map<String, Object> response = new HashMap<>();
    	if (authService.validateSession(sessionId,peopleId)) {
        	Long userId =  Long.valueOf(peopleId);
	        String transactonId = transactionService.handleTransaction(
	        			"WITHDRAWAL", 
	        			Double.parseDouble(request.get("amount").toString()),
	        			userId,
	        			request.get("topupId").toString()
	        		);
	        if(transactonId!=null) {
	        	response.put("errorCode", "0");  // No error
	            response.put("message", "Your withdrawal has been submitted with "+transactonId);
	        }else {
	        	response.put("errorCode", "-1");  // No error
	            response.put("message", "Sorry, We can't process your withdrawal, please try again");
	        }
	        return ResponseEntity.ok(response);
        }else {
        	response.put("errorCode", "BAD_REQ");
        	response.put("message", "Not a valid Session");
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
    
    @GetMapping("/lvldl")
    public List<Map<String, Object>> getDownlineData(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
    		HttpServletResponse httpResponse){
    	List<Map<String,Object>> levelDownLineData = new ArrayList<Map<String,Object>>();
        if (authService.validateSession(sid,pid)) {
        	Long userId =  Long.valueOf(pid);
        	levelDownLineData = transactionService.getDownlineData(userId);
        }else {
        	httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return Collections.emptyList();
        }
    	return levelDownLineData;
    }
    
    @PostMapping("/wdwBnryAmt")
    public ResponseEntity<Map<String, Object>> withdrawalBinaryAmount(@RequestBody Map<String, Object> request) {
    	String sessionId = (String) request.get("sid");
    	String peopleId=(String) request.get("pid");
    	Map<String, Object> response = new HashMap<>();
    	if (authService.validateSession(sessionId,peopleId)) {
        	Long userId =  Long.valueOf(peopleId);
	        String transactonId = transactionService.handleTransaction("BINARY", Double.parseDouble(request.get("amount").toString()),userId);
	        if(transactonId!=null) {
	        	response.put("errorCode", "0");  // No error
	            response.put("message", "Your withdrawal has been submitted with "+transactonId);
	        }else {
	        	response.put("errorCode", "-1");  // No error
	            response.put("message", "Sorry, We can't process your withdrawal, please try again");
	        }
	        return ResponseEntity.ok(response);
        }else {
        	response.put("errorCode", "BAD_REQ");
        	response.put("message", "Not a valid Session");
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
    @GetMapping("/totwdw")
    public ResponseEntity<Double> getTotalWithdrawals(
            @RequestParam(required = true) String sid,
            @RequestParam(required = true) String pid,
            @RequestParam(required = true) String topupId,
            HttpServletResponse httpResponse) {

        if (authService.validateSession(sid, pid)) {
            Long userId = Long.valueOf(pid);
            Double totalWithdrawn = transactionService.getTotalWithdrawals(userId, topupId);
            return ResponseEntity.ok(totalWithdrawn);
        } else {
            httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return ResponseEntity.status(HttpServletResponse.SC_UNAUTHORIZED).body(0.0);
        }
    }
    
}

