<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="poptitle">
    <strong>${popupTitle}</strong>
    <button type="button" class="close btnClose" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div class="content" style="padding: 10px 10px;">

    <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#selectTab">등록 교인</a></li>
        <li><a data-toggle="tab" href="#inputTab">직접 입력</a></li>
    </ul>

    <div class="tab-content">

        <!-- 사용자 선택탭 -->
        <div id="selectTab" class="tab-pane fade in active" style="margin-top: 10px;">
            <form id="frm" method="post">
                <input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
                <input type="hidden" id="popupTitle" name="popupTitle" value="${popupTitle}">
                <!-- 검색 -->
                <div class="bx-border p-20 mb-20" style="margin-bottom: 10px;">
                    <div class="row">
                        <div class="col-xs-4 col-md-3 pr-10">
                        	<select name="searchKey" class="form-control">
								<option value="user_name">성명</option>
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
                    <table id="tblUserList" class="table table-style">
                        <thead>
                            <tr>
                                <th scope="col">성명</th>
                                <th scope="col">생년월일</th>
                                <th scope="col">이메일</th>
                                <th scope="col">휴대전화</th>
                                <th scope="col" style="max-width: 200px;">주소</th>
                                <th scope="col">직분</th>
                                <th scope="col">교구</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userList}" var="user">
                                <tr class="clickable-row">
                                	<td style="display: none;" data="${user.user_id}"></td>
                                    <td data="${user.user_name}">${user.user_name}</td>
                                    <td data="${user.birth_date}">${cutil:getBirthDateFormatString(user.birth_date)}</td>
                                    <td data="${user.email}">${user.email}</td>
                                    <td data="${user.mobile}">${cutil:getMobileFormatString(user.mobile)}</td>
                                    <td style="display: none;" data="${user.post_number}"></td>
                                    <td style="display: none;" data="${user.address1}"></td>
                                    <td style="display: none;" data="${user.address2}"></td>
                                    <td data="(${user.post_number}) ${user.address1} ${user.address2}">(${user.post_number}) ${user.address1} ${user.address2}</td>
                                    <td style="display: none;" data="${user.church_officer}"></td>
                                    <td data="${user.church_officer_name}">${user.church_officer_name}</td>
                                    <td data="${user.diocese}">${user.diocese}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 페이징 -->
                <div id="divPagination" class="text-center">
                </div>

            </form>
        </div>

        <!-- 직접입력탭 -->
        <div id="inputTab" class="tab-pane fade" style="margin-top: 10px;">

            <div class="alert alert-info" style="margin-bottom: 10px;">
                <strong>! 등록 교인이 아닌 경우만 입력해주세요. </strong>
            </div>
			<form id="frmInputUser" class="form-horizontal">
				<div class="table-responsive" style="border-top: 1px solid #999;">
			        <table class="table table-style" style="border-top: 0;">
			        	<colgroup>
			        		<col width="150">
			        		<col width="*">
			        	</colgroup>
			            <tbody>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static required">성명</p></th>
			            		<td align="left" colspan="5">
			            			<input id="tiUserName" autocomplete="off" class="form-control" type="text" style="width: 200px;" data-validation="required" data-validation-error-msg="성명을 입력하세요.">
			            		</td>
			            	</tr>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static required">생년월일</p></th>
			            		<td align="left">
			            			<input id="tiBirthDate" type="text" class="form-control" style="width: 200px;" placeholder="YYYY-MM-DD" data-validation="required" data-validation-error-msg="생년월일을 입력하세요." value="1970-01-01">
			            		</td>
			            	</tr>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static">이메일</p></th>
			            		<td align="left">
			            			<input id="tiEmail" class="form-control" type="text" style="width: 200px;" data-validation="validEmail">
			            		</td>
			            	</tr>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static required">휴대전화</p></th>
			            		<td align="left">
			            			<input id="tiMobile" class="form-control" type="text" style="width: 200px;" placeholder="'-' 제외하고 숫자만입력" data-validation="validMobile">
			            		</td>
			            	</tr>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static required">우편번호</p></th>
			            		<td align="left">
			            			<input id="tiPostNumber" class="form-control" type="text" style="width: 200px;" data-validation="validPostNumber">
			            		</td>
			            	</tr>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static required">주소</p></th>
			            		<td align="left">
			            			<input id="tiAddress" class="form-control" type="text" data-validation="required" data-validation-error-msg="주소를 입력하세요.">
			            		</td>
			            	</tr>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static">직분</p></th>
			            		<td align="left">
			            			<select id="selOfficer" class="form-control" style="width:  200px;">
			            				<option value="">======= 선택 =======</option>
			            				<c:forEach items="${officerList}" var="officer">
			            					<option value="${officer.code_seq}">${officer.code_name}</option>
			            				</c:forEach>
			            			</select>
			            		</td>
			            	</tr>
			            	<tr>
			            		<th style="background-color: #f5f5f5;"><p class="form-control-static">교구</p></th>
			            		<td align="left">
			            			<input id="tiDiocese" class="form-control" type="text" style="width: 200px;">
			            		</td>
			            	</tr>
			            </tbody>
			        </table>
			    </div>
			    <div class="mt-30 text-center">
	                <button id="btnConfrim" type="submit" class="btn btn-primary btn-lg">확인</button>
	                <button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
	            </div>
			</form>
        </div>
    </div>
</div>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/daterangepicker.js"></script>
<script type="text/javascript">
(function() {
	
	common.datePicker($("#tiBirthDate"));
	
    // 이메일 유효성체크
    $.formUtils.addValidator({
        name: 'validEmail',
        validatorFunction: function(value, $el, config, language, $form) {
            var bValid = false;
            if (!value || common.isValidMail(value)) {
                bValid = true;
            }
            return bValid;
        },
        errorMessage: '이메일 형식이 유효하지 않습니다.'
    });
    
 	// 휴대전화 유효성체크
    $.formUtils.addValidator({
        name: 'validMobile',
        validatorFunction: function(value, $el, config, language, $form) {
            var bValid = false;
            if (value && common.isValidMobile(value)) {
                bValid = true;
            }
            return bValid;
        },
        errorMessage: "'-'제외하고 숫자만 입력하세요."
    });
 	
 	// 우편번호 유효성체크
    $.formUtils.addValidator({
        name: 'validPostNumber',
        validatorFunction: function(value, $el, config, language, $form) {
            var bValid = false;
            if (value && /^\d{5,6}$/.test(value)) {
                bValid = true;
            }
            return bValid;
        },
        errorMessage: "우편번호가 올바르지 않습니다."
    });

    //$.validate();

 	// 페이징 표시 설정
	$('#divPagination').bootpag({
	   total: Math.ceil(${searchVo.totalCount/searchVo.countPerPage}),
	   page: ${searchVo.pageIndex},
	   maxVisible: 5
	}).on('page', function(event, num){
		_search(num);
	});

    // 그리드 로우 선택시
    $('#tblUserList').on('click', '.clickable-row', function(event) {
        var selectedItems = [];
        $(this).find('td').each(function(idx) {
            selectedItems.push($(this).attr("data"));
        });
        if (window.opener && window.opener.selectuserCallBack != 'undefined') {
            window.opener.selectuserCallBack('select', selectedItems);
        }
        common.closeWindow();
    });

    // 직접입력 확인 클릭
    $("#btnConfrim").click(function(e) {

    	$.validate({
    		validateOnEvent: true,
    		onSuccess: function() {
    			var userId = "";
    			var userName = $('#tiUserName').val();
    	        var birthDate = $("#tiBirthDate").data('daterangepicker').startDate.format('YYYYMMDD');
    	        var email = $('#tiEmail').val();
    	        var mobile = $('#tiMobile').val();
    	        var postNumber = $('#tiPostNumber').val();
    	        var address1 = $('#tiAddress').val();
    	        var address2 = "";
    	        var fulladdress = address1;
    	        var officer = $('#selOfficer option:selected').val();
    	        var officerName = officer ? $('#selOfficer option:selected').text() : '';
    	        var diocese = $('#tiDiocese').val();
    	        
    	        common.ajax({
    	    		url:"${contextPath}/popup/checkduplicateduser", 
    	    		data:{userName:userName, birthDate:birthDate},
    	    		success: function(result) {
    	    			if(result) {
    	    				var isduplicated = result.isduplicated;
    	    				var user = result.user;
    	    				if(isduplicated && confirm('입력하신 사용자와 성명/생년월일이 동일한 등록교인이 있습니다.\n해당 사용자로 입력하시겠습니까?')) {
    	    					userId = user.user_id;
    	    					email = user.email;
    	    					mobile = user.mobile;
    	    					postNumber = user.post_number;
    	    					address1 = user.address1;
    	    					address2 = user.address2;
    	    					fulladdress = postNumber ? '(' + postNumber + ') ' : '';
    	    					fulladdress += address1 ? address1 : '';
    	    					fulladdress += address2 ? address2 : '';
    	    					officer = user.church_officer;
    	    					officerName = user.church_officer_name;
    	    					diocese = user.diocese;
    	    				}
    	    				var selectedItems = [];
    	        	        selectedItems.push(userId);
    	        	        selectedItems.push(userName);
    	        	        selectedItems.push(birthDate);
    	        	        selectedItems.push(email);
    	        	        selectedItems.push(mobile);
    	        	        selectedItems.push(postNumber);
    	        	        selectedItems.push(address1);
    	        	        selectedItems.push(address2);
    	        	        selectedItems.push(fulladdress);
    	        	        selectedItems.push(officer);
    	        	        selectedItems.push(officerName);
    	        	        selectedItems.push(diocese);
    	        	        if(window.opener && window.opener.selectuserCallBack != 'undefined') {
    	            			window.opener.selectuserCallBack('input', selectedItems);
    	            		}
    	            		common.closeWindow();
    	    			}
    	    		}
    	    	});
                return false;  // to prevent default submit action
            }
    	});
    });

    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });

})();

/**
 * 사용자 조회
 */
function _search(pageIndex) {
    $("#pageIndex").val(pageIndex ? pageIndex : 1);
    var frm = $("#frm");
    frm.action = "${contextPath}/popup/selectuser";
    frm.submit();
}

</script>