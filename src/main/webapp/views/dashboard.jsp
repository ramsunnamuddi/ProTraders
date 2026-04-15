<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<style>
/* Font Awesome for icons (add this in head) */
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css');

.referral-container {
    max-width: 900px;
    margin: 0 auto;
    padding: 20px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.section-title {
    text-align: center;
    color: #2c3e50;
    margin-bottom: 30px;
    font-weight: 600;
}

.referral-cards {
    display: flex;
    justify-content: center;
    gap: 30px;
    flex-wrap: wrap;
}

.referral-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    padding: 25px;
    width: 100%;
    max-width: 350px;
    transition: transform 0.3s ease;
}

.referral-card:hover {
    transform: translateY(-5px);
}

.card-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
}

.card-header i {
    color: #3498db;
    font-size: 1.5rem;
}

.card-header h4 {
    margin: 0;
    color: #2c3e50;
    font-size: 1.2rem;
}

.qr-container {
    background: white;
    padding: 15px;
    border-radius: 8px;
    margin: 0 auto 20px;
    text-align: center;
    border: 1px solid #eee;
}

.qr-code {
    width: 180px;
    height: 180px;
}

.link-container {
    display: flex;
    gap: 10px;
}

.link-input {
    flex: 1;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 14px;
    background: #f9f9f9;
    color: #555;
}

.copy-btn {
    background: #3498db;
    color: white;
    border: none;
    border-radius: 8px;
    padding: 0 20px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
}

.copy-btn:hover {
    background: #2980b9;
}

.copy-btn.copied {
    background: #2ecc71;
}

.copy-btn i {
    font-size: 16px;
}


@keyframes slideIn {
    from { transform: translateX(100%); }
    to { transform: translateX(0); }
}

@keyframes fadeOut {
    to { opacity: 0; }
}

/* Responsive */
@media (max-width: 768px) {
    .referral-cards {
        flex-direction: column;
        align-items: center;
    }
}
</style>
<!-- Dashboard -->
<div class="content-section" id="dashboardContent">
	
    <div class="d-flex justify-content-between align-items-center mb-4">
		<div class="logo"></div>
        <h2><i class="bi bi-speedometer2 me-2"></i>Dashboard Overview</h2>
		<div class="text-muted">&nbsp;<span id="currentDate"></span></div>
    </div>
	<div class="referral-container">
	    <h4 class="section-title">Share Your Referral Links</h4>
	    
	    <div class="referral-cards">
	        <!-- Left Referral Card -->
	        <div class="referral-card">
	            <div class="card-header">
	                <i class="fas fa-link"></i>
	                <h4>Left Referral</h4>
	            </div>
	            <div class="qr-container">
	                <img src="https://api.qrserver.com/v1/create-qr-code/?data=${pageContext.request.contextPath}/${dashboardDetails.leftReferralLink}&size=180x180&margin=10" 
	                     alt="Left QR Code" class="qr-code" />
	            </div>
	            <div class="link-container">
	                <input type="text" id="leftRef" class="link-input" 
	                       value="${dashboardDetails.leftReferralLink}" readonly>
	                <button class="copy-btn" onclick="copyToClipboard('leftRef', this)">
	                    <i class="far fa-copy"></i> Copy
	                </button>
	            </div>
	        </div>

	        <!-- Right Referral Card -->
	        <div class="referral-card">
	            <div class="card-header">
	                <i class="fas fa-link"></i>
	                <h4>Right Referral</h4>
	            </div>
	            <div class="qr-container">
	                <img src="https://api.qrserver.com/v1/create-qr-code/?data=${pageContext.request.contextPath}/${dashboardDetails.rightReferralLink}&size=180x180&margin=10" 
	                     alt="Right QR Code" class="qr-code" />
	            </div>
	            <div class="link-container">
	                <input type="text" id="rightRef" class="link-input" 
	                       value="${dashboardDetails.rightReferralLink}" readonly>
	                <button class="copy-btn" onclick="copyToClipboard('rightRef', this)">
	                    <i class="far fa-copy"></i> Copy
	                </button>
	            </div>
	        </div>
	    </div>
	</div>
    <!-- Stats Cards -->
    <div class="row">
	    <div class="col-xl-3 col-md-6 mb-4">
	        <div class="card stat-card card-primary h-100 py-2">
	            <div class="card-body">
	                <div class="row no-gutters align-items-center">
	                    <div class="col mr-2">
	                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Items</div>
	                        <div class="h5 mb-0 font-weight-bold text-gray-800">${dashboardDetails.totalItems}</div>
	                    </div>
	                    <div class="col-auto"><i class="bi bi-person-plus fs-2 text-primary"></i></div>
	                </div>
	            </div>
	        </div>
	    </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card stat-card card-success h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total Income</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">0</div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-plus-circle-fill fs-2 text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card stat-card card-warning h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Total Deposits</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">₹&nbsp;${dashboardDetails.totalDeposits}</div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-graph-up fs-2 text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card stat-card card-danger h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Total Withdrawals</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${dashboardDetails.totalWithdrawals}</div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-hourglass-split fs-2 text-danger"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
	
	<!-- Stats Cards -->
    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card stat-card card-primary h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">left Business</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${dashboardDetails.leftBusiness}</div>
                        </div>
                        <div class="col-auto"><i class="bi bi-briefcase-fill fs-2 text-primary"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card stat-card card-success h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Right Business</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${dashboardDetails.rightBusiness}</div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-briefcase-fill fs-2 text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card stat-card card-warning h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Right Bonus</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">₹&nbsp;${dashboardDetails.rightBonus}</div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-window-plus fs-2 text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card stat-card card-danger h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Left Bonus</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">₹&nbsp;${dashboardDetails.leftBonus}</div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-window-plus fs-2 text-danger"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
			
			<!-- Stats Cards -->
	<div class="row">
	    <div class="col-xl-3 col-md-6 mb-4">
	        <div class="card stat-card card-primary h-100 py-2">
	            <div class="card-body">
	                <div class="row no-gutters align-items-center">
	                    <div class="col mr-2">
	                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Binary Bonus</div>
	                        <div class="h5 mb-0 font-weight-bold text-gray-800">${dashboardDetails.binaryBonus}</div>
	                    </div>
	                    <div class="col-auto"><i class="bi bi-diagram-2-fill fs-2 text-primary"></i></div>
	                </div>
	            </div>
	        </div>
	    </div>

	    <div class="col-xl-3 col-md-6 mb-4">
	        <div class="card stat-card card-success h-100 py-2">
	            <div class="card-body">
	                <div class="row no-gutters align-items-center">
	                    <div class="col mr-2">
	                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">ROI Bonus</div>
	                        <div class="h5 mb-0 font-weight-bold text-gray-800">${dashboardDetails.totalRoiBonus}</div>
	                    </div>
	                    <div class="col-auto">
	                        <i class="bi bi-window-plus fs-2 text-success"></i>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>

	    <div class="col-xl-3 col-md-6 mb-4">
	        <div class="card stat-card card-warning h-100 py-2">
	            <div class="card-body">
	                <div class="row no-gutters align-items-center">
	                    <div class="col mr-2">
	                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Available Balance</div>
	                        <div class="h5 mb-0 font-weight-bold text-gray-800">₹&nbsp;${dashboardDetails.availableBalance}</div>
	                    </div>
	                    <div class="col-auto">
	                        <i class="bi bi-graph-up fs-2 text-warning"></i>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>

		<div class="col-xl-3 col-md-6 mb-4">
		    <div class="card stat-card card-danger h-100 py-2">
		        <div class="card-body">
		            <div class="row no-gutters align-items-center">
		                <div class="col mr-2">
		                    <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Active Directs</div>
		                    <div class="h5 mb-0 font-weight-bold text-gray-800">${dashboardDetails.activeDirects}</div>
		                </div>
		                <div class="col-auto">
		                    <i class="bi bi-hourglass-split fs-2 text-danger"></i>
		                </div>
		            </div>
		        </div>
		    </div>
		</div>
	</div>