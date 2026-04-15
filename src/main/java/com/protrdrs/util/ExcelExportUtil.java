package com.protrdrs.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;
import java.util.*;

@Component
public class ExcelExportUtil {

	private static final Map<String, Map<String, String>> SHEET_COLUMN_HEADERS = new LinkedHashMap<>();
	static {
	    Map<String, String> withdrawalMap = new LinkedHashMap<>();
	    withdrawalMap.put("txnId", "Request ID");
	    withdrawalMap.put("custId", "User");
	    withdrawalMap.put("pkg", "Package");
	    withdrawalMap.put("intAmt", "Interest Amount");
	    withdrawalMap.put("txnAmt", "Withdrawan Amount");
	    withdrawalMap.put("txnSts", "Status");
	    withdrawalMap.put("txnDtTime", "Request Date");
	    withdrawalMap.put("bAccno", "Account Number");
	    withdrawalMap.put("bAcctHldrNm", "Account Holder Name");
	    withdrawalMap.put("bname", "Bank Name");
	    withdrawalMap.put("bAcctbrch", "Branch Name");
	    withdrawalMap.put("bifscCode", "IFSC Code");

	    Map<String, String> fundTransferMap = new LinkedHashMap<>();
	    fundTransferMap.put("txnId", "Transaction ID");
	    fundTransferMap.put("custId", "User");
	    fundTransferMap.put("txnAmt", "Amount");
	    fundTransferMap.put("txnSts", "Status");
	    fundTransferMap.put("txnDtTime", "Date/Time");

	    Map<String, String> topupMap = new LinkedHashMap<>();
	    topupMap.put("txnId", "Transaction ID");
	    topupMap.put("custId", "User");
	    topupMap.put("txnAmt", "Amount");
	    topupMap.put("txnSts", "Status");
	    topupMap.put("txnDtTime", "Date/Time");
	    topupMap.put("expDt", "Expiry Date");

	    SHEET_COLUMN_HEADERS.put("withdrawal", withdrawalMap);
	    SHEET_COLUMN_HEADERS.put("fundtransfers", fundTransferMap);
	    SHEET_COLUMN_HEADERS.put("topups", topupMap);
	}

    public byte[] exportToExcel(List<Map<String, Object>> dataList, String sheetName) {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet(sheetName);

            Map<String, String> headers = SHEET_COLUMN_HEADERS.get(sheetName.toLowerCase());
            if (headers == null) {
                throw new IllegalArgumentException("Unsupported sheet name: " + sheetName);
            }

            List<String> columnKeys = new ArrayList<>(headers.keySet());

            // Header row
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < columnKeys.size(); i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers.get(columnKeys.get(i)));
            }

            // Data rows
            int rowIdx = 1;
            for (Map<String, Object> rowMap : dataList) {
                if (!rowMap.keySet().containsAll(columnKeys)) {
                    continue; // Skip if row is missing required columns
                }

                Row row = sheet.createRow(rowIdx++);
                for (int colIdx = 0; colIdx < columnKeys.size(); colIdx++) {
                    Object value = rowMap.get(columnKeys.get(colIdx));
                    row.createCell(colIdx).setCellValue(value != null ? value.toString() : "");
                }
            }

            workbook.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
            return new byte[0];
        }
    }
}
