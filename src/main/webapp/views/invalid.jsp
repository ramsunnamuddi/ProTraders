<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
	function relogin (){
		window.location.href = "/";
	}
</script>
<h1>Not a valid Session</h1>
<h5>Please click <a href= "auth/logout">here</a> to relogin.
