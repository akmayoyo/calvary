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
    		<h4>계약자
    		<c:choose>
    			<c:when test="${bunyangInfo.progress_status == 'C'}">
    			<c:set var="statusExp" value="사용 미승인"/>
    			<c:set var="statusClass" value="label-warning"/>
    			</c:when>
    			<c:when test="${bunyangInfo.progress_status == 'D'}">
    			<c:set var="statusExp" value="사용 승인"/>
    			<c:set var="statusClass" value="label-info"/>
    			</c:when>
    		</c:choose>
    		<span class="label ${statusClass}" style="margin-left: 10px; font-weight: normal;">${bunyangInfo.bunyang_times}차 - ${statusExp}</span>
    		</h4>
    	</div>
    	<c:if test="${bunyangInfo.progress_status != 'E'}">
    	<div class="pull-right">
	        <button class="btn btn-primary" type="button" onclick="succeedContractor()">계약승계</button>
	        <button class="btn btn-primary" type="button" onclick="editApplyUser()">정보수정</button>
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
	            	<c:if test="${not empty agentUser}">
	            	<tr>
	            		<td>${agentUser.user_name}</td>
	            		<td>${cutil:getBirthDateFormatString(agentUser.birth_date)}</td>
	            		<td>${cutil:getMobileFormatString(agentUser.mobile)}</td>
	            		<td>${agentUser.email}</td>
	            		<td align="left">(${agentUser.post_number})${agentUser.address1}${agentUser.address2}</td>
	            		<td>${agentUser.relation_type_name}</td>
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
        		<col width="5%">
        		<col width="5%">
        		<col width="8%">
        		<col width="8%">
        		<col width="17%">
        		<col width="5%">
        		<col width="5%">
        		<col width="5%">
        		<col width="7%">
        		<col width="5%">
        		<col width="5%">
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
                    <th scope="col">승인<br>번호</th>
                    <th scope="col">용인공원<br>확약번호</th>
                    <th scope="col">수정/해약</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${useUser}" var="use" varStatus="status">
            	<tr userId="${use.user_id}" coupleSeq="${use.couple_seq}" assignStatus="${use.assign_status}">
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
            		<td>
            			<c:choose>
            				<c:when test="${not empty use.cancel_seq}">
            					해약
            				</c:when>
            				<c:when test="${not empty use.approval_date}">
            					<c:choose>
            						<c:when test="${use.assign_status == 'OCCUPIED'}">사용(봉안)</c:when>
            						<c:otherwise>사용승인</c:otherwise>
            					</c:choose>
            				</c:when>
            				<c:otherwise>
            				사용미승인
            				</c:otherwise>
            			</c:choose>
            		</td>
            		<td>
            			<c:choose>
            				<c:when test="${not empty use.approval_no}">
            					<span>${use.approval_no}</span>
            				</c:when>
            				<c:when test="${empty use.approval_no}">
            					<span>${bunyangInfo.bunyang_no}-${status.count}</span>
            				</c:when>
            			</c:choose>
            		</td>
            		<td>${use.yongin_no}</td>
            		<td>
            			<c:if test="${use.assign_status != 'OCCUPIED' && empty use.cancel_seq}">
            			<button type="button" class="btn btn-primary btn-sm" onclick="editUseUser(this)">수정</button>
            			<button type="button" class="btn btn-danger btn-sm" onclick="cancelContract(this)">해약</button>
            			</c:if>
            		</td>
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
            		<td align="left" class="form-inline" colspan="3">
            			<label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_APPLY_USER %>"
            			<c:if test="${bunyangInfo.service_charge_type == 'APPLY_USER'}">checked</c:if>>신청자</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_USE_USER %>"
	                    <c:if test="${bunyangInfo.service_charge_type == 'USE_USER'}">checked</c:if>>각 사용자별 납부</label>
	                    <label class="radio-inline"><input type="radio" name="rbServiceChargeType" value="<%= CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT %>"
	                    <c:if test="${bunyangInfo.service_charge_type == 'REPRESENT'}">checked</c:if>>사용자 중 1인 대표</label>
	                    <select id="selMaintCharger" class="form-control" style="width: 100px; margin-left: 10px;<c:if test="${bunyangInfo.service_charge_type != 'REPRESENT'}">display:none;</c:if>">
							<option value="">선택</option>
							<c:forEach var="user" items="${useUser}">
								<option value="${user.user_id}"
								<c:if test="${bunyangInfo.service_charge_type == 'REPRESENT' && user.is_maint_charger == 'Y'}">selected</c:if>>${user.user_name}</option>
							</c:forEach>
						</select>
						<button class="btn btn-primary" type="button" style="margin-left: 5px;" onclick="changeServiceCharger()">저장</button>
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
        <button type="button" class="btn btn-default btn-lg" onclick="goToList()">목록</button>
    </div>
    
</div>


<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">

// init 함수
(function(){
	// 관리비 납부자 radio button 변경이벤트
	$("input[name=rbServiceChargeType]:radio").change(function(e) {
		var selectedVal = $(":input:radio[name=rbServiceChargeType]:checked").val();
		if(selectedVal == '<%=CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT%>') {
			$('#selMaintCharger').show();
		} else {
			$('#selMaintCharger').hide();
		}
		changed = true;
		changedBunyangInfo.serviceChargeType = selectedVal;
	});
	
})();

/**
 * 목록 클릭
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/usechange";
	frm.submit();
}

/**
 * 계약자 승계
 */
function succeedContractor() {
	var winoption = {width:1024, height:740};
	var param = {bunyangSeq:'${bunyangSeq}'};
	common.openWindow("${contextPath}/popup/succeedcontractor", "popSucceedContractor", winoption, param);
	
	// 팝업 callback 함수
	window.selectuserCallBack = function(item) {
		var idx = 0, userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '', relationType = '', relationTypeName = '', changeReason = '', remarks = '';
		if(item && item.length > 0) {
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
			changeReason = item[idx++];
			remarks = item[idx++];
			
			var userVo = {};
			userVo['bunyangSeq'] = '${bunyangSeq}';
			userVo['userName'] = userName;
			userVo['birthDate'] = birthDate;
			userVo['gender'] = gender;
			userVo['mobile'] = mobile;
			userVo['phone'] = phone;
			userVo['postNumber'] = postNumber;
			userVo['address1'] = address1;
			userVo['address2'] = address2;
			userVo['churchOfficer'] = churchOfficer;
			userVo['diocese'] = diocese;
			userVo['email'] = email;
			userVo['relationType'] = relationType;
			userVo['changeReason'] = changeReason;
			userVo['remarks'] = remarks;
			
			common.ajax({
				url:"${contextPath}/admin/succeedContractor", 
				data:userVo,
				success: function(result) {
					if(result && result.result) {
						common.showAlert("저장되었습니다.");
						var frm = document.getElementById("frm");
						frm.action = "${contextPath}/admin/useChangeDetail";
						frm.submit();
					}
				}
			});
		}
	};
}

/**
 * 계약자 수정
 */
function editApplyUser() {
	var winoption = {width:1024, height:640};
	var param = {popupTitle: "계약자 정보 수정"};
	param['userId'] = '${applyUser.user_id}';
	param['bunyangSeq'] = '${bunyangSeq}';
	param['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>';
	common.openWindow("${contextPath}/popup/changeRefUserInfo", "popChangeRefUserInfo", winoption, param);
	
	// 팝업 callback 함수
	window.selectuserCallBack = function(item) {
		var idx = 0, userId = '', userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '', relationType = '', relationTypeName = '', changeReason = '', remarks = '';
		if(item && item.length > 0) {
			userId = item[idx++];
			mobile = item[idx++];
			phone = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			email = item[idx++];
			
			var userVo = {};
			userVo['bunyangSeq'] = '${bunyangSeq}';
			userVo['userId'] = userId;
			userVo['mobile'] = mobile;
			userVo['phone'] = phone;
			userVo['postNumber'] = postNumber;
			userVo['address1'] = address1;
			userVo['address2'] = address2;
			userVo['email'] = email;
			userVo['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER%>';
			
			common.ajax({
				url:"${contextPath}/admin/changeRefUserInfo", 
				data:userVo,
				success: function(result) {
					if(result && result.result) {
						common.showAlert("저장되었습니다.");
						var frm = document.getElementById("frm");
						frm.action = "${contextPath}/admin/useChangeDetail";
						frm.submit();
					}
				}
			});
		}
	};
}

/**
 * 사용(봉안)대상자 정보 수정
 */
function editUseUser(btn) {
	var winoption = {width:1024, height:640};
	var param = {popupTitle: "사용(봉안)자 정보 수정"};
	param['userId'] = $(btn).parent('td').parent('tr').attr('userId');
	param['bunyangSeq'] = '${bunyangSeq}';
	param['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>';
	common.openWindow("${contextPath}/popup/changeRefUserInfo", "popChangeRefUserInfo", winoption, param);
	
	// 팝업 callback 함수
	window.selectuserCallBack = function(item) {
		var idx = 0, userId = '', userName = '', birthDate = '', gender = '', email = '', mobile = '', phone = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '', relationType = '', relationTypeName = '', changeReason = '', remarks = '';
		if(item && item.length > 0) {
			userId = item[idx++];
			mobile = item[idx++];
			phone = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			email = item[idx++];
			
			var userVo = {};
			userVo['bunyangSeq'] = '${bunyangSeq}';
			userVo['userId'] = userId;
			userVo['mobile'] = mobile;
			userVo['phone'] = phone;
			userVo['postNumber'] = postNumber;
			userVo['address1'] = address1;
			userVo['address2'] = address2;
			userVo['email'] = email;
			userVo['refType'] = '<%=CalvaryConstants.BUNYANG_REF_TYPE_USE_USER%>';
			
			common.ajax({
				url:"${contextPath}/admin/changeRefUserInfo", 
				data:userVo,
				success: function(result) {
					if(result && result.result) {
						common.showAlert("저장되었습니다.");
						var frm = document.getElementById("frm");
						frm.action = "${contextPath}/admin/useChangeDetail";
						frm.submit();
					}
				}
			});
		}
	};
}

/**
 * 관리비 납부자 변경
 */
function changeServiceCharger() {
	var maintCharger = $('#selMaintCharger option:selected').val();
	var serviceChargeType = $(":input:radio[name=rbServiceChargeType]:checked").val();
	
	// 관리비 납부 사용자 대표의 경우
	if(serviceChargeType == '<%=CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT%>') {
		if(!maintCharger) {
			common.showAlert("사용자중 관리비 납부자를 선택해주세요.");
			$('#selMaintCharger').focus();
			return;
		}
	} else {
		maintCharger = '';
	}
	var data = {};
	data['bunyangSeq'] = '${bunyangSeq}';
	data['serviceChargeType'] = serviceChargeType;
	data['maintCharger'] = maintCharger;
	
	// 저장 호출
	common.ajax({
		url:"${contextPath}/admin/changeServiceCharger", 
		data:data,
		success: function(result) {
			if(result && result.result) {
				common.showAlert("저장되었습니다.");
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/admin/useChangeDetail";
				frm.submit();
			}
		}
	});
}

/**
 * 해약
 */
function cancelContract(btn) {
	var bunyangSeq = '${bunyangSeq}';
	var winoption = {width:1124, height:590};
	var param = {bunyangSeq: bunyangSeq};
	var tr = $(btn).parent('td').parent('tr');
	var coupleSeq = tr.attr('coupleSeq');
	if(coupleSeq) {// 부부형의 경우
		tr = $('#tblUseUser tbody tr[coupleSeq="' + coupleSeq + '"]');
		if(tr.eq(0).attr('assignStatus') == '<%=CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED%>' || 
				tr.eq(1).attr('assignStatus') == '<%=CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED%>') {
			common.showAlert('부부형의 경우 사용(봉안)기수가 하나라도 있을 경우 해약이 불가합니다.');
			return;
		}
		param['userId1'] = tr.eq(0).attr('userId');
		param['userId2'] = tr.eq(1).attr('userId');
	} else {
		if(tr.attr('assignStatus') == '<%=CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED%>') {
			common.showAlert('미사용(미봉안) 기수에 대해서만 해약이 가능합니다.');
			return;
		}
		param['userId1'] = tr.attr('userId');	
	}
	common.openWindow("${contextPath}/popup/useUserCancel", "popUseUserCancel", winoption, param);
	window.useUserCancelCallBack = function(result) {
		if(result && result.result) {
			common.showAlert('해약처리가 승인되었습니다.');
			var frm = document.getElementById("frm");
			frm.action = "${contextPath}/admin/useChangeDetail";
			frm.submit();
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