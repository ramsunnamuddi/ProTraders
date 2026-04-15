async function reloadDLTabData() {
	if(!document.getElementById("dldataTabs")) return ;
    let activeTab = document.querySelector('.dl-nav-link.active').getAttribute('data-tab');
	const loadingOverlay = document.getElementById('loadingOverlay');
	showLoading(true, null, loadingOverlay);
	const idxFrm=document.getElementById('index');
	const sid=idxFrm.sid.value;
	const pid=idxFrm.pid.value;
	var custId=document.getElementById('dlusrsrch').value;
	try{
		if(activeTab!='au'&&(custId==null ||custId.length==0)){
			document.getElementById("tabData").innerText="Please search for a customer";
			return ;
		}else  document.getElementById("tabData").innerText="";
		
		if(activeTab=='tt')  {		
			try{
				response = await fetch(`admin/dt/totTm?sid=${sid}&pid=${pid}&cid=${custId}`);
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
				let response = await fetch(`admin/dt/orgcht?sid=${sid}&pid=${pid}&cid=${custId}`);
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
				response = await fetch(`admin/dt/lvldl?sid=${sid}&pid=${pid}&cid=${custId}`);
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
				tableContent +='<th scope="col">Customer Id</th><th scope="col">Customer name</th><th scope="col">Position</th><th scope="col"  class="text-right">Wallet Balance</th>';
				tableContent +='<th scope="col"  class="text-right">Total funds added</th><th scope="col"  class="text-right">Total packages bought</th><th scope="col"  class="text-right">Total withdrawals</th>';
				tableContent +='</tr></thead><tbody>';
				if (data.length > 0) {
		            data.forEach(item => {
		                tableContent += `<tr><td scope="row">${item.customerId}</td><td scope="row">${item.customerName}</td><td scope="row">${item.position}</td><td scope="row"  class="text-right">${item.totalBalance}</td>`;
						tableContent += `<td scope="row"  class="text-right">${item.totalFundsAdded}</td><td scope="row"  class="text-right">${item.totalPackagesBought}</td><td scope="row" class="text-right">${item.totalWithdrawals}</td></tr>`;
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
		}else if(activeTab=='au'){
			try{
				response = await fetch(`admin/dt/actvusrs?sid=${sid}&pid=${pid}&cid=${custId}`);
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
				tableContent +='<th scope="col">Customer Id</th><th scope="col">Customer name</th><th scope="col" class="text-right">Package</th><th scope="col">Purchase Date</th><th scope="col">Expiration Date</th>';
				tableContent +='</tr></thead><tbody>';
				if (data.length > 0) {
		            data.forEach(item => {
		                tableContent += `<tr><td scope="row">${item.custId}</td><td scope="row">${item.customerName}</td><td scope="row"  class="text-right">${item.pkg}</td><td scope="row">${item.tpdt}</td><td scope="row">${item.expdt}</td>`;
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
	}catch (error) {
       console.error(`Error loading ${section} data:`, error);
       showToast(`Error loading ${section} data`, 'danger');
   	} finally {
       showLoading(false, null, loadingOverlay);
   	}
}
function switchDlTab(event) {
	if(!document.getElementById("dldataTabs")) return ;
    document.querySelectorAll('.nav-link').forEach(tab => tab.classList.remove('active', 'disabled'));
    event.target.classList.add('active', 'disabled');
	reloadDLTabData();
}

function applyDLFilters(){
	reloadDLTabData();
}

function resetDLFilters(){
	document.getElementById('dlusrsrch').value="";
	reloadDLTabData();
}