<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%
//HttpSession session = request.getSession(false); // Pass 'false' to not create a new session

if (session != null && session.getAttribute("isLoggedIne") != null && (boolean) session.getAttribute("isLoggedIne")) {
  // Session is active
%>
<!DOCTYPE html>
<html>
<head>
  <title>EMPLOYEE Dashboard</title>
  <style>
  body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
    }
    
    table {
      width: 100%;
      border-collapse: collapse;
    }
    
    th, td {
      padding: 10px;
      text-align: left;
      border-bottom: 1px solid #dddddd;
    }
    
    th {
      background-color: #55efc4;
      color: #ffffff;
    }
  .card {
      background-color: #fff;
      box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
      padding: 16px;
      margin-bottom: 20px;
      border-radius: 4px;
    }

    .card-header {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .card-content {
      margin-bottom: 10px;
    }

    .card-content span {
      font-weight: bold;
    }
    body {
      background-color: #f1f1f1;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
    
    .header {
      background-color: #00b894;
      padding: 20px;
      color: white;
    }
    
    .container {
      max-width: 960px;
      margin: 20px auto;
      padding: 20px;
      background-color: white;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    }
    
    .navbar {
      background-color: #55efc4;
      padding: 10px;
      margin-bottom: 20px;
    }
    
    .navbar a {
      color: white;
      text-decoration: none;
      margin-right: 10px;
    }
    
    .content {
      background-color: white;
      padding: 20px;
      border: 1px solid #ddd;
      border-radius: 5px;
      margin-bottom: 20px;
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
  <div class="header">
    <h1>EMPLOYEE Dashboard</h1>
    <p>Employee ID: <span id="employeeId"><%= session.getAttribute("employee_id") %></span></p>
  </div>

  <div class="container">
    <div class="navbar">
      <a href="#" onclick="showContent('requestPass')">Request for Pass</a>
      <a href="#" onclick="showContent('machinesWithYou')">Machines with You</a>
      <a href="logout.jsp" onclick="showContent('logout')">Logout</a>
    </div>

    <div class="content" id="requestPass">
      <h2>Request for Pass</h2>
       <% 
    try {
      // Establish a database connection
      String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password = "123456";
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection connection = DriverManager.getConnection(url, username, password);
    String insertQuery="select department from employees where EMPLOYEE_ID= ?";
        PreparedStatement stmt = connection.prepareStatement(insertQuery);
        String department=session.getAttribute("employee_id").toString();;
        stmt.setInt(1,Integer.parseInt(department));
        //designationst.setInt(1,100023576);
        
        ResultSet rs=stmt.executeQuery();
        
        if(rs.next())
        {
            
            department=rs.getString(1);
            //out.println(department);
            
        }

      // Retrieve machine details from the machines table
      insertQuery = "SELECT MACHINE_ID	, MACHINE_NAME, DEPARTMENT,description FROM machine WHERE department=?";
      stmt = connection.prepareStatement(insertQuery);
      stmt.setString(1,department);
      //Statement getMachinesStmt = connection.createStatement();

      ResultSet machinesResult = stmt.executeQuery();

      // Iterate through the machine records and display them as cards
      while (machinesResult.next()) {
        int machineId = machinesResult.getInt("machine_id");
        String machineName = machinesResult.getString("machine_name");
        //department = machinesResult.getString("department");
        String description=machinesResult.getString("description");
        out.println("<form action='requestmachine.jsp' method='post'>");
        out.println("<input type='hidden' name='mid' value="+machineId+">");
        //out.println("<input type='hidden' name='department' value="+department+">");
        out.println("<input type='hidden' name='mname' value="+machineName+">");

  %>
  
        
        
        <div class="card">
          <div class="card-header">Machine <%= machineId %></div>
          <div class="card-content">
            <span>Machine Name:</span> <%= machineName %><br>
            <span>Department:</span> <%= department %><br>
            <span>Description:</span> <%= description %>
          </div>
           <input type="submit" value="request to take out"/>
        </div>
       
        </form>
  <% 
      }

      // Close the database connection
      machinesResult.close();
      //getMachinesStmt.close();
      connection.close();
    } catch (Exception e) {
      out.println("Error: " + e.getMessage());
      e.printStackTrace();
    }
  %>
      <!-- Request for pass content here -->
    </div>

    <div class="content" id="machinesWithYou">
      <h2>Machines with You</h2>
      <% 
    try {
      // Establish a database connection
      String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password = "123456";
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection conn = DriverManager.getConnection(url, username, password);
    String query = "SELECT * FROM gatepass WHERE eid=?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        String department=session.getAttribute("employee_id").toString();;
        pstmt.setInt(1, Integer.parseInt(department));
        ResultSet rs = pstmt.executeQuery();
        out.println("<table>");
        out.println("<tr><th>Gatepass Number</th><th>Machine ID</th><th>Requested Date</th><th>Problem Description</th><th>status</th><th>download</th></tr>");
        while (rs.next()) {
            String gatepassNumber = rs.getString("gid");
            String employeeId = rs.getString("mid");
            String machineId = rs.getString("rdate");
            String requestedDate = rs.getString("PDESCRIPTION");
            String problemDescription = rs.getString("status");

            out.println("<tr>");
            out.println("<td>" + gatepassNumber + "</td>");
            out.println("<td>" + employeeId + "</td>");
            out.println("<td>" + machineId + "</td>");
            out.println("<td>" + requestedDate + "</td>");
            out.println("<td>" + problemDescription + "</td>");
            if(problemDescription.equals("pending")||problemDescription.equals("rejected"))
            {
              //pass
            }
            else{
              out.println("<td>download pass</td>");
            }
            out.println("</tr>");
        }
        out.println("</table>");

        // Close database connections
        rs.close();
        pstmt.close();
        conn.close();

    } catch (SQLException e) {
        // Handle any errors
        e.printStackTrace();
        out.println("<h2>Error</h2>");
        out.println("<p>Failed to retrieve Gatepass details.</p>");
    }
  %>
      <!-- Machines with you content here -->
    </div>

    <div class="content" id="logout">
      <h2>Logout</h2>
      <!-- Logout content here -->
    </div>
  </div>

  <script>
    // Function to show/hide content based on button click
    function showContent(contentId) {
      // Hide all content
      var contents = document.getElementsByClassName("content");
      for (var i = 0; i < contents.length; i++) {
        contents[i].style.display = "none";
      }
      
      // Show selected content
      document.getElementById(contentId).style.display = "block";
    }
    showContent('requestPass');
  </script>
</body>
</html>
<%
}
else
{
    response.sendRedirect("index.html");
}
%>
