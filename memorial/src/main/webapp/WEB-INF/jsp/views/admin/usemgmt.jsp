<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 그리드 샘플 -->
<div class="col-md-9">
	
	<div>
    	<div>
	    	<div class="pull-left"><h4 style="display: inline-block;">동산 사용신청 리스트</h4></div>
	    </div>
	    <div class="clearfix"></div>
	    <div class="table-responsive">
	        <table id="tblAssignInfo" class="table table-style table-bordered">
	            <thead>
	                <tr>
	                    <th scope="col">계약번호</th>
	                    <th scope="col">사용(봉안)자</th>
	                    <th scope="col">신청일자</th>
	                    <th scope="col">신청위치</th>
	                    <th scope="col">승인일자</th>
	                    <th scope="col">승인위치</th>
	                    <th scope="col">상태</th>
	                    <th scope="col"></th>
	                </tr>
	            </thead>
	            <tbody>
	            <c:forEach items="${graveRequestList}" var="rowItem">
					<tr>
	                    <td>${rowItem.bunyang_no}</td>
	                    <td>${rowItem.user_name}</td>
	                    <td>${rowItem.request_date}</td>
	                    <td>${rowItem.request_section_seq}</td>
	                    <td>${rowItem.assign_date}</td>
	                    <td>${rowItem.approval_section_seq}</td>
	                    <td>${rowItem.request_status_exp}</td>
	                    <td></td>
					</tr>
				</c:forEach>
	            </tbody>
	        </table>
	    </div>
    </div>
	
</div>
<form id="frm" method="post">
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">
(function(){
	
})();

</script>