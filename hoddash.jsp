<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>HOD Dashboard</title>
  <style>
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
    .form-group {
      margin-bottom: 20px;
    }
    
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #333;
    }
    
    .form-group input {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
    }
    input[type="submit"] {
      background-color: #55efc4;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
      width: 100%;
    }
    
    input[type="submit"]:hover {
      background-color: #00b894;
    }
    .button {
      background-color: #55efc4;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
    }
    
    .button:hover {
      background-color: #00b894;
    }
    input[type="file"] {
      position: relative;
      overflow: hidden;
      display: inline-block;
      cursor: pointer;
      background-color: #ddd;
      color: #333;
      border: 1px solid #999;
      padding: 10px 20px;
      border-radius: 5px;
    }
    
    input[type="file"]::-webkit-file-upload-button {
      visibility: hidden;
    }
    
    input[type="file"]::before {
      content: 'Choose File';
      display: inline-block;
      vertical-align: middle;
    }
    
    input[type="file"]:hover {
      background-color: #ccc;
    }
    textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #55efc4;
      border-radius: 4px;
      box-sizing: border-box;
      margin-bottom: 10px;
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
     .gatepass-card {
      background-color: #ffffff;
      border-radius: 5px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      padding: 20px;
      margin-bottom: 20px;
    }
    
    .gatepass-card p {
      margin: 0;
      padding: 5px 0;
    }
    
    .gatepass-card .label {
      font-weight: bold;
    }
  </style>
</head>
<%
//HttpSession session = request.getSession(false); // Pass 'false' to not create a new session

if (session != null && session.getAttribute("isLoggedIn") != null && (boolean) session.getAttribute("isLoggedIn")) {
  // Session is active
%>
<body>
  <div class="header">
    <h1>HOD Dashboard</h1>
    <p>Employee ID: <span id="employeeId"><%= session.getAttribute("employee_id") %></span></p>
    
  </div>

  <div class="container">
    <div class="navbar">
      <a href="#" onclick="showContent('addEmployee')">Add Employee</a>
      <a href="#"   onclick="showContent('addMachine')">Add Machine</a>
      <a href="#"   onclick="showContent('addSubMachine')">show machines available</a>
      <a href="#"   onclick="showContent('acceptGatePass')">Accept Gate Pass</a>
      <a href="logout.jsp" onclick="showContent('logout')">Logout</a>
    </div>

    <div class="content" id="addEmployee">
      
      
        <h2>Add Employee</h2>
        <form action="addemployee.jsp" method="post">
          <div class="form-group">
            <label for="name">Employee Name</label>
            <input type="text" id="name" name="name" required>
          </div>
          <div class="form-group">
            <label for="password">password</label>
            <input type="password" id="password" name="password" required>
          </div>
          <div class="form-group">
            <label for="designation">Designation</label>
            <input type="text" id="designation" name="designation" required>
          </div>
          <div class="form-group">
            <label for="mobile">Mobile Number</label>
            <input type="tel" id="mobile" name="mobile" pattern="[0-9]{10}" required>
          </div>
          <input type="submit" value="add"/>
        </form>
    
      <!-- Add employee content here -->
    </div>

    <div class="content" id="addMachine">
      <h2>Add Machine</h2>
      <form action="addmachines.jsp" method="post">
        <div class="form-group">
          <label for="mname">machine Name</label>
          <input type="text" id="mname" name="mname" required>
          <label for="description">Description</label>
    <textarea id="description" name="description" rows="4" required></textarea>
        </div>
        
        
        <input type="submit" value="add"/>
      </form>

      

      <!-- Add machine content here -->
    </div>

    <div class="content" id="addSubMachine">
      <h2>show machines</h2>
        <% 
        String department=null;
    try {
      // Establish a database connection
      String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password = "123456";
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection connection = DriverManager.getConnection(url, username, password);
    String insertQuery="select department from employees where EMPLOYEE_ID= ?";
        PreparedStatement stmt = connection.prepareStatement(insertQuery);
        department=session.getAttribute("employee_id").toString();;
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
        

  %>
  
        
        
        <div class="card">
          <div class="card-header">Machine <%= machineId %></div>
          <div class="card-content">
            <span>Machine Name:</span> <%= machineName %><br>
            <span>Department:</span> <%= department %><br>
            <span>Description:</span> <%= description %>
          </div>
           
        </div>
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
      <!-- Add sub-machine content here -->
    </div>

    <div class="content" id="acceptGatePass">
      <h2>Accept Gate Pass</h2>
      <% 
    // Database connection details
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password = "123456";
    
    try {
        // Establish a database connection
        Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection conn = DriverManager.getConnection(url, username, password);

        // Query to retrieve gatepass details
        String insertQuery = "SELECT * FROM gatepass WHERE status='pending' AND department= ?";
        PreparedStatement stmt = conn.prepareStatement(insertQuery);
        stmt.setString(1,department);
        //designationst.setInt(1,100023576);
        
        ResultSet rs=stmt.executeQuery();
        
        
        //ResultSet rs = stmt.executeQuery(query);
        
        // Loop through the result set and display gatepass details in cards
        while (rs.next()) {
            String gatepassNumber = rs.getString("gid");
            String employeeNumber = rs.getString("eid");
            String machineId = rs.getString("mid");
            String requestedDate = rs.getString("rdate");
            String problemDescription = rs.getString("pdescription");
            insertQuery = "SELECT * FROM employees WHERE EMPLOYEE_ID	= ?";
          stmt = conn.prepareStatement(insertQuery);
          stmt.setInt(1,Integer.parseInt(employeeNumber));
          
          ResultSet rs1=stmt.executeQuery();
          rs1.next();
          
          String employeename = rs1.getString("EMPLOYEE_NAME");
          String mnum = rs1.getString("MOBILE_NUMBER");
          insertQuery = "SELECT * FROM machine WHERE MACHINE_ID	= ?";
          stmt = conn.prepareStatement(insertQuery);
          stmt.setInt(1,Integer.parseInt(machineId));
          
          rs1=stmt.executeQuery();
          rs1.next();
          String mname = rs1.getString("MACHINE_NAME");
          String mdes = rs1.getString("DESCRIPTION");

            // Display gatepass details in a card
            out.println("<div class='gatepass-card'>");
            out.println("<p><span class='label'>Gatepass Number:</span> " + gatepassNumber + "</p>");
            out.println("<p><span class='label'>Employee Number:</span> " + employeeNumber + "</p>");
             out.println("<p><span class='label'>Employee name:</span> " + employeename + "</p>");
              out.println("<p><span class='label'>Employee mobile Number:</span> " + mnum + "</p>");
            out.println("<p><span class='label'>Machine ID:</span> " + machineId + "</p>");
            out.println("<p><span class='label'>Machine name:</span> " + mname + "</p>");
            out.println("<p><span class='label'>Machine description:</span> " + mdes + "</p>");
            out.println("<p><span class='label'>Requested Date:</span> " + requestedDate.substring(0,10) + "</p>");
            out.println("<p><span class='label'>Problem Description:</span> " + problemDescription + "</p>");
            out.println("<form action='acceptgp.jsp' method='post'>");
        out.println("<input type='hidden' name='gid' value="+gatepassNumber+">");
        out.println("<input type='submit' value='accept'></form><br>");
        out.println("<form action='rejectgp.jsp' method='post'>");
        out.println("<input type='hidden' name='gid' value="+gatepassNumber+">");
        out.println("<input type='submit' value='reject' style='background-color: #ff0000'></form><br><br>");
            out.println("</div>");
        }

        // Close database connections
        rs.close();
        stmt.close();
        conn.close();

    } catch (SQLException e) {
        // Handle any errors
        e.printStackTrace();
        out.println(e);
        out.println("<p>Failed to retrieve Gatepass details.</p>");
    }
  %>
      <!-- Accept gate pass content here -->
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
    showContent('addEmployee');
  </script>
</body>
<%
}
else
{
    response.sendRedirect("index.html");
}
%>
</html>
