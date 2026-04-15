<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ProTraders</title>
	<!-- jQuery -->
    <script src="<c:url value='/js/jquery-3.7.1.min.js' />"></script>
    <script src="<c:url value='/js/jquery-ui.min.js' />"></script>
	<!-- jQGrid CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css">
	<!-- jQGrid JS -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/jquery.jqgrid.min.js"></script>
	<!-- jQuery UI (for styling) -->
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<link rel="stylesheet" href="<c:url value='/fonts/font.css' />">
	<link rel="stylesheet" href="<c:url value='/css/common.css' />">
	<script src="<c:url value='/js/common/jqGridInit.js'/>"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<style>
	.container {
		text-align: center;
		height: 80px;
		float: right;
		margin-left: 400px;
		align-content: center;
	}

	button, input[type="file"] {
	  padding: 12px;
	  margin: 10px;
	  cursor: pointer;
	}

	.popup {
	  display: none;
	  position: fixed;
	  top: 0;
	  left: 0;
	  width: 100%;
	  height: 100%;
	  background-color: rgba(0, 0, 0, 0.6);
	}

	.popup-content {
	  background-color: #ffffff;
	  padding: 20px;
	  border-radius: 10px;
	  width: 320px;
	  margin: 100px auto;
	  text-align: center;
	  box-shadow: 0 4px 10px rgba(0,0,0,0.3);
	}

	#qrcode img {
	  width: 200px;
	  height: 200px;
	  margin-top: 10px;
	}

	.tppopup-content .tpup-close-btn {
	  position: absolute;
	  top: 10px;
	  right: 15px;
	  cursor: pointer;
	}
	.tppopup {
		display: none;
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, 0.5);
		z-index: 999;
	}

	.tppopup-content {
		background-color: #fff;
		padding: 20px;
		border-radius: 8px;
		width: 400px;
		position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		box-shadow: 0 4px 8px rgba(0,0,0,0.1);
		min-height:400px;
	}

	.close-btn {
		float: right;
		font-size: 20px;
		cursor: pointer;
	}
	div#packageList {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		grid-template-rows: auto;
		gap: 5px;
		width: 80%;
		max-width: 100px;
		margin-top: 20px;
		padding: 10px;
	}
	.package-div {
		color: #888888;
		background-color: #666666;
		padding: 20px;
		border-radius: 12px;
		box-shadow: 3px 3px 12px rgba(0, 0, 0, 0.15);
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		height: 20px;
		transition: 0.3s ease-in-out;
	}
	.package-div:hover {
		transform: scale(1.05);
		box-shadow: 5px 5px 18px rgba(0, 0, 0, 0.2);
		color: #ffffff;
	}
	.package-div.selected {
		 background: linear-gradient(145deg, #000000, #1a1a1a);
		color: white;
		border-color: #000000;
	}
	
	.filters{
		margin: 15px 0px 15px 0px;
		width: 100%;
		left: 0;
		margin: 15px 0px 15px 0px;
		width: 100%;
		display: flex !important;
		flex-direction: row;
		align-items: anchor-center;
		gap:15px;
	}
	div#addFundsBtn, div#topupBtn {
		display:flex;
		float: right;
		cursor: pointer;
	}
	.addFunds, .topup{
		display: flex;
		align-items: anchor-center;
		padding: 5px;
		font-weight: bold;
		font-family: 'OpenSans';
	}
	.popup-content h2 {
		font-family: 'OpenSans';
		font-size: 15px;
	}
	#noFundsMessage{
		color: red;
		font-family: OpenSans;
		padding: 20px;
	}
	button#submitBtn {
		width: 100%;
	}
	span#avl-bal-spn {
		font-weight: bold;
		color: #333333;
		font-family:'OpenSans';
	}
	#avl-bal{
	    font-family: 'OpenSans';
		color: #999999;
	}
	.popup-message{
		font-size: 20px;
		font-family: 'OpenSans';
		color: #333333;
		font-weight: bold;
		
	}
	input#tpup-tab-fromDate-ipt,input#tpup-tab-toDate-ipt,input#fndrq-tab-fromDate-ipt,input#fndrq-tab-toDate-ipt, input#wdw-tab-fromDate-ipt, input#wdw-tab-toDate-ipt{
		border:none;
		border-bottom:1px solid #999999;
	}
	button.swal2-confirm.custom-button.swal2-styled{background:#333333;}
	</style>
</head>
<body>

<div id="tabs">
    <ul>
        <li><a href="#withdrawal-tab">Withdrawal</a></li>
        <li><a href="#topup-tab">Top-Up</a></li>
        <li><a href="#fundrequest-tab">Fund Request</a></li>
    </ul>

	<div id="withdrawal-tab">
		<div class="filters">
			<label for="wdw-tab-status">Status:</label>
			<select id="status">
				<option value="">All</option>
				<option value="SUCCESS">Success</option>
				<option value="PENDING">Pending</option>
				<option value="FAILED">Failed</option>
			</select>			
			<input type="text" placeholder="Choose a date" id="wdw-tab-fromDate-ipt">
			<input type="text" placeholder="Choose a date" id="wdw-tab-toDate-ipt">

			<button onclick="reloadData()">Filter</button>
		</div>
		<div id="withdrawal-tab-nodt" style="display:none">Currently no data available </div>
        <table id="withdrawal-grid"></table>
        <div id="withdrawal-pager"></div>
    </div>
    <div id="topup-tab">
		<div class="filters">
			<div class="tpup-tab-sts-div">
				<select id="tpup-tab-status">
					<option value="">All</option>
					<option value="SUCCESS">Success</option>
					<option value="PENDING">Pending</option>
					<option value="FAILED">Failed</option>
				</select>
			</div>
			<div class="tpup-tab-frmdt-div">
				<input type="text" placeholder="Pick a date" id="tpup-tab-fromDate-ipt">
			</div>
			<div class="tpup-tab-todt-div">
				<input type="text" placeholder="Pick a date" id="tpup-tab-toDate-ipt">
			</div>
			<div class="tpup-tab-filterBtn-div">
				<button onclick="reloadData()">Filter</button>
			</div>
			<div class="container">	
			  <!-- Display QR Code -->
				<div id="topupBtn">  
					<div><img src="<c:url value='/images/topup.svg'/>" alt="Topup" class="tab-icon" style="width:50px;height:50px;"></div>
					<div class="topup" >Top up</div>
				</div>
			</div>
		</div>
		<div id="topup-tab-nodt" style="display:none">Currently no data available </div>
		<div id="tppopup" class="tppopup">
		    <div class="tppopup-content">
		        <span class="tpup-close-btn" onclick="closePopup()">×</span>
		        <h2 style="font-family: 'OpenSans';">Select a Top-Up Package</h2>
				<div id="avl-bal">Available Funds:<span id='avl-bal-spn'></span></div>
		        <div id="packageList"></div>
		        <div id="noFundsMessage">You don't have funds, please add funds</div>
				<button id="submitBtn" style="display:none">Purchase <span id='selectPkg'></span> Now</button>
		    </div>
		</div>
        <table id="topup-grid"></table>
        <div id="topup-pager"></div>
    </div>
    <div id="fundrequest-tab">
		<div class="filters">
			<div class="sts-div">
				<select id="fndrq-tab-sts">
					<option value="">All</option>
					<option value="SUCCESS">Success</option>
					<option value="PENDING">Pending</option>
					<option value="FAILED">Failed</option>
				</select>
			</div>
			<div class="fndrq-tab-frmdt-div">
				<input type="text" placeholder="Pick a date" id="fndrq-tab-fromDate-ipt">
			</div>
			<div class="fndrq-tab-todt-div">
				<input type="text" placeholder="Pick a date" id="fndrq-tab-toDate-ipt">
			</div>
			<div class="fndrq-tab-filterBtn-div">
				<button onclick="reloadData()">Filter</button>
			</div>
			<div class="container">	
			  <!-- Display QR Code -->
			  <div id="addFundsBtn">  
				<div><img src="<c:url value='/images/addfunds.svg' />" alt="addFunds" class="tab-icon" style="width:50px;height:50px;"></div>
				<div class="addFunds">Add Funds</div>
				</div>
			</div>
		</div>
		
		<div id="fundrequest-tab-nodt" style="display:none">Currently no data available </div>
        <table id="fundrequest-grid"></table>
        <div id="fundrequest-pager"></div>
		
		<div id="qrPopup" class="popup">
		  <div class="popup-content">
		    <span class="close-btn">&times;</span>
		    <h2>Scan QR Code to Add Funds</h2>
		    <div id="qrcode">
		      <!-- QR code image will be loaded here -->
		    </div>
		  </div>
		</div>
    </div>
</div>

<script>
	$(document).ready(function() {
		const packages = [2999, 4999, 9999, 24999, 49999, 74999, 99999, 199999, 299999, 499999, 999999];
		$("#myButton").button();
		$('#status, #tpup-tab-status, #fndrq-tab-sts').selectmenu();
		$("#wdw-tab-toDate-ipt,#wdw-tab-fromDate-ipt,#tpup-tab-fromDate-ipt,#tpup-tab-toDate-ipt,#fndrq-tab-fromDate-ipt,#fndrq-tab-toDate-ipt").datepicker({
                dateFormat: "yy/mm/dd", // Date format
                minDate: 0,  // Prevent selecting past dates
                maxDate: "+1Y", // Limit selection to 1 year ahead
                changeMonth: true, // Allow month selection
                changeYear: true // Allow year selection
        });
	    $("#tabs").tabs({
			create: function(event, ui) {
				if ($(ui.tab).index() === 0) {
					loadTabData(ui.panel.attr('id')); // Trigger the first tab data load
				}
			},
	        activate: function(event, ui) {
	            let tabId = ui.newPanel.attr('id');
	            loadTabData(tabId);
	        }
	    });
		
		$('#uploadQrBtn').on('click', function () {
		      const file = $('#qrFile')[0].files[0];
		      if (!file) {
		        alert('Please select a file');
		        return;
		      }
			  const formData = new FormData();
			  formData.append('file', file);
			  $.ajax({
		          url: '/api/qr/upload',
		          type: 'POST',
		          data: formData,
		          processData: false,
		          contentType: false,
		          success: function (response) {
		            alert(response);
		          },
		          error: function () {
		            alert('Failed to upload QR code');
		          }
		        });
			 });
			 $('#addFundsBtn').on('click', function () {
		       $('#qrcode').empty(); // Clear previous QR codes

		       $.ajax({
		         url: '/api/qr/fetch',
		         type: 'GET',
		         xhrFields: {
		           responseType: 'blob' // Expect binary data
		         },
		         success: function (data) {
		           const url = URL.createObjectURL(data);
		           const img = $('<img>').attr('src', url).attr('alt', 'QR Code');
		           $('#qrcode').append(img);
		           $('#qrPopup').fadeIn(); // Show popup
		         },
		         error: function () {
		           alert('Failed to load QR code');
		         }
		       });
		     });
			 
			 $('.close-btn').on('click', function () {
		       $('#qrPopup').fadeOut();
		     });
			 
			 $(window).on('click', function (e) {
			      if ($(e.target).is('#qrPopup')) {
			        $('#qrPopup').fadeOut();
			      }
			    });

	    // Load data based on tab ID
	    function loadTabData(tabId) {
	        let url = '',stsId,frmDtId,toDtId;
	        switch(tabId) {
	            case 'withdrawal-tab':
	                url = '/txn/wdw';
					frmDtId=$("#wdw-tab-fromDate-ipt");
					toDtId=$("#wdw-tab-toDate-ipt");
					
	                break;
	            case 'topup-tab':
	                url = '/txn/tpup';
					frmDtId=$("#tpup-tab-fromDate-ipt");
					toDtId=$("#tpup-tab-toDate-ipt");
	                break;
	            case 'fundrequest-tab':
	                url = '/txn/fndRqs';
					frmDtId=$("#fndrq-tab-fromDate-ipt");
					toDtId=$("#fndrq-tab-toDate-ipt");
	                break;
	        }

	        if (url) {
	            const params = {
	                status: $('#status').val(),
	                fromDate: frmDtId.val(),
	                toDate: toDtId.val()
	            };

	            $.ajax({
	                url: url,
	                method: 'GET',
	                data: params,
	                success: function(data) {
	                    createJqGrid(tabId, data);
	                },
	                error: function(err) {
	                    console.log("Error loading data: ", err);
	                }
	            });
	        }
	    }

	    // Initialize jQGrid
	    function createJqGrid(tabId, data) {
			$("#"+tabId+"no-data").hide();
	        var gridId = "#"+tabId.replace('-tab', '-grid'),pagerId = "#"+tabId.replace('-tab', '-pager'),formattedDt;

	        $(gridId).jqGrid('GridUnload'); // Unload if already loaded
			
			var colNames=["Tranaction Id", "Amount", "Transaction Date","Status"];
			var colModel=[
						{ name: 'transactionId', index: "topup_package", width: 100, align: 'center', sortable: false  },
						{ name: 'transactionAmount', index: "amount", width: 100, align: 'right' , sortable: false,formatter: function (cellValue) {return formatNumber(cellValue); } },
						{ name: 'transactionDateTime', index: "transactionDateTime", width: 150, align: 'center' , sortable: false },
						{ name: 'transactionStatus', index: "transactionStatus", width: 100, align: 'center' , sortable: false }
					];
			if(tabId == "fundrequest-tab"){
					if(data.length>0){
							formattedDt = data.map(item => ({
								transactionId: item[0],
								transactionAmount: item[1],
								transactionType: item[2],
								transactionStatus: item[3],
								transactionDateTime: item[4]
							}));
					}
					colNames = ["Tranaction Id", "Amount", "Transaction Date", "Transaction Mode", "Status"];
					colModel = [
						{ name: 'transactionId', index: "topup_package", width: 100, align: 'center', sortable: false  },
						{ name: 'transactionAmount', index: "amount", width: 100, align: 'center' , sortable: false },
						{ name: 'transactionDateTime', index: "transactionDateTime", width: 150, align: 'center' , sortable: false },
						{ name: 'transactionType', index: "transactionType", width: 100, align: 'center' , sortable: false },
						{ name: 'transactionStatus', index: "transactionStatus", width: 100, align: 'center' , sortable: false }
					];
			}else {
				if(data.length>0){
					formattedDt = data.map(item => ({
						transactionId: item[0],
						transactionAmount: item[1],
						transactionStatus: item[2],
						transactionDateTime: item[3]
					}));
				}
			}
			initializeJqGrid(gridId,colNames,colModel,formattedDt?formattedDt.length:0,pagerId,formattedDt);
			return;   
			
	    }

	    // Reload data based on filters
	    function reloadData() {
	        const activeTab = $("#tabs").tabs('option', 'active');
	        const tabId = $("#tabs ul>li a").eq(activeTab).attr('href').replace('#', '');
	        loadTabData(tabId);
	    }
		
		function openPopup() {
	        $.get('/txn/balance', function(balance) {
	            $('#packageList').empty();
				$('#avl-bal-spn').empty().html(formatNumber(parseFloat(balance)));
	            $('#noFundsMessage').hide();

	            const affordablePackages = packages.filter(pkg => pkg <= balance);

	            if (affordablePackages.length > 0) {
	                affordablePackages.forEach(pkg => {
	                    $('#packageList').append('<div class="package-div" id="pkgDv">₹'+formatNumber(parseFloat(pkg))+'</div>');
	                });
	            } else {
	                $('#noFundsMessage').show();
	            }

	            $('#tppopup').show();
				$('.package-div').on('click', function () {
					// Remove 'selected' class from all divs
					$('.package-div').removeClass('selected');
					
					// Add 'selected' class to the clicked div
					$(this).addClass('selected');

					// Enable the submit button when a div is selected
					$("#selectPkg").empty().text($(this).text())
					$('#submitBtn').show();
				});
				$('#submitBtn').on ('click', function(){
					var pkgamt=$('#selectPkg').text().replace("₹","").replace(",","");
					purchasePackage(parseFloat(pkgamt));
				});
	        });
	    }
		function closePopup() {
	      $('#tppopup').hide();
		}
		function purchasePackage(amount) {
	          $.ajax({
	              url: '/txn/purchase',
	   		      type: 'POST',
	              contentType: 'application/json',
	              data: JSON.stringify({
	                  amount: amount
	              }),
	              success: function(response) {
	                  Swal.fire({
		                   icon: "success",
						   html: '<p class="popup-message">Thank you for your purchase</strong></p>',
						       confirmButtonText: "Close",
						       customClass: {
						           popup: "custom-popup",
						           title: "custom-title",
						           confirmButton: "custom-button"
						       }
		               }).then(() => {
		                 reload(); // Redirect to login page after OK
		               });
	                  closePopup();
	              },
	              error: function(xhr) {
	                  alert(xhr.responseText);
	              }
	          });
	     }

		  $('#topupBtn').on('click', openPopup);
		 $('.tpup-close-btn').on('click',closePopup);
	});

</script>

</body>
</html>
