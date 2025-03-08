<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="./node_modules/jquery/dist/jquery.min.js"></script>
<script src="js/jquery.loading-indicator.js"></script>
<link type="text/css" rel="stylesheet"
	href="css/jquery.loading-indicator.css" />
<title>Insert title here</title>
<script>
	$(function() {
		$("button").click(function() {
			var homeLoader = $('body').loadingIndicator({
				useImage : false,
			}).data("loadingIndicator");
		});
	});
</script>
</head>
<body>
	<button>Aaaa</button>
</body>
</html>