<%@page import="db.DatabaseConnection"%>
<%@page import="com.query.Query"%>
<script>
	function setParameter(val) {
		var val = val;
		document.getElementById('date_selection').value = val;
		//console.log(document.getElementById('date_selection').value);
	}
</script>
<%
	DatabaseConnection conn1 = new DatabaseConnection();
	int mc1 = 0;
	if (session.getAttribute("mc") != null) {
		mc1 = Integer.parseInt((String) session.getAttribute("mc"));
	}
	String[] days = new String[7];
	String[] dates = new String[7];
	try {
		conn1.ConnectToDataBase(mc1);
		days = Query.getThisWeekDayDatesArray("days", conn1);
		dates = Query.getThisWeekDayDatesArray("dates", conn1);

	} catch (Exception e) {
		System.out.println(e);
	} finally {
		conn1.CloseDataBaseConnection();
	}

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
	String select_type1 = "REV";
	if (request.getParameter("select_type1") != null) {
		select_type1 = request.getParameter("select_type1");
	}
	String select_type2 = "";
	if (request.getParameter("select_type2") != null) {
		select_type2 = request.getParameter("select_type2");
	}

	String action = "";
	if (request.getParameter("action") != null) {
		action = request.getParameter("action");
	}
%>
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
		<div class="modal-content" style="width: 110%">
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
					<div class="form-group" style="margin-bottom: 0px;" align="center">
						<div class="btn-group btn-group-sm" data-toggle="buttons" style="border: 0px">
							<label
								class="btn btn-info <%if (select_type1.equals("REV")) {%> active <%}%>"
								for="REV" style="cursor: pointer;"><input type="radio"
								name="select_type1" id="REV" value="REV"
								<%if (select_type1.equals("REV")) {%> checked="checked" <%}%> />Revenue&nbsp;&nbsp;</label><label
								class="btn btn-info <%if (select_type1.equals("TXN")) {%> active <%}%>"
								for="TXN" style="cursor: pointer;"><input type="radio"
								name="select_type1" id="TXN" value="TXN"
								<%if (select_type1.equals("TXN")) {%> checked="checked" <%}%> />Transactions&nbsp;&nbsp;</label>
						</div>
					</div>
					<div class="form-group" style="margin-bottom: 0px;" align="center">
						<div class="btn-group btn-group-sm" data-toggle="buttons" style="border: 0px">

							<%
								for (int i = 0; i < 7; i++) {
							%>
							<label
								class="btn btn-info <%if (select_type2.equals(dates[i])) {%> active <%}%>"
								for="<%=dates[i]%>" style="cursor: pointer;"><input type="radio"
								name="select_type2" id="<%=dates[i]%>" value="<%=dates[i]%>"
								<%if (select_type2.equals(dates[i])) {%> checked="checked" <%}%> />&nbsp;<%=days[i]%>&nbsp;</label>
							<%
								}
							%>
						</div>
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