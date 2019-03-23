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
		<img src="${contextPath}/resources/assets/images/logo_w.png" alt="">
	</a>

	<!-- 로그아웃 -->
	<div class="pull-right bx_logout">
		<a href="javascript:void(0)" onclick="_logout()">로그아웃</a></li>
	</div>
</header>

<!-- 컨텐츠 -->
<div class="m_contents">
	
	<!-- 아코디언 메뉴 -->
	<div id="m_menu" class="m_menu">

		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">사용(봉안)자 정보</a>
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
								<th scope="sel">장묘형태</th>
								<td class="text-left">
									<c:choose>
            							<c:when test="${!empty useUserInfo.couple_seq}">부부형</c:when>
            							<c:otherwise>1인형</c:otherwise>
            						</c:choose>
								</td>
							</tr>
							<tr>
								<th scope="sel">성명</th>
								<td class="text-left">${useUserInfo.user_name}</td>
							</tr>
							<tr>
								<th scope="sel">생년월일</th>
								<td class="text-left">${useUserInfo.birth_date}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">신청구역</a>
			</div>
			<div id="menu2">
				<div class="padding-15" style="border-bottom: 1px solid #e7e7e7;">
					<table class="table m_table">
						<colgroup>
							<col width="30%">
							<col width="70%">
						</colgroup>
						<tbody>
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
								<th scope="sel">상세위치</th>
								<td class="text-left">
									<a id="aDetailGraveInfo" href="javascript:void(0);" style="padding: 5px 0;" onclick="_showGraveMap()">
									</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<div class="mt-30 text-center">
        <button type="button" class="btn btn-primary btn-lg" onclick="_request()">신청</button>
        <button type="button" class="btn btn-default btn-lg" onclick="_cancel()">취소</button>
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



