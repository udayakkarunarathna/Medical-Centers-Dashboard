<%@page import="java.text.DecimalFormat"%>
<%
	double revenue1 = 0, revenue2 = 0, target = 0;

	if (session.getAttribute("revenue1") != null) {
		revenue1 = (Double) session.getAttribute("revenue1");
	}
	if (session.getAttribute("revenue2") != null) {
		revenue2 = (Double) session.getAttribute("revenue2");
	}
	if (session.getAttribute("target_all") != null) {
		target = (Double) session.getAttribute("target_all");
	}

	//System.out.println("revenue1 = " + revenue1);
	//System.out.println("revenue2 = " + revenue2);
	//System.out.println("target = " + target);

	DecimalFormat df = new DecimalFormat("###,###.##");
	DecimalFormat df1 = new DecimalFormat("###,###");
	String class1 = "", class2 = "";

	double income_per1 = 0, income_per2 = 0;
	if (target > 0) {
		income_per1 = (revenue1 / target) * 100;
		income_per2 = (revenue2 / target) * 100;
	}

	if (income_per1 < 50) {
		class1 = "bg-gradient-danger";
	} else if (income_per1 >= 50 && income_per1 < 100) {
		class1 = "bg-gradient-warning";
	} else if (income_per1 >= 100) {
		class1 = "bg-gradient-success";
	}

	if (income_per2 < 50) {
		class2 = "bg-gradient-danger";
	} else if (income_per2 >= 50 && income_per2 < 100) {
		class2 = "bg-gradient-warning";
	} else if (income_per2 >= 100) {
		class2 = "bg-gradient-success";
	}
%>
<div class="sidebar-progress">
	<p>Income Achievement 1</p>

	<div class="progress progress-sm">
		<div class="progress-bar <%=class1%>" role="progressbar"
			style="width: <%=income_per1%>%" aria-valuenow="<%=income_per1%>"
			aria-valuemin="0" aria-valuemax="1000"></div>
	</div>
	<p><%=df1.format(income_per1)%>
		%
	</p>
</div>
<div class="sidebar-progress">
	<p>Income Achievement 2</p>

	<div class="progress progress-sm">
		<div class="progress-bar  <%=class2%>" role="progressbar"
			style="width: <%=income_per2%>%" aria-valuenow="<%=income_per2%>"
			aria-valuemin="0" aria-valuemax="1000"></div>
	</div>
	<p><%=df1.format(income_per2)%>
		%
	</p>
</div>
<%-- <div style="margin-bottom: 30px;">&nbsp;</div>
<div class="sidebar-progress">
	<p>Patient Achievement 1</p>

	<div class="progress progress-sm">
		<div class="progress-bar <%=class2%>" role="progressbar"
			style="width: <%=patient_per1%>%" aria-valuenow="<%=patient_per1%>"
			aria-valuemin="0" aria-valuemax="1000"></div>
	</div>
	<p><%=df1.format(patient_per1)%>
		%
	</p>
</div>
<div class="sidebar-progress">
	<p>Patient Achievement 2</p>

	<div class="progress progress-sm">
		<div class="progress-bar bg-gradient-success" role="progressbar"
			style="width: <%=patient_per2%>%" aria-valuenow="<%=patient_per2%>"
			aria-valuemin="0" aria-valuemax="1000"></div>
	</div>
	<p><%=df1.format(patient_per2)%>
		%
	</p>
</div> --%>