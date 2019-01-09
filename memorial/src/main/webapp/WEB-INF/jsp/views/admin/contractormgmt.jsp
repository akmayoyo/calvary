<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20">
			<div class="row">
				<div class="col-xs-4 col-md-3 pr-10">
					<select name="searchKey" class="form-control">
						<option value="apply_user_name">신청자</option>
					</select>
				</div>
				<div class="col-xs-8 col-md-9 pl-0">
					<div class="input-group">
						<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
						<span class="input-group-btn pl-10">
							<button class="btn btn-primary" type="button" onclick="_search()">조회</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblList" class="table table-style table-bordered">
				<thead>
					<tr>
						<th scope="col" rowspan="2">번호</th>
						<th scope="col" colspan="4">신청자(계약자)</th>
						<th scope="col" rowspan="2">신청형태</th>
						<th scope="col" colspan="2">장묘형태</th>
						<th scope="col" rowspan="2">총 분양대금</th>
						<th scope="col" rowspan="2">신청일</th>
						<th scope="col" rowspan="2">계약일</th>
						<th scope="col" rowspan="2">사용승인일</th>
					</tr>
					<tr>
						<th scope="col">성명</th>
						<th scope="col">생년월일</th>
						<th scope="col">직분</th>
						<th scope="col">교구</th>
						<th scope="col">부부형</th>
						<th scope="col">1인형</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${bunyangList}" var="bunyang">
					<tr bunyangSeq="${bunyang.bunyang_seq}" progressStatus="${bunyang.progress_status}">
	                    <td>${bunyang.bunyang_seq}</td>
	                    <td>${bunyang.apply_user_name}<button type="button" class="btn btn-primary btn-xs" style="margin-left: 8px;" onclick="_changeContractor(this, event)">변경</button></td>
	                    <td>${bunyang.apply_user_birth_date}</td>
	                    <td>${bunyang.apply_user_church_officer_name}</td>
	                    <td>${bunyang.apply_user_diocese}</td>
	                    <td>${bunyang.product_type_name}</td>
	                    <td>${bunyang.couple_type_count}</td>
	                    <td>${bunyang.single_type_count}</td>
	                    <td>${cutil:getThousandSeperatorFormatString(bunyang.total_price)}</td>
	                    <td>${bunyang.regist_date}</td>
	                    <td>${bunyang.contract_date}</td>
	                    <td>${bunyang.use_approval_date}</td>
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
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
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
	frm.action = "${contextPath}/admin/contractormgmt";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["번호", "성명", "생년월일", "직분", "교구", "신청형태", "부부형", "1인형", "총 분양대금", "신청일","계약일","사용승인일"];
	var excelFields = ["bunyang_seq","apply_user_name","apply_user_birth_date","apply_user_church_officer_name","apply_user_diocese","product_type_name","couple_type_count","single_type_count","total_price","regist_date","contract_date","use_approval_date"];
	var searchKeys = [""];
	var searchValues = [""];
	var queryId = "admin.getBunyangList";
	var fileName = "분양리스트.xlsx";
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName);
}

/**
 * 사용승인
 */
function _changeContractor(btn, event) {
	event.stopPropagation();
	var bunyangSeq = $(btn).parent("td").parent("tr").attr("bunyangSeq");
	var progressStatus = $(btn).parent("td").parent("tr").attr("progressStatus");
	var userId;
	var userName;
	var winoption = {width:1240, height:830};
	var param = {popupTitle: "계약자 변경"};
	common.openWindow("${contextPath}/popup/selectuser", "popChangeContractor", winoption, param);
	// 신청자 입력 팝업 callback 함수
	window.selectuserCallBack = function(type, item) {
		var idx = 0;
		if(type == "select") {
			if(item && item.length > 0) {
				userId = item[idx++];
				userName = item[idx++];
			}
		}
		if(bunyangSeq && progressStatus && userId) {
			setTimeout(function(){
				if(confirm('신청번호('+bunyangSeq+')의 계약자를 '+userName+'님으로 변경합니다.\n진행하시겠습니까?')) {
					var data = {};
					data["bunyangSeq"] = bunyangSeq;
					data["progressStatus"] = progressStatus;
					data["userId"] = userId;
					common.ajax({
						url:"${contextPath}/admin/changecontractor", 
						data:data,
						success: function(result) {
							if(result && result.result) {
								common.showAlert("저장되었습니다.");
								var frm = document.getElementById("frm");
								frm.action = "${contextPath}/admin/contractormgmt";
								frm.submit();
							}
						}
					});
				}
			}, 100);
		}else {
			common.showAlert('선택된 정보가 올바르지 않습니다.');
		}
		
	};
}

</script>