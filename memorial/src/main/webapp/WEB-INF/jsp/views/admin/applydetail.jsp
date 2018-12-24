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
<!-- 	    	<div class="pull-right"> -->
<!-- 	        	<button id="btnRegistAgentUser" type="button" class="btn btn-primary btn-sm" onclick="registApplyUser(true)">입력</button> -->
<!-- 	    	</div> -->
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
<!--     	<div class="pull-right"> -->
<!--         	<button id="btnRegistUseUser" type="button" class="btn btn-primary btn-sm">입력</button> -->
<!--     	</div> -->
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
    <!-- 테이블 -->
    <div class="form-style">
        <div class="form-group">
            <div class="row">
                <label for="input1" class="col-sm-2 control-label form-control-static">신청형태</label>
                <div class="col-sm-10">
                    <p class="form-control-static" style="display: inline-block;">${bunyangInfo.product_type_name}</p>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label for="input2" class="col-sm-2 control-label form-control-static">장묘형태</label>
                <div class="col-sm-10">
                    <p class="form-control-static" style="display: inline-block;">부부형</p>
                    <input id="tiCoupleTypeCount" disabled class="form-control" style="width: 95px;display: inline-block; margin-left: 4px;" type="number" placeholder="기수입력" value="${bunyangInfo.couple_type_count }">
                    <p class="form-control-static" style="display: inline-block;">x 2</p>
                    <p class="form-control-static" style="display: inline-block; margin-left: 20px;">1인형</p>
                    <input id="tiSingleTypeCount" disabled class="form-control" style="width: 95px;display: inline-block; margin-left: 4px;" type="number" placeholder="기수입력" value="${bunyangInfo.single_type_count }">
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label for="input4" class="col-sm-2 control-labe form-control-staticl">관리비 납부자</label>
                <div class="col-sm-10">
                    <p class="form-control-static" style="display: inline-block;">${bunyangInfo.service_charge_type_name}</p>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label for="input4" class="col-sm-2 control-label form-control-static">총 분양가</label>
                <div class="col-sm-2">
                    <p class="form-control-static"><fmt:formatNumber value="${(bunyangInfo.couple_type_count*2 + bunyangInfo.single_type_count)*2000000}" pattern="#,###" />원</p>
                </div>
            </div>
        </div>
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
        <button id="btnApproval" type="button" class="btn btn-info btn-lg">승인</button>
        <button id="btnReject" type="button" class="btn btn-warning btn-lg">반려</button>
		</c:if>
        <button id="btnList" type="button" class="btn btn-default btn-lg">목록</button>
    </div>
    
</div>
<form id="frm" method="post">
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
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
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>