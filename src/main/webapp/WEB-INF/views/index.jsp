<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Dashboard</title>
    <script src="<c:url value='/js/jquery-3.7.1.min.js'/>"></script>
	<script src="<c:url value='/js/index.js'/>"></script>
	<link rel="stylesheet" href="<c:url value='/css/index.css'/>">
</head>
<body>

<!-- Top Navigation (Menus) -->
<div id="topFrame" class="header d-flex align-items-center sticky-top">
	<div class="container position-relative d-flex align-items-center">
		<div class="logo d-flex align-items-center me-auto">
			<h1 class="sitename">Company</h1>
		</div>
		<nav id="navmenu" class="navmenu">
			<ul>
				<li><div class="nav-mn-itm active" onclick="loadContent('dashboard', this)" >DashBoard</div></li>
				<li><div class="nav-mn-itm" onclick="loadContent('dl', this)">Downline</div></li>
				<li><div class="nav-mn-itm" onclick="loadContent('trxn', this)">Transactions</div></li>
				<li><div class="nav-mn-itm" onclick="loadContent('bns', this)">Bonus</div></li>
				<li><div class="nav-mn-itm" onclick="loadContent('prfl', this)">Profile</div></li>
			</ul>
		</nav>
	</div>
</div>

<!-- Content Area -->
<iframe id="containerFrame" src="/dashboard" width="100%" height="auto" style="min-height:600px;border: none;background: #ffffff;"></iframe>

</body>
</html>
