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
    			<c:when test="${bunyangInfo.progress_status == 'B' or bunyangInfo.progress_status == 'C'}">
    			<c:set var="statusExp" value="계약완료"/>
    			<c:set var="statusClass" value="label-info"/>
    			</c:when>
    			<c:when test="${bunyangInfo.progress_status == 'A'}">
    			<c:set var="statusExp" value="계약미승인"/>
    			<c:set var="statusClass" value="label-warning"/>
    			</c:when>
    			<c:when test="${bunyangInfo.progress_status == 'E'}">
    			<c:set var="statusExp" value="계약해약"/>
    			<c:set var="statusClass" value="label-danger"/>
    			</c:when>
    		</c:choose>
    		<span class="label ${statusClass}" style="margin-left: 10px; font-weight: normal;">${bunyangInfo.bunyang_times}차-${statusExp}</span>
    		</h4>
    	</div>
    	<c:if test="${bunyangInfo.progress_status != 'E'}">
    	<div class="pull-right">
	        <button class="btn btn-primary" type="button" style="width: 60px;" onclick="editApplyUser()">수정</button>
	    </div>
	    </c:if>
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
            	<tr>
            		<td>${applyUser.user_name}</td>
            		<td>${cutil:getBirthDateFormatString(applyUser.birth_date)}</td>
            		<td>${cutil:getMobileFormatString(applyUser.mobile)}</td>
            		<td>${applyUser.email}</td>
            		<td align="left">(${applyUser.post_number})${applyUser.address1}${applyUser.address2}</td>
            		<td>${applyUser.church_officer_name}</td>
            		<td>${applyUser.diocese}</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <!-- 대리인(대리인신청시만 표시됨) -->
    <div id="divAgentInfo" style="margin-top: 35px;">
    	<div>
	    	<div class="pull-left"><h4>대리인</h4></div>
	    </div>
	    <c:if test="${bunyangInfo.progress_status != 'E'}">
	    <div class="pull-right">
	        <button class="btn btn-primary" type="button" style="width: 60px;" onclick="editAgentUser()">
	        <c:choose>
	        	<c:when test="${not empty agentUser}">수정</c:when>
	        	<c:otherwise>입력</c:otherwise>
	        </c:choose>
	        </button>
	    </div>
	    </c:if>
	    <div class="clearfix"></div>
	    <div class="table-responsive">
	        <table id="tblAgentUser" class="table table-style">
	        	<colgroup>
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="15%">
	        		<col width="30%">
	        		<col width="10%">
	        		<c:if test="${bunyangInfo.progress_status != 'E'}">
	        		<col width="5%">
	        		</c:if>
	        	</colgroup>
	            <thead>
	                <tr>
	                    <th scope="col">성명</th>
	                    <th scope="col">생년월일</th>
	                    <th scope="col">휴대전화</th>
	                    <th scope="col">이메일</th>
	                    <th scope="col">주소</th>
	                    <th scope="col">관계</th>
	                    <c:if test="${bunyangInfo.progress_status != 'E'}">
	                    <th scope="col"></th>
	                    </c:if>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:if test="${not empty agentUser}">
	            	<tr>
	            		<td>${agentUser.user_name}</td>
	            		<td>${cutil:getBirthDateFormatString(agentUser.birth_date)}</td>
	            		<td>${cutil:getMobileFormatString(agentUser.mobile)}</td>
	            		<td>${agentUser.email}</td>
	            		<td align="left">(${agentUser.post_number})${agentUser.address1}${agentUser.address2}</td>
	            		<td>${agentUser.relation_type_name}</td>
	            		<c:if test="${bunyangInfo.progress_status != 'E'}">
	            		<td><button type="button" class="btn btn-default btn-sm" onclick="deleteAgentUserRow(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>
	            		</c:if>
	            	</tr>
	            	</c:if>
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
        		<c:if test="${bunyangInfo.progress_status != 'E'}">
        		<col width="5%">
        		</c:if>
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
                    <c:if test="${bunyangInfo.progress_status != 'E'}">
                    <th scope="col"></th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${useUser}" var="use" varStatus="status">
            	<tr useName="${use.user_name}">
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
            		<td name="userName">${use.user_name}</td>
            		<td name="birthDate">${cutil:getBirthDateFormatString(use.birth_date)}</td>
            		<td name="mobile">${cutil:getMobileFormatString(use.mobile)}</td>
            		<td align="left" name="address">(${use.post_number})${use.address1}${use.address2}</td>
            		<td name="relation">${use.relation_type_name}</td>
            		<td name="ischurch">${use.is_church_person}</td>
            		<td name="isMove">${use.is_move}</td>
            		<c:if test="${bunyangInfo.progress_status != 'E'}">
            		<c:choose>
            			<c:when test="${!empty use.couple_seq}">
            				<c:set var="nextVal" value="${useUser[status.count]}"/>
            				<c:if test="${nextVal.couple_seq == use.couple_seq}">
	            				<td rowspan="2"><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this,'couple')">수정</button>
            				</c:if>
            			</c:when>
            			<c:otherwise>
            				<td><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this,'single')">수정</button>
            			</c:otherwise>
            		</c:choose>
            		</c:if>
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
            		<c:choose>
            		<c:when test="${bunyangInfo.progress_status != 'E'}">
            		<td align="left" class="form-inline" colspan="3">
            			<label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_APPLY_USER %>"
            			<c:if test="${bunyangInfo.service_charge_type == 'APPLY_USER'}">checked</c:if>>신청자</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_USE_USER %>"
	                    <c:if test="${bunyangInfo.service_charge_type == 'USE_USER'}">checked</c:if>>각 사용자별 납부</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT %>"
	                    <c:if test="${bunyangInfo.service_charge_type == 'REPRESENT'}">checked</c:if>>사용자 중 1인 대표</label>
	                    <select id="selMaintCharger" class="form-control <c:if test="${bunyangInfo.service_charge_type != 'REPRESENT'}">hidden</c:if>" style="width: 100px; margin-left: 10px;">
							<option value="">선택</option>
							<c:forEach var="user" items="${useUser}">
								<option value="${user.user_id}"
								<c:if test="${bunyangInfo.service_charge_type == 'REPRESENT' && user.is_maint_charger == 'Y'}">selected</c:if>>${user.user_name}</option>
							</c:forEach>
						</select>
            		</td>
            		</c:when>
            		<c:otherwise>
            		<td align="left" colspan="3">
            		${bunyangInfo.service_charge_type_name}
            		<c:if test="${bunyangInfo.service_charge_type == 'REPRESENT'}"> : ${bunyangInfo.maint_charger_name}</c:if>
            		</td>
            		</c:otherwise>
            		</c:choose>
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
        <c:if test="${bunyangInfo.progress_status != 'E'}">
        <button type="button" class="btn btn-primary btn-lg" onclick="saveChangedInfo()">저장</button>
        </c:if>
        <c:if test="${bunyangInfo.progress_status != 'E'}">
        <button type="button" class="btn btn-danger btn-lg" onclick="cancelContract()">해약</button>
        </c:if>
        <button type="button" class="btn btn-default btn-lg" onclick="goToList()">목록</button>
    </div>
    
</div>

<!-- 신청자정보 -->
<ul id="applyUser" style="display: none;">
	<li userId="${applyUser.user_id}" refType="${applyUser.ref_type}" userName="${applyUser.user_name}" birthDate="${applyUser.birth_date }" gender="${applyUser.gender }"
	churchOfficer="${applyUser.church_officer}" diocese="${applyUser.diocese}" relationType="${applyUser.relation_type}"  
	mobile="${applyUser.mobile }" phone="${applyUser.phone }" email="${applyUser.email}"
	postNumber="${applyUser.post_number }" address1="${applyUser.address1 }" address2="${applyUser.address2}" fulladdress="(${applyUser.post_number})${applyUser.address1}${applyUser.address2}"
	isChurchPerson="${applyUser.is_church_person}" isMove="${applyUser.is_move}" relationTypeName="${applyUser.relation_type_name}"
	></li>
</ul>
<!-- 대리인정보 -->
<c:if test="${not empty agentUser}">
<ul id="agentUser" style="display: none;">
	<li userId="${agentUser.user_id}" refType="${agentUser.ref_type}" userName="${agentUser.user_name}" birthDate="${agentUser.birth_date }" gender="${agentUser.gender }"
	churchOfficer="${agentUser.church_officer}" diocese="${agentUser.diocese}" relationType="${agentUser.relation_type}"  
	mobile="${agentUser.mobile }" phone="${agentUser.phone }" email="${agentUser.email}"
	postNumber="${agentUser.post_number}" address1="${agentUser.address1 }" address2="${agentUser.address2}" fulladdress="(${agentUser.post_number})${agentUser.address1}${agentUser.address2}"
	isChurchPerson="${agentUser.is_church_person}" isMove="${agentUser.is_move}" relationTypeName="${agentUser.relation_type_name}"
	></li>
</ul>
</c:if>
<!-- 사용(봉안)대상자 정보 -->
<ul id="useUserList" style="display: none;">
	<c:forEach var="user" items="${useUser}">
		<li userId="${user.user_id}" refType="${user.ref_type}" userName="${user.user_name}" birthDate="${user.birth_date }" gender="${user.gender }"
		churchOfficer="${user.church_officer}" diocese="${user.diocese}" relationType="${user.relation_type}"  
		mobile="${user.mobile }" phone="${user.phone }" email="${user.email}"
		postNumber="${user.post_number }" address1="${user.address1 }" address2="${user.address2}" fulladdress="(${user.post_number})${user.address1}${user.address2}"
		isChurchPerson="${user.is_church_person}" isMove="${user.is_move}" relationTypeName="${user.relation_type_name}"
		></li>
	</c:forEach>
</ul>


<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">

// 변경여부
var changed = false;

// 변경된 정보
var changedBunyangInfo = {
		bunyangSeq: '${bunyangSeq}'
};
// 대리인 정보
var agentUser;
// 사용(봉안대상)자 정보
var useUsers = [];

// init 함수
(function(){
	
	if($('#agentUser li').length > 0) {
		agentUser = {};
		agentUser['userId'] = $('#agentUser li').attr('userId');
		agentUser['userName'] = $('#agentUser li').attr('userName');
		agentUser['birthDate'] = $('#agentUser li').attr('birthDate');
		agentUser['gender'] = $('#agentUser li').attr('gender');
		agentUser['mobile'] = $('#agentUser li').attr('mobile');
		agentUser['phone'] = $('#agentUser li').attr('phone');
		agentUser['postNumber'] = $('#agentUser li').attr('postNumber');
		agentUser['address1'] = $('#agentUser li').attr('address1');
		agentUser['address2'] = $('#agentUser li').attr('address2');
		agentUser['fulladdress'] = $('#agentUser li').attr('fulladdress');
		agentUser['isAgent'] = true;
		agentUser['email'] = $('#agentUser li').attr('email');
		agentUser['relationType'] = $('#agentUser li').attr('relationType');
		agentUser['relationTypeName'] = $('#agentUser li').attr('relationTypeName');
		agentUser['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER%>';
	}
	
	//  사용(봉안대상)자 정보
	$('#useUserList li').each(function(idx, item) {
		var useUserInfo = {};
		useUserInfo['userId'] = $(this).attr('userId');
		useUserInfo['userName'] = $(this).attr('userName');
		useUserInfo['birthDate'] = $(this).attr('birthDate');
		useUserInfo['gender'] = $(this).attr('gender');
		useUserInfo['mobile'] = $(this).attr('mobile');
		useUserInfo['phone'] = $(this).attr('phone');
		useUserInfo['postNumber'] = $(this).attr('postNumber');
		useUserInfo['address1'] = $(this).attr('address1');
		useUserInfo['address2'] = $(this).attr('address2');
		useUserInfo['fulladdress'] = $(this).attr('fulladdress');
		useUserInfo['email'] = $(this).attr('email');
		useUserInfo['relationType'] = $(this).attr('relationType');
		useUserInfo['relationTypeName'] = $(this).attr('relationTypeName');
		useUserInfo['isChurchPerson'] = $(this).attr('isChurchPerson');
		useUserInfo['isMove'] = $(this).attr('isMove');
		useUserInfo['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>';
		useUsers.push(useUserInfo);
	});
	
	// 관리비 납부자 radio button 변경이벤트
	$("input[name=rbServiceChargeType]:radio").change(function(e) {
		var selectedVal = $(":input:radio[name=rbServiceChargeType]:checked").val();
		if(selectedVal == '<%=CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT%>') {
			$('#selMaintCharger').removeClass('hidden');
		} else {
			$('#selMaintCharger').addClass('hidden');
		}
		changed = true;
		changedBunyangInfo.serviceChargeType = selectedVal;
	});
	
	$('#selMaintCharger').change(function(e) {
		changed = true;
	});
})();

/**
 * 목록 클릭
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/contractormgmt";
	frm.submit();
}

/**
 * 신청자 수정
 */
function editApplyUser() {
	var applyUserId = $('#applyUser li').attr('userId');
	var winoption = {width:1024, height:640};
	var param = {popupTitle: "신청자 수정", popupType:'1'};
	param = getUserParam(param);
	param['selectedUserId'] = applyUserId;
	common.openWindow("${contextPath}/popup/selectuser", "popRegistApplyUser", winoption, param);
	
	// 신청자 입력 팝업 callback 함수
	window.selectuserCallBack = function(item) {
		var idx = 0, userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', churchOfficerName = '', diocese = '';
		if(item && item.length > 0) {
			var oneSelfUserIdx = -1;
			$.each(useUsers, function(idx, item) {
				if(item.relationType == 'ONESELF') {
					oneSelfUserIdx = idx;
					return false;
				}
			});
			
			// 사용(봉안)대상자 중 신청자 본인이 있을 경우
			if(oneSelfUserIdx >= 0 && !confirm('사용(봉안) 대상자 중 신청자 본인이 있습니다.\n신청자 변경시 해당 정보도 변경됩니다.\n진행하시겠습니까?')) {
				return;
			}
			var tr = $("<tr/>");
			userName = item[idx++];
			birthDate = item[idx++];
			gender = item[idx++];
			mobile = item[idx++];
			phone = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			fulladdress = item[idx++];
			churchOfficer = item[idx++];
			churchOfficerName = item[idx++];
			diocese = item[idx++];
			email = item[idx++];
			
			var applyUser = {};
			applyUser['userId'] = applyUserId;
			applyUser['userName'] = userName;
			applyUser['birthDate'] = birthDate;
			applyUser['gender'] = gender;
			applyUser['mobile'] = mobile;
			applyUser['phone'] = phone;
			applyUser['postNumber'] = postNumber;
			applyUser['address1'] = address1;
			applyUser['address2'] = address2;
			applyUser['fulladdress'] = fulladdress;
			applyUser['churchOfficer'] = churchOfficer;
			applyUser['churchOfficerName'] = churchOfficerName;
			applyUser['diocese'] = diocese;
			applyUser['isAgent'] = false;
			applyUser['email'] = email;
			applyUser['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>';
			
			tr.append('<td>'+userName+"</td>");
			tr.append('<td>'+birthDate+"</td>");
			tr.append('<td>'+mobile+"</td>");
			tr.append('<td>'+email+"</td>");
			tr.append('<td align="left">'+fulladdress+"</td>");
			tr.append('<td>'+churchOfficerName+"</td>");
			tr.append('<td>'+diocese+"</td>");
			
			$("#tblApplyUser tbody").html(tr);
			changed = true;
			changedBunyangInfo.applyUser = applyUser;
			// 사용(봉안)대상자 중 신청자 본인이 있을 경우 해당정보도 변경해줌
			if(oneSelfUserIdx >= 0) {
				useUsers[oneSelfUserIdx]['userName'] = applyUser['userName'];
				useUsers[oneSelfUserIdx]['birthDate'] = applyUser['birthDate'];
				useUsers[oneSelfUserIdx]['gender'] = applyUser['gender'];
				useUsers[oneSelfUserIdx]['mobile'] = applyUser['mobile'];
				useUsers[oneSelfUserIdx]['phone'] = applyUser['phone'];
				useUsers[oneSelfUserIdx]['postNumber'] = applyUser['postNumber'];
				useUsers[oneSelfUserIdx]['address1'] = applyUser['address1'];
				useUsers[oneSelfUserIdx]['address2'] = applyUser['address2'];
				useUsers[oneSelfUserIdx]['fulladdress'] = applyUser['fulladdress'];
				useUsers[oneSelfUserIdx]['email'] = applyUser['email'];
				useUsers[oneSelfUserIdx]['relationType'] = 'ONESELF';
				useUsers[oneSelfUserIdx]['relationTypeName'] = '본인';
				useUsers[oneSelfUserIdx]['isChurchPerson'] = 'Y';
				var tr = $("#tblUseUser tbody tr").eq(oneSelfUserIdx);
				tr.find('td[name="userName"]').text(useUsers[oneSelfUserIdx]['userName']);
				tr.find('td[name="birthDate"]').text(useUsers[oneSelfUserIdx]['birthDate']);
				tr.find('td[name="mobile"]').text(useUsers[oneSelfUserIdx]['mobile']);
				tr.find('td[name="address"]').text(useUsers[oneSelfUserIdx]['fulladdress']);
				tr.find('td[name="relation"]').text(useUsers[oneSelfUserIdx]['relationTypeName']);
				tr.find('td[name="ischurch"]').text(useUsers[oneSelfUserIdx]['isChurchPerson']);
				tr.find('td[name="isMove"]').text(useUsers[oneSelfUserIdx]['isMove']);
				
				updateSelectBoxMaintCharger();
			}
		}
	};
}

/**
 * 대리인 입력/수정
 */
function editAgentUser() {
	var agentUserId = $('#agentUser li').attr('userId');
	var winoption = {width:1024, height:640};
	var param = {popupTitle: "대리인 입력", popupType:'2'};
	param = getUserParam(param);
	param['selectedUserId'] = agentUserId ? agentUserId : '';
	common.openWindow("${contextPath}/popup/selectuser", "popRegistAgentUser", winoption, param);
	
	// 대리인 입력 팝업 callback 함수
	window.selectuserCallBack = function(item) {
		var idx = 0, userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '', relationType = '', relationTypeName = '';
		if(item && item.length > 0) {
			var tr = $("<tr/>");
			userName = item[idx++];
			birthDate = item[idx++];
			gender = item[idx++];
			mobile = item[idx++];
			phone = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			fulladdress = item[idx++];
			churchOfficer = item[idx++];
			churchOfficerName = item[idx++];
			diocese = item[idx++];
			email = item[idx++];
			relationType = item[idx++];
			relationTypeName = item[idx++];
			
			agentUser = {};
			agentUser['userId'] = agentUserId ? agentUserId : '';
			agentUser['userName'] = userName;
			agentUser['birthDate'] = birthDate;
			agentUser['gender'] = gender;
			agentUser['mobile'] = mobile;
			agentUser['phone'] = phone;
			agentUser['postNumber'] = postNumber;
			agentUser['address1'] = address1;
			agentUser['address2'] = address2;
			agentUser['fulladdress'] = fulladdress;
			agentUser['isAgent'] = true;
			agentUser['email'] = email;
			agentUser['relationType'] = relationType;
			agentUser['relationTypeName'] = relationTypeName;
			agentUser['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER%>';
			
			tr.append('<td>'+userName+"</td>");
			tr.append('<td>'+birthDate+"</td>");
			tr.append('<td>'+mobile+"</td>");
			tr.append('<td>'+email+"</td>");
			tr.append('<td align="left">'+fulladdress+"</td>");
			tr.append('<td>'+relationTypeName+"</td>");
			tr.append('<td><button type="button" class="btn btn-default btn-sm" onclick="deleteAgentUserRow(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>');
			
			$("#tblAgentUser tbody").html(tr);
			
			changed = true;
			changedBunyangInfo.agentUser = agentUser;
		}
	};
}

/**
 * 사용(봉안)대상자 정보 수정
 */
function editUseUser(btn, type) {
	// 선택한 행 index
	var startIdx = $(btn).parent('td').parent('tr').index();
	var count = $(btn).parent('td').attr('rowspan');
	
	var winoption = {width:1024, height:750};
	if(type == 'single') {
		winoption['height'] = 640;
	}
	var param = {popupTitle: "사용(봉안) 대상자 수정", popupType:type};
	param = getUserParam(param);
	param['rowIdx'] = startIdx;
	common.openWindow("${contextPath}/popup/registuseuser", "popRegistUseUser", winoption, param);
	
	if(type == 'couple') {// 부부형
		// 사용(봉안) 대상자 입력 팝업 callback 함수
		window.selectuserCallBack = function(item1, item2, isOneSelf) {
			if(!item1 || item1.length == 0 || !item2 || item2.length == 0) {
				return;
			}
			changed = true;
			var useUser1 = setUseUser(item1, startIdx);
			var useUser2 = setUseUser(item2, startIdx+1);
			var tr1 = $('<tr/>');
			var tr2 = $('<tr/>');
			tr1.append('<td rowspan="2" class="coupletype">부부형</td>');
			tr1.append('<td name="userName">' + useUser1['userName'] + '</td>');
			tr1.append('<td name="birthDate">' + useUser1['birthDate'] + '</td>');
			tr1.append('<td name="mobile">' + useUser1['mobile'] + '</td>');
			tr1.append('<td name="address" align="left">' + useUser1['fulladdress'] + '</td>');
			tr1.append('<td name="relation">' + useUser1['relationTypeName'] + '</td>');
			tr1.append('<td name="ischurch">' + useUser1['isChurchPerson'] + '</td>');
			tr1.append('<td>' + useUser1['isMove'] + '</td>');
			tr1.append('<td rowspan="2" class="form-inline"><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this,\'couple\')">수정</button></td>');
			
			tr2.append('<td name="userName">' + useUser2['userName'] + '</td>');
			tr2.append('<td name="birthDate">' + useUser2['birthDate'] + '</td>');
			tr2.append('<td name="mobile">' + useUser2['mobile'] + '</td>');
			tr2.append('<td name="address" align="left">' + useUser2['fulladdress'] + '</td>');
			tr2.append('<td name="relation">' + useUser2['relationTypeName'] + '</td>');
			tr2.append('<td name="ischurch">' + useUser2['isChurchPerson'] + '</td>');
			tr2.append('<td>' + useUser2['isMove'] + '</td>');
			
			$("#tblUseUser tbody tr").eq(startIdx).replaceWith(tr1);
			$("#tblUseUser tbody tr").eq(startIdx+1).replaceWith(tr2);
			
			updateSelectBoxMaintCharger();
		};
	} else {// 1인형
		// 사용(봉안) 대상자 입력 팝업 callback 함수
		window.selectuserCallBack = function(item1, isOneSelf) {
			if(!item1 || item1.length == 0) {
				return;
			}
			changed = true;
			var useUser1 = setUseUser(item1, startIdx);
			var tr1 = $('<tr/>');
			tr1.append('<td rowspan="1" class="singletype">1인형</td>');
			tr1.append('<td name="userName">' + useUser1['userName'] + '</td>');
			tr1.append('<td name="birthDate">' + useUser1['birthDate'] + '</td>');
			tr1.append('<td name="mobile">' + useUser1['mobile'] + '</td>');
			tr1.append('<td name="address" align="left">' + useUser1['fulladdress'] + '</td>');
			tr1.append('<td name="relation">' + useUser1['relationTypeName'] + '</td>');
			tr1.append('<td name="ischurch">' + useUser1['isChurchPerson'] + '</td>');
			tr1.append('<td>' + useUser1['isMove'] + '</td>');
			tr1.append('<td rowspan="1" class="form-inline"><button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this, \'single\')">수정</button><button type="button" class="btn btn-danger btn-sm" style="margin-left:3px;" onclick="deleteUseUserRow(this)">삭제</button></td>');
			
			$("#tblUseUser tbody tr").eq(startIdx).replaceWith(tr1);
			
			updateSelectBoxMaintCharger();
		};
	}
}

/**
 * 변경한 정보 저장
 */
function saveChangedInfo() {
	if(!changed) {
		common.showAlert('변경된 정보가 없습니다.');
		return;
	}
	var maintCharger = $('#selMaintCharger option:selected').val();
	var serviceChargeType = $(":input:radio[name=rbServiceChargeType]:checked").val();
	var i;
	changedBunyangInfo.serviceChargeType = serviceChargeType;
	changedBunyangInfo.progressStatus = '${bunyangInfo.progress_status}';
	
	for(i = 0; i < useUsers.length; i++) {
		var user = useUsers[i];
		user['isMaintCharger'] = 'N';
	}
	
	// 관리비 납부 사용자 대표의 경우
	if(serviceChargeType == '<%=CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT%>') {
		if(!maintCharger) {
			common.showAlert("사용자중 관리비 납부자를 선택해주세요.");
			$('#selMaintCharger').focus();
			return;
		}
		// 사용자 대표
		for(var i = 0; i < useUsers.length; i++) {
			var user = useUsers[i];
			if(user.userId == maintCharger) {
				user['isMaintCharger'] = 'Y';
			}
		}
	}
	changedBunyangInfo.agentUser = agentUser;
	changedBunyangInfo.useUsers = useUsers;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/admin/changeContractInfo", 
		data:JSON.stringify(changedBunyangInfo),
		contentType: 'application/json',
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/admin/contractordetail";
				frm.submit();
			}
		}
	});
	
}

/**
 * 대리인 행 삭제
 */
function deleteAgentUserRow(btn) {
	deleteRow(btn);
	changed = true;
	agentUser = null;
}

/**
 * 행삭제
 * @param btn 삭제 버튼
 */
function deleteRow(btn) {
	var td = $(btn).parent("td"); 
	var rowspan = td.attr('rowspan');
	var tr = td.parent("tr"); 
	if(rowspan > 0) {
		var nexttR;
		for(var i = 0; i < rowspan; i++) {
			nextTr = tr.next('tr'); 
			tr.remove();
			tr = nextTr;
		}
	}else {
		tr.remove();
	}
}

/**
 * 신청자,대리인,사용(봉안)대상자 수정팝업에서 참조할 사용자정보 반환 
 */
function getUserParam(param) {
	var liApplyUser = $('#applyUser li');
	var liAgentUser = $('#agentUser li');
	var idx = 0;
	var applyUser;
	var agentUser;
	var useUser;
	
	// 신청자
	if(changedBunyangInfo && changedBunyangInfo.applyUser) {
		applyUser = changedBunyangInfo.applyUser;
		param['users['+idx+'].userId'] = applyUser.userId;
		param['users['+idx+'].userName'] = applyUser.userName;
		param['users['+idx+'].birthDate'] = applyUser.birthDate;
		param['users['+idx+'].gender'] = applyUser.gender;
		param['users['+idx+'].churchOfficer'] = applyUser.churchOfficer;
		param['users['+idx+'].diocese'] = applyUser.diocese;
		param['users['+idx+'].mobile'] = applyUser.mobile;
		param['users['+idx+'].phone'] = applyUser.phone;
		param['users['+idx+'].postNumber'] = applyUser.postNumber;
		param['users['+idx+'].address1'] = applyUser.address1;
		param['users['+idx+'].address2'] = applyUser.address2;
		param['users['+idx+'].fulladdress'] = applyUser.fulladdress;
		param['users['+idx+'].email'] = applyUser.email;
		param['users['+idx+'].refType'] = applyUser.refType;
		idx++;
	} else {
		if(liApplyUser && liApplyUser.length > 0) {
			param['users['+idx+'].userId'] = liApplyUser.attr('userId');
			param['users['+idx+'].userName'] = liApplyUser.attr('userName');
			param['users['+idx+'].birthDate'] = liApplyUser.attr('birthDate');
			param['users['+idx+'].gender'] = liApplyUser.attr('gender');
			param['users['+idx+'].churchOfficer'] = liApplyUser.attr('churchOfficer');
			param['users['+idx+'].diocese'] = liApplyUser.attr('diocese');
			param['users['+idx+'].mobile'] = liApplyUser.attr('mobile');
			param['users['+idx+'].phone'] = liApplyUser.attr('phone');
			param['users['+idx+'].postNumber'] = liApplyUser.attr('postNumber');
			param['users['+idx+'].address1'] = liApplyUser.attr('address1');
			param['users['+idx+'].address2'] = liApplyUser.attr('address2');
			param['users['+idx+'].fulladdress'] = liApplyUser.attr('fulladdress');
			param['users['+idx+'].email'] = liApplyUser.attr('email');
			param['users['+idx+'].refType'] = liApplyUser.attr('refType');
			idx++;
		}
	}
	
	// 대리인
	if(changedBunyangInfo && changedBunyangInfo.agentUser) {
		agentUser = changedBunyangInfo.agentUser;
		param['users['+idx+'].userId'] = agentUser.userId;
		param['users['+idx+'].userName'] = agentUser.userName;
		param['users['+idx+'].birthDate'] = agentUser.birthDate;
		param['users['+idx+'].gender'] = agentUser.gender;
		param['users['+idx+'].relationType'] = agentUser.relationType;
		param['users['+idx+'].relationTypeName'] = agentUser.relationTypeName;
		param['users['+idx+'].mobile'] = agentUser.mobile;
		param['users['+idx+'].phone'] = agentUser.phone;
		param['users['+idx+'].postNumber'] = agentUser.postNumber;
		param['users['+idx+'].address1'] = agentUser.address1;
		param['users['+idx+'].address2'] = agentUser.address2;
		param['users['+idx+'].fulladdress'] = agentUser.fulladdress;
		param['users['+idx+'].email'] = agentUser.email;
		param['users['+idx+'].refType'] = agentUser.refType;
		idx++;
	} else {
		if(liAgentUser && liAgentUser.length > 0) {// 대리인
			param['users['+idx+'].userId'] = liAgentUser.attr('userId');
			param['users['+idx+'].userName'] = liAgentUser.attr('userName');
			param['users['+idx+'].birthDate'] = liAgentUser.attr('birthDate');
			param['users['+idx+'].gender'] = liAgentUser.attr('gender');
			param['users['+idx+'].relationType'] = liAgentUser.attr('relationType');
			param['users['+idx+'].relationTypeName'] = liAgentUser.attr('relationTypeName');
			param['users['+idx+'].mobile'] = liAgentUser.attr('mobile');
			param['users['+idx+'].phone'] = liAgentUser.attr('phone');
			param['users['+idx+'].postNumber'] = liAgentUser.attr('postNumber');
			param['users['+idx+'].address1'] = liAgentUser.attr('address1');
			param['users['+idx+'].address2'] = liAgentUser.attr('address2');
			param['users['+idx+'].fulladdress'] = liAgentUser.attr('fulladdress');
			param['users['+idx+'].email'] = liAgentUser.attr('email');
			param['users['+idx+'].refType'] = liAgentUser.attr('refType');
			idx++;
		}
	}
	
	// 사용자
	$('#useUserList li').each(function() {
		var userId = $(this).attr('userId');
		var exist = false;
		param['users['+idx+'].userId'] = userId;
		if(changedBunyangInfo && changedBunyangInfo.useUser && changedBunyangInfo.useUser.length > 0) {
			$.each(changedBunyangInfo.useUser, function(i, item) {
				if(item.userId == userId) {
					exist = true;
					param['users['+idx+'].userName'] = item['userName'];
					param['users['+idx+'].birthDate'] = item['birthDate'];
					param['users['+idx+'].gender'] = item['gender'];
					param['users['+idx+'].relationType'] = item['relationType'];
					param['users['+idx+'].relationTypeName'] = item['relationTypeName'];
					param['users['+idx+'].mobile'] = item['mobile'];
					param['users['+idx+'].phone'] = item['phone'];
					param['users['+idx+'].postNumber'] = item['postNumber'];
					param['users['+idx+'].address1'] = item['address1'];
					param['users['+idx+'].address2'] = item['address2'];
					param['users['+idx+'].fulladdress'] = item['fulladdress'];
					param['users['+idx+'].email'] = item['email'];
					param['users['+idx+'].refType'] = item['refType'];
					param['users['+idx+'].isChurchPerson'] = item['isChurchPerson'];
					param['users['+idx+'].isMove'] = item['isMove'];
				}
			});
		}
		if(!exist) {
			param['users['+idx+'].userName'] = $(this).attr('userName');
			param['users['+idx+'].birthDate'] = $(this).attr('birthDate');
			param['users['+idx+'].gender'] = $(this).attr('gender');
			param['users['+idx+'].relationType'] = $(this).attr('relationType');
			param['users['+idx+'].relationTypeName'] = $(this).attr('relationTypeName');
			param['users['+idx+'].mobile'] = $(this).attr('mobile');
			param['users['+idx+'].phone'] = $(this).attr('phone');
			param['users['+idx+'].postNumber'] = $(this).attr('postNumber');
			param['users['+idx+'].address1'] = $(this).attr('address1');
			param['users['+idx+'].address2'] = $(this).attr('address2');
			param['users['+idx+'].fulladdress'] = $(this).attr('fulladdress');
			param['users['+idx+'].email'] = $(this).attr('email');
			param['users['+idx+'].refType'] = $(this).attr('refType');
			param['users['+idx+'].isChurchPerson'] = $(this).attr('isChurchPerson');
			param['users['+idx+'].isMove'] = $(this).attr('isMove');
		}
		idx++;
	});
	return param;
}

/**
 * 팝업에서 입력한 사용(봉안)대상자 정보반환
 */
function setUseUser(item, userIdx) {
	var idx = 0, userId = '', userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '', relationType = '', relationTypeName = '', isChurchPerson = '', isMove = '';
	var rtnVal = {};
	if(item && item.length > 0) {
		idx++;
		userId = $('#useUserList li').eq(userIdx).attr('userId');
		userName = item[idx++];
		birthDate = item[idx++];
		gender = item[idx++];
		mobile = item[idx++];
		phone = item[idx++];
		postNumber = item[idx++];
		address1 = item[idx++];
		address2 = item[idx++];
		fulladdress = item[idx++];
		churchOfficer = item[idx++];
		churchOfficerName = item[idx++];
		diocese = item[idx++];
		email = item[idx++];
		relationType = item[idx++];
		relationTypeName = item[idx++];
		isChurchPerson = item[idx++];
		isMove = item[idx++];
		useUsers[userIdx]['userId'] = userId;
		useUsers[userIdx]['userName'] = userName;
		useUsers[userIdx]['birthDate'] = birthDate;
		useUsers[userIdx]['gender'] = gender;
		useUsers[userIdx]['mobile'] = mobile;
		useUsers[userIdx]['phone'] = phone;
		useUsers[userIdx]['postNumber'] = postNumber;
		useUsers[userIdx]['address1'] = address1;
		useUsers[userIdx]['address2'] = address2;
		useUsers[userIdx]['fulladdress'] = fulladdress;
		useUsers[userIdx]['email'] = email;
		useUsers[userIdx]['relationType'] = relationType;
		useUsers[userIdx]['relationTypeName'] = relationTypeName;
		useUsers[userIdx]['isChurchPerson'] = isChurchPerson;
		useUsers[userIdx]['isMove'] = isMove;
		useUsers[userIdx]['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>';
		rtnVal = useUsers[userIdx];
	}
	return rtnVal;
}

/**
 * 사용자 중 1인 대표에서 선택할 사용자 리스트 업데이트
 */
function updateSelectBoxMaintCharger() {
	var options = '<option value="">선택</option>';
	if(useUsers && useUsers.length > 0) {
		$.each(useUsers, function(idx, item) {
			var userId = item.userId;
			options += '<option value="' + userId + '">' + item.userName + '</option>';
		});
	}
	var selectedVal = $('#selMaintCharger option:selected').val();
	$('#selMaintCharger').html(options);
	$('#selMaintCharger option[value="' + selectedVal + '"]').attr('selected', 'selected');
}

/**
 * 해약
 */
function cancelContract(progressStatus) {
	var bunyangSeq = '${bunyangSeq}';
	var winoption = {width:1024, height:690};
	var param = {bunyangSeq: bunyangSeq};
	common.openWindow("${contextPath}/popup/contractcancel", "popContractCancel", winoption, param);
	window.contractCancelCallBack = function(result) {
		if(result && result.result) {
			common.showAlert('해약처리가 승인되었습니다.');
			// 승인서 파일번호
			var fileSeq = result.fileSeq;
			donwloadFile(fileSeq);
			setTimeout(function(){
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/admin/contractordetail";
				frm.submit();
			}, 100);
		}		
	}
}

/**
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>