<%@ page language="java" contentType="text/html; charset=UTF8"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>Test JS</title>
<script type="text/javascript">
$(document).ready(function(){
	  $("a").on('click', function(event) {
	      $('html, body').animate({scrollTop: $('#textemail').offset().top}, 2000);
	  });
	});
</script>
</head>
<body>
<p> Test </p>
<input type="button" value="Test" name="test" onclick="getHeight();" />
</body>
</html>