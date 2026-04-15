package com.protrdrs.repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.Map;

import com.protrdrs.model.ProfileDetails;
import com.protrdrs.repository.UserRepository;

import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Optional;


@Repository
public class ProfileRepository {
	
	@Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired	
    private UserRepository userRepository;
	@Autowired
    private PasswordEncoder passwordEncoder;
    
    private static final String query = "SELECT u.customer_id as userId,u.full_name as name ,u.mobile_number as number ,u.email as email,b.bank_name as bankName,"+
    				"b.account_no as accountNo,b.ifsc_code as ifscCode,b.account_branch as accountBranch, b.account_holder_nm as accountHolderName "+
					"FROM users u LEFT JOIN bank_details b ON u.people_id = b.people_id"+
					" WHERE u.people_id = ?";
	private static final String checkUserQuery = "select count(*) from users where people_id=?";
    
    public ProfileDetails getProfileDetails(Long peopleId) {
		 Map<String, Object> result = jdbcTemplate.queryForMap(query, peopleId);
		  ProfileDetails details = new ProfileDetails();
		  details.setUserId(checkIfNull(result.get("userId")));
		  details.setName(checkIfNull(result.get("name")));
		  details.setNumber(checkIfNull(result.get("number")));
		  details.setEmail(checkIfNull(result.get("email")));
		  details.setBankName(checkIfNull(result.get("bankName")));
		  details.setAccountNo(checkIfNull(result.get("accountNo")));
		  details.setIfsCode(checkIfNull(result.get("ifscCode")));
		  details.setAccountBranch(checkIfNull(result.get("accountBranch")));
		  details.setAccountHolderName(checkIfNull(result.get("accountHolderName")));
		  return details;
	}
	
	private String checkIfNull(Object objValue){
		String value= "";
		if (objValue != null) {
			 if (objValue instanceof String) value = String.valueOf(objValue);
		}else value = "";
		
		return value;
	}
	
	public String updateGeneralInfo(Long userId, Map<String, Object> formData) {
        String email = (String) formData.get("email");
        String name = (String) formData.get("name");
        String mobileNo = (String) formData.get("number");

        // Check if user exists
        Integer count = jdbcTemplate.queryForObject(checkUserQuery, Integer.class, userId);

        if (count != null && count > 0) {
            int rowsUpdated = jdbcTemplate.update(
                "UPDATE users SET full_name = ?, mobile_number = ?,email = ? WHERE people_id = ?",
                name, mobileNo, email, userId
            );

            return (rowsUpdated > 0) ? "0" : "-1";
        } else {
            return "-2";
        }
    }
    
    public String updatePassword(Long userId, Map<String, Object> formData) {
        String password = (String) formData.get("password");

        // Check if user exists
        String result = "";
        Integer count = jdbcTemplate.queryForObject(checkUserQuery, Integer.class, userId);

        if (count != null && count > 0) {
        	Optional<String> hashedPasswordOpt = userRepository.findPasswordByPeopleId(userId);
        	if (hashedPasswordOpt.isPresent()) {
				String hashedPassword = hashedPasswordOpt.get();
	            if (passwordEncoder.matches(password.trim(), hashedPassword.trim())) {
					String newpwd = (String) formData.get("newpwd");
					if(newpwd!=null && newpwd.length()>0){
						String	encodedPwd = getHashedPassword(newpwd);
						int rowsUpdated = jdbcTemplate.update(
				                "UPDATE users SET password_hash = ? WHERE people_id = ?",
				                encodedPwd, userId
				        );
				        result =  (rowsUpdated > 0) ? "0" : "-1";
					}else   result =  "-1";
				}else result =  "-99";
			} 
        }else result =  "-2";
        
        return result; 
    }
    
    public String updateBankDetails(Long userId, Map<String, Object> formData) {
		
        String accountNumber = (String) formData.get("accountNo");
        String accountHolderName = (String) formData.get("accountHolderName");
        String branch = (String) formData.get("accountBranch");
        String bankName = (String) formData.get("bankName");
        String ifscCode = (String) formData.get("ifsCode");

        // Check if bank details exist for the user
        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM bank_details WHERE people_id = ?", Integer.class, userId
        );

        if (count != null && count > 0) {
            int rowsUpdated = jdbcTemplate.update(
                "UPDATE bank_details SET account_no=?, account_holder_nm=?, bank_name=?, account_branch=?, ifsc_code=? WHERE people_id = ?",
                accountNumber,accountHolderName, bankName, branch,  ifscCode, userId
            );

            return (rowsUpdated > 0) ? "0" : "-1";
        } else {
           String sql  =  "INSERT INTO bank_details value (?,?,?,?,?,?)";
           int rowsUpdated  = jdbcTemplate.update(
                sql,
                userId, accountNumber,accountHolderName, bankName, branch,  ifscCode
            );
            return (rowsUpdated > 0) ? "0" : "-1";
        }
    }
    
    private String  getHashedPassword(String password) {
	    return passwordEncoder.encode(password);
    }
    
    public String getReferrCustomerId(Long peopleId) {
	   try {
	   String sql = "SELECT customer_id FROM users WHERE people_id = ? and role='USER'";
	    return jdbcTemplate.queryForObject(sql, String.class, peopleId);
	   }catch(Exception ex) {
		   return null;
	   }
	}
    
    public Long getPeopleIdByCustomerId(String customerId) {
 	   try {
 	   String sql = "SELECT people_id FROM users WHERE customer_id = ? and role='USER'";
 	    return jdbcTemplate.queryForObject(sql, Long.class, customerId);
 	   }catch(Exception ex) {
 		   return null;
 	   }
 	}

}
