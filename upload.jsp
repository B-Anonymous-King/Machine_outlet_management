<%@ page import="com.oreilly.servlet.MultipartRequest" %>  
<%  
MultipartRequest m = new MultipartRequest(request, "c:/new");  
out.print("successfully uploaded");  
  
%>  