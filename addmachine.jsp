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
  String machineName = request.getParameter("mname");
  
  String eid=session.getAttribute("employee_id").toString();
  
  

  

  // Check if the file is an image (you can modify this condition as per your needs)
  

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
            
        }

    // Get the maximum machine ID from the machines table
    String getMaxMachineIdQuery = "SELECT MAX(machine_id) FROM machines";
    Statement getMaxMachineIdStmt = connection.createStatement();
    ResultSet maxMachineIdResult = getMaxMachineIdStmt.executeQuery(getMaxMachineIdQuery);
    int machineId = 1;

    if (maxMachineIdResult.next()) {
      machineId = maxMachineIdResult.getInt(1) + 1;
    }

    // Prepare the SQL query to insert the data into the machines table
    String insertMachineQuery = "INSERT INTO machines (machine_id, machine_name, department) VALUES (?, ?, ?, ?)";
    PreparedStatement insertMachineStmt = connection.prepareStatement(insertMachineQuery);
    insertMachineStmt.setInt(1, machineId);
    insertMachineStmt.setString(2, machineName);
    insertMachineStmt.setString(3, fileName);
    insertMachineStmt.setString(4, department);

    // Execute the SQL query to insert the data into the machines table
    insertMachineStmt.executeUpdate();

    // Save the file to a specific location if needed
    String saveDirectory = "/machine";
    Files.copy(fileContent, new File(saveDirectory + fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);

    // Close the database connection
    insertMachineStmt.close();
    getMaxMachineIdStmt.close();
    connection.close();

    out.println("Machine added successfully.");
  } catch (Exception e) {
    out.println("Error: " + e.getMessage());
    e.printStackTrace();
  }
%>
