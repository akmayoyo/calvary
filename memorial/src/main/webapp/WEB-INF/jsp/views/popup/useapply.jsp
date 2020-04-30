<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="poptitle">
	<strong>부활동산 사용(봉안)신청</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">

	<form id="frm" method="post">
		<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
		<input type="hidden" id="bunyangSeq" name="bunyangSeq">
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20" style="margin-bottom: 10px;">
			<div class="row">
				<div class="col-xs-4 col-md-3 pr-10">
					<select name="searchKey" class="form-control">
						<option value="apply_user_name">신청자</option>
					</select>
				</div>
				<div class="col-xs-8 col-md-9 pl-0">
					<div class="input-group">
						<input name="searchVal" type="text" class="form-control" value="${searchVo.searchVal}"> 
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
						<th scope="col">총분양대금</th>
						<th scope="col">계약일자</th>
						<th scope="col">완납일자</th>
						<th scope="col">사용승인일자</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${useApplyList}" var="useApply">
					<c:set var="contract_price" value="${cutil:getDownPayment(useApply.total_price)}"/><!-- 계약금 -->
					<tr class="clickable-row" bunyangSeq="${useApply.bunyang_seq}">
	                    <td><p class="form-control-static">${useApply.bunyang_no}</p></td>
	                    <td><p class="form-control-static">${useApply.apply_user_name}</p></td>
	                    <td><p class="form-control-static">${useApply.use_user_exp}</p></td>
	                    <td><p class="form-control-static">${useApply.product_type_name}</p></td>
	                    <td><p class="form-control-static">${useApply.couple_type_count}</p></td>
	                    <td><p class="form-control-static">${useApply.single_type_count}</p></td>
	                    <td><p class="form-control-static">${cutil:getThousandSeperatorFormatString(useApply.total_price)}</p></td>
	                    <td><p class="form-control-static">${useApply.contract_date}</p></td>
	                    <td><p class="form-control-static">${useApply.full_payment_date}</p></td>
	                    <td><p class="form-control-static">${useApply.use_approval_date}</p></td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 페이징 -->
		<div id="divPagination" class="text-center"></div>

	</form>
</div>
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
	
	// 그리드 로우 선택시
	$('#tblList').on('click', '.clickable-row', function(event) {
		var bunyangSeq = $(this).attr("bunyangSeq");
		_goToSelectUserList(bunyangSeq);
	});

})();

/**
 * 조회
 */
function _search(pageIndex) {
    $("#pageIndex").val(pageIndex ? pageIndex : 1);
    var frm = document.getElementById("frm");
    frm.action = "${contextPath}/popup/useapply";
    frm.submit();
}

/**
 * 신청할 사용자 선택화면으로 이동
 */
function _goToSelectUserList(bunyangSeq) {
	$("#bunyangSeq").val(bunyangSeq);
	var frm = document.getElementById("frm");
    frm.action = "${contextPath}/popup/selectuseuser";
    frm.submit();
}

</script>