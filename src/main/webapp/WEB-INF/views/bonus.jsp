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

	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/css/ui.jqgrid.min.css">
	<script src="https://cdn.jsdelivr.net/npm/free-jqgrid@4.15.5/js/jquery.jqgrid.min.js"></script>
	<script src="${pageContext.request.contextPath}/static/libs/raphael.min.js"></script>
	<script src="${pageContext.request.contextPath}/static/libs/Treant.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/static/libs/Treant.css">

	<style>
		#tree-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .orgchart {
            background: white;
            border-radius: 5px;
            padding: 10px;
        }

        .orgchart .node {
            padding: 10px;
            border: 1px solid #007bff;
            border-radius: 5px;
            background: #f8f9fa;
            font-weight: bold;
            color: #007bff;
        }

        .orgchart .node:hover {
            background: #007bff;
            color: white;
        }
		#tree-container { width: 100%; height: 500px; }
	</style>
	
<script>
	$(document).ready(function() {
		$("#bnsTabs").tabs({
           activate: function(event, ui) {
               let tabId = ui.newPanel.attr('id');
           }
       	});
	});
</script>
<style>
	#bnsTabs { margin-top: 10px; }
</style>
</head>
<body>
<div id="bnsTabs">
        <ul>
            <li><a href="#tab-1">ROI Bonus</a></li>
            <li><a href="#tab-2">Direct Bonus</a></li>
            <li><a href="#tab-3">Binary Bonus</a></li>
			<li><a href="#tab-4">Fund Details</a></li>
			<li><a href="#tab-5">Rewards</a></li>
			<li><a href="#tab-6">Achieved Rewads</a></li>
			<li><a href="#tab-7">Rank Income</a></li>
        </ul>
        <div id="tab-1">
			<h1>ROI Bonus Details</h1>
        </div>
        <div id="tab-2">
			<h1>Direct Bonus Details</h1>
        </div>
        <div id="tab-3"> 
			<h1>Binary Bonus Details</h1>
        </div>
		<div id ="tab-4">
			<h1>Fund Details</h1>
		</div>
		
		<div id ="tab-5">
			<h1>Rewards Details</h1>
		</div>
				
		<div id ="tab-6">
			<h1>Achieved Reward Details</h1>
		</div>
				
		<div id ="tab-7">
			<h1>Fund Rank Income Details</h1>
		</div>
								
								
    </div>
	</body>
	</html>