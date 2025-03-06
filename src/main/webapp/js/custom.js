
$(document).ready(function () {
	$(".tabs a").click(function(e){
        e.preventDefault(); // Prevent page jump

        // Remove active class from previous tab and add to clicked one
        $(".tabs a").removeClass("active");
        $(this).addClass("active");

        // Hide all tab content
        $(".tab-pane").removeClass("active").hide();

        // Show the clicked tab's content
        let target = $(this).attr("href");
        $(target).addClass("active").fadeIn(); // Fade-in effect
    });
	$("#login-dialog").hide();
       $("#popupDialog").dialog({
           autoOpen: false,
           modal: true,
		   width:500,
		   height:500,
		   closeOnEscape: false,
           buttons: {
               "Login": function () {
                   $(this).dialog("close");
               }
           }
       });
       // Show Loading Overlay on Secondary Button Click
       $("#loginDv").click(function() {
	   		$("#login-dialog").dialog({
	        	modal: true,
	            width: 350
	         });
	    });

        // Handle sub-tab click
       	$(".sub-tab").click(function () {
         	var target = $(this).data("target");
         	$(".invst-content").hide().removeClass("invest-cnt-actv"); // Hide all content
         	$("#" + target).show().addClass("invest-cnt-actv"); // Show selected content
			$(".sub-tab").removeClass("active"); // Remove active class from all tabs
			$(this).addClass("active"); 
         });
		 $('#contact-form').submit(function(event) {
            event.preventDefault();
            $('.thank-you').fadeIn();
            setTimeout(function() {
                $('.thank-you').fadeOut();
            }, 3000);
            this.reset();
       	 });
		 $("#login-btn").click(function () {
			var usrNm = $("#username").val().trim(),pwd = $("#password").val().trim();
		    if(vldLogin(usrNm,pwd)){
				doLogin(usrNm,pwd);
				return;
			}        
		 });
   });

   function vldLogin(usrNm,pwd){
        if (usrNm === "") {
            alert("Username cannot be empty");
            return false;
        }
        if (pwd === "") {
            alert("Password cannot be empty");
            return false;
        }
		return true;            
   }
   
   function doLogin(usrNm,pwd){
		const URL = "https://6bcc-2405-201-c025-f00c-6dbf-a228-ce1c-399e.ngrok-free.app"
		$.ajax({
            url: URL + "/api/auth/login",
            type: "POST",
            data: { username: usrNm, password: pwd },
            success: function (response) {
                if (response === "DUPLICATE") {
                    alert("Duplicate login detected. Please logout from the other session.");
                } else if (response === "SUCCESS") {
                    $("#login-dialog").dialog("close");
                     window.location.href = "/mainPage"; // Load main page
                } else {
                    alert("Login failed.");
                }
            },
            error: function () {
                alert("Error connecting to server. Please try again.");
            }
        });
   }