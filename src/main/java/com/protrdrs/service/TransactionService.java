package com.protrdrs.service;

import org.springframework.stereotype.Service;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;

import jakarta.persistence.Query;

import com.protrdrs.model.BinaryBonusResponseDTO;
import com.protrdrs.model.BinaryBonusResultDTO;
import com.protrdrs.model.EnhancedTreeNode;
import com.protrdrs.model.TotalTeamDTO;
import com.protrdrs.repository.BinaryBonusRepository;
import com.protrdrs.util.CommonUtil;

@Service
public class TransactionService {

	@Autowired
    private EntityManager entityManager;
    @Autowired
    private BinaryBonusRepository binaryBonusRepository;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;
    
    private static final NumberFormat numformatter = new DecimalFormat("##,###,###.00");
    
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy", Locale.ENGLISH);

	public double getAvailableBalance(Long userId){
		double availableAmount = 0.0;
		try{
			String sql = "SELECT available_balance " +
                     "FROM wallet WHERE people_id = :peopleId";
	        Query query = entityManager.createNativeQuery(sql);
	        query.setParameter("peopleId", userId);
	        availableAmount =  Double.parseDouble(""+query.getResultList().get(0));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return  availableAmount;
	}
	
	@Transactional
    public String handleTransaction(String type, Double amount, Long peopleId) {
		return handleTransaction(type, amount, peopleId, "");
	}

    @Transactional
    public String handleTransaction(String type, Double amount, Long peopleId, String topupId) {
		String transactionId = "";
        StoredProcedureQuery query;
        if ("ADD".equalsIgnoreCase(type)) {
            query = entityManager.createStoredProcedureQuery("add_funds")
                    .registerStoredProcedureParameter("p_people_id", Integer.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_transaction_amount", Double.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_transaction_status", String.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("transaction_id", String.class, ParameterMode.OUT)
                    .setParameter("p_people_id", peopleId)
                    .setParameter("p_transaction_amount", amount)
                    .setParameter("p_transaction_status", "SUCCESS");
            		query.execute();
                    transactionId = (String) query.getOutputParameterValue("transaction_id");
                    

        } else if ("TOPUP".equalsIgnoreCase(type)) {
			transactionId = "";
            query = entityManager.createStoredProcedureQuery("topup")
                    .registerStoredProcedureParameter("p_people_id", Integer.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_topup_package", Double.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_topup_status", String.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("topup_id", String.class, ParameterMode.OUT)
                    .setParameter("p_people_id", peopleId)
                    .setParameter("p_topup_package", amount)
                    .setParameter("p_topup_status", "Active");
            		query.execute();
            		transactionId = (String) query.getOutputParameterValue("topup_id");
        } else if ("WITHDRAWAL".equalsIgnoreCase(type)) {
            query = entityManager.createStoredProcedureQuery("add_withdrawals")
                    .registerStoredProcedureParameter("p_people_id", Integer.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_withdrawal_amount", Double.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_topup_id", String.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_wdw_status", String.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("wdw_trans_id", String.class, ParameterMode.OUT)
                    .setParameter("p_people_id", peopleId)
                    .setParameter("p_withdrawal_amount", amount)
                    .setParameter("p_topup_id", topupId)
                    .setParameter("p_wdw_status", "Pending");
            		query.execute();
            		transactionId = (String) query.getOutputParameterValue("wdw_trans_id");
        }else if ("BINARY".equalsIgnoreCase(type)) {
            query = entityManager.createStoredProcedureQuery("add_bnry_withdrawals")
                    .registerStoredProcedureParameter("p_people_id", Integer.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_withdrawal_amount", Double.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("p_wdw_status", String.class, ParameterMode.IN)
                    .registerStoredProcedureParameter("wdw_trans_id", String.class, ParameterMode.OUT)
                    .setParameter("p_people_id", peopleId)
                    .setParameter("p_withdrawal_amount", amount)
                    .setParameter("p_wdw_status", "Pending");
            		query.execute();
            		transactionId = (String) query.getOutputParameterValue("wdw_trans_id");
        } else {
            throw new RuntimeException("Invalid transaction type");
        }

        return transactionId;
    }
    
    @Transactional
    public List<Object[]> getFilteredFundRequests(Long peopleId, String status, String fromDate, String toDate, String orderBy, int offset, int pageSize) {
    	List<Object> params = new ArrayList<>();
        List<String> whereClauses = new ArrayList<>();

        String sql = "SELECT f.transaction_id,f.transaction_amount,f.transaction_status,f.fund_request_type,DATE_FORMAT(f.transaction_dt_time, '%d %b %Y %H:%i:%s') AS transaction_dt_time, u.customer_id " +
                     "FROM fund_request_history f " +
                     "JOIN users u ON u.people_id = f.people_id";
            
        whereClauses.add("f.people_id = ?");
        params.add(peopleId);

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

        sql += " ORDER BY f.transaction_dt_time DESC LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add(offset);

        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
                rs.getString("transaction_id"),
                formatDoubleData(rs.getString("transaction_amount")),
                rs.getString("transaction_status"),
                rs.getString("fund_request_type"),
                rs.getString("transaction_dt_time"),
                rs.getString("customer_id")
            }, params.toArray());
    }
    @Transactional
    public int countFundRequests(Long peopleId, String status, String fromDate, String toDate) {
    	String sql = "SELECT count(*) FROM fund_request_history f JOIN users u ON u.people_id = f.people_id"; 
    	// Initialize parameter map
        MapSqlParameterSource parameters = new MapSqlParameterSource();
        if(peopleId!=null) {
        	sql += " AND f.people_id =:peopleId";
        	parameters.addValue("peopleId", peopleId);
        }
        
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND f.transaction_dt_time >= STR_TO_DATE(:fromDate, '%Y-%m-%d %H:%i:%s')";
            parameters.addValue("fromDate", fromDate + " 00:00:00");
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND f.transaction_dt_time  <= STR_TO_DATE(:toDate, '%Y-%m-%d %H:%i:%s')";
            parameters.addValue("toDate", toDate + " 23:59:59");
        }

        if (status != null && !status.isEmpty()) {
            sql += " AND f.transaction_status = :status";
            parameters.addValue("status", status);
        }
        return namedParameterJdbcTemplate.queryForObject(sql, parameters, Integer.class);
    }
    
    @Transactional
    public List<Object[]> getFilteredTopUps(Long peopleId, String status, String fromDate, String toDate,String pkgId, String orderBy, int offset, int pageSize) {
    	List<Object> params = new ArrayList<>();
        List<String> whereClauses = new ArrayList<>();
 	   String sql = "SELECT t.topupId,t.topup_package,t.topup_status,DATE_FORMAT(topup_date_time, '%d %b %Y %H:%i:%s') AS topup_date_time ,"+
 			   "DATE_FORMAT(topup_exp_date, '%d %b %Y %H:%i:%s') AS topup_exp_date,u.customer_id  "+
 			   "FROM topup t, users u where u.people_id=t.people_id"; 
 	  whereClauses.add("t.people_id = ?");
      params.add(peopleId);
 	   if (fromDate != null && !fromDate.isEmpty()) {
            whereClauses.add("t.topup_date_time >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
            params.add(fromDate + " 00:00:00");
        }

        if (toDate != null && !toDate.isEmpty()) {
            whereClauses.add("t.topup_date_time <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
            params.add(toDate + " 23:59:59");
        }
        
        if (pkgId != null && !pkgId.isEmpty()) {
            whereClauses.add("t.topup_package = ?");
            params.add(pkgId.replaceAll(",", ""));
        }
        
        if (status != null && !status.isEmpty()) {
            whereClauses.add("t.topup_status = ?");
            params.add(status);
        }

        if (!whereClauses.isEmpty()) {
            sql += " AND " + String.join(" AND ", whereClauses);
        }
         
     		
        sql += 	" ORDER BY topup_date_time asc LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add(offset);
 	 return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
             rs.getString("topupId"),
             formatDoubleData(rs.getString("topup_package")),
             rs.getString("topup_status"),
             rs.getString("customer_id"),
             rs.getString("topup_date_time"),
             rs.getString("topup_exp_date")
         }, params.toArray());
    }
    
    @Transactional
    public int countTopups(Long peopleId, String status, String fromDate, String toDate,String pkgId) {
    	String sql = "SELECT count(*) FROM topup t, users u where u.people_id=t.people_id"; 
    	// Initialize parameter map
        MapSqlParameterSource parameters = new MapSqlParameterSource();
        if(peopleId!=null) {
        	sql += " AND t.people_id =:peopleId";
        	parameters.addValue("peopleId", peopleId);
        }
        
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND t.topup_date_time >= STR_TO_DATE(:fromDate, '%Y-%m-%d %H:%i:%s')";
            parameters.addValue("fromDate", fromDate + " 00:00:00");
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND t.topup_date_time  <= STR_TO_DATE(:toDate, '%Y-%m-%d %H:%i:%s')";
            parameters.addValue("toDate", toDate + " 23:59:59");
        }

        if (status != null && !status.isEmpty()) {
            sql += " AND t.topup_status = :status";
            parameters.addValue("status", status);
        }
        
        if (pkgId != null && !pkgId.isEmpty()) {
            sql += " AND t.topup_package = :pkgId";
            parameters.addValue("pkgId", pkgId);
        }
        // Execute the query and fetch the count
        return namedParameterJdbcTemplate.queryForObject(sql, parameters, Integer.class);
    }
    @Transactional
    public List<Object[]> getFilteredWithdrawals(Long peopleId, String status, String fromDate, String toDate, String orderBy, int offset, int pageSize) {
    	List<Object> params = new ArrayList<>();
        List<String> whereClauses = new ArrayList<>();
        String sql = "SELECT wh.withdrawal_id,wh.withdrawal_amount,wh.withdrawal_status,"+
     		" DATE_FORMAT(withdrawal_date_time, '%d %b %Y %H:%i:%s') AS wdw_dt_tm,u.customer_id,IFNULL(CAST(wh.topup_id AS CHAR), '-') AS topup_id, topup_package,interest_amount"+
         " FROM withdrawal_history wh JOIN users u ON u.people_id = wh.people_id LEFT JOIN topup t ON wh.topup_id = t.topupId  where wh.people_id = ?";

        params.add(peopleId);
        
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
 	
 	    if (!whereClauses.isEmpty()) sql += " AND " + String.join(" AND ", whereClauses);
 	    sql += " ORDER BY CASE WHEN wh.withdrawal_status = 'Pending' THEN 0 ELSE 1 END,  wh.withdrawal_date_time DESC  LIMIT ? OFFSET ?";
 	    System.out.println("Sql="+sql);
 	    params.add(pageSize);
 	    params.add(offset);
 	    return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
 	             rs.getString("withdrawal_id"),
 	             formatDoubleData(rs.getString("withdrawal_amount")),
 	             rs.getString("withdrawal_status"),
 	             rs.getString("customer_id"),
 	             rs.getString("wdw_dt_tm"),
 	             rs.getString("topup_id"),
 	            formatDoubleData(rs.getString("topup_package")),
 	            formatDoubleData(rs.getString("interest_amount"))
 	         }, params.toArray());
    }
    
    @Transactional
    public int countWithdrawals(Long peopleId,String status, String fromDate, String toDate, String orderBy) {
        // SQL query
        String sql = "SELECT COUNT(*) FROM withdrawal_history wh, users u, topup t WHERE u.people_id=wh.people_id AND wh.topup_id = t.topupId";
        
        // Initialize parameter map
        MapSqlParameterSource parameters = new MapSqlParameterSource();
        if(peopleId!=null) {
        	sql += " AND wh.people_id =:peopleId";
        	parameters.addValue("peopleId", peopleId);
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND wh.withdrawal_date_time >= STR_TO_DATE(:fromDate, '%Y-%m-%d %H:%i:%s')";
            parameters.addValue("fromDate", fromDate + " 00:00:00");
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND wh.withdrawal_date_time <= STR_TO_DATE(:toDate, '%Y-%m-%d %H:%i:%s')";
            parameters.addValue("toDate", toDate + " 23:59:59");
        }

        if (status != null && !status.isEmpty()) {
            sql += " AND wh.withdrawal_status = :status";
            parameters.addValue("status", status);
        }
        // Execute the query and fetch the count
        return namedParameterJdbcTemplate.queryForObject(sql, parameters, Integer.class);
    }
    
    @Transactional
    public Map<String, List<Object[]>> getFilteredROIBonus(Long peopleId, String status, String fromDate, String toDate, String orderBy) {
    	List<Object> params = new ArrayList<>();
        List<String> whereClauses = new ArrayList<>();
		String sql  =  "SELECT interest_id, parent_topup_id, interest_amt, rb.topup_status,"+
	     		" DATE_FORMAT(upd_dt_time, '%d %b %Y %H:%i:%s') AS upd_dt_time,u.customer_id,tp.topup_status AS topup_status_text "+
	            " FROM roi_bonus rb "+
	            "JOIN users u ON u.people_id = rb.people_id " +
                "JOIN topup tp ON tp.topupId = rb.parent_topup_id ";
		whereClauses.add("rb.people_id = ?");
        params.add(peopleId);
		if (fromDate != null && !fromDate.isEmpty()) {
 	        whereClauses.add("rb.upd_dt_time >= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
 	        params.add(fromDate + " 00:00:00");
 	    }
 	
 	    if (toDate != null && !toDate.isEmpty()) {
 	        whereClauses.add("rb.upd_dt_time <= STR_TO_DATE(?, '%Y-%m-%d %H:%i:%s')");
 	        params.add(toDate + " 23:59:59");
 	    }
 	    
 	    if (status != null && !status.isEmpty()) {
 	        whereClauses.add("rb.topup_status = ?");
 	        params.add(status);
 	    }
 	
 	    if (!whereClauses.isEmpty()) {
 	        sql += " AND " + String.join(" AND ", whereClauses);
 	    }
 	    sql += " ORDER BY parent_topup_id,interest_id, upd_dt_time desc";
 	   List<Object[]> results =  jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
	             rs.getString("interest_id"),
	             rs.getString("parent_topup_id"),
	             rs.getString("interest_amt"),
	             rs.getString("topup_status"),
	             rs.getString("upd_dt_time"),
	             rs.getString("customer_id"),
	             rs.getString("topup_status_text")
	         }, params.toArray());
 	  return results.stream().collect(Collectors.groupingBy(row -> (String) row[1]));
    }
    
     @Transactional
    public List<Object[]> getFilteredDirectBonus(Long peopleId, String status, String fromDate, String toDate, String orderBy) {
		StoredProcedureQuery query = entityManager
                .createStoredProcedureQuery("proc_roibns_his")
                .registerStoredProcedureParameter("p_people_id", Integer.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_status", String.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_from_date", String.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_to_date", String.class, ParameterMode.IN)
                .registerStoredProcedureParameter("p_order_by", String.class, ParameterMode.IN)
                .setParameter("p_people_id", peopleId)
                .setParameter("p_status", (status.length()==0? null : status))
                .setParameter("p_from_date", (fromDate.length()==0? null : fromDate))
                .setParameter("p_to_date", (toDate.length()==0? null : toDate))
                .setParameter("p_order_by", orderBy);

        return query.getResultList();
    }
    
    public BinaryBonusResponseDTO  getBinaryBonusWithCustomerId(Long peopleId) {
    	 List<BinaryBonusResultDTO> results = binaryBonusRepository.findBinaryBonusWithCustomerId(peopleId);
    	  
    	 BigDecimal total = results.stream()
    			    .map(r -> r.getBinaryBonus() != null ? r.getBinaryBonus() : BigDecimal.ZERO)
    			    .reduce(BigDecimal.ZERO, BigDecimal::add);
    	    
    	 BigDecimal withdrawalAmount = getSumOfWithdrawalsWithNullTopupId(peopleId);
    	 BigDecimal amount = total.subtract(withdrawalAmount);
    	 return new BinaryBonusResponseDTO(results, amount);
    }
    
    public List<BinaryBonusResultDTO> getDirectBonusWithCustomerId(Long peopleId) {
        return new ArrayList<BinaryBonusResultDTO>();
    }
    
    
    public List<TotalTeamDTO> getTotalTeamByAncestorId(Long peopleId) {
        return binaryBonusRepository.findTeamByAncestorId(peopleId);
    } 
    
    private BigDecimal getSumOfWithdrawalsWithNullTopupId(Long peopleId) {
    	String sql = "SELECT SUM(interest_amount) FROM withdrawal_history " +
                "WHERE topup_id IS NULL AND people_id = :peopleId and withdrawal_status <> 'Rejected'";

    	MapSqlParameterSource parameters = new MapSqlParameterSource();
    	parameters.addValue("peopleId", peopleId);
	
    	BigDecimal sum = namedParameterJdbcTemplate.queryForObject(sql, parameters, BigDecimal.class);
		return sum != null ? sum : BigDecimal.ZERO;
    }
     
     public EnhancedTreeNode getEnhancedTree(Long peopleId ) {
	    String sql = "SELECT uh.descendant_id, uh.position, u.full_name, u.customer_id, u.created_dt " +
	                 "FROM user_hierarchy uh, users u " +
	                 "WHERE uh.ancestor_id = ? AND u.people_id = uh.descendant_id";

	    List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, peopleId);
	    Map<String, EnhancedTreeNode> nodeMap = new HashMap<>();
	    String rootId = String.valueOf(peopleId);
	    EnhancedTreeNode root = null;

	    for (Map<String, Object> row : rows) {
	        String descendantId = row.get("descendant_id").toString();
	        String name = row.get("full_name").toString();
	        String customerId = row.get("customer_id").toString();
	        LocalDate date = ((LocalDateTime) row.get("created_dt")).toLocalDate();
	        String formattedDate = date.format(formatter);
	        EnhancedTreeNode node = new EnhancedTreeNode(name, formattedDate,customerId);
	        nodeMap.put(descendantId, node);
	        if (descendantId.equals(rootId))  root = node;
	    }
	    EnhancedTreeNode parent = nodeMap.get(rootId);
	    if(parent==null) {
	    	String parentQuery = "select u.full_name, u.customer_id, u.created_dt from users u where people_id=?";
	    	Map<String, Object> parentrow = jdbcTemplate.queryForMap(parentQuery, peopleId);
	    	if (parentrow != null) {
		    	String name = parentrow.get("full_name").toString();
		        String customerId = parentrow.get("customer_id").toString();
		        LocalDate date = ((LocalDateTime) parentrow.get("created_dt")).toLocalDate();
		        String formattedDate = date.format(formatter);
		        EnhancedTreeNode node = new EnhancedTreeNode(name, formattedDate,customerId);
		        nodeMap.put(rootId, node);
		        root=node;
	    	}
	    }
	    parent= nodeMap.get(rootId);
	    for (Map<String, Object> row : rows) {
	        String childId = row.get("descendant_id").toString();
	        if (!childId.equals(rootId)) {
	            EnhancedTreeNode child = nodeMap.get(childId);
	            if (parent != null && child != null) parent.addChild(child);
	        }
	    }
	    if (root == null || root.getChildren().isEmpty())  return null;
	    return root;
	}
	public List<Map<String, Object>> getDownlineData(Long ancestorId) {
		List<Object> params = new ArrayList<>();
	    
	    try {
	        String sql = "WITH descendants AS ( " +
	                     "    SELECT descendant_id, position " + // Include position here
	                     "    FROM user_hierarchy " +
	                     "    WHERE ancestor_id = ? AND position != '0' " + // Filter by ancestor_id	                     
	                     ") " +
	                     "SELECT " +
	                     "CASE d.position WHEN '1' THEN 'Left' WHEN '2' THEN 'Right' ELSE 'Unknown' END AS position_label,"+
	                     "    u.full_name,u.customer_id, " +
	                     "    COALESCE(w.available_balance, 0) AS total_balance, " +
	                     "    COALESCE(f.total_funds_added, 0) AS total_funds_added, " +
	                     "    COALESCE(t.total_packages_bought, 0) AS total_packages_bought, " +
	                     "    COALESCE(wd.total_withdrawals, 0) AS total_withdrawals " +
	                     "FROM descendants d " +
	                     "LEFT JOIN users u ON d.descendant_id = u.people_id " +
	                     "LEFT JOIN wallet w ON d.descendant_id = w.people_id " +
	                     "LEFT JOIN ( " +
	                     "    SELECT people_id, SUM(transaction_amount) AS total_funds_added " +
	                     "    FROM fund_request_history " +
	                     "    GROUP BY people_id " +
	                     ") f ON d.descendant_id = f.people_id " +
	                     "LEFT JOIN ( " +
	                     "    SELECT people_id, SUM(topup_package) AS total_packages_bought " +
	                     "    FROM topup " +
	                     "    GROUP BY people_id " +
	                     ") t ON d.descendant_id = t.people_id " +
	                     "LEFT JOIN ( " +
	                     "    SELECT people_id, SUM(withdrawal_amount) AS total_withdrawals " +
	                     "    FROM withdrawal_history " +
	                     "    GROUP BY people_id " +
	                     ") wd ON d.descendant_id = wd.people_id ORDER BY d.position;";
	
	        // Add ancestorId to params
	        params.add(ancestorId);
	        // Execute the query
	        return jdbcTemplate.query(sql, (rs, rowNum) -> {
	            Map<String, Object> stats = new HashMap<>();
	            stats.put("customerName", rs.getString("full_name"));
	            stats.put("customerId", rs.getString("customer_id"));
	            stats.put("totalBalance", formatDoubleData(rs.getDouble("total_balance")));
	            stats.put("totalFundsAdded", formatDoubleData(rs.getDouble("total_funds_added")));
	            stats.put("totalPackagesBought", formatDoubleData(rs.getDouble("total_packages_bought")));
	            stats.put("totalWithdrawals", formatDoubleData(rs.getDouble("total_withdrawals")));
	            stats.put("position", rs.getString("position_label"));
	            return stats;
	        }, params.toArray());
	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }
	    
	    return new ArrayList<Map<String, Object>>(); // Return empty list if error occurs
	}
	
	public Double getTotalWithdrawals(Long peopleId, String topupId) {
        String jpql = "SELECT SUM(w.interest_amount) from  withdrawal_history w WHERE w.people_Id = :peopleId AND w.topup_id = :topupId and w.withdrawal_status IN ('Approved', 'Pending') ";
        Double totalWithdrawanAmt = 0.0;
        Query query = entityManager.createNativeQuery(jpql)
        		.setParameter("peopleId", peopleId)
        		.setParameter("topupId", topupId);
        if(query.getResultList()!=null && query.getResultList().get(0)!=null) {
        	String result =  query.getResultList().get(0).toString();
        	totalWithdrawanAmt = result != null ? Double.parseDouble(result) : 0.0;
        }
        
        return totalWithdrawanAmt;
    }
	
	private String formatDoubleData(String value) {
		if(value == null || value.length()==0) return "0.0";
	    return CommonUtil.formatNumber(Double.parseDouble(value));
	}
	
	private String formatDoubleData(Double value) {
		if(value == null ) return "0.0";
	    return CommonUtil.formatNumber(value);
	}
}