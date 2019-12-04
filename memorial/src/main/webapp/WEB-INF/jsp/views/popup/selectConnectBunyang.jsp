<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="countPerPage" name="countPerPage" value="${searchVo.countPerPage}">
	<input type="hidden" id="totalCount" name="totalCount" value="${searchVo.totalCount}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">

<div class="poptitle">
	<strong>추가분양 선택</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">

	<!-- 검색 -->
	<div class="bx-border p-20" style="margin-bottom: 10px;">
		<div class="row">
			<div class="col-xs-2 col-md-2 pr-10">
				<select name="bunyangTimes" class="form-control">
					<option value="0">분양차수 : 전체</option>
					<c:forEach items="${bunyangTimesList}" var="bunyangTimesItem">
					<option value="${bunyangTimesItem.code_seq}" <c:if test="${searchVo.bunyangTimes == bunyangTimesItem.code_seq}">selected</c:if>>분양차수 : ${bunyangTimesItem.code_name}</option>
					</c:forEach>
				</select>
			</div>
			<div class="col-xs-2 col-md-2 pr-10 pl-0">
				<select name="searchKey" class="form-control">
					<option value="apply_user_name" <c:if test="${searchVo.searchKey == 'apply_user_name'}">selected</c:if>>신청자</option>
					<option value="bunyang_no" <c:if test="${searchVo.searchKey == 'bunyang_no'}">selected</c:if>>번호</option>
				</select>
			</div>
			<div class="col-xs-8 col-md-8 pl-0">
				<div class="input-group">
					<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
					<span class="input-group-btn pl-10">
						<button class="btn btn-primary" type="button" onclick="_search()">조회</button>
					</span>
				</div>
			</div>
		</div>
	</div>

	<!-- 사용(봉안) 대상자 -->
    <div class="table-responsive">
        <table id="tblList" class="table table-style">
			<thead>
				<tr>
					<th scope="col">선택</th>
					<th scope="col">번호</th>
					<th scope="col">신청자</th>
					<th scope="col">사용자</th>
					<th scope="col">신청형태</th>
					<th scope="col">부부형</th>
					<th scope="col">1인형</th>
					<th scope="col">상태</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${bunyangList}" var="bunyangItem">
					<c:if test="${bunyangSeq ne bunyangItem.bunyang_seq && bunyangItem.connected_bunyang_cnt eq 0}">
					<tr bunyangSeq="${bunyangItem.bunyang_seq}" <c:if test="${bunyangItem.cancel_yn == 'Y' || bunyangItem.progress_status == 'E' || bunyangItem.progress_status == 'R'}">class="cancel"</c:if>>
						<td><input type="checkbox" name="chkBunyang"> </td>
						<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.bunyang_no}</a></td>
						<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.apply_user_name}</a></td>
						<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.use_user_exp}</a></td>
						<td>${bunyangItem.product_type_name}</td>
						<td>${bunyangItem.couple_type_count}</td>
						<td>${bunyangItem.single_type_count}</td>
						<td style="text-decoration:none;">${bunyangItem.progress_status_exp}</td>
					</tr>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
    </div>
    
    <!-- 페이징 -->
	<div id="divPagination" class="text-center">
	</div>

	<div class="mt-30 text-center">
        <button type="button" class="btn btn-primary btn-lg" onclick="connectSelectedBunyang()">저장</button>
        <button type="button" class="btn btn-default btn-lg btnClose">취소</button>
    </div>
</div>
</form>

<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function() {
	
	// 페이징 표시 설정
	$('#divPagination').bootpag({
	   total: Math.ceil(${searchVo.totalCount/searchVo.countPerPage}),
	   page: ${searchVo.pageIndex},
	   maxVisible: 5
	}).on('page', function(event, num){
		_search(num);
	});
	
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
})();

(function(){
	
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/popup/selectConnectBunyang";
	frm.submit();
}

function connectSelectedBunyang() {
	var selectedBunyangSeqs = [];
	var fileFrm = new FormData();
	$('#tblList tbody tr').each(function(idx) {
		var chk = $(this).find('input[name="chkBunyang"]');
		if(chk.is(":checked")) {
			var bunyangSeq = $(this).attr('bunyangSeq');
			fileFrm.append('selectedBunyangSeq', bunyangSeq);
			selectedBunyangSeqs.push(bunyangSeq);
		}
	});
	if(selectedBunyangSeqs.length == 0) {
		common.showAlert('추가할 분양건을 선택해주세요.');
		return;
	}
	fileFrm.append('groupSeq', '${groupSeq}');
	fileFrm.append('bunyangSeq', '${bunyangSeq}');
   	$.ajax({
   		dataType : 'text',
        url:"${contextPath}/popup/connectSelectedBunyang",
        data:fileFrm,
        type : "POST",
        enctype: 'multipart/form-data',
        processData: false, 
        contentType:false,
        success : function(result) {
        	if(result){
        		common.showAlert('저장되었습니다.');
        		setTimeout(function(){
        			if (window.opener && window.opener.saveCallBack != 'undefined') {
    			        window.opener.saveCallBack(true);
    			    }
    				common.closeWindow();
				}, 300);
        	}
		},error : function(result){
        	
		},beforeSend: function() {
			common.loading(true);
		},complete: function() {
			common.loading(false);
		}
    });
}

/**
 * 분양 상세정보를 팝업으로 표시
 */
function _showBunyangInfo(el) {
	var bunyangSeq = $(el).parent('td').parent('tr').attr('bunyangSeq');
	var winoption = {width:1120, height:750};
	common.openWindow("${contextPath}/popup/bunyanginfo", "popBunyangInfo", winoption, {bunyangSeq:bunyangSeq});
}


</script>