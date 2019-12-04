<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="${searchVo.searchKey}">
	<input type="hidden" id="searchVal" name="searchVal" value="${searchVo.searchVal}">
	<input type="hidden" id="countPerPage" name="countPerPage" value="${searchVo.countPerPage}">
	<input type="hidden" id="totalCount" name="totalCount" value="${searchVo.totalCount}">
	<input type="hidden" id="progressStatus" name="progressStatus" value="${searchVo.progressStatus}">
	<input type="hidden" id="bunyangTimes" name="bunyangTimes" value="${searchVo.bunyangTimes}">
	<input type="hidden" id="groupSeq" name="groupSeq" value="${groupSeq}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
</form>

<div class="col-md-9">

	<!-- 분양 정보 -->
	<div style="margin-top: 15px;">
		<div class="pull-left"><h4>분양 정보</h4></div>	
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
            		<th style="background-color: #f5f5f5;">신청자</th>
            		<td align="left" colspan="3">${bunyangInfo.apply_user_name}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">신청형태</th>
            		<td align="left" colspan="3">${bunyangInfo.product_type_name}</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">장묘형태</th>
            		<td align="left" colspan="3">부부형 : [${bunyangInfo.couple_type_count }] x 2&nbsp;&nbsp;&nbsp;&nbsp;1인형 : [${bunyangInfo.single_type_count }]&nbsp;&nbsp;(총 ${bunyangInfo.couple_type_count*2 + bunyangInfo.single_type_count}기)</td>
            	</tr>
            </tbody>
        </table>
    </div>


    <div>
    	<div class="pull-left">
    		<h4>추가 연결된 분양 리스트</h4>
    	</div>
    	<div class="pull-right">
	        <button class="btn btn-primary" type="button" style="width: 60px;" onclick="selectConnectBunyang()">추가</button>
	    </div>
    </div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblList" class="table table-style">
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">신청자</th>
					<th scope="col">사용자</th>
					<th scope="col">신청형태</th>
					<th scope="col">부부형</th>
					<th scope="col">1인형</th>
					<th scope="col">상태</th>
					<th scope="col">연결해제</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${fn:length(addedBunyangList) gt 0}">
						<c:forEach items="${addedBunyangList}" var="bunyangItem">
							<tr bunyangSeq="${bunyangItem.bunyang_seq }" <c:if test="${bunyangItem.cancel_yn == 'Y' || bunyangItem.progress_status == 'E' || bunyangItem.progress_status == 'R'}">class="cancel"</c:if>>
								<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.bunyang_no}</a></td>
								<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.apply_user_name}</a></td>
								<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${bunyangItem.use_user_exp}</a></td>
								<td>${bunyangItem.product_type_name}</td>
								<td>${bunyangItem.couple_type_count}</td>
								<td>${bunyangItem.single_type_count}</td>
								<td style="text-decoration:none;">${bunyangItem.progress_status_exp}</td>
								<td><button type="button" class="btn btn-danger btn-sm" onclick="disconnectBunyang('${bunyangItem.bunyang_seq}')">해제</button></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="12" style="color: #777;">
								추가 연결된 분양 리스트가 없습니다.
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
    </div>

    
    <div class="mt-30 text-center">
        <button type="button" class="btn btn-default btn-lg" onclick="goToList()">목록</button>
    </div>
    
</div>


<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">

/**
 * 분양 상세정보를 팝업으로 표시
 */
function _showBunyangInfo(el) {
	var bunyangSeq = $(el).parent('td').parent('tr').attr('bunyangSeq');
	var winoption = {width:1120, height:750};
	common.openWindow("${contextPath}/popup/bunyanginfo", "popBunyangInfo", winoption, {bunyangSeq:bunyangSeq});
}

/**
 * 분양 상세정보를 팝업으로 표시
 */
function selectConnectBunyang() {
	var groupSeq = '${groupSeq}';
	var bunyangSeq = '${bunyangSeq}';
	var winoption = {width:1024, height:600};
	common.openWindow("${contextPath}/popup/selectConnectBunyang", "popSelectConnectBunyang", winoption, {groupSeq:groupSeq, bunyangSeq:bunyangSeq});
	window.saveCallBack = function(val) {
		if(val) {
			var frm = document.getElementById("frm");
			frm.action = "${contextPath}/admin/connectdetail";
			frm.submit();
		}
	}
}

/** 
 * 분양 연결 해제 
 */
function disconnectBunyang(bunyangSeq) {
	if(confirm('연결 정보를 해제하시겠습니까?')) {
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/disconnectbunyang", 
			data:{groupSeq:'${groupSeq}', bunyangSeq:bunyangSeq},
			success: function(result) {
				if(result) {
					common.showAlert("해제되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/admin/connectdetail";
					frm.submit();
				}
			}
		});
	}
}

/**
 * 목록 클릭
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/connectbunyang";
	frm.submit();
}

</script>