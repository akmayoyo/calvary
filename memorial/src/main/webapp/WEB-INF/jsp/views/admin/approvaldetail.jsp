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

	<c:set var="contract_price" value="${cutil:getDownPayment(bunyangInfo.total_price)}"/><!-- 계약금 -->

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
            		<th style="background-color: #f5f5f5;">계약금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(contract_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(contract_price)})
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">잔금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price - contract_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price - contract_price)})
					</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <!-- 계약금 납부 내역 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>계약금 납부 내역</h4></div>
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
            		<td align="left">
            			<p class="form-control-static" style="display: inline-block;">
            				<c:choose>
								<c:when test="${downPaymentInfo.payment_amount > 0}">
									<span class="label label-info">완납</span>
								</c:when>
								<c:otherwise>
									<span class="label label-warning">미납</span>
								</c:otherwise>
							</c:choose>
            			</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">납부금액</p></th>
            		<td align="left"><p class="form-control-static" style="display: inline-block;">일금 : ${cutil:convertPriceToHangul(downPaymentInfo.payment_amount)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(downPaymentInfo.payment_amount)})</p></td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">납부일자</p></th>
            		<td align="left">
           				<p class="form-control-static" style="display: inline-block;">${downPaymentInfo.payment_date}</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">납부방법</p></th>
            		<td align="left">
           				<p class="form-control-static" style="display: inline-block;">
           					<c:choose>
           						<c:when test="${downPaymentInfo.payment_method == 'TRANSFER'}">무통장입금/계좌이체</c:when>
           						<c:when test="${downPaymentInfo.payment_method == 'CASH'}">현금납부</c:when>
           						<c:otherwise>${downPaymentInfo.payment_method}</c:otherwise>
           					</c:choose>
           				</p>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">확인일자</p></th>
            		<td align="left"><p class="form-control-static" style="display: inline-block;">${downPaymentInfo.create_date }</p></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static" style="display: inline-block;">확인자</p></th>
            		<td align="left"><p class="form-control-static" style="display: inline-block;">${downPaymentInfo.create_user_name}</p></td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <!-- 잔금 납부 내역 -->
	<div style="margin-top: 35px;">
		<div class="pull-left"><h4>잔금 납부 내역 (총 ₩${cutil:getThousandSeperatorFormatString(totalPaymentInfo.total_amount)})</h4></div>
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table class="table table-style">
            <thead>
                <tr>
                    <th scope="col">회차</th>
                    <th scope="col">납입일</th>
                    <th scope="col">납입금</th>
                    <th scope="col">납입유형</th>
                </tr>
            </thead>
            <tbody id="tbodyPayment">
            	<tr>
            		<td><p class="form-control-static" style="display: inline-block;">1</p></td>
            		<td><p class="form-control-static" style="display: inline-block;">${downPaymentInfo.payment_date}</p></td>
            		<td><p class="form-control-static" style="display: inline-block;">₩${cutil:getThousandSeperatorFormatString(downPaymentInfo.payment_amount)}</p></td>
            		<td><p class="form-control-static" style="display: inline-block;">계약금</p></td>
            	</tr>
            	<c:forEach items="${balancePaymentList}" var="balancePayment" varStatus="status">
            	<tr>
            		<td><p class="form-control-static" style="display: inline-block;">${status.count+1}</p></td>
            		<td align="center">
            			<p class="form-control-static" style="display: inline-block;">${balancePayment.payment_date}</p>
            		</td>
            		<td align="center">
            			<p class="form-control-static" style="display: inline-block;">₩${cutil:getThousandSeperatorFormatString(balancePayment.payment_amount)}</p>
            		</td>
            		<td><p class="form-control-static" style="display: inline-block;">중도금</p></td>
            	</tr>
            	</c:forEach>
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
        <c:if test="${bunyangInfo.progress_status != 'D'}">
        <button id="btnContract" type="button" class="btn btn-info btn-lg" onclick="approval()">사용승인</button>
        </c:if>
        <button id="btnList" type="button" class="btn btn-default btn-lg" onclick="goToList()">목록</button>
    </div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
	
})();

/**
 * 목록 클릭
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/approvalmgmt";
	frm.submit();
}

/**
 * 사용 승인
 */
function approval() {
	var bunyangSeq = $(btn).parent("td").parent("tr").attr("bunyangSeq");
	var data = {};
	data["bunyangSeq"] = '${bunyangSeq}';
	// 저장 호출
	common.ajax({
		url:"${contextPath}/admin/useapproval", 
		data:data,
		success: function(result) {
			if(result && result.result) {
				common.showAlert("사용승인되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/admin/approvaldetail";
				frm.submit();
			}
		}
	});
}

/**
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>