<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>갈보리 부활동산</title>

<!-- Bootstrap -->
<link href="${contextPath}/resources/bootstrap/css/bootstrap.css" rel="stylesheet">
<link rel="stylesheet" href="${contextPath}/resources/css/daterangepicker.css" />
<script type="text/javascript" src="${contextPath}/resources/js/jquery-3.3.1.min.js"></script>
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script> -->
<script src="${contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>
<script src="${contextPath}/resources/js/jquery.bootpag.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->
	
<!-- custom style -->
<link href="${contextPath}/resources/assets/css/style.css" rel="stylesheet">
<link rel="stylesheet" href="${contextPath}/resources/assets/css/topmenu.css"/>
<link rel="stylesheet" href="${contextPath}/resources/css/loadingbar.css">
<link rel="stylesheet" href="${contextPath}/resources/css/select2.min.css">
</head>

<body>
	
	<tiles:insertAttribute name="header"/>
	
	<!-- 컨텐츠 -->
	<div class="contents sample">

		<!-- sub-title -->
		<div class="sub-title">
			<c:choose>
				<c:when test="${!empty submenuName}"><h1>${submenuName}</h1></c:when>
				<c:otherwise><h1>${menuInfo.menu_name}</h1></c:otherwise>
			</c:choose>
		</div>

		<!-- breadcrumb -->
		<div class="breadcrumb_wrap">
			<div class="wrap">
				<ul class="breadcrumb">
					<li class="breadcrumb-item">홈</li>
					<li class="breadcrumb-item">${pMenuInfo.menu_name}</li>
					<li class="breadcrumb-item" aria-current="page">${menuInfo.menu_name}</li>
				</ul>
			</div>
		</div>
		
		<!-- 중간 컨텐츠 -->
		<div class="container-fluid section">
			<div class="wrap">
				<div class="row">
					<tiles:insertAttribute name="aside"/>
					<tiles:insertAttribute name="body"/>
				</div>
			</div>
		</div>
		
	</div>
	
	<tiles:insertAttribute name="footer"/>
	
	<script src="${contextPath}/resources/assets/js/topmenu.js"></script>

</body>
</html>