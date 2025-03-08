<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="css/jquery-loading.css" rel="stylesheet">
<script src="./node_modules/jquery/dist/jquery.min.js"></script>
<script src="js/jquery-loading.js"></script>

<title>Insert title here</title>
<style type="text/css">
.js-loading-overlay {
	background-color: rgba(0, 0, 0, .5);
	width: 100%;
	height: 100%;
	position: absolute;
	top: 0;
	left: 0;
}
</style>

</head>
<body>
	<div class="card">
		<div>
			<br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br />
			<br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br />
			<br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br />
		</div>
	</div>
</body>
<script>
	$(document).ready(function() {

		$('.card').loading({
			circles : 3,
			overlay : true,
			base : 0.3,

		});

	})
</script>
</html>