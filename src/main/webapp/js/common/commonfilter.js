if (typeof filterStates === 'undefined') {
    var filterStates = {
        fundTransfer: {},
        withdrawal: {},
        topup: {},
        users: {}
    };
}

// Initialize filters for each section
function initFilters() {
    // No default date values are set

    // Disable future dates in the calendar
    const today = new Date().toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format
    document.querySelectorAll('[id$="FromDate"]').forEach(el => {
        el.setAttribute('max', today); // Disable future dates
    });
    document.querySelectorAll('[id$="ToDate"]').forEach(el => {
        el.setAttribute('max', today); // Disable future dates
    });

    // Set up event listeners for apply/reset buttons
    addFltrEvtLstnr();
	addPurchasePkg();
	reloadTabData();
	reloadDLTabData();
	addPrflEvtLstnr();
}

function showEnlargedQR(qrCode) {
	const enlargedModal = new bootstrap.Modal(document.getElementById('enlargedQRModal'));
    const qrImage = document.getElementById('enlargedQRImage');
    const pdfFrame = document.getElementById('enlargedPDF');
    
    if(qrCode.includes('image/')) {
        qrImage.src = qrCode;
        qrImage.style.display = 'block';
        pdfFrame.style.display = 'none';
    } 
    else if(qrCode.includes('application/pdf')) {
        pdfFrame.src = qrCode;
        pdfFrame.style.display = 'block';
        qrImage.style.display = 'none';
    }
    
    enlargedModal.show();
}
async function copyToClipboard(id, button) {
    try {
        const input = document.getElementById(id);
        const baseUrl = window.location.origin;
        const referralCode = input.value.trim();
        const fullLink = referralCode.startsWith('http') ? referralCode : baseUrl +"/"+ referralCode;

        // Visual feedback
        button.innerHTML = '<i class="fas fa-check"></i> Copied!';
        button.classList.add('copied');
        
        // Reset button after 2 seconds
        setTimeout(() => {
            button.innerHTML = '<i class="far fa-copy"></i> Copy';
            button.classList.remove('copied');
        }, 2000);

        if (navigator.clipboard) {
            await navigator.clipboard.writeText(fullLink);
            showToast('Link copied to clipboard!');
        } else {
            fallbackCopy(fullLink);
        }
    } catch (err) {
        console.error("Copy failed:", err);
        fallbackCopy(fullLink);
    }
}

function fallbackCopy(text) {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    document.body.appendChild(textarea);
    textarea.select();
    
    try {
        document.execCommand('copy');
        showToast('Link copied!');
    } catch (err) {
        prompt('Copy to clipboard:', text);
    }
    
    document.body.removeChild(textarea);
}

function showCopiedNotification() {
    showToast('Copied Successfully', 'success');
    
    setTimeout(() => toast.remove(), 2000); // Auto-remove after 2 seconds
}
function addPrflEvtLstnr(){
	if(!document.getElementById('profile')) return;
	document.querySelectorAll("#accountTabs .nav-link").forEach(tab => {
       tab.addEventListener("click", function (event) {
           event.preventDefault();
           
           document.querySelectorAll("#accountTabs .nav-link").forEach(t => t.classList.remove("active"));
           this.classList.add("active");

           document.querySelectorAll(".tab-pane").forEach(content => content.classList.remove("show", "active"));
           
           let target = this.getAttribute("href");
           document.querySelector(target).classList.add("show", "active");
       });
   });
   
}
// Set up event listeners for all filter buttons
function addFltrEvtLstnr() {
    // Fund Transfer filters
	if(document.getElementById('applyFundTransferFilters')){
	    document.getElementById('applyFundTransferFilters').addEventListener('click', () => {
	        applyFilters('fundTransfer');
	    });
	    document.getElementById('resetFundTransferFilters').addEventListener('click', () => {
	        resetFilters('fundTransfer');
	    });
	}
    
    // Withdrawal filters
	if(document.getElementById('applyWithdrawalFilters')){
	    document.getElementById('applyWithdrawalFilters').addEventListener('click', () => {
	        applyFilters('withdrawal');
	    });
	    document.getElementById('resetWithdrawalFilters').addEventListener('click', () => {
	        resetFilters('withdrawal');
	    });
	}
    
    // Topup filters
	if(document.getElementById('applyTopupFilters')){
	    document.getElementById('applyTopupFilters').addEventListener('click', () => {
	        applyFilters('topup');
	    });
	    document.getElementById('resetTopupFilters').addEventListener('click', () => {
	        resetFilters('topup');
	    });
	}
    
    // Users filters
	if(document.getElementById('applyUsersFilters')){
	    document.getElementById('applyUsersFilters').addEventListener('click', () => {
	        applyFilters('users');
	    });
	    document.getElementById('resetUsersFilters').addEventListener('click', () => {
	        resetFilters('users');
	    });
	}
}

// Apply filters for a specific section
function applyFilters(section,clRldSctnDt=true, rstPgn = true) {
    // Get filter values
    const filters = {
        fromDate: document.getElementById(`${section}FromDate`).value,
        toDate: document.getElementById(`${section}ToDate`).value
    };
    
    // Section-specific filters
	if(filters.toDate<filters.fromDate)  {
		showToast("To date can't be less than From Date", 'danger');
		return ;
	}
    if (section === 'fundTransfer') {
        filters.status = document.getElementById('fundTransferStatus').value;
		
    } 
    else if (section === 'withdrawal') {
        filters.status = document.getElementById('withdrawalStatus').value;
		if (rstPgn) {	
			filters.page=1;        
	        updatePaginationUI(1);
	    }
    } 
    else if (section === 'topup') {       
        filters.packageId = document.getElementById('topupPackage').value;
		 filters.status = document.getElementById('topupStatus').value;
    } 
    else if (section === 'users') {
        filters.status = document.getElementById('usersStatus').value;
        filters.search = document.getElementById('usersSearch').value;
    }
    
    // Save filter state
    filterStates[section] = filters;
    if(!clRldSctnDt) return;
    // Reload data with filters
    reloadSectionData(section,rstPgn);
}

// Reset filters for a specific section
function resetFilters(section) {
    // Reset date inputs to default (last 30 days)
    const defaultFromDate = new Date();
    defaultFromDate.setDate(defaultFromDate.getDate() - 30);
    const formatDate = (date) => date.toISOString().split('T')[0];
    
	document.getElementById(`${section}FromDate`).value = '';
	document.getElementById(`${section}ToDate`).value = '';
    
    // Reset other inputs
    if (section === 'fundTransfer') {
        document.getElementById('fundTransferStatus').value = '';
    } 
    else if (section === 'withdrawal') {
        document.getElementById('withdrawalStatus').value = '';
		updatePaginationUI(1);
    } 
    else if (section === 'topup') {
        document.getElementById('topupPackage').value = '';
		document.getElementById('topupStatus').value = '';
    } 
    else if (section === 'users') {
        document.getElementById('usersStatus').value = '';
        document.getElementById('usersSearch').value = '';
    }
    
    // Clear filter state
    filterStates[section] = {};
    
    // Reload data without filters
    reloadSectionData(section,true);
    
    // Show success message
    showToast('Filters reset successfully', 'success');
}

// Reload data for a section with current filters
async function reloadSectionData(section,rstPgn) {
    const loadingOverlay = document.getElementById('loadingOverlay');
    showLoading(true, null, loadingOverlay);
    
    try {
        // Build query string from filters
        const queryParams = new URLSearchParams();
        for (const [key, value] of Object.entries(filterStates[section])) {
            if (value) queryParams.append(key, value);
        }
		const form = document.getElementById('index');
		const formData = new FormData(form);

		for (const [key, value] of formData.entries()) {
		    if (value) queryParams.append(key, value);
		}
        
        const response = await fetch(`txn/${section}?${queryParams.toString()}`);
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = '/';
		        }, 2000);
			}else throw new Error('Failed to load content');
			return ;
		}
        const data = await response.json();
        
        // Update the section with the filtered data
        if (section === "fundTransfer") {
            populateDataTBL("fundTransferTBL", data.data);
        } 
        else if (section === "withdrawal") {
            populateDataTBL("withdrawalTBL", data);
        } 
        else if (section === "topup") {
            populateDataTBL("topupHisTBL", data);
        } 
        else if (section === "users") {
            const tbody = document.querySelector("#usersTBL tbody");
            tbody.innerHTML = "";
            if (data.length === 0) {
                tbody.innerHTML = `<tr><td colspan="4" style="text-align:center;">No users found</td></tr>`;
            } else {
                data.forEach(user => {
                    let row = document.createElement("tr");
                    row.innerHTML = `<td>${user.custId}</td><td>${user.name}</td><td>${user.email}</td><td>${user.createdDt}</td>`;
                    tbody.appendChild(row);
                });
            }
        }
		if(rstPgn) recalPgn(section,queryParams,loadingOverlay);
    } catch (error) {
        console.error(`Error loading ${section} data:`, error);
        showToast(`Error loading ${section} data`, 'danger');
    } finally {
        showLoading(false, null, loadingOverlay);
    }
}

// Toast notification function
function showToast(message, type = 'info') {
    const toastContainer = document.getElementById('toastContainer');
    const toastId = `toast-${Date.now()}`;
    
    const toast = document.createElement('div');
    toast.className = `toast show align-items-center text-white bg-${type} border-0`;
    toast.id = toastId;
    toast.role = 'alert';
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;
    
    toastContainer.appendChild(toast);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        const toastElement = document.getElementById(toastId);
        if (toastElement) {
            toastElement.classList.remove('show');
            setTimeout(() => toastElement.remove(), 300);
        }
    }, 5000);
}


function showLoading(show, form, overlay) {
  if (show) {
	overlay.style.display = 'flex';
	document.body.style.overflow = 'hidden';
	if(form) Array.from(form.elements).forEach(el => el.disabled = true);
  } else {
	overlay.style.display = 'none';
	document.body.style.overflow = '';
	if(form) Array.from(form.elements).forEach(el => el.disabled = false);
  }
}
function populateDataTBL(tableId,jsonData) {
	const tbody = document.querySelector("#"+tableId+" tbody");

	// Clear any existing rows
	tbody.innerHTML = "";
	if (jsonData.length === 0) {
		// If no data, show "No Data Available"
		let noDataRow = document.createElement("tr");
		noDataRow.innerHTML = `<td colspan="5" style="text-align:center; font-weight:500; color:#999999;border:none">No Data Available</td>`;
		tbody.appendChild(noDataRow);
	} else {
		// If data exists, populate the table
		if(tableId=='withdrawalTBL'){
			jsonData.forEach(txn => {
				let row = document.createElement("tr");
				var dtRw="<td>"+txn[0]+"</td><td>"+txn[5]+"</td><td>₹"+txn[6]+"</td><td>₹"+txn[7]+"</td><td>₹"+txn[1]+"</td><td><span class='badge bg-";
				if(txn[2]=="SUCCESS"||txn[2]=="Active"||txn[2]=="Approved") dtRw+="success"
				else if(txn[2]=="Rejected"||txn[2]=="FAILED") dtRw+="danger";
				else if(txn[2]=="Withdrawan")dtRw+="secondary";
				else if(txn[2]=="Expired") dtRw+="info";
				else  dtRw+="warning";
				dtRw+="'>"+txn[2]+"</span></td><td>"+txn[4]+"</td>";
				if(tableId=="topupHisTBL") dtRw+="<td>"+txn[5]+"</td>";
				row.innerHTML = dtRw;
				tbody.appendChild(row);
			});
			return;
		}
		jsonData.forEach(txn => {
			let row = document.createElement("tr");
			var dtRw="<td>"+txn[0]+"</td><td>₹"+txn[1]+"</td><td><span class='badge bg-";
			if(txn[2]=="SUCCESS"||txn[2]=="Active"||txn[2]=="Approved") dtRw+="success"
			else if(txn[2]=="Rejected"||txn[2]=="FAILED") dtRw+="danger";
			else if(txn[2]=="Withdrawan")dtRw+="secondary";
			else if(txn[2]=="Expired") dtRw+="info";
			else  dtRw+="warning";
			dtRw+="'>"+txn[2]+"</span></td><td>"+txn[4]+"</td>";
			if(tableId=="topupHisTBL") dtRw+="<td>"+txn[5]+"</td>";
			row.innerHTML = dtRw;
			tbody.appendChild(row);
		});
	}
}

function addPurchasePkg(){
	if(!document.getElementById('purchasepkgFrm')) return;
	document.getElementById('purchasepkgFrm').addEventListener('submit', async function(e) {
		e.preventDefault();
		const modal = bootstrap.Modal.getInstance(document.getElementById('addPackageModal'));
	    const formData = new FormData(this);
		const idxFrm=document.getElementById('index');
	    
	    try {
	        // Show loading state (optional)
	        const saveBtn = document.querySelector('#addPackageModal .modal-footer .btn-primary');
	        saveBtn.disabled = true;
	        saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Purchasing...';
	        
	        // Make the API call
	        const response = await fetch('txn/purchase', {
	            method: 'POST',
				body:JSON.stringify({
				    ...Object.fromEntries(formData),
				    sid: idxFrm.sid.value,
				    pid: idxFrm.pid.value
				}),
	            headers: {
	                'Content-Type': 'application/json'
	            }
	        });
	        
			if (!response.ok){
				if(response.status==401){
					showToast("Invalid Session , Redirecting to home page", 'danger');
					setTimeout(() => {
			           window.location.href = '/';
			        }, 2000);
				}else throw new Error('Your purchase has been failed');
				return ;
			}
	        
	        const result = await response.json();
	        
	        // Show success toast
			if(result!=null){
				var erCd=result.errorCode;
				if(erCd=='0'){
					showToast(result.message, 'success');
					populateDataTBL("topupHisTBL", result.tpups);
					document.getElementById('availbal').value =  result.balance;
					const dropdown = document.getElementById('purchagepkg');
			       dropdown.innerHTML = ""; // Clear existing options
					var packages = result.pkgs;
			       packages.forEach(pkg => {
			           if (pkg.pkg_amt <= parseFloat(result.balance)) {
			               const option = document.createElement('option');
			               option.value = pkg.pkg_amt;
			               option.textContent = pkg.pkg_amt;
			               dropdown.appendChild(option);
			           }
			       });
				   modal.hide();
				}else showToast(message, 'danger');	
			}
	        
	        
	        // Close the modal after a short delay
	        setTimeout(() => {
	            modal.hide();
	            // Reset form and button state
	            this.reset();
	            saveBtn.disabled = false;
	            saveBtn.textContent = 'Purchase';
	        }, 2000);
	        
	    } catch (error) {
	        console.error('Your purchage failed:', error);
	        showToast(error.message, 'danger');
	        
	        // Reset button state
	        const saveBtn = document.querySelector('#addPackageModal .modal-footer .btn-primary');
	        saveBtn.disabled = false;
	        saveBtn.textContent = 'Purchase';
	    }
	});
}

function switchBnsTab(ev) {
	if(!document.getElementById("dataTabs")) return ;
    document.querySelectorAll('.nav-link').forEach(tab => tab.classList.remove('active', 'disabled'));
    ev.target.classList.add('active', 'disabled');
	reloadTabData();
}

async function reloadTabData(shwOverly) {
	if(!document.getElementById("dataTabs")) return ;
    let activeTab = document.querySelector('.nav-link.active').getAttribute('data-tab');
    let fromDate = document.getElementById('bnsFromDate').value;
    let toDate = document.getElementById('bnsToDate').value;
    let status = '';
	const form = document.getElementById('index');
	let sid=form.sid.value;
	let pid=form.pid.value;
	if(activeTab=='roibns'&&toDate<fromDate)  {
		showToast("To date can't be less than From Date", 'danger');
		return ;
	}
	const loadingOverlay = document.getElementById('loadingOverlay');
	showLoading(shwOverly?shwOverly:true, null, loadingOverlay);
	btncls=document.getElementById("bnswdw");
	if(activeTab=='bnrybns'){ 
		btncls.style.display="";
		btncls.classList.add('d-flex');
	}else{
		btncls.style.display="none";
		btncls.classList.remove('d-flex');
	}
    try {
        let response = ''
		if(activeTab=='roibns'){
			document.getElementById('bns-fltr').style.display="";
			response = await fetch(`txn/${activeTab}?fromDate=${fromDate}&toDate=${toDate}&status=${status}&sid=${sid}&pid=${pid}`);
		}else {
			document.getElementById('bns-fltr').style.display="none";
			response = await fetch(`txn/${activeTab}?sid=${sid}&pid=${pid}`);
			
		}

		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = '/';
		        }, 2000);
			}else throw new Error('Failed to save details');
			return ;
		}
        
        let data = await response.json();
		let tableContent = '<div id="table-responsive">';
		if (activeTab == 'roibns') {
		    let grouped = {};

			if (Object.keys(data).length > 0) {
			    // Grouping (already done if data is a map, but we'll format structure)
			    Object.entries(data).forEach(([parentId, rows]) => {
					var totVal=rows.reduce((sum, row) => sum + parseFloat(row[2]), 0);
			        grouped[parentId] = {
			            status: rows[0][6], // e.g., Active/Pending/Completed
			            rows: rows,
			            total:  totVal// interest_amt
			        };
			    });

			    tableContent += '<div class="accordion" id="groupAccordion">';

			    let groupIndex = 0;

			    Object.entries(grouped).forEach(([parentId, group]) => {
			        const collapseId = `collapse-${groupIndex}`;
			        const headingId = `heading-${groupIndex}`;
			        const isFirst = groupIndex === 0;
					const badgeClass = getStatusBadgeClass(group.status);
					const isActive = group.status.toLowerCase() === 'active';
			        tableContent += `
			        <div class="accordion-item">
						<h2 class="accordion-header d-flex justify-content-between align-items-center px-3" id="${headingId}">
							<button class="accordion-button ${!isFirst ? 'collapsed' : ''}" type="button" data-bs-toggle="collapse" data-bs-target="#${collapseId}">
						       	${parentId}
								${isActive? `<span class="badge bg-primary ms-2" data-topup-id="${parentId}"
						                    data-amount="${group.total.toFixed(2)}"
						                    onclick="showWithdrawModal(this)">
						                    Withdraw
						               </span>`
						            : `<span class="badge ${badgeClass} ms-2">${group.status}</span>`
						        }
						    </button>
						</h2>
			            <div id="${collapseId}" class="accordion-collapse collapse ${isFirst ? 'show' : ''}" data-bs-parent="#groupAccordion">
			                <div class="accordion-body">
			                    <table class="table table-striped table-bordered">
			                        <thead>
			                            <tr>
			                                <th>Transaction ID</th>
			                                <th>Amount</th>
			                                <th>Date</th>
			                                <th>Status</th>
			                            </tr>
			                        </thead>
			                        <tbody>`;

			        group.rows.forEach(row => {
			            tableContent += `
			                <tr>
			                    <td>${row[0]}</td>
			                    <td>₹${formatNumber(parseFloat(row[2]).toFixed(2))}</td>
			                    <td>${row[4]}</td>
			                    <td>${row[3]}</td>
			                </tr>`;
			        });

			        tableContent += `
			                        </tbody>
			                        <tfoot>
			                            <tr class="table-info">
			                                <td><strong>Total</strong></td>
			                                <td colspan="3"><strong>₹${formatNumber(group.total.toFixed(2))}</strong></td>
			                            </tr>
			                        </tfoot>
			                    </table>
			                </div>
			            </div>
			        </div>`;
			        groupIndex++;
			    });

			    tableContent += '</div>';
			} else {
			    tableContent = '<div class="alert alert-info text-center" role="alert">No ROI Bonus data available.</div>';
			}
		}else if(activeTab=='bnrybns'){
			tableContent = '<table class="table table-striped table-sm"><thead><tr><th>Binary User</th><th>Binary position</th><th>Binary Bonus</th></tr></thead><tbody>';
			if (data) {
				var dt=data.data,tot=data.totalAmount;
				if(tot<=0) {
					btncls.style.display="none";
					btncls.classList.remove('d-flex');
				}
				document.getElementById('totamt').innerHTML = tot;
				document.getElementById("bnrywdw").setAttribute("data-tot-amt", tot);
				if(dt.length>0){
					dt.forEach(item => {
						let positionText = item.binaryPosition == 1 ? 'Left' : 'Right';
		                tableContent += `
							<tr><td>${item.customerId}</td>
							<td>${positionText}</td>
							<td>${item.binaryBonus}</td></tr>`;
		            });
				}else tableContent += '<tr><td colspan="3" style="text-align:center;border:none;">No data available</td></tr>';				
			}else tableContent += '<tr><td colspan="3" style="text-align:center;border:none;">No data available</td></tr>';
        }else{
			tableContent = '<table class="table table-striped table-sm"><thead><tr><th>User</th><th>Bonus</th></tr></thead><tbody>';
			if (data.length > 0) {
				data.forEach(item => {
	                tableContent += `
						<tr><td>${item.customerId}</td>
						<td>${item.bonus}</td></tr>`;
	            });
			}else {
				tableContent += '<tr><td colspan="3" style="text-align:center;border:none;">No data available</td></tr>';
			}
			
        }
        tableContent += '</tbody></table></div>';
        document.getElementById('tabData').innerHTML = tableContent;
    } catch (error) {
        console.error(`Error loading ${activeTab} data:`, error);
        document.getElementById('tabData').innerHTML = '<p class="text-center text-danger">Error loading data</p>';
    }finally{
		showLoading(false, null, loadingOverlay);
	}
}
async function saveProfile() {
    let name = document.getElementById("name").value.trim();
    let email = document.getElementById("email").value.trim();
    let number = document.getElementById("number").value.trim();
	let type = document.getElementById("type").value.trim();
	let sid= document.getElementById("index").sid.value.trim();
	let pid= document.getElementById("index").pid.value.trim();
    if (!name || !email || !number) {
        alert("Please fill in all profile details.");
        return;
    }
	const loadingOverlay = document.getElementById('loadingOverlay');
	showLoading(true, null, loadingOverlay);
	const saveBtn = document.querySelector('#svusrdtls');
	try{
		saveBtn.disabled = true;
	    saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> updating...';
		let data = { name, email, number,type,sid,pid };
		
		const response = await fetch('prfl/saveDetails', {
			method: 'POST',
		    body: JSON.stringify(data),
		    headers: {
		    	'Content-Type': 'application/json'
		     }
		});
		
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = '/';
		        }, 2000);
			}else throw new Error('Failed to save details');
			return ;
		}
		    
		const result = await response.json();
		
	    // Show success toast
		if(result!=null){
			var ercd=result.errCd;
			if(ercd=='0') showToast(result.errMsg, 'success');
			else showToast(message, 'danger');	
		}
	}catch(error) {
		console.error(`Failed to save the users details:`, error);
	    showToast(`Failed to save the user details`, 'danger');
	}finally {
		saveBtn.disabled = false;
        saveBtn.textContent = 'Update User details';
		showLoading(false, null, loadingOverlay);
	}
}

// Save Password
async function savePassword() {
    let password = document.getElementById("password").value.trim();
	let newpwd = document.getElementById("newpwd").value.trim();
    let cnfpwd = document.getElementById("cnfpwd").value.trim();
	let type = document.getElementById("pwdtype").value.trim();
	let sid= document.getElementById("index").sid.value.trim();
	let pid= document.getElementById("index").pid.value.trim();
    if (!password || !newpwd || !cnfpwd) {
        alert("Please fill all password fields.");
        return;
    }
    if (newpwd !== cnfpwd) {
        alert("New password and confirm password must match.");
        return;
    }
	const loadingOverlay = document.getElementById('loadingOverlay');
	showLoading(true, null, loadingOverlay);
	const saveBtn = document.querySelector('#updpwd');
	try{
		saveBtn.disabled = true;
	    saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> updating...';
    	let data = { password, newpwd,type,sid,pid};
		const response = await fetch('prfl/saveDetails', {
			method: 'POST',
		    body: JSON.stringify(data),
		    headers: {
		    	'Content-Type': 'application/json'
		     }
		});
		    
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = '/';
		        }, 2000);
			}else throw new Error('Failed to change the password');
			return ;
		}		    
		const result = await response.json();
		
	    // Show success toast
		if(result!=null){
			var ercd=result.errCd;
			if(ercd=='0') showToast(result.errMsg, 'success');
			else showToast(message, 'danger');	
		}
	}catch(error) {
		console.error(`Failed to change the password:`, error);
	    showToast(`Failed to change the password`, 'danger');
	}finally {
	    saveBtn.disabled = false;
	    saveBtn.textContent = 'Change Password';
		showLoading(false, null, loadingOverlay);
		showLoading(false, null, loadingOverlay);
	}
}

// Save Bank Details
async function saveBankDetails() {
    let bankName = document.getElementById("bankName").value.trim();
	let accountHolderName = document.getElementById("accountHolderName").value.trim();
	let accountBranch = document.getElementById("accountBranch").value.trim();
    let accountNo = document.getElementById("accountNo").value.trim();
    let ifsCode = document.getElementById("ifsCode").value.trim();
	let type = document.getElementById("bnktype").value.trim();
	let sid= document.getElementById("index").sid.value.trim();
	let pid= document.getElementById("index").pid.value.trim();
    if (!bankName || !accountNo || !ifsCode) {
        alert("Please fill all bank details.");
        return;
    }
	const loadingOverlay = document.getElementById('loadingOverlay');
	showLoading(true, null, loadingOverlay);
	const saveBtn = document.querySelector('#updbnkdtls');
	
	try{
		saveBtn.disabled = true;
		saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> updating...';
    	let data = { accountNo, accountHolderName, accountBranch,  ifsCode, bankName, type,sid,pid };

		const response = await fetch('prfl/saveDetails', {
			method: 'POST',
		    body: JSON.stringify(data),
		    headers: {
		    	'Content-Type': 'application/json'
		     }
		});
		    
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = '/';
		        }, 2000);
			}else throw new Error('Failed to change the password');
			return ;
		}	
		    
		const result = await response.json();
		
	    // Show success toast
		if(result!=null){
			var ercd=result.errCd;
			if(ercd=='0') showToast(result.errMsg, 'success');
			else showToast(message, 'danger');	
		}
	}catch(error) {
		console.error(`Failed to save the bank details:`, error);
	    showToast(`Failed to save the bank details`, 'danger');
	}finally {
        saveBtn.disabled = false;
        saveBtn.textContent = 'Save Changes';
		showLoading(false, null, loadingOverlay);
	}
}

async function reloadDLTabData() {
	if(!document.getElementById("dldataTabs")) return ;
    let activeTab = document.querySelector('.nav-link.active').getAttribute('data-tab');
	const loadingOverlay = document.getElementById('loadingOverlay');
	showLoading(true, null, loadingOverlay);
	const idxFrm=document.getElementById('index');
	const sid=idxFrm.sid.value;
	const pid=idxFrm.pid.value;
	if(activeTab=='tt')  {		
		try{
			response = await fetch(`txn/totTm?sid=${sid}&pid=${pid}`);
			if (!response.ok){
				if(response.status==401){
					showToast("Invalid Session , Redirecting to home page", 'danger');
					setTimeout(() => {
			           window.location.href = '/';
			        }, 2000);
				}else throw new Error('Failed to save details');
				return ;
			}
		        
	        let data = await response.json();
			let tableContent = '<div id="table-responsive">';
			tableContent = '<table class="table table-striped"><thead><tr><th scope="col">Customer Id</th><th scope="col">Customer name</th><th scope="col">Position</th></tr></thead><tbody>';
			if (data.length > 0) {
	            data.forEach(item => {
	                tableContent += `<tr><td scope="row">${item.customerId}</td><td scope="row">${item.fullname}</td><td scope="row">${item.position}</td></tr>`;
	            });
	        } else {
	            tableContent += '<tr><td colspan="5" style="text-align:center;border:none;">No data available</td></tr>';
	        }	
	        tableContent += '</tbody></table></div>';
	        document.getElementById('tabData').innerHTML = tableContent;
		}catch (error) {
		 	console.error(`Error loading ${activeTab} data:`, error);
		 	document.getElementById('tabData').innerHTML = '<p class="text-center text-danger">Error loading data</p>';	
		}finally{
			showLoading(false, null, loadingOverlay);
		}
	}else if(activeTab=='gt')  {
		try{
			let response = await fetch(`txn/orgcht?sid=${sid}&pid=${pid}`);
			if (!response.ok){
				if(response.status==401){
					showToast("Invalid Session , Redirecting to home page", 'danger');
					setTimeout(() => {
			           window.location.href = '/';
			        }, 2000);
				}else throw new Error('Failed to save details');
				return ;
			}
		   	const text = await response.text(); // get raw body
		   	if (!text) {
		    	document.getElementById('tabData').innerHTML = '<p>No data available</p>';
		       	return;
		   	}
	        let data = JSON.parse(text);
			
			if (data) {
				document.getElementById('tabData').innerHTML='<div id="treeContainer" style="overflow: auto; width: 100%; height: 600px;"><canvas id="treeCanvas"></canvas></div><div id="tooltip" class="tooltip" style="display: none;">';
				drawTree(data);
	        }
	        
		}catch (error) {
		 	console.error(`Error loading ${activeTab} data:`, error);
		 	document.getElementById('tabData').innerHTML = '<p class="text-center text-danger">Error loading data</p>';	
		}finally{
			showLoading(false, null, loadingOverlay);
		}
	}else if(activeTab=='ld'){
		try{
			response = await fetch(`txn/lvldl?sid=${sid}&pid=${pid}`);
			if (!response.ok){
				if(response.status==401){
					showToast("Invalid Session , Redirecting to home page", 'danger');
					setTimeout(() => {
			           window.location.href = '/';
			        }, 2000);
				}else throw new Error('Failed to save details');
				return ;
			}
		        
	        let data = await response.json();
			let tableContent = '<div id="table-responsive">';
			tableContent = '<table class="table table-striped"><thead><tr>';
			tableContent +='<th scope="col">Customer Id</th><th scope="col">Customer name</th><th scope="col">Position</th><th scope="col">Wallet Balance</th>';
			tableContent +='<th scope="col">Total funds added</th><th scope="col">Total packages bought</th><th scope="col">Total withdrawals</th>';
			tableContent +='</tr></thead><tbody>';
			if (data.length > 0) {
	            data.forEach(item => {
	                tableContent += `<tr><td scope="row">${item.customerId}</td><td scope="row">${item.customerName}</td><td scope="row">${item.position}</td><td scope="row">${item.totalBalance}</td>`;
					tableContent += `<td scope="row">${item.totalFundsAdded}</td><td scope="row">${item.totalPackagesBought}</td><td scope="row">${item.totalWithdrawals}</td></tr>`;
	            });
	        } else tableContent += '<tr><td colspan="5" style="text-align:center;border:none;">No data available</td></tr>';
	        tableContent += '</tbody></table></div>';
	        document.getElementById('tabData').innerHTML = tableContent;
		}catch (error) {
		 	console.error(`Error loading ${activeTab} data:`, error);
		 	document.getElementById('tabData').innerHTML = '<p class="text-center text-danger">Error loading data</p>';	
		}finally{
			showLoading(false, null, loadingOverlay);
		}
	}else{
		document.getElementById('tabData').innerHTML = '<p>No data available</p>';
		showLoading(false, null, loadingOverlay);
	}
}
function switchDlTab(event) {
	if(!document.getElementById("dldataTabs")) return ;
    document.querySelectorAll('.nav-link').forEach(tab => tab.classList.remove('active', 'disabled'));
    event.target.classList.add('active', 'disabled');
	reloadDLTabData();
}

async function showWithdrawModal(button) {
	const topupId = button.getAttribute('data-topup-id');
	const amount = button.getAttribute('data-amount');
	const idxFrm=document.getElementById('index');
	const sid=idxFrm.sid.value;
	const pid=idxFrm.pid.value;
	var realamount  = parseFloat(amount)*0.10;
	var payoutAmt= parseFloat(amount).toFixed(2) - realamount.toFixed(2)
	let modalBody = '';
    try {
        const response = await fetch(`txn/totwdw?sid=${sid}&pid=${pid}&topupId=${topupId}`);
        if (!response.ok) {
            if (response.status === 401) {
                showToast("Invalid Session, Redirecting to home page", 'danger');
                setTimeout(() => window.location.href = '/', 2000);
                return;
            }
            throw new Error("Failed to get withdrawal data.");
        }

        const totalWithdrawn = await response.json();
        console.log("Total withdrawn:", totalWithdrawn);

        const remaining = parseFloat(amount).toFixed(2) - parseFloat(totalWithdrawn).toFixed(2);
        if (remaining <= 0) {
			modalBody = `<div class="modal-body">This Top-up ID has already been used for a completed withdrawal.</div>`;
        }else if(totalWithdrawn==0){
			modalBody = 
			`<div class="modal-body">
				<table class="table table-borderless table-sm">
			      <tbody>
			        <tr>
			          <th scope="row" class="text-start">Topup Id</th>
			          <td class="text-muted">${topupId}</td>
			        </tr>
			        <tr>
			          <th scope="row" class="text-start">Original amount</th>
			          <td class="text-muted">₹${formatNumber(parseFloat(amount).toFixed(2))}</td>
			        </tr>
			        <tr>
			          <th scope="row" class="text-start">After 10% Fee</th>
			          <td class="text-primary fw-bold">₹${Math.ceil(formatNumber(payoutAmt.toFixed(2)))}</td>
			        </tr>
			      </tbody>
				</table>
				<p class="text-center mt-3 mb-0">Please click on <strong>Confirm</strong> to proceed.</p>
			 </div>
			 <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="confirmWithdraw('${topupId}', ${amount})">Confirm</button>
              </div>`;
		}else if(remaining>0){
			realamount  = parseFloat(remaining)*0.10;
			payoutAmt= parseFloat(remaining).toFixed(2) - realamount.toFixed(2);
			modalBody = 
				`<div class="modal-body">
					<p class="mt-3 mb-0">You have existing withdrawal requests totaling <strong>₹${formatNumber(parseFloat(totalWithdrawn).toFixed(2))}</strong>(approved or pending). Your current eligible withdrawal amount is  
					<strong>₹${formatNumber(parseFloat(remaining).toFixed(2))}</strong></p>
						<table class="table table-borderless table-sm">
					      <tbody>
					        <tr>
					          <th scope="row" class="text-start">Topup Id</th>
					          <td class="text-muted">${topupId}</td>
					        </tr>
					        <tr>
					          <th scope="row" class="text-start">Original amount</th>
					          <td class="text-muted">₹${formatNumber(parseFloat(amount).toFixed(2))}</td>
					        </tr>
							<tr>
					          <th scope="row" class="text-start">Remaining Amount</th>
					          <td class="text-muted">₹${formatNumber(parseFloat(remaining).toFixed(2))}</td>
					        </tr>
					        <tr>
					          <th scope="row" class="text-start">After 10% Fee on the remainign amount</th>
					          <td class="text-primary fw-bold">₹${Math.ceil(formatNumber(payoutAmt.toFixed(2)))}</td>
					        </tr>
					      </tbody>
						</table>
						<p class="text-center mt-3 mb-0">Please click on <strong>Confirm</strong> to proceed.</p>
				</div>
				<div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                <button type="button" class="btn btn-primary" onclick="confirmWithdraw('${topupId}', ${Math.ceil(parseFloat(remaining).toFixed(2))})">Confirm</button>
	              </div>`
		}
		const modalHtml = `
		        <div class="modal fade" id="withdrawModal" tabindex="-1" aria-labelledby="withdrawModalLabel" aria-hidden="true">
		          <div class="modal-dialog modal-dialog-centered">
		            <div class="modal-content">
		              <div class="modal-header">
		                <h5 class="modal-title" id="withdrawModalLabel">Confirm Withdrawal</h5>
		                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		              </div>
		              ${modalBody}
		            </div>
		          </div>
		        </div>`;
		
		// Show Bootstrap modal
		    

		    document.body.insertAdjacentHTML('beforeend', modalHtml);

		    const modal = new bootstrap.Modal(document.getElementById('withdrawModal'));
		    modal.show();

		    // Remove the modal from DOM after it's hidden
		    document.getElementById('withdrawModal').addEventListener('hidden.bs.modal', function () {
		        document.getElementById('withdrawModal').remove();
		    });
    } catch (error) {
        console.error("Error:", error);
        showToast("Error loading withdrawal data", 'danger');
    }
}
 
async function confirmWithdraw(topupId, amount) {
	const form = document.getElementById('index');
	let sid=form.sid.value;
	let pid=form.pid.value;
    const payload = {
        topupId: topupId,
        amount: amount,
		sid: sid,
		pid: pid
    };

    try {
		const modal = bootstrap.Modal.getInstance(document.getElementById('withdrawModal'));
		modal.hide();
		const loadingOverlay = document.getElementById('loadingOverlay');
		showLoading(true, null, loadingOverlay);
        const response = await fetch(`txn/wdwAmt`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });

        const data = await response.json();
        if (data && data.errorCode == 0) {
            showToast(data.message, 'success');
            reloadTabData(false);
        } else {
            showToast(data.message, 'danger');
        }
    } catch (err) {
        showToast('Something went wrong', 'danger');
    }finally{
		showLoading(false, null, loadingOverlay);
		// Close the modal manually after response
	   
	} 
}
function getStatusBadgeClass(status) {
    switch (status.toLowerCase()) {
        case 'active':
            return 'bg-success';    // Green
        case 'completed':
            return 'bg-primary';    // Blue
        case 'processing':
            return 'bg-warning';    // Yellow/Orange
        case 'withdrawan':          
            return 'bg-secondary';  // Grey
		case 'in progress':
		    return 'bg-warning'; 
        default:
            return 'bg-dark';       // Fallback
    }
}

function wdwhdlPgn(pgNm){
	gotoPage(pgNm,'withdrawal');
	return;
}
function tpuphdlPgn(pgNm){
	gotoPage(pgNm,'topup');
	return;
}

function fndrqhdlPgn(pgNm){
	gotoPage(pgNm,'fundTransfer');
	return;
}


async function gotoPage(pgNm,sctn){
	applyFilters(sctn,false,false);
	filterStates[sctn].page=pgNm;
    reloadSectionData(sctn);
	updatePaginationUI(pgNm,sctn);
}

function updatePaginationUI(crntPg,sctn) {
    const buttons = document.querySelectorAll('#'+sctn+'Pagination button');
    buttons.forEach(btn => {
        const pgNm = parseInt(btn.textContent.trim());
        if (pgNm === crntPg) {
            btn.classList.remove('btn-outline-primary');
			btn.classList.add('disabled');
            btn.classList.add('btn-primary');
			btn.disabled = true;
        } else {
            btn.classList.remove('btn-primary');
            btn.classList.add('btn-outline-primary');
			btn.classList.remove('disabled');
			btn.disabled = false;
        }
    });
}

async function recalPgn(sctn, queryParams,loadingOverlay) {
	try{
	 	showLoading(true, null, loadingOverlay);
	 	// Send another API call to get the new total count
	    const response = await fetch(`txn/${sctn}cnt?${queryParams.toString()}`); 
		 const totalRecords = await response.json();
		 const pageSize = 5; // or whatever your page size is
		 const totalPages = Math.ceil(totalRecords / pageSize);
	
		 // Rebuild pagination UI
		 const paginationDiv = document.getElementById(`${sctn}Pagination`);
		 paginationDiv.innerHTML = '';
	
		 if (totalPages > 1) {
		     for (let i = 1; i <= totalPages; i++) {
		         const btn = document.createElement('button');
		         btn.className = `btn btn-sm ${i === 1 ? 'btn-primary disabled' : 'btn-outline-primary'} m-1`;
		         btn.textContent = i;
		         btn.onclick = () => gotoPage(i, sctn);
		         paginationDiv.appendChild(btn);
		     }
		 }
	}catch (error) {
     console.error(`Error loading ${section} data:`, error);
     showToast(`Error loading ${section} data`, 'danger');
    }finally {
     showLoading(false, null, loadingOverlay);
    }
}

function wdwbnryAmt(button){
	const amount = button.getAttribute('data-tot-amt');
	var realamount  = parseFloat(amount)*0.10;
	var payoutAmt= parseFloat(amount).toFixed(2) - realamount.toFixed(2);
	const modalHtml = `
	        <div class="modal fade" id="withdrawBnryModal" tabindex="-1" aria-labelledby="withdrawModalLabel" aria-hidden="true">
	          <div class="modal-dialog modal-dialog-centered">
	            <div class="modal-content">
	              <div class="modal-header">
	                <h5 class="modal-title" id="withdrawModalLabel">Confirm Withdrawal</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	              </div>
	              <div class="modal-body">	                
					Original amount: <strong>₹${parseFloat(amount).toFixed(2)}</strong><br/>
					After a 10% fee, you'll receive:<strong>₹${Math.ceil(payoutAmt.toFixed(2))}</strong>.<br/>
					Please click on confirm to proceed.
	              </div>
	              <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                <button type="button" class="btn btn-primary" onclick="cnfrmBnrWdw(${amount})">Confirm</button>
	              </div>
	            </div>
	          </div>
	        </div>`;

	    document.body.insertAdjacentHTML('beforeend', modalHtml);

	    const modal = new bootstrap.Modal(document.getElementById('withdrawBnryModal'));
	    modal.show();

	    // Remove the modal from DOM after it's hidden
	    document.getElementById('withdrawBnryModal').addEventListener('hidden.bs.modal', function(){
	        document.getElementById('withdrawBnryModal').remove();
	    });
}

async function cnfrmBnrWdw(amount) {
	const form = document.getElementById('index');
	let sid=form.sid.value;
	let pid=form.pid.value;
    const payload = {
        amount: amount,
		sid: sid,
		pid: pid
    };

    try {
		const modal = bootstrap.Modal.getInstance(document.getElementById('withdrawBnryModal'));
		modal.hide();
		const loadingOverlay = document.getElementById('loadingOverlay');
		showLoading(true, null, loadingOverlay);
        const response = await fetch(`txn/wdwBnryAmt`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });

        const data = await response.json();
        if (data && data.errorCode == 0) {
            showToast(data.message, 'success');
            reloadTabData(false);
        } else {
            showToast(data.message, 'danger');
        }
    } catch (err) {
        showToast('Something went wrong', 'danger');
    }finally{
		showLoading(false, null, loadingOverlay);
	} 
}

function formatNumber(num) {
  // Fixed to 2 decimal places and add commas
  return num.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
