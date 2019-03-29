<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="userId" name="userId">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangInfo.bunyang_seq}">
</form>
<header class="m_header">
	<!-- 사이트 로고 -->
	<a class="logo" href="${contextPath}/mobile/main">
		<img src="${contextPath}/resources/assets/images/logo_w.png" alt="">
	</a>

	<!-- 로그아웃 -->
	<div class="pull-right bx_logout">
		<a href="javascript:void(0)" onclick="_logout()">로그아웃</a></li>
	</div>
</header>

<!-- 컨텐츠 -->
<div class="m_contents">
	
	<div class="m_user">
		<span class="m_profile"><span class="glyphicon glyphicon-user" aria-hidden="true"></span></span>
		<span>${userVo.userName} 성도님 반갑습니다.</span>
	</div>
	
	<!-- 아코디언 메뉴 -->
	<div id="m_menu" class="m_menu">

		<div class="panel">
			<div class="depth1">
				<a data-toggle="collapse" data-parent="#m_menu" aria-expanded="true" href="#menu1">계약정보</a>
			</div>
			<div id="menu1" class="collapse in">
				<div class="padding-15">
					<table class="table m_table">
						<tbody>
							<tr>
								<th scope="sel">계약자</th>
								<td class="text-left">${bunyangInfo.apply_user_name}</td>
							</tr>
							<tr>
								<th scope="sel">계약번호</th>
								<td class="text-left">${bunyangInfo.bunyang_no}</td>
							</tr>
							<tr>
								<th scope="sel">신청형태</th>
								<td class="text-left">${bunyangInfo.product_type_name}</td>
							</tr>
							<tr>
								<th scope="sel">장묘형태</th>
								<td class="text-left">부부형 : [${bunyangInfo.couple_type_count }] x 2&nbsp;&nbsp;&nbsp;&nbsp;1인형 : [${bunyangInfo.single_type_count }]&nbsp;&nbsp;(총 ${bunyangInfo.couple_type_count*2 + bunyangInfo.single_type_count}기)</td>
							</tr>
							<tr>
								<th scope="sel">관리비납부자</th>
								<td class="text-left">
									${bunyangInfo.service_charge_type_name}
									<c:if test="${not empty bunyangInfo.maint_charger_name}"> (${bunyangInfo.maint_charger_name})</c:if>
								</td>
							</tr>
							<tr>
								<th scope="sel">총 분양대금</th>
								<td class="text-left">일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price)})</td>
							</tr>
							<tr>
								<th scope="sel">상태</th>
								<td class="text-left">
									<c:choose>
										<c:when test="${bunyangInfo.progress_status == 'N'}">신청미승인</c:when>
										<c:when test="${bunyangInfo.progress_status == 'A'}">신청승인</c:when>
										<c:when test="${bunyangInfo.progress_status == 'B'}">계약완료</c:when>
										<c:when test="${bunyangInfo.progress_status == 'C'}">완납</c:when>
										<c:when test="${bunyangInfo.progress_status == 'D'}">사용승인</c:when>
										<c:when test="${bunyangInfo.progress_status == 'E'}">해약</c:when>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		<div class="panel">
			<div class="depth1">
				<a data-toggle="collapse" data-parent="#m_menu" aria-expanded="false" href="#menu3">납입정보</a>
			</div>
			<div id="menu3" class="collapse">
				<div class="padding-15">
					<table class="table m_table table-bordered">
						<thead>
							<tr>
								<th scope="col">납입유형</th>
								<th scope="col">납입금액</th>
								<th scope="col">납입일자</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${paymentList}" var="rowItem">
							<tr>
								<td>${rowItem.payment_type_name}</td>
								<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.payment_amount)}</td>
								<td>${rowItem.payment_date}</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<div class="panel">
			<div class="depth1">
				<a data-toggle="collapse" data-parent="#m_menu" aria-expanded="false" href="#menu2">사용(봉안) 대상자</a>
			</div>
			<div id="menu2" class="collapse">
				<div class="padding-15 table-responsive">
					<table id="tblUseUser" class="table m_table">
						<thead>
							<tr>
								<th scope="col">성명</th>
								<th scope="col">관계</th>
								<th scope="col">승인상태</th>
								<th scope="col">봉안여부</th>
								<th scope="col">사용신청</th>
								<th scope="col">사용구역</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${useUserList}" var="rowItem">
							<tr approvalYn="${not empty rowItem.approval_assign_date}" assignStatus="${rowItem.couple_assign_status}" <c:if test="${not empty rowItem.cancel_seq}">class="cancel"</c:if>>
								<td>${rowItem.user_name}</td>
								<td>${rowItem.relation_type_name}</td>
								<td>
									<c:choose>
										<c:when test="${not empty rowItem.cancel_seq}">해약</c:when>
										<c:when test="${not empty bunyangInfo.use_approval_date}">승인</c:when>
										<c:otherwise>미승인</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${rowItem.couple_assign_status == 'OCCUPIED'}">Y</c:when>
										<c:otherwise>N</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${rowItem.couple_assign_status == 'OCCUPIED'}">사용(봉안)중</c:when>
										<c:otherwise>
										<button class="btn btn-primary btn-sm" onclick="_requestGrave(this, '${rowItem.user_id}')" <c:if test="${not empty rowItem.cancel_seq}">disabled</c:if>>신청</button>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${rowItem.couple_assign_status == 'OCCUPIED'}"><span name="section_info" section_seq="${rowItem.section_seq}" row_seq="${rowItem.row_seq}" col_seq="${rowItem.col_seq}" seq_no="${rowItem.seq_no}"></span></c:when>
									</c:choose>
								</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">

(function(){
	// 사용구역표시
	$('span[name="section_info"]').each(function(idx) {
		var section = $(this).attr('section_seq') + '구역';
		section += '  ' + $(this).attr('row_seq') + '행-' + seqToAlpha($(this).attr('col_seq')) + '열 (고유번호:' + $(this).attr('seq_no') + ')';
		$(this).text(section);
	});
	
})();

/**
 * 추모동산 사용신청
 */
function _requestGrave(btn, userId) {
	var tr = $(btn).parent('td').parent('tr');
	if(tr.attr('approvalYn') != 'true') {
		common.showAlert('사용승인 후 신청가능합니다.');
		return;
	}
	if(tr.attr('assignStatus') == 'OCCUPIED') {
		common.showAlert('이미 봉안된 사용자입니다.');
		return;
	}
	$('#userId').val(userId);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/requestGrave";
	frm.submit();
}

/**
 * 로그아웃처리
 */
function _logout() {
	common.ajax({
		url:"${contextPath}/account/mobile/logout", 
		data:{},
		success: function(result) {
			if(result) {
				location.replace('${contextPath}/account/mobile/login');
			}
		}
	});
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
