<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%
//HttpSession session = request.getSession(false); // Pass 'false' to not create a new session

if (session != null && session.getAttribute("isLoggedIn") != null && (boolean) session.getAttribute("isLoggedIn")) {
    
  // Session is active
%>
<% 
    // Database connection details
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password = "123456";
    
    try {
        String gid=request.getParameter("gid");
        String hid=session.getAttribute("employee_id").toString();
        // Establish a database connection
        Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection conn = DriverManager.getConnection(url, username, password);
    String insertQuery = "UPDATE gatepass SET status='rejected' WHERE gid=?";;
        PreparedStatement stmt = conn.prepareStatement(insertQuery);
        //stmt.setInt(1,Integer.parseInt(hid));
        stmt.setInt(1,Integer.parseInt(gid));
        //designationst.setInt(1,100023576);
        
        int rowsAffected=stmt.executeUpdate();
        if (rowsAffected > 0) {%>
        <!DOCTYPE html>
<html>
<head>
  <title>Gatepass rejection</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
    }
    
    .message {
      background-color: #ff0000;
      color: #ffffff;
      padding: 20px;
      text-align: center;
      border-radius: 5px;
      font-size: 18px;
      font-weight: bold;
    }
    a {
      display: inline-block;
      padding: 10px 20px;
      background-color: #55efc4;
      color: white;
      text-decoration: none;
      border-radius: 5px;
    }
    
    a:hover {
      background-color: #00b894;
    }
  </style>
</head>
<body>
  <div class="message">
    You rejected the gatepass with gatepass id <%=gid%> to not let the machine out
  </div><br>
  <a href="hoddash.jsp">Go to  Dashboard</a>
</body>
</html>

<%         //out.println("Status and hid updated successfully.");
      } else {
         out.println("No rows updated.");
      }
    } 
      catch (SQLException e) {
      // Handle any errors
      e.printStackTrace();
      
   }
   %>
<%
}
else
{
    response.sendRedirect("index.html");
}
%>