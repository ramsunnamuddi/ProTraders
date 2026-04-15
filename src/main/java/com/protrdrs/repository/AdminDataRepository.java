package com.protrdrs.repository;

import org.springframework.stereotype.Repository;

import com.protrdrs.util.CommonUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.List;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;

@Repository
public class AdminDataRepository {
	@Autowired
    private JdbcTemplate jdbcTemplate;
	@Autowired
    private PasswordEncoder passwordEncoder;

    // Get today's and week's registered users
    public Map<String, Integer> getUserRegistrationStats() {
        String sql = "SELECT COUNT(CASE WHEN DATE(created_dt) = CURDATE() THEN 1 END) AS today_registered, COUNT(CASE WHEN created_dt >= CURDATE() - INTERVAL 7 DAY THEN 1 END) AS week_registered FROM users";
        return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
            Map<String, Integer> stats = new HashMap<>();
            stats.put("today_registered", rs.getInt("today_registered"));
            stats.put("week_registered", rs.getInt("week_registered"));
            return stats;
        });
    }

    // Get total active top-up amount
    public Double getTotalActiveTopup() {
        String sql = "SELECT SUM(topup_package) FROM topup WHERE DATE_ADD(topup_date_time, INTERVAL 120 DAY) >= CURDATE()";
        return jdbcTemplate.queryForObject(sql, Double.class);
    }
    
    public Double getTodayTopups(){
    	String sql = "select COALESCE(sum(topup_package), 0) from topup where DATE(topup_date_time) = CURDATE()";
        return jdbcTemplate.queryForObject(sql, Double.class);
    }
    
    public Double getTodayWithdrawals(){
    	String sql = "select COALESCE(sum(withdrawal_amount), 0) from withdrawal_history where DATE(withdrawal_date_time) = CURDATE() and withdrawal_status='Approved'";
        return jdbcTemplate.queryForObject(sql, Double.class);
    }
    
    public Double getTotalWithdrawals() {
    	String sql = "select COALESCE(sum(withdrawal_amount), 0) from withdrawal_history where withdrawal_status='Approved'";
    	return jdbcTemplate.queryForObject(sql, Double.class);
    }
    // Get pending withdrawals count
    public Integer getPendingWithdrawals() {
        String sql = "SELECT COUNT(*) FROM withdrawal_history WHERE withdrawal_status = 'PENDING'";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    // Get user registrations for the past 7 days
    public List<Map<String, Object>> getUserRegistrationsChart() {
        String sql = """
            SELECT DATE(created_dt) AS reg_date, COUNT(*) AS user_count 
            FROM users 
            WHERE created_dt >= CURDATE() - INTERVAL 7 DAY 
            GROUP BY DATE(created_dt) 
            ORDER BY reg_date DESC
        """;
        return jdbcTemplate.queryForList(sql);
    }
    
    public List<Map<String, Object>> getActvUsersData(Long peopleId){
    	List<Object> params = new ArrayList<>();
        List<String> whereClauses = new ArrayList<>();

        String sql = "SELECT t.people_id,u.customer_id,u.full_name,t.topup_package,DATE_FORMAT(t.topup_date_time, '%d %b %Y %H:%i:%s') AS topup_date_time,DATE_FORMAT(t.topup_exp_date, '%d %b %Y %H:%i:%s') AS topup_exp_date FROM topup t INNER JOIN users u ON t.people_Id = u.people_Id";

        if (peopleId != null) {
            whereClauses.add("t.people_id=?");
            params.add(peopleId);
        }
    	
        if (!whereClauses.isEmpty()) {
            sql += " AND " + String.join(" AND ", whereClauses);
        }
        sql += " order by t.people_id asc, topup_date_time desc  ";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
        Map<String, Object> stats = new LinkedHashMap<>();
	        stats.put("custId", rs.getString("customer_id"));  // Convert decimal to String
	        stats.put("customerName", rs.getString("full_name"));
	        stats.put("pkg", formatData(rs.getString("topup_package")));
	        stats.put("tpdt", rs.getString("topup_date_time"));
	        stats.put("expdt", rs.getString("topup_exp_date"));
	        return stats;
	    }, params.toArray());
    }

    // Get active top-up package count (for pie chart)
    public List<Map<String, Object>> getActiveTopupPackages() {
        String sql = """
            SELECT topup_package AS pkg_nm, COUNT(*) AS user_count
            FROM topup
            WHERE DATE_ADD(topup_date_time, INTERVAL 120 DAY) >= CURDATE()
            GROUP BY pkg_nm
            ORDER BY user_count DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
        Map<String, Object> stats = new HashMap<>();
	        stats.put("pkg_nm", rs.getString("pkg_nm"));  // Convert decimal to String
	        stats.put("user_count", rs.getInt("user_count"));
	        return stats;
	    });
    }

    // Get latest top-ups
    public List<Map<String, Object>> getLatestTopups() {
        String sql = """
            SELECT topup_package, u.customer_id, DATE_FORMAT(topup_date_time, '%d %b %Y %H:%i:%s') AS date 
            FROM topup tp
            JOIN users u ON tp.people_id = u.people_id
            WHERE DATE_ADD(topup_date_time, INTERVAL 120 DAY) >= CURDATE()
            ORDER BY topup_date_time DESC;
        """;
        return jdbcTemplate.queryForList(sql);
    }

    // Get latest withdrawals
    public List<Map<String, Object>> getLatestWithdrawals() {
        String sql = """
            SELECT withdrawal_amount, DATE_FORMAT(withdrawal_date_time, '%d %b %Y %H:%i:%s') AS withdrawal_date_time, u.customer_id,withdrawal_status
            FROM withdrawal_history wh
            JOIN users u ON wh.people_id = u.people_id
            ORDER BY withdrawal_date_time DESC
        """;
        return jdbcTemplate.queryForList(sql);
    }
    
    // Get latest withdrawals
   public List<Map<String, Object>> getPackages() {
    String sql = """
        SELECT pkg_nm, pkg_amt 
        FROM packages 
        ORDER BY id asc
    """;
	 return jdbcTemplate.query(sql, (rs, rowNum) -> {
        Map<String, Object> stats = new HashMap<>();
	        stats.put("pkg_nm", rs.getString("pkg_nm"));  // Convert decimal to String
	        stats.put("pkg_amt", rs.getString("pkg_amt"));
	        return stats;
	    });
   }
   
   public List<Map<String, Object>> getFundRequestData(String fromDate, String toDate, String status, int offset, int pageSize) {
        List<Object> params = new ArrayList<>();
        List<String> whereClauses = new ArrayList<>();

        String sql = "SELECT f.transaction_id,f.transaction_amount,f.transaction_status,f.fund_request_type,DATE_FORMAT(f.transaction_dt_time, '%d %b %Y %H:%i:%s') AS transaction_dt_time, u.customer_id, u.full_name " +
                     "FROM fund_request_history f " +
                     "JOIN users u ON u.people_id = f.people_id";

        if (fromDate != null && !fromDate.isEmpty()) {
            whereClauses.add("f.transaction_dt_time >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
            params.add(fromDate + " 00:00:00");
        }

        if (toDate != null && !toDate.isEmpty()) {
            whereClauses.add("f.transaction_dt_time <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
            params.add(toDate + " 23:59:59");
        }
        
        if (status != null && !status.isEmpty()) {
            whereClauses.add("f.transaction_status = ?");
            params.add(status);
        }

        if (!whereClauses.isEmpty()) {
            sql += " WHERE " + String.join(" AND ", whereClauses);
        }
        	
        sql += " ORDER BY f.transaction_dt_time DESC  ";
        if(pageSize>0&&offset>-1) {
        	sql += " LIMIT ? OFFSET ?";
        	params.add(pageSize);
      	    params.add(offset);
        }
        
        return jdbcTemplate.query(sql,(rs, rowNum) -> { // Use jdbcTemplate.query()
            Map<String, Object> stats = new HashMap<>();
            stats.put("txnId", rs.getString("transaction_id"));
            stats.put("txnAmt", formatData(rs.getString("transaction_amount")));
            stats.put("txnDtTime", rs.getString("transaction_dt_time"));
            stats.put("txnSts", rs.getString("transaction_status"));
            stats.put("txnTyp", rs.getString("fund_request_type"));
            stats.put("custId", rs.getString("customer_id"));
            stats.put("name", rs.getString("full_name"));
            return stats;
        }, params.toArray());
    }
   
   public List<Map<String, Object>> getTopupDataForPDF(String fromDate, String toDate, String status, String packageId) {
	   List<Object> params = new ArrayList<>();
       List<String> whereClauses = new ArrayList<>();
	   String sql = "SELECT t.topupId,t.topup_package,t.topup_status,DATE_FORMAT(topup_date_time, '%d %b %Y %H:%i:%s') AS topup_date_time ,"+
			   "DATE_FORMAT(topup_exp_date, '%d %b %Y %H:%i:%s') AS topup_exp_date,u.customer_id  "+
			   " FROM topup t, users u where u.people_id=t.people_id"; 
	   if (fromDate != null && !fromDate.isEmpty()) {
           whereClauses.add("t.topup_date_time >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
           params.add(fromDate + " 00:00:00");
       }

       if (toDate != null && !toDate.isEmpty()) {
           whereClauses.add("t.topup_date_time <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
           params.add(toDate + " 23:59:59");
       }
       
       if (packageId != null && !packageId.isEmpty()) {
           whereClauses.add("t.topup_package = ?");
           params.add(packageId.replaceAll(",", ""));
       }
       
       if (status != null && !status.isEmpty()) {
           whereClauses.add("t.topup_status = ?");
           params.add(status);
       }

       if (!whereClauses.isEmpty()) {
           sql += " AND " + String.join(" AND ", whereClauses);
       }
        
    		
       sql += 	" ORDER BY topup_date_time desc ";
      return jdbcTemplate.query(sql, (rs, rowNum) -> {
        Map<String, Object> stats = new HashMap<>();
	        stats.put("txnId", rs.getString("topupId"));  // Convert decimal to String
	        stats.put("txnAmt", formatData(rs.getString("topup_package")));
	        stats.put("txnDtTime", rs.getString("topup_date_time"));
	        stats.put("txnSts", rs.getString("topup_status"));
	        stats.put("custId", rs.getString("customer_id"));
	        stats.put("expDt", rs.getString("topup_exp_date"));
	        return stats;
	    }, params.toArray());
   }
   
   
   public List<Map<String, Object>> getTopupData(String fromDate, String toDate, String status, String packageId, int offset, int pageSize) {
	   List<Object> params = new ArrayList<>();
       List<String> whereClauses = new ArrayList<>();
	   String sql = "SELECT t.topupId,t.topup_package,t.topup_status,DATE_FORMAT(topup_date_time, '%d %b %Y %H:%i:%s') AS topup_date_time ,"+
			   "DATE_FORMAT(topup_exp_date, '%d %b %Y %H:%i:%s') AS topup_exp_date,u.customer_id, u.full_name  "+
			   " FROM topup t, users u where u.people_id=t.people_id"; 
	   if (fromDate != null && !fromDate.isEmpty()) {
           whereClauses.add("t.topup_date_time >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
           params.add(fromDate + " 00:00:00");
       }

       if (toDate != null && !toDate.isEmpty()) {
           whereClauses.add("t.topup_date_time <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
           params.add(toDate + " 23:59:59");
       }
       
       if (packageId != null && !packageId.isEmpty()) {
           whereClauses.add("t.topup_package = ?");
           params.add(packageId.replaceAll(",", ""));
       }
       
       if (status != null && !status.isEmpty()) {
           whereClauses.add("t.topup_status = ?");
           params.add(status);
       }

       if (!whereClauses.isEmpty()) {
           sql += " AND " + String.join(" AND ", whereClauses);
       }
        
    		
       sql += 	" ORDER BY topup_date_time desc ";
       if(pageSize>0&&offset>-1) {
       	sql += " LIMIT ? OFFSET ?";
       		params.add(pageSize);
     	    params.add(offset);
       }
      return jdbcTemplate.query(sql, (rs, rowNum) -> {
        Map<String, Object> stats = new HashMap<>();
	        stats.put("txnId", rs.getString("topupId"));  // Convert decimal to String
	        stats.put("txnAmt", formatData(rs.getString("topup_package")));
	        stats.put("txnDtTime", rs.getString("topup_date_time"));
	        stats.put("txnSts", rs.getString("topup_status"));
	        stats.put("custId", rs.getString("customer_id"));
	        stats.put("expDt", rs.getString("topup_exp_date"));
	        stats.put("name", rs.getString("full_name"));
	        return stats;
	    }, params.toArray());
   }
   
   public List<Map<String, Object>> getPendingWithdrawalsData(String fromDate, String toDate, String status, String searchBy, int offset, int pageSize) {
	   List<Object> params = new ArrayList<>();
	   List<String> whereClauses = new ArrayList<>();

	   String sql = "SELECT wh.withdrawal_id, wh.withdrawal_amount, wh.withdrawal_status, " +
	       "DATE_FORMAT(wh.withdrawal_date_time, '%d %b %Y %H:%i:%s') AS submitted_dt, " +
	       "u.customer_id, IFNULL(wh.topup_id, '-') AS topup_id, " +
	       "IFNULL(t.topup_package, '-') AS topup_package, wh.interest_amount, " +
	       "b.bank_name, b.account_no, b.account_branch, b.account_holder_nm, b.ifsc_code,u.full_name " +
	       "FROM withdrawal_history wh " +
	       "JOIN users u ON u.people_id = wh.people_id " +
	       "LEFT JOIN topup t ON wh.topup_id = t.topupId " +
	       "LEFT JOIN bank_details b ON wh.people_id = b.people_id";

	   // WHERE clause conditions
	   if (fromDate != null && !fromDate.isEmpty()) {
	       whereClauses.add("wh.withdrawal_date_time >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
	       params.add(fromDate + " 00:00:00");
	   }

	   if (toDate != null && !toDate.isEmpty()) {
	       whereClauses.add("wh.withdrawal_date_time <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
	       params.add(toDate + " 23:59:59");
	   }

	   if (status != null && !status.isEmpty()) {
	       whereClauses.add("wh.withdrawal_status = ?");
	       params.add(status);
	   }

	   if (searchBy != null && !searchBy.isEmpty()) {
	       whereClauses.add("(u.customer_id = ? OR u.email = ? OR u.mobile_number = ? OR u.full_name = ? OR t.topup_package = ?)");
	       params.add(searchBy);
	       params.add(searchBy);
	       params.add(searchBy);
	       params.add(searchBy);
	       params.add(searchBy);
	   }

	   // Add WHERE clause if conditions exist
	   if (!whereClauses.isEmpty()) {
	       sql += " WHERE " + String.join(" AND ", whereClauses);
	   }

	   // Ordering
	   sql += " ORDER BY CASE WHEN wh.withdrawal_status = 'Pending' THEN 0 ELSE 1 END, wh.withdrawal_date_time DESC";

	   // Pagination
	   if (pageSize > 0 && offset > -1) {
	       sql += " LIMIT ? OFFSET ?";
	       params.add(pageSize);
	       params.add(offset);
	   }
        AtomicInteger serialNo = new AtomicInteger(offset + 1); 
	    return jdbcTemplate.query(sql, (rs, rowNum) -> {
	       	Map<String, Object> stats = new LinkedHashMap<>();
	       		stats.put("srNo", serialNo.getAndIncrement());
		        stats.put("txnId", rs.getString("withdrawal_id"));  // Convert decimal to String
		        stats.put("txnAmt", formatData(rs.getString("withdrawal_amount")));
		        stats.put("txnDtTime", rs.getString("submitted_dt"));
		        stats.put("txnSts", rs.getString("withdrawal_status"));
		        stats.put("custId", rs.getString("customer_id"));
		        stats.put("topupId", rs.getString("topup_id"));
		        stats.put ("pkg", formatData(rs.getString("topup_package")));
		        stats.put("intAmt", formatData(rs.getString("interest_amount")));
		        stats.put("bAccno", rs.getString("account_no"));
		        stats.put("bAcctHldrNm", rs.getString("account_holder_nm"));	
		        stats.put("bname", rs.getString("bank_name"));
		        stats.put("bAcctbrch", rs.getString("account_branch"));
		        stats.put("bifscCode", rs.getString("ifsc_code"));
		        stats.put("name", rs.getString("full_name"));
		        return stats;
	    	}, params.toArray());
   }
   public int getPendingWithdrawalsCount(String fromDate, String toDate, String status, String searchBy){
	   List<Object> params = new ArrayList<>();
	   List<String> whereClauses = new ArrayList<>();

	   String sql = "SELECT count(*) " +
	       "FROM withdrawal_history wh " +
	       "JOIN users u ON u.people_id = wh.people_id " +
	       "LEFT JOIN topup t ON wh.topup_id = t.topupId " +
	       "LEFT JOIN bank_details b ON wh.people_id = b.people_id";

	   // WHERE clause conditions
	   if (fromDate != null && !fromDate.isEmpty()) {
	       whereClauses.add("wh.withdrawal_date_time >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
	       params.add(fromDate + " 00:00:00");
	   }

	   if (toDate != null && !toDate.isEmpty()) {
	       whereClauses.add("wh.withdrawal_date_time <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
	       params.add(toDate + " 23:59:59");
	   }

	   if (status != null && !status.isEmpty()) {
	       whereClauses.add("wh.withdrawal_status = ?");
	       params.add(status);
	   }

	   if (searchBy != null && !searchBy.isEmpty()) {
	       whereClauses.add("(u.customer_id = ? OR u.email = ? OR u.mobile_number = ? OR u.full_name = ? OR t.topup_package = ?)");
	       params.add(searchBy);
	       params.add(searchBy);
	       params.add(searchBy);
	       params.add(searchBy);
	       params.add(searchBy);
	   }

	   // Add WHERE clause if conditions exist
	   if (!whereClauses.isEmpty())  sql += " WHERE " + String.join(" AND ", whereClauses);
	   // Ordering
	   sql += " ORDER BY CASE WHEN wh.withdrawal_status = 'Pending' THEN 0 ELSE 1 END, wh.withdrawal_date_time DESC";
	   int totalCount = jdbcTemplate.queryForObject(sql, Integer.class, params.toArray());
       return totalCount;
   }
   
   public List<Map<String, Object>> getUsersData(String fromDate, String toDate, String searchBy) {
	   List<Object> params = new ArrayList<>();
       List<String> whereClauses = new ArrayList<>();
       try {
	       String sql = "select customer_id, u.full_name,Email,mobile_number,COALESCE(b.account_no, '-') AS account_no,COALESCE(b.bank_name, '-') AS bank_name,"+
	    			"COALESCE(b.ifsc_code, '-') AS ifsc_code,DATE_FORMAT(created_dt, '%d %b %Y %H:%i:%s') AS created_dt,"+
	    		   " COALESCE(b.account_holder_nm, '-') AS account_holder_nm, COALESCE(b.account_branch, '-') AS account_branch"+
	    			" from users u LEFT JOIN bank_details b ON u.people_id = b.people_id where role='USER' ";
		    if (fromDate != null && !fromDate.isEmpty()) {
		        whereClauses.add("u.created_dt >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
		        params.add(fromDate + " 00:00:00");
		    }
		
		    if (toDate != null && !toDate.isEmpty()) {
		        whereClauses.add("u.created_dt <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
		        params.add(toDate + " 23:59:59");
		    }
	
		    if (searchBy != null && !searchBy.isEmpty()) {
		        whereClauses.add("(u.customer_id = ? or u.email = ? or u.mobile_number = ? or u.full_name = ?)");
		        params.add(searchBy);
		        params.add(searchBy);
		        params.add(searchBy);
		        params.add(searchBy);
		    }    
		    if (!whereClauses.isEmpty()) sql += " AND " + String.join(" AND ", whereClauses);
    
		    sql += " ORDER BY created_dt desc";
			return jdbcTemplate.query(sql, (rs, rowNum) -> {
		        Map<String, Object> stats = new LinkedHashMap<>();
			        stats.put("custId", rs.getString("customer_id"));  // Convert decimal to String
			        stats.put("name", rs.getString("full_name"));
			        stats.put("number", rs.getString("mobile_number"));
			        stats.put("email", rs.getString("email"));
			        stats.put("accountNo", rs.getString("account_no"));
			        stats.put("bankNm", rs.getString("bank_name"));
			        stats.put("ifscCd", rs.getString("ifsc_code"));
			        stats.put("accHldNm", rs.getString("account_holder_nm"));
			        stats.put("brnchNm", rs.getString("account_branch"));
			        stats.put("createdDt", rs.getString("created_dt"));
			        
			        return stats;
			    }, params.toArray());
	   }catch(Exception ex) {	   
		   ex.printStackTrace();
	   }
       return  new ArrayList<Map<String, Object>>();
 }
   
   public List<Map<String, Object>> getTopupPackages() {
        String sql = """
            SELECT topup_package AS pkg_nm, COUNT(*) AS user_count
            FROM topup
            GROUP BY pkg_nm
            ORDER BY user_count DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
        Map<String, Object> stats = new HashMap<>();
	        stats.put("pkg_nm", rs.getString("pkg_nm"));  // Convert decimal to String
	        stats.put("user_count", rs.getInt("user_count"));
	        return stats;
	    });
    }
   
   public Long checkUserExistence(String customerId) {
	   return checkUserExistence(customerId, false);
   }
   
   public Long checkUserExistence(String customerId, boolean checkself) {
	   try {
	   String sql = "SELECT people_id FROM users WHERE customer_id = ? ";
	   if(!checkself) sql += " and role='USER'";
	    return jdbcTemplate.queryForObject(sql, Long.class, customerId);
	   }catch(Exception ex) {
		   return null;
	   }
   }
   
   public Double getAvailableBalance(Long peopleId) {
	   try {
		   String sql = "select available_balance from wallet where people_id=?";
		   return jdbcTemplate.queryForObject(sql, Double.class, peopleId);
	   }catch(Exception ex) {
		   return null;
	   }
   }
   
   public String updateUserPassword(Long userId, Map<String, Object> formData) {
       
       String result = "";
       String newpwd = (String) formData.get("newpwd");
		if(newpwd!=null && newpwd.length()>0){
			String	encodedPwd = getHashedPassword(newpwd);
			int rowsUpdated = jdbcTemplate.update(
	                "UPDATE users SET password_hash = ? WHERE people_id = ?",
	                encodedPwd, userId
	        );
	        result =  (rowsUpdated > 0) ? "0" : "-1";
		}else   result =  "-1";
       
       return result; 
   }
   

   public String  getHashedPassword(String password) {
	    return passwordEncoder.encode(password);
   }
   
   public Integer checkPackageExistence(Double amount) {
	   try {
	   String sql = "select count(*) from packages where pkg_nm=? or pkg_amt=?";
	    return jdbcTemplate.queryForObject(sql, Integer.class, amount, amount);
	   }catch(Exception ex) {
		   return null;
	   }
   }
   
   public Map<String, Object> checkWithdrwalTransactionIdExistence(String transactionId) {
	   try {
	   String sql = "select withdrawal_status,topup_id from withdrawal_history where withdrawal_id=? ";
	    return jdbcTemplate.queryForMap(sql, transactionId);
	   }catch(Exception ex) {
		   return null;
	   }
   }
   
	public String updateWithdrawalTransaction(Long userId, String transactionId, String status, String topupId) {	       
	   String result = "";
	   int rowsUpdated=0;
	   if(transactionId!=null && transactionId.length()>0&&status!=null&&status.length()>0){
			rowsUpdated = jdbcTemplate.update(
	                "UPDATE withdrawal_history SET withdrawal_status = ? WHERE people_id = ? and withdrawal_id=?",
	                status,userId, transactionId);
		    result =  (rowsUpdated > 0) ? "0" : "-1";
	   }else   result =  "-1";
	   
	   return result; 
	}
	
	private String formatData(String value) {
		if(value==null || value.length()==0 || "-".equalsIgnoreCase(value)) return value;
		return CommonUtil.formatNumber(Double.parseDouble(value));
	}
	
	
}
