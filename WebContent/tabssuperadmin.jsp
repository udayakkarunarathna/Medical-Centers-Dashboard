
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
		href="<%=root%>dashboardsuperadmin.jsp"> <span class="menu-title">Dashboard</span><i
			class="mdi mdi-home menu-icon"></i>
	</a></li>
	<li style="display: none;" class="nav-item"><a class="nav-link"
		data-toggle="collapse" href="#ui-basic" aria-expanded="false"
		aria-controls="ui-basic"> <span class="menu-title">Target
				Vs Achievement</span> <i class="menu-arrow"></i> <i
			class="mdi mdi-target menu-icon"></i></a>
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
				<li class="nav-item loader"><a class="nav-link"
					href="<%=path%>doctorrevenuewise.jsp">Doctor-wise</a></li>
			</ul>
		</div></li>
	<li style="" class="nav-item loader"><a class="nav-link"
		href="<%=root%>dashboardsuperadmincc.jsp"><span class="menu-title">Revenue<br />All
				Collecting Center
		</span> <i class="mdi mdi-cash menu-icon"></i> </a></li>
	<%-- <li class="nav-item"><a class="nav-link"
		href="<%=path%>comparisonsuperadmin.jsp"><span class="menu-title">Comparison</span>
			<i class="mdi mdi-compare menu-icon"></i> </a></li> --%>
	<li style="" class="nav-item"><a class="nav-link"
		data-toggle="collapse" href="#ui-basic1" aria-expanded="false"
		aria-controls="ui-basic1"> <span class="menu-title">Revenue
				Breakdown<br />Collecting Center-wise
		</span> <i class="menu-arrow"></i> <i class="mdi mdi-compare menu-icon"></i>
	</a>
		<div class="collapse" id="ui-basic1">
			<ul class="nav flex-column sub-menu">
				<li class="nav-item loader"><a class="nav-link active"
					href="<%=root%>collecting_center_breakdown.jsp?mc=202">Battaramulla</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=root%>collecting_center_breakdown.jsp?mc=205">Jaela</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=root%>collecting_center_breakdown.jsp?mc=201">Kiribathgoda</a></li>
				<li class="nav-item loader"><a class="nav-link"
					href="<%=root%>collecting_center_breakdown.jsp?mc=203">Panadura</a></li>
				<%-- <li class="nav-item loader"><a class="nav-link"
					href="<%=root%>collecting_center_breakdown.jsp?mc=206">Rajagiriya</a></li> --%>
			</ul>
		</div></li>

	<li style="display: none;" class="nav-item loader"><a
		class="nav-link" href="<%=path%>user.jsp"> <span
			class="menu-title">User-wise Revenue</span> <i
			class="mdi mdi-human menu-icon"></i>
	</a></li>
	<%-- <li class="nav-item"><a class="nav-link"
		href="<%=path%>channel.jsp"> <span class="menu-title">Channel</span>
			<i class="mdi mdi-stethoscope menu-icon"></i>
	</a></li> --%>
	<li class="nav-item"><a class="nav-link"
		data-toggle="collapse" href="#ui-basic2" aria-expanded="false"
		aria-controls="ui-basic2"> <span class="menu-title">Switch to</span> <i class="menu-arrow"></i> <i
			class="mdi mdi-crosshairs-gps menu-icon"></i>
	</a>
		<div class="collapse" id="ui-basic2">
			<ul class="nav flex-column sub-menu">
			<%
			String[] mc = {"202", "205", "201", "203", "206"};
			String[] mcString = {"Battaramulla", "Jaela", "Kiribathgoda", "Panadura", "Rajagiriya"};
							for (int i = 0; i < mcString.length - 1; i++) {
						%>
				<li class="nav-item"><a class="nav-link"
					href="LoginControl?u_name=Admin&password=123&mc=<%=mc[i]%>~<%=mcString[i]%> MC"><%=mcString[i]%></a></li>
				<%
							}
						%>	
				
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