<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.IOException"%>


<%@page import="java.util.Properties"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.PasswordAuthentication"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.internet.AddressException"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>



<%!




private static Message prepareMessage(Session mysession2,String myemail,String umob, String uaadhar, String uname, String uloc,String p_email) {
	Message message = new MimeMessage(mysession2);
	try {
		
		message.setFrom(new InternetAddress(myemail));
		message.setRecipient(Message.RecipientType.TO, new InternetAddress(p_email));
		message.setSubject("Emergency "+uaadhar+" at "+uloc);
		message.setText("Emergency\n\nName: "+uname+"\nMobile: "+umob+"\nAadhar: "+uaadhar+"\nCurrent location: "+uloc);
		return message;
	} catch (AddressException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (MessagingException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	return null;
}

%>
<!DOCTYPE html>
<html>
<head>
	<title>YouAreSafe</title>
	  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Anton&display=swap" rel="stylesheet">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>


</head>
<body>
<%
HttpSession mysession=request.getSession(); 
if(mysession.getAttribute("aadhar")==null){
	response.sendRedirect("login.jsp");
}
else if(mysession.getAttribute("location")==null){
	response.sendRedirect("home.jsp");
}

else{
%>

<%          


if(mysession.getAttribute("location")!=null){
Connection conn = null;
try {
	

	Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost:3306/javadbms";
    String user = "root";
    String dbpassword = "wiseone";
	
    
    conn = DriverManager.getConnection(url, user, dbpassword);
    String sql="insert into emergency values('"+mysession.getAttribute("aadhar")+"','"+mysession.getAttribute("location")+"','n');";
    Statement st = conn.createStatement(); 
    st.executeUpdate(sql); 
    

} catch(SQLException e) {
   System.out.println(e.getMessage());
} catch (ClassNotFoundException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
}



System.out.println("Sending...");

Properties props = new Properties();
props.put("mail.smtp.auth","true");
props.put("mail.smtp.starttls.enable","true");
props.put("mail.smtp.host","smtp.gmail.com");
props.put("mail.smtp.port","587");

String myemail = "theconscienceofficial@gmail.com";
String pwd = "conscience@google";

Session mysession2 = Session.getInstance(props, new Authenticator() {
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication(myemail,pwd);
	}
});


String umob = (String)mysession.getAttribute("mobile");
String uaadhar = (String)mysession.getAttribute("aadhar");
String uname = (String)mysession.getAttribute("name");
String uloc = (String)mysession.getAttribute("location");
String p_email = null;

Connection conn = null;
try {
	

	Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost:3306/javadbms";
    String user = "root";
    String dbpassword = "wiseone";
	
    
    conn = DriverManager.getConnection(url, user, dbpassword);
    String sql2="select p_email from policedata where control_string like '%"+uloc.charAt(0)+"%'";
    Statement st2 = conn.createStatement(); 
    ResultSet rs =st2.executeQuery(sql2); 
    
    while(rs.next()){
    	p_email = rs.getString(1);
    }

} catch(SQLException e) {
   System.out.println(e.getMessage());
} catch (ClassNotFoundException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}





Message message = prepareMessage(mysession2,myemail,umob,uaadhar,uname,uloc,p_email);

Transport.send(message);

System.out.println("Message sent successfully");
}
%>
	<div class="container">
        <div align="center" style="margin-top: 80px;font-family: 'Anton', sans-serif; font-size:40px;color: red;"><img src="alarm-gif.gif">
        <p class="sending">ALARMING POLICE...</p>
        </div>
        <br>
        <br>
        <br>
	</div>
	<div align="center">
		<button class="btn btn-default btn-sm" onclick="window.location.href='home.jsp'">Cancel</button>
	</div>

	

</body>
</html>