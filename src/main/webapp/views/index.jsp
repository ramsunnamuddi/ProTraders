<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ProTraders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="stylesheet" href="<c:url value='css/user/nwview.css' />">
	<link rel="stylesheet" href="<c:url value='fonts/font.css' />">	
	<link rel="stylesheet" href="<c:url value='css/common.css' />">
	<script src="<c:url value='/js/jquery-3.7.1.min.js' />"></script>
    <script src="<c:url value='/js/jquery-ui.min.js' />"></script>	
	<!-- jQGrid CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css">
	<!-- jQGrid JS -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/jquery.jqgrid.min.js"></script>
	<!-- jQuery UI (for styling) -->
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <style>
        
    </style>
</head>
<body onload="loadPage('dashboard', event)">
    <!-- Sidebar -->
	<form name="index" id="index">
		<input type="hidden" value="${sid}" name="sid">			 
		<input type="hidden" value="${pid}" name="pid">
	</form>
    <div class="sidebar" id="sidebar">
        <button class="menu-btn" id="menuBtn"><i class="fas fa-bars"></i></button>
        <a href="#" onclick="loadPage('dashboard', event)" class="active"><i class="fas fa-tachometer"></i><span> Dashboard</span></a>
        <a href="#" onclick="loadPage('dl', event)"><i class="fas fa-long-arrow-down"></i><span> Downline</span></a>
        <a href="#" onclick="loadPage('fndtrns', event)"><i class="fas fa-qrcode"></i><span> Funds Transfer</span></a>
		<a href="#" onclick="loadPage('tpups', event)"><i class="bi bi-coin"></i><span>Top Ups</span></a>
		<a href="#" onclick="loadPage('wdw', event)"><i class="bi bi-cash-stack" aria-hidden="true"></i><span>Withdrawals</span></a>
        <a href="#" onclick="loadPage('bns', event)"><i class="fas fa-plus-square"></i><span> Income</span></a>
        <a href="#" onclick="loadPage('prfl', event)"><i class="fas fa-user"></i><span> Profile</span></a>
        <a href="#" onclick="doLogout()"><i class="fas fa-sign-out-alt"></i><span> Log Out</span></a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div id="mainContent" style="height: 100%;overflow: auto;"></div>
    </div>

    <script>
        document.getElementById("menuBtn").addEventListener("click", function() {
            if (window.innerWidth > 600) {
                document.getElementById("sidebar").classList.toggle("expanded");
            }
        });

        function loadPage(page, event) {
            if (event) event.preventDefault();
            
			let loadingOverlay = document.getElementById("loadingOverlay");
			loadingOverlay.style.display = "flex";
            document.getElementById("mainContent").classList.add("hidden");
			const form = document.getElementById('index');
			const data = {
			    sid: form.sid.value,
			    pid: form.pid.value
			};
            setTimeout(() => {
                $.ajax({
                    url: page,
                    type: 'POST',
					data: JSON.stringify(data),
					contentType: 'application/json',
                    success: function(response) {
                        document.getElementById("mainContent").innerHTML = response;
                        loadingOverlay.style.display = "none";
                        document.getElementById("mainContent").classList.remove("hidden");
                        
                        // Highlight active menu
                        document.querySelectorAll('.sidebar a').forEach(link => link.classList.remove('active'));
                        //event.target.closest('a').classList.add('active');
						initFilters();
                    },
                    error: function() {
                        document.getElementById("mainContent").innerHTML = "<h2>Error</h2><p>Failed to load content.</p>";
                        loadingOverlay.style.display = "none";
                        document.getElementById("mainContent").classList.remove("hidden");
                    }
                });
            }, 500);
        }// Load once
		
		function doLogout(){
			const form = document.getElementById('index');
		    $.ajax({
		        url: "auth/logout?sid="+form.sid.value+"&pid="+form.pid.value,
		        type: "GET",
		        success: function (response) {
					window.location.href = "/";
		        },
				error: function(xhr, status, error) {
					alert("Technical error!!");
				}
		    });
		}
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
	<script src="<c:url value='js/common/commonfilter.js'/>"></script>
	<script src="<c:url value='js/common/binarytree.js'/>"></script>
	
	<div id="loadingOverlay" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.7);z-index:1001;justify-content:center;align-items:center;">
    <div style="text-align:center;">
      <!-- Animated rupee symbol -->
      <div style="font-size:4rem;font-weight:bold;color:gold;animation:spin-3d 1.5s linear infinite;">&#x20B9;</div>
      <p style="color:white;margin-top:20px;font-size:1.2rem;font-family: roboto;">Please wait, it's loading...</p>
    </div>
  </div>
	<!-- Toast Notifications Container -->
	<div id="toastContainer" class="position-fixed top-0 end-0 p-3" style="z-index: 1100"></div>
</body>
</html>
