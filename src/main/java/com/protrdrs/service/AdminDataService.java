package com.protrdrs.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;

import com.protrdrs.model.DashboardDetails;
import com.protrdrs.model.EnhancedTreeNode;
import com.protrdrs.model.TotalTeamDTO;
import com.protrdrs.repository.AdminDataRepository;
import com.protrdrs.repository.DashboardRepository;
import com.protrdrs.repository.ProfileRepository;
import com.protrdrs.util.CommonUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.stream.Collectors;
import java.text.DecimalFormat;
import java.text.NumberFormat;

@Service
public class AdminDataService {
	@Autowired
    private AdminDataRepository adminDataRepository;
	@Autowired 
	private ProfileRepository profileRepository;
	@Autowired 
	private TransactionService transactionService;

	@Autowired 
	private  DashboardRepository dashboardRepository;
	
	private static final NumberFormat formatter = new DecimalFormat("##,###,###.00");
    
    private static final String[] colorsArray = {
	    "#FF5733", // Red-Orange
	    "#33FF57", // Lime Green
	    "#3357FF", // Royal Blue
	    "#FF33A8", // Hot Pink
	    "#33FFF6", // Aqua Blue
	    "#FFBD33", // Golden Yellow
	    "#A833FF", // Purple
	    "#57FF33", // Bright Green
	    "#FF3380", // Deep Pink
	    "#33A8FF", // Sky Blue
	    "#FFC733"  // Amber
	};



    public Map<String, Object> getDashboardData() {
        Map<String, Object> dashboardData = new HashMap<>();

        // Get user registration stats
        dashboardData.put("userStats", adminDataRepository.getUserRegistrationStats());

        // Get total active top-up
        dashboardData.put("totalActiveTopup", formatDoubleData(adminDataRepository.getTotalActiveTopup()));

        // Get pending withdrawals count
        dashboardData.put("pendingWithdrawals", adminDataRepository.getPendingWithdrawals());

        // Get bar chart data (user registrations in last 7 days)
        dashboardData.put("userChart", getUserRegistrationsDetails());

        // Get pie chart data (active top-up packages)
        dashboardData.put("topupPieChart", getPackageWithUserStats());

        // Get latest top-ups
        dashboardData.put("latestTopups", adminDataRepository.getLatestTopups());

        // Get latest withdrawals
        dashboardData.put("latestWithdrawals", adminDataRepository.getLatestWithdrawals());
        dashboardData.put("todayTopupSales", formatDoubleData(adminDataRepository.getTodayTopups()));
        dashboardData.put("todayWithdrawals", formatDoubleData(adminDataRepository.getTodayWithdrawals()));
        dashboardData.put("totWithdrawals", formatDoubleData(adminDataRepository.getTotalWithdrawals()));

        return dashboardData;
    }
    
    public Map<String, Object> getPackageWithUserStats() {
	    List<Map<String, Object>> packages = getPackages();
	    List<Map<String, Object>> userTopups = adminDataRepository.getActiveTopupPackages();
	
	    // Convert userTopups to a Map with String keys for easier lookup
	    Map<String, Integer> userTopupMap = userTopups.stream()
	        .collect(Collectors.toMap(
	            topup -> topup.get("pkg_nm").toString(),  // Ensure key is a String
	            topup -> (Integer) topup.get("user_count")
	        ));
	
	    List<String> pkgAmts = new ArrayList<>();
	    List<Integer> userCounts = new ArrayList<>();
	    List<String> colors = new ArrayList<>();
	    int i =0;
	    
	    // Populate separate lists
	    for (Map<String, Object> pkg : packages) {
	        String pkgAmt = pkg.get("pkg_amt").toString();  // Convert to String if needed
	        int userCount = userTopupMap.getOrDefault(pkgAmt, 0);
	        double pkgAmtdouble = Double.parseDouble(pkgAmt);
	        String formattedPkgAmt = formatter.format(pkgAmtdouble);
	        
	        pkgAmts.add("\"" +formattedPkgAmt+ "\"");
	        userCounts.add(userCount);	        
	        colors.add("\"" +colorsArray[i]+ "\"");
	        i++;
	    }
	
	    // Return as a single Map containing two lists
	    Map<String, Object> result = new HashMap<>();
	    result.put("pkg_amt", pkgAmts);
	    result.put("user_count", userCounts);
	    result.put("colors",colors);
	    return result;
	}

    
    private Map<String, Object> getUserRegistrationsDetails(){
		LocalDate today = LocalDate.now();
		List<String> last7Days = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        for (int i = 6; i >= 0; i--) {
            last7Days.add(today.minusDays(i).format(formatter)); // Example: ["2025-03-24", "2025-03-25", ..., "2025-03-30"]
        }
		List<Map<String, Object>> userGrowth = adminDataRepository.getUserRegistrationsChart();
		Map<String, Long> dbDataMap = userGrowth.stream()
            .collect(Collectors.toMap(
                record -> record.get("reg_date").toString(),
                record -> (Long) record.get("user_count")
            ));

        // Fill missing dates with 0
        List<Long> userCounts = new ArrayList<>();
        List<String> formattedDays = new ArrayList<>();
        for (String date : last7Days) {
			formattedDays.add( "\"" +convertDate(date)+ "\"");
            userCounts.add(dbDataMap.getOrDefault(date, 0L));
        }

        // Prepare response
        Map<String, Object> response = new HashMap<>();
        response.put("labels",formattedDays); // x-axis labels
        response.put("data", userCounts);  // y-axis values

        return response;
	}
	
	private static String convertDate(String dateStr) {
	    DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	    DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("MMM dd");
	
	    LocalDate date = LocalDate.parse(dateStr, inputFormatter);
	    return date.format(outputFormatter);
	}
	
	public List<Map<String,Object>> getFundTransferData(String fromDate, String toDate, String status, int offset, int pageSize){
		return  adminDataRepository.getFundRequestData(fromDate, toDate, status,offset, pageSize);
	}
	
	public Map<String,Object> getTopupData(String fromDate, String toDate, String status, String packageId, int offset, int pageSize){
		 Map<String, Object> topupData = new HashMap<>();
		 topupData.put("pkgs",getPackages());
		 topupData.put("tpupdt",adminDataRepository.getTopupData(fromDate, toDate, status, packageId,offset, pageSize));
		 topupData.put("perfChrt",getPackagePerfChart());
		 return topupData;
	}
	
	public List<Map<String,Object>> getWithdrawalData(String fromDate, String toDate, String status, String searchBy, int offset, int pageSize){
		return  adminDataRepository.getPendingWithdrawalsData(fromDate, toDate, status,searchBy,offset, pageSize);
	}
	@Transactional
    public int countWithdrawals(String fromDate, String toDate, String status, String searchBy) {
		return  adminDataRepository.getPendingWithdrawalsCount(fromDate, toDate, status,searchBy);
    }
	public List<Map<String,Object>> getUsersData(String fromDate, String toDate, String searchBy){
		return  adminDataRepository.getUsersData(fromDate, toDate, searchBy);
	}
	
	public Map<String, Object> getPackagePerfChart() {
	    List<Map<String, Object>> packages = getPackages();
	    List<Map<String, Object>> userTopups = adminDataRepository.getTopupPackages();
	
	    // Convert userTopups to a Map with String keys for easier lookup
	    Map<String, Integer> userTopupMap = userTopups.stream()
	        .collect(Collectors.toMap(
	            topup -> topup.get("pkg_nm").toString(),  // Ensure key is a String
	            topup -> (Integer) topup.get("user_count")
	        ));
	
	    List<String> pkgAmts = new ArrayList<>();
	    List<Integer> pkgCounts = new ArrayList<>();
	     List<Double> pkgRevenues = new ArrayList<>();
	    // Populate separate lists
	    for (Map<String, Object> pkg : packages) {
	        String pkgAmt = pkg.get("pkg_amt").toString();  // Convert to String if needed
	        int pkgCount = userTopupMap.getOrDefault(pkgAmt, 0);
	        double pkgAmtdouble = Double.parseDouble(pkgAmt);
	        String formattedPkgAmt = formatDoubleData(pkgAmtdouble);
	        pkgAmts.add(formattedPkgAmt);
	        pkgCounts.add(pkgCount);
	        pkgRevenues.add(pkgAmtdouble*pkgCount) ;  
	    }
	
	    // Return as a single Map containing two lists
	    Map<String, Object> result = new HashMap<>();
	    result.put("pkg_amt", pkgAmts);
	    result.put("pkg_count", pkgCounts);
	    result.put("pkg_revenue", pkgRevenues);
	    return result;
	}
	
	public String saveUserBankDetails(Map<String,Object> formData) {
		Long peopleId =  adminDataRepository.checkUserExistence((String) formData.get("custId"));
		String result=null;
		if(peopleId!=null) {
			result = profileRepository.updateBankDetails(peopleId,formData);
			if("1".equalsIgnoreCase(result)) result="Error saving bank details: Failed to save bank details";
		}else result="User not found";
		
		return result;
	}
	
	public String updateUserPassword(Map<String,Object> formData) {
		Long peopleId =  adminDataRepository.checkUserExistence((String) formData.get("custId"),true);
		String result=null;
		if(peopleId!=null) {
			result = adminDataRepository.updateUserPassword(peopleId,formData);
			if("-1".equalsIgnoreCase(result)) result="Error updating password: Failed to update the details";
		}else result="User not found";
		
		return result;
	}
	
	public Map<String, Object> addFunds(Map<String,Object> formData) {
		Long peopleId =  adminDataRepository.checkUserExistence((String) formData.get("custId"));
		Map<String, Object> resultMap=new HashMap<String, Object> ();
		if(peopleId!=null) {
			String amount=(String) formData.get("amt");
			double amt= Double.parseDouble(amount);
			String transactonId = transactionService.handleTransaction("ADD",amt,peopleId);
			if(transactonId!=null&&transactonId.length()>0) {
				resultMap.put("eC", "0");  // No error
				resultMap.put("eM", "Funds added successfully "+transactonId);
		    }else {
		    	resultMap.put("eC", "-1");  // No error
		    	resultMap.put("eM", "Failed to add Funds");
		    }
		}else {
			resultMap.put("eC", "-3");  // No error
			resultMap.put("eM", "User not found");
		}
		
		return resultMap;
	}
	
	public Map<String, Object> purchasePackage(Map<String,Object> formData) {
		Long peopleId =  adminDataRepository.checkUserExistence((String) formData.get("custId"));
		Map<String, Object> resultMap=new HashMap<String, Object>();
		if(peopleId!=null) {
			Double dbAmount = adminDataRepository.getAvailableBalance(peopleId);
			String amount=(String) formData.get("amt");
			double amt= Double.parseDouble(amount);
			if(amt<=dbAmount) {
				Integer pkgCount = adminDataRepository.checkPackageExistence(amt);
				if(pkgCount!=null&&pkgCount>0) {
					String transactonId = transactionService.handleTransaction("TOPUP",amt,peopleId);
					if(transactonId!=null&&transactonId.length()>0) {
						resultMap.put("eC", "0");  // No error
						resultMap.put("eM", "Your purchage is successfull and the transaction id is:"+transactonId);
				    }else {
				    	resultMap.put("eC", "-1");
				    	resultMap.put("eM", "Your purchase has been failed , Please try again.");
				    }
				}else {
					resultMap.put("eC", "-2");
			    	resultMap.put("eM", "No Such package, please choose valid one");;
				}
				
			}else {
				resultMap.put("eC", "-3");
		    	resultMap.put("eM", "User doesn't have sufficient funds");
			}
			
		}else {
			resultMap.put("eC", "-4");
	    	resultMap.put("eM", "No Such user, please provide a valid customer");
		}
		
		return resultMap;
	}
	
	public List<Map<String, Object>> getPackages(){
		return adminDataRepository.getPackages();
	}
	
	public String handleWDWStatus(String transactionId, String newStatus, String customerId) {
		String result=null;
		try {
			Long peopleId =  adminDataRepository.checkUserExistence(customerId);
			if(peopleId!=null) {
				Map<String,Object> info = adminDataRepository.checkWithdrwalTransactionIdExistence(transactionId);
				String currentStatus = (String) info.get("withdrawal_status");
				String topupId = (String) info.get("topup_id");
				System.out.println("currentStatus="+currentStatus+", topupId="+topupId);
				if(	(!"pending".equalsIgnoreCase(currentStatus)&&(newStatus.equals(currentStatus)))) result="You have alreay changed the status to same.";
				else if("approved".equalsIgnoreCase(currentStatus.toLowerCase())) result="Transaction already approved and you can't change it";
				else if("rejected".equalsIgnoreCase(currentStatus.toLowerCase())) result="Transaction already rejected and you can't change it";
				else {
					result=adminDataRepository.updateWithdrawalTransaction(peopleId, transactionId, newStatus, topupId);
				}
			}else {
				result="Invalid user";
			}
		}catch(Exception e) {
			System.out.println("Exception Occured "+e.getMessage());
		}
		return result;
	}
	
	public Map<String, DashboardDetails> getUserDashboardDetails(String customerId){
		Long peopleId =  adminDataRepository.checkUserExistence(customerId);
		DashboardDetails dashboardDetails= new DashboardDetails();  
		Map<String, DashboardDetails> userDashBoardDetails = new HashMap<String, DashboardDetails>();
		if(peopleId!=null) {
			dashboardDetails =  dashboardRepository.getDashboardDetails(peopleId);
		}
		userDashBoardDetails.put("usrDBdtls", dashboardDetails);
		
		return userDashBoardDetails;
	}
	
	public List<Map<String,Object>> getTopupDataForPDF(String fromDate, String toDate, String status, String packageId){
		return  adminDataRepository.getTopupData(fromDate, toDate, status, packageId,0,0);
	}

	public List<TotalTeamDTO> getTotalTeamByAncestorId(String cid) {
		Long peopleId =  adminDataRepository.checkUserExistence(cid);
		List<TotalTeamDTO> list= new ArrayList<TotalTeamDTO>();
		if(peopleId!=null) {
			list = transactionService.getTotalTeamByAncestorId(peopleId);
		}
		return list;
	}

	public EnhancedTreeNode getEnhancedTree(String cid) {
		Long peopleId =  adminDataRepository.checkUserExistence(cid);
		EnhancedTreeNode treeNode= new EnhancedTreeNode();
		if(peopleId!=null)  treeNode = transactionService.getEnhancedTree(peopleId);
		return treeNode;
	}

	public List<Map<String, Object>> getDownlineData(String cid) {
		Long peopleId =  adminDataRepository.checkUserExistence(cid);
		List<Map<String,Object>> levelDownLineData = new ArrayList<Map<String,Object>>();
		if(peopleId!=null) {
			levelDownLineData = transactionService.getDownlineData(peopleId);
		}
		return levelDownLineData;
	}
	
	public List<Map<String, Object>> getActvUsers(String cid) {
		Long peopleId = null;
		if(cid!=null&&cid.length()>0) peopleId=  adminDataRepository.checkUserExistence(cid);
		List<Map<String,Object>> activeUserData = new ArrayList<Map<String,Object>>();
		activeUserData = adminDataRepository.getActvUsersData(peopleId);
		return activeUserData;
	}
	
	
	private String formatDoubleData(Double value) {
	    return CommonUtil.formatNumber(value);
	}
	
	public String generateCommonPassword(String password) {
		return adminDataRepository.getHashedPassword(password);
	}
}
