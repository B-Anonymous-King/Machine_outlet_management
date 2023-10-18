<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      padding: 20px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }

    th, td {
      padding: 10px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }

    th {
      background-color: #4CAF50;
      color: #fff;
    }

    tr:nth-child(even) {
      background-color: #f2f2f2;
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
<%
//HttpSession session = request.getSession(false); // Pass 'false' to not create a new session

if (session != null && session.getAttribute("isLoggedIn") != null && (boolean) session.getAttribute("isLoggedIn")) {
  // Session is active
%>
<%
  String machineName = request.getParameter("mname");
  String description=request.getParameter("description");

  try {
    // Establish a database connection
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password = "123456";
    String department=session.getAttribute("employee_id").toString();
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection connection = DriverManager.getConnection(url, username, password);

    // Get the maximum machine ID from the machines table
    String getMaxMachineIdQuery = "SELECT MAX(machine_id) FROM machine";
    Statement getMaxMachineIdStmt = connection.createStatement();
    ResultSet maxMachineIdResult = getMaxMachineIdStmt.executeQuery(getMaxMachineIdQuery);
    int machineId = 1;

    if (maxMachineIdResult.next()) {
      machineId = maxMachineIdResult.getInt(1) + 1;
    }
    String insertQuery="select department from employees where EMPLOYEE_ID= ?";
        PreparedStatement stmt = connection.prepareStatement(insertQuery);
        department=session.getAttribute("employee_id").toString();;
        stmt.setInt(1,Integer.parseInt(department));
        //designationst.setInt(1,100023576);
        
        ResultSet rs=stmt.executeQuery();
        
        if(rs.next())
        {
            
            department=rs.getString(1);
            
        }

    // Prepare the SQL query to insert the data into the machines table
    String insertMachineQuery = "INSERT INTO machine (machine_id, machine_name,department,description) VALUES (?, ?, ?, ?)";
    PreparedStatement insertMachineStmt = connection.prepareStatement(insertMachineQuery);
    insertMachineStmt.setInt(1, machineId);
    insertMachineStmt.setString(2, machineName);
    insertMachineStmt.setString(3,department );
    insertMachineStmt.setString(3,description);


    // Execute the SQL query to insert the data into the machines table
    insertMachineStmt.executeUpdate();

    // Close the database connection
    insertMachineStmt.close();
    getMaxMachineIdStmt.close();
    connection.close();%>
    <table>
    <tr>
      <th>Machine ID</th>
      <th>Machine Name</th>
      <th>Department</th>
      <th>description</th>
    </tr>
    <tr>
      <td><%=machineId%></td>
      <td><%=machineName%></td>
      <td><%=department%></td>
      <td><%=description%></td>
    </tr>
    
  </table>
  <a href="hoddash.jsp">Go to  Dashboard</a>


   <% 
  } catch (Exception e) {
    out.println("Error: " + e.getMessage());
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
