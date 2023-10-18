<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
//HttpSession session = request.getSession(false); // Pass 'false' to not create a new session

if (session != null && session.getAttribute("isLoggedIne") != null && (boolean) session.getAttribute("isLoggedIne")) {
    String department=null;
    %>
<!DOCTYPE html>
<html>
<head>
    <title>Gate Pass Form</title>
    <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      margin: 0;
      padding: 20px;
    }
    
    h1 {
      color: #333333;
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
        department=session.getAttribute("employee_id").toString();;
        stmt.setInt(1,Integer.parseInt(department));
        //designationst.setInt(1,100023576);
        
        ResultSet rs=stmt.executeQuery();
        
        if(rs.next())
        {
            
            department=rs.getString(1);
            //out.println(department);
            
        }
    }
        catch  (Exception e) {
      out.println("Error: " + e.getMessage());
      e.printStackTrace();
    }
  %>
    <% 
        // Retrieve form inputs
        String pdescription = request.getParameter("problem");
        int ndays = Integer.parseInt(request.getParameter("expectedDays"));
        String dateTaking = java.time.LocalDate.now().toString();
        int eid=Integer.parseInt(session.getAttribute("employee_id").toString());
        //String department=request.getParameter("department");
        int mid=Integer.parseInt(request.getParameter("mid"));
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
        // Database connection details
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String username = "system";
        String password = "123456";
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // Establish a database connection
            Connection conn = DriverManager.getConnection(url, username, password);

            // Generate gatepass ID
            int gatepassId = 0;
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT MAX(gid) FROM gatepass");
            if (rs.next()) {
                gatepassId = rs.getInt(1) + 1;
            }
            
            // Insert data into gatepass table
            //out.println(dateTaking);
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO gatepass (gid, pdescription, ndays, rdate, eid, department, status, mid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1, gatepassId);
            pstmt.setString(2, pdescription);
            pstmt.setInt(3, ndays);
            pstmt.setString(4, dateTaking);
            pstmt.setInt(5,eid);
            pstmt.setString(6,department);
            pstmt.setString(7,"pending");
            pstmt.setInt(8,mid);
            
            pstmt.executeUpdate();
            //out.println(department);
            // Close database connections
            //pstmt.close();
            //stmt.close();
            conn.close();%>
            <h1>Gatepass Details</h1>

  <div class="gatepass-card">
    <p><span class="label">Gatepass Number:</span> <%=gatepassId%></p>
    <p><span class="label">Employee Number:</span> <%=eid%></p>
    <p><span class="label">Machine ID:</span> <%=mid%></p>
    <p><span class="label">Requested Date:</span> <%=dateTaking%></p>
    <p><span class="label">Problem Description:</span> <%=pdescription%></p>
    <p>request is sent to your department HOD after approval you can get gate pass</p>
  </div>
<a href="employeehome.jsp">Go to  Dashboard</a>
            
            <%
        } catch (SQLException e) {
            // Handle any errors
            e.printStackTrace();
            out.println("<h1>Error</h1>");
            out.println("<p>Failed to add Gate Pass.</p>");
        }
    %>
</body>
</html>
<%
}
else
{
    response.sendRedirect("index.html");
}
%>
