<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="db.DatabaseConnection"%>
<%@page import="dao.UserIncome"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.query.Query"%>
<%
	if (request.getSession(false) != null && session.getAttribute("u_name") != null) {
%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	DecimalFormat df = new DecimalFormat("############.##");

		int mc = 0;
		if (session.getAttribute("mc") != null) {
			mc = Integer.parseInt((String) session.getAttribute("mc"));
		}

		String year = "";
		if (request.getParameter("year") != null) {
			year = request.getParameter("year");
		}
		
		ArrayList<UserIncome> income_arraylist = new ArrayList<UserIncome>();
		ArrayList<UserIncome> count_arraylist = new ArrayList<UserIncome>();

		DatabaseConnection conn = new DatabaseConnection();
		ResultSet rs = null;

		Calendar now = Calendar.getInstance();
		int this_year = now.get(Calendar.YEAR);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Target | Medical Center</title>
<!-- plugins:css -->
<link rel="stylesheet"
	href="node_modules/mdi/css/materialdesignicons.min.css">
<link rel="stylesheet"
	href="node_modules/perfect-scrollbar/dist/css/perfect-scrollbar.min.css">
<!-- endinject -->
<!-- plugin css for this page -->
<!-- End plugin css for this page -->
<!-- inject:css -->
<link rel="stylesheet" href="css/style.css">
<!-- endinject -->
<link rel="shortcut icon" href="images/favicon.png" />

<script src="node_modules/highcharts/highcharts.js"></script>
<script src="node_modules/highcharts/highcharts-3d.js"></script>
<script src="node_modules/highcharts/modules/data.js"></script>
<script src="node_modules/highcharts/modules/drilldown.js"></script>
<script src="node_modules/highcharts/modules/exporting.js"></script>
<script src="node_modules/highcharts/modules/export-data.js"></script>
<script src="node_modules/jquery/dist/jquery.min.js"></script>
<script src="node_modules/popper.js/dist/umd/popper.min.js"></script>
<link rel="stylesheet"
	href="node_modules/bootstrap/dist/css/bootstrap.min.css" />
<script type="text/javascript"
	src="node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="node_modules/bootstrap/dist/js/bootstrap.js"></script>

<script
	src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/ScrollMagic.min.js"></script>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/plugins/debug.addIndicators.min.js"></script>
<style>
.font_3d {
	text-shadow: 0 1px 0 #ccc, 0 2px 0 #c9c9c9, 0 3px 0 #bbb, 0 4px 0
		#b9b9b9, 0 5px 0 #aaa, 0 6px 1px rgba(0, 0, 0, .1), 0 0 5px
		rgba(0, 0, 0, .1), 0 1px 3px rgba(0, 0, 0, .3), 0 3px 5px
		rgba(0, 0, 0, .2), 0 5px 10px rgba(0, 0, 0, .25), 0 10px 10px
		rgba(0, 0, 0, .2), 0 20px 20px rgba(0, 0, 0, .15);
	margin-left: -41px;
}
</style>
<script type="text/javascript">
	$(function() {
		var modalConfirm = function(callback) {

			$("#btn-confirm").on("click", function() {
				$("#mi-modal").modal('show');
			});

			$("#modal-btn-yes").on("click", function() {
				callback(true);
				$("#mi-modal").modal('hide');
				$("#tar-form").submit();
			});

			$("#modal-btn-no").on("click", function() {
				callback(false);
				$("#mi-modal").modal('hide');
			});
		};

		modalConfirm(function(confirm) {
			if (confirm) {
				//Acciones si el usuario confirma
				$("#result").html("CONFIRMADO");
			} else {
				//Acciones si el usuario no confirma
				$("#result").html("NO CONFIRMADO");
			}
		});
	});
</script>
</head>
<body>
	<div class="container-scroller">
		<!-- partial:partials/_navbar.html -->
		 <nav id="navbar" style="transition: top 0.5s" class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
			<!-- <div
				class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
				<a class="navbar-brand brand-logo" href="dashboard.jsp"><img
					src="images/logo.svg" alt="logo" /></a> <a
					class="navbar-brand brand-logo-mini" href="dashboard.jsp"><img
					src="images/logo-mini.svg" alt="logo" /></a>
			</div> -->
			<div
				class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
				<a class="navbar-brand brand-logo" href="dashboard.jsp"><img
					src="images/logo-mini.svg" alt="logo"
					style="margin-left: -40px; margin-right: 0px;" /><font
					class="font_3d" size="4px;"><b>&nbsp;<%=(String) session.getAttribute("mc_name")%>

					</b></font></a> <a class="navbar-brand brand-logo-mini" href="dashboard.jsp"><img
					src="images/logo-mini.svg" alt="logo" /></a>
			</div>
			<div class="navbar-menu-wrapper d-flex align-items-stretch">
				<div class="search-field ml-4 d-none d-md-block">
					<form class="d-flex align-items-stretch h-100" action="#">
						<div class="input-group">
							<input type="text" class="form-control bg-transparent border-0"
								placeholder="Search">

							<div class="input-group-btn">
								<button type="button"
									class="btn bg-transparent dropdown-toggle px-0"
									data-toggle="dropdown" aria-haspopup="true"
									aria-expanded="false">
									<i class="mdi mdi-earth"></i>
								</button>
								<div class="dropdown-menu dropdown-menu-right">
									<a class="dropdown-item" href="#">Today</a> <a
										class="dropdown-item" href="#">This week</a> <a
										class="dropdown-item" href="#">This month</a>
									<div role="separator" class="dropdown-divider"></div>
									<a class="dropdown-item" href="#">Month and older</a>
								</div>
							</div>
							<div
								class="input-group-addon bg-transparent border-0 search-button">
								<button type="submit" class="btn btn-sm bg-transparent px-0">
									<i class="mdi mdi-magnify"></i>
								</button>
							</div>
						</div>
					</form>
				</div>
				<ul class="navbar-nav navbar-nav-right">
					<li class="nav-item d-none d-lg-block full-screen-link"><a
						class="nav-link"> <i class="mdi mdi-fullscreen"
							id="fullscreen-button"></i>
					</a></li>
					<li class="nav-item dropdown"><a
						class="nav-link count-indicator dropdown-toggle"
						id="messageDropdown" href="#" data-toggle="dropdown"
						aria-expanded="false"> <i class="mdi mdi-email-outline"></i> <span
							class="count"></span>
					</a>
						<div
							class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list"
							aria-labelledby="messageDropdown">
							<h6 class="p-3 mb-0">Messages</h6>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item preview-item">
								<div class="preview-thumbnail">
									<img src="images/faces/face4.jpg" alt="image"
										class="profile-pic">
								</div>
								<div
									class="preview-item-content d-flex align-items-start flex-column justify-content-center">
									<h6 class="preview-subject ellipsis mb-1 font-weight-normal">Mark
										send you a message</h6>

									<p class="text-gray mb-0">1 Minutes ago</p>
								</div>
							</a>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item preview-item">
								<div class="preview-thumbnail">
									<img src="images/faces/face2.jpg" alt="image"
										class="profile-pic">
								</div>
								<div
									class="preview-item-content d-flex align-items-start flex-column justify-content-center">
									<h6 class="preview-subject ellipsis mb-1 font-weight-normal">Cregh
										send you a message</h6>

									<p class="text-gray mb-0">15 Minutes ago</p>
								</div>
							</a>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item preview-item">
								<div class="preview-thumbnail">
									<img src="images/faces/face3.jpg" alt="image"
										class="profile-pic">
								</div>
								<div
									class="preview-item-content d-flex align-items-start flex-column justify-content-center">
									<h6 class="preview-subject ellipsis mb-1 font-weight-normal">Profile
										picture updated</h6>

									<p class="text-gray mb-0">18 Minutes ago</p>
								</div>
							</a>

							<div class="dropdown-divider"></div>
							<h6 class="p-3 mb-0 text-center">4 new messages</h6>
						</div></li>
					<li class="nav-item dropdown"><a
						class="nav-link count-indicator dropdown-toggle"
						id="notificationDropdown" href="#" data-toggle="dropdown"> <i
							class="mdi mdi-bell-outline"></i> <span class="count"></span>
					</a>

						<div
							class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list"
							aria-labelledby="notificationDropdown">
							<h6 class="p-3 mb-0">Notifications</h6>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item preview-item">
								<div class="preview-thumbnail">
									<div class="preview-icon bg-success">
										<i class="mdi mdi-calendar"></i>
									</div>
								</div>
								<div
									class="preview-item-content d-flex align-items-start flex-column justify-content-center">
									<h6 class="preview-subject font-weight-normal mb-1">Event
										today</h6>

									<p class="text-gray ellipsis mb-0">Just a reminder that you
										have an event today</p>
								</div>
							</a>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item preview-item">
								<div class="preview-thumbnail">
									<div class="preview-icon bg-warning">
										<i class="mdi mdi-settings"></i>
									</div>
								</div>
								<div
									class="preview-item-content d-flex align-items-start flex-column justify-content-center">
									<h6 class="preview-subject font-weight-normal mb-1">Settings</h6>

									<p class="text-gray ellipsis mb-0">Update dashboard</p>
								</div>
							</a>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item preview-item">
								<div class="preview-thumbnail">
									<div class="preview-icon bg-info">
										<i class="mdi mdi-link-variant"></i>
									</div>
								</div>
								<div
									class="preview-item-content d-flex align-items-start flex-column justify-content-center">
									<h6 class="preview-subject font-weight-normal mb-1">Launch
										Admin</h6>

									<p class="text-gray ellipsis mb-0">New admin wow!</p>
								</div>
							</a>

							<div class="dropdown-divider"></div>
							<h6 class="p-3 mb-0 text-center">See all notifications</h6>
						</div></li>
					<li class="nav-item dropdown"><a
						class="nav-link dropdown-toggle nav-profile" id="profileDropdown"
						href="#" data-toggle="dropdown" aria-expanded="false"> <img
							src="images/faces-clipart/pic-1.png" alt="image"> <span
							class="d-none d-lg-inline"><%=session.getAttribute("u_nameC")%></span>
					</a>

						<div class="dropdown-menu navbar-dropdown w-100"
							aria-labelledby="profileDropdown">
							<a class="dropdown-item" href="target.jsp"> <i
								class="mdi mdi-cached mr-2 text-success"></i> Target
							</a>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item" href="Logout.jsp"> <i
								class="mdi mdi-logout mr-2 text-primary"></i> Signout
							</a>
						</div></li>
					<li class="nav-item nav-logout d-none d-lg-block"><a
						class="nav-link" href="Logout.jsp"> <i class="mdi mdi-power"></i>
					</a></li>
				</ul>
				<button
					class="navbar-toggler navbar-toggler-right d-lg-none align-self-center"
					type="button" data-toggle="offcanvas">
					<span class="mdi mdi-menu"></span>
				</button>
			</div>
		</nav>
		<!-- partial -->
		<div class="container-fluid page-body-wrapper">
			<div class="row row-offcanvas row-offcanvas-right">
				<!-- partial:partials/_sidebar.html -->

				<nav class="sidebar sidebar-offcanvas" id="sidebar">
					<jsp:include page="tabs.jsp"></jsp:include>
					<%-- <jsp:include page="/pages/highcharts/leftbottom.jsp"></jsp:include> --%>
				</nav>
				<!-- partial -->
				<div class="content-wrapper">
					<div class="row">
						<%
							String month_arr[] = { "January", "February", "March", "April", "May", "June", "July", "August",
										"September", "October", "November", "December" };
								session.setAttribute("month_arr", month_arr);
								String color = "";

								List<String[]> chl_al = new ArrayList<String[]>();

								chl_al = Query.getChlYearTargetServicewise(mc, year);

								session.setAttribute("chl_al", chl_al);

								//System.out.println("chl_al size = " + chl_al.size());

								String insert_update = "";
								if (chl_al.size() == 0) {
									insert_update = "insert";
									for (int i = 1; i <= month_arr.length; i++) {
										String[] a = new String[4];
										a[0] = "0";
										a[1] = "0";
										a[2] = "0";
										a[3] = "0";
										chl_al.add(a);
									}
								} else {
									insert_update = "update";
								}
						%>
						<div class="col-12 grid-margin">
							<div class="card">
								<div class="card-body">
									<h4 class="card-title">
										Channel Target Amount & Patient Count for year
										<%=year%></h4>
									<form method="post" action="SaveChannelTarget" id="tar-form">
										<input type="hidden" name="year" value="<%=year%>" /> 
										<p class="card-description">&nbsp;</p>
										<div class="row">
											<div class="col-md-6">
												<div class="form-group row">
													<label class="col-sm-3 col-form-label">Month</label>
													<div class="col-sm-9">Patient Count</div>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-group row">
													<div class="col-sm-9">Target Amount</div>
												</div>
											</div>
										</div>

										<div class="row">

											<%
												for (int i = 1; i <= month_arr.length; i++) {
											%>
											<div class="col-md-6">
												<div class="form-group row">
													<label class="col-sm-3 col-form-label"><%=month_arr[i - 1]%></label>
													<div class="col-sm-9">
														<input type="number" class="form-control" size="2"
															name="c_<%=i%>" onclick="select()"
															value="<%=chl_al.get(i - 1)[1]%>"
															style="font-weight: bold; text-align: right;"
															aria-label="Amount (to the nearest rupee)">
													</div>
												</div>
											</div>
											<div class="col-md-6">
												<div class="form-group row">
													<div class="col-sm-9">
														<input type="number" class="form-control" size="2"
															name="a_<%=i%>" onclick="select()"
															value="<%=chl_al.get(i - 1)[2]%>"
															style="font-weight: bold; text-align: right;"
															aria-label="Amount (to the nearest rupee)">
													</div>
												</div>
											</div>
											<%
												}
											%>
										</div>
										<input type="hidden" name="insert_update"
											value="<%=insert_update%>" />
										<div align="right">

											<button type="button" class="btn btn-success mr-2"
												id="btn-confirm" style="cursor: pointer;">Save</button>

											<div class="modal fade" tabindex="-1" role="dialog"
												aria-labelledby="mySmallModalLabel" aria-hidden="true"
												id="mi-modal">
												<div class="modal-dialog modal-md">
													<div class="modal-content">
														<div class="modal-header" align="left"
															style="text-align: left;">
															<button type="button" class="close" data-dismiss="modal"
																aria-label="Close">
																<span aria-hidden="true">&times;</span>
															</button>
															<h4 class="modal-title" id="myModalLabel">Are you
																sure you want to save...?</h4>
														</div>
														<div class="modal-footer">
															<button type="button" class="btn btn-primary"
																style="cursor: pointer;" id="modal-btn-yes">&nbsp;&nbsp;Yes&nbsp;&nbsp;</button>
															<button type="button" class="btn btn-danger"
																style="cursor: pointer;" id="modal-btn-no">&nbsp;&nbsp;No&nbsp;&nbsp;</button>
														</div>
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>

					<!-- content-wrapper ends -->
					<jsp:include page="footer.jsp"></jsp:include>
					<!-- partial -->
				</div>
				<!-- row-offcanvas ends -->
			</div>
			<!-- page-body-wrapper ends -->
		</div>
	</div>
	<!-- container-scroller -->
	<!-- plugins:js -->
	<script src="node_modules/jquery/dist/jquery.min.js"></script>
	<script src="node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
	<script
		src="node_modules/perfect-scrollbar/dist/js/perfect-scrollbar.jquery.min.js"></script>
	<!-- endinject -->
	<!-- Plugin js for this page-->
	<script src="node_modules/chart.js/dist/Chart.min.js"></script>
	<!-- End plugin js for this page-->
	<!-- inject:js -->
	<script src="js/off-canvas.js"></script>
	<script src="js/misc.js"></script>
	<!-- endinject -->
	<!-- Custom js for this page-->
	<script src="js/chart.js"></script>
	<!-- End custom js for this page-->
	<script>
		var prevScrollpos = window.pageYOffset;
		window.onscroll = function() {
			var currentScrollPos = window.pageYOffset;
			if (prevScrollpos > currentScrollPos) {
				document.getElementById("navbar").style.top = "0";
			} else {
				document.getElementById("navbar").style.top = "0";
			}
			prevScrollpos = currentScrollPos;
		}
	</script>
</body>
</html>
<%
	} else {
		//RequestDispatcher rd = request.getRequestDispatcher("Logout.jsp?error=Logout from the system...");
		//System.out.println("Logout...");
		response.sendRedirect("Logout.jsp?error=Logout%20from%20the%20system...");
	}
%>

