
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
			var lgfrm = document.getElementById("lgnfrm");
			usrNm=lgfrm.username.value,pwd =lgfrm.pwd.value;
		    if(vldLogin(usrNm,pwd)){
				doLogin(usrNm,pwd);
				return;
			}        
		 });
		 $("#register-dialog").dialog({
		       autoOpen: false, // Keep it hidden initially
		       modal: true,
		       width: 350
		   });
		   $("#position").selectmenu();
		 $("#new-user").click(function (event) {
			event.preventDefault(); // Prevent page reload

	        // Properly close the login dialog
	        $("#login-dialog").dialog("close");

	        // Open the Register Dialog
	        $("#register-dialog").dialog("open");
 		 });
		 
		 $("#register-btn").click(function () {
			var formDataArray = $("#registerfrm").serializeArray(); // Convert form data to key=value format
			console.log("Form Data:", formDataArray);
			var registerData = {}; 

		    $.each(formDataArray, function (idx,field) {
				registerData[field.name] = field.value; // Convert array to JSON object
			 });
	 	    if(vldRegFrm(registerData)){
	 			doRegister(registerData);
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
		$.ajax({
		    url: "/auth/login",
		    type: "POST",
		    contentType: "application/json",  // ✅ Important: Ensure JSON content type
		    data: JSON.stringify({ 
		        username: usrNm, 
		        password: pwd 
		    }),
		    success: function(response) {
				if(response !=null ){
					var errCd =  response.errCd;
					if(errCd!=null && errCd.length>0&&errCd==0){ 
						$("#login-dialog").dialog("close");
						window.location.href = "/index";
					}else {
						$("#login-dialog").dialog("close");
						if(errCd == "15" || errCd == "11"){
							Swal.fire({
							    icon: 'error',
							    title: 'Invalid Credentials',
							    text: "We couldn't find you in our records. To continue with us, please register.",
							    confirmButtonText: 'Register Now',
							    confirmButtonColor: '#FF0000',  // Red for error
								allowOutsideClick: false,  // Disable clicking outside to close the modal
								allowEscapeKey: false,   
						}).then(() => {
							$("#register-dialog").dialog("open");; // Redirect to login page after OK
						});
					}else if(errCd=='16'){
							// Authentication Failed
							Swal.fire({
							    icon: 'error',
							    title: 'Authentication Failed',
							    text: "We couldn't log you in as we are facing technical difficulties. Please try again later.",
							    confirmButtonText: 'Try Again Later',
							    confirmButtonColor: '#FF0000', // Red for error
								allowOutsideClick: false,  // Disable clicking outside to close the modal
								allowEscapeKey: false,  
							}).then(() => {
								$("#login-dialog").dialog("open");; // Redirect to login page after OK
							});
						}else if(errCd =='13'){
							// Duplicate Login
							Swal.fire({
							    icon: 'warning',
							    title: 'Duplicate Login',
							    text: "We found a duplicate login on another device please help to click here to logout  on all the other devices.",
							    confirmButtonText: 'Click here',
							    confirmButtonColor: '#FF9800',  // Orange for warning
								allowOutsideClick: false,  // Disable clicking outside to close the modal
								allowEscapeKey: false,  
							});
						}
					}
				}
				
		    },
		    error: function(xhr, status, error) {
		        console.error("Error:", xhr.responseText);
		    }
		});
   }
   
   function vldRegFrm(dt){
	console.log("Form Data:", dt);
	 return true;
   }
   
   function doRegister(registerDt){
	 var data =  JSON.stringify(registerDt);
	$.ajax({
	        url: "/auth/register",
	        type: "POST",
	        data: data,
			contentType: "application/json",
	        success: function(response) {
				if(response !=null && response.customerId!=null && response.customerId.length>0){
					$("#register-dialog").dialog("close");
					Swal.fire({
		                   icon: "success",
						   html: `<p class="popup-message">Your Customer ID: <strong>${response.customerId}</strong></p>`,
						       confirmButtonText: "Login",
						       customClass: {
						           popup: "custom-popup",
						           title: "custom-title",
						           confirmButton: "custom-button"
						       }
		               }).then(() => {
		                  $("#login-dialog").dialog("open");; // Redirect to login page after OK
		               });
				}
	        },
	        error: function(xhr, status, error) {
	            console.log("Error:", error);
	        }
	    });
   }