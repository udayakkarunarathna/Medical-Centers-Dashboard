<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Dashboard | Medical Center</title>
<!-- plugins:css -->
<link rel="stylesheet"
	href="./node_modules/mdi/css/materialdesignicons.min.css">
<link rel="stylesheet"
	href="./node_modules/perfect-scrollbar/dist/css/perfect-scrollbar.min.css">
<!-- endinject -->
<!-- plugin css for this page -->
<link rel="stylesheet"
	href="./node_modules/font-awesome/css/font-awesome.min.css" />
<!-- End plugin css for this page -->
<!-- inject:css -->
<link rel="stylesheet" href="./css/style.css">
<!-- endinject -->
<link rel="shortcut icon" href="./images/favicon.png" />
<script src="./node_modules/jquery/dist/jquery.min.js"></script>
<script src="js/jquery.loading-indicator.js"></script>
<link type="text/css" rel="stylesheet"
	href="css/jquery.loading-indicator.css" />
<script>
	$(document).ready(function() {
		$("button").click(function() {
			var u_name = document.getElementById('u_name').value;
			u_name = u_name.trim();
			var password = document.getElementById('password').value;
			password = password.trim();
			var mc = document.getElementById('mc').value;

			if (u_name == "" || password == "" || mc == "*") {
			} else {
				var homeLoader = $('body').loadingIndicator({
					useImage : false,
				}).data("loadingIndicator");
			}
		});
	});
</script>
<style type="text/css">
blink {
  -webkit-animation: 2s linear infinite condemned_blink_effect; // for Safari 4.0 - 8.0
  animation: 2s linear infinite condemned_blink_effect;
}
@-webkit-keyframes condemned_blink_effect { // for Safari 4.0 - 8.0
  0% {
    visibility: hidden;
  }
  50% {
    visibility: hidden;
  }
  100% {
    visibility: visible;
  }
}
@keyframes condemned_blink_effect {
  0% {
    visibility: hidden;
  }
  50% {
    visibility: hidden;
  }
  100% {
    visibility: visible;
  }
}
</style>
</head>
<%
	//System.out.println("In the Login page");
	String error = "";
	if (request.getParameter("error") != null) {
		error = request.getParameter("error");
	}
%>
<body>
	<div class="container-scroller">
		<div class="container-fluid page-body-wrapper">
			<div class="row">
				<div
					class="content-wrapper full-page-wrapper d-flex align-items-center auth-pages">
					<div class="card col-lg-5 mx-auto">
						<div class="card-body px-5 py-5">
							<h3 class="card-title text-center mb-4">
								<u>Nawaloka Medical Center</u>
							</h3>
							<h4 class="card-title text-center mb-5">
								<u>Dashboard Login</u>
							</h4>
							<form method="post" action="LoginControl">
								<div class="form-group">
									<!-- <label>Username</label> -->
									<input type="text" name="u_name" id="u_name"
										required="required" placeholder="User Name"
										style="font-weight: bold; color: #fe9b7a; font-size: 1em"
										class="form-control p_input">
								</div>
								<div class="form-group">
									<!-- <label>Password *</label> -->
									<input type="password" id="password" name="password"
										style="font-weight: bold; color: #fe9b7a; font-size: 1em" placeholder="Password"
										required="required" class="form-control p_input">
								</div>
								<div class="form-group">
									<!-- <label>Medical Center *</label> -->
									<select class="form-control" id="mc" name="mc"
										style="font-weight: bold; color: #fe9b7a; cursor: pointer; font-size: 1em">
										<option value="*~*" style="font-weight: bold;">--
											Select Medical Center --</option>
										<option style="font-weight: bold; cursor: pointer;"
											value="202~Battaramulla MC">Battaramulla</option>
										<option style="font-weight: bold; cursor: pointer;"
											value="205~Jaela MC">Jaela</option>
										<option style="font-weight: bold; cursor: pointer;"
											value="201~Kiribathgoda MC">Kiribathgoda</option>
										<option style="font-weight: bold; cursor: pointer;"
											value="203~Panadura MC">Panadura</option>
										<!-- <option style="font-weight: bold; cursor: pointer;"
											value="206~Paliyagoda CC">Paliyagoda</option> -->
									</select>
								</div>
								<div style="display: none;"
									class="form-group d-flex align-items-center justify-content-between">
									<div style="display: none;" class="form-check">
										<label class="form-check-label"> <input
											type="checkbox" class="form-check-input"> Remember me
										</label>
									</div>
									<a style="display: none;" href="#" class="forgot-pass">Forgot
										password</a>
								</div>
								<div class="text-center">
									<button type="submit" style="cursor: pointer; font-size: 1em"
										class="btn btn-primary btn-block enter-btn">Login</button>
								</div>
								<%
									if (!error.equals("")) {
								%>
								<blockquote class="blockquote blockquote-danger"
									style="margin-top: 0px; margin-bottom: 0px;">
									<footer class="blockquote-footer"
										style="margin-top: 0px; margin-bottom: 0px;"> <blink><b><%=error%></b></blink>
									<cite title="Source Title"><blink>Log again...</blink></cite></footer>
								</blockquote>
								<%
									}
								%>
								<!--<div class="d-flex" style="display: none;">
									<button class="btn btn-facebook mr-2 col">
										<i class="mdi mdi-facebook"></i> Facebook
									</button>
									<button class="btn btn-google col">
										<i class="mdi mdi-google-plus"></i> Google plus
									</button>
								</div> 
								<p class="sign-up" style="display: none;">
									Don't have an Account?<a href="#"> Sign Up</a>
								</p>-->
							</form>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
			</div>
			<!-- row ends -->
		</div>
		<!-- page-body-wrapper ends -->
	</div>
	<!-- container-scroller -->
	<!-- plugins:js -->
	<script src="./node_modules/popper.js/dist/umd/popper.min.js"></script>
	<script src="./node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
	<script
		src="./node_modules/perfect-scrollbar/dist/js/perfect-scrollbar.jquery.min.js"></script>
	<!-- endinject -->
	<!-- inject:js -->
	<script src="./js/off-canvas.js"></script>
	<script src="./js/misc.js"></script>
	<!-- endinject -->
</body>
</html>