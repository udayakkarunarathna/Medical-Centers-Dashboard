<%@page import="db.DatabaseConnection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.query.Query"%>
<script>
	function setParameter(val) {
		var val = val;
		document.getElementById('date_selection').value = val;
		//console.log(document.getElementById('date_selection').value);
	}
</script>
<%
	String sub = "", root = "", path = "";
	if (request.getParameter("sub") != null) {
		sub = request.getParameter("sub");
	}
	if (sub.equals("yes")) {
		root = "../../";
		path = "";
	} else {
		root = "";
		path = "pages/highcharts/";
	}

	int mc = 0;
	if (session.getAttribute("mc") != null) {
		mc = Integer.parseInt((String) session.getAttribute("mc"));
	}

	String select_type1 = "All";
	if (request.getParameter("select_type1") != null) {
		select_type1 = request.getParameter("select_type1");
	}

	String select_type2 = "REV";
	if (request.getParameter("select_type2") != null) {
		select_type2 = request.getParameter("select_type2");
	}

	String doctor = "*~*";
	if (request.getParameter("doctor") != null) {
		doctor = request.getParameter("doctor");
	}

	String date_selection = "date";
	if (request.getParameter("date_selection") != null) {
		date_selection = request.getParameter("date_selection");
	}
	if (date_selection.equals("")) {
		date_selection = "date";
	}
	String action = "";
	if (request.getParameter("action") != null) {
		action = request.getParameter("action");
	}
	// System.out.println(action);
	String date1 = "";
	if (request.getParameter("date1") != null) {
		date1 = request.getParameter("date1");
	}
	String date2 = "";
	if (request.getParameter("date2") != null) {
		date2 = request.getParameter("date2");
	}
	String week1 = "";
	if (request.getParameter("week1") != null) {
		week1 = request.getParameter("week1");
	}
	String week11 = "";
	if (request.getParameter("week11") != null) {
		week11 = request.getParameter("week11");
	}
	String week2 = "";
	if (request.getParameter("week2") != null) {
		week2 = request.getParameter("week2");
	}
	String week22 = "";
	if (request.getParameter("week22") != null) {
		week22 = request.getParameter("week22");
	}
	String month1 = "";
	if (request.getParameter("month1") != null) {
		month1 = request.getParameter("month1");
	}
	String month2 = "";
	if (request.getParameter("month2") != null) {
		month2 = request.getParameter("month2");
	}
	String year1 = "";
	if (request.getParameter("year1") != null) {
		year1 = request.getParameter("year1");
	}
	String year2 = "";
	if (request.getParameter("year2") != null) {
		year2 = request.getParameter("year2");
	}

	String cc = "no";
	if (request.getParameter("cc") != null) {
		cc = request.getParameter("cc");
	}

	if (week1.equals("")) {
		week1 = date1;
	}
	if (week11.equals("")) {
		week11 = date1;
	}
	if (week2.equals("")) {
		week2 = date2;
	}
	if (week22.equals("")) {
		week22 = date2;
	}

	// System.out.println("\n");
	// System.out.println("select_type1 = " + select_type1);
	// System.out.println("select_type2 = " + select_type2);
	// System.out.println("Filter date1 = " + date1);
	// System.out.println("Filter date2 = " + date2);
	// System.out.println("Filter week1 = " + week1);
	// System.out.println("Filter week11 = " + week11);
	// System.out.println("Filter week2 = " + week2);
	// System.out.println("Filter week22 = " + week22);
	// System.out.println("\n");
%>
<script src="<%=root%>js/jquery.loading-indicator.js"></script>
<link type="text/css" rel="stylesheet"
	href="<%=root%>css/jquery.loading-indicator.css" />
<script>
	$(document).ready(function() {
		$(".loader").click(function() {
			$('html, body').css({
				overflow : 'hidden',
				height : '100%'
			});
			var homeLoader = $('body').loadingIndicator({
				useImage : false,
			}).data("loadingIndicator");
		});
	});
</script>
<script>
	var keys = [ 32, 33, 34, 35, 36, 37, 38, 39, 40 ];

	function preventDefault(e) {
		e = e || window.event;
		if (e.preventDefault)
			e.preventDefault();
		e.returnValue = false;
	}

	function keydown(e) {
		for (var i = keys.length; i--;) {
			if (e.keyCode === keys[i]) {
				preventDefault(e);
				return;
			}
		}
	}

	function wheel(e) {
		preventDefault(e);
	}

	function disable_scroll() {
		if (window.addEventListener) {
			window.addEventListener('DOMMouseScroll', wheel, false);
		}
		window.onmousewheel = document.onmousewheel = wheel;
		document.onkeydown = keydown;
		disable_scroll_mobile();
	}

	function enable_scroll() {
		if (window.removeEventListener) {
			window.removeEventListener('DOMMouseScroll', wheel, false);
		}
		window.onmousewheel = document.onmousewheel = document.onkeydown = null;
		enable_scroll_mobile();
	}

	// My improvement

	// MOBILE
	function disable_scroll_mobile() {
		document.addEventListener('touchmove', preventDefault, false);
	}
	function enable_scroll_mobile() {
		document.removeEventListener('touchmove', preventDefault, false);
	}
</script>
<div align="right" style="margin-bottom: 5px; margin-top: -15px;">
	<button type="button" class="btn btn-inverse-info btn-fw"
		data-toggle="modal" data-target="#exampleModal" data-whatever="@mdo"
		style="cursor: pointer;">Filter</button>
</div>

<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog"
	aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header" style="background-color: #9fa2bd">
				<h5 class="modal-title" id="exampleModalLabel">Filter</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form style="font-weight: bold;" method="post" action="<%=action%>">
				<input type="hidden" name="date_selection" id="date_selection" />
				<div class="modal-body">
					<div class="form-group"
						style="margin-bottom: 0px; <%if (cc.equals("yes")) {%>display: none;<%}%>"
						align="center">
						<div class="btn-group btn-group-sm" data-toggle="buttons" style="border: 0px">
							<label
								class="btn btn-info <%if (select_type1.equals("OPD")) {%> active <%}%>"
								for="opd" style="cursor: pointer;"><input type="radio"
								name="select_type1" id="opd" value="OPD" <%if (select_type1.equals("OPD")) {%> checked="checked" <%}%>/>OPD&nbsp;&nbsp;</label><label
								class="btn btn-info <%if (select_type1.equals("INWARD")) {%> active <%}%>"
								for="inward" style="cursor: pointer;"><input
								type="radio" name="select_type1" id="inward" value="INWARD" <%if (select_type1.equals("INWARD")) {%> checked="checked" <%}%>/>Inward&nbsp;&nbsp;</label>
							<label
								class="btn btn-info <%if (select_type1.equals("All")) {%> active <%}%>"
								for="all" style="cursor: pointer;"><input type="radio"
								name="select_type1" id="all" value="All" <%if (select_type1.equals("All")) {%> checked="checked" <%}%>/>All&nbsp;&nbsp;</label>
						</div>
					</div>
					<div class="form-group" style="margin-bottom: 0px;" align="center">
						<div class="btn-group btn-group-sm" data-toggle="buttons" style="border: 0px">
							<label
								class="btn btn-info <%if (select_type2.equals("REV")) {%> active <%}%>"
								for="REV" style="cursor: pointer;"><input type="radio"
								name="select_type2" id="REV" value="REV" <%if (select_type2.equals("REV")) {%> checked="checked" <%}%>/>Revenue&nbsp;&nbsp;</label><label
								class="btn btn-info <%if (select_type2.equals("TXN")) {%> active <%}%>"
								for="TXN" style="cursor: pointer;"><input type="radio"
								name="select_type2" id="TXN" value="TXN" <%if (select_type2.equals("TXN")) {%> checked="checked" <%}%>/>Patient
								Count&nbsp;&nbsp;</label>
						</div>
					</div>

					<div class="form-group" align="left">
						<label for="doctor">Doctor</label> <select
							class="form-control form-control" id="doctor"
							style="font-weight: bold; color: green;" name="doctor">
							<option style="font-weight: bold; color: blue;" value="*~*"
								<%if (doctor.equals("*~*")) {%> selected="selected" <%}%>>--
								All --</option>
							<%
								// System.out.println(doctor);

								ArrayList<String[]> doctor_al = Query.getDoctors(mc);
								session.setAttribute("doctor_al", doctor_al);
								for (int i = 1; i <= doctor_al.size(); i++) {
							%>
							<option
								<%if (doctor.equals(doctor_al.get(i - 1)[0] + "~" + doctor_al.get(i - 1)[1])) {%>
								selected="selected" <%}%>
								value="<%=doctor_al.get(i - 1)[0]%>~<%=doctor_al.get(i - 1)[1]%>"
								style="font-weight: bold; color: green;"><%=doctor_al.get(i - 1)[1]%></option>
							<%
								}
							%>
						</select>
					</div>

					<!-- Nav tabs -->
					<ul class="nav nav-tabs" style="margin-top: 20px;">
						<li class="nav-item"><a
							class="nav-link <%if (date_selection.equals("date")) {%> active <%}%>"
							data-toggle="tab" href="#date" onclick="setParameter('date')">Date</a></li>
						<li class="nav-item"><a
							class="nav-link <%if (date_selection.equals("week")) {%> active <%}%>"
							data-toggle="tab" href="#week" onclick="setParameter('week')">Date
								Range</a></li>
						<li class="nav-item"><a
							class="nav-link <%if (date_selection.equals("month")) {%> active <%}%>"
							data-toggle="tab" href="#month" onclick="setParameter('month')">Month</a></li>
						<li class="nav-item"><a
							class="nav-link <%if (date_selection.equals("year")) {%> active <%}%>"
							data-toggle="tab" href="#year" onclick="setParameter('year')">Year</a></li>
					</ul>
					<!-- Tab panes -->
					<div class="tab-content">

						<div
							class="tab-pane container <%if (date_selection.equals("date")) {%> active <%} else {%> fade <%}%>"
							id="date">
							<label for="from" class="col-form-label">Date 1:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="date" class="form-control"
								id="date1" name="date1" placeholder="Select date 1 ..."
								value="<%=date1%>"
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">
							<label for="date2" class="col-form-label">Date 2:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="date" class="form-control"
								id="date2" name="date2" value="<%=date2%>"
								placeholder="Select date 2 ..."
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">
						</div>

						<div
							class="tab-pane container <%if (date_selection.equals("week")) {%> active <%} else {%> fade <%}%>"
							id="week">
							<label for="week1" class="col-form-label">Date Range 1:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="date" class="form-control"
								id="week1" name="week1" placeholder="Select date from ..."
								value="<%=week1%>"
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">&nbsp;&nbsp;<input
								type="date" class="form-control" id="week11" name="week11"
								placeholder="Select date from ..." value="<%=week11%>"
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">

							<label for="week2" class="col-form-label">Date Range 2:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="date" class="form-control"
								id="week2" name="week2" value="<%=week2%>"
								placeholder="Select date to ..."
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">&nbsp;&nbsp;<input
								type="date" class="form-control" id="week22" name="week22"
								value="<%=week22%>" placeholder="Select date to ..."
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">
						</div>


						<div
							class="tab-pane container <%if (date_selection.equals("month")) {%> active <%} else {%> fade <%}%>"
							id="month">
							<label for="month1" class="col-form-label">Month 1:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="month" class="form-control"
								id="month1" name="month1" placeholder="Select month 1 ..."
								value="<%=month1%>"
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">
							<label for="month2" class="col-form-label">Month 2:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="month" class="form-control"
								id="month2" name="month2" value="<%=month2%>"
								placeholder="Select month 2 ..."
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">
						</div>
						<div
							class="tab-pane container <%if (date_selection.equals("year")) {%> active <%} else {%> fade <%}%>"
							id="year">
							<label for="year1" class="col-form-label">Year 1:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="number" step="1"
								value="<%=year1%>" class="form-control" id="year1" name="year1"
								placeholder="Select year 1 ..."
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">
							<label for="year2" class="col-form-label">Year 2:</label>
							&nbsp;&nbsp;&nbsp;&nbsp;<input type="number" step="1"
								value="<%=year2%>" class="form-control" id="year2" name="year2"
								placeholder="Select year 2 ..."
								style="width: 200px; font-weight: bold; cursor: pointer; color: green">
						</div>
					</div>

					<div class="form-group">
						<div class="form-radio" align="right">
							<button type="button" class="btn btn-secondary"
								style="cursor: pointer;" data-dismiss="modal">Close</button>
							&nbsp;
							<button type="submit" style="cursor: pointer;"
								class="btn btn-inverse-info btn-fw loader" onclick="disable_scroll()">View</button>
						</div>
					</div>
				</div>
				<div class="modal-footer" style="background-color: #9fa2bd">
					&nbsp;<br />
				</div>
			</form>
		</div>
	</div>
</div>