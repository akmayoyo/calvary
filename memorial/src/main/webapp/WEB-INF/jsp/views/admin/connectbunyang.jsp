<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="groupSeq" name="groupSeq">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20" style="margin-top: 20px;">
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
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblList" class="table table-style">
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">신청자</th>
						<th scope="col">사용자</th>
						<th scope="col">신청형태</th>
						<th scope="col">부부형</th>
						<th scope="col">1인형</th>
						<th scope="col">신청일자</th>
						<th scope="col">계약<br>여부</th>
						<th scope="col">계약일자</th>
						<th scope="col">완납<br>여부</th>
						<th scope="col">사용승인<br>일자</th>
						<th scope="col">상태</th>
						<th scope="col">추가분양<br>관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${bunyangList}" var="bunyangItem">
						<tr bunyangSeq="${bunyangItem.bunyang_seq}" <c:if test="${bunyangItem.cancel_yn == 'Y' || bunyangItem.progress_status == 'E' || bunyangItem.progress_status == 'R'}">class="cancel"</c:if>>
							<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.bunyang_no}</a></td>
							<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.apply_user_name}</a></td>
							<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.use_user_exp}</a></td>
							<td>${bunyangItem.product_type_name}</td>
							<td>${bunyangItem.couple_type_count}</td>
							<td>${bunyangItem.single_type_count}</td>
							<td>${bunyangItem.regist_date}</td>
							<td><c:if test="${not empty bunyangItem.contract_date}">O</c:if></td>
							<td>${bunyangItem.contract_date}</td>
							<td><c:if test="${not empty bunyangItem.full_payment_date}">O</c:if></td>
							<td>${bunyangItem.use_approval_date}</td>
							<td style="text-decoration:none;">${bunyangItem.progress_status_exp}</td>
							<td><button type="button" class="btn btn-default btn-sm" onclick="connectDetail('${bunyangItem.group_seq}', '${bunyangItem.bunyang_seq}')"><span class="glyphicon glyphicon-cog" aria-hidden="true"></span></button></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	
		<!-- 페이징 -->
		<div id="divPagination" class="text-center">
		</div>
	
	</div>
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function(){
	// 페이징 표시 설정
	$('#divPagination').bootpag({
	   total: Math.ceil(${searchVo.totalCount/searchVo.countPerPage}),
	   page: ${searchVo.pageIndex},
	   maxVisible: 5
	}).on('page', function(event, num){
		_search(num);
	});
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/connectbunyang";
	frm.submit();
}

/** 
 * 상세 페이지 이동
 */
function connectDetail(groupSeq, bunyangSeq) {
	$("#groupSeq").val(groupSeq);
	$("#bunyangSeq").val(bunyangSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/connectdetail";
	frm.submit();
}

/**
 * 분양 상세정보를 팝업으로 표시
 */
function _showBunyangInfo(el) {
	var bunyangSeq = $(el).parent('td').parent('tr').attr('bunyangSeq');
	var winoption = {width:1120, height:750};
	common.openWindow("${contextPath}/popup/bunyanginfo", "popBunyangInfo", winoption, {bunyangSeq:bunyangSeq});
}
a
</script>