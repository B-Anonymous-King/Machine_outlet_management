<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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
        String dateTaking = java.time.LocalDate.now().toString();
        DateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        DateFormat outputFormat = new SimpleDateFormat("dd-MMM-yyyy");
        try {
            // Parse the input date string
            Date inputDate = inputFormat.parse(dateTaking);

            // Format the date to the desired output format
             dateTaking = outputFormat.format(inputDate);
        }
        catch (ParseException e) {
            e.printStackTrace();
        }
        // Establish a database connection
        Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection conn = DriverManager.getConnection(url, username, password);
    String insertQuery = "UPDATE gatepass SET status='accepted', hid=?,adate=? WHERE gid=?";;
        PreparedStatement stmt = conn.prepareStatement(insertQuery);
        stmt.setInt(1,Integer.parseInt(hid));
        stmt.setString(2,dateTaking);
        stmt.setInt(3,Integer.parseInt(gid));
        //designationst.setInt(1,100023576);
        
        int rowsAffected=stmt.executeUpdate();
        if (rowsAffected > 0) {%>
        <!DOCTYPE html>
<html>
<head>
  <title>Gatepass Approval</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
    }
    
    .message {
      background-color: #55efc4;
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
    You approved the gatepass with gatepass id <%=gid%> to let the machine out
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