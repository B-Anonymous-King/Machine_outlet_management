<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%
//HttpSession session = request.getSession(false); // Pass 'false' to not create a new session

if (session != null && session.getAttribute("isLoggedInc") != null && (boolean) session.getAttribute("isLoggedInc")) {
  // Session is active
%>
<!DOCTYPE html>
<html>
<head>
  <title>CISF Dashboard</title>
  <style>
    body {
      background-color: #f1f1f1;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
     body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
    }
    
    .form-container {
      width: 300px;
      margin: 0 auto;
    }
    
    .form-group {
      margin-bottom: 10px;
    }
    
    .form-label {
      display: block;
      margin-bottom: 5px;
    }
    
    .form-input {
      width: 100%;
      padding: 8px;
      border-radius: 5px;
      border: 1px solid #dddddd;
    }
    
    .form-submit {
      background-color: #55efc4;
      color: #ffffff;
      padding: 10px 20px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
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
  </style>
</head>
<body>
  <div class="header">
    <h1>CISF Dashboard</h1>
    <p>Employee ID: <span id="employeeId"><%= session.getAttribute("employee_id") %></span></p>
  </div>

  <div class="container">
    <div class="navbar">
      <a href="#" onclick="showContent('enterMachineOut')">Enter Machine Out</a>
      <a href="#" onclick="showContent('letMachineIn')">Let Machine In</a>
      <a href="logout.jsp" onclick="showContent('logout')">Logout</a>
    </div>

    <div class="content" id="enterMachineOut">
      <h2>Enter Machine Out</h2>
      <div class="form-container">
    <form action="showgp.jsp" method="post">
      <div class="form-group">
        <label for="gid" class="form-label">Gatepass ID:</label>
        <input type="number" id="gid" name="gid" class="form-input" required>
      </div>
      <input type="submit" value="Show Details" class="form-submit">
    </form>
  </div>
      <!-- Enter machine out content here -->
    </div>

    <div class="content" id="letMachineIn">
      <h2>Let Machine In</h2>
       <div class="form-container">
    <form action="showgp1.jsp" method="post">
      <div class="form-group">
        <label for="gid" class="form-label">Gatepass ID:</label>
        <input type="number" id="gid" name="gid" class="form-input" required>
      </div>
      <input type="submit" value="Show Details" class="form-submit">
    </form>
  </div>
      <!-- Let machine in content here -->
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
    showContent('enterMachineOut');
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
