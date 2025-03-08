<%@page import="java.text.DecimalFormat"%>
<%
	double revenue = 0, target = 0, head_count = 0, tag_head_count = 0;
	String date_from1 = "", date_to1 = "";

	if (session.getAttribute("date_from1") != null) {
		date_from1 = (String) session.getAttribute("date_from1");
	}
	if (session.getAttribute("date_to1") != null) {
		date_to1 = (String) session.getAttribute("date_to1");
	}
	if (session.getAttribute("revenue_all") != null) {
		revenue = (Double) session.getAttribute("revenue_all");
	}
	if (session.getAttribute("target_all") != null) {
		target = (Double) session.getAttribute("target_all");
	}
	if (session.getAttribute("head_count_all") != null) {
		head_count = (Double) session.getAttribute("head_count_all");
	}
	if (session.getAttribute("tag_head_count_all") != null) {
		tag_head_count = (Double) session.getAttribute("tag_head_count_all");
	}

	DecimalFormat df = new DecimalFormat("###,###.##");
	DecimalFormat df1 = new DecimalFormat("###,###");
	String class1 = "", class2 = "";

	// System.out.println("revenue = " + revenue);
	// System.out.println("target = " + target);
	// System.out.println("head_count = " + head_count);
	// System.out.println("tag_head_count = " + tag_head_count);

	double income_per1 = 0, patient_per1 = 0;
	if (target > 0) {
		income_per1 = (revenue / target) * 100;
	}
	if (tag_head_count > 0) {
		patient_per1 = (head_count / tag_head_count) * 100;
	}
	// System.out.println("income_per1 = " + income_per1);
	// System.out.println("patient_per1 = " + patient_per1);

	if (income_per1 < 50) {
		class1 = "bg-gradient-danger";
	} else if (income_per1 >= 50 && income_per1 < 100) {
		class1 = "bg-gradient-warning";
	} else if (income_per1 >= 100) {
		class1 = "bg-gradient-success";
	}

	if (patient_per1 < 50) {
		class2 = "bg-gradient-danger";
	} else if (patient_per1 >= 50 && patient_per1 < 100) {
		class2 = "bg-gradient-warning";
	} else if (patient_per1 >= 100) {
		class2 = "bg-gradient-success";
	}
%>
<div class="sidebar-progress" style="margin-bottom: 30px;">
	<p>
		All Income Achievement<br /> <font size="1">From <%=date_from1%>
			to <%=date_to1%></font>
	</p>

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
	<p>
		All Patient Achievement<br /> <font size="1">From <%=date_from1%>
			to <%=date_to1%></font>
	</p>

	<div class="progress progress-sm">
		<div class="progress-bar <%=class2%>" role="progressbar"
			style="width: <%=patient_per1%>%" aria-valuenow="<%=patient_per1%>"
			aria-valuemin="0" aria-valuemax="1000"></div>
	</div>
	<p><%=df1.format(patient_per1)%>
		%
	</p>
</div>