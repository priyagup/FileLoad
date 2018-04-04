<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript" src="jquery-3.2.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="style.css">
<title>Air Assist</title>
</head>
<body>
	<form method="post" action="uploadfile" encType="multipart/form-data" id="home" onsubmit="return Checkfiles(this);">
		<input type="file" name="file" id="file" />
		<p id="description">Drag your files here or click in this area.</p>
		<button type="submit">Upload</button>
	</form>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		$('form input').change(function() {
			$('#description').text(this.files.length + " file(s) selected");
		});
	});

	function Checkfiles() {
		var fup = document.getElementById('file');
		var fileName = fup.value;
		var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
		if (ext == "csv") {
			return true;
		} else {
			alert("Upload csv files only");
			fup.focus();
			return false;
		}
	}
</script>
</html>
