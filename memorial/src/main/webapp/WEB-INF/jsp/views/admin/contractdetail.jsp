<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="${searchVo.searchKey}">
	<input type="hidden" id="searchVal" name="searchVal" value="${searchVo.searchVal}">
	<input type="hidden" id="countPerPage" name="countPerPage" value="${searchVo.countPerPage}">
	<input type="hidden" id="totalCount" name="totalCount" value="${searchVo.totalCount}">
	<input type="hidden" id="progressStatus" name="progressStatus" value="${searchVo.progressStatus}">
	<input type="hidden" id="bunyangTimes" name="bunyangTimes" value="${searchVo.bunyangTimes}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
</form>

<c:set var="contract_price" value="${cutil:getDownPayment(bunyangInfo.total_price)}"/><!-- 계약금 -->

<div class="col-md-9">

    <!-- 신청자 -->
    <div>
    	<div class="pull-left">
    		<h4>신청자
    		<c:choose>
    			<c:when test="${bunyangInfo.progress_status == 'A'}">
    				<c:choose>
    					<c:when test="${bunyangInfo.down_payment >= contract_price}">
    					<c:set var="statusExp" value="계약미진행"/>
    					<c:set var="statusClass" value="label-info"/>
    					</c:when>
    					<c:otherwise>
    					<c:set var="statusExp" value="신청승인"/>
    					<c:set var="statusClass" value="label-info"/>
    					</c:otherwise>
    				</c:choose>
    			</c:when>
    			<c:when test="${bunyangInfo.progress_status == 'B'}">
    			<c:set var="statusExp" value="계약완료"/>
    			<c:set var="statusClass" value="label-info"/>
    			</c:when>
    			<c:when test="${bunyangInfo.progress_status == 'C'}">
    			<c:set var="statusExp" value="완납"/>
    			<c:set var="statusClass" value="label-info"/>
    			</c:when>
    			<c:when test="${bunyangInfo.progress_status == 'E'}">
    			<c:set var="statusExp" value="계약취소"/>
    			<c:set var="statusClass" value="label-danger"/>
    			</c:when>
    		</c:choose>
    		<span class="label ${statusClass}" style="margin-left: 10px; font-weight: normal;">${bunyangInfo.bunyang_times}차-${statusExp}</span>
    		</h4>
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
            		<td name="tdApplyUserName">${apply.user_name}</td>
            		<td>${cutil:getBirthDateFormatString(apply.birth_date)}</td>
            		<td name="tdApplyUserMobile">${cutil:getMobileFormatString(apply.mobile)}</td>
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
            		<th style="background-color: #f5f5f5;">계약번호</th>
            		<td align="left" colspan="3">${bunyangInfo.bunyang_no}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">분양차수</th>
            		<td align="left" colspan="3">${bunyangInfo.bunyang_times}차</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">분양단가</th>
            		<td align="left" colspan="3">
            		<c:choose>
            			<c:when test="${cutil:isFreeBunyang(bunyangInfo.price_per_count)}">무료</c:when>
            			<c:otherwise>₩${cutil:getThousandSeperatorFormatString(bunyangInfo.price_per_count)}원</c:otherwise>
            		</c:choose>
            		</td>
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
            	<tr>
            		<th style="background-color: #f5f5f5;">계약금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(contract_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(contract_price)})
            		<c:choose>
            			<c:when test="${bunyangInfo.down_payment >= contract_price}"><span class="label label-info" style="margin-left: 3px;">완납</span></c:when>
            			<c:otherwise><span class="label label-warning" style="margin-left: 3px;">미납</span></c:otherwise>
            		</c:choose>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">잔금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price - contract_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price - contract_price)})
            		<c:choose>
            			<c:when test="${(bunyangInfo.balance_payment+bunyangInfo.down_payment) >= bunyangInfo.total_price}"><span class="label label-info" style="margin-left: 3px;">완납</span></c:when>
            			<c:otherwise><span class="label label-warning" style="margin-left: 3px;">미납</span></c:otherwise>
            		</c:choose>
					</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <!-- 잔금 납부 내역 -->
	<div style="margin-top: 35px;">
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
    
    <!-- 추가분양리스트 -->
    <c:if test="${not empty addedBunyangList}">
    <div style="margin-top: 35px;">
		<div class="pull-left"><h4>추가 분양 리스트</h4></div>	
	</div>
	<div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
         <table class="table table-style">
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
				<c:forEach items="${addedBunyangList}" var="bunyangItem">
					<tr bunyangSeq="${bunyangItem.bunyang_seq}" <c:if test="${bunyangItem.cancel_yn == 'Y' || bunyangItem.progress_status == 'E' || bunyangItem.progress_status == 'R'}">class="cancel"</c:if>>
						<td><a href="javascript:void(0)" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.bunyang_no}</a></td>
						<td><a href="javascript:void(0)" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.apply_user_name}</a></td>
						<td><a href="javascript:void(0)" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.use_user_exp}</a></td>
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
    </c:if>
    
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
        <c:if test="${bunyangInfo.progress_status == 'A' && bunyangInfo.down_payment >= contract_price}">
        <button id="btnContract" type="button" class="btn btn-info btn-lg" onclick="apprContract('B')">계약</button>
        </c:if>
        <c:if test="${bunyangInfo.progress_status == 'B' && (bunyangInfo.down_payment + bunyangInfo.balance_payment  >= bunyangInfo.total_price)}">
        <button id="btnFullpayment" type="button" class="btn btn-info btn-lg" onclick="apprContract('C')">완납</button>
        </c:if>
        <button id="btnList" type="button" class="btn btn-default btn-lg" onclick="goToList()">목록</button>
    </div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
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
 * 계약 승인
 */
function apprContract(progressStatus) {
	var winoption = {width:450, height:355};
	var param = {popupTitle: progressStatus == 'B' ? "계약일 입력" : "완납일 입력"};
	common.openWindow("${contextPath}/popup/registdate", "popRegistDate", winoption, param);
	// 사용승인일 입력 팝업 callback 함수
	window.registDateCallBack = function(val) {
		var data = {};
		data["bunyangSeq"] = "${bunyangSeq}";
		data["progressStatus"] = progressStatus;
		data["updateDate"] = val;
		common.ajax({
			url:"${contextPath}/admin/apprcontract", 
			data:data,
			success: function(result) {
				if(result && result.result) {
					// 계약서 파일번호
					var fileSeq = result.fileSeq;
					var confirmMsg = '';
					if(progressStatus == 'B') {
						confirmMsg = '계약 처리 되었습니다.\n계약서를 다운로드하시겠습니까?';
					} else if(progressStatus == 'C') {
						confirmMsg = '완납 처리 되었습니다.\n완납확인증명서를 다운로드하시겠습니까?';
					}
					var applyUserName = $('#tblApplyUser tbody tr').eq(0).find('td[name="tdApplyUserName"]').text();
					var mobile = $('#tblApplyUser tbody tr').eq(0).find('td[name="tdApplyUserMobile"]').text();
					if(progressStatus == 'B' && common.isValidMobile(mobile)) {
						if(confirm('계약 처리 되었습니다.\n계약자에게 계약 승인메세지를 전송하시겠습니까?')) {
							var sendSmsVo = {};
							var dt = val;
							if(dt && dt.length == 8) {
								dt = dt.substring(2,4) + "/" + dt.substring(4,6) + "/" + dt.substring(6,8);
							}
							sendSmsVo.msgKey = 'M0003';
							sendSmsVo.receivers = mobile;
							sendSmsVo.sequences = [applyUserName, dt];
							common.sendSms(sendSmsVo, function(result) {
								common.showAlert('메세지가 전송되었습니다.');
								refresh();
							}, function(xhr, status, message) {
								refresh();
							});
						} else {
							refresh();
						}	
					} else {
						if(confirm(confirmMsg)) {
							donwloadFile(fileSeq);
							setTimeout(function(){
								refresh();
							}, 100);
						} else {
							refresh();
						}
					}
				}
			}
		});
	};
}

/**
 * 
 */
function refresh() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/contractdetail";
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

/**
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>