<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="${searchVo.searchKey}">
	<input type="hidden" id="searchVal" name="searchVal" value="${searchVo.searchVal}">
	<input type="hidden" id="countPerPage" name="countPerPage" value="${searchVo.countPerPage}">
	<input type="hidden" id="totalCount" name="totalCount" value="${searchVo.totalCount}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
</form>

<div class="col-md-9">
    <!-- 신청자 -->
    <div>
    	<div class="pull-left"><h4>신청자</h4></div>
    </div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblApplyUser" class="table table-style">
            <thead>
                <tr>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">휴대전화</th>
                    <th scope="col">이메일</th>
                    <th scope="col">주소</th>
                    <th scope="col">직분</th>
                    <th scope="col">교구</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${applyUser}" var="apply">
            	<tr>
            		<td>${apply.user_name}</td>
            		<td>${apply.birth_date}</td>
            		<td>${apply.mobile}</td>
            		<td>${apply.email}</td>
            		<td>(${apply.post_number}) ${apply.address1} ${apply.address2}</td>
            		<td>${apply.church_officer_name}</td>
            		<td>${apply.diocese}</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>
    
    <!-- 대리인(대리인신청시만 표시됨) -->
    <div id="divAgentInfo" style="margin-top: 35px;">
    	<div>
	    	<div class="pull-left"><h4>대리인</h4></div>
	    </div>
	    <div class="clearfix"></div>
	    <div class="table-responsive">
	        <table id="tblAgentUser" class="table table-style">
	            <thead>
	                <tr>
	                    <th scope="col">성명</th>
	                    <th scope="col">생년월일</th>
	                    <th scope="col">휴대전화</th>
	                    <th scope="col">이메일</th>
	                    <th scope="col">주소</th>
	                    <th scope="col">관계</th>
                    	<th scope="col">교인여부</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:forEach items="${agentUser}" var="agent">
	            	<tr>
	            		<td>${agent.user_name}</td>
	            		<td>${agent.birth_date}</td>
	            		<td>${agent.mobile}</td>
	            		<td>${agent.email}</td>
	            		<td>(${agent.post_number}) ${agent.address1} ${agent.address2}</td>
	            		<td>${agent.relation_type_name}</td>
	            		<td>${agent.is_church_person}</td>
	            	</tr>
	            	</c:forEach>
	            </tbody>
	        </table>
	    </div>
    </div>

	<!-- 사용(봉안) 대상자 -->
	<div style="margin-top: 35px;">
		<div class="pull-left" style=""><h4>사용(봉안) 대상자</h4></div>
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblUseUser" class="table table-style">
            <thead>
                <tr>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">휴대전화</th>
                    <th scope="col">이메일</th>
                    <th scope="col">주소</th>
                    <th scope="col">관계</th>
                    <th scope="col">교인여부</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${useUser}" var="use">
            	<tr>
            		<td>${use.user_name}</td>
            		<td>${use.birth_date}</td>
            		<td>${use.mobile}</td>
            		<td>${use.email}</td>
            		<td>(${use.post_number}) ${use.address1} ${use.address2}</td>
            		<td>${use.relation_type_name}</td>
            		<td>${use.is_church_person}</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>

	<!-- 동산 신청 정보 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>동산 신청 정보</h4></div>	
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="18%">
        		<col width="32%">
        		<col width="18%">
        		<col width="32%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;">신청형태</th>
            		<td align="left" colspan="3">${bunyangInfo.product_type_name}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">장묘형태</th>
            		<td align="left" colspan="3">부부형 : [${bunyangInfo.couple_type_count }] x 2&nbsp;&nbsp;&nbsp;&nbsp;1인형 : [${bunyangInfo.single_type_count }]&nbsp;&nbsp;(총 ${bunyangInfo.couple_type_count*2 + bunyangInfo.single_type_count}기)</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">총 분양대금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price)})</td>
            	</tr>
            	<tr>
            		<c:set var="contract_price" value="${cutil:getDownPayment(bunyangInfo.total_price)}"/><!-- 계약금 -->
            		<th style="background-color: #f5f5f5;">계약금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(contract_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(contract_price)})<span class="label label-warning" style="margin-left: 10px;">미납</span></td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">잔금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price - contract_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price - contract_price)})<span class="label label-warning" style="margin-left: 10px;">미납</span></td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <!-- 계약금 납부 내역 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>계약금 납부 내역</h4></div>
		<div class="pull-right">
	    	<button id="btnRegistContract" type="button" class="btn btn-primary" onclick="registApplyUser(true)">저장</button>
		</div>	
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="18%">
        		<col width="32%">
        		<col width="18%">
        		<col width="32%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">납부상태</p></th>
            		<td align="left"><p class="form-control-static" style="display: inline-block;">미납</p></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">납부금액</p></th>
            		<td align="left"><p class="form-control-static" style="display: inline-block;">일금 : 사십만원&nbsp;&nbsp;(₩400,000)</p></td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">납부일자</p></th>
            		<td align="left"><input id="contract_payment_date" name="contract_payment_date" type="text" class="form-control" style="width: 200px;" value=""></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">납부방법</p></th>
            		<td align="left">
            			<select class="form-control" style="width: auto;">
            				<option>무통장입금/계좌이체</option>
            				<option>현금납부</option>
            			</select>
            		</td>
            	</tr>
<!--             	<tr> -->
<!--             		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">확인일자</p></th> -->
<!--             		<td align="left"></td> -->
<!--             		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">확인자</p></th> -->
<!--             		<td align="left"></td> -->
<!--             	</tr> -->
            </tbody>
        </table>
    </div>
    
    <!-- 계약금 납부 내역 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>잔금 납입 계획 및 납부 확인서</h4></div>
		<div class="pull-right">
	    	<button id="btnRegistContract" type="button" class="btn btn-primary" onclick="registApplyUser(true)">추가</button>
	    	<button id="btnRegistContract" type="button" class="btn btn-primary" onclick="registApplyUser(true)">저장</button>
		</div>	
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table class="table table-style">
            <thead>
                <tr>
                    <th scope="col">회차</th>
                    <th scope="col">납입예정일</th>
                    <th scope="col">납입금액</th>
                    <th scope="col">실납입일</th>
                    <th scope="col">납입금</th>
                    <th scope="col">확인/완납</th>
                </tr>
            </thead>
            <tbody>
            	
            </tbody>
        </table>
    </div>
    
    <!-- 관련 양식 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>관련 양식</h4></div>	
	</div>
    <div class="clearfix"></div>
    <!-- 양식 리스트 -->
	<ul class="list-group">
		<c:forEach items="${fileList}" var="file">
		<li class="list-group-item"><a href="javascript:void(0)" onclick="donwloadFile('${file.file_seq}')">${file.file_name }</a></li>
		</c:forEach>
	</ul>

    <div class="mt-30 text-center">
        <button id="btnEdit" type="button" class="btn btn-primary btn-lg">수정</button>
        <button id="btnEdit" type="button" class="btn btn-info btn-lg">계약</button>
        <button id="btnList" type="button" class="btn btn-default btn-lg">목록</button>
    </div>
    
</div>
<form id="frm" method="post">
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
	$('#contract_payment_date').daterangepicker({
		singleDatePicker: true,
		showDropdowns: true,
		locale: {
            "format": "YYYY/MM/DD",
            "daysOfWeek": [
                "일",
                "월",
                "화",
                "수",
                "목",
                "금",
                "토"
            ],
            "monthNames": [
                "1월",
                "2월",
                "3월",
                "4월",
                "5월",
                "6월",
                "7월",
                "8월",
                "9월",
                "10월",
                "11월",
                "12월"
            ]
        }
	});
	
	// 목록 클릭
	$('#btnList').click(function(e){
		goToList();
	});	
	
})();

/**
 * 목록 클릭
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/contractmgmt";
	frm.submit();
}

/**
 * 승인
 */
function approval() {
	if(confirm("승인하시겠습니까?")) {
		var bunyangInfo = {};
		bunyangInfo["bunyangSeq"] = "${bunyangSeq}";
		bunyangInfo["progressStatus"] = "<%=CalvaryConstants.PROGRESS_STATUS_A%>";
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/approval", 
			data:JSON.stringify(bunyangInfo),
			contentType: 'application/json',
			success: function(result) {
				if(result && result.result) {
					common.showAlert("승인되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/admin/applymgmt";
					frm.submit();
				}
			}
		});
	}
}

/**
 * 반려
 */
function reject() {
	if(confirm("반려하시겠습니까?")) {
		var bunyangInfo = {};
		bunyangInfo["bunyangSeq"] = "${bunyangSeq}";
		bunyangInfo["progressStatus"] = "<%=CalvaryConstants.PROGRESS_STATUS_E%>";
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/reject", 
			data:JSON.stringify(bunyangInfo),
			contentType: 'application/json',
			success: function(result) {
				if(result && result.result) {
					common.showAlert("반려처리 되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/admin/applymgmt";
					frm.submit();
				}
			}
		});
	}
}

/**
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>