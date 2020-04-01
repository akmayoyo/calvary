<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<div class="pull-left"><h3 style="margin-top: 0;">분양현황</h3></div>
    	<div class="clearfix"></div>
		<div style="border-top: 1px solid #999;">
	        <table class="table table-style table-bordered" style="border-top: 0;">
	        	<colgroup>
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="15%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        	</colgroup>
	            <tbody>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">개별형</p></th>
	            		<td>${statusByProductType.each_cnt}</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">부부형</p></th>
	            		<td>${statusByGraveType.total_couple_cnt} 기중 ${statusByGraveType.couple_cnt} 기 신청</td>
	            		<td>${statusByGraveType.couple_usage}%</td>
	            		<td>${statusByGraveType.total_couple_cnt - statusByGraveType.couple_cnt}기 남음</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">계약자</p></th>
	            		<td>${statusByProgress.contract_cnt}명</td>
	            		<td rowspan="2">총 ${statusByGraveType.couple_cnt*2 + statusByGraveType.single_cnt}기 분양</td>
	            	</tr>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">가족형</p></th>
	            		<td>${statusByProductType.family_cnt}</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">1인형</p></th>
	            		<td>${statusByGraveType.total_single_cnt} 기중 ${statusByGraveType.single_cnt} 기 신청</td>
	            		<td>${statusByGraveType.single_usage}%</td>
	            		<td>${statusByGraveType.total_single_cnt - statusByGraveType.single_cnt}기 남음</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">완납자</p></th>
	            		<td>${statusByProgress.fullpayment_cnt}명</td>
	            	</tr>
	            </tbody>
	        </table>
	    </div>
	
	
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20" style="margin-top: 20px;">
			<div class="row">
				<div class="col-xs-4 col-md-3 pr-10">
					<select name="searchKey" class="form-control">
						<option value="apply_user_name" <c:if test="${searchVo.searchKey == 'apply_user_name'}">selected</c:if>>신청자</option>
						<option value="bunyang_no" <c:if test="${searchVo.searchKey == 'bunyang_no'}">selected</c:if>>번호</option>
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
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${bunyangList}" var="bunyangItem">
						<tr bunyangSeq="${bunyangItem.bunyang_seq}" <c:if test="${bunyangItem.cancel_yn == 'Y' || bunyangItem.progress_status == 'E' || bunyangItem.progress_status == 'R'}">class="cancel"</c:if>>
							<td>
								<a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.bunyang_no}
								<c:if test="${not empty bunyangItem.group_seq}">
								<br><span class="label label-primary">추가분양</span>
								</c:if>
								</a>
							</td>
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
	frm.action = "${contextPath}/admin/bunyangstatus";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["번호","신청자","연락처","사용자","신청형태","부부형","1인형","신청일자","계약일자","완납여부","사용승인일자","상태"];
	var excelFields = ["bunyang_no","apply_user_name","apply_user_mobile","use_user_exp","product_type_name","couple_type_count"
		,"single_type_count","regist_date","contract_date","full_payment_yn","use_approval_date","progress_status_exp"];
	var searchKeys = ["${searchVo.searchKey}"];
	var searchValues = ["${searchVo.searchVal}"];
	var queryId = "admin.getBunyangList";
	var title = "갈보리추모동산 분양현황";
	var fileName = title + ".xlsx";
	var sheetName = title;
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
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