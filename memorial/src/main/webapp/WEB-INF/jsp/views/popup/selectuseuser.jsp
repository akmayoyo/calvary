<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="${searchVo.searchKey}">
	<input type="hidden" id="searchVal" name="searchVal" value="${searchVo.searchVal}">
	<input type="hidden" id="countPerPage" name="countPerPage" value="${searchVo.countPerPage}">
	<input type="hidden" id="totalCount" name="totalCount" value="${searchVo.totalCount}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
	<input type="hidden" id="productType" name="productType" value="${bunyangInfo.product_type}">
</form>

<div class="poptitle">
	<strong>추모동산 사용(봉안)신청</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">

	<!-- 사용(봉안) 대상자 -->
	<div class="pull-left" style=""><h4>사용(봉안) 대상자</h4></div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblList" class="table table-style table-bordered">
            <thead>
                <tr>
                	<th scope="col" width="40"></th>
                    <th scope="col">장묘형태</th>
                    <th scope="col">성명</th>
                    <th scope="col">관계</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">주소</th>
                    <th scope="col">휴대전화</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${useUserList}" var="useUser" varStatus="status">
            	<tr userSeq="${useUser.user_seq}" bunyangSeq="${useUser.bunyang_seq}" coupleSeq="${useUser.couple_seq}">
            		<td align="center">
            			<c:choose>
	            			<c:when test="${useUser.assign_yn > 0}">
	            				<span class="label label-warning">사용중</span>
	            			</c:when>
	            			<c:otherwise>
	            				<input name="chkyn" type="checkbox" class="form-control" style="width: 20px; height: 20px;">
	            			</c:otherwise>
	            		</c:choose>
            		</td>
            		<c:choose>
            			<c:when test="${!empty useUser.couple_seq}">
            				<c:set var="nextVal" value="${useUserList[status.count]}"/>
            				<c:if test="${nextVal.couple_seq == useUser.couple_seq}">
	            				<td rowspan="2">부부형</td>
            				</c:if>
            			</c:when>
            			<c:otherwise>
            				<td>1인형</td>
            			</c:otherwise>
            		</c:choose>
            		<td><p class="form-control-static">${useUser.user_name}</p></td>
            		<td><p class="form-control-static">${useUser.relation_type_name}</p></td>
            		<td><p class="form-control-static">${cutil:getBirthDateFormatString(useUser.birth_date)}</p></td>
            		<td><p class="form-control-static">(${useUser.post_number}) ${useUser.address1} ${useUser.address2}</p></td>
            		<td><p class="form-control-static">${cutil:getMobileFormatString(useUser.mobile)}</p></td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>

	<div class="mt-30 text-center">
        <button type="button" class="btn btn-primary btn-lg" onclick="_assignGrave()">신청</button>
        <button type="button" class="btn btn-default btn-lg" onclick="_goToList()">목록</button>
    </div>
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function() {
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
})();

/**
 * 선택한 사용자 동산 배정
 */
function _assignGrave() {
	
	var bunyangSeq = $('#bunyangSeq').val();
	var productType = $('#productType').val();
	var userSeqs = [];
	var coupleSeqs = [];
	$("input[name='chkyn']").each(function(idx){
		if($(this).is(":checked")) {
			var tr = $(this).parent("td").parent("tr");
			var bunyangSeq = tr.attr("bunyangSeq");
			var userSeq = tr.attr("userSeq");
			var coupleSeq = tr.attr("coupleSeq");
			userSeqs.push(userSeq);
			coupleSeqs.push(coupleSeq ? coupleSeq : 0);
		}
	});
	if(userSeqs.length > 0) {
		var assignInfo = {};
		assignInfo['bunyangSeq'] = bunyangSeq;
		assignInfo['productType'] = productType;
		assignInfo['userSeqs'] = userSeqs;
		assignInfo['coupleSeqs'] = coupleSeqs;
		common.ajax({
			url:"${contextPath}/popup/assigngrave", 
			data:assignInfo,
			success: function(result) {
				if(result && result.result) {
		        	common.showAlert('저장되었습니다.');
	        	}
				if (window.opener && window.opener.saveCallBack != 'undefined') {
		            window.opener.saveCallBack(result);
		            common.closeWindow();
		        }
			}
		});
	} else {
		common.showAlert('신청할 사용자를 선택해주세요.');
		return;
	}
}

/**
 * 목록 클릭
 */
function _goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/popup/useapply";
	frm.submit();
}

</script>