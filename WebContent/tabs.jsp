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
<ul class="nav">
	<li class="nav-item loader"><a class="nav-link"
		href="<%=root%>dashboard.jsp"> <span class="menu-title">Dashboard</span><i
			class="mdi mdi-home menu-icon"></i>
	</a></li>
	<li class="nav-item"><a class="nav-link" data-toggle="collapse"
		href="#ui-basic" aria-expanded="false" aria-controls="ui-basic"> <span
			class="menu-title">Target Vs Achievement</span> <i class="menu-arrow"></i>
			<i class="mdi mdi-target menu-icon"></i></a>
		<div class="collapse" id="ui-basic">
			<ul class="nav flex-column sub-menu">
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>targetachievement.jsp">All Category</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>targetachievement1.jsp">Category-wise</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>collecting_center.jsp">Collecting Center-wise</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>specialitywise.jsp">Speciality-wise</a></li>
				<%-- <li class="nav-item loader"><a class="nav-link"
					href="<%=path%>doctorrevenuewise.jsp">Doctor-wise</a></li> --%>
			</ul>
		</div></li>
	<li class="nav-item loader"><a class="nav-link"
		href="<%=path%>revenue.jsp"><span class="menu-title">Revenue
				& Transaction</span> <i class="mdi mdi-cash menu-icon"></i> </a></li>
	<li class="nav-item"><a class="nav-link" data-toggle="collapse"
		href="#ui-basic1" aria-expanded="false" aria-controls="ui-basic1">
			<span class="menu-title">Comparison</span> <i class="menu-arrow"></i>
			<i class="mdi mdi-compare menu-icon"></i>
	</a>
		<div class="collapse" id="ui-basic1">
			<ul class="nav flex-column sub-menu">
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison10.jsp">Week Days</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison11.jsp">Week Days Breakdown</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison.jsp">All Category</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison2.jsp">Lab</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison1.jsp">Pharmacy</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison4.jsp">Service Non Appointment</a></li>
				<li class="nav-item loader" style="display: none;"><a
					class="nav-link" href="<%=path%>comparison3.jsp">Medical
						Package</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison6.jsp">Channel</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparison5.jsp">Collecting Center</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparisonspeciality.jsp">Speciality</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>comparisondoctor.jsp">Doctor</a></li>
			</ul>
		</div></li>

	<li class="nav-item loader"><a class="nav-link"
		href="<%=path%>user.jsp"> <span class="menu-title">User-wise
				Revenue</span> <i class="mdi mdi-human menu-icon"></i>
	</a></li>
	
	<%if(session.getAttribute("u_name").equals("Admin")){ %>
	<li class="nav-item loader"><a class="nav-link"
		href="<%=root%>dashboardsuperadmin.jsp"> <span class="menu-title">Switch to All MC View</span> <i class="mdi mdi-logout menu-icon"></i>
	</a></li>
	<%} %>
	<br>
	<%-- <li class="nav-item"><a class="nav-link"
		href="<%=path%>channel.jsp"> <span class="menu-title">Channel</span>
			<i class="mdi mdi-stethoscope menu-icon"></i>
	</a></li> --%>
	<li style="display: none;" class="nav-item"><a class="nav-link"
		data-toggle="collapse" href="#ui-basic2" aria-expanded="false"
		aria-controls="ui-basic2"> <span class="menu-title">Basic
				UI Elements</span> <i class="menu-arrow"></i> <i
			class="mdi mdi-crosshairs-gps menu-icon"></i>
	</a>
		<div class="collapse" id="ui-basic2">
			<ul class="nav flex-column sub-menu">
				<li class="nav-item"><a class="nav-link"
					href="pages/ui-features/buttons.html">Buttons</a></li>
				<li class="nav-item"><a class="nav-link"
					href="pages/ui-features/typography.html">Typography</a></li>
			</ul>
		</div></li>
	<li style="display: none;" class="nav-item"><a class="nav-link"
		href="pages/icons/font-awesome.html"> <span class="menu-title">Icons</span>
			<i class="mdi mdi-contacts menu-icon"></i>
	</a></li>
	<li style="display: none;" class="nav-item"><a class="nav-link"
		href="pages/forms/basic_elements.html"> <span class="menu-title">Form
				Elements</span> <i class="mdi mdi-format-list-bulleted menu-icon"></i>
	</a></li>
	<li style="display: none;" class="nav-item"><a class="nav-link"
		href="pages/charts/chartjs.jsp"> <span class="menu-title">Chart</span>
			<i class="mdi mdi-chart-bar menu-icon"></i>
	</a></li>
	<li style="display: none;" class="nav-item"><a class="nav-link"
		href="pages/tables/bootstrap-table.html"> <span class="menu-title">Table</span>
			<i class="mdi mdi-table-large menu-icon"></i>
	</a></li>
	<li style="display: none;" class="nav-item"><a class="nav-link"
		data-toggle="collapse" href="#auth" aria-expanded="false"
		aria-controls="auth"> <span class="menu-title">Sample Pages</span>
			<i class="menu-arrow"></i> <i class="mdi mdi-lock menu-icon"></i>
	</a>
		<div style="display: none;" class="collapse" id="auth">
			<ul class="nav flex-column sub-menu">
				<li class="nav-item"><a class="nav-link"
					href="pages/samples/blank-page.html"> Blank Page </a></li>
				<li class="nav-item"><a class="nav-link"
					href="pages/samples/Login.jsp"> Login </a></li>
				<li class="nav-item"><a class="nav-link"
					href="pages/samples/register.html"> Register </a></li>
				<li class="nav-item"><a class="nav-link"
					href="pages/samples/error-404.html"> 404 </a></li>
				<li class="nav-item"><a class="nav-link"
					href="pages/samples/error-500.html"> 500 </a></li>
			</ul>
		</div></li>
</ul>