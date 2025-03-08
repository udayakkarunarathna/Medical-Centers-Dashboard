<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="db.DatabaseConnection"%>
<%
	if (request.getSession(false) != null && session.getAttribute("u_name") != null) {
%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.query.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	//System.out.println("Target...");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Target Vs Achievement | Medical Center</title>
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
<link rel="shortcut icon" href="../../images/favicon.png" />

<script src="../../node_modules/highcharts/highcharts.js"></script>
<script src="../../node_modules/highcharts/highcharts-3d.js"></script>
<script src="../../node_modules/highcharts/modules/data.js"></script>
<script src="../../node_modules/highcharts/modules/drilldown.js"></script>
<script src="../../node_modules/highcharts/modules/exporting.js"></script>
<script src="../../node_modules/highcharts/modules/export-data.js"></script>
<script src="../../node_modules/jquery/dist/jquery.min.js"></script>

<script src="../../node_modules/popper.js/dist/umd/popper.min.js"></script>
<link rel="stylesheet"
	href="../../node_modules/bootstrap/dist/css/bootstrap.min.css" />
<script type="text/javascript"
	src="../../node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="../../node_modules/bootstrap/dist/js/bootstrap.js"></script>

<script
	src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/ScrollMagic.min.js"></script>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/ScrollMagic/2.0.5/plugins/debug.addIndicators.min.js"></script>

<%
	String select_type1 = "All";
		if (request.getParameter("select_type1") != null) {
			select_type1 = request.getParameter("select_type1");
		}
		String select_type2 = "REV";
		if (request.getParameter("select_type2") != null) {
			select_type2 = request.getParameter("select_type2");
		}
		String currency1 = "", currency2 = "";
		if(select_type2.equals("REV")){
			currency1 = "Rs.";
			currency2 = "(Rs.)";
		}
		int mc = 0;
		if (session.getAttribute("mc") != null) {
			mc = Integer.parseInt((String) session.getAttribute("mc"));
		}

		String date_from = "";
		String date_to = "";

		double ph_target = 0, ph_income = 0, lab_target = 0, lab_income = 0, mp_target = 0, mp_income = 0,
				sna_target = 0, sna_income = 0;

		DatabaseConnection conn = new DatabaseConnection();
		try {
			conn.ConnectToDataBase(mc);

			if (request.getParameter("date_from") != null) {
				date_from = request.getParameter("date_from");
			} else if (session.getAttribute("date_from") != null) {
				date_from = (String) session.getAttribute("date_from");
			} else {
				date_from = Query.getDateMonthYear("today", conn);
				date_to = date_from;
			}

			if (request.getParameter("date_to") != null) {
				date_to = request.getParameter("date_to");
			} else if (session.getAttribute("date_to") != null) {
				date_to = (String) session.getAttribute("date_to");
			}

			session.setAttribute("date_from", date_from);
			session.setAttribute("date_to", date_to);

			// System.out.println("date_from = " + date_from);
			// System.out.println("date_to = " + date_to);
			// System.out.println("select_type1 = " + select_type1);
			// System.out.println("");

			ph_target = Query.getTargetTransaction("PH", date_from, date_to, select_type1, select_type2, conn);
			lab_target = Query.getTargetTransaction("LAB", date_from, date_to, select_type1, select_type2,
					conn);
			mp_target = Query.getTargetTransaction("MP", date_from, date_to, select_type1, select_type2, conn);
			sna_target = Query.getTargetTransaction("SNA", date_from, date_to, select_type1, select_type2,
					conn);

			if (select_type2.equals("REV")) {
				ph_income = Query.PharmachyRevenueAll(date_from, date_to, select_type1, "All", conn);
				lab_income = Query.LabRevenueWC(date_from, date_to, select_type1, conn);
				mp_income = Query.MediPackRevenueWC(date_from, date_to, select_type1, conn);
				sna_income = Query.ServiceNonAppRevenueWC(date_from, date_to, select_type1, conn);
			} else if (select_type2.equals("TXN")) {
				ph_income = Query.PharmachyCount(date_from, date_to, select_type1, "All", conn);
				lab_income = Query.LabCountWC(date_from, date_to, select_type1, "All", conn);
				mp_income = Query.MediPackCountWC(date_from, date_to, select_type1, "All", conn);
				sna_income = Query.ServiceNonAppCountWC(date_from, date_to, select_type1, "All", conn);
			}

			conn.CloseDataBaseConnection();
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			System.out.println(e);
		}

		double tot_income = ph_income + lab_income + mp_income + sna_income;
		double tot_target = ph_target + lab_target + mp_target + sna_target;

		DecimalFormat df1 = new DecimalFormat("##########");

		String ph_color = "", lab_color = "", sna_color = "", mp_color = "";

		if (ph_target < ph_income) {
			ph_color = "#64E572";
		} else {
			ph_color = "#F16868";
		}

		if (lab_target < lab_income) {
			lab_color = "#64E572";
		} else {
			lab_color = "#F16868";
		}

		if (mp_target < mp_income) {
			mp_color = "#64E572";
		} else {
			mp_color = "#F16868";
		}

		if (sna_target < sna_income) {
			sna_color = "#64E572";
		} else {
			sna_color = "#F16868";
		}

		double ph_per = 0, lab_per = 0, sna_per = 0, mp_per = 0;
		;

		if (ph_target > 0) {
			ph_per = ph_income * 100 / ph_target;
		}
		if (lab_target > 0) {
			lab_per = lab_income * 100 / lab_target;
		}
		if (sna_target > 0) {
			sna_per = sna_income * 100 / sna_target;
		}
		if (mp_target > 0) {
			mp_per = mp_income * 100 / mp_target;
		}
%>
<script>
	$(function() {

		//Bar chart - Target vs Achievment
		var chart1 = new Highcharts.chart(
				'ph',
				{
					chart : {
						marginTop: 100,
						type : 'column',
						options3d : {
							enabled : true,
							alpha : 12,
							beta : -6,
							depth : 100,
							viewDistance : 25
						}
					},
					title : {
						text : '<%=select_type1%> Target Vs Achievement - Pharmacy'
					},
					subtitle : {
						text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
					},
					xAxis : {
						//gridLineColor : 'white',
						categories : [ '' ],
						title : {
							text : null
						}
					},
					yAxis : {
						//gridLineColor : 'white',
						min : 0,
						title : {
							text : 'Amount <%=currency2%>'
						},
						labels : {
							overflow : 'justify'
						}
					},
					tooltip : {
						valueSuffix : ''
					},
					plotOptions : {
						column : {
							depth : 150,
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								x: 0,
				                y: 0,
								format : '<span style="font-size:22px; color:#f96868;">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px"><%=currency1%> {point.y}</span>'
							}
						}
					},
					"series" : [ {
						"name" : "Target",
						"data" : [ {
							"y" :
<%=df1.format(ph_target)%>
	,
							"per" : null,
							"symbol" : null
						} ]
					}, {
						"name" : "Achievement",
						"data" : [ {
							"color" : "<%=ph_color%>",
							"y" :
<%=df1.format(ph_income)%>
	,
							"per" :
<%=df1.format(ph_per)%>
	,
							"symbol" : '%'
						} ]
					} ]
				});
		
		
		//Bar chart - Target vs Achievment
		var chart2 = new Highcharts.chart(
				'lab',
				{
					chart : {
						marginTop: 100,
						type : 'column',
						options3d : {
							enabled : true,
							alpha : 12,
							beta : -6,
							depth : 100,
							viewDistance : 25
						}
					},
					title : {
						text : '<%=select_type1%> Target Vs Achievement - Lab'
					},
					subtitle : {
						text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
					},
					xAxis : {
						//gridLineColor : 'white',
						categories : [ '' ],
						title : {
							text : null
						}
					},
					yAxis : {
						//gridLineColor : 'white',
						min : 0,
						title : {
							text : 'Amount <%=currency2%>'
						},
						labels : {
							overflow : 'justify'
						}
					},
					tooltip : {
						valueSuffix : ''
					},
					plotOptions : {
						column : {
							depth : 150,
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								x: 0,
				                y: 0,
								format : '<span style="font-size:22px; color:#f96868;">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px"><%=currency1%> {point.y}</span>'
							}
						}
					},
					"series" : [ {
						"name" : "Target",
						"data" : [ {
							"y" :
<%=df1.format(lab_target)%>
	,
							"per" : null,
							"symbol" : null
						} ]
					}, {
						"name" : "Achievement",
						"data" : [ {
							"color" : "<%=lab_color%>",
							"y" :
<%=df1.format(lab_income)%>
	,
							"per" :
<%=df1.format(lab_per)%>
	,
							"symbol" : '%'
						} ]
					} ]
				});
		//Bar chart - Target vs Achievment
		var chart3 = new Highcharts.chart(
				'mp',
				{
					chart : {
						marginTop: 100,
						type : 'column',
						options3d : {
							enabled : true,
							alpha : 12,
							beta : -6,
							depth : 100,
							viewDistance : 25
						}
					},
					title : {
						text : '<%=select_type1%> Target Vs Achievement - Medical Packages'
					},
					subtitle : {
						text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
					},
					xAxis : {
						//gridLineColor : 'white',
						categories : [ '' ],
						title : {
							text : null
						}
					},
					yAxis : {
						//gridLineColor : 'white',
						min : 0,
						title : {
							text : 'Amount <%=currency2%>'
						},
						labels : {
							overflow : 'justify'
						}
					},
					tooltip : {
						valueSuffix : ''
					},
					plotOptions : {
						column : {
							depth : 150,
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								x: 0,
				                y: 0,
								format : '<span style="font-size:22px; color:#f96868;">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px"><%=currency1%> {point.y}</span>'
							}
						}
					},
					"series" : [ {
						"name" : "Target",
						"data" : [ {
							"y" :
<%=df1.format(mp_target)%>
	,
							"per" : null,
							"symbol" : null
						} ]
					}, {
						"name" : "Achievement",
						"data" : [ {
							"color" : "<%=mp_color%>",
							"y" :
<%=df1.format(mp_income)%>
	,
							"per" :
<%=df1.format(mp_per)%>
	,
							"symbol" : '%'
						} ]
					} ]
				});
		//Bar chart - Target vs Achievment
		var chart4 = new Highcharts.chart(
				'sna',
				{
					chart : {
						marginTop: 100,
						type : 'column',
						options3d : {
							enabled : true,
							alpha : 12,
							beta : -6,
							depth : 100,
							viewDistance : 25
						}
					},
					title : {
						text : '<%=select_type1%> Target Vs Achievement - Service Non Appointment'
					},
					subtitle : {
						text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
					},
					xAxis : {
						//gridLineColor : 'white',
						categories : [ '' ],
						title : {
							text : null
						}
					},
					yAxis : {
						//gridLineColor : 'white',
						min : 0,
						title : {
							text : 'Amount <%=currency2%>'
						},
						labels : {
							overflow : 'justify'
						}
					},
					tooltip : {
						valueSuffix : ''
					},
					plotOptions : {
						column : {
							depth : 150,
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								x: 0,
				                y: 0,
								format : '<span style="font-size:22px; color:#f96868;">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px"><%=currency1%> {point.y}</span>'
							}
						}
					},
					"series" : [ {
						"name" : "Target",
						"data" : [ {
							"y" :
<%=df1.format(sna_target)%>
	,
							"per" : null,
							"symbol" : null
						} ]
					}, {
						"name" : "Achievement",
						"data" : [ {
							"color" : "<%=sna_color%>",
							"y" :
<%=df1.format(sna_income)%>
	,
							"per" :
<%=df1.format(sna_per)%>
	,
							"symbol" : '%'
						} ]
					} ]
				});
	});

	//////////////////////////////////////////////////
</script>
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
</head>

<body>
	<div class="container-scroller">
		<!-- partial:../../partials/_navbar.html -->
		<nav class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
			<!-- <div
				class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
				<a class="navbar-brand brand-logo" href="../../dashboard.jsp"><img
					src="../../images/logo.svg" alt="logo" /></a> <a
					class="navbar-brand brand-logo-mini" href="../../dashboard.jsp"><img
					src="../../images/logo-mini.svg" alt="logo" /></a>
			</div> -->
			<div
				class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
				<a class="navbar-brand brand-logo" href="../../dashboard.jsp"><img
					src="../../images/logo-mini.svg" alt="logo"
					style="margin-left: -40px; margin-right: 0px;" /><font
					class="font_3d" size="4px;"><b>&nbsp;<%=(String) session.getAttribute("mc_name")%>

					</b></font></a> <a class="navbar-brand brand-logo-mini" href="../../dashboard.jsp"><img
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
							src="../../images/faces-clipart/pic-1.png" alt="image"> <span
							class="d-none d-lg-inline"><%=session.getAttribute("u_nameC")%></span>
					</a>

						<div class="dropdown-menu navbar-dropdown w-100"
							aria-labelledby="profileDropdown">
							<a class="dropdown-item" href="../../target.jsp"> <i
								class="mdi mdi-cached mr-2 text-success"></i> Target
							</a>

							<div class="dropdown-divider"></div>
							<a class="dropdown-item" href="../../Logout.jsp"> <i
								class="mdi mdi-logout mr-2 text-primary"></i> Signout
							</a>
						</div></li>
					<li class="nav-item nav-logout d-none d-lg-block"><a
						class="nav-link" href="../../Logout.jsp"> <i
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
					<jsp:include page="../../tabs.jsp"><jsp:param
							value="yes" name="sub" /></jsp:include>
					<jsp:include page="leftbottom.jsp"></jsp:include>
				</nav>
				<!-- partial -->
				<div class="content-wrapper">

					<%
						///////////////////////// Modal - Start
					%>
					<jsp:include page="../../filter_date.jsp"><jsp:param
							value="targetachievement1.jsp" name="action" /><jsp:param
							value="<%=select_type1%>" name="select_type1" /><jsp:param
							value="<%=select_type2%>" name="select_type2" /><jsp:param
							value="<%=date_from%>" name="date_from" /><jsp:param
							value="<%=date_to%>" name="date_to" /><jsp:param value="yes"
							name="sub" /></jsp:include>
					<%
						///////////////////////// Modal - End
					%>
					<div class="row">
						<div class="col-md-6 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div id="ph" style="width: 100%; height: 450px;"></div>
								</div>
							</div>
						</div>
						<div class="col-md-6 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div id="lab" style="width: 100%; height: 450px;"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div id="mp" style="width: 100%; height: 500px;"></div>
								</div>
							</div>
						</div>
						<div class="col-md-6 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div id="sna" style="width: 100%; height: 500px;"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
				<jsp:include page="../../footer.jsp"></jsp:include>
				<!-- partial -->
			</div>
			<!-- row-offcanvas ends -->
		</div>
		<!-- page-body-wrapper ends -->
	</div>
	<!-- container-scroller -->
	<!-- plugins:js -->
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
	<%
		} else {
			//RequestDispatcher rd = request.getRequestDispatcher("Logout.jsp?error=Logout from the system...");
			//System.out.println("Logout...");
			response.sendRedirect("../../Logout.jsp?error=Logout%20from%20the%20system...");
		}
	%>
</body>
</html>

