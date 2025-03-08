<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 2:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="ws.RESTfulJerseyClient"%>
<%@page import="db.DatabaseConnection"%>
<%
	//System.out.println("request.getSession(false) = " + request.getSession(false));

	//System.out.println("session.getAttribute(u_name) = " + session.getAttribute("u_name"));

	if (request.getSession(false) != null && session.getAttribute("u_name") != null) {
%>
<%@page import="com.query.Query"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	//session.setAttribute("userName", "Admin");
		session.setAttribute("title", "Medical Center");
		//System.out.println("Dashboard...");

		String u_name = "";
		if (request.getParameter("u_name") != null) {
			u_name = request.getParameter("u_name");
		}
		String password = "";
		if (request.getParameter("password") != null) {
			password = request.getParameter("password");
		}

		String select_type1 = "All";
		if (request.getParameter("select_type1") != null) {
			select_type1 = request.getParameter("select_type1");
		}
		int mc = 0;
		if (session.getAttribute("mc") != null) {
			mc = Integer.parseInt((String) session.getAttribute("mc"));
		}
		// System.out.println("select_type1 = " + select_type1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Dashboard | Medical Center</title>
<!-- plugins:css -->
<link rel="stylesheet"
	href="node_modules/mdi/css/materialdesignicons.min.css">
<link rel="stylesheet"
	href="node_modules/perfect-scrollbar/dist/css/perfect-scrollbar.min.css">
<!-- endinject -->
<!-- plugin css for this page -->
<link rel="stylesheet"
	href="node_modules/jquery-bar-rating/dist/themes/css-stars.css">
<script src="node_modules/popper.js/dist/umd/popper.min.js"></script>
<link rel="stylesheet"
	href="node_modules/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css" />
<link rel="stylesheet"
	href="node_modules/font-awesome/css/font-awesome.min.css" />
<script src="node_modules/highcharts/highcharts.js"></script>
<script src="node_modules/highcharts/highcharts-3d.js"></script>
<script src="node_modules/highcharts/modules/exporting.js"></script>
<script src="node_modules/highcharts/modules/export-data.js"></script>
<script src="node_modules/highcharts/modules/series-label.js"></script>
<script src="node_modules/jquery/dist/jquery.min.js"></script>

<!-- End plugin css for this page -->
<!-- inject:css -->
<link rel="stylesheet" href="css/style.css">
<!-- endinject -->
<link rel="shortcut icon" href="images/favicon.png" />
<style type="text/css">
table {
	border: 1
}
</style>
<style type="text/css">
containerMain1, containerMain2 {
	min-width: 310px;
	max-width: 800px;
	margin: 0 auto;
}

containerMain1, containerMain2 {
	height: 400px;
}
</style>
<%
	double target = 0, revenue = 0, head_count = 0, tag_head_count = 0;
		double target_per = 0;
		String date_from = "";
		String date_to = "";
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
	
	session.setAttribute("date_from1", date_from);
	session.setAttribute("date_to1", date_to);

	// System.out.println("date_from = " + date_from);
	// System.out.println("date_to = " + date_to);
	// System.out.println("");
	
	String access_token = "";
	access_token = RESTfulJerseyClient.getAccessToken();
	
	double[] channel_amt_count_arr = new double[2];		
	//System.out.println("mc = " + mc);		
	//System.out.println("access_token = " + access_token);		
	//System.out.println("select_type1 = " + select_type1);				
	
	target = Query.getAllTargetAmount2(date_from, date_to, select_type1, conn);
	// System.out.println("target = " + target);			

	tag_head_count = Query.getAllTargetCount(date_from, date_to, select_type1, conn);
	// System.out.println("tag_head_count = " + tag_head_count);
	
	
	if(!access_token.equals("")){
		channel_amt_count_arr = Query.ChannelRevenueCountAll(mc, "TXN",  access_token, date_from, date_to, select_type1);	
	}
	//System.out.println("channel_amt_count_arr = " + channel_amt_count_arr[0] + "," + channel_amt_count_arr[1]);


			//revenue = Query.getRevenueAll(date_from, date_to, select_type1, conn);
			revenue = Query.getRevenueAllWC(date_from, date_to, select_type1, conn, mc, access_token) + channel_amt_count_arr[0];
			//System.out.println("1 = " + revenue);	
			//System.out.println("2 = " + (revenue - channel_amt_count_arr[0]));		

			head_count = Query.getCountAllWC(date_from, date_to, select_type1, conn, mc, access_token) + channel_amt_count_arr[1];
			// System.out.println("head_count = " + head_count);

			conn.CloseDataBaseConnection();
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			// System.out.println(e);
		}

		if (target > 0) {
			target_per = revenue * 100 / target;
		}

		if (select_type1.equals("All")) {
			session.setAttribute("target_all", target);
			session.setAttribute("revenue_all", revenue);
			session.setAttribute("head_count_all", head_count);
			session.setAttribute("tag_head_count_all", tag_head_count);
		}

		DecimalFormat df = new DecimalFormat("###,###,###");
		DecimalFormat df1 = new DecimalFormat("##########");
		String color1 = "", color2 = "";

		if (target < revenue) {
			color1 = "#64E572";
		} else {
			color1 = "#F16868";
		}

		if (tag_head_count < head_count) {
			color2 = "#64E572";
		} else {
			color2 = "#F16868";
		}

		double tag_head_count_per = 0;
		if (tag_head_count > 0) {
			tag_head_count_per = head_count * 100 / tag_head_count;
		}
%>
<script type="text/javascript">

	$(function() {
		//Set up the chart
		var chart1 = new Highcharts.Chart(
				{
					chart : {
						marginTop: 100,
						renderTo : 'containerMain1',
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
						text : '<%=select_type1%> Target Vs Revenue - Without Collecting Center'
					},
					subtitle : {
						text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
					},
					tooltip : {
						valueSuffix : ''
					},
					xAxis : {
						//gridLineColor: 'white',
						categories : [ '' ]
					},
					yAxis : {
						///gridLineColor: 'white',
						min : 0,
						title : {
							text : 'Amount (Rs.)'
						},
						stackLabels : {
							enabled : true,
							style : {
								fontWeight : 'bold',
								fontSize : '14px;',
								color : (Highcharts.theme && Highcharts.theme.textColor)
										|| 'gray'
							}
						}
					},
					labels: {
						formatter: function() {
							return Highcharts.numberFormat(this.value, 2);
						}
					},
					plotOptions : {
						column : {
							depth : 150,
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								x: 0,
								format : '<span style="font-size:22px; color:#f96868;">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px">Rs. {point.y:,.0f}</span>'
							}
						}
					},
					"series" : [ {
						"name" : "Target",
						"data" : [ {
							"y" : <%=df1.format(target)%>,
							"per" : null,
							"symbol" : null,
						} ]
					}, {
						"name" : "Revenue",
						"color" : "<%=color1%>",
						"data" : [ {
							"y" : <%=df1.format(revenue)%>,
							"per" : <%=df1.format(target_per)%>,
							"symbol" : '%'
						}
						]
					} ]
				});
		
		function showValues() {
		    $('#alpha-value').html(chart1.options.chart.options3d.alpha);
		    $('#beta-value').html(chart1.options.chart.options3d.beta);
		    $('#depth-value').html(chart1.options.chart.options3d.depth);
		}

		// Activate the sliders
		$('#sliders input').on('input change', function () {
		    chart1.options.chart.options3d[this.id] = parseFloat(this.value);
		    showValues();
		    chart1.redraw(false);
		});

		showValues();

		///////////////////////////////////////////////////////////////////////////

		//Set up the chart
		var chart2 = new Highcharts.Chart(
				{
					chart : {
						marginTop: 100,
						renderTo : 'containerMain2',
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
						text : '<%=select_type1%> Target Vs Achieved Head Count - Without Collecting Center'
					},
					subtitle : {
						text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
					},
					tooltip : {
						valueSuffix : ' patients'
					},
					xAxis : {
						//gridLineColor: 'white',
						categories : [ '' ]
					},
					yAxis : {
						//gridLineColor: 'white',
						min : 0,
						title : {
							text : 'Head Count'
						},
						stackLabels : {
							enabled : true,
							style : {
								fontWeight : 'bold',
								fontSize : '14px;',
								color : (Highcharts.theme && Highcharts.theme.textColor)
										|| 'gray'
							}
						}
					},
					plotOptions : {
						column : {
							depth : 150,
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								x: 0,
								format : '<span style="font-size:22px; color:#f96868;">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px">{point.y:,.0f}</span>'
							}
						}
					},
					"series" : [ {
						"name" : "Target",
						"data" : [ {
							"y" :
<%=tag_head_count%>
	,
							"per" : null,
							"symbol" : null,
						} ]
					}, {
						"name" : "Achieved",
						"color" : "<%=color2%>",
						"data" : [ {
							"y" :
<%=head_count%>
	,
							"per" :
<%=tag_head_count_per%>
	,
							"symbol" : '%'
						}

						]
					} ]
				});

		///////////////////////////////////////////////////////////////////////////

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
		<!-- partial:partials/_navbar.html -->
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
				<a class="navbar-brand brand-logo" href="dashboard.jsp"><img
					src="images/logo-mini.svg" alt="logo"
					style="margin-left: -40px; margin-right: 0px;" /><font
					class="font_3d" size="4px;"><b>&nbsp;<%=(String) session.getAttribute("mc_name")%></b></font></a>
				<a class="navbar-brand brand-logo-mini" href="dashboard.jsp"><img
					src="images/logo-mini.svg" alt="logo" /></a>
			</div>
			<div class="navbar-menu-wrapper d-flex align-items-stretch">
				<div class="search-field ml-4 d-none d-md-block">
					<form class="d-flex align-items-stretch h-100" action="#">
						<div class="input-group" style="display: none;">
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
					<li class="nav-item dropdown"><!-- <a
						class="nav-link count-indicator dropdown-toggle"
						id="messageDropdown" href="#" data-toggle="dropdown"
						aria-expanded="false"> <i class="mdi mdi-email-outline"></i> <span
							class="count"></span>
					</a> -->

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
					<li class="nav-item dropdown"><!-- <a
						class="nav-link count-indicator dropdown-toggle"
						id="notificationDropdown" href="#" data-toggle="dropdown"> <i
							class="mdi mdi-bell-outline"></i> <span class="count"></span>
					</a> -->

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
							src="http://192.168.<%=session.getAttribute("mc")%>.250:8888/Employee_Photo/uicon.png" alt="image"> <span
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
					<jsp:include page="pages/highcharts/leftbottom.jsp">
						<jsp:param value="<%=date_from%>" name="date_from1" />
						<jsp:param value="<%=date_to%>" name="date_to1" />
					</jsp:include>
				</nav>
				<%
					double tot_sale = 0;
				%>
				<!-- partial -->
				<div class="content-wrapper">
					<%
						///////////////////////// Modal - Start
					%>
					<jsp:include page="filter_date.jsp"><jsp:param
							value="dashboard.jsp" name="action" /><jsp:param
							value="<%=date_from%>" name="date_from" /><jsp:param
							value="<%=date_to%>" name="date_to" /><jsp:param
							value="<%=select_type1%>" name="select_type1" /><jsp:param
							value="no" name="sub" /><jsp:param
							value="<%=mc%>" name="mc" /></jsp:include>
					<%
						///////////////////////// Modal - End
					%>
					<!-- <div><h1 class="display-4">Here use dates</h1></div> -->
					<div>
						<div class="row">
							<div class="col-md-3 stretch-card grid-margin">
								<div class="card bg-gradient-revenue text-white">
									<div class="card-body">
										<h4 class="font-weight-normal mb-2"><%=select_type1%>
											Revenue
										</h4>
										<h2 class="font-weight-normal mb-3">
											<font size="3">Rs.</font>
											<%=df.format(revenue)%></h2>
										<p class="card-text">
											Head Count <font size="5"><%=df.format(head_count)%></font>
										</p>
									</div>
								</div>
							</div>
							<div class="col-md-3 stretch-card grid-margin">
								<div class="card bg-gradient-target text-white">
									<div class="card-body">
										<h4 class="font-weight-normal mb-2"><%=select_type1%>
											Target
										</h4>
										<h2 class="font-weight-normal mb-3">
											<font size="3">Rs.</font>
											<%=df.format(target)%></h2>
										<p class="card-text">
											Target Head Count <font size="5"><%=df.format(tag_head_count)%></font>
										</p>
									</div>
								</div>
							</div>
							<%
								if (revenue >= target) {
							%>
							<div class="col-md-3 stretch-card grid-margin">
								<div class="card bg-gradient-success text-white">
									<div class="card-body">
										<h4 class="font-weight-normal mb-2">Success Revenue</h4>
										<h2 class="font-weight-normal mb-3">
											<font size="3">Rs.</font>
											<%=df.format(revenue - target)%>
											<i class="fa fa-long-arrow-up"></i>
										</h2>
										<p class="card-text">
											Percentage : <font size="5"><%=df.format(target_per)%>
												%</font>
										</p>
									</div>
								</div>
							</div>
							<%
								} else {
							%>
							<div class="col-md-3 stretch-card grid-margin">
								<div class="card bg-gradient-danger text-white">
									<div class="card-body">
										<h4 class="font-weight-normal mb-2">Unsuccess Revenue</h4>
										<h2 class="font-weight-normal mb-3">
											<font size="3">Rs.</font>
											<%=df.format(revenue - target)%>
											<i class="fa fa-long-arrow-down"></i>
										</h2>
										<p class="card-text">
											Percentage : <font size="5"><%=df.format(target_per)%>
												%</font>
										</p>
									</div>
								</div>
							</div>
							<%
								}
							%>
							<%
								if (head_count >= tag_head_count) {
							%>
							<div class="col-md-3 stretch-card grid-margin">
								<div class="card bg-gradient-success text-white">
									<div class="card-body">
										<h4 class="font-weight-normal mb-2">Success Head Count</h4>

										<h2 class="font-weight-normal mb-3"><%=df.format(head_count - tag_head_count)%>
											<i class="fa fa-long-arrow-up"></i>
										</h2>
										<p class="card-text">
											Percentage : <font size="5"><%=df.format((head_count * 100) / tag_head_count)%>
												%</font>
										</p>
									</div>
								</div>
							</div>
							<%
								} else {
							%>
							<div class="col-md-3 stretch-card grid-margin">
								<div class="card bg-gradient-danger text-white">
									<div class="card-body">
										<h4 class="font-weight-normal mb-2">Unsuccess Head Count</h4>
										<h2 class="font-weight-normal mb-3"><%=df.format(head_count - tag_head_count)%>
											<i class="fa fa-long-arrow-down"></i>
										</h2>
										<p class="card-text">
											Percentage : <font size="5"><%=df.format((head_count * 100) / tag_head_count)%>
												%</font>
										</p>
									</div>
								</div>
							</div>
							<%
								}
							%>
						</div>

						<div class="row">
							<div class="col-md-6 grid-margin stretch-card">
								<div class="card">
									<div class="card-body">
										<div id="containerMain1" style="width: 100%; height: 450px;"></div>
										<div id="sliders" style="display: none;">
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
							<div class="col-md-6 grid-margin stretch-card">
								<div class="card">
									<div class="card-body">
										<div id="containerMain2" style="width: 100%; height: 450px;"></div>
									</div>
								</div>
							</div>
						</div>

						<div class="row" style="display: none">
							<div class="col-md-6 d-flex align-items-stretch grid-margin">
								<div class="col-12 grid-margin">
									<div class="card">
										<div class="card-body">
											<h4 class="card-title">Sale Overview</h4>
											<canvas id="sales-chart"></canvas>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-6 d-flex align-items-stretch grid-margin">
								<div class="col-12 grid-margin">
									<div class="card">
										<div class="card-body d-flex flex-column">
											<h4 class="card-title">Satisfaction Graph</h4>

											<div class="mt-auto">
												<canvas id="satisfaction-chart"></canvas>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row" style="display: none">
							<div class="col-lg-12 grid-margin stretch-card">
								<div class="card">
									<div class="card-body">
										<h4 class="card-title">Recent Updates</h4>

										<div class="d-flex">
											<div class="d-flex align-items-center mr-4 text-muted">
												<i class="mdi mdi-account icon-sm mr-2"></i> <span>jack
													Menqu</span>
											</div>
											<div class="d-flex align-items-center text-muted">
												<i class="mdi mdi-calendar-blank icon-sm mr-2"></i> <span>October
													3rd, 2018</span>
											</div>
										</div>
										<div class="row mt-3">
											<div class="col-6 pr-1">
												<img src="images/dashboard/img_1.jpg"
													class="mb-2 mw-100 w-100 rounded" alt="image"> <img
													src="images/dashboard/img_4.jpg"
													class="mw-100 w-100 rounded" alt="image">
											</div>
											<div class="col-6 pl-1">
												<img src="images/dashboard/img_2.jpg"
													class="mb-2 mw-100 w-100 rounded" alt="image"> <img
													src="images/dashboard/img_3.jpg"
													class="mw-100 w-100 rounded" alt="image">
											</div>
										</div>
										<div class="d-flex mt-5 align-items-top">
											<img src="images/faces/face3.jpg"
												class="img-sm rounded-circle mr-3" alt="image">

											<div class="mb-0 flex-grow">
												<p class="font-weight-bold mr-2 mb-0">Jack Manque</p>

												<p>This is amazing! We have moved to a brand new office
													in New Hampshire with a lot more space. We will miss our
													old office but we are very excited about our new space.</p>
											</div>
											<div class="ml-auto">
												<i class="mdi mdi-heart-outline text-muted"></i>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row" style="display: none">
							<div class="col-12 grid-margin">
								<div class="card">
									<div class="card-body">
										<h4 class="card-title">Recent Tickets</h4>

										<div class="table-responsive">
											<table class="table">
												<thead>
													<tr>
														<th>Ticket No.</th>
														<th>Subject</th>
														<th>Assignee</th>
														<th>Status</th>
														<th>Last Update</th>
														<th>Tracking ID</th>
														<th>Priority</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>5669</td>
														<td>Fund is not recieved</td>
														<td class="py-1"><img src="http://192.168.<%=session.getAttribute("mc")%>.250:8888/Employee_Photo/uicon.png"
															class="mr-2" alt="image"> David Grey</td>
														<td><label class="badge badge-gradient-success">DONE</label>
														</td>
														<td>Dec 5, 2017</td>
														<td>WD-12345</td>
														<td><i
															class="mdi mdi-arrow-up text-danger icon-sm mr-1"></i>High
														</td>
													</tr>
													<tr>
														<td>5670</td>
														<td>High loading time</td>
														<td class="py-1"><img src="images/faces/face2.jpg"
															class="mr-2" alt="image"> Stella Johnson</td>
														<td><label class="badge badge-gradient-warning">PROGRESS</label>
														</td>
														<td>Dec 12, 2017</td>
														<td>WD-12346</td>
														<td><i
															class="mdi mdi-arrow-up text-danger icon-sm mr-1"></i>High
														</td>
													</tr>
													<tr>
														<td>5671</td>
														<td>Website down for one week</td>
														<td class="py-1"><img src="images/faces/face3.jpg"
															class="mr-2" alt="image"> Marina Michel</td>
														<td><label class="badge badge-gradient-secondary">ON
																HOLD</label></td>
														<td>Dec 16, 2017</td>
														<td>WD-12347</td>
														<td><i
															class="mdi mdi-arrow-up text-success icon-sm mr-1"></i>Low
														</td>
													</tr>
													<tr>
														<td>5672</td>
														<td>Loosing control on server</td>
														<td class="py-1"><img src="images/faces/face4.jpg"
															class="mr-2" alt="image"> John Doe</td>
														<td><label class="badge badge-gradient-success">DONE</label>
														</td>
														<td>Dec 3, 2017</td>
														<td>WD-12348</td>
														<td><i
															class="mdi mdi-arrow-up text-warning icon-sm mr-1"></i>Medium
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- content-wrapper ends -->
				<jsp:include page="footer.jsp"></jsp:include>
				<!-- partial -->
				<!-- row-offcanvas ends -->
			</div>
			<!-- page-body-wrapper ends -->
		</div>
		<!-- container-scroller -->

		<!-- plugins:js -->
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
		<script src="js/dashboard.js"></script>
		<!-- End custom js for this page-->
	</div>
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
