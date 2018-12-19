<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<style type="text/css">
</style>
<link rel="stylesheet" href="${contextPath}/resources/css/loadingbar.css">
<title>Login</title>

</head>
<body>
<form action="/account/login.do" method="post">
	<input type="text">
	<input type="password">
</form>
</body>
<script type="text/javascript" src="${contextPath}/resources/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
common.loading(true);
setTimeout(function(){
	common.loading(false);
}, 2000);
</script>
</html>