<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Employee Details</title>
  <style>
    body {
      background-color: #f4f4f4;
      font-family: Arial, sans-serif;
    }
    
    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
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
    
    h1 {
      text-align: center;
      margin-bottom: 30px;
    }
    
    p {
      margin-bottom: 10px;
    }
    
    .details {
      margin-top: 20px;
    }
    
    .details table {
      width: 100%;
      border-collapse: collapse;
    }
    
    .details th,
    .details td {
      padding: 8px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    
    .details th {
      background-color: #f2f2f2;
    }
  </style>
</head>
<%
    // Retrieve form inputs
    String name = request.getParameter("name");
    String designation = request.getParameter("designation");
    String mobile = request.getParameter("mobile");
    String pwd=request.getParameter("password");

    // Database connection details
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password = "123456";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Connect to the database
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, username, password);
        //out.println(session.getAttribute("employee_id"));
        // Retrieve the max employee_id from the employees table
        int maxEmployeeId = 0;
        String maxIdQuery = "SELECT MAX(employee_id) FROM employees";
        Statement maxIdStmt = conn.createStatement();
        ResultSet rs = maxIdStmt.executeQuery(maxIdQuery);
        if (rs.next()) {
            maxEmployeeId = rs.getInt(1);
        }
        
        maxEmployeeId++; // Increment to get the next employee_id
        String insertQuery="select department from employees where EMPLOYEE_ID= ?";
        stmt = conn.prepareStatement(insertQuery);
        String department=session.getAttribute("employee_id").toString();;
        stmt.setInt(1,Integer.parseInt(department));
        //designationst.setInt(1,100023576);
        
        rs=stmt.executeQuery();
        
        if(rs.next())
        {
            
            department=rs.getString(1);
            
        }
        insertQuery = "INSERT INTO users (EMPLOYEE_ID, PASSWORD, TYPE) VALUES (?, ?, ?)";
        stmt = conn.prepareStatement(insertQuery);
        stmt.setInt(1,maxEmployeeId);
        stmt.setString(2, pwd);
        
        stmt.setString(3, "EMPLOYEE");
        
        stmt.executeUpdate();

        // Insert the new employee record into the employees table
        insertQuery= "INSERT INTO employees (employee_id, EMPLOYEE_NAME, designation, MOBILE_NUMBER	, department) VALUES (?, ?, ?, ?, ?)";
        stmt = conn.prepareStatement(insertQuery);
        stmt.setInt(1,maxEmployeeId);
        stmt.setString(2, name);
        stmt.setString(3, designation);
        stmt.setString(4, mobile);
        stmt.setString(5,department);
        stmt.executeUpdate();%>
        <body>
  <div class="container">
    <h1>Employee Added Successfully</h1>
    
    <div class="details">
      <table>
        <tr>
          <th>Employee ID</th>
          <td><%=maxEmployeeId%></td>
        </tr>
        <tr>
          <th>Employee Name</th>
          <td><%=name%></td>
        </tr>
        <tr>
          <th>Password</th>
          <td><%=pwd%></td>
        </tr>
        <tr>
          <th>Mobile Number</th>
          <td><%=mobile%></td>
        </tr>
        <tr>
          <th>Designation</th>
          <td><%=designation%></td>
        </tr>
        <tr>
          <th>Department</th>
          <td><%=department%></td>
        </tr>
        
      </table>
      <div>
    <a href="hoddash.jsp">Go to  Dashboard</a>
  </div>
    </div>
  </div>
</body>
        
       <% 
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        out.println(e);
    } finally {
        // Close the database connections
        if (stmt != null) {
            stmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
