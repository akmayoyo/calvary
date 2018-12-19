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
		<a class="logo" href="#">
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
							<div class="group wrap">
								<div class="menu-title hidden-xs"><h2>${menu.menu_name}</h2></div>
								<!-- 2 Level -->
								<c:forEach items="${menu.children}" var="menu">
									<li>
										<a href="${menu.menu_url}">${menu.menu_name}</a>
										<ul class="depth3">
										<!-- 3 Level -->
										<c:forEach items="${menu.children}" var="menu">
											<li><a href="${menu.menu_url}">${menu.menu_name}</a></li>
										</c:forEach>
										</ul>
									</li>
								</c:forEach>
							</div>
						</ul>
					</li>
				</c:forEach>
			</ul>
			<ul class="link-bar pull-right">
				<li class="item"><a href="#">로그인</a></li>
				<li class="item"><a href="#">회원가입</a></li>
			</ul>
		</nav>
	</div>
</header>