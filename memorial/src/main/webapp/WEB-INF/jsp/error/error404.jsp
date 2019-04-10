<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="org.slf4j.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page isErrorPage="true" %> <%@ page import="java.io.PrintWriter"%> 
<%@ page import="java.io.ByteArrayOutputStream"%> 
<%
// Logger logger = LoggerFactory.getLogger("ERROR_LOGGER");
// String errorType = exception.getClass().getName();
// String errorMessage = exception.getMessage();
// logger.error("error type : " + errorType);
// logger.error("error message : " + errorMessage);
// logger.error("print error!!\n", exception);
%>
<!doctype html>
<html> 
<head> 
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<title>에러 발생</title>

<!-- Bootstrap -->
<link href="${contextPath}/resources/bootstrap/css/bootstrap.css" rel="stylesheet">
<link rel="stylesheet" href="${contextPath}/resources/css/daterangepicker.css" />
<script type="text/javascript" src="${contextPath}/resources/js/jquery-3.3.1.min.js"></script>
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script> -->
<script src="${contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>
<script src="${contextPath}/resources/js/jquery.bootpag.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
	
<!-- custom style -->
<link href="${contextPath}/resources/assets/css/style.css" rel="stylesheet">
<link rel="stylesheet" href="${contextPath}/resources/assets/css/topmenu.css"/>
<link rel="stylesheet" href="${contextPath}/resources/css/loadingbar.css">
<link rel="stylesheet" href="${contextPath}/resources/css/select2.min.css">
 
</head> 

<body>
	<header> 
		<div class="wrap">
			<!-- 모바일용 메뉴버튼 -->
			<div class="menu-toggle">
				<input type="checkbox" id="menu-ckb"/>
				<label for="menu-ckb" class="menu-lines">
					<span></span>
					<span></span>
					<span></span>
				</label>
			</div>
			<!-- 사이트 로고 -->
			<a class="logo" href="${contextPath}/main/index">
				<img src="${contextPath}/resources/assets/images/logo_w.png" alt="">
			</a>
	
		</div>
	</header>

	<!-- 컨텐츠 -->
	<div class="contents sample">
		<div class="row" style="margin-top: 100px;">
			<div class="col-xs-6" style="margin: 0 auto; float: none; text-align: center;">
				<span style="font-size: 70px;">Page Not Found</span>
			</div>
		</div>
	</div> 
	
</body> 
</html>