package com.protrdrs.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.protrdrs.model.DashboardDetails;

import java.util.Map;
import java.math.BigDecimal;
import java.text.DecimalFormat;

@Repository
public class DashboardRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public DashboardDetails getDashboardDetails(Long peopleId) {
        String sql = "CALL proc_dashboard_dtls(?)";

        // Execute the procedure and get the result as a Map
        Map<String, Object> result = jdbcTemplate.queryForMap(sql, peopleId);

        // Map the result to the DashboardDetails object
        DashboardDetails details = new DashboardDetails();
        details.setTotalItems(formatNumber(checkIfNull(result.get("total_items"))));
        details.setTotalDeposits(formatNumber(checkIfNull(result.get("total_deposits"))));
        details.setActiveDirects(checkIfNullInt(result.get("active_directs")));
        details.setLeftBusiness(formatNumber(checkIfNull(result.get("left_business"))));
        details.setRightBusiness(formatNumber(checkIfNull(result.get("right_business"))));
        details.setBinaryBonus(formatNumber(checkIfNull(result.get("binary_bonus"))));
        details.setLeftBonus(formatNumber(checkIfNull(result.get("left_bonus"))));
        details.setRightBonus(formatNumber(checkIfNull(result.get("right_bonus"))));
        details.setTotalRoiBonus(formatNumber(checkIfNull(result.get("roi_bonus"))));
        details.setAvailableBalance(formatNumber(checkIfNull(result.get("available_balance"))));
        details.setTotalWithdrawals(formatNumber(checkIfNull(result.get("total_withdrawals"))));
        details.setLeftReferralLink(checkIfNullStr(result.get("left_ref_link")));
        details.setRightReferralLink(checkIfNullStr(result.get("right_ref_link")));

        return details;
    }
    
    private Double checkIfNull(Object objValue){
		Double value = null;		
		if (objValue != null) {
			 if (objValue instanceof BigDecimal) value = ((BigDecimal) objValue).doubleValue();
			 else if (objValue instanceof Double)  value = (Double) objValue;
		}else value = 0.0; // or any other default value you need		
		return value;
	}
    
    private String checkIfNullStr(Object objValue){
		String value = null;
		if (objValue != null) {
			if (objValue instanceof String) value = ((String) objValue);
		}else value = ""; // or any other default value you need		
		return value;
	}
	
	private Integer checkIfNullInt(Object objValue){
		Integer value = null;
		if (objValue != null) {
			 if (objValue instanceof BigDecimal) value = ((BigDecimal) objValue).intValue();
			 else if (objValue instanceof Integer)  value = (Integer) objValue;
		}else value = 0; // or any other default value you need
		return value;
	}
	
	private String formatNumber(Double objvalue){
		if(objvalue==0.0) return "0.00";
		DecimalFormat decimalFormat = new DecimalFormat("#,###,###,###.00");
		String formattedNumber = decimalFormat.format(objvalue);
		return formattedNumber;
	}
}
