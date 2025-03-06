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
		$("#dlTabs").tabs({
           activate: function(event, ui) {
               let tabId = ui.newPanel.attr('id');
              
			   if (ui.newPanel.attr("id") === "tab-4") {
                   loadGenealogyTree();
               }else {
					//loadTabData(tabId);
			   }
           }
       	});
		
		function loadGenealogyTree() {
			let config = {
                chart: { container: "#tree", rootOrientation: "NORTH" },
                nodeStructure: {
                    text: { name: "Grandparent" },
                    children: [
                        {
                            text: { name: "Parent 1" },
                            children: [
                                { text: { name: "Child 1" } },
                                { text: { name: "Child 2" } }
                            ]
                        },
                        {
                            text: { name: "Parent 2" },
                            children: [
                                { text: { name: "Child 3" } },
                                { text: { name: "Child 4" } }
                            ]
                        }
                    ]
                }
            };

            $("#tree").empty(); // Prevent duplicate trees
            new Treant(config);
		}
		
	});
</script>
<style>
	#dltabs { margin-top: 10px; }
</style>
</head>
<body>
<div id="dlTabs">
        <ul>
            <li><a href="#tab-1">Direct Sponsor</a></li>
            <li><a href="#tab-2">Level Downline</a></li>
            <li><a href="#tab-3">Total Team</a></li>
			<li><a href="#tab-4">Genealogy Tree</a></li>
        </ul>
        <div id="tab-1">
			
        </div>
        <div id="tab-2">
			
        </div>
        <div id="tab-3"> 
			          
        </div>
		<div id ="tab-4">
			<div id="tree-container">
                <div id="tree"></div>
            </div>
		</div>
    </div>
	</body>
	</html>