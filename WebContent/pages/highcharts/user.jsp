<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
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
	DecimalFormat df = new DecimalFormat("###,###.##");
		String select_type1 = "All";
		if (request.getParameter("select_type1") != null) {
			select_type1 = request.getParameter("select_type1");
		}

		String select_type2 = "Revenue and Transactions";
		if (request.getParameter("select_type2") != null) {
			select_type2 = request.getParameter("select_type2");
		}

		int mc = 0;
		if (session.getAttribute("mc") != null) {
			mc = Integer.parseInt((String) session.getAttribute("mc"));
		}

		String date_from = "";
		String date_to = "";

		double ph_income = 0, lab_income = 0, mp_income = 0, sna_income = 0, ph_count = 0, lab_count = 0,
				mp_count = 0, sna_count = 0;
		String user_id = "", user_name = "";

		ArrayList<UserIncome> income_arraylist = new ArrayList<UserIncome>();
		ArrayList<UserIncome> count_arraylist = new ArrayList<UserIncome>();

		DatabaseConnection conn = new DatabaseConnection();
		ResultSet rs = null;

		String category[] = {"Pharmacy", "Lab", "Service Non Appointment"};
		String category_color[] = {"rgb(144, 237, 125)", "rgb(247, 163, 92)", "rgb(231, 241, 104)"};

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

			String query = "SELECT DISTINCT UPPER(USER_ID) USER_ID, NVL((SELECT UPPER((TRIM(U.LAST_NAME)) || ' ' || UPPER(TRIM(U.FIRST_NAME))) U_NAME FROM USERNAMEPASSWORDNEW U WHERE UPPER(U.USERNAME) = UPPER(USER_ID)), '-') U_NAME FROM"
					+ " (SELECT O.USER_ID FROM OUTDOOR_PATIENT_ISSUE O WHERE O.OUTDOOR_ISSUE_DATE BETWEEN TO_DATE('"
					+ date_from + "','YYYY-MM-DD') AND TO_DATE('" + date_to + "','YYYY-MM-DD')+1" + " UNION"
					+ " SELECT O.USER_ID FROM INWARD_PATIENT_ISSUE O WHERE O.INWARD_ISSUE_DATE BETWEEN TO_DATE('"
					+ date_from + "','YYYY-MM-DD') AND TO_DATE('" + date_to + "','YYYY-MM-DD')+1" + " UNION"
					+ " SELECT LI.USER_ID FROM LAB_TEST_INVOICES LI WHERE LI.TXN_DATE BETWEEN TO_DATE('"
					+ date_from + "','YYYY-MM-DD') AND TO_DATE('" + date_to + "','YYYY-MM-DD')+1" + " UNION"
					+ " SELECT MI.STAFF_ID FROM MEDI_PACK_INVOICES MI WHERE MI.TXN_DATE BETWEEN TO_DATE('"
					+ date_from + "','YYYY-MM-DD') AND TO_DATE('" + date_to + "','YYYY-MM-DD')+1" + " UNION"
					+ " SELECT SN.USER_ID FROM SERVICES_NONAPPOINTMENTS SN WHERE SN.TXN_DATE BETWEEN TO_DATE('"
					+ date_from + "','YYYY-MM-DD') AND TO_DATE('" + date_to + "','YYYY-MM-DD')+1)"
					+ " DUAL WHERE USER_ID IS NOT NULL";
			rs = conn.query(query);

			//System.out.println("query = " + query);

			DatabaseConnection conn1 = new DatabaseConnection();
			try {
				conn1.ConnectToDataBase(mc);
				while (rs.next()) {

					user_id = rs.getString("USER_ID");
					user_name = rs.getString("U_NAME");

					if (!select_type2.equals("Transactions")) {

						ph_income = Query.PharmachyRevenueAll(date_from, date_to, select_type1, user_id, conn1);
						lab_income = Query.LabRevenueAll(date_from, date_to, select_type1, user_id, conn1);
						//mp_income = Query.MediPackRevenueAll(date_from, date_to, select_type1, user_id, conn1);
						sna_income = Query.ServiceNonAppRevenueAll(date_from, date_to, select_type1, user_id,
								conn1);
						// System.out.println("/n");
						if (ph_income + lab_income + mp_income + sna_income > 0)
							income_arraylist
									.add(new UserIncome(user_name, ph_income, lab_income, mp_income, sna_income));

						Collections.sort(income_arraylist, UserIncome.userIncomeComparision);
					}

					if (!select_type2.equals("Revenue")) {
						ph_count = Query.PharmachyCount(date_from, date_to, select_type1, user_id, conn1);
						lab_count = Query.LabCount(date_from, date_to, select_type1, user_id, conn1);
						//mp_count = Query.MediPackCount(date_from, date_to, select_type1, user_id, conn1);
						sna_count = Query.ServiceNonAppCount(date_from, date_to, select_type1, user_id, conn1);

						if (ph_count + lab_count + mp_count + sna_count > 0)
							count_arraylist
									.add(new UserIncome(user_name, ph_count, lab_count, mp_count, sna_count));

						Collections.sort(count_arraylist, UserIncome.userIncomeComparision);
					}
				}
				conn1.CloseDataBaseConnection();
			} catch (Exception e) {
				conn1.CloseDataBaseConnection();
				System.out.println(e);
			}

			conn.CloseDataBaseConnection();
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			System.out.println(e);
		}

		List<String[]> income_arraylist1 = new ArrayList<String[]>();
		List<String[]> count_arraylist1 = new ArrayList<String[]>();

		if (!select_type2.equals("Transactions")) {
			for (UserIncome str : income_arraylist) {
				String color = "";
				String[] arr = {str.getUserName(), Double.toString(str.getPhIncome()),
						Double.toString(str.getLabIncome()),
						Double.toString(str.getSnaIncome())};
				income_arraylist1.add(arr);
			}
		}

		if (!select_type2.equals("Revenue")) {
			for (UserIncome str : count_arraylist) {
				String color = "";
				String[] arr = {str.getUserName(), Double.toString(str.getPhIncome()),
						Double.toString(str.getLabIncome()),
						Double.toString(str.getSnaIncome())};
				count_arraylist1.add(arr);
			}
		}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>User | Medical Center</title>
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
		
		<%if (!select_type2.equals("Transactions")) {%>
		var chart1 = new Highcharts.chart(
				'containerBar1',
				{
					chart : {
						type : 'column',
						marginRight: 0,
						options3d : {
							enabled : true,
							alpha : 0,
							beta : 0,
							depth : 100,
							viewDistance : 25
						}
					},
					title : {
						text : 'User wise <%=select_type1%>	Revenue (Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>)'
					},
					xAxis : {
						//gridLineColor : 'white',
						/* labels: {
            				rotation: 270
        				}, */
						categories : [<%if (income_arraylist1.size() > 0) {%> <%for (int i = 0; i < income_arraylist1.size(); i++) {%> '<%=income_arraylist1.get(i)[0]%>', <%}%> <%} else {%>''<%}%>]
					},
					yAxis : {
						//gridLineColor : 'white',
						title : {
							text : 'Total Amount (Rs.)'
						},
						stackLabels : {
							enabled : true,
							style : {
								fontWeight : 'bold',
								color : (Highcharts.theme && Highcharts.theme.textColor)
										|| 'gray'
							}
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
					scrollbar: {
				            enabled: true
				        },
					tooltip : {
						headerFormat : '<b>{point.x}</b><br/>',
						pointFormat : '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
					},
					plotOptions : {
						column : {
							depth : 100,
							stacking : 'normal',
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								color : (Highcharts.theme && Highcharts.theme.dataLabelsColor)
										|| 'white'
							}
						}
					},
					series : [ 
						<%for (int j = 0; j < category.length; j++) {%>
								{
									name : '<%=category[j]%>',
									color: '<%=category_color[j]%>',
									data : [<%if (income_arraylist1.size() > 0) {%> <%for (int i = 0; i < income_arraylist1.size(); i++) {
								if (!income_arraylist1.get(i)[j + 1].equals("0.0")) {%> <%=income_arraylist1.get(i)[j + 1]%> <%} else {%> null <%}%>, <%}%> <%} else {%>0<%}%>]
								},
								<%}%> ]
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
		<%}%>
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		<%if (!select_type2.equals("Revenue")) {%>
		var chart2 = new Highcharts.chart(
				'containerBar2',
				{
					chart : {
						type : 'column',
						marginRight: 0,
						options3d : {
							enabled : true,
							alpha : 0,
							beta : 0,
							depth : 100,
							viewDistance : 25
						}
					},
					title : {
						text : 'User wise <%=select_type1%>	Transactions (Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>)'
					},
					subtitle : {
						text : ''
					},
					xAxis : {
						//gridLineColor : 'white',
						/* labels: {
            				rotation: 270
        				}, */
						categories : [ <%for (int i = 0; i < count_arraylist1.size(); i++) {%> '<%=count_arraylist1.get(i)[0]%>', <%}%> ]
					},
					yAxis : {
						//gridLineColor : 'white',
						title : {
							text : 'Total Amount (Rs.)'
						},
						stackLabels : {
							enabled : true,
							style : {
								fontWeight : 'bold',
								color : (Highcharts.theme && Highcharts.theme.textColor)
										|| 'gray'
							}
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
					scrollbar: {
				            enabled: true
				        },
					tooltip : {
						headerFormat : '<b>{point.x}</b><br/>',
						pointFormat : '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
					},
					plotOptions : {
						column : {
							depth : 100,
							stacking : 'normal',
							dataLabels : {
								allowOverlap : true,
								enabled : true,
								color : (Highcharts.theme && Highcharts.theme.dataLabelsColor)
										|| 'white'
							}
						}
					},
					series : [ 
						<%for (int j = 0; j < category.length; j++) {%>
						{
							name : '<%=category[j]%>',
							color: '<%=category_color[j]%>',
							data : [
								<%for (int i = 0; i < count_arraylist1.size(); i++) {
							if (!count_arraylist1.get(i)[j + 1].equals("0.0")) {%> <%=count_arraylist1.get(i)[j + 1]%> <%} else {%> null <%}%>, <%}%>
							]
						},
						<%}%> ]
				});
		
		function showValues2() {
			$('#alpha-value').html(chart2.options.chart.options3d.alpha);
			$('#beta-value').html(chart2.options.chart.options3d.beta);
			$('#depth-value').html(chart2.options.chart.options3d.depth);
		}

		// Activate the sliders
		$('#sliders2 input').on('input change', function() {
			chart2.options.chart.options3d[this.id] = parseFloat(this.value);
			showValues2();
			chart2.redraw(false);
		});

		showValues2();
		<%}%>
		///////////////////////////////////////////////////////////////////////////////////////////
		
	});
</script>
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
					<jsp:include page="../../filter_date_user.jsp"><jsp:param
							value="user.jsp" name="action" /><jsp:param
							value="<%=select_type1%>" name="select_type1" /><jsp:param
							value="<%=select_type2%>" name="select_type2" /><jsp:param
							value="<%=date_from%>" name="date_from" /><jsp:param
							value="<%=date_to%>" name="date_to" /><jsp:param value="yes"
							name="sub" /></jsp:include>
					<%
						///////////////////////// Modal - End
					%>
					<%
						//System.out.println("select_type2 = " + select_type2);
							if (!select_type2.equals("Transactions")) {
					%>
					<div class="row">
						<div class="col-md-12 grid-margin" style="overflow: scroll; min-width:100%; width: <%=income_arraylist.size() * 100%>px;">
							<div class="card" style="width: <%=income_arraylist.size() * 100%>px; min-width:100%;">
								<div class="card-body" style="width: <%=income_arraylist.size() * 100%>px; min-width:100%;">
									<div class="table-responsive">
										<div id="containerBar1"
											style="height: 520px; width:100%; margin: 0 auto; position: relative;"></div>
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
						</div>
					</div>
					<%
						}
					%>


					<%
						if (!select_type2.equals("Transactions")) {
					%>
					<div class="row">
						<div class="col-md-12 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<h5 class="card-title" align="center">
										User Income Contribution (Between
										<%=date_from%>
										and
										<%=date_to%>)
									</h5>

									<div class="table-responsive">
										<table class="table">
											<thead>
												<tr>
													<th>#</th>
													<th>Name</th>
													<th>Overall Income Contribution</th>
													<th></th>
													<th align="right" style="text-align: right;">Pharmacy</th>
													<th align="right" style="text-align: right;">Service</th>
													<th align="right" style="text-align: right;">Lab</th>
													<th align="right" style="text-align: right;">Total</th>
												</tr>
											</thead>
											<tbody>
												<%
													double tot_user_income = 0;

															for (int i = 0; i < income_arraylist1.size(); i++) {
																tot_user_income = tot_user_income + Double.parseDouble(income_arraylist1.get(i)[1])
																		+ Double.parseDouble(income_arraylist1.get(i)[2])
																		+ Double.parseDouble(income_arraylist1.get(i)[3]);
															}

															double tot_row = 0, mp_tot = 0, ph_tot = 0, sna_tot = 0, lab_tot = 0, per = 0;
															String contribution = "";
															for (int i = 0; i < income_arraylist1.size(); i++) {
																per = 0;
																contribution = "";
																tot_row = Double.parseDouble(income_arraylist1.get(i)[1])
																		+ Double.parseDouble(income_arraylist1.get(i)[2])
																		+ Double.parseDouble(income_arraylist1.get(i)[3]);

																ph_tot = ph_tot + Double.parseDouble(income_arraylist1.get(i)[1]);
																sna_tot = sna_tot + Double.parseDouble(income_arraylist1.get(i)[3]);
																lab_tot = lab_tot + Double.parseDouble(income_arraylist1.get(i)[2]);

																if ((tot_row / tot_user_income) * 100 < 50) {
																	contribution = "danger";
																} else if ((tot_row / tot_user_income) * 100 > 50 && (tot_row / tot_user_income) * 100 < 75) {
																	contribution = "warning";
																} else {
																	contribution = "success";
																}
																per = (tot_row / tot_user_income) * 100;
												%>
												<tr>
													<td><%=i + 1%></td>
													<td><%=income_arraylist1.get(i)[0]%></td>
													<td>
														<div class="progress">
															<div class="progress-bar bg-gradient-<%=contribution%>"
																role="progressbar" style="width: <%=per%>%"
																aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
														</div>
													</td>
													<td align="left"><%=df.format(per)%> %</td>
													<td align="right"><%=df.format(Double.parseDouble(income_arraylist1.get(i)[1]))%></td>
													<td align="right"><%=df.format(Double.parseDouble(income_arraylist1.get(i)[3]))%></td>
													<td align="right"><%=df.format(Double.parseDouble(income_arraylist1.get(i)[2]))%></td>
													<td align="right"><%=df.format(tot_row)%></td>
												</tr>
												<%
													}
												%>
												<tr>
													<td align="right" colspan="4">Total</td>
													<td align="right"><%=df.format(ph_tot)%></td>
													<td align="right"><%=df.format(sna_tot)%></td>
													<td align="right"><%=df.format(lab_tot)%></td>
													<td align="right"><%=df.format(mp_tot + ph_tot + sna_tot + lab_tot)%></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
					<%
						}
					%>

					<%
						if (!select_type2.equals("Revenue")) {
					%>
					<div class="row">
						<div class="col-md-12 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<div class="table-responsive">
										<div id="containerBar2"
											style="height: 520px; margin: 0 auto; position: relative;"></div>
										<div id="sliders2" style="display: none;">
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
					<%
						}
					%>

					<%
						if (!select_type2.equals("Revenue")) {
					%>
					<div class="row">
						<div class="col-md-12 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<h5 class="card-title" align="center">
										User Transactions Contribution (Between
										<%=date_from%>
										and
										<%=date_to%>)
									</h5>

									<div class="table-responsive">
										<table class="table" border="0">
											<thead>
												<tr>
													<th>#</th>
													<th>Name</th>
													<th>Overall Transactions Contribution</th>
													<th></th>
													<th align="right" style="text-align: right;">Pharmacy</th>
													<th align="right" style="text-align: right;">Service</th>
													<th align="right" style="text-align: right;">Lab</th>
													<th align="right" style="text-align: right;">Total</th>
												</tr>
											</thead>
											<tbody>
												<%
													double tot_user_count = 0;

															for (int i = 0; i < count_arraylist1.size(); i++) {
																tot_user_count = tot_user_count + Double.parseDouble(count_arraylist1.get(i)[1])
																		+ Double.parseDouble(count_arraylist1.get(i)[2])
																		+ Double.parseDouble(count_arraylist1.get(i)[3]);
															}

															double tot_row = 0, mp_tot = 0, ph_tot = 0, sna_tot = 0, lab_tot = 0, per = 0;
															String contribution = "";
															for (int i = 0; i < count_arraylist1.size(); i++) {
																per = 0;
																contribution = "";
																tot_row = Double.parseDouble(count_arraylist1.get(i)[1])
																		+ Double.parseDouble(count_arraylist1.get(i)[2])
																		+ Double.parseDouble(count_arraylist1.get(i)[3]);

																ph_tot = ph_tot + Double.parseDouble(count_arraylist1.get(i)[1]);
																sna_tot = sna_tot + Double.parseDouble(count_arraylist1.get(i)[3]);
																lab_tot = lab_tot + Double.parseDouble(count_arraylist1.get(i)[2]);

																if ((tot_row / tot_user_count) * 100 < 50) {
																	contribution = "danger";
																} else if ((tot_row / tot_user_count) * 100 > 50 && (tot_row / tot_user_count) * 100 < 75) {
																	contribution = "warning";
																} else {
																	contribution = "success";
																}
																per = (tot_row / tot_user_count) * 100;
												%>
												<tr>
													<td><%=i + 1%></td>
													<td><%=count_arraylist1.get(i)[0]%></td>
													<td>
														<div class="progress">
															<div class="progress-bar bg-gradient-<%=contribution%>"
																role="progressbar" style="width: <%=per%>%"
																aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
														</div>
													</td>
													<td align="left"><%=df.format(per)%> %</td>
													<td align="right"><%=df.format(Double.parseDouble(count_arraylist1.get(i)[1]))%></td>
													<td align="right"><%=df.format(Double.parseDouble(count_arraylist1.get(i)[3]))%></td>
													<td align="right"><%=df.format(Double.parseDouble(count_arraylist1.get(i)[2]))%></td>
													<td align="right"><%=df.format(tot_row)%></td>
												</tr>
												<%
													}
												%>
												<tr>
													<td align="right" colspan="4">Total</td>
													<td align="right"><%=df.format(ph_tot)%></td>
													<td align="right"><%=df.format(sna_tot)%></td>
													<td align="right"><%=df.format(lab_tot)%></td>
													<td align="right"><%=df.format(mp_tot + ph_tot + sna_tot + lab_tot)%></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
					<%
						}
					%>

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

