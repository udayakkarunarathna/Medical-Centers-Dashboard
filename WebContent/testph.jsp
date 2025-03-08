<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="javapkg.OPDIssue"%>
<%@ page import="javapkg.Parameter"%>
<%@ page import="javapkg.PharmacyUnit"%>
<%@ page import="javapkg.HandleThroughUnits"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
	String pharmacyCode = (String) session.getAttribute("pharmacyCode");
	
		OPDIssue opddrug = new OPDIssue(pharmacyCode);
		
		Parameter obj = new Parameter("OPDISSUE");
		
		String param = "";
		
		param = obj.getNextValue();

		out.println(opddrug.getAllDoctors());
		
		out.println("<br/>");

		out.println(opddrug.getOPDAccutualDrugQuantityinPharmacy());
		
		out.println("<br/>");

		out.println(param);
		

		out.println("<br/>");

		out.println(opddrug.getOPDBanksList());		

		out.println("<br/>");
		
		PharmacyUnit pu = new PharmacyUnit(pharmacyCode);

		out.println(pu.selectAccountTypeVtDefalt());
		

		
		HandleThroughUnits hu = new HandleThroughUnits(pharmacyCode);

		out.println(hu.getAllThroughUnits());
	%>


</body>
</html> --%>