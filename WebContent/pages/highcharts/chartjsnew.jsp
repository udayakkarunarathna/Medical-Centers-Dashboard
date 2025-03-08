<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Charts | <%=session.getAttribute("title")%>
</title>
<!-- plugins:css -->
<link rel="stylesheet"
	href="../../node_modules/mdi/css/materialdesignicons.min.css">
<link rel="stylesheet"
	href="../../node_modules/perfect-scrollbar/dist/css/perfect-scrollbar.min.css">
<!-- endinject -->
<!-- plugin css for this page -->
<!-- End plugin css for this page -->
<!-- inject:css -->
<link rel="stylesheet" href="../../css/style.css">
<!-- endinject -->
<link rel="shortcut icon" href="images/favicon.png" />

<script src="../../node_modules/highcharts/highcharts.js"></script>
<script src="../../node_modules/highcharts/modules/data.js"></script>
<script src="../../node_modules/highcharts/modules/drilldown.js"></script>
<script src="../../node_modules/highcharts/modules/exporting.js"></script>
<script src="../../node_modules/highcharts/modules/export-data.js"></script>
<script src="../../node_modules/jquery/dist/jquery.min.js"></script>

<link rel="stylesheet"
	href="../../node_modules/bootstrap/dist/css/bootstrap.min.css" />
<script type="text/javascript"
	src="../../node_modules/bootstrap/dist/js/bootstrap.min.js"></script>

<script
	src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/ScrollMagic.min.js"></script>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/plugins/debug.addIndicators.min.js"></script>


<%--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>--%>
<%
	double ph_target = 0, ph_income = 0, lab_target = 0, lab_income = 0, mp_target = 0, mp_income = 0,
			sna_target = 0, sna_income = 0;

	ph_target = 5000;
	lab_target = 50000;
	mp_target = 10000;
	sna_target = 35000;

	ph_income = 20000;
	lab_income = 40000;
	mp_income = 10000;
	sna_income = 30000;

	double tot_income = ph_income + lab_income + mp_income + sna_income;
	double tot_target = ph_target + lab_target + mp_target + sna_target;
%>
<script>
	$(function() {

		//Bar chart - Target vs Achievment
		var myChart = Highcharts.chart('containerBar', {
			chart : {
				plotShadow : true,
				type : 'bar'
			},
			title : {
				text : 'Target Vs Achievement'
			},
			subtitle : {
				text : 'October, 2018'
			},
			xAxis : {
				categories : [ 'Pharmacy', 'Lab', 'Medical<br/>Packages',
						'Service Non<br/>Appointment' ]
			},
			yAxis : {
				title : {
					text : 'Amount (Rs.)'
				}
			},
			series : [
					{
						name : 'Target',
						data : [
<%=ph_target%>
	,
<%=lab_target%>
	,
<%=mp_target%>
	,
<%=sna_target%>
	]
					},
					{
						name : 'Achievement',
						data : [
<%=ph_income%>
	,
<%=lab_income%>
	,
<%=mp_income%>
	,
<%=sna_income%>
	]
					} ]
		});
		/////////////////////////////////////////////////

		//Pie chart - left
		Highcharts
				.chart(
						'pie_revenue',
						{
							chart : {
								plotShadow : true,
								type : 'pie'
							},
							title : {
								text : 'Total Revenue'
							},
							subtitle : {
								text : 'October, 2018 | Click the slices to view breakdown.'
							},
							plotOptions : {
								pie : {
									showInLegend : true
								},
								series : {
									dataLabels : {
										enabled : true,
										format : '{point.code}: {point.y:.1f} %'
									}
								}
							},

							tooltip : {
								headerFormat : '<span style="font-size:11px">{series.name}</span><br>',
								pointFormat : '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/><span></span><br/>'
							},

							"series" : [ {
								"name" : "Category",
								"colorByPoint" : true,
								"data" : [ {
									"code" : "PH",
									"name" : "Pharmacy",
									"y" :
<%=(ph_income * 100) / tot_income%>
	,
									"drilldown" : "Pharmacy"
								}, {
									"code" : "LAB",
									"name" : "Lab",
									"y" :
<%=(lab_income * 100) / tot_income%>
	,
									"drilldown" : "Lab"
								}, {
									"code" : "MP",
									"name" : "Medical Packages",
									"y" :
<%=(mp_income * 100) / tot_income%>
	,
									"drilldown" : "Medical Packages"
								}, {
									"code" : "SNA",
									"name" : "Service Non Appointment",
									"y" :
<%=(sna_income * 100) / tot_income%>
	,
									"drilldown" : "Service Non Appointment"
								} ]
							} ],
							"drilldown" : {
								"series" : [
										{
											"name" : "Pharmacy",
											"id" : "Pharmacy",
											"data" : [ [ "v65.0", 0.1 ],
													[ "v64.0", 1.3 ],
													[ "v63.0", 53.02 ],
													[ "v62.0", 1.4 ],
													[ "v29.0", 0.26 ] ]
										},
										{
											"name" : "Lab",
											"id" : "Lab",
											"data" : [ [ "v58.0", 1.02 ],
													[ "v57.0", 7.36 ],
													[ "v56.0", 0.35 ],
													[ "v55.0", 0.11 ],
													[ "v47.0", 0.12 ] ]
										},
										{
											"name" : "Medical Packages",
											"id" : "Medical Packages",
											"data" : [ [ "v11.0", 6.2 ],
													[ "v10.0", 0.29 ],
													[ "v9.0", 0.27 ],
													[ "v8.0", 0.47 ] ]
										},
										{
											"name" : "Medical Packages",
											"id" : "Medical Packages",
											"data" : [ [ "v11.0", 6.2 ],
													[ "v10.0", 0.29 ],
													[ "v9.0", 0.27 ],
													[ "v8.0", 0.47 ] ]
										},
										{
											"name" : "Service Non Appointment",
											"id" : "Service Non Appointment",
											"data" : [ [ "v11.0", 6.2 ],
													[ "v10.0", 0.29 ],
													[ "v9.0", 0.27 ],
													[ "v8.0", 0.47 ] ]
										} ]
							}
						});

		//////////////////////////////////////////////////

		// Pie left
		Highcharts
				.chart(
						'pie_target',
						{
							chart : {
								plotBackgroundColor : null,
								plotBorderWidth : null,
								plotShadow : true,
								type : 'pie'
							},
							title : {
								text : 'Target'
							},
							subtitle : {
								text : 'October, 2018'
							},
							tooltip : {
								pointFormat : '{series.name}: <b>{point.percentage:.1f}%</b>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									cursor : 'pointer',
									dataLabels : {
										enabled : true,
										format : '<b>{point.code}</b>: {point.percentage:.1f} %',
										style : {
											color : (Highcharts.theme && Highcharts.theme.contrastTextColor)
													|| 'black'
										},
										connectorColor : 'silver'
									},
									showInLegend : true
								}
							},
							series : [ {
								name : 'Percentage',
								data : [ {
									code : 'PH',
									name : 'Pharmacy',
									y :
<%=(ph_target * 100) / tot_target%>
	}, {
									code : 'LAB',
									name : 'Lab',
									y :
<%=(lab_target * 100) / tot_target%>
	}, {
									code : 'MP',
									name : 'Medical Packages',
									y :
<%=(mp_target * 100) / tot_target%>
	}, {
									code : 'SNA',
									name : 'Service Non Appointment',
									y :
<%=(sna_target * 100) / tot_target%>
	} ]
							} ]
						});
	});
	//////////////////////////////////////////////
</script>
</head>


<body>
	<div class="container-scroller">
		<!-- partial:../../partials/_navbar.html -->
		<nav class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
			<div
				class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
				<a class="navbar-brand brand-logo" href="../../index.jsp"><img
					src="../../images/logo.svg" alt="logo" /></a> <a
					class="navbar-brand brand-logo-mini" href="../../index.jsp"><img
					src="../../images/logo-mini.svg" alt="logo" /></a>
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
									<img src="../../images/faces/face4.jpg" alt="image"
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
									<img src="../../images/faces/face2.jpg" alt="image"
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
									<img src="../../images/faces/face3.jpg" alt="image"
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
							src="../../images/faces/face1.jpg" alt="image"> <span
							class="d-none d-lg-inline">Daniel Russiel</span>
					</a>

						<div class="dropdown-menu navbar-dropdown w-100"
							aria-labelledby="profileDropdown">
							<a class="dropdown-item" href="#"> <i
								class="mdi mdi-cached mr-2 text-success"></i> Activity Log
							</a>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item" href="#"> <i
								class="mdi mdi-logout mr-2 text-primary"></i> Signout
							</a>
						</div></li>
					<li class="nav-item nav-logout d-none d-lg-block"><a
						class="nav-link" href="../../login.html"> <i
							class="mdi mdi-power"></i>
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
				<!-- partial:../../partials/_sidebar.html -->

				<nav class="sidebar sidebar-offcanvas" id="sidebar">

					<ul class="nav">
						<li class="nav-item"><a class="nav-link"
							href="../../index.jsp"> <span class="menu-title">Dashboard</span>
								<span class="menu-sub-title">( 2 new updates )</span> <i
								class="mdi mdi-home menu-icon"></i>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							data-toggle="collapse" href="#ui-basic" aria-expanded="false"
							aria-controls="ui-basic"> <span class="menu-title">Basic
									UI Elements</span> <i class="menu-arrow"></i> <i
								class="mdi mdi-crosshairs-gps menu-icon"></i>
						</a>

							<div class="collapse" id="ui-basic">
								<ul class="nav flex-column sub-menu">
									<li class="nav-item"><a class="nav-link"
										href="../../pages/ui-features/buttons.html">Buttons</a></li>
									<li class="nav-item"><a class="nav-link"
										href="../../pages/ui-features/typography.html">Typography</a>
									</li>
								</ul>
							</div></li>
						<li class="nav-item"><a class="nav-link"
							href="../../pages/icons/font-awesome.html"> <span
								class="menu-title">Icons</span> <i
								class="mdi mdi-contacts menu-icon"></i>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="../../pages/forms/basic_elements.html"> <span
								class="menu-title">Form Elements</span> <i
								class="mdi mdi-format-list-bulleted menu-icon"></i>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="../../pages/charts/chartjs.jsp"> <span
								class="menu-title">Chart</span> <i
								class="mdi mdi-chart-bar menu-icon"></i>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="../../pages/highcharts/chartjsnew.jsp"> <span
								class="menu-title">Revenue</span> <i
								class="mdi mdi-chart-bar menu-icon"></i>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="../../pages/tables/bootstrap-table.html"> <span
								class="menu-title">Table</span> <i
								class="mdi mdi-table-large menu-icon"></i>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							data-toggle="collapse" href="#auth" aria-expanded="false"
							aria-controls="auth"> <span class="menu-title">Sample
									Pages</span> <i class="menu-arrow"></i> <i
								class="mdi mdi-lock menu-icon"></i>
						</a>

							<div class="collapse" id="auth">
								<ul class="nav flex-column sub-menu">
									<li class="nav-item"><a class="nav-link"
										href="../../pages/samples/blank-page.html"> Blank Page </a></li>
									<li class="nav-item"><a class="nav-link"
										href="../../pages/samples/login.html"> Login </a></li>
									<li class="nav-item"><a class="nav-link"
										href="../../pages/samples/register.html"> Register </a></li>
									<li class="nav-item"><a class="nav-link"
										href="../../pages/samples/error-404.html"> 404 </a></li>
									<li class="nav-item"><a class="nav-link"
										href="../../pages/samples/error-500.html"> 500 </a></li>
								</ul>
							</div></li>
					</ul>
					<div class="sidebar-progress">
						<p>Total Sales</p>

						<div class="progress progress-sm">
							<div class="progress-bar bg-gradient-success" role="progressbar"
								style="width: 72%" aria-valuenow="72" aria-valuemin="0"
								aria-valuemax="100"></div>
						</div>
						<p>50 Items sold</p>
					</div>
					<div class="sidebar-progress">
						<p>Customer Target</p>

						<div class="progress progress-sm">
							<div class="progress-bar bg-gradient-primary" role="progressbar"
								style="width: 90%" aria-valuenow="90" aria-valuemin="0"
								aria-valuemax="100"></div>
						</div>
						<p>200 Items sold</p>
					</div>
				</nav>
				<!-- partial -->
				<div class="content-wrapper">

					<%
						///////////////////////// Modal - Start
					%>
					<div align="right">
						<button type="button" class="btn btn-gradient-secondary btn-fw"
							data-toggle="modal" data-target="#exampleModal"
							data-whatever="@mdo" style="cursor: pointer;">Filter</button>
					</div>

					<div class="modal fade" id="exampleModal" tabindex="-1"
						role="dialog" aria-labelledby="exampleModalLabel"
						aria-hidden="true">
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header" style="background-color: #e83e8c">
									<h5 class="modal-title" id="exampleModalLabel">Filter</h5>
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<form style="font-weight: bold;" method="post"
									action="chartjsnew.jsp">
									<div class="modal-body">
										<div class="form-group">
											<label for="recipient-name" class="col-form-label">Date
												From:</label> &nbsp;&nbsp;&nbsp;&nbsp;<input type="date"
												class="form-control" id="from" name="from"
												placeholder="Select date from..." value=""
												style="width: 200px; font-weight: bold;">
										</div>
										<div class="form-group">
											<label for="recipient-name" class="col-form-label">To
												Date:</label> &nbsp;&nbsp;&nbsp;&nbsp;<input type="date"
												class="form-control" id="to" name="to" value=""
												placeholder="Select date to..."
												style="width: 200px; font-weight: bold;">
										</div>
										<div class="form-group">
											<label class="col-form-label">Type</label>
											<div class="form-radio">
												<label class="form-check-label">
													&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"
													class="form-check-input" name="membershipRadios"
													id="membershipRadios1" value="" checked>All
												</label>
											</div>
											<div class="form-radio">
												<label class="form-check-label">
													&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"
													class="form-check-input" name="membershipRadios"
													id="membershipRadios2" value="option2">OPD
												</label>
											</div>
											<div class="form-radio">
												<label class="form-check-label">
													&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio"
													class="form-check-input" name="membershipRadios"
													id="membershipRadios2" value="option2">Inward
												</label>
											</div>
											<div class="form-radio" align="right">
												<button type="button" class="btn btn-secondary"
													style="cursor: pointer;" data-dismiss="modal">Close</button>
												&nbsp;
												<button type="submit" style="cursor: pointer;"
													class="btn btn-gradient-secondary btn-fw">View</button>
											</div>
										</div>
									</div>
									<div class="modal-footer" style="background-color: #e83e8c;">
										&nbsp;<br />
									</div>
								</form>
							</div>
						</div>
					</div>
					<%
						///////////////////////// Modal - End
					%>
					<div class="row">
						<div class="col-12 grid-margin">
							<div class="card">
								<div class="card-body">
									<div id="containerBar" style="width: 100%; height: 500px;"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div id="pie_revenue" style="width: 100%; height: 500px;"></div>
								</div>
							</div>
						</div>
						<div class="col-md-6 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div id="pie_target" style="width: 100%; height: 500px;"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
				<!-- partial:../../partials/_footer.html -->
				<footer class="footer">
					<div align="center"
						class="d-sm-flex justify-content-center justify-content-sm-between">
						<span
							class="text-muted text-center text-sm-left d-block d-sm-inline-block">Copyright
							© 2018 <a href="http://www.nawaloka.com/" target="_blank">Nawaloka
								Medical Center</a>. All rights reserved.
						</span>
					</div>
				</footer>
				<!-- partial -->
			</div>
			<!-- row-offcanvas ends -->
		</div>
		<!-- page-body-wrapper ends -->
	</div>
	<!-- container-scroller -->
	<!-- plugins:js -->
	<script src="../../node_modules/jquery/dist/jquery.min.js"></script>
	<script src="../../node_modules/popper.js/dist/umd/popper.min.js"></script>
	<script src="../../node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
	<script
		src="../../node_modules/perfect-scrollbar/dist/js/perfect-scrollbar.jquery.min.js"></script>
	<!-- endinject -->
	<!-- Plugin js for this page-->
	<script src="../../node_modules/chart.js/dist/Chart.min.js"></script>
	<!-- End plugin js for this page-->
	<!-- inject:js -->
	<script src="../../js/off-canvas.js"></script>
	<script src="../../js/misc.js"></script>
	<!-- endinject -->
	<!-- Custom js for this page-->
	<script src="../../js/chart.js"></script>
	<!-- End custom js for this page-->
</body>

</html>

