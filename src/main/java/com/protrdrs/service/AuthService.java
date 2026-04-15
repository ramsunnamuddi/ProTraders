package com.protrdrs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.protrdrs.model.ReferralLink;
import com.protrdrs.model.User;
import com.protrdrs.repository.ProfileRepository;
import com.protrdrs.repository.ReferralLinkRepository;
import com.protrdrs.repository.SessionRepository;
import com.protrdrs.repository.UserRepository;
import com.protrdrs.util.EncryptionUtil;

import java.util.Optional;
import java.util.Map;
import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;

@Service
public class AuthService {

	@Autowired	
    private UserRepository userRepository;
	@Autowired
    private JdbcTemplate jdbcTemplate;
	@Autowired
    private PasswordEncoder passwordEncoder;
	@Autowired
	SessionRepository sessionRepository;
	@Autowired
	MessageService messageService;
	
	@Autowired
	ProfileRepository  profileRepository;
	
	@Autowired
	ReferralLinkRepository referralLinkRepository;
	
	public Map<String,String > loginUser(String customerId, String enteredPassword, String ipAddress, String browserInfo, HttpServletRequest httpRequest){
		return loginUser(customerId, enteredPassword, ipAddress, browserInfo, httpRequest,"USER");
	}

    public Map<String,String > loginUser(String customerId, String enteredPassword, String ipAddress, String browserInfo, HttpServletRequest httpRequest, String role) {
		String errorCode= "";
    	Map<String, String> resultMap =  new HashMap<String, String>();
		try{
        	// Fetch hashed password from DB
        	Optional<String> hashedPasswordOpt = Optional.empty();
        	if(role==null) role="ADMIN";
        	hashedPasswordOpt = userRepository.findPasswordByCustomerId(customerId, role);
	        if (hashedPasswordOpt.isPresent()) {
	            String hashedPassword = hashedPasswordOpt.get();
	            // Compare entered password with hashed password
	            if (passwordEncoder.matches(enteredPassword.trim(), hashedPassword.trim())) {
	               	Map<String, String> hashMp = createSession(customerId, ipAddress, browserInfo);	               	
	                if(hashMp !=null&&"SUCCESS".equalsIgnoreCase(hashMp.get("msg"))) {
	                	String sessionId = (String) hashMp.get("sessionId");
	                	String peopleId = (String) hashMp.get("peopleId");
						HttpSession session = httpRequest.getSession();
		        		session.setAttribute("SESSION_ID", sessionId);
		        		session.setAttribute("PEOPLE_ID", peopleId);
		        		errorCode =  messageService.getMessage("LOGIN.SUCCESS");
		        		resultMap.put("sid", sessionId);
		        		resultMap.put("pid", peopleId);
					}else errorCode = messageService.getMessage("LOGIN."+hashMp.get("msg"));
	            }else errorCode  = messageService.getMessage("LOGIN.INVALID_CREDENTIALS");
	        }else errorCode =  messageService.getMessage("LOGIN.USER.NOTFOUND");
		}catch(Exception ex){
			ex.printStackTrace();
			errorCode = messageService.getMessage("LOGIN.FAILURE");
		}
		
		resultMap.put("errCd", errorCode);
		resultMap.put("errMsg", messageService.getMessage("LOGIN_CODE_"+errorCode));
        return resultMap; // Authentication failed
    }

    public Map<String,String> createSession(String customerId, String ipAddress, String browserInfo) {
    	Map<String,String> resultMap =  new HashMap<String,String>();
        try {
            // Execute stored procedure
            Map<String, Object> result = jdbcTemplate.call(conn -> {
                var stmt = conn.prepareCall("{CALL user_login(?, ?, ?, ?,?)}");

                // Set input parameters
                stmt.setString(1, customerId); // user_email
                stmt.setString(2, ipAddress);     // user_ip
                // Register output parameters
                stmt.registerOutParameter(3, Types.VARCHAR); // session_status
                stmt.registerOutParameter(4, Types.CHAR); 
                stmt.registerOutParameter(5, Types.CHAR); 

                return stmt;
            }, List.of( // ✅ Explicitly declare parameters
                new SqlParameter(Types.VARCHAR), // First input parameter (e.g., username)
                new SqlParameter(Types.VARCHAR), 
                new SqlOutParameter("message", Types.VARCHAR),// Third output parameter (message)
                new SqlOutParameter("sessionId", Types.VARCHAR), // Fourth output parameter (sessionId)
                new SqlOutParameter("people_id", Types.VARCHAR)	// output parameter (people_id)
            ));
            
            String message = (String) result.get("message");
            String sessionId = null;
            String peopleId= null;
            if("SUCCESS" .equals(message) ){
            	sessionId = (String) result.get("sessionId");
            	peopleId = (String) result.get("people_id");
            }
            resultMap.put("sessionId",sessionId);
            resultMap.put("peopleId",peopleId);
            resultMap.put("msg",message);
            
            // Extract session ID
        } catch (Exception e) {
        	e.printStackTrace();
            resultMap.put("msg","Error:Authentication Exception");
        }
        return resultMap;
    }
    
    public boolean validateSession(String sessionId, String peopleId) {
    	if(sessionId!=null&sessionId.length()>0
    			&&peopleId!=null&&peopleId.length()>0) 
    	{
    		Integer count = sessionRepository.checkValidSession(sessionId, peopleId);
    		return count != null && count > 0;
    	}
    	return false;
    }
    
    public void logout(String sid, String pid, HttpServletRequest request , HttpServletResponse response) {
		String deleteSessionQuery = "DELETE FROM session_info WHERE people_id = ?";
		String updateHistoryQuery = "UPDATE user_login_history SET logout_datetime = ? WHERE people_id = ? AND session_id =? ";
        if(sid!=null&sid.length()>0&&pid!=null&&pid.length()>0) {
			Long userId =  Long.valueOf(pid);
        	jdbcTemplate.update(deleteSessionQuery, userId);        	
        	jdbcTemplate.update(updateHistoryQuery, LocalDateTime.now(), userId,sid);
		}
        invalidateSession(request , response);
    }
    public void invalidateSession(HttpServletRequest request , HttpServletResponse response) {
    	HttpSession session = request.getSession(false);
    	if (session != null) session.invalidate();
        clearCookies(response);
    }
    private void clearCookies(HttpServletResponse response) {
        response.setHeader("Set-Cookie", "JSESSIONID=; Path=/; Max-Age=0; HttpOnly; Secure; SameSite=Strict");
        response.setHeader("Set-Cookie", "user_token=; Path=/; Max-Age=0; HttpOnly; Secure; SameSite=Strict");
    }
    
    public boolean validateSession(Map<String, String> formData) {
		 String sessionId = formData.get("sid");
		 String peopleId = formData.get("pid");
		 return validateSession(sessionId, peopleId);
    }
    
    public void generateLinks(String customerId) throws Exception {
    	Long peopleId = profileRepository.getPeopleIdByCustomerId(customerId);
    	String dataLeft = "refId=" +peopleId+ "&position=left";
	    String dataRight = "refId=" +peopleId+ "&position=right";
	    String tokenLeft = EncryptionUtil.encrypt(dataLeft);
	    String tokenRight = EncryptionUtil.encrypt(dataRight);
	    ReferralLink link = new ReferralLink();
        link.setPeople_id(peopleId);
        link.setLeft_ref_link(tokenLeft);
        link.setRight_ref_link(tokenRight);
        referralLinkRepository.save(link);

    }
    
    public void generateReferralLinksForAllUsers() {
        List<User> users = userRepository.findAllByRole("USER");

        for (User user : users) {
        	Long peopleId=user.getPeopleId();
            boolean exists = referralLinkRepository.existsById(peopleId);
            if (!exists) {
            	try {
	            	String dataLeft = "refId=" +peopleId+ "&position=left";
	        	    String dataRight = "refId=" +peopleId+ "&position=right";
	        	    String tokenLeft = EncryptionUtil.encrypt(dataLeft);
	        	    String tokenRight = EncryptionUtil.encrypt(dataRight);
	        	    ReferralLink link = new ReferralLink();
	                link.setPeople_id(peopleId);
	                link.setLeft_ref_link(tokenLeft);
	                link.setRight_ref_link(tokenRight);
	                referralLinkRepository.save(link);
            	}catch(Exception ex) {
            		System.out.println("=================Exception occured while generating the links for peopleId="+peopleId);
            		ex.printStackTrace();
            	}
            }else  System.out.println("peopleId="+peopleId+" already exists in the referal table continuing to next one");
        }
    }
}

