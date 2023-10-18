<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*, javax.servlet.*" %>
<%
if (session != null && session.getAttribute("isLoggedInc") != null && (boolean) session.getAttribute("isLoggedInc")) {
   // Retrieve the gid from the request parameter
   String gid = request.getParameter("gid");
   
   // Database connection setup
   try {
    // Establish a database connection
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
  String username = "system";
  String password = "123456";
  Class.forName("oracle.jdbc.driver.OracleDriver");
  Connection con = DriverManager.getConnection(url, username, password);
   
   // Prepare the SQL query
   String sql = "SELECT * FROM gatepass WHERE gid = ?";
   PreparedStatement stmt = con.prepareStatement(sql);
   stmt.setString(1, gid);
   
   // Execute the query
   ResultSet rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
  <title>Gatepass Details</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
    }
    
    .details-container {
      width: 300px;
      margin: 0 auto;
      background-color: #ffffff;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    .details-label {
      font-weight: bold;
      margin-bottom: 5px;
    }
    
    .details-value {
      margin-bottom: 10px;
    }
    input[type="submit"] {
  background-color: #55efc4;
  color: #ffffff;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

input[type="submit"]:hover {
  background-color: #55efc6;
}
    
  </style>
</head>
<body>
  <div class="details-container">
    <h2>Gatepass Details</h2>
    <% if (rs.next()) { %>
      <p>
        <span class="details-label">Gatepass ID:</span>
        <span class="details-value"><%= rs.getString("gid") %></span>
      </p>
      <p>
        <span class="details-label">Employee Number:</span>
        <span class="details-value"><%= rs.getString("eid") %></span>
      </p>
      <p>
        <span class="details-label">Machine ID:</span>
        <span class="details-value"><%= rs.getString("mid") %></span>
      </p>
      <p>
        <span class="details-label">Requested Date:</span>
        <span class="details-value"><%= rs.getString("rdate") %></span>
      </p>
      <p>
        <span class="details-label">Problem Description:</span>
        <span class="details-value"><%= rs.getString("pdescription") %></span>
      </p>
    <% 
    if(rs.getString("status").equals("out")){
    out.println("<form action='machinein.jsp' method='post'>");
        out.println("<input type='hidden' name='gid' value="+gid+">");%>
        <input type="submit" value="let machine in"/>
        <%}
        }
        else { %>
      <p>No details found for the given Gatepass ID.</p>
    <% } } catch (Exception e) {
      out.println("Error: " + e.getMessage());
      e.printStackTrace();
    }
   } 
      %>
  </div>
</body>
</html>
<%
   // Close the database resources
   //rs.close();
   //stmt.close();
   //con.close();
%>
