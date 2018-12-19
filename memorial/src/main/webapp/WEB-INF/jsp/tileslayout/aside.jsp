<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="col-md-3 hidden-xs hidden-sm">
	<div id="sidemenu" class="side-menu">
		<h2>Menu</h2>
		<!-- 1 Level -->
		<c:forEach items="${menuList}" var="menu">
			<div class="panel">
				<div class="depth1">
					<c:choose>
						<c:when test="${menu.menu_seq eq pmenuSeq}">
							<a data-toggle="collapse" data-parent="#sidemenu" aria-expanded="true" href="#${menu.menu_seq}">
								${menu.menu_name}
							</a>
						</c:when>
						<c:otherwise>
							<a data-toggle="collapse" data-parent="#sidemenu" aria-expanded="false" href="#${menu.menu_seq}">
								${menu.menu_name}
							</a>
						</c:otherwise>
					</c:choose>
				</div>
				<c:choose>
					<c:when test="${menu.menu_seq eq pmenuSeq}">
						<ul id="${menu.menu_seq}" class="collapse in depth2">
					</c:when>
					<c:otherwise>
						<ul id="${menu.menu_seq}" class="collapse depth2">
					</c:otherwise>
				</c:choose>
						<!-- 2 Level -->
						<c:forEach items="${menu.children}" var="menu">
							<li>
							<c:choose>
								<c:when test="${menu.menu_seq eq menuSeq}">
									<a class="active" href="${menu.menu_url}">${menu.menu_name}</a>
								</c:when>
								<c:otherwise>
									<a href="${menu.menu_url}">${menu.menu_name}</a>
								</c:otherwise>
							</c:choose>
							</li>
						</c:forEach>
						</ul>
			</div>
		</c:forEach>
	</div>
</div>