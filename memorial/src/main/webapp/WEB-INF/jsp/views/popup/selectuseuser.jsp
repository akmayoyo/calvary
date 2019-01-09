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
        <table id="tblList" class="table table-style">
            <thead>
                <tr>
                	<th scope="col" width="40"></th>
                    <th scope="col">성명</th>
                    <th scope="col">관계</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">주소</th>
                    <th scope="col">휴대전화</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${useUserList}" var="useUser">
            	<tr userSeq="${useUser.user_seq}" bunyangSeq="${useUser.bunyang_seq}">
            		<td><input name="chkyn" type="checkbox" class="form-control"></td>
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
	$("input[name='chkyn']").each(function(idx){
		if($(this).is(":checked")) {
			var tr = $(this).parent("td").parent("tr");
			var bunyangSeq = tr.attr("bunyangSeq");
			var userSeq = tr.attr("userSeq");
		}
	});
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