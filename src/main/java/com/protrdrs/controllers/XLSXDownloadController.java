package com.protrdrs.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.protrdrs.service.AdminDataService;
import com.protrdrs.service.AuthService;
import com.protrdrs.util.ExcelExportUtil;

@RestController
@RequestMapping("/dwnldxlsx")
public class XLSXDownloadController {
	@Autowired
	AdminDataService adminDataService;
	@Autowired
	ExcelExportUtil excelExportUtil;
	@Autowired
	AuthService authService;
    
    @GetMapping("/withdrawal.xlsx")
    public ResponseEntity<byte[]> downloadWithdrawalXls(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String searchBy) {
    	
    	 if (!authService.validateSession(sid, pid)) {
	        return ResponseEntity
	                .status(HttpStatus.UNAUTHORIZED)
	                .body(null); // or an empty byte array: new byte[0]
	    }

        List<Map<String, Object>> data = adminDataService.getWithdrawalData(from, to, status,searchBy,-1,0);
        byte[] pdf = excelExportUtil.exportToExcel(data,"Withdrawal");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"WithdrawalsReport.xlsx\"")
                .body(pdf);
    }
    
    @GetMapping("/fundTransfer.xlsx")
    public ResponseEntity<byte[]> downloadFundTransferXls(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to,
            @RequestParam(required = false) String status) {
    	
    	 if (!authService.validateSession(sid, pid)) {
    	        return ResponseEntity
    	                .status(HttpStatus.UNAUTHORIZED)
    	                .body(null); // or an empty byte array: new byte[0]
    	    }

        List<Map<String, Object>> data = adminDataService.getFundTransferData(from, to, status,-1,0);
        byte[] pdf = excelExportUtil.exportToExcel(data,"Fundtransfers");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"FundtransfersReport.xlsx\"")
                .body(pdf);
    }
    
    @GetMapping("/topup.xlsx")
    public ResponseEntity<byte[]> downloadTopupsXls(
    		@RequestParam(required = true) String sid,
    		@RequestParam(required = true) String pid,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String packageId) {
    	
    	 if (!authService.validateSession(sid, pid)) {
    	        return ResponseEntity
    	                .status(HttpStatus.UNAUTHORIZED)
    	                .body(null); // or an empty byte array: new byte[0]
    	 }
    	 
    	 List<Map<String, Object>> data = adminDataService.getTopupDataForPDF(from, to, status, packageId);
    	 byte[] pdf = excelExportUtil.exportToExcel(data,"Topups");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"TopupReport.xlsx\"")
                .body(pdf);
    }
}
