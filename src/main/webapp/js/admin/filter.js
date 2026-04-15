if (typeof filterStates === 'undefined') {
    var filterStates = {
        fundTransfer: {},
        withdrawal: {},
        topup: {},
        users: {}
    };
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
				jsonData.forEach(txn => {
					let row = document.createElement("tr"),dtRw='';
					if(tableId=="withdrawalTBL"){
						dtRw = `<td>#${txn.srNo}</td>`;
						dtRw+= "<td>"+txn.name+"</td><td>"+txn.custId+"</td>";
					} else dtRw = "<td>"+txn.name+"</td><td>"+txn.custId+"</td>";
					if(tableId=="withdrawalTBL") dtRw+="<td class='text-right'>₹"+txn.pkg+"</td><td class='text-right'>₹"+txn.intAmt+"</td>";
					dtRw+="<td class='text-right'>₹"+txn.txnAmt+"</td><td><span class='badge "+gtBdgCls(txn.txnSts)+"'>"+txn.txnSts+"</span></td><td>"+txn.txnDtTime+"</td>";
					if(tableId=="topupHisTBL") dtRw+= "<td>"+txn.expDt+"</td>";
					if(tableId=="withdrawalTBL"){
						if(txn.txnSts.toLowerCase()=="pending"){ dtRw+=`<td class="text-center"><input type="checkbox" class="txn-checkbox" 
						    data-id="${txn.txnId}" 
						    data-custid="${txn.custId}" 
						    data-bank="${txn.bname}" 
						    data-acctno="${txn.bAccno}" 
						    data-branch="${txn.bAcctbrch}" 
						    data-accthldr="${txn.bAcctHldrNm}" 
						    data-ifsc="${txn.bifscCode}" 
						    data-amt="${txn.txnAmt}" 
						    data-intamt="${txn.intAmt}"></td>`;;
						}else dtRw+='<td></td>';
					}
					row.innerHTML=dtRw;
					tbody.appendChild(row);
				});
				document.getElementById('bulkActions').style.display = 'none';
				if(tableId=="withdrawalTBL"){
					document.querySelectorAll('.txn-checkbox').forEach(cb => {
					    cb.addEventListener('change', () => {
					        const anyChecked = Array.from(document.querySelectorAll('.txn-checkbox')).some(c => c.checked);
					        document.getElementById('bulkActions').style.display = anyChecked ? 'block' : 'none';
					    });
					});
				}
			}
		}
// Initialize filters for each section

async function gotoPage(pgNm,sctn){
	applyFilters(sctn,true);
	filterStates[sctn].page=pgNm;
    reloadSectionData(sctn);
	updatePaginationUI(pgNm,sctn)
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
async function crtPgn(sctn,fltrs){
	if(!fltrs){
		applyFilters(sctn,true);
		filterStates[sctn].page=1;
		fltrs=filterStates[sctn];
	}
	const queryParams = new URLSearchParams();
    for (const [key, value] of Object.entries(fltrs)) {
        if (value) queryParams.append(key, value);
    }
	const form = document.getElementById('index');
	const formData = new FormData(form);

	for (const [key, value] of formData.entries()) {
	    if (value) queryParams.append(key, value);
	}
	try{
	 	showLoading(true, null, loadingOverlay);
	 	// Send another API call to get the new total count
	    const response = await fetch(`admin/dt/${sctn}cnt?${queryParams.toString()}`); 
		 const totalRecords = await response.json();
		 const pageSize = 10; // or whatever your page size is
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
	addSvBnkDtlsEvtLstnr(); //Save bank details
	addUpdPwdEvtLstnr();//Change password
	addFndsEvtLstnr();//Add Funds
	addPkgEvtLstnr(); //Purchase package
	addExportvtLstnr();
}
function addUpdPwdEvtLstnr() {
	document.getElementById('chngpwd').addEventListener('submit', async function(e) {
	    e.preventDefault();
	    
	    // Get the modal instance
	    const modal = bootstrap.Modal.getInstance(document.getElementById('chngPwdModal'));
	    const formData = new FormData(this);
		const frmObj = Object.fromEntries(formData);
		if(frmObj.password.length==0){
			showToast("New Password field cannot be empty", 'danger');
			return;
		} else if(frmObj.newpwd.length==0){
			 showToast("Confirm Password field cannot be empty", 'danger');
			 return;
		}else if(frmObj.password.length!=frmObj.newpwd.length){
			showToast("New password and confirm passsword mismatching", 'danger');
			return;
		}
		const idxFrm=document.getElementById('index');
	    try {
	        // Show loading state (optional)
	        const saveBtn = document.querySelector('#chngPwdModal .modal-footer .btn-primary');
	        saveBtn.disabled = true;
	        saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> updating...';
	        
	        // Make the API call
	        const response = await fetch('admin/dt/chngpwd', {
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
			           window.location.href = 'admin';
			        }, 2000);
				}else throw new Error('Failed to update the password');
				return ;
			} 
	        
	        const result = await response.json();
	        
	        // Show success toast
			if(result!=null){
				var message=result.message;
				if(message=='0') showToast('Password updated successfully!', 'success');
				else showToast(message, 'danger');	
			}
	        
	        
	        // Close the modal after a short delay
	        setTimeout(() => {
	            modal.hide();
	            // Reset form and button state
	            this.reset();
	            saveBtn.disabled = false;
	            saveBtn.textContent = 'Update';
	        }, 1000);
	        
	    } catch (error) {
	        console.error('Error saving bank details:', error);
	        showToast('Error saving bank details: ' + error.message, 'danger');
	        
	        // Reset button state
	        const saveBtn = document.querySelector('#chngPwdModal .modal-footer .btn-primary');
	        saveBtn.disabled = false;
	        saveBtn.textContent = 'Update';
	    }
	});
    
}
function addPkgEvtLstnr() {
	document.getElementById('addPackage').addEventListener('submit', async function(e) {
	    e.preventDefault();
	    
	    // Get the modal instance
	    const modal = bootstrap.Modal.getInstance(document.getElementById('addPackageModal'));
	    const formData = new FormData(this);
		const idxFrm=document.getElementById('index');
	    
	    try {
	        // Show loading state (optional)
	        const saveBtn = document.querySelector('#addPackageModal .modal-footer .btn-primary');
	        saveBtn.disabled = true;
	        saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Purchasing...';
	        
	        // Make the API call
	        const response = await fetch('admin/dt/purchase', {
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
			           window.location.href = 'admin';
			        }, 2000);
				}else throw new Error('Failed to purchase the package');
			}
	        
	        const result = await response.json();
	        
			// Show success toast
			if(result!=null){
				var cd=result.eC;
				if(cd=='0') showToast(result.eM, 'success');
				else showToast(result.eM, 'danger');	
			}
	        
	        
	        // Close the modal after a short delay
	        setTimeout(() => {
	            modal.hide();
	            // Reset form and button state
	            this.reset();
	            saveBtn.disabled = false;
	            saveBtn.textContent = 'Purchase';
	        }, 1000);
	        
	    } catch (error) {
	        console.error('Error saving bank details:', error);
	        showToast('Error adding the package: ' + error.message, 'danger');
	        
	        // Reset button state
	        const saveBtn = document.querySelector('#addPackageModal .modal-footer .btn-primary');
	        saveBtn.disabled = false;
	        saveBtn.textContent = 'Purchase';
	    }
	});
    
}

function addFndsEvtLstnr() {
	document.getElementById('addFnds').addEventListener('submit', async function(e) {
	    e.preventDefault();
	    
	    // Get the modal instance
	    const modal = bootstrap.Modal.getInstance(document.getElementById('addFundsModal'));
	    const formData = new FormData(this);
		const idxFrm = document.getElementById('index');
	    
	    try {
	        // Show loading state (optional)
	        const saveBtn = document.querySelector('#addFundsModal .modal-footer .btn-primary');
	        saveBtn.disabled = true;
	        saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adding...';
	        
	        // Make the API call
	        const response = await fetch('admin/dt/addFunds', {
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
			           window.location.href = 'admin';
			        }, 2000);
				}else throw new Error('Failed to add funds');
				return ;
	        }
	        
	        const result = await response.json();
	        
	        // Show success toast
			if(result!=null){
				var cd=result.eC;
				if(cd=='0') showToast(result.eM, 'success');
				else showToast(result.eM, 'danger');	
			}
	        
	        
	        // Close the modal after a short delay
	        setTimeout(() => {
	            modal.hide();
	            // Reset form and button state
	            this.reset();
	            saveBtn.disabled = false;
	            saveBtn.textContent = 'Add Funds';
	        }, 1000);
	        
	    } catch (error) {
	        console.error('Error saving bank details:', error);
	        showToast('Error saving bank details: ' + error.message, 'danger');
	        
	        // Reset button state
			const saveBtn = document.querySelector('#addFundsModal .modal-footer .btn-primary');
	        saveBtn.disabled = false;
	        saveBtn.textContent = 'Add Funds';
	    }
	});
    
}

function addSvBnkDtlsEvtLstnr() {
	document.getElementById('svbnkdtl').addEventListener('submit', async function(e) {
	    e.preventDefault();
	    
	    // Get the modal instance
	    const modal = bootstrap.Modal.getInstance(document.getElementById('bankDtls'));
	    const formData = new FormData(this);
		const idxFrm=document.getElementById('index');
	    
	    try {
	        // Show loading state (optional)
	        const saveBtn = document.querySelector('#bankDtls .modal-footer .btn-primary');
	        saveBtn.disabled = true;
	        saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
	        
	        // Make the API call
	        const response = await fetch('admin/dt/saveDetails', {
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
			           window.location.href = 'admin';
			        }, 2000);
				}else throw new Error('Failed to save bank details');
				return ;
	        }
	        
	        const result = await response.json();
	        
	        // Show success toast
			if(result!=null){
				var message=result.message;
				if(message=='0') showToast('Bank details saved successfully!', 'success');
				else showToast(message, 'danger');	
				reloadSectionData("users");
			}
	        
	        
	        // Close the modal after a short delay
	        setTimeout(() => {
	            modal.hide();
	            // Reset form and button state
	            this.reset();
	            saveBtn.disabled = false;
	            saveBtn.textContent = 'Save';
	        }, 1000);
	        
	    } catch (error) {
	        console.error('Error saving bank details:', error);
	        showToast('Error saving bank details: ' + error.message, 'danger');
	        
	        // Reset button state
	        const saveBtn = document.querySelector('#bankDtls .modal-footer .btn-primary');
	        saveBtn.disabled = false;
	        saveBtn.textContent = 'Save';
	    }
	});
    
}

// Set up event listeners for all filter buttons
function addFltrEvtLstnr() {
    // Fund Transfer filters
    document.getElementById('applyFundTransferFilters').addEventListener('click', () => {
        applyFilters('fundTransfer');
    });
    document.getElementById('resetFundTransferFilters').addEventListener('click', () => {
        resetFilters('fundTransfer');
    });
    
    // Withdrawal filters
    document.getElementById('applyWithdrawalFilters').addEventListener('click', () => {
        applyFilters('withdrawal');
    });
    document.getElementById('resetWithdrawalFilters').addEventListener('click', () => {
        resetFilters('withdrawal');
    });
    
    // Topup filters
    document.getElementById('applyTopupFilters').addEventListener('click', () => {
        applyFilters('topup');
    });
    document.getElementById('resetTopupFilters').addEventListener('click', () => {
        resetFilters('topup');
    });
    
    // Users filters
    document.getElementById('applyUsersFilters').addEventListener('click', () => {
        applyFilters('users');
    });
    document.getElementById('resetUsersFilters').addEventListener('click', () => {
        resetFilters('users');
    });
	
	// Users filters
    document.getElementById('applyDLFilters').addEventListener('click', () => {
        applyDLFilters('users');
    });
    document.getElementById('resetDLFilters').addEventListener('click', () => {
        resetDLFilters('users');
    });
}

// Apply filters for a specific section
function applyFilters(section,sb) {
    // Get filter values
    const filters = {
        fromDate: document.getElementById(`${section}FromDate`).value,
        toDate: document.getElementById(`${section}ToDate`).value
    };
    let clPgn = false;
    // Section-specific filtersdocument.getElementById(`${section}FromDate`)
	if(filters.toDate<filters.fromDate)  {
		showToast("To date can't be less than From Date", 'danger');
		return ;
	}
    if (section === 'fundTransfer') {
        filters.status = document.getElementById('fundTransferStatus').value;
		clPgn=true;
		
    } 
    else if (section === 'withdrawal') {
        filters.status = document.getElementById('withdrawalStatus').value;
		filters.searchBy = document.getElementById('wdwSearch').value;
		clPgn=true;
    } 
    else if (section === 'topup') {       
        filters.packageId = document.getElementById('topupPackage').value;
		filters.status = document.getElementById('topupStatus').value;
		clPgn=true;
    } 
    else if (section === 'users') {
        filters.searchBy = document.getElementById('usersSearch').value;
		clPgn=false;
    }
    
    // Save filter state
    filterStates[section] = filters;
    if(sb) return;
    // Reload data with filters
	if (section !== 'users') filters.page=1;
    reloadSectionData(section);
	if(clPgn) crtPgn(section,filters);
}

// Reset filters for a specific section
function resetFilters(section,sb) {
    // Reset date inputs to default (last 30 days)
    const defaultFromDate = new Date();
    defaultFromDate.setDate(defaultFromDate.getDate() - 30);
    const formatDate = (date) => date.toISOString().split('T')[0];
   	let clPgn=false;
	document.getElementById(`${section}FromDate`).value = '';
	document.getElementById(`${section}ToDate`).value = '';
    
    // Reset other inputs
    if (section === 'fundTransfer') {
        document.getElementById('fundTransferStatus').value = '';
		clPgn=true;
    } 
    else if (section === 'withdrawal') {
        document.getElementById('withdrawalStatus').value = '';
		document.getElementById('wdwSearch').value='';
		clPgn=true;
    } 
    else if (section === 'topup') {
        document.getElementById('topupPackage').value = '';
		document.getElementById('topupStatus').value = '';
		clPgn=true;
    } 
    else if (section === 'users') {
        document.getElementById('usersSearch').value = '';
		clPgn=false;
    }
    
    // Clear filter state
    filterStates[section] = {};
    if(sb) return;
    // Reload data without filters
    reloadSectionData(section);
	if(clPgn)crtPgn(section,{});
}

// Reload data for a section with current filters
async function reloadSectionData(section) {
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
        
        const response = await fetch(`admin/dt/${section}?${queryParams.toString()}`);
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = 'admin';
		        }, 2000);
			}else throw new Error('Failed to load data');
		}
        
        const data = await response.json();
        
        // Update the section with the filtered data
        if (section === "fundTransfer") {
            populateDataTBL("fundTransferTBL", data);
        } 
        else if (section === "withdrawal") {
            populateDataTBL("withdrawalTBL", data);
        } 
        else if (section === "topup") {
            const tbody = document.querySelector("#topupPkgsTBL tbody");
            tbody.innerHTML = "";
            if (data.pkgs.length === 0) {
                tbody.innerHTML = `<tr><td colspan="2" style="text-align:center;">No packages found</td></tr>`;
            } else {
                data.pkgs.forEach(pkg => {
                    let row = document.createElement("tr");
                    row.innerHTML = `<td>${pkg.pkg_nm}</td><td>₹${pkg.pkg_amt}</td>`;
                    tbody.appendChild(row);
                });
            }
            populateDataTBL("topupHisTBL", data.tpupdt);
            updatePackageChart(data.perfChrt);
        }else if (section === "users") {
            const tbody = document.querySelector("#usersTBL tbody");
            tbody.innerHTML = "";
            if (data.length === 0) {
                tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;">No users found</td></tr>`;
            } else {
                data.forEach(txn => {
					let row = document.createElement("tr");
					row.innerHTML = "<td>"+txn.custId+"</td><td>"+txn.name+"</td><td>"+txn.email+"</td><td>"+txn.number+"</td><td>"+txn.createdDt+"</td><td><span class='mreinf' onclick=\"moreinfo('" + txn.custId + "', event)\">More info</span></td>";
					row.innerHTML +="<td><span class='mreinf' data-custid='"+txn.custId+"' data-bank='"+txn.bankNm+"' data-acctno='"+txn.accountNo+"' data-branch='"+txn.brnchNm+"' data-accthldr='"+txn.accHldNm+"' data-ifsc='"+txn.ifscCd+"' onclick=swbnkDtls(this)>Add </span></td>";
					row.innerHTML +="<td><span class='mreinf' onclick=\"swChngPwdMdl('" + txn.custId + "', event)\">Click here</span></td>";
					tbody.appendChild(row);

                });
            }
        }
    } catch (error) {
        console.error(`Error loading ${section} data:`, error);
        showToast(`Error loading ${section} data`, 'danger');
    } finally {
        showLoading(false, null, loadingOverlay);
    }
}
function swChngPwdMdl(custId){
	const modal = new bootstrap.Modal(document.getElementById('chngPwdModal'));
	if(custId&&custId!="-"&&custId.length>0){		
		if(document.getElementById('chngPwdModal')){
		    frm = document.getElementById("chngpwd")
		    frm.custId.value=custId;
		}
	}
	modal.show();	
}
function swbnkDtls(ev){
    const custId = ev.getAttribute('data-custid');
    const bnm = ev.getAttribute('data-bank');
    const acctNo = ev.getAttribute('data-acctno');
    const acctHldrNm = ev.getAttribute('data-accthldr');
    const acctbrch = ev.getAttribute('data-branch');
    const ifscCd = ev.getAttribute('data-ifsc');
	const modal = new bootstrap.Modal(document.getElementById('bankDtls'));
	frm = document.getElementById("svbnkdtl");
	if(acctNo&&acctNo!="-"&&acctNo.length>0){	
	    frm.custId.value=custId;
		frm.accountNo.value=acctNo;
		frm.accountHolderName.value=acctHldrNm;
		frm.accountBranch.value=acctbrch;
		frm.ifsCode.value=ifscCd;
		frm.bankName.value=bnm;
	}else {
		frm.custId.value="";
		frm.accountNo.value="";
		frm.accountHolderName.value="";
		frm.accountBranch.value="";
		frm.ifsCode.value="";
		frm.bankName.value="";
	}
	modal.show();	
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

function gtBdgCls(status ){
	switch (status.toLowerCase()) {
	        case 'active':return 'bg-success';    // Green
	        case 'completed':return 'bg-primary';    // Blue
	        case 'processing':return 'bg-warning';    // Yellow/Orange
			case 'pending':return 'bg-warning';    // Yellow/Orange
	        case 'failed':return 'bg-danger';
	        case 'withdrawan':    return 'bg-secondary';      // typo fallback
			case 'success':return 'bg-success';
			case 'approved':return 'bg-success';
			case 'rejected':return 'bg-danger';  
	        default: return 'bg-dark'; 
		}
}

async function handleWdwSts(trasId,typ,custId){
	const form = document.getElementById('index');
	let sid=form.sid.value;
	let pid=form.pid.value;
    const payload = {
		transId: trasId,
		type:typ,
		custId:custId,
		sid: sid,
		pid: pid
    };
	try {
		const loadingOverlay = document.getElementById('loadingOverlay');
		showLoading(true, null, loadingOverlay);
        const response = await fetch(`admin/dt/hdlwdw`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = 'admin';
		        }, 2000);
			}else throw new Error('Failed to approve/Reject transaction');
        }
        
        const result = await response.json();
        
        // Show success toast
		if(result!=null){
			var message=result.message;
			if(message=='0'){
				showToast('Withdrwal request successfully updated', 'success');
				reloadSectionData("withdrawal");
			} 
			else showToast(message, 'danger');	
		}
    } catch (err) {
        showToast('Something went wrong', 'danger');
    }finally{
		showLoading(false, null, loadingOverlay);
		// Close the modal manually after response
	   
	} 
}

async function moreinfo(custId,e){
	e.preventDefault();
	const modalEl = document.getElementById('usrDtlsModal');
	const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
	modal.show();
	const tbody = document.querySelector('#usrDtlsModal tbody');
	try {
		const loadingOverlay = document.getElementById('loadingOverlay');
		showLoading(true, null, loadingOverlay);
		const queryParams = new URLSearchParams();
		queryParams.append("custId", custId);
		const form = document.getElementById('index');
		const formData = new FormData(form);

		for (const [key, value] of formData.entries()) {
		    if (value) queryParams.append(key, value);
		}
		const response = await fetch(`admin/dt/usrdshbrd?${queryParams.toString()}`);
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = 'admin';
		        }, 2000);
			}else throw new Error('Failed to load data');
		}
	    
	    const data = await response.json();
		if(data.length==0){
			tbody.innerHTML = '<tr><td colspan="6">No Data available</td></tr>';
		}else {
			const usrdtls= data.usrDBdtls;
			tbody.innerHTML = `
			           <tr>
			               <td>${custId}</td>
			               <td>${usrdtls.activeDirects || '-'}</td>
			               <td>${usrdtls.availableBalance || '-'}</td>
			               <td>${usrdtls.leftBusiness || '-'}</td>
			               <td>${usrdtls.rightBusiness || '-'}</td>
			               <td>${usrdtls.totalWithdrawals || '-'}</td>
			           </tr>
			       `;
		}
	}catch (err) {
     	showToast('Something went wrong', 'danger');
    }finally{
		showLoading(false, null, loadingOverlay);
	}
}
async function doLogout(){
	const form = document.getElementById('index');
	let sid=form.sid.value;
	let pid=form.pid.value;
	const response = await fetch(`auth/logout?sid=${sid}&pid=${pid}`);
	if(response.ok){
		window.location.href = "admin";
	}else {
		showToast('Something went wrong', 'danger');
	}	    
}

function addExportvtLstnr(){
	document.getElementById('wdwpdf').addEventListener('click', () => {
        downloadPdf('withdrawal','Withdrawals_Report');
    });
	document.getElementById('fndtrnspdf').addEventListener('click', () => {
        downloadPdf('fundTransfer', 'Fundtransfers_Report');
    });
	document.getElementById('topuppdf').addEventListener('click', () => {
        downloadPdf('topup', 'Topups_Report');
    });
}
async function downloadPdf(urlNm,flNm,flty){
	const loadingOverlay = document.getElementById('loadingOverlay');
	showLoading(true, null, loadingOverlay);
	flty=flty?flty:"xlsx";
	try {
		const queryParams = new URLSearchParams();
		applyFilters(urlNm,true);
	    for (const [key, value] of Object.entries(filterStates[urlNm])) {
	        if (value) queryParams.append(key, value);
	    }
		const form = document.getElementById('index');
		const formData = new FormData(form);
	
		for (const [key, value] of formData.entries()) {
		    if (value) queryParams.append(key, value);
		}
		const response = await fetch(`dwnld${flty}/${urlNm}.${flty}?${queryParams.toString()}`);
		if (!response.ok){
			if(response.status==401){
				showToast("Invalid Session , Redirecting to home page", 'danger');
				setTimeout(() => {
		           window.location.href = 'admin';
		        }, 2000);
			}else throw new Error('Failed to load data');
		}
		const blob = await response.blob(); // Get the file as a blob
		const link = document.createElement('a');
		link.href = URL.createObjectURL(blob); // Create a URL for the blob
		const today = new Date();
		const yyyy = today.getFullYear();
		const mm = String(today.getMonth() + 1).padStart(2, '0'); // Months are 0-indexed
		const dd = String(today.getDate()).padStart(2, '0');
		const formattedDate = `${yyyy}${mm}${dd}`;
		link.download = `${flNm}_${formattedDate}.${flty}`; // Specify the file name
		link.click();
		showLoading(false, null, loadingOverlay);
	}catch (error) {
        console.error(`Error downloading ${urlNm} pdf:`, error);
        showToast(`Error downloading ${urlNm} data`, 'danger');
    } finally {
        
    }
}

function swAprveMdl(txnId,sts,custId,bnm,acctHldrNm,acctbrch,acctNo,ifscCd,actAmt,intAmt) {
    // Show Bootstrap modal
	let modalBody = '';
	if (acctNo && acctNo.trim() !== ''&&acctNo.trim() !== '-'&&acctNo !="null") modalBody = `
	<div class="modal-body">
	    <table class="table table-borderless table-sm">
	      <tbody>
	        <tr>
	          <th scope="row" class="text-start">Transaction Id</th>
	          <td class="text-muted">${txnId}</td>
	        </tr>
	        <tr>
	          <th scope="row" class="text-start">Account Number</th>
	          <td class="text-muted">${acctNo}</td>
	        </tr>
	        <tr>
	          <th scope="row" class="text-start">Account Holder Name</th>
	          <td class="text-muted">${acctHldrNm}</td>
	        </tr>
			<tr>
			  <th scope="row" class="text-start">Bank Name</th>
			  <td class="text-muted">${bnm}</td>
			</tr>
	        <tr>
	          <th scope="row" class="text-start">Branch Name</th>
	          <td class="text-muted">${acctbrch}</td>
	        </tr>
	        <tr>
	          <th scope="row" class="text-start">IFSC Code</th>
	          <td class="text-muted">${ifscCd}</td>
	        </tr>
	        <tr>
	          <th scope="row" class="text-start">Original Amount</th>
	          <td class="text-success">₹${parseFloat(intAmt).toFixed(2)}</td>
	        </tr>
	        <tr>
	          <th scope="row" class="text-start">After 10% Fee</th>
	          <td class="text-primary fw-bold">₹${parseFloat(actAmt).toFixed(2)}</td>
	        </tr>
	      </tbody>
	    </table>
	    <p class="text-center mt-3 mb-0">Please click on <strong>Confirm</strong> to proceed.</p>
	  </div><div class="modal-footer">
		<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
		<button type="button" class="btn btn-primary" data-bs-dismiss="modal" onclick="handleWdwSts('${txnId}', '${sts}', '${custId}')">Confirm</button>
		</div>`;
	else modalBody = `<div class="modal-body text-danger">
	      Cannot proceed: Bank account number is not available for this user.
	    </div>
	    <div class="modal-footer">
	      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
	    </div>`;

	const modalHtml = `
	  <div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-centered">
	      <div class="modal-content">
	        <div class="modal-header">
	          <h5 class="modal-title" id="withdrawModalLabel">${acctNo && acctNo.trim() !== '' ? 'Please check the details' : 'Missing Bank Details'}</h5>
	          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	        </div>
	        ${modalBody}
	      </div>
	    </div>
	  </div>`;

    document.body.insertAdjacentHTML('beforeend', modalHtml);

    const modal = new bootstrap.Modal(document.getElementById('approveModal'));
    modal.show();

    // Remove the modal from DOM after it's hidden
    document.getElementById('approveModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('approveModal').remove();
    });
}
function swBulkCnfMdl(actTyp) {
    const selected = Array.from(document.querySelectorAll('.txn-checkbox:checked'));
    if (selected.length === 0) {
        showToast("Please select at least one transaction", 'warning');
        return;
    }

    let modalBody = `<div class="modal-body"><div class="table-responsive"><table class="table table-bordered table-sm">
        <thead class="table-light">
            <tr>
                <th>#</th>
                <th>Transaction ID</th>
                <th>Customer ID</th>
                <th>Account No</th>
				<th>Account Holder Name</th>
				<th>Bank Name</th>
                <th>Branch</th>
                <th>IFSC Code</th>
                <th class='text-right'>Original Amt</th>
                <th class='text-right'>Final Amt</th>
            </tr>
        </thead><tbody>`;

    let invalid = false;

    selected.forEach((cb, i) => {
        const txnId = cb.getAttribute('data-id');
        const custId = cb.getAttribute('data-custid');
        const bnm = cb.getAttribute('data-bank');
        const acctNo = cb.getAttribute('data-acctno');
        const acctHldrNm = cb.getAttribute('data-accthldr');
        const acctbrch = cb.getAttribute('data-branch');
        const ifscCd = cb.getAttribute('data-ifsc');
        const intAmt = cb.getAttribute('data-intamt');
        const actAmt = cb.getAttribute('data-amt');

        // If any required value is missing, prevent approval
        if (!acctNo || acctNo.trim() === '' || acctNo === '-' || acctNo === 'null') {
            invalid = true;
        }

        modalBody += `
            <tr>
                <td>${i + 1}</td>
                <td>${txnId}</td>
                <td>${custId}</td>
				<td>${acctNo}</td>
				<td>${acctHldrNm}</td>
                <td>${bnm}</td>
                <td>${acctbrch}</td>
                <td>${ifscCd}</td>
                <td class='text-right'>₹${formatNumber(parseFloat(intAmt.replaceAll(",","")).toFixed(2))}</td>
                <td class='text-right'><b class="text-primary">₹${formatNumber(parseFloat(actAmt.replaceAll(",","")).toFixed(2))}</b></td>
            </tr>`;
    });
	const actTxt = actTyp === 'Approved' ? 'approve': (actTyp === 'Rejected' ? 'reject' : 'process');
    modalBody += `</tbody></table></div>
        <p class="text-center mt-2 mb-0">Please click <strong>Confirm</strong> to ${actTxt} all selected transactions.</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>`;

    if(!invalid)  modalBody += `<button type="button" class="btn btn-primary" data-bs-dismiss="modal" onclick="handleBulkWdwSts('${actTyp}')">Confirm</button>`;
    else modalBody += `<button type="button" class="btn btn-warning" disabled>Missing Bank Info</button>`;
    modalBody += `</div>`;

    const modalHtml = `
        <div class="modal fade" id="bulkApproveModal" tabindex="-1" aria-labelledby="bulkApproveModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Bulk Approval Preview</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    ${modalBody}
                </div>
            </div>
        </div>`;

    document.body.insertAdjacentHTML('beforeend', modalHtml);
    const modal = new bootstrap.Modal(document.getElementById('bulkApproveModal'));
    modal.show();

    document.getElementById('bulkApproveModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('bulkApproveModal').remove();
    });
}
async function handleBulkWdwSts(actionType) {
    const selected = Array.from(document.querySelectorAll('.txn-checkbox:checked'));
    if (selected.length === 0) {
        showToast("Please select at least one transaction", 'warning');
        return;
    }

    const form = document.getElementById('index');
    const sid = form.sid.value;
    const pid = form.pid.value;

    const payload = {
        type: actionType,
        sid: sid,
        pid: pid,
        transactions: selected.map(cb => ({
            transId: cb.getAttribute('data-id'),
            custId: cb.getAttribute('data-custid')
        }))
    };

    try {
        const loadingOverlay = document.getElementById('loadingOverlay');
        showLoading(true, null, loadingOverlay);

        const response = await fetch(`admin/dt/hdlwdw`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });

        if (!response.ok) {
            if (response.status === 401) {
                showToast("Invalid Session, Redirecting to home page", 'danger');
                setTimeout(() => window.location.href = 'admin', 2000);
            } else {
                throw new Error('Failed to perform bulk action');
            }
        }

        const result = await response.json();
        if (result != null) {
            const message = result.message;
            if (message === '0') {
                showToast(`Withdrawal requests successfully ${actionType.toLowerCase()}`, 'success');
                reloadSectionData("withdrawal");
            } else {
                showToast(message, 'danger');
            }
        }
    } catch (err) {
        console.error(err);
        showToast('Something went wrong', 'danger');
    } finally {
        showLoading(false, null, loadingOverlay);
    }
}
function formatNumber(num) {
  // Fixed to 2 decimal places and add commas
  return num.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
// Initialize filters when DOM is loaded
document.addEventListener('DOMContentLoaded', initFilters);