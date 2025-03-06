<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>jQuery UI Example</title>

    <!-- jQuery & jQuery UI -->
    <script src="<c:url value='/js/jquery-3.7.1.min.js' />"></script>
    <script src="<c:url value='/js/jquery-ui.min.js' />"></script>
    <link rel="stylesheet" href="<c:url value='/css/jquery-ui.min.css' />">
	<style>
		.body {
		  display: flex;
		  justify-content: center;
		  align-items: center;
		  height: 100px;
		  margin: 0;
		  background-color: #f0f0f0;
		}

		.coin {
		  position: relative;
		  width: 100px;
		  height: 100px;
		  background-color: #d4af37; /* Coin color */
		  border-radius: 50%;
		  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.3); /* Coin shadow */
		  background-image: radial-gradient(
		    circle at 50% 120%,
		    rgba(255, 255, 255, 0.5) 0%,
		    rgba(255, 255, 255, 0) 80%
		  ); /* Coin texture */
		  animation: flip 1s infinite;
		}

		.engraving {
		  position: absolute;
		  top: 50%;
		  left: 50%;
		  transform: translate(-50%, -50%);
		  font-size: 50px;
		  font-weight: bold;
		  color: rgba(0, 0, 0, 0.5); /* Engraving color */
		  text-shadow: 1px 1px 1px rgba(255, 255, 255, 0.5); /* Engraving shadow */
		}

		@keyframes flip {
		  0% {
		    transform: rotateY(0deg);
		  }
		  50% {
		    transform: rotateY(180deg);
		  }
		  100% {
		    transform: rotateY(360deg);
		  }
		}

	</style>
    <!-- jQuery UI Activation -->
    <script>
        $(document).ready(function () {
            $("#tabs").tabs(); // Activate Tabs
            $("#accordion").accordion(); // Activate Accordion
            $(".ui-button").button(); // Apply jQuery UI button styles

            // Initialize Popup Dialog (Hidden by Default)
            $("#popupDialog").dialog({
                autoOpen: false,
                modal: true,
                buttons: {
                    "Close": function () {
                        $(this).dialog("close");
                    }
                }
            });

            // Show Popup on Primary Button Click
            $("#primaryButton").click(function () {
                $("#popupDialog").dialog("open");
            });

            // Show Loading Overlay on Secondary Button Click
            $("#secondaryButton").click(function () {
                $("#loadingOverlay").show();
            });
        });
    </script>

    <!-- Loading Overlay Styles https://uiverse.io/ram_1286/dry-stingray-64-->
    <style>
        #loadingOverlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
        }
        #loadingMessage {
            position: absolute;
            top: 50%;
            left: 50%;
        }
    </style>
</head>
<body>

    <!-- Tabs -->
    <div id="tabs">
        <ul>
            <li><a href="#tab-1">Tab 1</a></li>
            <li><a href="#tab-2">Tab 2</a></li>
            <li><a href="#tab-3">Tab 3</a></li>
        </ul>
        <div id="tab-1">
            <p>Content for Tab 1.</p>
        </div>
        <div id="tab-2">
            <p>Content for Tab 2.</p>
        </div>
        <div id="tab-3">
            <p>Content for Tab 3.</p>
        </div>
    </div>

    <!-- Buttons -->
    <div class="buttons">
        <button id="primaryButton" class="ui-button">Primary Button</button>
        <button id="secondaryButton" class="ui-button">Secondary Button</button>
    </div>

    <!-- Popup Dialog -->
    <div id="popupDialog" title="Popup Title">
        <p>This is a jQuery UI popup dialog!</p>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay">
		<div class="coin" id="loadingMessage">
			  <span class="engraving">₹</span>
		</div>
    </div>

    <!-- Accordion -->
    <div id="accordion">
        <h3>Accordion 1</h3>
        <div>
            <p>Details for Accordion 1.</p>
        </div>
        <h3>Accordion 2</h3>
        <div>
            <p>Details for Accordion 2.</p>
        </div>
        <h3>Accordion 3</h3>
        <div>
            <p>Details for Accordion 3.</p>
        </div>
    </div>

    <!-- Images 
    <div>
        <img src="<c:url value='/images/image1.jpg' />" alt="Image 1">
        <img src="<c:url value='/images/image2.jpg' />" alt="Image 2">
        <img src="<c:url value='/images/image3.jpg' />" alt="Image 3">
    </div>-->
	


</body>
</html>
