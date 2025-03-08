<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 9/13/2018
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="dao.Utils"%>
<%@page import="ws.RESTfulJerseyClient"%>
<%@page import="ws.DoctorAppointment"%>
<%@page import="db.DatabaseConnection"%>
<%
		if (request.getSession(false) != null && session.getAttribute("u_name") != null) {
	%>
<%@page import="java.util.*"%>
<%@page import="dao.Category"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.query.Query"%>
<%@page import="java.text.DecimalFormat"%>
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

<%
	DecimalFormat df = new DecimalFormat("######.##");
	double ph_target = 0, ph_income = 0, lab_target = 0, lab_income = 0, mp_target = 0, mp_income = 0,
	sna_target = 0, sna_income = 0, channel_target = 0, channel_income = 0;

	String select_type1 = "All";
	if (request.getParameter("select_type1") != null) {
		select_type1 = request.getParameter("select_type1");
	}
	String select_type2 = "REV";
	if (request.getParameter("select_type2") != null) {
		select_type2 = request.getParameter("select_type2");
	}
	String currency1 = "", currency2 = "", suffix = "";
	if(select_type2.equals("REV")){
		currency1 = "Rs.";
		currency2 = "(Rs.)";
		suffix = "";
	}
	int mc = 0;
	if (session.getAttribute("mc") != null) {
		mc = Integer.parseInt((String) session.getAttribute("mc"));
	}

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

		// System.out.println("date_from = " + date_from);
		// System.out.println("date_to = " + date_to);
		// System.out.println("select_type1 = " + select_type1);
		// System.out.println("");

		ph_target = Query.getTargetTransaction("PH", date_from, date_to, select_type1, select_type2, conn);
		lab_target = Query.getTargetTransaction("LAB", date_from, date_to, select_type1, select_type2, conn);
		//mp_target = Query.getTargetTransaction("MP", date_from, date_to, select_type1, select_type2, conn);
		sna_target = Query.getTargetTransaction("SNA", date_from, date_to, select_type1, select_type2, conn);
		channel_target = Query.getTargetTransactionChannel(date_from, date_to, select_type2, conn);

		List<DoctorAppointment> da_al = new ArrayList<DoctorAppointment>();
		String access_token = "";
		if (select_type1.equals("CHANNEL") || select_type1.equals("All")) {
	access_token = RESTfulJerseyClient.getAccessToken();
	if(!access_token.equals("")){
	da_al = RESTfulJerseyClient.getDoctorAppointmentList(mc, "TXN", access_token, date_from, date_to);
	}
		}
		
			if (select_type2.equals("REV")) {
				if (mc == 202) {
					ph_income = Query.PharmachyRevenueAll(date_from, date_to, select_type1, "All", conn) - 
							Query.PharmachyRevenueCCUnit(date_from, date_to, select_type1, "All", conn, "PH00000009");
					lab_income = Query.LabRevenueWC(date_from, date_to, select_type1, conn);
					//mp_income = Query.MediPackRevenueWC(date_from, date_to, select_type1, conn);
					sna_income = Query.ServiceNonAppRevenueWC(date_from, date_to, select_type1, conn);
					for (DoctorAppointment da : da_al) {
						channel_income += da.getTotalAmount();
					}
				} else {
					ph_income = Query.PharmachyRevenueAll(date_from, date_to, select_type1, "All", conn);
					lab_income = Query.LabRevenueWC(date_from, date_to, select_type1, conn);
					//mp_income = Query.MediPackRevenueWC(date_from, date_to, select_type1, conn);
					sna_income = Query.ServiceNonAppRevenueWC(date_from, date_to, select_type1, conn);
					for (DoctorAppointment da : da_al) {
						channel_income += da.getTotalAmount();
					}
				}
			} else if (select_type2.equals("TXN")) {
				if (mc == 202) {
					ph_income = Query.PharmachyCount(date_from, date_to, select_type1, "All", conn) - 
							Query.PharmachyCountCC(date_from, date_to, select_type1, "All", conn, "PH00000009");
					lab_income = Query.LabCountWC(date_from, date_to, select_type1, "All", conn);
					//mp_income = Query.MediPackCountWC(date_from, date_to, select_type1, "All", conn);
					sna_income = Query.ServiceNonAppCountWC(date_from, date_to, select_type1, "All", conn);
					for (DoctorAppointment da : da_al) {
						channel_income += da.getChannelCount();
					}
				} else {
					ph_income = Query.PharmachyCount(date_from, date_to, select_type1, "All", conn);
					lab_income = Query.LabCountWC(date_from, date_to, select_type1, "All", conn);
					//mp_income = Query.MediPackCountWC(date_from, date_to, select_type1, "All", conn);
					sna_income = Query.ServiceNonAppCountWC(date_from, date_to, select_type1, "All", conn);
					for (DoctorAppointment da : da_al) {
						channel_income += da.getChannelCount();
					}
				}
			}

			/* System.out.println("ph_income = " + ph_income);
			System.out.println("lab_income = " + lab_income);
			System.out.println("channel_income = " + channel_income);
			System.out.println("sna_income = " + sna_income); */

			double tot_income = ph_income + lab_income + mp_income + sna_income + channel_income;
			if (tot_income == 0)
				tot_income = 1;
			double tot_target = ph_target + lab_target + mp_target + sna_target + channel_target;
			if (tot_target == 0)
				tot_target = 1;

			double ph_per = 0, lab_per = 0, mp_per = 0, sna_per = 0, channel_per = 0;

			if (ph_target > 0) {
				ph_per = ph_income * 100 / ph_target;
			}
			if (lab_target > 0) {
				lab_per = lab_income * 100 / lab_target;
			}
			if (mp_target > 0) {
				mp_per = mp_income * 100 / mp_target;
			}
			if (sna_target > 0) {
				sna_per = sna_income * 100 / sna_target;
			}
			if (channel_target > 0) {
				channel_per = channel_income * 100 / channel_target;
			}

			ArrayList<Category> arraylist = new ArrayList<Category>();
			arraylist.add(new Category(ph_per, "Pharmacy", ph_target, ph_income));
			//arraylist.add(new Category(mp_per, "Medical Package", mp_target, mp_income));
			arraylist.add(new Category(sna_per, "Service Non Appointment", sna_target, sna_income));
			arraylist.add(new Category(lab_per, "Lab", lab_target, lab_income));
			arraylist.add(new Category(channel_per, "Channel", channel_target, channel_income));

			/* Sorting on percentage property*/
			// System.out.println("percentage Sorting:");
			// System.out.println("\n");
			Collections.sort(arraylist, Category.CatPercentage);

			List<String[]> arraylist1 = new ArrayList<String[]>();

			for (Category str : arraylist) {
				String color = "";
				if (str.getTarget() > str.getIncome()) {
					color = "#F16868";
				} else {
					color = "#64E572";
				}
				String[] arr = { Double.toString(str.getPercentage()), str.getCategoryname(),
						Double.toString(str.getTarget()), Double.toString(str.getIncome()), color };
				arraylist1.add(arr);
			}
			// System.out.println(arraylist1);
			// System.out.println("\n");

			// color red - #F16868
			// color green - #64E572
%>
<script>

	$(function() {

		//Bar chart - Target vs Achievment
		var chart1 = Highcharts
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
								text : '<%=select_type1%> Target Vs Achievement - Cash & Credit - Without Collecting Center'
							},
							subtitle : {
								text : 'Between <b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
							},
							xAxis : {
								//gridLineColor : 'white',
								categories : [ '<%=arraylist1.get(0)[1]%>', '<%=arraylist1.get(1)[1]%>', '<%=arraylist1.get(2)[1]%>', '<%=arraylist1.get(3)[1]%>'],
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
								valueSuffix : ' <%=suffix%>'
							},
							plotOptions : {
								column : {
									depth : 70,
									dataLabels : {
										allowOverlap : true,
										enabled : true,
										rotation: 270,
										x: 0,
						                y: -60,
										format : '<font style="font-size:22px; color:#f96868;">{point.per:.0f} {point.symbol}</font><br/><span style="font-size:12px"><%=currency1%> {point.y:,.0f}</span>'
									}
								}
							},
							"series" : [ {
								"name" : "Target",
								"data" : [{
									"symbol" : null,
									"y" :
<%=arraylist1.get(0)[2]%>
	,
									"per" : null
								}, {
									"symbol" : null,
									"y" :
<%=arraylist1.get(1)[2]%>
	,
									"per" : null
								}, {
									"symbol" : null,
									"y" :
<%=arraylist1.get(2)[2]%>
	,
									"per" : null
								}, {
									"symbol" : null,
									"y" :
<%=arraylist1.get(3)[2]%>
	,
									"per" : null
								} ]
							}, {
								"name" : "Achievement",
								"data" : [ {
									"symbol" : "%",
									"color" : "<%=arraylist1.get(0)[4]%>",
									"y" :
<%=arraylist1.get(0)[3]%>
	,
									"per" :
<%=arraylist1.get(0)[0]%>
	}, {
									"symbol" : "%",
									"color" : "<%=arraylist1.get(1)[4]%>",
									"y" :
<%=arraylist1.get(1)[3]%>
	,
									"per" :
<%=arraylist1.get(1)[0]%>
	}, {
		"symbol" : "%",
		"color" : "<%=arraylist1.get(2)[4]%>",
		"y" :
<%=arraylist1.get(2)[3]%>
,
		"per" :
<%=arraylist1.get(2)[0]%>
}, {
	"symbol" : "%",
	"color" : "<%=arraylist1.get(3)[4]%>",
	"y" :
<%=arraylist1.get(3)[3]%>
,
	"per" :
<%=arraylist1.get(3)[0]%>
} ]
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
		/////////////////////////////////////////////////

		////////////////////////////////////////////////

		//Pie chart - Achievement
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
								text : '<%=select_type1%>  Achievement & Breakdown - Without Collecting Center'
							},
							subtitle : {
								text : '<b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b> | Click the slices to view breakdown.'
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
							plotOptions : {
								pie : {
									showInLegend : false,
									depth : 35
								},
								series : {
									dataLabels : {
										allowOverlap : true,
										enabled : true,
										format : '<span style="font-size:11px;">{point.name}</span><br/><span style="font-size:18px; color:#f96868;">{point.y:,.2f} %</span><br/><span style="font-size:11px"><%=currency1%> {point.amount:,.0f}</span>'
									}
								}
							},

							tooltip : {
								headerFormat : '<span style="font-size:11px">{series.name}</span><br>',
								pointFormat : '<span style="color:{point.color}"><b>{point.name}</b></span><br/>{point.amount:.0f}<br/><b>{point.y:,.2f} %</b> of total'
							},

							"series" : [ {
								"name" : "Percentage",
								"colorByPoint" : true,
								"data" : [
										{
											"code" : "SNA",
											"name" : "Service Non Appointment",
											"amount" :
<%=sna_income%>
	,
	<%if(tot_income > 0){%>"y" :
<%=Math.round((sna_income * 100) / tot_income)%>
	,<%}%>
											"drilldown" : "Service Non Appointment"
										},
										{
											"color" : "#E7F168",
											"code" : "PH",
											"name" : "Pharmacy",
											"amount" :
<%=ph_income%>
	,
	<%if(tot_income > 0){%>"y" :
<%=Math.round((ph_income * 100) / tot_income)%>
	,<%}%>
											"drilldown" : "Pharmacy"
										},
										{
											"code" : "LAB",
											"name" : "Lab",
											"amount" :
<%=lab_income%>
	,
	<%if(tot_income > 0){%>"y" :
<%=Math.round((lab_income * 100) / tot_income)%>
	,<%}%>
											"drilldown" : "Lab"
										},
										{
											"code" : "CHANNEL",
											"name" : "Channel",
											"amount" :
<%=channel_income%>
	,
	<%if(tot_income > 0){%>"y" :
<%=Math.round((channel_income * 100) / tot_income)%>
	,<%}%>
											"drilldown" : "Channel"
										} ]
							} ],
							"drilldown" : {
								"series" : [
										{
											"code" : "Service Non Appointment",
											"name" : "Service Non Appointment",
											"id" : "Service Non Appointment",
											"data" : [
												<%
												List<String[]> alSNA = null;
												if(select_type2.equals("REV")){
													alSNA = Query.ServiceNonAppBreakdownWC(date_from, date_to, select_type1, "ASC", "", conn);
												}else if(select_type2.equals("TXN")){
													alSNA = Query.ServiceNonAppCountBreakdownWC(date_from, date_to, select_type1, "ASC", "", conn);
												}
										if(alSNA.size()>0){
			for (int i = 0; i < alSNA.size(); i++) {
				if(alSNA.get(i)[0]!=null){
			%> 
													{
														"name" : "<%=alSNA.get(i)[0]%>",
														<%if (i == 1) {%>
														"color" : "#E7F168",
														<%}%>
														<%if(sna_income > 0){%>"y" :
<%=df.format(Double.parseDouble(alSNA.get(i)[1]) * 100 / sna_income)%>
	,<%}%>
														"amount" : <%=Double.parseDouble(alSNA.get(i)[1])%>
													}
													<%if (i != 9) {%>
													,
													<%}%>
													<%
				if(i==9) break;									
				}}}%> ]
										},
										{
											"code" : "Pharmacy",
											"name" : "Pharmacy",
											"id" : "Pharmacy",
											"data" : [
												<%
												List<String[]> alP = null;
												if(select_type2.equals("REV")){
													alP = Query.PharmacyBreakdown(date_from, date_to, select_type1, "ASC", "", conn);
												}else if(select_type2.equals("TXN")){
													alP = Query.PharmacyCountBreakdown(date_from, date_to, select_type1, "ASC", "", conn);
												}
												
												if(alP.size()>0){		
					for (int i = 0; i < alP.size(); i++) {
						if(alP.get(i)[0]!=null){
					%>
															{
																"name" : "<%=alP.get(i)[0]%>",
																<%if (i == 1) {%>
																"color" : "#E7F168",
																<%}%>
																<%if(ph_income > 0){%>"y" :
		<%=df.format(Double.parseDouble(alP.get(i)[1]) * 100 / ph_income)%>
			,<%}%>
																"amount" : <%=Double.parseDouble(alP.get(i)[1])%>
															}
															<%if (i != 9) {%>
															,
															<%}%>
															<%
															if(i==9) break;									
						}}}%> ]
										},
										{
											"code" : "Lab",
											"name" : "Lab",
											"id" : "Lab",
											"data" : [
												<%												
												List<String[]> alL = null;												
												if(select_type2.equals("REV")){
													alL = Query.LabBreakdownWC(date_from, date_to, select_type1, "ASC", "", conn);
												}else if(select_type2.equals("TXN")){
													alL = Query.LabCountBreakdownRWC(date_from, date_to, select_type1, "ASC", "", conn);
												}
												
												if(alL.size()>0){	
													int j = 0;
					for (int i = 0; i < alL.size(); i++) {
						if(alL.get(i)[0]!=null && Double.parseDouble(alL.get(i)[1]) > 0){
							j++;
							// System.out.println(" i = " + i + ", name = " + alL.get(i)[0]);
					%>
															{
																"name" : "<%=alL.get(i)[0]%>",
																<%if (j == 2) {%>
																"color" : "#E7F168",
																<%}%>
																<%if(lab_income > 0){%>"y" :
		<%=df.format(Double.parseDouble(alL.get(i)[1]) * 100 / lab_income)%>
			,<%}%>
																"amount" : <%=Double.parseDouble(alL.get(i)[1])%>
															}
															<%if (j != 10) {%>
															,
															<%}%>
															<%
															if(j==10) break;									
						}}}%> ]
										},
										{
											"code" : "Channel",
											"name" : "Channel",
											"id" : "Channel",
											"data" : [
												<%	
													int j = 0;
													double amt = 0;
													HashMap<String, Double> hashMap = new HashMap<String, Double>();
					for (DoctorAppointment da : da_al) {						
						if(select_type2.equals("REV")){
							amt = da.getTotalAmount();
						}else if(select_type2.equals("TXN")){
							amt = da.getChannelCount();
						}	
						
						if (hashMap.containsKey(da.getDoctorName())) {
							hashMap.put(da.getDoctorName(), hashMap.get(da.getDoctorName()) + amt);								
						} else {
							hashMap.put(da.getDoctorName(), amt);
						}
					}					
					Map<String, Double> hm = Utils.sortByValue(hashMap);	
					for (Map.Entry row : hm.entrySet()) {
						j++;
					%>
															{
																"name" : "<%=row.getKey()%>",
																<%if (j == 2) {%>
																"color" : "#E7F168",
																<%}%>
																<%if(channel_income > 0){%>"y" :
		<%=df.format(Double.parseDouble((row.getValue()).toString()) * 100 / channel_income)%>
			,<%}%>
																"amount" : <%=row.getValue()%>
															}
															<%if (j != 10) {%>
															,
															<%}%>
															<%
															if(j==10) break;									
						
						}
					%> ]
										} ]
							}
						});

		///////////////////////////////////////////////////////////////////

		// Pie chart - Target
		Highcharts
				.chart(
						'pie_target',
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
								text : '<%=select_type1%> Target'
							},
							subtitle : {
								text : '<b><u><%=date_from%></u></b> and <b><u><%=date_to%></u></b>'
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
								//pointFormat : '{series.name}: <b>{point.percentage:.1f} %</b>'
								headerFormat : '<span style="font-size:11px">{series.name}</span><br>',
								pointFormat : '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:,.2f} %</b> of total<br/><span></span><br/>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									depth : 35,
									cursor : 'pointer',
									dataLabels : {
										allowOverlap : true,
										enabled : true,
										format : '<span style="font-size:11px;">{point.name}</span><br/><span style="font-size:22px; color:#f96868;">{point.y:,.0f} %</span><br/><span style="font-size:11px;"><%=currency1%> {point.amount:.0f}</span>',
										//format : '<span style="font-size:11px; color:#f96868;">{point.code}</span><br/><span style="font-size:22px; color:#f96868;">{point.y:.0f} %</span>'
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
								name : 'Percentage',
								data : [
										{
											code : 'SNA',
											name : 'Service Non Appointment',
											amount :
<%=sna_target%>
										<%if(tot_target > 0){%>,
											y :
<%=df.format((sna_target * 100) / tot_target)%><%}%>
	},
										{
											color : '#E7F168',
											code : 'PH',
											name : 'Pharmacy',
											amount :
<%=ph_target%>
	<%if(tot_target > 0){%>,
											y :
<%=df.format((ph_target * 100) / tot_target)%><%}%>
	},
										{
											code : 'LAB',
											name : 'Lab',
											amount :
<%=lab_target%>
	<%if(tot_target > 0){%>,
											y :
<%=df.format((lab_target * 100) / tot_target)%><%}%>
	} ]
							} ]
						});
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
					<jsp:include page="../../filter_date.jsp"><jsp:param
							value="targetachievement.jsp" name="action" /><jsp:param
							value="yes" name="sub" /><jsp:param
							value="<%=select_type1%>" name="select_type1" /><jsp:param
							value="<%=select_type2%>" name="select_type2" /><jsp:param
							value="<%=date_to%>" name="date_to" /><jsp:param
							value="<%=date_from%>" name="date_from" /></jsp:include>
					<%
						///////////////////////// Modal - End
					%>
					<div class="row">
						<div class="col-12 grid-margin">
							<div class="card">
								<div class="card-body">
									<div id="containerBar1" style="width: 100%; height: 500px;"></div>
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
					<div class="row">
						<div class="col-12 grid-margin">
							<div class="card">
								<div class="card-body">
									<div id="pie_revenue" style="width: 100%; height: 500px;"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="row" style="display: none;">
						<div class="col-12 grid-margin">
							<div class="card">
								<div class="card-body">
									<div id="pie_target" style="width: 100%; height: 500px;"></div>
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
	conn.CloseDataBaseConnection();
	} catch (Exception e) {
		conn.CloseDataBaseConnection();
		System.out.println(e);
	}
		} else {
			//RequestDispatcher rd = request.getRequestDispatcher("Logout.jsp?error=Logout from the system...");
			//System.out.println("Logout...");
			response.sendRedirect("../../Logout.jsp?error=Logout%20from%20the%20system...");
		}
	%>

