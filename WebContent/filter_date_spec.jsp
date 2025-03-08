
<%@page import="db.DatabaseConnection"%>
<%@page import="com.query.Query"%>
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
	String action = "";
	if (request.getParameter("action") != null) {
		action = request.getParameter("action");
	}

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
		conn.CloseDataBaseConnection();
	} catch (Exception e) {
		conn.CloseDataBaseConnection();
		System.out.println(e);
	}

	if (request.getParameter("date_to") != null) {
		date_to = request.getParameter("date_to");
	} else if (session.getAttribute("date_to") != null) {
		date_to = (String) session.getAttribute("date_to");
	}
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
				<div class="modal-body">
					<div class="form-group" style="margin-bottom: 0px;" align="center">
						<div class="btn-group btn-group-sm" data-toggle="buttons" style="border: 0px">
							<label
								class="btn btn-info <%if (select_type1.equals("OPD")) {%> active <%}%>"
								for="opd" style="cursor: pointer;"><input type="radio"
								name="select_type1" id="opd" value="OPD"
								<%if (select_type1.equals("OPD")) {%> checked="checked" <%}%> />OPD&nbsp;&nbsp;</label><label
								class="btn btn-info <%if (select_type1.equals("INWARD")) {%> active <%}%>"
								for="inward" style="cursor: pointer;"><input
								type="radio" name="select_type1" id="inward" value="INWARD"
								<%if (select_type1.equals("INWARD")) {%> checked="checked" <%}%> />Inward&nbsp;&nbsp;</label><label
								class="btn btn-info <%if (select_type1.equals("All")) {%> active <%}%>"
								for="all" style="cursor: pointer;"><input type="radio"
								name="select_type1" id="all" value="All"
								<%if (select_type1.equals("All")) {%> checked="checked" <%}%> />All&nbsp;&nbsp;</label>
						</div>
					</div>
					<div class="form-group" style="margin-bottom: 0px;" align="center">
						<div class="btn-group btn-group-sm" data-toggle="buttons" style="border: 0px">
							<label
								class="btn btn-info <%if (select_type2.equals("REV")) {%> active <%}%>"
								for="all" style="cursor: pointer;"><input type="radio"
								name="select_type2" id="REV" value="REV"
								<%if (select_type2.equals("REV")) {%> checked="checked" <%}%> />Revenue&nbsp;&nbsp;</label><label
								class="btn btn-info <%if (select_type2.equals("TXN")) {%> active <%}%>"
								for="opd" style="cursor: pointer;"><input type="radio"
								name="select_type2" id="TXN" value="TXN"
								<%if (select_type2.equals("TXN")) {%> checked="checked" <%}%> />Patient
								Count&nbsp;&nbsp;</label>
						</div>
					</div>
					<div class="form-group" style="margin-bottom: 0px;" align="center">
						<div class="btn-group btn-group-justified btn-group-sm"
							data-toggle="buttons" style="border: 0px">
							<label
								class="btn btn-info <%if (select_type3.equals("PH")) {%> active <%}%>"
								for="ph" style="cursor: pointer;"><input type="radio"
								name="select_type3" id="ph" value="PH"
								<%if (select_type3.equals("PH")) {%> checked="checked" <%}%> />Pharmacy</label>
							<label
								class="btn btn-info <%if (select_type3.equals("LAB")) {%> active <%}%>"
								for="lab" style="cursor: pointer;"><input type="radio"
								name="select_type3" id="lab" value="LAB"
								<%if (select_type3.equals("LAB")) {%> checked="checked" <%}%> />Lab</label>
							<label
								class="btn btn-info <%if (select_type3.equals("SNA")) {%> active <%}%>"
								for="sna" style="cursor: pointer;"><input type="radio"
								name="select_type3" id="sna" value="SNA"
								<%if (select_type3.equals("SNA")) {%> checked="checked" <%}%> />Service</label>
							<label
								class="btn btn-info <%if (select_type3.equals("All")) {%> active <%}%>"
								for="all" style="cursor: pointer;"><input type="radio"
								name="select_type3" id="all" value="All"
								<%if (select_type3.equals("All")) {%> checked="checked" <%}%> />All</label>
						</div>
					</div>
					<div class="form-group" style="margin-top: 20px;">
						<label for="date_from" class="col-form-label">Date From:</label>
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="date" class="form-control"
							id="date_from" name="date_from" placeholder="Select date from..."
							value="<%=date_from%>"
							style="width: 200px; font-weight: bold; cursor: pointer; color: green">
					</div>
					<div class="form-group">
						<label for="date_to" class="col-form-label">To Date:</label>
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="date" class="form-control"
							id="date_to" name="date_to" value="<%=date_to%>"
							placeholder="Select date to..."
							style="width: 200px; font-weight: bold; cursor: pointer; color: green">
					</div>
					<div class="form-group">
						<div class="form-radio" align="right">
							<button type="button" class="btn btn-secondary"
								style="cursor: pointer;" data-dismiss="modal">Close</button>
							&nbsp;
							<button type="submit" style="cursor: pointer;"
								class="btn btn-inverse-info btn-fw loader"
								onclick="disable_scroll()">View</button>
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