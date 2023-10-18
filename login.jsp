<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%@page import="javax.naming.*"%>
<%@ page language="java" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // Get the form inputs from request parameters
    String employeeId = request.getParameter("employee-number");
    String password = request.getParameter("password");
    
    out.println(employeeId+password);
    
    // Establish database connection
    Context initContext = new InitialContext();
    Connection conn = null;
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String username = "system";
    String password1 = "123456";
    try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn = DriverManager.getConnection(url, username, password1);
    }
    catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // Prepare and execute SQL query
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE employee_id = ? AND password = ?");
    stmt.setString(1, employeeId);
    stmt.setString(2, password);
    ResultSet rs = stmt.executeQuery();

    // Check if the result set has a row
    if (rs.next()) {
        String userType = rs.getString("TYPE");
        String homePage;
        
        session.setAttribute("employee_id", employeeId);
        
        
        // Determine the user's home page based on their type
        if (userType.equals("HOD")) {
            session.setAttribute("isLoggedIn", true);
            homePage = "hoddash.jsp";
        } else if(userType.equals("EMPLOYEE")){
            session.setAttribute("isLoggedIne", true);
            homePage = "employeehome.jsp";
        }
        else{
            session.setAttribute("isLoggedInc", true);
            homePage = "cisfhome.jsp";
        }
        
        // Redirect to the respective home page
        response.sendRedirect(homePage);
    } else {
        // Invalid credentials, show error message or redirect to an error page
        response.sendRedirect("index.html");
    }

    // Close database connections
    rs.close();
    stmt.close();
    conn.close();
%>
