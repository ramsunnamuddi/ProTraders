package com.protrdrs.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.protrdrs.service.AdminDataService;
import com.protrdrs.service.AuthService;
import com.protrdrs.util.PdfExportUtil;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/dwnldpdf")
public class PDFDownloadController {
	@Autowired
	AdminDataService adminDataService;
	@Autowired
	PdfExportUtil pdfExportUtil;
	@Autowired
	AuthService authService;
    @GetMapping("/pdf")
    public ResponseEntity<Resource> downloadPdf() throws IOException {
        ClassPathResource pdfFile = new ClassPathResource("pdfs/ProTrader_Voucher.pdf");

        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=ProTrader_Voucher.pdf");

        return ResponseEntity.ok()
                .headers(headers)
                .contentLength(pdfFile.contentLength())
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfFile);
    }
    
    @GetMapping("/withdrawal.pdf")
    public ResponseEntity<byte[]> downloadWithdrawalPdf(
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
        byte[] pdf = pdfExportUtil.buildWithdrawalReport(data,"Withdrawal");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"WithdrawalsReport.pdf\"")
                .body(pdf);
    }
    
    @GetMapping("/fundTransfer.pdf")
    public ResponseEntity<byte[]> downloadFundTransferPdf(
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
        byte[] pdf = pdfExportUtil.buildWithdrawalReport(data,"Fundtransfers");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"FundtransfersReport.pdf\"")
                .body(pdf);
    }
    
    @GetMapping("/topup.pdf")
    public ResponseEntity<byte[]> downloadTopupsPdf(
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
    	 byte[] pdf = pdfExportUtil.buildWithdrawalReport(data,"Topups");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"TopupReport.pdf\"")
                .body(pdf);
    }
}

