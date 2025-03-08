<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 2:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="ws.RESTfulJerseyClient"%>
<%@page import="db.DatabaseConnection"%>
<%@page import="com.query.Query"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	session.setAttribute("userName", "Admin");
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

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	String[] mc = {"202", "205", "201", "203", "202"};
	String[] hos_code = {"H260", "H304", "H261", "H262", "H260"};
	//session.setAttribute("mc", "202");

	String[] mcString = {"Battaramulla", "Jaela", "Kiribathgoda", "Panadura", "Rajagiriya"};

	double[] target = new double[5], revenue = new double[5], head_count = new double[5],
	tag_head_count = new double[5];
	double[] target_per = new double[5];

	double[] tag_head_count_per = new double[5];

	String date_from = "";
	String date_to = "";

	DecimalFormat df = new DecimalFormat("###,###,###");
	DecimalFormat df1 = new DecimalFormat("##########");
	String[] color1 = new String[5], color2 = new String[5];

	double tot_revenue = 0, tot_head_count = 0;

	String access_token = "";
	access_token = RESTfulJerseyClient.getAccessToken();

	for (int i = 0; i < 5; i++) {
		DatabaseConnection conn = new DatabaseConnection();
		try {
	conn.ConnectToDataBase(Integer.parseInt(mc[i]));

	if (i == 0) {
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
	}
	
	

	double[] channel_amt_count_arr = new double[2];

	if (i != 4) {
		channel_amt_count_arr = Query.ChannelRevenueCountAll(Integer.parseInt(mc[i]), "TXN",
		access_token, date_from, date_to, select_type1);
	}

	if (i == 4) {				
		target[i] = Query.getAllTargetAmountCCUnit(date_from, date_to, conn, "U00109");
		revenue[i] = Query.getRevenueAllCCUnit(date_from, date_to, select_type1, conn, "U00109");
		//revenue[i] = Query.getRevenueAllCC(date_from, date_to, conn);
		tag_head_count[i] = Query.getAllTargetCountCCUnit(date_from, date_to, conn, "U00109");
		//head_count[i] = Query.getCountAllCC(date_from, date_to, conn);
		head_count[i] = Query.getCountAllCCUnit(date_from, date_to, select_type1, conn, "U00109");
	} else {
		target[i] = Query.getAllTargetAmount2(date_from, date_to, select_type1, conn);
		tag_head_count[i] = Query.getAllTargetCount(date_from, date_to, select_type1, conn);
		
		if(mc[i].equals("202")){
			revenue[i] = Query.getRevenueAllWC(date_from, date_to, select_type1, conn,
					Integer.parseInt(mc[i]), access_token) + channel_amt_count_arr[0] - 
					Query.PharmachyRevenueCCUnit(date_from, date_to, select_type1, "All", conn, "PH00000009");
			
			head_count[i] = Query.getCountAllWC(date_from, date_to, select_type1, conn,
					Integer.parseInt(mc[i]), access_token) + channel_amt_count_arr[1] - Query.PharmachyCountCC(date_from, date_to, select_type1, "All", conn, "PH00000009");
		} else {
			revenue[i] = Query.getRevenueAllWC(date_from, date_to, select_type1, conn,
					Integer.parseInt(mc[i]), access_token) + channel_amt_count_arr[0];
			
			head_count[i] = Query.getCountAllWC(date_from, date_to, select_type1, conn,
					Integer.parseInt(mc[i]), access_token) + channel_amt_count_arr[1];
		}
	}

	tot_revenue = tot_revenue + revenue[i];
	tot_head_count = tot_head_count + head_count[i];

	conn.CloseDataBaseConnection();
		} catch (Exception e) {
	conn.CloseDataBaseConnection();
	System.out.println(e);
		}

		if (target[i] > 0) {
	target_per[i] = revenue[i] * 100 / target[i];
		}

		if (target[i] < revenue[i]) {
	color1[i] = "#64E572";
		} else {
	color1[i] = "#F16868";
		}

		if (tag_head_count[i] < head_count[i]) {
	color2[i] = "#64E572";
		} else {
	color2[i] = "#F16868";
		}

		if (tag_head_count[i] > 0) {
	tag_head_count_per[i] = head_count[i] * 100 / tag_head_count[i];
		}

	}	
	
	String[] mc_cc = {"202", "205", "201", "203", "206"};
	double all_cc_revenue = 0, all_cc_count = 0, all_cc_target = 0, all_cc_target_head_count = 0;
	
	for (int i = 0; i < 5; i++) {
		DatabaseConnection conn = new DatabaseConnection();
		try {
			conn.ConnectToDataBase(Integer.parseInt(mc_cc[i]));
			
			if(i == 0) {
				all_cc_revenue = all_cc_revenue + Query.getRevenueAllCC(date_from, date_to, conn, select_type1) - Query.getRevenueAllCCUnit(date_from, date_to, select_type1, conn, "U00109");
				all_cc_count = all_cc_count + Query.getCountAllCC(date_from, date_to, conn, select_type1) - Query.getCountAllCCUnit(date_from, date_to, select_type1, conn, "U00109");
				
				//System.out.println("all_cc_revenue" + i + "= " + all_cc_revenue);
				//System.out.println("all_cc_count" + i + "= " + all_cc_count);
				
				all_cc_target = all_cc_target + Query.getAllTargetAmountCC(date_from, date_to, conn) - Query.getAllTargetAmountCCUnit(date_from, date_to, conn, "U00109");
				all_cc_target_head_count = all_cc_target_head_count + Query.getAllTargetCountCC(date_from, date_to, conn) - Query.getAllTargetCountCCUnit(date_from, date_to, conn, "U00109");
			} else {
				all_cc_revenue = all_cc_revenue + Query.getRevenueAllCC(date_from, date_to, conn, select_type1);
				all_cc_count = all_cc_count + Query.getCountAllCC(date_from, date_to, conn, select_type1);
				
				//System.out.println("all_cc_revenue" + i + "= " + all_cc_revenue);
				//System.out.println("all_cc_count" + i + "= " + all_cc_count);
				
				all_cc_target = all_cc_target + Query.getAllTargetAmountCC(date_from, date_to, conn);
				all_cc_target_head_count = all_cc_target_head_count + Query.getAllTargetCountCC(date_from, date_to, conn);
			}
			
			conn.CloseDataBaseConnection();
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			System.out.println(e);
		}
	}
	
	//all_cc_target = all_cc_target - target[4];
	//all_cc_target_head_count = all_cc_target_head_count - tag_head_count[4];
	

	double all_cc_target_per = 0;
	String all_cc_color1 = "";
	double all_cc_target_head_per = 0;
	String all_cc_color2 = "";
	
	if (all_cc_target > 0) {
		all_cc_target_per = all_cc_revenue * 100 / all_cc_target;
	}

	if (all_cc_target < all_cc_revenue) {
		all_cc_color1 = "#64E572";
	} else {
		all_cc_color1 = "#F16868";
	}

	if (all_cc_target_head_count < all_cc_count) {
		all_cc_color2 = "#64E572";
	} else {
		all_cc_color2 = "#F16868";
	}

	if (all_cc_target_head_count > 0) {
		all_cc_target_head_per = all_cc_count * 100 / all_cc_target_head_count;
	}
	//System.out.println("all_cc_revenue = " + all_cc_revenue);
	//System.out.println("all_cc_count = " + all_cc_count);

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

<script src="node_modules/popper.js/dist/umd/popper.min.js"></script>

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
containerBar1, containerBar2 {
	min-width: 310px;
	max-width: 800px;
	margin: 0 auto;
}

containerBar1, containerBar2 {
	height: 500px;
}
</style>
<style>
div.rotateDiv {
	-ms-transform: rotate(270deg); /* IE 9 */
	-webkit-transform: rotate(270deg); /* Safari 3-8 */
	transform: rotate(270deg);
}
</style>

<script type="text/javascript">

	$(function() {


		//Bar chart - Target vs Achievment
		var myChart1 = Highcharts
				.chart(
						'containerBar1',
						{
							chart : {
								marginTop: 130,
								type : 'column',
								options3d : {
									enabled : true,
									alpha : 12,
									beta : 0,
									depth : 100,
									viewDistance : 25
								}
							},
							colors: ['rgb(124, 181, 236)', null],
							title : {
								text : '<%=select_type1%> Target vs Revenue'
							},
							subtitle : {
								text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
							},
							xAxis : {
								//gridLineColor : 'white',
								categories : [ '<%=mcString[0]%>', '<%=mcString[1]%>',
										'<%=mcString[2]%>',
										'<%=mcString[3]%>', '<%=mcString[4]%>', 'Collecting Center' ]
							},
							yAxis : {
								//gridLineColor : 'white',
								title : {
									text : 'Amount (Rs.)'
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
						                credits: {
						                    enabled: false
						                }
						            }
						        }]
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
										format : '<span align="center" style="font-size:16px; color:#f96868; text-align: middle">{point.per:.0f} {point.symbol}</span><br/><span>Rs. {point.y:,.0f}</span>'
									}
								},
								column : {
									depth : 100
								}
							},
							/* legend : {
								layout : 'vertical',
								align : 'right',
								verticalAlign : 'top',
								x : -40,
								y : 80,
								floating : true,
								borderWidth : 1,
								backgroundColor : ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
								shadow : true
							}, */
							"series" : [ {
								"name" : 'Target',
					            //"type" : 'scatter',
								"data" : [ {
									"y" :
<%=df1.format(target[0])%>
	,
									"per" : null,
									"symbol" : null
	}, {
									"y" :
<%=df1.format(target[1])%>
	,
									"per" : null,
									"symbol" : null
	}, {
									"y" :
<%=df1.format(target[2])%>
	,
									"per" : null,
									"symbol" : null
	}, {
		"y" :
			<%=df1.format(target[3])%>
				,
												"per" : null,
												"symbol" : null
				}, {
					"y" :
						<%=df1.format(target[4])%>
							,
															"per" : null,
															"symbol" : null
							}, {
								"y" :
									<%=df1.format(all_cc_target)%>
										,
																		"per" : null,
																		"symbol" : null
										} ]
							}, {
								"name" : 'Revenue',
								"data" : [ {
									"y" : <%=df1.format(revenue[0])%>,
									"color" : "<%=color1[0]%>",
<%if (target[0] != 0) {%>
"symbol" : "%",
"per" : <%=target_per[0]%>
<%} else {%>
"symbol" : null,
"per" : null
<%}%>
	}, {
									"y" :
<%=df1.format(revenue[1])%>,
"color" : "<%=color1[1]%>",
<%if (target[1] != 0) {%>
"symbol" : "%",
"per" : <%=target_per[1]%>
<%} else {%>
"symbol" : null,
"per" : null
<%}%>
	}, {
									"y" :
<%=df1.format(revenue[2])%>,
"color" : "<%=color1[2]%>",
<%if (target[2] != 0) {%>
"symbol" : "%",
"per" : <%=target_per[2]%>
<%} else {%>
"symbol" : null,
"per" : null
<%}%>
	}, {
		"y" :
			<%=df1.format(revenue[3])%>,
			"color" : "<%=color1[3]%>",
			<%if (target[3] != 0) {%>
			"symbol" : "%",
			"per" : <%=target_per[3]%>
			<%} else {%>
			"symbol" : null,
			"per" : null
			<%}%>
				}, {
					"y" :
						<%=df1.format(revenue[4])%>,
						"color" : "<%=color1[4]%>",
						<%if (target[4] != 0) {%>
						"symbol" : "%",
						"per" : <%=target_per[4]%>
						<%} else {%>
						"symbol" : null,
						"per" : null
						<%}%>
							}, {
								"y" :
									<%=df1.format(all_cc_revenue)%>,
									"color" : "<%=all_cc_color1%>",
									<%if (all_cc_target != 0) {%>
									"symbol" : "%",
									"per" : <%=all_cc_target_per%>
									<%} else {%>
									"symbol" : null,
									"per" : null
									<%}%>
										} ]
							} ]
						});
		
		function showValues1() {
		    $('#alpha-value1').html(myChart1.options.chart.options3d.alpha);
		    $('#beta-value1').html(myChart1.options.chart.options3d.beta);
		    $('#depth-value1').html(myChart1.options.chart.options3d.depth);
		}

		// Activate the sliders
		$('#sliders1 input').on('input change', function () {
			myChart1.options.chart.options3d[this.id] = parseFloat(this.value);
		    showValues1();
		    myChart1.redraw(false);
		});

		showValues1();

		//Bar chart - Target vs Achievment
		var myChart2 = Highcharts
				.chart(
						'containerBar2',
						{
							chart : {
								marginTop: 95,
								type : 'column',
								options3d : {
									enabled : true,
									alpha : 12,
									beta : 0,
									depth : 100,
									viewDistance : 25
								}
							},
							colors: ['rgb(124, 181, 236)', null],
							title : {
								text : '<%=select_type1%> Target vs Achived Head Count'
							},
							subtitle : {
								text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
							},
							xAxis : {
								//gridLineColor : 'white',
								categories : [ '<%=mcString[0]%>', '<%=mcString[1]%>',
									'<%=mcString[2]%>',
									'<%=mcString[3]%>', '<%=mcString[4]%>', 'Collecting Center' ]
							},
							yAxis : {
								//gridLineColor : 'white',
								title : {
									text : 'Head Count'
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
						                credits: {
						                    enabled: false
						                }
						            }
						        }]
						    },
							plotOptions : {
								series : {
									borderWidth : 0,
									dataLabels : {
										allowOverlap : true,
										enabled : true,
										rotation: 270,
										x: 0,
						                y: -40,
										format : '<span align="center" style="font-size:20px; color:#f96868; text-align: middle">{point.per:.0f} {point.symbol}</span><br/><span style="font-size:12px">{point.y:,.0f}</span>'
									}
								},
								column : {
									depth : 100
								}
							},
							/* legend : {
								layout : 'vertical',
								align : 'right',
								verticalAlign : 'top',
								x : -40,
								y : 80,
								floating : true,
								borderWidth : 1,
								backgroundColor : ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
								shadow : true
							}, */
							"series" : [ {
								"name" : 'Target',
					            //"type" : 'scatter',
								"data" : [ {
									"y" :
<%=tag_head_count[0]%>
	,
									"per" : null,
									"symbol" : null
	}, {
									"y" :
<%=tag_head_count[1]%>
	,
									"per" : null,
									"symbol" : null
	}, {
									"y" :
<%=tag_head_count[2]%>
	,
									"per" : null,
									"symbol" : null
	}, {
		"y" :
			<%=tag_head_count[3]%>
				,
												"per" : null,
												"symbol" : null
				}, {
					"y" :
						<%=tag_head_count[4]%>
							,
															"per" : null,
															"symbol" : null
							}, {
								"y" :
									<%=all_cc_target_head_count%>
										,
																		"per" : null,
																		"symbol" : null
										} ]
							}, {
								"name" : 'Head Count',
								"data" : [ {
									"y" : <%=head_count[0]%>,
									"color" : "<%=color2[0]%>",
									<%if (tag_head_count[0] != 0) {%>
									"symbol" : "%",
									"per" : <%=tag_head_count_per[0]%>
									<%} else {%>
									"symbol" : null,
									"per" : null
									<%}%>
	}, {
									"y" :
<%=head_count[1]%>,
"color" : "<%=color2[1]%>",
<%if (tag_head_count[1] != 0) {%>
"symbol" : "%",
"per" : <%=tag_head_count_per[1]%>
<%} else {%>
"symbol" : null,
"per" : null
<%}%>
	}, {
									"y" :
<%=head_count[2]%>,
"color" : "<%=color2[2]%>",
<%if (tag_head_count[2] != 0) {%>
"symbol" : "%",
"per" : <%=tag_head_count_per[2]%>
<%} else {%>
"symbol" : null,
"per" : null
<%}%>
	}, {
		"y" :
			<%=head_count[3]%>,
			"color" : "<%=color2[3]%>",
			<%if (tag_head_count[3] != 0) {%>
			"symbol" : "%",
			"per" : <%=tag_head_count_per[3]%>
			<%} else {%>
			"symbol" : null,
			"per" : null
			<%}%>
				}, {
					"y" :
						<%=head_count[4]%>,
						"color" : "<%=color2[4]%>",
						<%if (tag_head_count[4] != 0) {%>
						"symbol" : "%",
						"per" : <%=tag_head_count_per[4]%>
						<%} else {%>
						"symbol" : null,
						"per" : null
						<%}%>
							}, {
								"y" :
									<%=(all_cc_count)%>,
									"color" : "<%=all_cc_color2%>",
									<%if (all_cc_target_head_count != 0) {%>
									"symbol" : "%",
									"per" : <%=all_cc_target_head_per%>
									<%} else {%>
									"symbol" : null,
									"per" : null
									<%}%>
										} ]
							} ]
						});
		
		function showValues2() {
		    $('#alpha-value2').html(myChart2.options.chart.options3d.alpha);
		    $('#beta-value2').html(myChart2.options.chart.options3d.beta);
		    $('#depth-value2').html(myChart2.options.chart.options3d.depth);
		}

		// Activate the sliders
		$('#sliders2 input').on('input change', function () {
			myChart2.options.chart.options3d[this.id] = parseFloat(this.value);
		    showValues2();
		    myChart2.redraw(false);
		});

		showValues2();
		
		// Pie chart - Revenue
		Highcharts
				.chart(
						'pie_revenue',
						{
							chart : {
								plotBackgroundColor : null,
								plotBorderWidth : null,
								type : 'pie',
								options3d : {
									enabled : true,
									alpha : 45,
									beta : 0
								}
							},
							title : {
								text : '<%=select_type1%> Revenue Contribution'
							},
							subtitle : {
								text : '<b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
							},
							tooltip : {
								//pointFormat : '{series.name}: <b>{point.percentage:.1f} %</b>'
								headerFormat : '<span style="font-size:11px">{series.name}</span><br>',
								pointFormat : '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.0f} %</b> of total<br/><span></span><br/>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									depth : 35,
									cursor : 'pointer',
									dataLabels : {
										allowOverlap : true,
										enabled : true,
										format : '<span style="font-size:11px">{point.code}<span><br><span style="font-size:22px; color:#f96868;">{point.y:.0f} %<span><br/><span style="font-size:11px;">Rs. {point.amount:.0f}</span>',
										style : {
											color : (Highcharts.theme && Highcharts.theme.contrastTextColor)
													|| 'black'
										},
										connectorColor : 'silver'
									},
									showInLegend : false
								}
							},
							series : [ {
								name : 'Contribution',
								data : [ {
									code : '<%=mcString[0]%>',
									name : '<%=mcString[0]%>',
									amount : <%=revenue[0]%><%if (tot_revenue > 0) {%>,									
									y : <%=(revenue[0] * 100) / tot_revenue%>
									<%}%>
									}, 
									{
									code : '<%=mcString[1]%>',
									color : '#E7F168',
									name : '<%=mcString[1]%>',
									amount : <%=revenue[1]%><%if (tot_revenue > 0) {%>,
									y : <%=(revenue[1] * 100) / tot_revenue%>	
									<%}%>
									}, 
									{
									code : '<%=mcString[2]%>',
									name : '<%=mcString[2]%>',
									amount : <%=revenue[2]%><%if (tot_revenue > 0) {%>,
									y : <%=(revenue[2] * 100) / tot_revenue%>
									<%}%>
									}, {
										code : '<%=mcString[3]%>',
										name : '<%=mcString[3]%>',
										amount : <%=revenue[3]%><%if (tot_revenue > 0) {%>,
										y : <%=(revenue[3] * 100) / tot_revenue%>
										<%}%>
		}, {
			code : '<%=mcString[4]%>',
			name : '<%=mcString[4]%>',
			amount : <%=revenue[4]%><%if (tot_revenue > 0) {%>,
			y : <%=(revenue[4] * 100) / tot_revenue%>
			<%}%>
}, {
	code : 'Collecting Center',
	name : 'Collecting Center',
	amount : <%=all_cc_revenue%><%if (tot_revenue > 0) {%>,
	y : <%=(all_cc_revenue * 100) / tot_revenue%>
	<%}%>
} ]
							} ]
						});
		
		// Pie chart - Head Count
		Highcharts
				.chart(
						'pie_head_count',
						{
							chart : {
								plotBackgroundColor : null,
								plotBorderWidth : null,
								type : 'pie',
								options3d : {
									enabled : true,
									alpha : 45,
									beta : 0
								}
							},
							title : {
								text : '<%=select_type1%> Head Count Contribution'
							},
							subtitle : {
								text : '<b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
							},
							tooltip : {
								//pointFormat : '{series.name}: <b>{point.percentage:.1f} %</b>'
								headerFormat : '<span style="font-size:11px">{series.name}</span><br>',
								pointFormat : '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.0f} %</b> of total<br/><span></span><br/>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									depth : 35,
									cursor : 'pointer',
									dataLabels : {
										allowOverlap : true,
										enabled : true,
										format : '<span style="font-size:11px">{point.code}<span><br><span style="font-size:22px; color:#f96868;">{point.y:.0f} %<span><br/><span style="font-size:11px;">{point.amount:.0f}</span>',
										style : {
											color : (Highcharts.theme && Highcharts.theme.contrastTextColor)
													|| 'black'
										},
										connectorColor : 'silver'
									},
									showInLegend : false
								}
							},
							series : [ {
								name : 'Contribution',
								data : [ {
									code : '<%=mcString[0]%>',
									name : '<%=mcString[0]%>',
									amount : <%=head_count[0]%><%if (tot_head_count > 0) {%>,									
									y : <%=(head_count[0] * 100) / tot_head_count%>
									<%}%>
									}, 
									{
									code : '<%=mcString[1]%>',
									color : '#E7F168',
									name : '<%=mcString[1]%>',
									amount : <%=head_count[1]%><%if (tot_head_count > 0) {%>,
									y : <%=(head_count[1] * 100) / tot_head_count%>	
									<%}%>
									}, 
									{
									code : '<%=mcString[2]%>',
									name : '<%=mcString[2]%>',
									amount : <%=head_count[2]%><%if (tot_head_count > 0) {%>,
									y : <%=(head_count[2] * 100) / tot_head_count%>
									<%}%>
									}, {
										code : '<%=mcString[3]%>',
										name : '<%=mcString[3]%>',
										amount : <%=head_count[3]%><%if (tot_head_count > 0) {%>,
										y : <%=(head_count[3] * 100) / tot_head_count%>
										<%}%>
		}, {
			code : '<%=mcString[4]%>',
			name : '<%=mcString[4]%>',
			amount : <%=head_count[4]%><%if (tot_head_count > 0) {%>,
			y : <%=(head_count[4] * 100) / tot_head_count%>
			<%}%>
}, {
	code : 'Collecting Center',
	name : 'Collecting Center',
	amount : <%=(all_cc_count-head_count[4])%><%if (tot_head_count > 0) {%>,
	y : <%=((all_cc_count-head_count[4]) * 100) / tot_head_count%>
	<%}%>
} ]
							} ]
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
		<!-- partial:partials/_navbar.html -->
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
				<a class="navbar-brand brand-logo" href="dashboardsuperadmin.jsp"><img
					src="images/logo-mini.svg" alt="logo"
					style="margin-left: -40px; margin-right: 0px;" /><font
					class="font_3d" size="4px;"><b>&nbsp;<%=(String) session.getAttribute("title")%></b></font></a>
				<a class="navbar-brand brand-logo-mini"
					href="dashboardsuperadmin.jsp"><img src="images/logo-mini.svg"
					alt="logo" /></a>
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
					<li class="nav-item dropdown">
						<!-- <a
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
						</div>
					</li>
					<li class="nav-item dropdown">
						<!-- <a
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
						</div>
					</li>
					<li class="nav-item dropdown"><a
						class="nav-link dropdown-toggle nav-profile" id="profileDropdown"
						href="#" data-toggle="dropdown" aria-expanded="false"> <img
							src="images/faces-clipart/pic-1.png" alt="image"> <span
							class="d-none d-lg-inline"><%=(String) session.getAttribute("userName")%></span>
					</a>

						<div class="dropdown-menu navbar-dropdown w-100"
							aria-labelledby="profileDropdown">
							<!-- <a class="dropdown-item" href="target.jsp"> <i
								class="mdi mdi-cached mr-2 text-success"></i> Target
							</a> -->

							<div class="dropdown-divider"></div>
							<!-- <a class="dropdown-item" href="Logout.jsp"> <i
								class="mdi mdi-logout mr-2 text-primary"></i> Signout
							</a> -->
						</div></li>
					<li class="nav-item nav-logout d-none d-lg-block"><a
						class="nav-link" href=""> <i class="mdi mdi-power"></i>
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
				<nav class="sidebar sidebar-offcanvas" id="sidebar">
					<jsp:include page="tabssuperadmin.jsp"></jsp:include>
				</nav>
				<%
					double tot_sale = 0;
				%>
				<!-- partial -->
				<div class="content-wrapper">
					<%
						///////////////////////// Modal - Start
					%>
					<div class="row" style="margin-left: 0px;">
						<%
							for (int i = 0; i < mcString.length; i++) {
						%>
						<a class="btn btn-outline-primary" data-toggle="collapse"
							href="#multiCollapseExample<%=i + 1%>" role="button"
							aria-expanded="false"
							aria-controls="multiCollapseExample<%=i + 1%>"><%=mcString[i]%></a>&nbsp;
						<%
							}
						%>
						<a class="btn btn-outline-primary" data-toggle="collapse"
							href="#multiCollapseExample7" role="button"
							aria-expanded="false"
							aria-controls="multiCollapseExample7">Collecting Center</a>
						&nbsp;&nbsp;&nbsp;
						<button class="btn btn-outline-warning" type="button"
							style="cursor: pointer;" data-toggle="collapse"
							data-target=".multi-collapse" aria-expanded="false"
							aria-controls="multiCollapseExample1 multiCollapseExample2 multiCollapseExample3 multiCollapseExample4 multiCollapseExample5 multiCollapseExample6 multiCollapseExample7">Toggle
							All Centers</button>

						&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
						<div>
							<jsp:include page="filter_date.jsp"><jsp:param
									value="dashboardsuperadmin.jsp" name="action" /><jsp:param
									value="<%=date_from%>" name="date_from" /><jsp:param
									value="<%=date_to%>" name="date_to" /><jsp:param value="no"
									name="sub" /></jsp:include></div>
					</div>
					<%
						///////////////////////// Modal - End
					%>
					<!-- <div><h1 class="display-4">Here use dates</h1></div> -->
					<div>
						<%
							for (int i = 0; i < mcString.length; i++) {
						%>
						<div class="col">
							<div class="collapse multi-collapse"
								id="multiCollapseExample<%=i + 1%>">
								<div class="row">
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-revenue text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h5 class="font-weight-normal mb-1">
													<b><%=mcString[i]%></b>
													<%=select_type1%>
													Revenue
												</h5>
												<h3 class="font-weight-normal mb-1">
													<font size="2">Rs.</font>
													<%=df.format(revenue[i])%></h3>
												<p class="card-text">
													Head Count <font size="4"><%=df.format(head_count[i])%></font>
												</p>
											</div>
										</div>
									</div>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-target text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h5 class="font-weight-normal mb-1">
													<b><%=mcString[i]%></b>
													<%=select_type1%>
													Target
												</h5>
												<h3 class="font-weight-normal mb-1">
													<font size="2">Rs.</font>
													<%=df.format(target[i])%></h3>
												<p class="card-text">
													Target Head Count <font size="4"><%=df.format(tag_head_count[i])%></font>
												</p>
											</div>
										</div>
									</div>
									<%
										if (revenue[i] >= target[i]) {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-success text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b><%=mcString[i]%></b> Success Revenue
												</h6>
												<h3 class="font-weight-normal mb-1">
													<font size="3">Rs.</font>
													<%=df.format(revenue[i] - target[i])%>
													<i class="fa fa-long-arrow-up"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(target_per[i])%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-danger text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b><%=mcString[i]%></b> Unsuccess Revenue
												</h6>
												<h3 class="font-weight-normal mb-1">
													<font size="2">Rs.</font>
													<%=df.format(revenue[i] - target[i])%>
													<i class="fa fa-long-arrow-down"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(target_per[i])%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										}
									%>
									<%
										if (head_count[i] >= tag_head_count[i]) {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-success text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b><%=mcString[i]%></b> Success Head Count
												</h6>

												<h3 class="font-weight-normal mb-1"><%=df.format(head_count[i] - tag_head_count[i])%>
													<i class="fa fa-long-arrow-up"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(tag_head_count_per[i])%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-danger text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b><%=mcString[i]%></b> Unsuccess Head Count
												</h6>
												<h3 class="font-weight-normal mb-1"><%=df.format(head_count[i] - tag_head_count[i])%>
													<i class="fa fa-long-arrow-down"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(tag_head_count_per[i])%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										}
									%>
								</div>
							</div>
						</div>
						<%
							}
						%>
						
						
						<div class="col">
							<div class="collapse multi-collapse"
								id="multiCollapseExample7">
								<div class="row">
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-revenue text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h5 class="font-weight-normal mb-1">
													<b>Collecting Center</b>
													<%=select_type1%>
													Revenue
												</h5>
												<h3 class="font-weight-normal mb-1">
													<font size="2">Rs.</font>
													<%=df.format(all_cc_revenue)%></h3>
												<p class="card-text">
													Head Count <font size="4"><%=df.format(all_cc_count)%></font>
												</p>
											</div>
										</div>
									</div>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-target text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h5 class="font-weight-normal mb-1">
													<b>Collecting Center</b>
													<%=select_type1%>
													Target
												</h5>
												<h3 class="font-weight-normal mb-1">
													<font size="2">Rs.</font>
													<%=df.format(all_cc_target)%></h3>
												<p class="card-text">
													Target Head Count <font size="4"><%=df.format(all_cc_target_head_count)%></font>
												</p>
											</div>
										</div>
									</div>
									<%
										if (all_cc_revenue >= all_cc_target) {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-success text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b>Collecting Center</b> Success Revenue
												</h6>
												<h3 class="font-weight-normal mb-1">
													<font size="3">Rs.</font>
													<%=df.format(all_cc_revenue - all_cc_target)%>
													<i class="fa fa-long-arrow-up"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(all_cc_target_per)%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-danger text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b>Collecting Center</b> Unsuccess Revenue
												</h6>
												<h3 class="font-weight-normal mb-1">
													<font size="2">Rs.</font>
													<%=df.format(all_cc_revenue - all_cc_target)%>
													<i class="fa fa-long-arrow-down"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(all_cc_target_per)%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										}
									%>
									<%
										if (all_cc_count >= all_cc_target_head_count) {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-success text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b>Collecting Center</b> Success Head Count
												</h6>

												<h3 class="font-weight-normal mb-1"><%=df.format(all_cc_count - all_cc_target_head_count)%>
													<i class="fa fa-long-arrow-up"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(all_cc_target_head_per)%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<div class="col-md-3 grid-margin"
										style="margin-bottom: 5px; padding-left: 0px;">
										<div class="card bg-gradient-danger text-white">
											<div class="card-body" style="padding: 0.4rem">
												<h6 class="font-weight-normal mb-1">
													<b>Collecting Center</b> Unsuccess Head Count
												</h6>
												<h3 class="font-weight-normal mb-1"><%=df.format(all_cc_count - all_cc_target_head_count)%>
													<i class="fa fa-long-arrow-down"></i>
												</h3>
												<p class="card-text">
													Percentage : <font size="4"><%=df.format(all_cc_target_head_per)%>
														%</font>
												</p>
											</div>
										</div>
									</div>
									<%
										}
									%>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12 grid-margin">
								<div class="card">
									<div class="card-body">
										<div id="containerBar1" style="width: 100%; height: 500px;"></div>
										<div id="sliders1" style="">
											<table style="display: none;">
												<tr>
													<td>Alpha Angle</td>
													<td><input id="alpha" type="range" min="0" max="45"
														value="15" /> <span id="alpha-value1" class="value"></span></td>
												</tr>
												<tr>
													<td>Beta Angle</td>
													<td><input id="beta" type="range" min="-45" max="45"
														value="15" /> <span id="beta-value1" class="value"></span></td>
												</tr>
												<tr>
													<td>Depth</td>
													<td><input id="depth" type="range" min="20" max="100"
														value="50" /> <span id="depth-value1" class="value"></span></td>
												</tr>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12 grid-margin">
								<div class="card">
									<div class="card-body">
										<div id="containerBar2" style="width: 100%; height: 500px;"></div>
										<div id="sliders2" style="">
											<table style="display: none;">
												<tr>
													<td>Alpha Angle</td>
													<td><input id="alpha" type="range" min="0" max="45"
														value="15" /> <span id="alpha-value2" class="value"></span></td>
												</tr>
												<tr>
													<td>Beta Angle</td>
													<td><input id="beta" type="range" min="-45" max="45"
														value="15" /> <span id="beta-value2" class="value"></span></td>
												</tr>
												<tr>
													<td>Depth</td>
													<td><input id="depth" type="range" min="20" max="100"
														value="50" /> <span id="depth-value2" class="value"></span></td>
												</tr>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12 grid-margin">
								<div class="card">
									<div class="card-body">
										<div id="pie_revenue" style="width: 100%; height: 500px;"></div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12 grid-margin">
								<div class="card">
									<div class="card-body">
										<div id="pie_head_count" style="width: 100%; height: 500px;"></div>
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
											</div>
											<div class="col-6 pl-1">
												
											</div>
										</div>
										<div class="d-flex mt-5 align-items-top">
											

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
														<td class="py-1"><img src="images/faces-clipart/pic-1.png"
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
														<td class="py-1"> Stella Johnson</td>
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
														<td class="py-1"> Marina Michel</td>
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
														<td class="py-1"> John Doe</td>
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