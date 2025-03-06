<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction</title>

	<script src="<c:url value='/js/jquery-3.7.1.min.js'/>"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">

	<!-- ✅ Free jqGrid (Compatible with jQuery 3.x) -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/css/ui.jqgrid.min.css">
	<script src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/jquery.jqgrid.min.js"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
	<script>
	        $(document).ready(function() {
				$("#trxnTabs").tabs({
	               activate: function(event, ui) {
	                   let tabId = ui.newPanel.attr('id');
	                   loadTabData(tabId);
	               }
	           	});
				
				$("#history-dialog").dialog({
		             autoOpen: false,
		             width: 500,
		             modal: true,
					 position: { my: "center top", at: "center top+50", of: window } 
		         });

		         // Handle History Button Click
		         $(".history-button").click(function () {
		             let tabId = $(this).data("tab"); // Get the tab ID
		             fetchHistory(tabId); // Fetch history data
		         });

		         // AJAX function to get history data from the backend
		         function fetchHistory(tabId) {
		             $.ajax({
		                 url: "/getHistory", // Backend API (replace with actual URL)
		                 type: "GET",
		                 data: { tab: tabId }, // Send tab ID
		                 dataType: "json",
		                 success: function (response) {
		                     loadHistoryGrid(response);
		                 },
		                 error: function () {
		                     loadHistoryGrid([]);
		                 },
			             complete: function () {
			                 $("#history-dialog").dialog("open"); // Always open the dialog
			             }
		             });
		         }

		         // Function to update history table with fetched data
				 function loadHistoryGrid(data) {
	                $("#history-grid").jqGrid("GridUnload"); // Unload previous grid data

	                $("#history-grid").jqGrid({
	                    datatype: "local",
	                    data: data.length ? data : [{ id: "❌", date: "❌", status: "Failed to load data", amount: "❌" }], // Show error if data is empty
	                    colNames: ["Transaction Id", "Transaction Date", "Transaction Status", "Amount"],
	                    colModel: [
	                        { name: "id", index: "id", width: 80, align: "center" },
	                        { name: "date", index: "date", width: 120, align: "center" },
	                        { name: "status", index: "status", width: 150, align: "center" },
	                        { name: "amount", index: "amount", width: 100, align: "center" }
	                    ],
	                    rowNum: 5,
	                    pager: "#history-pager",
	                    viewrecords: true,
	                    height: "auto",
	                    autowidth: true,
	                    loadComplete: function () {
	                        if (data.length === 0) {
								$("#history-pager").show();
	                            $("#history-grid").setGridParam({ rowNum: 1 }).trigger("reloadGrid");
	                    }else {
				            $("#history-pager").show();
				        }
	                    }
	                });
	            }
		     });
			function loadTabData(tabId) {
	            let url = "";
	           if (tabId === "tab-3") url = "/api/settings";
			   else return;

	            $.ajax({
	                url: url,
	                method: "GET",
	                success: function(data) {
						if (data.length > 0) {
			               $("#" + tabId).html('<table id="grid-' + tabId + '"></table><div id="pager-' + tabId + '"></div>');
			               $("#grid-" + tabId).jqGrid({
			                   datatype: "local",
			                   data: data,
			                   colNames: ["ID", "Name", "Status", "Date"],
			                   colModel: [
			                       { name: "id", index: "id", width: 80, align: "center" },
			                       { name: "name", index: "name", width: 150, align: "center" },
			                       { name: "status", index: "status", width: 100, align: "center" },
			                       { name: "date", index: "date", width: 120, align: "center" }
			                   ],
			                   rowNum: 5,
			                   pager: "#pager-" + tabId,
			                   viewrecords: true,
			                   height: "auto",
			                   autowidth: true
			               });
			           } else {
			               $("#" + tabId).html("<p>No records found.</p>");
			           }
	                },
	                error: function() {
	                    $("#" + tabId).html("<p>Error loading data.</p>");
	                }
	            });
	        }
	    </script>

    <style>
		.tab-header {
	            display: flex;
	            justify-content: space-between;
	            align-items: center;
	            font-size: 16px;
	            font-weight: bold;
	            padding: 10px;
	        }

	        .history-button {
	            padding: 5px 10px;
	            font-size: 14px;
	            cursor: pointer;
	            background-color: #007bff;
	            color: white;
	            border: none;
	            border-radius: 4px;
	        }

	        .history-button:hover {
	            background-color: #0056b3;
	        }

	        #qrcode {
	            margin-top: 10px;
	        }

	        /* jQuery UI Tabs Override */
	        #tabs { margin-top: 10px; }
    </style>
</head>
<body>

    <div id="trxnTabs">
        <ul>
            <li><a href="#tab-1">Funds</a></li>
            <li><a href="#tab-2">TopUp</a></li>
            <li><a href="#tab-3">Withdrawals</a></li>
        </ul>
        <div id="tab-1">
			<div class="tab-header">
                <span>Packages</span>
                <button class="history-button" onclick="showHistory()">Show History</button>
            </div>
            <label for="packageInput">Enter Package Name:</label>
            <input type="text" id="packageInput" placeholder="Enter package">
            <button id="submitPackage">Submit</button>
            <p id="packageResult"></p>
        </div>
        <div id="tab-2">
			<div class="tab-header">
               <span>QR Code</span>
               <button class="history-button" onclick="showHistory()">Show History</button>
           </div>
           <p>Scan this QR Code:</p>
           <div id="qrcode"></div>

        </div>
        <div id="tab-3">
            <p>Adjust your Settings here.</p>
        </div>
    </div>
	<div id="history-dialog" title="History Data">
		<table id="history-grid"></table>
		<div id="history-pager"></div>
	</div>

</body>
</html>

