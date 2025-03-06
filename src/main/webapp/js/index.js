function loadContent(page,element) {
	const URL = "https://6bcc-2405-201-c025-f00c-6dbf-a228-ce1c-399e.ngrok-free.app"
    $.ajax({
        url: URL+"/api/auth/validate",
        type: "GET",
        success: function (response) {
            if (response === "INVALID" || response === "EXPIRED") {
                alert("Session expired. Please log in again.");
               window.location.href = "/";
            } else {
                $("#containerFrame").attr("src", page);
				document.querySelectorAll("div.nav-mn-itm").forEach(el => el.classList.remove("active"));
				element.classList.add("active");
            }
        }
    });
}