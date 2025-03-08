<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="db.DatabaseConnection"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="dao.DoctorSpeciality"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.query.Query"%>
<%
	if (request.getSession(false) != null && session.getAttribute("u_name") != null) {
%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	//System.out.println("Comparison...");
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
	int mc = 0;
		if (session.getAttribute("mc") != null) {
	mc = Integer.parseInt((String) session.getAttribute("mc"));
		}
		String select_type1 = "All";
		if (request.getParameter("select_type1") != null) {
	select_type1 = request.getParameter("select_type1");
		}
		String select_type2 = "TXN";
		if (request.getParameter("select_type2") != null) {
	select_type2 = request.getParameter("select_type2");
		}

		String select_type3 = "All";
		if (request.getParameter("select_type3") != null) {
	select_type3 = request.getParameter("select_type3");
		}

		// System.out.println("select_type1 = " + select_type1);
		// System.out.println("select_type2 = " + select_type2);
		// System.out.println("select_type3 = " + select_type3);

		String date_from = "";
		String date_to = "";

		double income = 0;

		/////////////////////////////////////////////////////////////////////////////////////
		ArrayList<DoctorSpeciality> arraylist = new ArrayList<DoctorSpeciality>();

		ArrayList<String[]> target_arraylist = new ArrayList<String[]>();
		ArrayList<String[]> income_arraylist = new ArrayList<String[]>();

		String column_name = "", currency = "", heading1 = "", heading2 = "", heading3 = "", valueSuffix = "";

		if (select_type1.equals("All")) {
	heading2 = "OPD & INWARD";
		} else {
	heading2 = select_type1;
		}

		if (select_type3.equals("PH")) {
	heading3 = "Pharmacy";
		} else if (select_type3.equals("LAB")) {
	heading3 = "Lab";
		} else if (select_type3.equals("MP")) {
	heading3 = "Medical Packages";
		} else if (select_type3.equals("SNA")) {
	heading3 = "Services";
		} else if (select_type3.equals("CHANNEL")) {
	heading3 = "Channel";
		} else {
	heading3 = "All Category";
		}

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


	target_arraylist = Query.getDoctorSpecialityTarget(date_from, date_to, select_type2, conn);

	if (select_type2.equals("REV")) {
		// Use stringbuilder instead of string 
		income_arraylist = Query.getSpecialityRevenueAmount(select_type1, select_type3, date_from,
		date_to, conn);
		column_name = "Amount (Rs.)";
		currency = "Rs.";
		valueSuffix = "";
	} else if (select_type2.equals("TXN")) {
		// Use stringbuilder instead of string 
		income_arraylist = Query.getSpecialityRevenueCount(select_type1, select_type3, date_from, date_to, conn);
		column_name = "Patient Count";
		currency = "";
		valueSuffix = " patients";
	}
	conn.CloseDataBaseConnection();
		} catch (Exception e) {
	conn.CloseDataBaseConnection();
	System.out.println(e);
		}

		double per = 0;
		for (int i = 0; i < target_arraylist.size(); i++) {
	per = 0;
	
	if (income_arraylist.size() > 0) {
		if (!target_arraylist.get(i)[2].equals("0")) {
			per = Double.parseDouble(income_arraylist.get(i)[2]) * 100
					/ Double.parseDouble(target_arraylist.get(i)[2]);
		}

		if (Double.parseDouble(income_arraylist.get(i)[2]) > 0) {
			arraylist.add(new DoctorSpeciality(per, target_arraylist.get(i)[1],
					Double.parseDouble(target_arraylist.get(i)[2]),
					Double.parseDouble(income_arraylist.get(i)[2])));
		}
	}

		}

		/* Sorting on percentage property*/
		// System.out.println("percentage Sorting:");
		// System.out.println("\n");		
		
		if (select_type2.equals("REV")) {
			Collections.sort(arraylist, DoctorSpeciality.Income);
		} else if (select_type2.equals("TXN")) {
			Collections.sort(arraylist, DoctorSpeciality.Percentage);
		}
		List<String[]> arraylist1 = new ArrayList<String[]>();

		for (DoctorSpeciality str : arraylist) {
			String color = "";
			if (str.getTarget() > str.getIncome()) {
				color = "#F16868";
			} else {
				color = "#64E572";
			}
			String[] arr = { Double.toString(str.getPercentage()), str.getName(),
					Double.toString(str.getTarget()), Double.toString(str.getIncome()), color };

			arraylist1.add(arr);

			//System.out.println("str.getPercentage() = " + str.getPercentage());
		}
		// System.out.println("\n");

		/////////////////////////////////////////////////////////////////////////////////////
%>
<script>
	$(function() {

		//Bar chart - Target vs Achievment
		var chart1 = Highcharts
				.chart(
						'containerBar',
						{
							chart : {
								marginTop: 100,
								marginRight: 50,
								type : 'bar',
								options3d : {
									enabled : true,
									alpha : 0,
									beta : 1,
									depth : 100,
									viewDistance : 25
								}
							},
							colors: ['rgb(124, 181, 236)', null],
							title : {
								text : 'Speciality wise <%=heading1%> Target vs Achievment - <%=heading2%> - <%=heading3%> - Without Collecting Center',
						        align: 'left'
							},
							subtitle : {
								text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>',
						        align: 'left'
							},
							xAxis : {
								//gridLineColor : 'white',
								categories : [ <%for (int i = 0; i < arraylist1.size(); i++) {%>'<%=arraylist1.get(i)[1]%>',<%}%>]
							},
							yAxis : {
								//gridLineColor : 'white',
								title : {
									text : '<%=column_name%>'
								},
								labels: {
						            align: 'left'
						        }
							},
							legend: {
								align: 'left'	
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
							tooltip : {
								valueSuffix : ' <%=valueSuffix%>'
							},
							plotOptions : {
								series : {
									borderWidth : 0,
									dataLabels : {
										allowOverlap: true,
										enabled: true,
										y: 5,
										x: 1, 
										crop: false,
						                overflow: 'none',
						                inside: false,
										format: '<span style="font-size:12px"><%=currency%> {point.y:,.0f}</span> <span style="font-size:18px; color:#f96868; margin-left: 10px;">{point.per:.0f} {point.symbol}</span>'
									}
								},
								bar : {
									depth : 20
								}
							},
							legend : {
								layout : 'vertical',
								align : 'right',
								verticalAlign : 'top',
								x : -40,
								y : 80,
								floating : true,
								borderWidth : 1,
								backgroundColor : ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
								shadow : true
							}, 
							"series" : [ {
								"name" : 'Target',
								"data" : [ <%for (int i = 0; i < arraylist1.size(); i++) {%>{
									"y" :
										<%=arraylist1.get(i)[2]%>
											,
																			"per" : null,
																			"symbol" : null
																		},<%}%>]
							}, {
								"name" : 'Achievment',
								"data" : [ <%for (int i = 0; i < arraylist1.size(); i++) {%>{
									"y" : <%=arraylist1.get(i)[3]%>,
									"color" : "<%=arraylist1.get(i)[4]%>",
									"per" : <%=arraylist1.get(i)[0]%>,
									"symbol" : "%"
								},<%}%>]
							} ]
						});
		
		function showValues() {
			$('#alpha-value').html(chart1.options.chart.options3d.alpha);
			$('#beta-value').html(chart1.options.chart.options3d.beta);
			$('#depth-value').html(chart1.options.chart.options3d.depth);
		}

		// Activate the sliders
		$('#sliders input').on('input change', function() {
			chart1.options.chart.options3d[this.id] = parseFloat(this.value);
			showValues();
			chart1.redraw(false);
		});

		showValues();
	});
	//////////////////////////////////////////////
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
		 <nav id="navbar" style="transition: top 0.5s" class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
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
					<%-- <jsp:include page="leftbottom.jsp"></jsp:include> --%>
				</nav>
				<!-- partial -->
				<div class="content-wrapper">
					<%
						///////////////////////// Modal - Start
					%>
					<jsp:include page="../../filter_date_spec.jsp"><jsp:param
							value="specialitywise.jsp" name="action" /><jsp:param
							value="yes" name="spec" /><jsp:param value="yes" name="sub" /><jsp:param
							value="<%=select_type1%>" name="select_type1" /><jsp:param
							value="<%=select_type2%>" name="select_type2" /><jsp:param
							value="<%=select_type3%>" name="select_type3" /><jsp:param
							value="<%=date_from%>" name="date_from" /><jsp:param
							value="<%=date_to%>" name="date_to" /></jsp:include>
					<%
						///////////////////////// Modal - End
					%>
					<div class="row">
						<div class="col-12 grid-margin" style="">
							<div class="card" style="">
								<div class="card-body" style="">
									<div id="containerBar"
										style="width: 100%; min-height:100%; height: <%=arraylist.size() * 135%>px; position: relative;"></div>
									<div id="sliders" style="display: inline; display: none;">
										<table>
											<tr>
												<td>Alpha Angle</td>
												<td><input id="alpha" type="range" min="0" max="45"
													value="15" /> <span id="alpha-value" class="value"></span></td>
											</tr>
											<tr>
												<td>Beta Angle</td>
												<td><input id="beta" type="range" min="-45" max="45"
													value="15" /> <span id="beta-value" class="value"></span></td>
											</tr>
											<tr>
												<td>Depth</td>
												<td><input id="depth" type="range" min="20" max="100"
													value="50" /> <span id="depth-value" class="value"></span></td>
											</tr>
										</table>
									</div>
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

