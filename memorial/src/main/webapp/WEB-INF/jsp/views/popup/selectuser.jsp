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
                <!-- 검색 -->
                <div class="bx-border p-20 mb-20" style="margin-bottom: 10px;">
                    <div class="row">
                        <div class="col-xs-4 col-md-3 pr-10">
                            <select name="searchCondition" class="form-control">
                                <option>성명</option>
                            </select>
                        </div>
                        <div class="col-xs-8 col-md-9 pl-0">
                            <div class="input-group">
                                <input name="userName" type="text" class="form-control" value="${searchVo.userName}">
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
                                <th scope="col">주소</th>
                                <th scope="col">직분</th>
                                <th scope="col">교구</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userList}" var="user">
                                <tr class="clickable-row">
                                	<td style="display: none;" data="${user.user_id}"></td>
                                    <td data="${user.user_name}">${user.user_name}</td>
                                    <td data="${user.birth_date}">${user.birth_date}</td>
                                    <td data="${user.email}">${user.email}</td>
                                    <td data="${user.mobile}">${user.mobile}</td>
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

            <div class="form-group">
                <label for="tiUserName">성명</label>
                <input type="text" class="form-control" id="tiUserName">
            </div>
            <div class="form-group">
                <label for="tiBirthday">생년월일</label>
                <input type="text" class="form-control" id="tiBirthday">
            </div>
            <div class="form-group">
                <label for="tiEmail">이메일</label>
                <input type="email" class="form-control" id="tiEmail">
            </div>
            <div class="form-group">
                <label for="tiMobile">휴대전화</label>
                <input type="text" class="form-control" id="tiMobile" placeholder="'-' 없이 숫자만 입력하세요.">
            </div>
            <div class="form-group">
                <label for="tiPostNumber">우편번호</label>
                <input type="text" class="form-control" id="tiPostNumber">
            </div>
            <div class="form-group">
                <label for="tiAddress">주소</label>
                <input type="text" class="form-control" id="tiAddress">
            </div>

            <div class="mt-30 text-center">
                <button id="btnConfrim" type="button" class="btn btn-primary btn-lg">확인</button>
                <button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
            </div>
        </div>

    </div>
</div>

<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function(){
	// 페이징 표시 설정
	$('#divPagination').bootpag({
	   total: Math.ceil(${15/countPerPage}),
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
		if(window.opener && window.opener.selectuserCallBack != 'undefined') {
			window.opener.selectuserCallBack('select', selectedItems);
		}
		common.closeWindow();
	});
	
	// 직접입력 확인 클릭
	$("#btnConfrim").click(function(e){
		var selectedItems = [];
		if(window.opener && window.opener.selectuserCallBack != 'undefined') {
			window.opener.selectuserCallBack('select', selectedItems);
		}
		common.closeWindow();
	});
	
	// 닫기 클릭
	$("button.btnClose").click(function(e){
		common.closeWindow();
	});
	
})();

/**
 * 사용자 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = $("#frm");
	frm.action = "/${contextPath}/popup/selectuser";
	frm.submit();
}

</script>