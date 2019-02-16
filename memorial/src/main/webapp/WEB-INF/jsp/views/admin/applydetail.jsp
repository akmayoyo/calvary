<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="${searchVo.searchKey}">
	<input type="hidden" id="searchVal" name="searchVal" value="${searchVo.searchVal}">
	<input type="hidden" id="progressStatus" name="progressStatus" value="${searchVo.progressStatus}">
	<input type="hidden" id="bunyangTimes" name="bunyangTimes" value="${searchVo.bunyangTimes}">
	<input type="hidden" id="countPerPage" name="countPerPage" value="${searchVo.countPerPage}">
	<input type="hidden" id="totalCount" name="totalCount" value="${searchVo.totalCount}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
</form>

<div class="col-md-9">
    <!-- 신청자 -->
    <div>
    	<div class="pull-left">
    		<p style="font-weight: bold; font-size: 18px; margin: 10px 8px 8px 0; display: inline-block;">신청자</p>
    		<c:choose>
    			<c:when test="${bunyangInfo.progress_status == 'N'}"><span class="label label-success">신청</span></c:when>
    			<c:when test="${bunyangInfo.cancel_yn == 'Y'}"><span class="label label-danger">취소</span></c:when>
    			<c:when test="${bunyangInfo.progress_status == 'A' && bunyangInfo.cancel_yn != 'Y'}"><span class="label label-info">승인</span></c:when>
    			<c:when test="${bunyangInfo.progress_status == 'R'}"><span class="label label-warning">반려</span></c:when>
    		</c:choose>
    	</div>
    </div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblApplyUser" class="table table-style">
        	<colgroup>
        		<col width="7%">
        		<col width="13%">
        		<col width="13%">
        		<col width="13%">
        		<col width="30%">
        		<col width="7%">
        		<col width="7%">
        	</colgroup>
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
            		<td align="left">(${apply.post_number}) ${apply.address1} ${apply.address2}</td>
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
	        	<colgroup>
	        		<col width="7%">
	        		<col width="13%">
	        		<col width="13%">
	        		<col width="13%">
	        		<col width="30%">
	        		<col width="7%">
	        	</colgroup>
	            <thead>
	                <tr>
	                    <th scope="col">성명</th>
	                    <th scope="col">생년월일</th>
	                    <th scope="col">휴대전화</th>
	                    <th scope="col">이메일</th>
	                    <th scope="col">주소</th>
	                    <th scope="col">관계</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:forEach items="${agentUser}" var="agent">
	            	<tr>
	            		<td>${agent.user_name}</td>
	            		<td>${cutil:getBirthDateFormatString(agent.birth_date)}</td>
	            		<td>${cutil:getMobileFormatString(agent.mobile)}</td>
	            		<td>${agent.email}</td>
	            		<td align="left">(${agent.post_number}) ${agent.address1} ${agent.address2}</td>
	            		<td>${agent.relation_type_name}</td>
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
        <table id="tblUseUser" class="table table-style table-bordered">
        	<colgroup>
        		<col width="8%">
        		<col width="8%">
        		<col width="10%">
        		<col width="12%">
        		<col width="30%">
        		<col width="8%">
        		<col width="8%">
        		<col width="8%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col">장묘형태</th>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">휴대전화</th>
                    <th scope="col">주소</th>
                    <th scope="col">관계</th>
                    <th scope="col">교인여부</th>
                    <th scope="col">이장대상</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${useUser}" var="use" varStatus="status">
            	<tr>
            		<c:choose>
            			<c:when test="${!empty use.couple_seq}">
            				<c:set var="nextVal" value="${useUser[status.count]}"/>
            				<c:if test="${nextVal.couple_seq == use.couple_seq}">
	            				<td rowspan="2">부부형</td>
            				</c:if>
            			</c:when>
            			<c:otherwise>
            				<td>1인형</td>
            			</c:otherwise>
            		</c:choose>
            		<td>${use.user_name}</td>
            		<td>${cutil:getBirthDateFormatString(use.birth_date)}</td>
            		<td>${cutil:getMobileFormatString(use.mobile)}</td>
            		<td align="left">(${use.post_number}) ${use.address1} ${use.address2}</td>
            		<td>${use.relation_type_name}</td>
            		<td>${use.is_church_person}</td>
            		<td>${use.is_move}</td>
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
        		<col width="10%">
        		<col width="40%">
        		<col width="18%">
        		<col width="32%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;">분양차수</th>
            		<td align="left" colspan="3">${bunyangInfo.bunyang_times}차</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">분양단가</th>
            		<td align="left" colspan="3">₩${cutil:getThousandSeperatorFormatString(bunyangInfo.price_per_count)}원</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">신청형태</th>
            		<td align="left" colspan="3">${bunyangInfo.product_type_name}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">장묘형태</th>
            		<td align="left" colspan="3">부부형 : [${bunyangInfo.couple_type_count }] x 2&nbsp;&nbsp;&nbsp;&nbsp;1인형 : [${bunyangInfo.single_type_count }]&nbsp;&nbsp;(총 ${bunyangInfo.couple_type_count*2 + bunyangInfo.single_type_count}기)</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">관리비 납부자</th>
            		<td align="left" colspan="3">
            			${bunyangInfo.service_charge_type_name}
            			<c:if test="${bunyangInfo.service_charge_type == 'REPRESENT'}"> : ${bunyangInfo.maint_charger_name}</c:if>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">총 분양대금</th>
            		<td align="left" colspan="3">
            			일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price)})
            		</td>
            	</tr>
            	<c:if test="${not empty bunyangInfo.remarks_exp}">
            	<tr>
            		<th style="background-color: #f5f5f5;">비고</th>
            		<td align="left" colspan="3">${bunyangInfo.remarks_exp}</td>
            	</tr>
            	</c:if>
            </tbody>
        </table>
    </div>
    
    <!-- 신청 양식 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>신청 양식</h4></div>	
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
        <c:if test="${bunyangInfo.progress_status == 'N'}">
        <button type="button" class="btn btn-info btn-lg" onclick="approval()">승인</button>
        <button type="button" class="btn btn-warning btn-lg" onclick="reject()">반려</button>
        <button type="button" class="btn btn-danger btn-lg" onclick="cancel()">취소</button>
		</c:if>
        <c:if test="${bunyangInfo.progress_status == 'A' && bunyangInfo.cancel_yn != 'Y'}">
        <button type="button" class="btn btn-danger btn-lg" onclick="cancel()">취소</button>
		</c:if>
		<c:if test="${bunyangInfo.progress_status == 'R'}">
		<button type="button" class="btn btn-info btn-lg" onclick="approval()">승인</button>
		</c:if>
        <button id="btnList" type="button" class="btn btn-default btn-lg">목록</button>
    </div>
    
</div>
<form id="frm" method="post">
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
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
	frm.action = "${contextPath}/admin/applymgmt";
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
		bunyangInfo["bunyangTimes"] = ${bunyangInfo.bunyang_times};
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/approval", 
			data:JSON.stringify(bunyangInfo),
			contentType: 'application/json',
			success: function(result) {
				if(result && result.result) {
					// 승인서 파일번호
					var fileSeq = result.fileSeq;
					if(confirm('승인되었습니다.\n승인서를 다운로드하시겠습니까?')) {
						donwloadFile(fileSeq);
						setTimeout(function(){
							refresh();
						}, 100);
					} else {
						refresh();
					}
				}
			}
		});
	}
}

/**
 * 
 */
function refresh() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/applydetail";
	frm.submit();
}

/**
 * 반려
 */
function reject() {
	var winoption = {width:600, height:265};
	var param = {popupTitle: "반려 사유 입력"};
	common.openWindow("${contextPath}/popup/registcomment", "popRegistComment", winoption, param);
	// 신청자 입력 팝업 callback 함수
	window.registCommentCallBack = function(val) {
		var bunyangInfo = {};
		bunyangInfo["bunyangSeq"] = "${bunyangSeq}";
		bunyangInfo["progressStatus"] = "<%=CalvaryConstants.PROGRESS_STATUS_R%>";
		bunyangInfo["remarks"] = val;
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
	};
}

/**
 * 취소
 */
function cancel() {
	var winoption = {width:600, height:265};
	var param = {popupTitle: "취소 사유 입력"};
	common.openWindow("${contextPath}/popup/registcomment", "popRegistComment", winoption, param);
	// 신청자 입력 팝업 callback 함수
	window.registCommentCallBack = function(val) {
		var bunyangInfo = {};
		bunyangInfo["bunyangSeq"] = "${bunyangSeq}";
		bunyangInfo["progressStatus"] = "${bunyangInfo.progress_status}";
		bunyangInfo["remarks"] = val;
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/cancel", 
			data:JSON.stringify(bunyangInfo),
			contentType: 'application/json',
			success: function(result) {
				if(result && result.result) {
					common.showAlert("취소처리되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/admin/applymgmt";
					frm.submit();
				}
			}
		});
	};
}

/**
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>