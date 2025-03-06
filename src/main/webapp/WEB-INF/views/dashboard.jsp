<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grid with Header & Icon</title>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

		body {
		    background-color: #f4f4f4;
		    display: flex;
		    flex-direction: column;
		    align-items: center;
		    justify-content: flex-start;
		    min-height: 100vh;  /* Ensures full page height */
		    padding-top: 20px;
		    overflow-y: auto;  /* Allows scrolling if content overflows */
		}

		.container {
		    display: grid;
		    grid-template-columns: repeat(3, 1fr); /* 3 columns */
		    grid-template-rows: auto; /* Adjusts to fit all rows */
		    gap: 20px;
		    width: 80%;
		    max-width: 1000px;
		    margin-top: 20px;
		    padding-bottom: 20px; /* Extra space to prevent cutoff */
		}


        /* Increased Box Size */
        .box {
            background-color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 3px 3px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 120px; /* Increased Height */
            transition: 0.3s ease-in-out;
        }

        .box:hover {
            transform: scale(1.05);
            box-shadow: 5px 5px 18px rgba(0, 0, 0, 0.2);
        }

        /* Header & Icon Section */
        .box-header {
            display: flex;
            align-items: center;
            font-size: 16px; /* Slightly bigger font */
            font-weight: bold;
            text-transform: uppercase;
            color: #666666;
			font-family:calibri;
        }

        /* Icon (Next to Header) */
        .box-icon {
            font-size: 22px; /* Larger icon */
            color: #ff6b00;
            margin-right: 10px;
        }

        /* Content (Right-Aligned) */
        .box-content {
            font-size: 28px; /* Larger number */
            font-weight: bold;
            color: #999999;
            text-align: right;
			font-family:calibri;
        }

    </style>
</head>
<body>

    <!-- Grid Layout -->
    <div class="container">
        <div class="box">
            <div class="box-header">
                <i class="fas fa-users box-icon"></i> Active Directs
            </div>
            <div class="box-content">0</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-shopping-cart box-icon"></i> Total Items
            </div>
            <div class="box-content">12</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-envelope box-icon"></i> Left Business
            </div>
            <div class="box-content">5</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-tasks box-icon"></i> Right Business
            </div>
            <div class="box-content">3</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-chart-line box-icon"></i> Total Deposit
            </div>
            <div class="box-content">87%</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-coins box-icon"></i> ROI Bonus
            </div>
            <div class="box-content">$120K</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-bell box-icon"></i> Binary Bonus
            </div>
            <div class="box-content">8</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-clipboard-list box-icon"></i> Rank Income
            </div>
            <div class="box-content">23</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-clock box-icon"></i> Right Bonus
            </div>
            <div class="box-content">40h</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-project-diagram box-icon"></i> Total income
            </div>
            <div class="box-content">5</div>
        </div>
        <div class="box">
            <div class="box-header">
                <i class="fas fa-dollar-sign box-icon"></i> Total withdrawals
            </div>
            <div class="box-content">$2,500</div>
        </div>
		<div class="box">
           <div class="box-header">
               <i class="fas fa-clock box-icon"></i> Right Bonus
           </div>
           <div class="box-content">40h</div>
       </div>
       <div class="box">
           <div class="box-header">
               <i class="fas fa-project-diagram box-icon"></i> Available Balance
           </div>
           <div class="box-content">5</div>
       </div>
       <div class="box">
           <div class="box-header">
               <i class="fas fa-dollar-sign box-icon"></i> Reward
           </div>
           <div class="box-content">$2,500</div>
       </div>
    </div>

</body>
</html>


