<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

		<!-- 메뉴 -->
		<nav id="menu" class="menu">
			<ul class="depth1">
				<!-- 1 Level -->
				<c:forEach items="${menuList}" var="menu">
					<li class="item">
						<a href="${menu.menu_url}">${menu.menu_name}</a>
						<ul class="depth2">
							<div class="wrap">
								<li class="menu_group">
									<ul>
									<!-- 2 Level -->
									<c:forEach items="${menu.children}" var="menu">
										<li><a href="${menu.menu_url}">${menu.menu_name}</a></li>
									</c:forEach>
									</ul>
								</li>
							</div>
						</ul>
					</li>
				</c:forEach>
				<div class="bx_sub hidden-xs">
					<div class="wrap">
						<c:forEach items="${menuList}" var="menu">
						<!-- 메뉴선택시 서브메뉴 영역에 보일 텍스트 -->
						<h2 class="title">${menu.menu_name}</h2>
						</c:forEach>
					</div>
				</div>
			</ul>
			<ul class="link-bar pull-right">
				<c:choose>
					<c:when test="${not empty sessionVo}">
					<li class="item"><a href="javascript:void(0)" onclick="_logout()">로그아웃</a></li>
					</c:when>
					<c:otherwise>
					<li class="item"><a href="${contextPath}/account/login">로그인</a></li>
					<li class="item"><a href="${contextPath}/account/join">회원가입</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
		</nav>
	</div>
</header>

<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">

/**
 * 로그아웃처리
 */
function _logout() {
	common.ajax({
		url:"${contextPath}/account/logout", 
		data:{},
		success: function(result) {
			if(result) {
				location.replace('${contextPath}/main/index');
			}
		}
	});
}
</script>