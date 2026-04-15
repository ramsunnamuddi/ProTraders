<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>jQuery Date Picker Example</title>
    
    <!-- Include jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Include jQuery UI CSS (for datepicker styling) -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    
    <!-- Include jQuery UI JS (for datepicker functionality) -->
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <!-- Add some basic styling -->
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 50px;
        }

        .container {
            width: 300px;
            margin: 0 auto;
        }

        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }

        .response {
            margin-top: 20px;
            font-size: 18px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Simple AJAX Call Example</h2>
    <form id="ajaxForm">
        <label for="inputText">Enter Some Text:</label>
        <input type="text" id="inputText" name="inputText" required />
        <button type="submit">Submit</button>
    </form>

    <div class="response" id="responseDiv"></div>
</div>

<!-- jQuery AJAX Script -->
<script>
    $(document).ready(function() {
        $('#ajaxForm').on('submit', function(event) {
            event.preventDefault(); // Prevent the form from submitting normally

            var inputText = $('#inputText').val(); // Get the value of the input field

            // Make an AJAX request
            $.ajax({
                url: "/txn/addfunds", // JSP file to handle the server-side processing
                type: 'POST',
				contentType: 'application/json',
                data: JSON.stringify({
                    amount: inputText  // Sending the amount value from the input
                }), // Send the data to the server
                success: function(response) {
                    // On success, display the response in the div
                    $('#responseDiv').html(response);
                },
                error: function(xhr, status, error) {
                    // If there's an error, show an error message
                    $('#responseDiv').html("Error: " + error);
                }
            });
        });
    });
</script>

</body>
</html>
