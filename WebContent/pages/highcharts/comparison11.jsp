<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 4/24/2020
  Time: 9:00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="ws.RESTfulJerseyClient"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="ws.DoctorAppointment"%>
<%@page import="db.DatabaseConnection"%>
<%@page import="com.query.Query"%>
<%
	if (request.getSession(false) != null && session.getAttribute("u_name") != null) {
%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	// System.out.println("Comparison...");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=yes">
<title>Comparison | Medical Center</title>
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
<script src="../../node_modules/highcharts/modules/series-label.js"></script>

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
	//System.out.println(request.getParameter("select_type1"));
		//System.out.println(request.getParameter("select_type2"));

		int mc = 0;
		if (session.getAttribute("mc") != null) {
			mc = Integer.parseInt((String) session.getAttribute("mc"));
		}

		String select_type1 = "REV";
		if (request.getParameter("select_type1") != null) {
			select_type1 = request.getParameter("select_type1");
		}

		DatabaseConnection conn = new DatabaseConnection();

		String select_type2 = "";
		if (request.getParameter("select_type2") != null) {
			select_type2 = request.getParameter("select_type2");
		} else {
			try {
				conn.ConnectToDataBase(mc);
				select_type2 = Query.getTodayName(conn);
			} catch (Exception e) {
				conn.CloseDataBaseConnection();
				System.out.println(e);
			}
		}

		String select_type1_S = "Revenue", yaxis = "Amount (Rs.)", curency1 = "Rs.";
		if (select_type1.equals("TXN")) {
			select_type1_S = "Transaction";
			yaxis = "Count";
			curency1 = "";
		}

		double ph_income = 0, lab_income = 0, sna_income = 0, channel_income = 0;

		String[] date_arr = null;

		String sub_title1 = "", sub_title2 = "", title_ex = "";

		Double PHARMACY[] = new Double[6];
		Double LAB[] = new Double[6];
		Double SERVICE[] = new Double[6];
		Double CHANNEL[] = new Double[6];
		try {
			conn.ConnectToDataBase(mc);

			if (request.getParameter("select_type2") != null) {
				date_arr = Query.getDateMonthYearArray(select_type2, conn);
			} else {
				date_arr = Query.getDateMonthYearArray("today", conn);
			}
			//System.out.println(date_arr.length);

			session.setAttribute("date_arr", date_arr);

			List<DoctorAppointment> da_al1 = new ArrayList<DoctorAppointment>();
			List<DoctorAppointment> da_al2 = new ArrayList<DoctorAppointment>();

			String access_token = "";
			access_token = RESTfulJerseyClient.getAccessToken();

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			for (int i = 1; i < date_arr.length; i++) {

				if (!access_token.equals("")) {
					da_al1 = RESTfulJerseyClient.getDoctorAppointmentList(mc, "TXN", access_token, date_arr[i],
							date_arr[i]);
				}

				if (select_type1.equals("REV")) {

					PHARMACY[i - 1] = Query.PharmachyRevenueAll(date_arr[i], date_arr[i], "All", "All", conn);
					LAB[i - 1] = Query.LabRevenueWC(date_arr[i], date_arr[i], "All", conn);
					SERVICE[i - 1] = Query.ServiceNonAppRevenueWC(date_arr[i], date_arr[i], "All", conn);

					for (DoctorAppointment da : da_al1) {
						channel_income += da.getTotalAmount();
					}
					CHANNEL[i - 1] = channel_income;

				} else if (select_type1.equals("TXN")) {

					PHARMACY[i - 1] = Query.PharmachyCount(date_arr[i], date_arr[i], "All", "All", conn);
					LAB[i - 1] = Query.LabCountWC(date_arr[i], date_arr[i], "All", "All", conn);
					SERVICE[i - 1] = Query.ServiceNonAppCountWC(date_arr[i], date_arr[i], "All", "All", conn);

					for (DoctorAppointment da : da_al1) {
						channel_income += da.getChannelCount();
					}
					CHANNEL[i - 1] = channel_income;

				}
				channel_income = 0;
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			sub_title1 = date_arr[1];
			title_ex = "Between Dates";

			//////////////////////////////////////////////////////////////////////

			conn.CloseDataBaseConnection();
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			System.out.println(e);
		}

		double PHARMACY_AVG = (PHARMACY[0] + PHARMACY[1] + PHARMACY[2] + PHARMACY[3] + PHARMACY[4]) / 5;
		double LAB_AVG = (LAB[0] + LAB[1] + LAB[2] + LAB[3] + LAB[4]) / 5;
		double SERVICE_AVG = (SERVICE[0] + SERVICE[1] + SERVICE[2] + SERVICE[3] + SERVICE[4]) / 5;
		double CHANNEL_AVG = (CHANNEL[0] + CHANNEL[1] + CHANNEL[2] + CHANNEL[3] + CHANNEL[4]) / 5;

		String color1_1 = "", color1_2 = "", color2_1 = "", color2_2 = "", color3_1 = "", color3_2 = "",
				color4_1 = "", color4_2 = "";

		// #F16868 - red
		// #64E572 - green

		if (PHARMACY_AVG < PHARMACY[5]) {
			color1_1 = "#F16868";
			color1_2 = "#64E572";
		} else {
			color1_1 = "#64E572";
			color1_2 = "#F16868";
		}

		if (LAB_AVG < LAB[5]) {
			color2_1 = "#F16868";
			color2_2 = "#64E572";
		} else {
			color2_1 = "#64E572";
			color2_2 = "#F16868";
		}

		if (SERVICE_AVG < SERVICE[5]) {
			color3_1 = "#F16868";
			color3_2 = "#64E572";
		} else {
			color3_1 = "#64E572";
			color3_2 = "#F16868";
		}

		if (CHANNEL_AVG < CHANNEL[5]) {
			color4_1 = "#F16868";
			color4_2 = "#64E572";
		} else {
			color4_1 = "#64E572";
			color4_2 = "#F16868";
		}
%>
<script>
	$(function() {
		Highcharts.chart('containerLine',
				{
					chart: {
						marginTop: 130,
			        	type: 'column',
						options3d : {
							enabled : true,
							alpha : 12,
							beta : 0,
							depth : 100,
							viewDistance : 25
						}
			    	},
					title : {
						text : '<%=select_type1_S%> Comparison - Without Collecting Center'
					},
					subtitle : {
						text : '<%=date_arr[0]%>s'
					},
					yAxis : {
						min: 0,
						title : {
							text : '<%=yaxis%>'
						}
					},
				    responsive: {
				        rules: [{
				            condition: {
				                maxWidth: 500
				            },
				            chartOptions: {
				                legend: {
				                    align: 'center',
				                    verticalAlign: 'bottom',
				                    layout: 'horizontal'
				                },
				                yAxis: {
				                    labels: {
				                        align: 'left',
				                        x: 0,
				                        y: -5
				                    },
				                    title: {
				                        text: null
				                    }
				                },
				                subtitle: {
				                    text: null
				                },
				                credits: {
				                    enabled: false
				                }
				            }
				        }]
				    },
					xAxis : {
						categories : ['Pharmacy', 'Lab', 'Service', 'Channel']
					},
					legend : {
						layout : 'horizontal',
						align : 'center',
						verticalAlign : 'bottom'
					},
					plotOptions : {
						series : {
							borderWidth : 0,
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								rotation: 270,
								x: 0,
				                y: -60,
								format : '<span align="center" style="font-size:18px; color:#f96868; text-align: middle">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px"><%=curency1%>{point.y:,.0f}</span>'
									}
								},
								column : {
									depth : 100
								}
							},
							tooltip : {
								headerFormat: '<span style="font-size:10px">{point.key}</span><br/><table>',
							    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
							            '<td style="padding:0"><b>{point.y:.0f}</b></td></tr>',
							    useHTML: true
							},

							"series" : [
									{
										"name" : 'Last 5 <%=date_arr[0]%>s',
										"visible" : true,
										"data" : [
											{
												"name": "Pharmacy",
												"drilldown": "Pharmacy",
												"y" : <%=PHARMACY_AVG%>,
												"color" : "<%=color1_1%>",
												"symbol" : null,
												"per" : null
											},
											{
												"y" : <%=LAB_AVG%>,
												"color" : "<%=color2_1%>",
												"symbol" : null,
												"per" : null},
											{
												"y" : <%=SERVICE_AVG%>,
												"color" : "<%=color3_1%>",
												"symbol" : null,
												"per" : null},
											{
												"y" : <%=CHANNEL_AVG%>,
												"color" : "<%=color4_1%>",
												"symbol" : null,
												"per" : null}]
									},
									{
										"name" : '<%=date_arr[6]%>',
										"visible" : true,
										"data" : [
											{   
												"name": "Pharmacy",
												"drilldown": "Pharmacy",
												"y" : <%=PHARMACY[5]%>,
												"color" : "<%=color1_2%>",
												<%if (PHARMACY_AVG != 0) {%>
												"symbol" : "%",
												"per" : <%=PHARMACY[5] * 100 / PHARMACY_AVG%>
												<%} else {%>
												"symbol" : null,
												"per" : null
												<%}%>
											},
												{"y" : <%=LAB[5]%>,
												"color" : "<%=color2_2%>",
												<%if (LAB_AVG != 0) {%>
												"symbol" : "%",
												"per" : <%=LAB[5] * 100 / LAB_AVG%>
												<%} else {%>
												"symbol" : null,
												"per" : null
												<%}%>},
												{"y" : <%=SERVICE[5]%>,
												"color" : "<%=color3_2%>",
												<%if (SERVICE_AVG != 0) {%>
												"symbol" : "%",
												"per" : <%=SERVICE[5] * 100 / SERVICE_AVG%>
												<%} else {%>
												"symbol" : null,
												"per" : null
												<%}%>},
												{"y" : <%=CHANNEL[5]%>,
												"color" : "<%=color4_2%>",
												<%if (CHANNEL_AVG != 0) {%>
												"symbol" : "%",
												"per" : <%=CHANNEL[5] * 100 / CHANNEL_AVG%>
												<%} else {%>
												"symbol" : null,
												"per" : null
												<%}%>}
												]
									} ],
									
									"drilldown" : {
										"allowPointDrilldown": true,
										"series" : [
											{
												"id": "Pharmacy",
												"name" : "Pharmacy",
												"data": [
													{
														"name": 'a',
														"y": 10000
													},
													{
														"name": 'b',
														"y": 20000
													},
													{
														"name": 'c',
														"y": 20000
													}
												]
											}
										]
									}

							,responsive : {
								rules : [ {
									condition : {
										maxWidth : 500
									},
									chartOptions : {
										legend : {
											layout : 'horizontal',
											align : 'center',
											verticalAlign : 'bottom'
										}
									}
								} ]
							}

						});
	});
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
		<nav id="navbar" style="transition: top 0.5s"
			class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
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
					<%-- <jsp:include page="leftbottom_comparison.jsp"></jsp:include> --%>
				</nav>
				<!-- partial -->
				<div class="content-wrapper">

					<%
						///////////////////////// Modal - Start
					%>
					<jsp:include page="../../filter_com10.jsp"><jsp:param
							value="comparison11.jsp" name="action" /><jsp:param
							value="<%=select_type1%>" name="select_type1" /><jsp:param
							value="<%=select_type2%>" name="select_type2" /><jsp:param
							value="<%=date_arr[1]%>" name="date" /><jsp:param value="yes"
							name="sub" /></jsp:include>
					<%
						///////////////////////// Modal - End
					%>

					<div class="row">
						<div class="col-12 grid-margin">
							<div class="card">
								<div class="card-body">
									<div id="containerLine" style="width: 100%; height: 500px;"></div>
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
		response.sendRedirect("../../Logout.jsp?error=Logout%20from%20the%20system...");
	}
%>