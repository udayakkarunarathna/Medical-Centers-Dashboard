<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="db.DatabaseConnection"%>
<%@page import="com.query.Query"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	//session.setAttribute("userName", "Admin");
	session.setAttribute("title", "Medical Center");
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


<script src="../../node_modules/jquery/dist/jquery.min.js"></script>
<script src="../../node_modules/highcharts/highstock.js"></script>
<script src="../../node_modules/highcharts/modules/exporting.js"></script>
<script src="../../node_modules/highcharts/modules/export-data.js"></script>
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
	
<!-- <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://code.highcharts.com/stock/highstock.js"></script>
<script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
<script src="https://code.highcharts.com/stock/modules/export-data.js"></script> -->

<%
	int mc = 202;
		/* if (session.getAttribute("mc") != null) {
			mc = Integer.parseInt((String) session.getAttribute("mc"));
		} */

		String select_type1 = "All";
		if (request.getParameter("select_type1") != null) {
			select_type1 = request.getParameter("select_type1");
		}
		String select_type2 = "REV";
		if (request.getParameter("select_type2") != null) {
			select_type2 = request.getParameter("select_type2");
		}
		String date_selection = "date";
		if (request.getParameter("date_selection") != null) {
			date_selection = request.getParameter("date_selection");
		}
		if (date_selection.equals("")) {
			date_selection = "date";
		}
		// System.out.println("select_type1 = " + select_type1);
		// System.out.println("date_selection = " + date_selection);

		double ph_target = 0, lab_target = 0, mp_target = 0, sna_target = 0;

		double ph_income1 = 0, ph_income2 = 0, lab_income1 = 0, lab_income2 = 0, mp_income1 = 0, mp_income2 = 0,
				sna_income1 = 0, sna_income2 = 0;

		String date_from = "";
		String date_to = "";
		
		String date1 = "";
		String date2 = "";

		String week1 = "";
		String week2 = "";
		String week11 = "";
		String week22 = "";

		String month1 = "";
		String month2 = "";

		String year1 = "";
		String year2 = "";

		String sub_title1 = "", sub_title2 = "", title_ex = "";

		
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
			
		if (request.getParameter("date1") != null) {
			date1 = request.getParameter("date1");
		} else if (session.getAttribute("date1") != null) {
			date1 = (String) session.getAttribute("date1");
		} else {
			date1 = Query.getDateMonthYear("yesterday", conn);
		}

		if (request.getParameter("date2") != null) {
			date2 = request.getParameter("date2");
		} else if (session.getAttribute("date2") != null) {
			date2 = (String) session.getAttribute("date2");
		} else {
			date2 = Query.getDateMonthYear("today", conn);
		}

		if (request.getParameter("week1") != null) {
			week1 = request.getParameter("week1");
		} else if (session.getAttribute("week1") != null) {
			week1 = (String) session.getAttribute("week1");
		} else {
			week1 = Query.getDateMonthYear("yesterday", conn);
		}

		if (request.getParameter("week11") != null) {
			week11 = request.getParameter("week11");
		} else if (session.getAttribute("week11") != null) {
			week11 = (String) session.getAttribute("week11");
		} else {
			week11 = Query.getDateMonthYear("yesterday", conn);
		}

		// System.out.println("Com week11 = " + week11);

		if (request.getParameter("week2") != null) {
			week2 = request.getParameter("week2");
		} else if (session.getAttribute("week2") != null) {
			week2 = (String) session.getAttribute("week2");
		} else {
			week2 = Query.getDateMonthYear("today", conn);
		}

		if (request.getParameter("week22") != null) {
			week22 = request.getParameter("week22");
		} else if (session.getAttribute("week22") != null) {
			week22 = (String) session.getAttribute("week22");
		} else {
			week22 = Query.getDateMonthYear("today", conn);
		}

		// System.out.println("Com week22 = " + week22);

		if (request.getParameter("month1") != null) {
			month1 = request.getParameter("month1");
		} else if (session.getAttribute("month1") != null) {
			month1 = (String) session.getAttribute("month1");
		} else {
			month1 = Query.getDateMonthYear("last_month", conn);
		}

		if (request.getParameter("month2") != null) {
			month2 = request.getParameter("month2");
		} else if (session.getAttribute("month2") != null) {
			month2 = (String) session.getAttribute("month2");
		} else {
			month2 = Query.getDateMonthYear("this_month", conn);
		}

		if (request.getParameter("year1") != null) {
			year1 = request.getParameter("year1");
		} else if (session.getAttribute("year1") != null) {
			year1 = (String) session.getAttribute("year1");
		} else {
			year1 = Query.getDateMonthYear("last_year", conn);
		}

		if (request.getParameter("year2") != null) {
			year2 = request.getParameter("year2");
		} else if (session.getAttribute("year2") != null) {
			year2 = (String) session.getAttribute("year2");
		} else {
			year2 = Query.getDateMonthYear("this_year", conn);
		}

		session.setAttribute("date1", date1);
		session.setAttribute("date2", date2);
		session.setAttribute("week1", week1);
		session.setAttribute("week2", week2);
		session.setAttribute("week11", week11);
		session.setAttribute("week22", week22);
		
		// System.out.println("month1 = " + month1);
		// System.out.println("month2 = " + month2);
		
		session.setAttribute("month1", month1);
		session.setAttribute("month2", month2);
		
		// System.out.println("year1 = " + year1);
		// System.out.println("year2 = " + year2);
		
		session.setAttribute("year1", year1);
		session.setAttribute("year2", year2);


		if (date_selection.equals("date")) {
			// If date //////////////////////////////////////////////////////////

			/* ph_target = Query.getTargetAmount("PH", date1, date1, select_type1, conn);
			lab_target = Query.getTargetAmount("LAB", date1, date1, select_type1, conn);
			mp_target = Query.getTargetAmount("MP", date1, date1, select_type1, conn);
			sna_target = Query.getTargetAmount("SNA", date1, date1, select_type1, conn);

			ph_income1 = Query.PharmachyRevenueAll(date1, date1, select_type1, "All", conn);
			lab_income1 = Query.LabRevenueWC(date1, date1, select_type1, conn);
			mp_income1 = Query.MediPackRevenueWC(date1, date1, select_type1, conn);
			sna_income1 = Query.ServiceNonAppRevenueWC(date1, date1, select_type1, conn);

			ph_income2 = Query.PharmachyRevenueAll(date2, date2, select_type1, "All", conn);
			lab_income2 = Query.LabRevenueWC(date2, date2, select_type1, conn);
			mp_income2 = Query.MediPackRevenueWC(date2, date2, select_type1, conn);
			sna_income2 = Query.ServiceNonAppRevenueWC(date2, date2, select_type1, conn); */

			sub_title1 = date1;
			sub_title2 = date2;
			title_ex = "Between Dates";

			//////////////////////////////////////////////////////////////////////
		} else if (date_selection.equals("week")) {
			// If date range //////////////////////////////////////////////////////////

			/* ph_target = (Query.getTargetAmount("PH", week1, week11, select_type1, conn)
					+ Query.getTargetAmount("PH", week2, week22, select_type1, conn)) / 2;
			lab_target = (Query.getTargetAmount("LAB", week1, week11, select_type1, conn)
					+ Query.getTargetAmount("LAB", week2, week22, select_type1, conn)) / 2;
			mp_target = (Query.getTargetAmount("MP", week1, week11, select_type1, conn)
					+ Query.getTargetAmount("MP", week2, week22, select_type1, conn)) / 2;
			sna_target = (Query.getTargetAmount("SNA", week1, week11, select_type1, conn)
					+ Query.getTargetAmount("SNA", week2, week22, select_type1, conn)) / 2;

			ph_income1 = Query.PharmachyRevenueAll(week1, week11, select_type1, "All", conn);
			lab_income1 = Query.LabRevenueWC(week1, week11, select_type1, conn);
			mp_income1 = Query.MediPackRevenueWC(week1, week11, select_type1, conn);
			sna_income1 = Query.ServiceNonAppRevenueWC(week1, week11, select_type1, conn);

			ph_income2 = Query.PharmachyRevenueAll(week2, week22, select_type1, "All", conn);
			lab_income2 = Query.LabRevenueWC(week2, week22, select_type1, conn);
			mp_income2 = Query.MediPackRevenueWC(week2, week22, select_type1, conn);
			sna_income2 = Query.ServiceNonAppRevenueWC(week2, week22, select_type1, conn); */

			sub_title1 = "From " + week1 + " to " + week11;
			sub_title2 = "from " + week2 + " to " + week22;
			title_ex = "Between Date Ranges";

			//////////////////////////////////////////////////////////////////////
		} else if (date_selection.equals("month")) {
			// If month //////////////////////////////////////////////////////////
			
			/* ph_target = Query.getTargetAmount("PH", (month1 + "-01"), Query.getLastDate(month2, conn), select_type1, conn)/2;
			lab_target = Query.getTargetAmount("LAB", (month1 + "-01"), Query.getLastDate(month2, conn), select_type1, conn)/2;
			mp_target = Query.getTargetAmount("MP", (month1 + "-01"), Query.getLastDate(month2, conn), select_type1, conn)/2;
			sna_target = Query.getTargetAmount("SNA", (month1 + "-01"), Query.getLastDate(month2, conn), select_type1, conn)/2;

			ph_income1 = Query.PharmachyRevenueAll((month1 + "-01"), Query.getLastDate(month1, conn), select_type1, "All", conn);
			lab_income1 = Query.LabRevenueWC((month1 + "-01"), Query.getLastDate(month1, conn), select_type1, conn);
			mp_income1 = Query.MediPackRevenueWC((month1 + "-01"), Query.getLastDate(month1, conn), select_type1, conn);
			sna_income1 = Query.ServiceNonAppRevenueWC((month1 + "-01"), Query.getLastDate(month1, conn), select_type1, conn);

			ph_income2 = Query.PharmachyRevenueAll((month2 + "-01"), Query.getLastDate(month2, conn), select_type1, "All", conn);
			lab_income2 = Query.LabRevenueWC((month2 + "-01"), Query.getLastDate(month2, conn), select_type1, conn);
			mp_income2 = Query.MediPackRevenueWC((month2 + "-01"), Query.getLastDate(month2, conn), select_type1, conn);
			sna_income2 = Query.ServiceNonAppRevenueWC((month2 + "-01"), Query.getLastDate(month2, conn), select_type1, conn); */

			sub_title1 = month1;
			sub_title2 = month2;
			title_ex = "Between Months";

			//////////////////////////////////////////////////////////////////////	
		} else if (date_selection.equals("year")) {
			// If year //////////////////////////////////////////////////////////

			/* ph_target = Query.getTargetAmount("PH", (year1 + "-01-01"), (year2 + "-12-31"), select_type1, conn)/2;
			lab_target = Query.getTargetAmount("LAB", (year1 + "-01-01"), (year2 + "-12-31"), select_type1, conn)/2;
			mp_target = Query.getTargetAmount("MP", (year1 + "-01-01"), (year2 + "-12-31"), select_type1, conn)/2;
			sna_target = Query.getTargetAmount("SNA", (year1 + "-01-01"), (year2 + "-12-31"), select_type1, conn)/2;

			ph_income1 = Query.PharmachyRevenueAll((year1 + "-01-01"), (year1 + "-12-31"), select_type1, "All", conn);
			lab_income1 = Query.LabRevenueWC((year1 + "-01-01"), (year1 + "-12-31"), select_type1, conn);
			mp_income1 = Query.MediPackRevenueWC((year1 + "-01-01"), (year1 + "-12-31"), select_type1, conn);
			sna_income1 = Query.ServiceNonAppRevenueWC((year1 + "-01-01"), (year1 + "-12-31"), select_type1, conn);

			ph_income2 = Query.PharmachyRevenueAll((year2 + "-01-01"), (year2 + "-12-31"), select_type1, "All", conn);
			lab_income2 = Query.LabRevenueWC((year2 + "-01-01"), (year2 + "-12-31"), select_type1, conn);
			mp_income2 = Query.MediPackRevenueWC((year2 + "-01-01"), (year2 + "-12-31"), select_type1, conn);
			sna_income2 = Query.ServiceNonAppRevenueWC((year2 + "-01-01"), (year2 + "-12-31"), select_type1, conn); */
			
			sub_title1 = year1;
			sub_title2 = year2;
			title_ex = "Between Years";
			
			//////////////////////////////////////////////////////////////////////
		}

		conn.CloseDataBaseConnection();
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			System.out.println(e);
		}
		
		double tot_income = ph_income2 + lab_income2 + mp_income2 + sna_income2;
		double tot_target = ph_income1 + lab_income1 + mp_income1 + sna_income1;
		
		
		if (select_type1.equals("All")) {
			session.setAttribute("target_all", ph_target + lab_target + sna_target + mp_target);
			session.setAttribute("revenue1", ph_income1 + lab_income1 + sna_income1 + mp_income1);
			session.setAttribute("revenue2", ph_income2 + lab_income2 + sna_income2 + mp_income2);
		}

		String color1_1 = "", color1_2 = "", color2_1 = "", color2_2 = "", color3_1 = "", color3_2 = "",color4_1 = "", color4_2 = "";
		
		// #F16868 - red
		// #64E572 - green
		
		if (lab_income1 < lab_income2) {
			color1_1 = "#F16868";
			color1_2 = "#64E572"; 
		} else {
			color1_1 = "#64E572";
			color1_2 = "#F16868"; 
		}
		
		if (ph_income1 < ph_income2) {
			color2_1 = "#F16868";
			color2_2 = "#64E572"; 
		} else {
			color2_1 = "#64E572";
			color2_2 = "#F16868"; 
		}
		
		if (sna_income1 < sna_income2) {
			color3_1 = "#F16868";
			color3_2 = "#64E572"; 
		} else {
			color3_1 = "#64E572";
			color3_2 = "#F16868"; 
		}
		
		if (mp_income1 < mp_income2) {
			color4_1 = "#F16868";
			color4_2 = "#64E572"; 
		} else {
			color4_1 = "#64E572";
			color4_2 = "#F16868"; 
		}
%>
<script>
$(function() {
	var seriesOptions = [], seriesCounter = 0, names = [ 'MSFT', 'AAPL', 'GOOG' ];

	/**
	 * Create the chart when all data is loaded
	 * @returns {undefined}
	 */
	function createChart() {

		Highcharts
				.stockChart(
						'containerStock',
						{

							rangeSelector : {
								selected : 4
							},

							yAxis : {
								labels : {
									formatter : function() {
										return (this.value > 0 ? ' + ' : '')
												+ this.value + '%';
									}
								},
								plotLines : [ {
									value : 0,
									width : 2,
									color : 'silver'
								} ]
							},

							plotOptions : {
								series : {
									compare : 'percent',
									showInNavigator : true
								}
							},

							tooltip : {
								pointFormat : '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
								valueDecimals : 2,
								split : true
							},

							series : seriesOptions
						});
	}

	$.each(names, function(i, name) {

		$.getJSON(name.toLowerCase() + '-c.json', function(data) {

			seriesOptions[i] = {
				name : name,
				data : data
			};

			// As we're loading the data asynchronously, we don't know what order it will arrive. So
			// we keep a counter and create the chart when all the data is loaded.
			seriesCounter += 1;

			if (seriesCounter === names.length) {
				createChart();
			}
		});
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
		 <nav id="navbar" style="transition: top 0.5s" class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
			<!-- <div
				class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
				<a class="navbar-brand brand-logo" href="../../dashboardsuperadmin.jsp"><img
					src="../../images/logo.svg" alt="logo" /></a> <a
					class="navbar-brand brand-logo-mini" href="../../dashboardsuperadmin.jsp"><img
					src="../../images/logo-mini.svg" alt="logo" /></a>
			</div> -->
			<div
				class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
				<a class="navbar-brand brand-logo" href="../../dashboardsuperadmin.jsp"><img
					src="../../images/logo-mini.svg" alt="logo"
					style="margin-left: -40px; margin-right: 0px;" /><font
					class="font_3d" size="4px;"><b>&nbsp;<%=(String) session.getAttribute("title")%>
							
					</b></font></a> <a class="navbar-brand brand-logo-mini" href="../../dashboardsuperadmin.jsp"><img
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
							class="d-none d-lg-inline">Super Admin</span>
					</a>

						<div class="dropdown-menu navbar-dropdown w-100"
							aria-labelledby="profileDropdown">
							<!-- <a class="dropdown-item" href="../../target.jsp"> <i
								class="mdi mdi-cached mr-2 text-success"></i> Target
							</a> -->

							<div class="dropdown-divider"></div>
							<!-- <a class="dropdown-item" href="../../Logout.jsp"> <i
								class="mdi mdi-logout mr-2 text-primary"></i> Signout
							</a> -->
						</div></li>
					<li class="nav-item nav-logout d-none d-lg-block"><a
						class="nav-link" href=""> <i
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
					<jsp:include page="../../tabssuperadmin.jsp"><jsp:param
							value="yes" name="sub" /></jsp:include>
				</nav>
				<!-- partial -->
				<div class="content-wrapper">

					<%
						///////////////////////// Modal - Start
					%>
					<div>
						<jsp:include page="../../filter_date.jsp"><jsp:param
								value="dashboardsuperadmin.jsp" name="action" /><jsp:param
value="<%=select_type1%>" name="select_type1" /><jsp:param
value="<%=select_type2%>" name="select_type2" /><jsp:param
value="<%=date_from%>" name="date_from" /><jsp:param
value="<%=date_to%>" name="date_to" /><jsp:param
							value="yes" name="sub" /></jsp:include></div>
					<%
						///////////////////////// Modal - End
					%>

					<div class="row">
						<div class="col-12 grid-margin">
							<div class="card">
								<div class="card-body">
									<div id="containerStock" style="width: 100%; height: 400px; min-width: 310px"></div>
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