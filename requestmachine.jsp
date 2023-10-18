<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%
//HttpSession session = request.getSession(false); // Pass 'false' to not create a new session

if (session != null && session.getAttribute("isLoggedIne") != null && (boolean) session.getAttribute("isLoggedIne")) {
  // Session is active
  String mid=request.getParameter("mid");
  //String department=request.getParameter("department");
  //out.println(department);
  String mname=request.getParameter("mname");
  String department=null;
  //out.println(mid);
%>
<!DOCTYPE html>
<html>
<head>
  <title>Report Problem</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      padding: 20px;
    }

    h1 {
      color: #55efc4;
    }

    label {
      display: block;
      margin-bottom: 10px;
      color: #55efc4;
    }

    input[type="text"],
    input[type="number"],
    input[type="date"],
    textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #55efc4;
      border-radius: 4px;
      box-sizing: border-box;
      margin-bottom: 10px;
    }

    input[type="text"]:focus,
    input[type="number"]:focus,
    input[type="date"]:focus,
    textarea:focus {
      outline: none;
      border-color: #7CB342;
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
      background-color: #7CB342;
    }

    input[type="submit"]:focus {
      outline: none;
    }
    a.button {
      display: inline-block;
      padding: 10px 20px;
      background-color: #55efc4;
      color: #ffffff;
      text-decoration: none;
      border-radius: 4px;
      border: none;
      cursor: pointer;
    }

    a.button:hover {
      background-color: #00b894;
    }
  </style>
</head>
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
<body>
  <h1>Report Problem</h1>
  <form action="sendrequest.jsp" method="post">
    <label for="problem">Problem Description</label>
    <textarea id="problem" name="problem" rows="4" required></textarea>

    <label for="expectedDays">Expected Number of Days</label>
    
    <input type="number" id="expectedDays" name="expectedDays" required>

    
   <% out.println("<input type='hidden' name='mid' value="+mid+">"); %>
   <% out.println("<input type='hidden' name='department' value="+department+">"); %>
   <% out.println("<input type='hidden' name='mname' value="+mname+">"); %>
    <input type="submit" value="Submit">
    <a href="employeehome.jsp" class="button">back</a>
  </form>
</body>
</html>
<%
}
else
{
    response.sendRedirect("index.html");
}
%>
