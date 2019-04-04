<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" name="bunyangSeq">
	<input type="hidden" name="userId">
	<input type="hidden" name="sectionSeq">
	<input type="hidden" name="seqNo">
</form>
<c:choose>
<c:when test="${isOccupied }">
<script type="text/javascript">
	alert('이미 사용(봉안)중인 사용자입니다.');
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
</script>
</c:when>
<c:otherwise>
<header class="m_header">
	<!-- 사이트 로고 -->
	<a class="logo" href="${contextPath}/mobile/main">
		<img src="${contextPath}/resources/assets/images/logo_w.png" alt="" style="width: 145px;">
	</a>

	<!-- 로그아웃 -->
	<div class="pull-right bx_logout">
		<a href="http://b2b.yonginparklife.com/mobile.b2b/m.index.asp#" target="_blank" style="display: inline-block;">용인공원</a>
		<a href="javascript:void(0)" onclick="_logout()" style="display: inline-block;">로그아웃</a></li>
	</div>
</header>

<!-- 컨텐츠 -->
<div class="m_contents">
	
	<!-- 아코디언 메뉴 -->
	<div id="m_menu" class="m_menu">
		
		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">추모동산 배치도</a>
			</div>
			<div id="menu2">
				<div class="padding-15" style="border-bottom: 1px solid #e7e7e7;">
					<img alt="" src="${contextPath}/resources/assets/images/grave.png" style="width: 100%; border: 1px solid #f0f0f0;">
				</div>
			</div>
		</div>

		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">사용(봉안) 신청정보</a>
			</div>
			<div id="menu2">
				<div class="padding-15">
					<table class="table m_table">
						<colgroup>
							<col width="30%">
							<col width="70%">
						</colgroup>
						<tbody>
							<tr>
								<th scope="sel">사용(봉안)자</th>
								<td class="text-left">${useUserInfo.user_name}</td>
							</tr>
							<tr>
								<th scope="sel">장묘형태</th>
								<td class="text-left">
									<c:choose>
            							<c:when test="${!empty useUserInfo.couple_seq}">부부형</c:when>
            							<c:otherwise>1인형</c:otherwise>
            						</c:choose>
								</td>
							</tr>
							<tr>
								<th scope="sel">구역</th>
								<td class="text-left">
									<c:choose>
										<c:when test="${!empty assignedGraveInfo}">${assignedGraveInfo.section_seq}</c:when>
										<c:otherwise>
											<select id="selGraveSection" class="form-control" onchange="_changeGraveSection()">
											<c:forEach items="${avaliableGraveList}" var="rowItem">
												<option value="${rowItem.section_seq}" rowSeq="${rowItem.row_seq}" colSeq="${rowItem.col_seq}"  seqNo="${rowItem.seq_no}">${rowItem.section_seq}</option>
											</c:forEach>
											</select>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th scope="sel">사용(봉안)위치</th>
								<td class="text-left">
									<a id="aDetailGraveInfo" href="javascript:void(0);" style="padding: 5px 0;" onclick="_showGraveMap()"></a>
									<span style="color: #007BFF;">※사용(봉안)위치는 선택하신 구역내 순차적으로 배정됩니다.</span>
								</td>
							</tr>
						</tbody>
					</table>
    				
    				<div style="background-color: #E0EFFC; padding: 10px 10px; margin-top: 15px;">
    					<div style="text-align: center;">
							<h4 style="display: inline-block;">[가구역] 사용(봉안)위치 정보</h3>
						</div>
						<div style="text-align: center; margin-top: 5px;">
							<div style="width: 10px; height: 10px; background-color: #BFBFBF; display: inline-block;">
							</div>
							<span>사용중</span>
							<div style="width: 10px; height: 10px; background-color: #007BFF; display: inline-block; margin-left: 15px;">
							</div>
							<span>배정구역</span>
						</div>
						
						<div id="grid1" style="text-align: center; margin-top: 20px;">
			<svg height="286"><g class="row"><rect class="square" x="169" y="1" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="193" y="1" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="1" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="1" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="1" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="179" y="11.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">15</text><text x="203" y="11.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="11.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="11.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="11.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="145" y="20" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="169" y="20" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="20" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="20" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="20" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="20" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="155" y="30.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">14</text><text x="179" y="30.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="30.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="30.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="30.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="30.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="145" y="39" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="169" y="39" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="39" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="39" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="39" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="39" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="155" y="49.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">13</text><text x="179" y="49.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="49.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="49.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="49.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="49.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="121" y="58" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="145" y="58" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="58" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="58" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="58" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="58" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="58" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="131" y="68.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">12</text><text x="155" y="68.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="68.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="68.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="68.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="68.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="68.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="121" y="77" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="145" y="77" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="77" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="77" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="77" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="77" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="77" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="131" y="87.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">11</text><text x="155" y="87.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="87.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="87.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="87.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="87.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="87.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="121" y="96" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="145" y="96" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="96" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="96" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="96" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="96" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="96" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="131" y="106.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">10</text><text x="155" y="106.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="106.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="106.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="106.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="106.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="106.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="121" y="115" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="145" y="115" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="115" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="115" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="115" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="115" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="115" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="131" y="125.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">9</text><text x="155" y="125.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="125.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="125.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="125.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="125.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="125.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="97" y="134" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="121" y="134" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="145" y="134" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="134" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="134" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="134" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="134" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="134" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="107" y="144.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">8</text><text x="131" y="144.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="144.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="144.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="144.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="144.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="144.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="144.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="97" y="153" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="121" y="153" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="145" y="153" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="153" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="153" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="153" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="153" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="153" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="107" y="163.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">7</text><text x="131" y="163.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="163.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="163.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="163.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="163.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="163.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="163.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="73" y="172" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="97" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="121" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1; cursor: default;"></rect><rect class="square" x="145" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1; cursor: default;"></rect><rect class="square" x="193" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1; cursor: default;"></rect><rect class="square" x="217" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="172" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="83" y="182.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">6</text><text x="107" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">B</text><text x="131" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="182.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="73" y="191" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="97" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="121" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="145" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1; cursor: default;"></rect><rect class="square" x="241" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="191" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="83" y="201.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">5</text><text x="107" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">B</text><text x="131" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="201.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="73" y="210" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="97" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="121" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="145" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="210" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="83" y="220.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">4</text><text x="107" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">B</text><text x="131" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="220.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="49" y="229" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="73" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="97" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="121" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="145" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="229" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="59" y="239.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">3</text><text x="83" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">A</text><text x="107" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">B</text><text x="131" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="239.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="49" y="248" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="73" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="97" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="121" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="145" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="248" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="59" y="258.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">2</text><text x="83" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">A</text><text x="107" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">B</text><text x="131" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="258.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g><g class="row"><rect class="square" x="49" y="267" width="20" height="15" style="fill: rgb(146, 208, 80); stroke: rgb(153, 153, 153); stroke-width: 0;"></rect><rect class="square" x="73" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="97" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="121" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="145" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="169" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="193" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="217" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="241" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><rect class="square" x="265" y="267" width="20" height="15" style="fill: rgb(255, 255, 255); stroke: rgb(153, 153, 153); stroke-width: 1;"></rect><text x="59" y="277.5" font-size="10px" fill="#fff" class="grid-text" style="text-anchor: middle; cursor: pointer;">1</text><text x="83" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">A</text><text x="107" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">B</text><text x="131" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">C</text><text x="155" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">D</text><text x="179" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">E</text><text x="203" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">F</text><text x="227" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">G</text><text x="251" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">H</text><text x="275" y="277.5" font-size="9px" fill="#999" class="grid-text" style="text-anchor: middle; cursor: pointer;">I</text></g></svg></div>
						
						
    				</div>
    				
    				<div class="text-center" style="margin-top: 15px;">
        				<button type="button" class="btn btn-primary btn-lg" onclick="_request()">신청</button>
        				<button type="button" class="btn btn-default btn-lg" onclick="_cancel()">취소</button>
    				</div>
    				
				</div>
			</div>
		</div>
		
	</div>
	
</div>

<c:if test="${!empty useUserInfo.couple_seq}">
<input id="coupleSeq" type="hidden" value="${useUserInfo.couple_seq}">
</c:if>
<input id="userSeq" type="hidden" value="${useUserInfo.user_seq}">
<c:if test="${!empty assignedGraveInfo}">
<input id="assignedSectionSeq" type="hidden" value="${assignedGraveInfo.section_seq}">
<input id="assignedRowSeq" type="hidden" value="${assignedGraveInfo.row_seq}">
<input id="assignedColSeq" type="hidden" value="${assignedGraveInfo.col_seq}">
<input id="assignedSeqNo" type="hidden" value="${assignedGraveInfo.seq_no}">
</c:if>

<script type="text/javascript">

(function() {
	if($('#assignedSectionSeq').val()) {
		var sectionSeq = $('#assignedSectionSeq').val();
		var rowSeq = $('#assignedRowSeq').val();
		var colSeq = $('#assignedColSeq').val();
		var seqNo = $('#assignedSeqNo').val();
		showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo);
	} else {
		$('#selGraveSection').trigger('change');	
	}
})();


/**
 * 
 */
function _showGraveMap() {
	
}

/**
 * 
 */
function _changeGraveSection() {
	var selectedOption = $('#selGraveSection').find('option:selected');
	var sectionSeq = selectedOption.val();
	var rowSeq = selectedOption.attr('rowSeq');
	var colSeq = selectedOption.attr('colSeq');
	var seqNo = selectedOption.attr('seqNo');
	showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo);
}

/**
 * 
 */
function showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo) {
	if(sectionSeq) {
		var detailGraveInfo = sectionSeq + '구역';
		detailGraveInfo += '  ' + (rowSeq ? rowSeq : '') + '행 - ' + seqToAlpha(colSeq) + '열 (고유번호 : ' + (seqNo ? seqNo : '') + ')';
		$('#aDetailGraveInfo').text(detailGraveInfo);	
	}
}

/**
 * 
 */
function _request() {
	var sectionSeq = '', rowSeq = 0, colSeq = 0, isReserved = 0, seqNo = '';
	var assignedSectionSeq = $('#assignedSectionSeq').val();
	if(assignedSectionSeq) {
		isReserved = 1;
		sectionSeq = assignedSectionSeq;
		rowSeq = $('#assignedRowSeq').val();
		colSeq = $('#assignedColSeq').val();
		seqNo = $('#assignedSeqNo').val();
	}else {
		var selectedOption = $('#selGraveSection').find('option:selected');
		sectionSeq = selectedOption.val();
		rowSeq = selectedOption.attr('rowSeq');
		colSeq = selectedOption.attr('colSeq');
		seqNo = selectedOption.attr('seqNo');
	}
	
	var data = {};
	data.productType = '${bunyangInfo.product_type}';
	data.bunyangSeq = '${bunyangInfo.bunyang_seq}';
	data.coupleSeq = $('#coupleSeq').val() ? $('#coupleSeq').val() : 0;
	data.userSeq = $('#userSeq').val();
	data.sectionSeq = sectionSeq;
	data.rowSeq = rowSeq;
	data.colSeq = colSeq;
	data.isReserved = isReserved;
	
	common.ajax({
		url:"${contextPath}/mobile/assignGrave", 
		data:data,
		success: function(result) {
			if(result && result.result) {
				common.showAlert('신청되었습니다.\n부고 알림 메세지 전송 페이지로 이동합니다.');
				$('input[name="bunyangSeq"]').val('${bunyangInfo.bunyang_seq}');
				$('input[name="userId"]').val('${useUserInfo.user_id}');
				$('input[name="sectionSeq"]').val(sectionSeq);
				$('input[name="seqNo"]').val(seqNo);
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/mobile/registFuneralInfo";
				frm.submit();
			} else {
				common.showAlert('저장에 실패하였습니다.');
			}
		}
	});
}

/**
 * 
 */
function _cancel() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
}

/**
 * 
 */
function seqToAlpha(seq) {
	var seqOfA = "A".charCodeAt(0) + (seq-1);
	var alpha = String.fromCharCode(seqOfA);
	return alpha;
}

</script>
</c:otherwise>
</c:choose>



