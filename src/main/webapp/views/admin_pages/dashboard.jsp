<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<link rel="stylesheet" href="<c:url value='css/admin/dashboard_style.css' />">
</head>
<body>

   <%@ include file ="/views/admin_pages/menu.jsp"%>
   <form name="index" id="index">
   		<input type="hidden" value="${sid}" name="sid">			 
   		<input type="hidden" value="${pid}" name="pid">
   	</form>
    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Dashboard -->
        <div class="content-section" id="dashboardContent">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-speedometer2 me-2"></i>Dashboard Overview</h2>
                <div class="text-muted">Today: <span id="currentDate"></span></div>
            </div>

            <!-- Stats Cards -->
            <div class="row">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card card-primary h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Today's Users</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${dshbrdDtls.userStats.today_registered}</div>
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
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Weekly Users</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${dshbrdDtls.userStats.week_registered}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-people fs-2 text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

				<div class="col-xl-3 col-md-6 mb-4">
				    <div class="card stat-card card-primary h-100 py-2">
				        <div class="card-body">
				            <div class="row no-gutters align-items-center">
				                <div class="col mr-2">
				                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Top-Up Sales</div>
				                    <div class="h5 mb-0 font-weight-bold text-gray-800">₹${dshbrdDtls.totalActiveTopup}</div>
				                </div>
				                <div class="col-auto">
				                    <i class="bi bi-cash-coin fs-2 text-primary"></i>
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
				                    <div class="h5 mb-0 font-weight-bold text-gray-800">₹${dshbrdDtls.totWithdrawals}</div>
				                </div>
				                <div class="col-auto">
				                    <i class="bi bi-currency-exchange fs-2 text-danger"></i>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>

				<div class="col-xl-3 col-md-6 mb-4">
				    <div class="card stat-card card-success h-100 py-2">
				        <div class="card-body">
				            <div class="row no-gutters align-items-center">
				                <div class="col mr-2">
				                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Today Topup Sales</div>
				                    <div class="h5 mb-0 font-weight-bold text-gray-800">₹${dshbrdDtls.todayTopupSales}</div>
				                </div>
				                <div class="col-auto">
				                    <i class="bi bi-arrow-up-circle fs-2 text-success"></i>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>

				<div class="col-xl-3 col-md-6 mb-4">
				    <div class="card stat-card card-info h-100 py-2">
				        <div class="card-body">
				            <div class="row no-gutters align-items-center">
				                <div class="col mr-2">
				                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Today Withdrawals</div>
				                    <div class="h5 mb-0 font-weight-bold text-gray-800">₹${dshbrdDtls.todayWithdrawals}</div>
				                </div>
				                <div class="col-auto">
				                    <i class="bi bi-arrow-down-circle fs-2 text-info"></i>
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
                                    <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Pending Withdrawals</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${dshbrdDtls.pendingWithdrawals}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-hourglass-split fs-2 text-danger"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card shadow h-100">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">User Growth</h6>
							<label>Last 7 Days</label>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="userGrowthChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 mb-4">
                    <div class="card shadow h-100">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Package Sales</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="packageSalesChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Recent Top-Ups</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>Amount</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
										<c:choose>

									        <!-- ================= TOPUPS ================= -->
									        <c:when test="${not empty dshbrdDtls.latestTopups}">
									            <c:forEach var="topups" items="${dshbrdDtls.latestTopups}" varStatus="status">
									
									                <c:if test="${status.index < 5}">
									                    <tr>
									                        <td><c:out value="${topups.customer_id}" /></td>
									                        <td><c:out value="${topups.topup_package}" /></td>
									                        <td><c:out value="${topups.date}" /></td>
									                    </tr>
									                </c:if>
									
									                <c:if test="${status.index == 5}">
									                    <tr>
									                        <td colspan="3" style="text-align:center;background:#f0f0f0;">
									                            <a href="#" class="seeMoreLink" data-target-section="topup"
									                               style="text-decoration:none;color:#333;font-weight:500;">
									                               See More
									                            </a>
									                        </td>
									                    </tr>
									                </c:if>
									
									            </c:forEach>
									        </c:when>
									
									        <c:otherwise>
									            <tr>
									                <td colspan="3" style="text-align:center;border:none;">
									                    No data available
									                </td>
									            </tr>
									        </c:otherwise>
									
									    </c:choose>
									</tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 mb-4">
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Recent Withdrawals</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
									<tbody>
										<c:choose>

									        <c:when test="${not empty dshbrdDtls.latestWithdrawals}">
									            <c:forEach var="withdrawal" items="${dshbrdDtls.latestWithdrawals}" varStatus="status">
									
									                <c:if test="${status.index < 5}">
									                    <tr>
									                        <td><c:out value="${withdrawal.customer_id}" /></td>
									                        <td><c:out value="${withdrawal.withdrawal_amount}" /></td>
									
									                        <td>
									                            <c:choose>
									                                <c:when test="${withdrawal.withdrawal_status == 'Approved'}">
									                                    <span class="badge bg-success">
									                                        <c:out value="${withdrawal.withdrawal_status}" />
									                                    </span>
									                                </c:when>
									
									                                <c:when test="${withdrawal.withdrawal_status == 'Pending'}">
									                                    <span class="badge bg-warning">
									                                        <c:out value="${withdrawal.withdrawal_status}" />
									                                    </span>
									                                </c:when>
									
									                                <c:when test="${withdrawal.withdrawal_status == 'Rejected'}">
									                                    <span class="badge bg-danger">
									                                        <c:out value="${withdrawal.withdrawal_status}" />
									                                    </span>
									                                </c:when>
									
									                                <c:otherwise>
									                                    <span class="badge bg-secondary">
									                                        <c:out value="${withdrawal.withdrawal_status}" />
									                                    </span>
									                                </c:otherwise>
									                            </c:choose>
									                        </td>
									
									                        <td><c:out value="${withdrawal.withdrawal_date_time}" /></td>
									                    </tr>
									                </c:if>
									
									            </c:forEach>
									
									            <c:if test="${fn:length(dshbrdDtls.latestWithdrawals) > 5}">
									                <tr>
									                    <td colspan="4" style="text-align:center;background:#f0f0f0;">
									                        <a href="#" class="seeMoreLink" data-target-section="withdrawal"
									                           style="text-decoration:none;color:#333;font-weight:500;">
									                           See More
									                        </a>
									                    </td>
									                </tr>
									            </c:if>
									
									        </c:when>
									
									        <c:otherwise>
									            <tr>
									                <td colspan="4" style="text-align:center;border:none;">
									                    No data available
									                </td>
									            </tr>
									        </c:otherwise>
									
									    </c:choose>
									</tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/admin_pages/fundtransferview.jsp" %>
		<%@ include file="/views/admin_pages/topupview.jsp" %>
		<%@ include file="/views/admin_pages/withdrawalview.jsp" %>
		<%@ include file="/views/admin_pages/usermgmtview.jsp"%>
		<%@ include file="/views/admin_pages/fileuploadview.jsp"%>
		<%@ include file="/views/admin_pages/downline_view.jsp"%>
		<%@ include file ="/views/admin_pages/modalvws.jsp"%>
	 
	<div id="loadingOverlay" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.7);z-index:1001;justify-content:center;align-items:center;">
    <div style="text-align:center;">
      <!-- Animated rupee symbol -->
      <div style="font-size:4rem;font-weight:bold;color:gold;animation:spin-3d 1.5s linear infinite;">&#x20B9;</div>
      <p style="color:white;margin-top:20px;font-size:1.2rem;font-family: roboto;">Please wait, it's loading...</p>
    </div>
  </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="<c:url value='js/common/fileupload.js'/>"></script>
	<script src="<c:url value='js/admin/filter.js'/>"></script>
	<script src="<c:url value='js/common/downline.js'/>"></script>
	<script src="<c:url value='js/common/binarytree.js'/>"></script>
    <script>
        // Initialize date
        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('en-US', {
            year: 'numeric', 
            month: 'long', 
            day: 'numeric'
        });

        // Sidebar toggle
        document.getElementById('toggleSidebar').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('sidebar-collapsed');
            document.getElementById('mainContent').classList.toggle('content-collapsed');
        });
		var packagePerformanceChart = null;
        // Navigation between sections
        document.querySelectorAll('[data-section]').forEach(link => {
			link.addEventListener('click', async function (e) {
				e.preventDefault();
				const section = this.getAttribute('data-section');
				const contentElement = document.getElementById(section + 'Content');
				const loadingOverlay = document.getElementById('loadingOverlay');

				// Show loading overlay
				showLoading(true, null, loadingOverlay);
				const form = document.getElementById('index');
				const formData = new FormData(form);
				const queryParams = new URLSearchParams();
				for (const [key, value] of formData.entries()) {
				    if (value) queryParams.append(key, value);
				}
				// Update active link
				document.querySelectorAll('.nav-link').forEach(nav => nav.classList.remove('active'));
				this.classList.add('active');

				try {
					if(section=="upload"){
						initUploadSection();
					}else if(section=='dl'){
						document.querySelectorAll('.dl-nav-link').forEach(tab => tab.classList.remove('active', 'disabled'));
						document.querySelectorAll('.dl-nav-link')[0].classList.add('active', 'disabled');
						reloadDLTabData();
					}else if(section!="dashboard"){
						resetFilters(section, true);
						// Fetch content for the section before showing it
						const response = await fetch('admin/dt/'+section+"?"+queryParams.toString());
						if (!response.ok){
							if(response.status==401){
								showToast("Invalid Session , Redirecting to home page", 'danger');
								setTimeout(() => {
						           window.location.href = 'admin';
						        }, 2000);
							}else throw new Error('Failed to load content');
							return ;
						}

						const data = await response.text(); // Assuming the server returns HTML
						var jsonDt=[];
						if(data!=null&&data.length>0) jsonDt = JSON.parse(data);
						if(section=="fundTransfer"){
							populateDataTBL(section+"TBL", jsonDt); // Update section content
							crtPgn(section);
						}else if(section == "withdrawal"){
							 populateDataTBL(section+"TBL", jsonDt);
							 crtPgn(section);
						}else if(section=="topup"){
							const tbody = document.querySelector("#"+section+"PkgsTBL tbody"), jsonData=jsonDt.pkgs;

							// Clear any existing rows
							tbody.innerHTML = "";
							if (jsonData.length === 0) {
								// If no data, show "No Data Available"
								let noDataRow = document.createElement("tr");
								noDataRow.innerHTML = `<td colspan="5" style="text-align:center; font-weight:500; color:#999999;border:none">No Data Available</td>`;
								tbody.appendChild(noDataRow);
							} else {
								// If data exists, populate the table
								jsonData.forEach(txn => {
									let row = document.createElement("tr");
									row.innerHTML = "<td>"+txn.pkg_nm+"</td><td>₹"+txn.pkg_amt+"</td>";
									tbody.appendChild(row);
								});
							}
							populateDataTBL(section+"HisTBL", jsonDt.tpupdt); // Update section content
							crtPgn(section);
							updatePackageChart(jsonDt.perfChrt);
						}else if(section=="users"){
							const tbody = document.querySelector("#"+section+"TBL tbody");
							tbody.innerHTML = "";

							if (jsonDt.length === 0) {
								// If no data, show "No Data Available"
								let noDataRow = document.createElement("tr");
								noDataRow.innerHTML = `<td colspan="6" style="text-align:center; font-weight:500; color:#999999;border-bottom:none">No active users found</td>`;
								tbody.appendChild(noDataRow);
							}else {
								jsonDt.forEach(txn => {
									let row = document.createElement("tr");
									row.innerHTML = "<td>"+txn.custId+"</td><td>"+txn.name+"</td><td>"+txn.email+"</td><td>"+txn.number+"</td><td>"+txn.createdDt+"</td><td><span class='mreinf' onclick=\"moreinfo('" + txn.custId + "', event)\">More info</span></td>";
									row.innerHTML +="<td><span class='mreinf' data-custid='"+txn.custId+"' data-bank='"+txn.bankNm+"' data-acctno='"+txn.accountNo+"' data-branch='"+txn.brnchNm+"' data-accthldr='"+txn.accHldNm+"' data-ifsc='"+txn.ifscCd+"' onclick=swbnkDtls(this)>Add </span></td>";
									row.innerHTML +="<td><span class='mreinf' onclick=\"swChngPwdMdl('" + txn.custId + "', event)\">Click here</span></td>";
									tbody.appendChild(row);
								});
							}
						}
						if(section!='users'){
							document.querySelectorAll('.paging').forEach(sec => sec.classList.add('d-none'));
							document.getElementById(section + 'Pagination').classList.remove('d-none');		
						}
					}
					// Hide all content sections before displaying the updated one
					document.querySelectorAll('.content-section').forEach(sec => sec.classList.add('d-none'));			
					contentElement.classList.remove('d-none'); // Show updated section
					unlockScrollingWithDelay(3000);
				} catch (error) {
					console.error('Error fetching content:', error);
					contentElement.innerHTML = '<p style="color:red;">Error loading content. Please try again.</p>';
					contentElement.classList.remove('d-none');
				} finally {
					// Hide loading overlay after fetch completes
					loadingOverlay.style.display = 'none';
				}
			});
		});
		document.querySelectorAll('.seeMoreLink').forEach(link => {
		    link.addEventListener('click', function (e) {
		        e.preventDefault();

		        const trgSec = this.getAttribute('data-target-section');
		        const trgLnk = document.querySelector('[data-section="'+trgSec+'"]');

		        if (trgLnk)  trgLnk.click(); // Triggers the actual section
		        else console.warn('No matching data-section found:', targetSection);
		    });
		});
        // Withdrawal rejection functionality
        document.querySelectorAll('.reject-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const reasonInput = this.closest('td').querySelector('.reason-input');
                reasonInput.classList.toggle('d-none');
            });
        });

        document.querySelectorAll('.confirm-reject').forEach(btn => {
            btn.addEventListener('click', function() {
                const reason = this.previousElementSibling.value;
                if (!reason) {
                    alert('Please enter rejection reason');
                    return;
                }
                alert('Withdrawal rejected with reason: ' + reason);
                this.closest('.reason-input').classList.add('d-none');
            });
        });

		// Function to check if scrolling is locked
		function isPageScrollLocked() {
		  const bodyStyle = window.getComputedStyle(document.body);
		  const htmlStyle = window.getComputedStyle(document.documentElement);
		  
		  return bodyStyle.overflow === 'hidden' || 
				 htmlStyle.overflow === 'hidden' ||
				 bodyStyle.overflowY === 'hidden' || 
				 htmlStyle.overflowY === 'hidden';
		}
		
		function updatePackageChart(jsonDt) {
		  try {
			
			// Extract the data you need (adjust based on your API response)
			const packagePrices = jsonDt.pkg_amt;
			const salesCounts = jsonDt.pkg_count;
			const revenues = jsonDt.pkg_revenue;
			
			// Update the chart
			packagePerformanceChart.data.labels = packagePrices;
			packagePerformanceChart.data.datasets[0].data = salesCounts;
			packagePerformanceChart.data.datasets[1].data = revenues;
			packagePerformanceChart.update();
			
			
		  } catch (error) {
			console.error('Error updating chart:', error);
			// Optional: Show error state on chart
			packagePerformanceChart.data.labels = ['Error loading data'];
			packagePerformanceChart.data.datasets.forEach(dataset => dataset.data = [0]);
			packagePerformanceChart.update();
		  }
		}

		// Function to unlock scrolling with timeout
		function unlockScrollingWithDelay(delayMs) {
		  setTimeout(() => {
			// Check current state first
			if (isPageScrollLocked()) {
			  console.log('Scroll is currently locked - unlocking now');
			  
			  // Set overflow to auto on both elements
			  document.body.style.overflow = 'auto';
			  document.documentElement.style.overflow = 'auto';
			  
			  // Verify it worked
			  if (!isPageScrollLocked()) {
				console.log('Successfully unlocked scrolling');
			  } else {
				console.warn('Failed to unlock scrolling');
			  }
			} else {
			  console.log('Scroll was not locked');
			}
		  }, delayMs);
		}

		// Usage examples:

		// 1. Unlock after 3 seconds
		unlockScrollingWithDelay(3000);

		// 2. Unlock after animation completes (500ms)
		// unlockScrollingWithDelay(500);

		// 3. Unlock when some condition is met
		// if (someCondition) {
		//   unlockScrollingWithDelay(0); // Immediately
		// }

        // Initialize charts
        function initCharts() {
            // User Growth Chart
            new Chart(document.getElementById('userGrowthChart'), {
                type: 'line',
                data: {
                	labels: ${fn:escapeXml(dshbrdDtls.userChart.labels)},
                    datasets: [{
                        label: 'New Users',
                        data: ${dshbrdDtls.userChart.data},
                        borderColor: '#4e73df',
                        backgroundColor: 'rgba(78, 115, 223, 0.05)',
                        tension: 0.3,
                        fill: true
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { 
							beginAtZero: true,
							ticks: {  // Ensures whole number steps
								precision: 0    // Prevents decimal points
							}
						},
                        x: { grid: { display: false } }
                    }
                }
            });

            // Package Sales Chart
            new Chart(document.getElementById('packageSalesChart'), {
                type: 'doughnut',
                data: {
                    labels: ${dshbrdDtls.topupPieChart.pkg_amt},
                    datasets: [{
                        data: ${dshbrdDtls.topupPieChart.user_count},
                        backgroundColor: ${dshbrdDtls.topupPieChart.colors},
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } }
                }
            });

            // Package Performance Chart
            packagePerformanceChart = new Chart(document.getElementById('packagePerformanceChart'), {
				type: 'bar',
				data: {
				  labels: [], // Start empty
				  datasets: [{
					label: 'Sales Count',
					data: [],
					backgroundColor: '#4e73df'
				  }, {
					label: 'Revenue (₹)',
					data: [],
					backgroundColor: '#1cc88a'
				  }]
				},
				options: {
				  maintainAspectRatio: false,
				  scales: {
					y: { beginAtZero: true }
				  }
				}
            });

            // New Users Chart
          <%--/*new Chart(document.getElementById('newUsersChart'), {
                type: 'line',
                data: {
                    labels: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Today'],
                    datasets: [{
                        label: 'New Users',
                        data: [5, 8, 6, 9, 7, 10, 12],
                        borderColor: '#4e73df',
                        backgroundColor: 'rgba(78, 115, 223, 0.05)',
                        tension: 0.3,
                        fill: true
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });

            // User Activity Chart
            new Chart(document.getElementById('userActivityChart'), {
                type: 'bar',
                data: {
                    labels: ['Active', 'Inactive', 'Blocked'],
                    datasets: [{
                        label: 'Users',
                        data: [85, 10, 5],
                        backgroundColor: ['#4e73df', '#f6c23e', '#e74a3b']
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });*/--%>
        }

        // Initialize charts when DOM is loaded
        document.addEventListener('DOMContentLoaded', initCharts);
    </script>
	<!-- Toast Notifications Container -->
<div id="toastContainer" class="position-fixed top-0 end-0 p-3" style="z-index: 1100"></div>
</body>
</html>