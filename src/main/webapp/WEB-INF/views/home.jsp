<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Madhu Traders</title>

    <!-- jQuery & jQuery UI -->
    <script src="<c:url value='/js/jquery-3.7.1.min.js' />"></script>
    <script src="<c:url value='/js/jquery-ui.min.js' />"></script>
	<script src="<c:url value='/js/custom.js' />"></script>
    <link rel="stylesheet" href="<c:url value='/css/jquery-ui.min.css' />">
	<link rel="stylesheet" href="<c:url value='/css/style.css' />">
</head>
<body>
<!-- partial:index.partial.html -->
<body>
	<header id="hdr">
	    <div class="headerMn">
	        <div class="hdr-cntr">
	            <div class="hdr-itms-cntr">
	                <div class="hdr-logo-dv"></div>
	                <div class="hdr-itms-dv">
	                    <!-- Tabs Navigation & Login in Same Line -->
	                    <div class="hdrmnnv flxfl">
	                        <ul class="tabs">
	                            <li><a href="#home" class="hdrnv hdrtxt active">Home</a></li>
	                            <li class="divider"></li>
	                            <li><a href="#about" class="hdrnv hdrtxt">About Us</a></li>
	                            <li class="divider"></li>
								<li><a href="#plans" class="hdrnv hdrtxt">Our Investment Plans</a></li>
								<li class="divider"></li>
	                            <li><a href="#contact" class="hdrnv hdrtxt">Contact Us</a></li>
	                        </ul>

	                        <!-- Login Button -->
	                        <div class="loginDv" id="loginDv">
	                            <div class="hdrnv login" id="loginBtn">Login</div>
	                        </div>
	                    </div>
	                    
	                </div>
	            </div>
	        </div>
	    </div>
	</header>

	<!-- Tab Content -->
	<div class="tab-content">
	    <div id="home" class="tab-pane active">
			<div class="container">
		        <div class="header ">Invest Smart, Invest Simple</div>
		        <div class="content invst">
					<div class="invst-img"></div>
		            <div class="content-text">
		               Madhu Traders is a next-generation investment platform designed to make investing seamless, transparent, and profitable. Launched in 2025, we are committed to bridging the gap between traditional investment opportunities and the needs of the modern investor.
		            </div>
		        </div>

		        <div class="header">What is Cryptocurrency?</div>
		        <div class="content crypto">
		            <div class="content-text">
						Cryptocurrency is a digital asset that uses cryptography for secure transactions and operates independently of traditional banks. Unlike fiat currencies, it is decentralized and runs on blockchain technology, ensuring transparency, security, and global accessibility.
		            </div>
					<div class="crypto-img"></div>
		        </div>

		        <div class="header">Understanding Decentralization & Blockchain</div>
		        <div class="content blkchn">
					<div class="blkchn-img"></div>
		            <div class="content-text">
						<strong>Decentralization</strong> – No central authority controls cryptocurrencies, making transactions peer-to-peer and reducing third-party interference.</p>
		                <strong>Blockchain Technology</strong> – A secure digital ledger that records every transaction, ensuring transparency and fraud prevention.</p>
		            </div>
		        </div>

		        <div class="header">Benefits of Cryptocurrency Investment</div>
				<div class="benefits-container">
				    <div class="benefit-box">
				        <img src="/images/growth.png" alt="Check Icon">
				        <div class="benefit-text">High Growth Potential</div>
				    </div>
				    <div class="benefit-box">
				        <img src="/images/lock.svg" alt="Shield Icon">
				        <div class="benefit-text">Security & Transparency</div>
				    </div>
				    <div class="benefit-box">
				        <img src="/images/global.png" alt="Globe Icon">
				        <div class="benefit-text">Global Accessibility</div>
				    </div>
				    <div class="benefit-box">
				        <img src="/images/financial.png" alt="Freedom Icon">
				        <div class="benefit-text">Financial Freedom</div>
				    </div>
				</div>		       
		    </div>
		</div>
	    <div id="about" class="tab-pane">About Us Information</div>
	    <div id="contact" class="tab-pane">
			<div class="contact-box">
		        <h2>Contact Us</h2>
		        <form id="contact-form">
		            <div class="form-group">
		                <input type="text" id="name" name="name" placeholder="Name" required>
		            </div>
		            <div class="form-group">
		                <input type="email" id="email" name="email" placeholder="Email" required>
		            </div>
		            <div class="form-group">
		                <input type="tel" id="number" name="number" placeholder="Number" required>
		            </div>
		            <button type="submit">Contact Us</button>
		        </form>
		        <p class="thank-you">Thank you for contacting us!</p>
		    </div>
			
		</div>
		
		<div id="plans" class="tab-pane">
			<div class="investment-tab" id="investment-tab">Investment Plans</div>

			   <!-- Investment Panel (Initially Hidden) -->
			   <div class="investment-panel">
			       <div class="sub-tab" data-target="roi">RoI Income</div>
			       <div class="sub-tab" data-target="binary">Binary Income</div>
			       <div class="sub-tab" data-target="direct">Direct Income</div>
			       <div class="sub-tab" data-target="reward">Reward Income</div>
			   </div>

			   <!-- Content Sections -->
			   <div id="roi" class="invst-content">🏆 <strong>RoI Income:</strong> This income is based on return on investment.</div>
			   <div id="binary" class="invst-content">⚖ <strong>Binary Income:</strong> Earn income based on binary tree structures.</div>
			   <div id="direct" class="invst-content">💼 <strong>Direct Income:</strong> Earn direct commission from referrals.</div>
			   <div id="reward" class="invst-content">🎁 <strong>Reward Income:</strong> Earn extra bonuses and incentives.</div>
		</div>
	</div>

	<div id="login-dialog" class="login-container" title="">
        <h2>Login</h2>
        <form id="lgnfrm" method="POST">
            <div class="input-group">
                <div class="input-box">
                    <input type="text" id="username" placeholder="Enter Username">
                </div>
                <div class="input-box">
                    <input type="password" id="password" placeholder="Enter Password">
                </div>
            </div>
            <div class="button-group">
                <div class="button-box" id="login-btn">Login</div>
            </div>
        </form>
        <div class="login-options">
            <a href="#" id="forgot-password">Forgot Password?</a>
            <a href="#" id="new-user">New User? Sign Up</a>
        </div>
    </div>

</body>
<!-- partial -->
</html>
