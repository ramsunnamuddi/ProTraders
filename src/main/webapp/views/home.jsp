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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	
<style>
	:root {
		--primary: #2563eb;
		--secondary: #1e40af;
		--accent: #3b82f6;
		--dark: #1e293b;
		--light: #f8fafc;
		--success: #10b981;
		--warning: #f59e0b;
		--gradient: linear-gradient(135deg, var(--primary), var(--secondary));
		--shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		--radius: 12px;
	}

	* {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
		font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
	}

	body {
		background-color: var(--light);
		color: var(--dark);
		line-height: 1.6;
	}

	.container {
		width: 100%;
		max-width: 1200px;
		margin: 0 auto;
		padding: 0 20px;
	}

	/* Header Styles */
	header {
		background: var(--gradient);
		color: white;
		padding: 1.2rem 0;
		position: sticky;
		top: 0;
		z-index: 100;
		box-shadow: var(--shadow);
	}

	nav {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.logo {
		font-size: 1.8rem;
		font-weight: 700;
		display: flex;
		align-items: center;
		gap: 10px;
	}

	.logo-icon {
		color: white;
		font-size: 2rem;
	}

	.nav-links {
		display: flex;
		list-style: none;
		gap: 2rem;
	}

	.nav-links a {
		color: white;
		text-decoration: none;
		font-weight: 500;
		transition: all 0.3s ease;
		position: relative;
		padding: 0.5rem 0;
	}

	.nav-links a:hover {
		color: rgba(255, 255, 255, 0.9);
	}

	.nav-links a::after {
		content: '';
		position: absolute;
		bottom: 0;
		left: 0;
		width: 0;
		height: 2px;
		background: white;
		transition: width 0.3s ease;
	}

	.nav-links a:hover::after {
		width: 100%;
	}

	.active a {
		font-weight: 600;
	}

	.active a::after {
		width: 100%;
	}

	.hamburger {
		display: none;
		cursor: pointer;
		font-size: 1.5rem;
		color: white;
	}

	/* Hero Section */
	.hero {
		background: var(--gradient);
		color: white;
		padding: 5rem 0;
		text-align: center;
		position: relative;
		overflow: hidden;
	}

	.hero::before {
		content: '';
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: url('https://images.unsplash.com/photo-1639762681057-408e52192e55?q=80&w=2232&auto=format&fit=crop') no-repeat center/cover;
		opacity: 0.15;
		z-index: 0;
	}

	.hero-content {
		position: relative;
		z-index: 1;
		max-width: 800px;
		margin: 0 auto;
		padding: 0 20px;
	}

	.hero h1 {
		font-size: 3.5rem;
		margin-bottom: 1.5rem;
		font-weight: 800;
		line-height: 1.2;
	}

	.hero p {
		font-size: 1.25rem;
		margin-bottom: 2.5rem;
		opacity: 0.9;
	}

	.btn {
		display: inline-block;
		background: white;
		color: var(--primary);
		padding: 0.9rem 2.5rem;
		border-radius: 50px;
		font-weight: 600;
		text-decoration: none;
		transition: all 0.3s ease;
		box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
	}

	.btn:hover {
		transform: translateY(-3px);
		box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
	}

	.btn-outline {
		background: transparent;
		color: white;
		border: 2px solid white;
		margin-left: 1rem;
	}

	.btn-outline:hover {
		background: rgba(255, 255, 255, 0.1);
	}

	/* Features Section */
	.features {
		padding: 5rem 0;
	}

	.section-header {
		text-align: center;
		margin-bottom: 4rem;
	}

	.section-header h2 {
		font-size: 2.5rem;
		color: var(--dark);
		margin-bottom: 1rem;
		font-weight: 700;
	}

	.section-header p {
		color: #64748b;
		max-width: 700px;
		margin: 0 auto;
		font-size: 1.1rem;
	}

	.features-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
		gap: 2rem;
	}

	.feature-card {
		background: white;
		border-radius: var(--radius);
		padding: 2.5rem;
		text-align: center;
		transition: all 0.3s ease;
		box-shadow: var(--shadow);
	}

	.feature-card:hover {
		transform: translateY(-10px);
		box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
	}

	.feature-icon {
		font-size: 3rem;
		color: var(--accent);
		margin-bottom: 1.5rem;
	}

	.feature-card h3 {
		font-size: 1.5rem;
		color: var(--dark);
		margin-bottom: 1rem;
	}

	.feature-card p {
		color: #64748b;
	}

	/* How It Works Section */
	.steps {
		padding: 5rem 0;
		background: #f1f5f9;
	}

	.steps-container {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 2rem;
		margin-top: 3rem;
	}

	.step-card {
		flex: 1;
		min-width: 250px;
		max-width: 300px;
		background: white;
		padding: 2rem;
		border-radius: var(--radius);
		text-align: center;
		box-shadow: var(--shadow);
		position: relative;
	}

	.step-number {
		width: 50px;
		height: 50px;
		background: var(--accent);
		color: white;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 1.5rem;
		font-weight: bold;
		margin: 0 auto 1.5rem;
	}

	/* Testimonials */
	.testimonials {
		padding: 5rem 0;
	}

	.testimonial-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
		gap: 2rem;
		margin-top: 3rem;
	}

	.testimonial-card {
		background: white;
		padding: 2rem;
		border-radius: var(--radius);
		box-shadow: var(--shadow);
	}

	.testimonial-text {
		font-style: italic;
		margin-bottom: 1.5rem;
		color: #475569;
	}

	.testimonial-author {
		display: flex;
		align-items: center;
		gap: 1rem;
	}

	.author-avatar {
		width: 50px;
		height: 50px;
		border-radius: 50%;
		object-fit: cover;
	}

	.author-info h4 {
		color: var(--dark);
	}

	.author-info p {
		color: #64748b;
		font-size: 0.9rem;
	}

	/* About Page */
	.about {
		padding: 5rem 0;
	}

	.about-content {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 3rem;
		align-items: center;
	}

	.about-image {
		border-radius: var(--radius);
		overflow: hidden;
		box-shadow: var(--shadow);
	}

	.about-image img {
		width: 100%;
		height: auto;
		display: block;
	}

	.about-text h2 {
		font-size: 2.5rem;
		color: var(--dark);
		margin-bottom: 1.5rem;
	}

	.about-text p {
		margin-bottom: 1.5rem;
		color: #475569;
		line-height: 1.8;
	}

	/* Team Section */
	.team {
		padding: 5rem 0;
		background: #f1f5f9;
	}

	.team-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
		gap: 2rem;
		margin-top: 3rem;
	}

	.team-card {
		background: white;
		border-radius: var(--radius);
		overflow: hidden;
		box-shadow: var(--shadow);
		text-align: center;
	}

	.team-image {
		width: 100%;
		height: 250px;
		object-fit: cover;
	}

	.team-info {
		padding: 1.5rem;
	}

	.team-info h3 {
		color: var(--dark);
		margin-bottom: 0.5rem;
	}

	.team-info p {
		color: var(--accent);
		font-weight: 500;
		margin-bottom: 1rem;
	}

	/* Services Page */
	.services {
		padding: 5rem 0;
	}

	.package-table {
		width: 100%;
		border-collapse: collapse;
		margin: 3rem 0;
		background: white;
		border-radius: var(--radius);
		overflow: hidden;
		box-shadow: var(--shadow);
	}

	.package-table th, 
	.package-table td {
		padding: 1.2rem 1rem;
		text-align: center;
		border: 1px solid #e2e8f0;
	}

	.package-table th {
		background: var(--accent);
		color: white;
		font-weight: 600;
	}

	.package-table tr:nth-child(even) {
		background: #f8fafc;
	}

	.package-table tr:hover {
		background: #f1f5f9;
	}

	.highlight {
		background: #fff9db !important;
		font-weight: 600;
	}

	.bonus-tables {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
		gap: 2rem;
		margin: 3rem 0;
	}

	.bonus-table {
		width: 100%;
		border-collapse: collapse;
		background: white;
		border-radius: var(--radius);
		overflow: hidden;
		box-shadow: var(--shadow);
	}

	.bonus-table th, 
	.bonus-table td {
		padding: 1rem;
		text-align: center;
		border: 1px solid #e2e8f0;
	}

	.bonus-table th {
		background: var(--primary);
		color: white;
		font-weight: 600;
	}

	.bonus-table tr:nth-child(even) {
		background: #f8fafc;
	}

	/* Signup Page */
	.signup {
		padding: 5rem 0;
		background: #f1f5f9;
	}

	.signup-container {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 3rem;
		align-items: center;
	}

	.signup-form {
		background: white;
		padding: 2.5rem;
		border-radius: var(--radius);
		box-shadow: var(--shadow);
	}

	.signup-form h2 {
		color: var(--dark);
		margin-bottom: 1.5rem;
		text-align: center;
	}

	.form-group {
		margin-bottom: 1.5rem;
	}

	.form-group label {
		display: block;
		margin-bottom: 0.5rem;
		color: var(--dark);
		font-weight: 500;
	}

	.form-group input {
		width: 100%;
		padding: 1rem;
		border: 1px solid #e2e8f0;
		border-radius: 8px;
		font-size: 1rem;
		transition: border 0.3s ease;
	}

	.form-group input:focus {
		border-color: var(--accent);
		outline: none;
		box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
	}

	.signup-btn {
		width: 100%;
		padding: 1rem;
		background: var(--gradient);
		color: white;
		border: none;
		border-radius: 8px;
		font-size: 1rem;
		font-weight: 600;
		cursor: pointer;
		transition: all 0.3s ease;
		margin-top: 1rem;
	}

	.signup-btn:hover {
		opacity: 0.9;
		transform: translateY(-2px);
	}

	.signup-benefits {
		background: var(--gradient);
		color: white;
		padding: 2.5rem;
		border-radius: var(--radius);
		box-shadow: var(--shadow);
	}

	.signup-benefits h2 {
		margin-bottom: 1.5rem;
		text-align: center;
	}

	.benefits-list {
		list-style: none;
	}

	.benefits-list li {
		margin-bottom: 1rem;
		display: flex;
		align-items: center;
		gap: 10px;
	}

	.benefits-list i {
		color: white;
		font-size: 1.2rem;
	}

	/* Modal Popups */
	.modal {
		display: none;
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: rgba(0, 0, 0, 0.7);
		z-index: 1000;
		justify-content: center;
		align-items: center;
	}

	.modal-content {
		background: white;
		padding: 3rem;
		border-radius: var(--radius);
		width: 100%;
		max-width: 450px;
		box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
		animation: modalFadeIn 0.3s ease;
		position: relative;
	}

	.close-modal {
		position: absolute;
		top: 15px;
		right: 15px;
		font-size: 1.5rem;
		cursor: pointer;
		color: #64748b;
		transition: color 0.3s ease;
	}

	.close-modal:hover {
		color: var(--dark);
	}

	/* Footer */
	footer {
		background: var(--dark);
		color: white;
		padding: 4rem 0 2rem;
	}

	.footer-content {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
		gap: 3rem;
		margin-bottom: 3rem;
	}

	.footer-column h3 {
		font-size: 1.3rem;
		margin-bottom: 1.5rem;
		position: relative;
		padding-bottom: 10px;
	}

	.footer-column h3::after {
		content: '';
		position: absolute;
		bottom: 0;
		left: 0;
		width: 40px;
		height: 3px;
		background: var(--accent);
	}

	.footer-links {
		list-style: none;
	}

	.footer-links li {
		margin-bottom: 0.8rem;
	}

	.footer-links a {
		color: #e2e8f0;
		text-decoration: none;
		transition: color 0.3s ease;
	}

	.footer-links a:hover {
		color: var(--accent);
	}

	.social-links {
		display: flex;
		gap: 1rem;
		margin-top: 1.5rem;
	}

	.social-links a {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 40px;
		height: 40px;
		background: rgba(255, 255, 255, 0.1);
		border-radius: 50%;
		color: white;
		transition: all 0.3s ease;
	}

	.social-links a:hover {
		background: var(--accent);
		transform: translateY(-3px);
	}

	.footer-bottom {
		text-align: center;
		padding-top: 2rem;
		border-top: 1px solid rgba(255, 255, 255, 0.1);
		color: #94a3b8;
		font-size: 0.9rem;
	}

	/* Responsive Styles */
	@media (max-width: 992px) {
		.hero h1 {
			font-size: 3rem;
		}
		
		.about-content,
		.signup-container {
			grid-template-columns: 1fr;
		}
		
		.about-image {
			order: -1;
		}
	}

	@media (max-width: 768px) {
		.nav-links {
			position: fixed;
			top: 80px;
			left: -100%;
			width: 100%;
			height: calc(100vh - 80px);
			background: var(--primary);
			flex-direction: column;
			align-items: center;
			padding-top: 3rem;
			gap: 2rem;
			transition: left 0.3s ease;
		}

		.nav-links.active {
			left: 0;
		}

		.hamburger {
			display: block;
		}

		.hero h1 {
			font-size: 2.5rem;
		}

		.hero p {
			font-size: 1.1rem;
		}

		.btn {
			padding: 0.8rem 2rem;
		}

		.section-header h2 {
			font-size: 2rem;
		}
	}

	@media (max-width: 576px) {
		.hero {
			padding: 4rem 0;
		}

		.hero h1 {
			font-size: 2rem;
		}

		.btn-group {
			display: flex;
			flex-direction: column;
			gap: 1rem;
		}

		.btn-outline {
			margin-left: 0;
		}
	}
	.cta p {
		padding-bottom: 15px;
	}
	section.cta {
		padding-bottom: 30px !important;
	}
	.form-footer {
		padding-top: 1rem;
	}

	/* Toast notification animations */
	@keyframes fadeIn {
	  from { opacity: 0; transform: translateY(-20px); }
	  to { opacity: 1; transform: translateY(0); }
	}
	@keyframes fadeOut {
	  from { opacity: 1; transform: translateY(0); }
	  to { opacity: 0; transform: translateY(-20px); }
	}
	/* Toast notifications */
	.toast {
		font-size: 0.9rem;
		margin-bottom: 0.5rem;
		box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
	}

	.toast-body {
		padding: 0.75rem;
	}

	.success-icon {
	  font-size: 4rem;
	  color: #28a745;
	}

	.animate-tick {
	  animation: tickPop 0.6s ease;
	}

	@keyframes tickPop {
	  0% {
		transform: scale(0.3);
		opacity: 0;
	  }
	  50% {
		transform: scale(1.3);
		opacity: 1;
	  }
	  100% {
		transform: scale(1);
	  }
	}

	#registrationSuccessModal .modal-content{
		text-align:center;
	}
	.cutid{
		font-size:1.25rem;
		font-weight:bold;
	}
	.gtvchra{
		background-color: #FFD700; 
		color: #000; 
		border: none; 
		padding: 14px 28px; 
		font-size: 18px; 
		font-weight: bold; 
		border-radius: 30px; cursor: 
		pointer; 
		transition: background-color 0.3s ease; 
		width: 100%; max-width: 250px; 
		display: inline-block; 
		text-decoration: none; 
		text-align: center; 
		box-shadow: 0 4px 8px rgba(0,0,0,0.2);
	}
	.gtvchrdv{
		width:100%; 
		text-align:center; 
		margin:40px 0;
	}
	#overlay {
		display: none;
		position: fixed;
		top: 0; left: 0;
		width: 100%; height: 100%;
		background-color: rgba(0,0,0,0.5);
		z-index: 1000;
		justify-content: center;
		align-items: center;
		color: white;
		font-size: 20px;
		font-weight: bold;
	}

	   /* Toast message */
	#toast {
		visibility: hidden;
		min-width: 200px;
		background-color: #28a745;
		color: white;
		text-align: center;
		border-radius: 8px;
		padding: 12px 24px;
		position: fixed;
		z-index: 1001;
		left: 50%;
		bottom: 30px;
		transform: translateX(-50%);
		font-size: 16px;
		box-shadow: 0 4px 6px rgba(0,0,0,0.3);
		transition: visibility 0s, opacity 0.5s ease;
		opacity: 0;
	}

	#toast.show {
		visibility: visible;
		opacity: 1;
	}
	.voucher-btn {
		background-color: #FFD700;
		color: #000;
		border: none;
		padding: 14px 28px;
		font-size: 18px;
		font-weight: bold;
		border-radius: 30px;
		cursor: pointer;
		max-width: 250px;
		display: block;
		margin: 40px auto;
		text-align: center;
		box-shadow: 0 4px 8px rgba(0,0,0,0.2);
		transition: background-color 0.3s ease;
	}

	.voucher-btn:hover {
		background-color: #e6c200;
	}
</style>
</head>
<body>
	<div class="top-bar" style="background-color: #f8f9fa; padding: 5px 0; font-size: 14px;">
	    <div class="container d-flex justify-content-between align-items-center">
	        <div class="contact-info">
	            <i class="fas fa-phone-alt"></i> <span>+91 92047 13346</span>
	        </div>
	        <div class="whatsapp-link">
				<a href="https://chat.whatsapp.com/Jr0htOmKW8f4r9hS63zT23" target="_blank" style="text-decoration: none; color: #25D366;">
	                <i class="fab fa-whatsapp"></i> Join on WhatsApp
	            </a>
	        </div>
	    </div>
	</div>
    <!-- Header -->
    <header>
        <div class="container">
            <nav>
                <div class="logo">
                    <i class="fas fa-coins logo-icon"></i>
                    <span>ProTraders</span>
                </div>
                <ul class="nav-links">
                    <li class="active"><a href="#home">Home</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#services">Services</a></li>
                    <li><a href="#signup" id="signup-tab">Sign Up</a></li>
                    <li><a href="#" id="login-tab">Login</a></li>
                </ul>
				
                <div class="hamburger">
                    <i class="fas fa-bars"></i>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Content Sections -->
    <main>
        <!-- Home Page -->
        <section id="home-page">
            <!-- Hero Section -->
            <section class="hero">
                <div class="hero-content">
                    <h1>Maximize Your Earnings with Smart Investments</h1>
                    <p>Join thousands of investors earning weekly returns through our proven ROI system and referral network</p>
                    <div class="btn-group">
                        <a href="#signup" class="btn">Get Started</a>
                        <a href="#services" class="btn btn-outline">View Packages</a>
                    </div>
					<div class="gtvchrdv"> 
						 <button class="voucher-btn" onclick="downloadVoucher()">GET VOUCHER</button> 
					</div>
                </div>
            </section>
            <!-- Features Section -->
            <section class="features">
                <div class="container">
                    <div class="section-header">
                        <h2>Our Earning System</h2>
                        <p>Multiple ways to grow your wealth through our comprehensive platform</p>
                    </div>
                    <div class="features-grid">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <h3>ROI Income</h3>
                            <p>Earn 5% ROI daily on weekdays, up to 120 credited days per investment package.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <h3>Direct Bonus</h3>
                            <p>Get 5% instant bonus for every direct referral who joins with your link.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-code-branch"></i>
                            </div>
                            <h3>Binary Bonus</h3>
                            <p>Earn 10% on team volume based on your referral network structure.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <h3>Reward Income</h3>
                            <p>Luxury rewards and cash bonuses for top performers in our network.</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- How It Works Section -->
            <section class="steps">
                <div class="container">
                    <div class="section-header">
                        <h2>How It Works</h2>
                        <p>Start earning in just 4 simple steps</p>
                    </div>
                    <div class="steps-container">
                        <div class="step-card">
                            <div class="step-number">1</div>
                            <h3>Sign Up</h3>
                            <p>Create your free account in less than 2 minutes</p>
                        </div>
                        <div class="step-card">
                            <div class="step-number">2</div>
                            <h3>Choose Package</h3>
                            <p>Select an investment package that fits your budget</p>
                        </div>
                        <div class="step-card">
                            <div class="step-number">3</div>
                            <h3>Build Team</h3>
                            <p>Share your referral link to earn bonuses</p>
                        </div>
                        <div class="step-card">
                            <div class="step-number">4</div>
                            <h3>Earn Weekly</h3>
                            <p>Receive ROI payments every 5 days</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Testimonials Section -->
            <section class="testimonials">
                <div class="container">
                    <div class="section-header">
                        <h2>Success Stories</h2>
                        <p>What our members say about their experience</p>
                    </div>
                    <div class="testimonial-grid">
                        <div class="testimonial-card">
                            <p class="testimonial-text">"I've earned over $12,000 in ROI payments in just 4 months. The weekly payouts are consistent and the referral bonuses are amazing!"</p>
                            <div class="testimonial-author">
                                <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="Sarah J." class="author-avatar">
                                <div class="author-info">
                                    <h4>Sarah J.</h4>
                                    <p>Member since 2024</p>
                                </div>
                            </div>
                        </div>
                        <div class="testimonial-card">
                            <p class="testimonial-text">"The binary bonus system helped me earn an extra $3,500 last month from my team's activity. This platform really rewards your effort."</p>
                            <div class="testimonial-author">
                                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Michael T." class="author-avatar">
                                <div class="author-info">
                                    <h4>Michael T.</h4>
                                    <p>Top Earner</p>
                                </div>
                            </div>
                        </div>
                        <div class="testimonial-card">
                            <p class="testimonial-text">"I started with just $500 and now I'm earning weekly returns while building my network. The dashboard makes tracking everything so easy."</p>
                            <div class="testimonial-author">
                                <img src="https://randomuser.me/api/portraits/women/68.jpg" alt="Lisa M." class="author-avatar">
                                <div class="author-info">
                                    <h4>Lisa M.</h4>
                                    <p>New Member</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </section>

        <!-- About Page -->
        <section id="about-page" style="display: none;">
            <section class="about">
                <div class="container">
                    <div class="about-content">
                        <div class="about-image">
                            <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=2070&auto=format&fit=crop" alt="Our Office">
                        </div>
                        <div class="about-text">
                            <h2>About ProTraders</h2>
                            <p>Founded in 2025, ProTraders was created to democratize wealth building through innovative investment strategies and community-powered growth.</p>
                            <p>Our mission is to provide accessible financial opportunities while rewarding members for helping others achieve financial freedom.</p>
                            <p>With over 15,000 active members and $4.2M in payouts to date, we've created a proven system that benefits everyone in our network.</p>
                            <a href="#signup" class="btn">Join Our Community</a>
                        </div>
                    </div>
                </div>
            </section>

            <section class="team">
                <div class="container">
                    <div class="section-header">
                        <h2>Meet Our Leadership</h2>
                        <p>The experienced team guiding our platform's success</p>
                    </div>
                    <div class="team-grid">
                        <div class="team-card">
                            <img src="https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=1887&auto=format&fit=crop" alt="CEO" class="team-image">
                            <div class="team-info">
                                <h3>David Wilson</h3>
                                <p>CEO & Founder</p>
                                <p>15+ years in fintech and investment</p>
                            </div>
                        </div>
                        <div class="team-card">
                            <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=1888&auto=format&fit=crop" alt="CFO" class="team-image">
                            <div class="team-info">
                                <h3>Sarah Johnson</h3>
                                <p>Chief Financial Officer</p>
                                <p>Former hedge fund manager</p>
                            </div>
                        </div>
                        <div class="team-card">
                            <img src="https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=1887&auto=format&fit=crop" alt="CTO" class="team-image">
                            <div class="team-info">
                                <h3>Michael Chen</h3>
                                <p>Chief Technology Officer</p>
                                <p>Blockchain and security expert</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </section>

        <!-- Services Page -->
        <section id="services-page" style="display: none;">
            <section class="services">
                <div class="container">
                    <div class="section-header">
                        <h2>Investment Packages</h2>
                        <p>Choose the package that matches your financial goals</p>
                    </div>
                    
					<table class="package-table">
	                    <thead>
	                        <tr>
	                            <th>Price</th>
	                            <th>Daily ROI</th>
	                            <th>Duration</th>
	                            <th>Daily return</th>
	                            <th>Total Return</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <tr>
	                            <td>2,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>149.95</td>
	                            <td>17,994.00</td>
	                        </tr>
	                         <tr>
	                            <td>4,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>249.95</td>
	                            <td>29,994.00</td>
	                        </tr>
	                         <tr>
	                            <td>9,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>499.95</td>
	                            <td>59,994.00</td>
	                        </tr>
							 <tr>
	                            <td>24,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>1,249.95</td>
	                            <td>149,994.00</td>
	                        </tr>
							 <tr>
	                            <td>49,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>2,499.95</td>
	                            <td>299,994.00</td>
	                        </tr>
							 <tr>
	                            <td>74,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>3,749.95</td>
	                            <td>449,994.00</td>
	                        </tr>
							 <tr>
	                            <td>99,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>4,999.95</td>
	                            <td>599,994.00</td>
	                        </tr>
							 <tr>
	                            <td>199,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>9,999.95</td>
	                            <td>1,199,994.00</td>
	                        </tr>
							 <tr>
	                            <td>299,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>14,999.95</td>
	                            <td>1,799,994.00</td>
	                        </tr>
							 <tr>
	                            <td>499,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>24,999.95</td>
	                            <td>2,999,994.00</td>
	                        </tr>
							 <tr>
	                            <td>999,999</td>
	                            <td>5%</td>
	                            <td>120 days</td>
	                            <td>49,999.95</td>
	                            <td>5,999,994.00</td>
	                        </tr>
	                    </tbody>
	                </table>
                    <div class="bonus-tables">
						<div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-sitemap"></i>
                            </div>
                            <h3>Direct</h3>
                            <p>Get 5% on each direct referral’s first package purchase.</p>
                        </div>							
						<div class="feature-card">
							<div class="feature-icon">
							 	<i class="fas fa-user-friends"></i>
							 </div>
							 <h3>Binary Bonus</h3>
							 <p>Unlock 10% when binary referrals complete their first package activation.</p>
						</div>
                    </div>

                    <div class="section-header">
                        <h2>Reward System</h2>
                        <p>Achieve these milestones to unlock special rewards</p>
                    </div>

                    <div class="features-grid">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fa-solid fa-mobile-screen-button"></i>
                            </div>
                            <h3>iPhone</h3>
                            <p>Earn the latest iPhone by referring 5:5 active members.</p>
                        </div>
						<div class="feature-card">
                            <div class="feature-icon">
                                <i class="fa-solid fa-motorcycle"></i></i>
                            </div>
                            <h3>Bike</h3>
                            <p>Get rewarded with a Royal Enfield or Jawa bike when you reach 10:10 active referrals.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-gem"></i>
                            </div>
                            <h3>Gold</h3>
                            <p>Unlock &#8377;4 Lakh worth of gold by achieving a 25:25 active members.</p>
                        </div>
						<div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-car"></i>
                            </div>
                            <h3>Car Bonus</h3>
                            <p>Unlock a Swift car reward by reaching a balanced 50:50 active member.</p>
                        </div>
                    </div>
                </div>
            </section>
        </section>

        <!-- Signup Page -->
        <section id="signup-page" style="display: none;">
            <section class="signup">
                <div class="container">
                    <div class="signup-container">
                        <div class="signup-form">
                            <h2>Create Your Account</h2>
                            <form>
                                <div class="form-group">
                                    <label for="fullname">Full Name</label>
                                    <input type="text" id="fullname" placeholder="Enter your full name" required>
                                </div>
                                <div class="form-group">
                                    <label for="email">Email Address</label>
                                    <input type="email" id="email" placeholder="Enter your email" required>
                                </div>
                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel" id="phone" placeholder="Enter your phone number" required>
                                </div>
                                <div class="form-group">
                                    <label for="password">Password</label>
                                    <input type="password" id="password" placeholder="Create a password" required>
                                </div>
								<c:choose>
								    <c:when test="${not empty referrer}">
								        <div class="form-group">
								            <label for="referral">Referral ID (Optional)</label>
								            <input type="text" id="referral" placeholder="Enter referral code if any" value="${referrer}" readonly>
								        </div>
								    </c:when>
								    <c:otherwise>
								            <input type="hidden" id="referral" value="">
								    </c:otherwise>
								</c:choose>
								<div class="form-group">
								  <label for="position">Position(Optional)</label>
								  <select id="positionSelect" class="form-select" aria-label="Default select example" name="position">
								    <option value="" disabled selected>Select Position...</option>
								    <option value="1" ${position == '1' ? 'selected' : ''}>Left</option>
								    <option value="2" ${position == '2' ? 'selected' : ''}>Right</option>
								  </select>
								</div>
                                <button type="submit" class="signup-btn">Create Account</button>
                            </form>
                        </div>
                        <div class="signup-benefits">
                            <h2>Why Join ProTraders?</h2>
                            <ul class="benefits-list">
                                <li><i class="fas fa-check-circle"></i> Get rewarded with ROI from Monday to Friday, for 120 days</li>
                                <li><i class="fas fa-check-circle"></i> 5% direct referral bonus</li>
                                <li><i class="fas fa-check-circle"></i> 10% binary matching bonus</li>
                                <li><i class="fas fa-check-circle"></i> Luxury reward incentives</li>
                                <li><i class="fas fa-check-circle"></i> 24/7 customer support</li>
                                <li><i class="fas fa-check-circle"></i> Secure and transparent system</li>
                                <li><i class="fas fa-check-circle"></i> Daily withdrawal availability</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>
        </section>
    </main>

    <!-- CTA Section -->
    <section class="cta">
        <div class="container">
            <h2>Ready to Start Building Your Wealth?</h2>
            <p>Join our community today and begin your journey to financial freedom</p>
            <a href="#signup" class="btn">Sign Up Now</a>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-column">
                    <h3>ProTraders</h3>
                    <p>The next-generation investment platform for smart investors.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="https://chat.whatsapp.com/HaeRbOcDz808GrbXigMaS8" target="_blank"><i class="fab fa-whatsapp"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-telegram"></i></a>
                    </div>
                </div>
                <div class="footer-column">
                    <h3>Quick Links</h3>
                    <ul class="footer-links">
                        <li><a href="#home">Home</a></li>
                        <li><a href="#about">About Us</a></li>
                        <li><a href="#services">Services</a></li>
                        <li><a href="#">FAQ</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Contact</h3>
                    <ul class="footer-links">
                        <!--<li><a href="mailto:support@wealthbuilderpro.com">support@wealthbuilderpro.com</a></li>-->
                        <li>123 Investment Ave, Financial District</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 ProTraders. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Login Modal -->
    <div class="modal" id="login-modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2>Welcome Back</h2>
            <form>
                <div class="form-group">
                    <label for="login-email">Customer Id</label>
                    <input type="text" id="login-email" placeholder="Enter your Customer Id">
                </div>
                <div class="form-group">
                    <label for="login-password">Password</label>
                    <input type="password" id="login-password" placeholder="Enter your password">
                </div>
                <button type="submit" class="signup-btn">Sign In</button>
                <div class="form-footer">
                    New to ProTraders? <a href="#signup">Create account</a>
                </div>
            </form>
        </div>
    </div>
	<div class="modal" id="registrationSuccessModal">
        <div class="modal-content">
			<span class="close-modal">&times;</span>                
            <div class="modal-body">
				<i class="fas fa-check-circle animate-tick success-icon mb-3"></i>
		       <h5 class="modal-title mb-2">Registration Successful!</h5>
		       <p id="modalCustomerIdText" class="mb-3">Your Customer ID: <span id="custIdText"></p>
			</div>
        </div>
    </div>
	<div id="toastContainer" class="position-fixed top-0 end-0 p-3" style="z-index: 1100"></div>
	<div id="overlay">&#x23F3; Please wait while we download your voucher...</div>
	<form action="index" method="post" name="login">
		<input type="hidden" value="" name="sid">			 
		<input type="hidden" value="" name="pid">
	</form>
	<script>
		window.addEventListener('DOMContentLoaded', () => {
	       const shouldShowSignup = "${showSignup}" === "true"; // true or false from Spring Boot controller

	       if (shouldShowSignup) {
	           const signupTab = document.getElementById("signup-tab");
	           if (signupTab) {
	               signupTab.click(); // this will activate the tab programmatically
	           }
	       }
	   });
		// Mobile Menu Toggle
		const hamburger = document.querySelector('.hamburger');
		const navLinks = document.querySelector('.nav-links');
		hamburger.addEventListener('click', () => {
			navLinks.classList.toggle('active');
		});

		// Close mobile menu when clicking a link
		document.querySelectorAll('.nav-links a').forEach(link => {
			link.addEventListener('click', () => {
				navLinks.classList.remove('active');
			});
		});

		// Modal Handling
		const loginModal = document.getElementById('login-modal');
		const loginTab = document.getElementById('login-tab');
		const closeModals = document.querySelectorAll('.close-modal');

		function openModal(modal) {
			modal.style.display = 'flex';
			document.body.style.overflow = 'hidden';
		}

		function closeModal(modal) {
			modal.style.display = 'none';
			document.body.style.overflow = 'auto';
		}

		// Login modal
		loginTab.addEventListener('click', (e) => {
			e.preventDefault();
			openModal(loginModal);
		});

		// Signup links
		document.querySelectorAll('a[href="#signup"]').forEach(link => {
			link.addEventListener('click', (e) => {
				e.preventDefault();
				showPage('signup-page');
			});
		});

		// Close modals
		closeModals.forEach(btn => {
			btn.addEventListener('click', () => {
				const modal = btn.closest('.modal');
				closeModal(modal);
			});
		});

		// Close when clicking outside modal
		/*window.addEventListener('click', (e) => {
			if (e.target === loginModal) closeModal(loginModal);
			if (e.target === signupModal) closeModal(signupModal);
		});*/

		// Page Navigation System
		function showPage(pageId) {
			// Hide all pages
			document.querySelectorAll('main > section').forEach(section => {
				section.style.display = 'none';
			});
			
			// Show requested page
			if(pageId) {
				document.getElementById(pageId).style.display = 'block';
			}
			
			// Update active nav link
			document.querySelectorAll('nav li').forEach(li => {
				li.classList.remove('active');
			});
			
			if(pageId === 'home-page' || !pageId) {
				document.querySelector('nav li:first-child').classList.add('active');
			} else {
				const navItem = document.querySelector(`nav a[href="#${pageId.replace('-page', '')}"]`);
				if(navItem) navItem.parentElement.classList.add('active');
			}
			
			// Scroll to top
			window.scrollTo(0, 0);
		}

		// Initialize page based on URL hash
		window.addEventListener('load', () => {
			const hash = window.location.hash.substring(1);
			if(hash) {
				showPage(hash+"-page");
			} else {
				showPage('home-page');
			}
		});

		// Handle navigation clicks
		document.querySelectorAll('nav a[href^="#"]').forEach(link => {
			link.addEventListener('click', function(e) {
				const href = this.getAttribute('href');
				if(href === '#') return;
				
				e.preventDefault();
				const pageId = href.substring(1);
				showPage(pageId+'-page');
				history.pushState(null, null, href);
			});
		});

		// Handle browser back/forward
		window.addEventListener('popstate', () => {
			const hash = window.location.hash.substring(1);
			if(hash) {
				showPage(hash+'-page');
			} else {
				showPage('home-page');
			}
		});

		// Backend API Integration
		const BASE_URL = 'https://your-api-endpoint.com'; // Replace with your actual backend URL

		// Registration Function
		async function registerUser(userData) {
			try {
				const response = await fetch(`auth/register`, {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify(userData)
				});

				const data = await response.json();

				if (!response.ok) {
					throw new Error(data.message || 'Registration failed');
				}

				return data;
			} catch (error) {
				console.error('Registration error:', error);
				throw error;
			}
		}

		// Login Function
		async function loginUser(credentials) {
			try {
				const response = await fetch(`auth/login`, {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify(credentials)
				});

				const data = await response.json();

				if (!response.ok) {
					throw new Error(data.message || 'Login failed');
				}

				return data;
			} catch (error) {
				console.error('Login error:', error);
				throw error;
			}
		}

		// Signup Form Submission
		document.querySelector('#signup-page form, #signup-modal form').addEventListener('submit', async (e) => {
			e.preventDefault();
			
			const form = e.target;
			const submitButton = form.querySelector('button[type="submit"]');
			const originalButtonText = submitButton.textContent;
			const position =document.getElementById('positionSelect').value;
			const fullName = form.querySelector('#fullname, #modal-fullname').value;
			const mobileNumber = form.querySelector('#phone, #modal-phone').value;
			const email = form.querySelector('#email, #modal-email').value;
			const password = form.querySelector('#password, #modal-password').value;
			if (fullName === "") {
			   showToast("Full Name is required.");
			   return;
		   }

		   if (!/^\d{10}$/.test(mobileNumber)) {
			   showToast("Mobile number must be exactly 10 digits.");
			   return;
		   }

		   if (!/^[\w.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(email)) {
			   showToast("Enter a valid email address.");
			   return;
		   }

		   if (password.length < 6) {
			   showToast("Password must be at least 6 characters.");
			   return;
		   }
		   if(position.length==0){
				showToast("Position must be selected.");
				return;
		   }
			// Get form data
			const userData = {
				email: email,
				fullName: fullName,
				mobileNumber: mobileNumber,
				password: password,
				sponsorId: form.querySelector('#referral, #modal-referral').value || null,
				position: position || null
			};

			// Disable button during submission
			submitButton.disabled = true;
			submitButton.textContent = 'Processing...';

			try {
				const response = await registerUser(userData);
				
				// Show success message
				if(response.customerId&&response.customerId.length>0){
					document.getElementById('custIdText').textContent = response.customerId;
					// Show modal
					document.getElementById('registrationSuccessModal').style.display = 'flex';
				}
				// Close modal if in modal
				/*if (form.closest('.modal')) {
					closeModal(signupModal);
				}*/
				
				// Clear form
				form.reset();
				
			} catch (error) {
				showToast(error.message || 'Registration failed. Please try again.');
			} finally {
				// Re-enable button
				submitButton.disabled = false;
				submitButton.textContent = originalButtonText;
			}
		});

		// Login Form Submission
		document.querySelector('#login-modal form').addEventListener('submit', async (e) => {
			e.preventDefault();
			
			const form = e.target;
			const submitButton = form.querySelector('button[type="submit"]');
			const originalButtonText = submitButton.textContent;
			
			// Get form data
			const credentials = {
				username: form.querySelector('#login-email').value,
				password: form.querySelector('#login-password').value
			};

			// Disable button during submission
			submitButton.disabled = true;
			submitButton.textContent = 'Logging in...';

			try {
				const response = await loginUser(credentials);
				
				// Store the token if your backend returns one
				if (response.token) {
					localStorage.setItem('authToken', response.token);
				}else if(response.errCd!=0){
					showToast(response.errMsg || 'Login failed. Please try again.');
					return;
				}else{
					const form = document.forms['login'];
					form['sid'].value = response.sid;
					form['pid'].value = response.pid;
					form.submit();
				}
			} catch (error) {
				alert(error.message || 'Login failed. Please check your credentials and try again.');
			} finally {
				// Re-enable button
				submitButton.disabled = false;
				submitButton.textContent = originalButtonText;
			}
		});
		function showToast(message, type = 'danger') {
			const toastContainer = document.getElementById('toastContainer');
			const toastId = 'toast-'+Date.now();
			
			const toast = document.createElement('div');
			toast.className = 'toast show align-items-center text-white bg-'+type+' border-0';
			toast.id = toastId;
			toast.role = 'alert';
			toast.setAttribute('aria-live', 'assertive');
			toast.setAttribute('aria-atomic', 'true');
			
			toast.innerHTML = '<div class="d-flex align-items-center"><div class="toast-body d-flex align-items-center">'+message+'</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button></div>';
			
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

		function showOverlay() {
		  document.getElementById("overlay").style.display = "flex";
		}

		function hideOverlay() {
		  document.getElementById("overlay").style.display = "none";
		}

		function downloadVoucher() {
		  showOverlay();

		  fetch('dwnldpdf/pdf')
			.then(response => {
			  if (!response.ok) throw new Error("Download failed");
			  return response.blob();
			})
			.then(blob => {
			  const url = window.URL.createObjectURL(blob);
			  const link = document.createElement('a');
			  link.href = url;
			  link.download = 'ProTrader_Voucher.pdf';
			  document.body.appendChild(link);
			  link.click();
			  link.remove();
			  URL.revokeObjectURL(url);

			  hideOverlay();
			  showToast("Voucher downloaded successfully!","success");
			})
			.catch(error => {
			  hideOverlay();
			  showToast("Failed to download voucher.",'danger');
			  console.error("Download error:", error);
			});
		}
	</script>	
</body>
</html>