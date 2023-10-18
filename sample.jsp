<%@ page import="org.xhtmlrenderer.pdf.ITextRenderer" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%
String inputHtmlPath = "letter.html";
        String outputPdfPath = "output.pdf";
        
        try {
            // Create an instance of ITextRenderer
            ITextRenderer renderer = new ITextRenderer();

            // Read the input HTML file
            String inputFileUrl = new File(inputHtmlPath).toURI().toURL().toString();

            // Set the input HTML content
            renderer.setDocument(inputFileUrl);
            
            // Render the PDF
            renderer.layout();
            
            // Create an output stream to save the PDF
            OutputStream outputStream = new FileOutputStream(outputPdfPath);
            
            // Write the PDF content to the output stream
            renderer.createPDF(outputStream);
            
            // Close the output stream
            outputStream.close();
            
            System.out.println("PDF created successfully at: " + outputPdfPath);
        } catch (Exception e) {
            System.err.println("Error converting HTML to PDF: " + e.getMessage());
        }

%>

