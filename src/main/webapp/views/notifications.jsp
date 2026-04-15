<!DOCTYPE html>
<html>
<head>
    <title>Email Details</title>
    <style>
        body { font-family: sans-serif; }
        .email-header { border-bottom: 1px solid #ccc; padding-bottom: 10px; margin-bottom: 20px; }
        .email-body { white-space: pre-wrap; /* Preserve formatting */ }
        .email-actions { margin-top: 20px; }
        .email-actions button { padding: 8px 15px; margin-right: 10px; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div id="email-detail">
        <div class="email-header">
            <p><strong>From:</strong> <span id="email-from"></span></p>
            <p><strong>To:</strong> <span id="email-to"></span></p>
            <p><strong>Subject:</strong> <span id="email-subject"></span></p>
        </div>
        <div class="email-body" id="email-body"></div>
        <div class="email-actions" id="email-actions">
            </div>
        <button id="back-button">Back</button>
    </div>

    <script>
        function showEmailDetail(emailData) {
            $("#email-from").text(emailData.sender);
            $("#email-to").text(emailData.recipient);
            $("#email-subject").text(emailData.subject);
            $("#email-body").text(emailData.body);

            $("#email-actions").empty(); // Clear existing buttons
            if (emailData.actions) {
                emailData.actions.forEach(function(action) {
                    $("<button>").text(action).click(function() {
                        handleAction(action);
                    }).appendTo("#email-actions");
                });
            }
        }

        function handleAction(actionName) {
            console.log("Action '" + actionName + "' triggered");
            // Implement your action logic here
        }

        $(document).ready(function() {
            $("#back-button").click(function() {
                window.history.back(); // or hide the detail view
            });
        });
    </script>
</body>
</html>