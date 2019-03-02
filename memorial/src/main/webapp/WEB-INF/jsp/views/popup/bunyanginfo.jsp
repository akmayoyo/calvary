<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
</form>

<div class="poptitle">
	<strong>분양 상세 정보</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 15px 15px;">
    <!-- 신청자 -->
    <div>
    	<div class="pull-left"><h4>신청자</h4></div>
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
            		<td>${cutil:getBirthDateFormatString(apply.birth_date)}</td>
            		<td>${cutil:getMobileFormatString(apply.mobile)}</td>
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
    <div id="divAgentInfo" style="margin-top: 15px;">
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
	<div style="margin-top: 15px;">
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
        		<col width="22%">
        		<col width="8%">
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
                    <th scope="col">상태</th>
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
            		<td>
            		<c:choose>
            			<c:when test="${not empty use.cancel_seq}">해약</c:when>
            			<c:when test="${not empty use.approval_no}">사용승인</c:when>
            			<c:otherwise>사용미승인</c:otherwise>
            		</c:choose>
            		</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>

	<!-- 동산 신청 정보 -->
	<div style="margin-top: 15px;">
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
            		<th style="background-color: #f5f5f5;">번호</th>
            		<td align="left" colspan="3">${bunyangInfo.bunyang_no}</td>
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
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price)})</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <c:if test="${not empty paymentList}">
    <!-- 잔금 납부 내역 -->
	<div style="margin-top: 15px;">
		<div class="pull-left"><h4>납부 내역 (총 ₩${cutil:getThousandSeperatorFormatString(totalPaymentInfo.total_amount)})</h4></div>
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table class="table table-style table-bordered">
        	<colgroup>
        		<col width="10%">
        		<col width="18%">
        		<col width="18%">
        		<col width="18%">
        		<col width="18%">
        		<col width="18%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col">회차</th>
                    <th scope="col">납입일</th>
                    <th scope="col">납입금</th>
                    <th scope="col">납입유형</th>
                    <th scope="col">납부방법</th>
                    <th scope="col">입금자</th>
                </tr>
            </thead>
            <tbody id="tbodyPayment">
            	<c:forEach items="${paymentList}" var="payment" varStatus="status">
            		<tr>
            			<td>${status.count}</td>
	            		<td>${payment.payment_date}</td>
	            		<td align="right">${cutil:getThousandSeperatorFormatString(payment.payment_amount)}</td>
	            		<td>${payment.payment_type_name}</td>
	            		<td>
	            			<c:choose>
	            				<c:when test="${payment.payment_method == 'TRANSFER'}">무통장/계좌이체</c:when>
	            				<c:when test="${payment.payment_method == 'CASH'}">현금</c:when>
	            			</c:choose>
	            		</td>
	            		<td>${payment.payment_user}</td>
            		</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>
    
    <c:if test="${bunyangInfo.progress_status == 'E'}">
    
    <c:set var="penalty" value="${bunyangInfo.down_payment/2}"/><!-- 위약금 -->
    <c:set var="cancelReturn" value="${bunyangInfo.down_payment + bunyangInfo.balance_payment - penalty}"/><!-- 반환금 -->
    
    <!-- 계약금 납부 내역 -->
	<div style="margin-top: 15px;">
		<div class="pull-left"><h4>해약 내역</h4></div>
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
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약사유</p></th>
            		<td align="left" ><p class="form-control-static">${bunyangInfo.cancel_reason }</p></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">신청일자</p></th>
            		<td align="left" ><p class="form-control-static">${bunyangInfo.cancel_approval_date }</p></td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약 위약금</p></th>
            		<td align="left">
            			<p class="form-control-static">일금 : ${cutil:convertPriceToHangul(penalty)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(penalty)})</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">반환금</p></th>
            		<td align="left">
            			<p class="form-control-static">일금 : ${cutil:convertPriceToHangul(cancelReturn)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(cancelReturn)})</p>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금계좌</p></th>
            		<td align="left"><p class="form-control-static">${bunyangInfo.cancel_bank}&nbsp;${bunyangInfo.cancel_account}</p></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">예금주</p></th>
            		<td align="left"><p class="form-control-static">${bunyangInfo.cancel_account_holder }</p></td>
            	</tr>
            </tbody>
        </table>
    </div>
    </c:if>
    
    <!-- 관련 양식 -->
	<div style="margin-top: 15px;">
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
        <button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
    </div>

</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
	
})();

/**
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>