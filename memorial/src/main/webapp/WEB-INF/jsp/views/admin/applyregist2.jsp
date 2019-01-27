<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="col-md-9">

	<!-- 신청자 정보 panel -->
	<div class="panel-group" style="margin-bottom: 10px;">
  		<div class="panel panel-default">
    		<div class="panel-heading">
      			<h4 class="panel-title">
        			<a data-toggle="collapse" href="#collapse1"><h4>신청자 정보<h4></a>
      			</h4>
    		</div>
    		<div id="collapse1" class="panel-collapse" style="padding: 15px;">
      			<div class="table-responsive">
        			<table id="tblApplyUser" class="table table-style table-horizon" style="border-top: 0;">
        				<colgroup>
        					<col width="20%">
        					<col width="80%">
			        	</colgroup>
            			<tbody>
            				<tr>
		            			<th class="required">신청자성명</th>
		            			<td><input name="userName" type="text" class="form-control input-sm" style="width: 150px;" autofocus="autofocus"></td>
		            		</tr>
            				<tr>
		            			<th class="required">생년월일</th>
			            		<td align="left" class="form-inline">
			            			<select name="birthYear" class="form-control input-sm" style="width: 70px;">
			            				<option>1981</option>
			            			</select>
			            			<span>-</span>
			            			<select name="birthMonth" class="form-control input-sm" style="width: 70px;">
			            				<option>01</option>
			            			</select>
			            			<span>-</span>
			            			<select name="birthDay" class="form-control input-sm" style="width: 70px; margin-right: 15px;">
			            				<option>10</option>
			            			</select>
			            			<span style="font-size: 13px;">성별</span>
			            			<select name="gender" class="form-control input-sm" style="width: 70px; margin-left: 5px;">
			            				<option value="1">남성</option>
			            				<option value="2">여성</option>
			            			</select>
			            		</td>
		            		</tr>
		            		<tr>
		            			<th class="required">휴대전화</th>
		            			<td align="left" class="form-inline">
			            			<select name="mobile1" class="form-control input-sm" style="width: 70px;">
			            				<option>010</option>
			            				<option>011</option>
			            				<option>016</option>
			            				<option>019</option>
			            			</select>
			            			<span>-</span>
			            			<input name="mobile2" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            			<span>-</span>
			            			<input name="mobile3" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            		</td>
		            		</tr>
		            		<tr>
		            			<th class="required">전화</th>
		            			<td align="left" class="form-inline">
			            			<input name="phone1" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            			<span>-</span>
			            			<input name="phone2" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            			<span>-</span>
			            			<input name="phone3" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            		</td>
		            		</tr>
		            		<tr>
		            			<th class="required">주소</th>
		            			<td align="left" class="form-inline" colspan="3">
		            				<input name="postNumber" type="text" class="form-control input-sm readonlywhite" style="width: 150px;" readonly="readonly" placeholder="우편번호">
		            				<button type="button" class="btn btn-sm btn-primary" onclick="goJusoPopup(this)">검색</button><br>
		            				<input name="address1" type="text" class="form-control input-sm readonlywhite" readonly="readonly" placeholder="주소" style="width: 100%; margin-top: 5px;"><br>
		            				<input name="address2" type="text" class="form-control input-sm" placeholder="상세주소" style="width: 100%; margin-top: 5px;">
		            			</td>
		            		</tr>
		            		<tr>
		            			<th class="required">직분/교구</th>
			            		<td align="left" class="form-inline">
			            			<span style="font-size: 13px;">직분</span>
			            			<select class="form-control input-sm" style="width: 87px; margin-left: 5px; margin-right: 18px;">
			            				<option>평신도</option>
			            			</select>
			            			<span style="font-size: 13px;">교구</span>
			            			<select class="form-control input-sm" style="width: 87px; margin-left: 5px;">
			            				<option>1</option>
			            			</select>
			            		</td>
		            		</tr>
		            		<tr>
		            			<th>이메일</th>
			            		<td align="left" class="form-inline">
			            			<input name="emailAddr" type="text" class="form-control input-sm" style="width: 120px;">
			            			<span>@</span>
			            			<select name="emailDomain" class="form-control input-sm" style="width: 120px;">
			            				<option>naver.com</option>
			            			</select>
			            		</td>
		            		</tr>
		            	</tbody>
		            </table>
				</div>
				
				<div class="mt-30 text-center">
        <button type="button" class="btn btn-primary btn-lg">확인</button>
    </div>
				
    		</div>
  		</div>
	</div><!-- 신청자 정보 panel End -->
	
	<!-- 대리인 정보 panel -->
	<div class="panel-group" style="margin-bottom: 10px;">
  		<div class="panel panel-default">
    		<div class="panel-heading">
      			<h4 class="panel-title">
        			<a data-toggle="collapse" href="#collapse2"><h4>대리인 신청<h4></a>
      			</h4>
    		</div>
    		<div id="collapse2" class="panel-collapse collapse" style="padding: 15px;">
      			<div class="table-responsive">
        			<table id="tblApplyUser" class="table table-style table-horizon" style="border-top: 0;">
        				<colgroup>
        					<col width="20%">
        					<col width="80%">
			        	</colgroup>
            			<tbody>
            				<tr>
		            			<th class="required">대리인명</th>
		            			<td><input name="userName" type="text" class="form-control input-sm" style="width: 150px;" autofocus="autofocus"></td>
		            		</tr>
            				<tr>
		            			<th class="required">생년월일</th>
			            		<td align="left" class="form-inline">
			            			<select name="birthYear" class="form-control input-sm" style="width: 70px;">
			            				<option>1981</option>
			            			</select>
			            			<span>-</span>
			            			<select name="birthMonth" class="form-control input-sm" style="width: 70px;">
			            				<option>01</option>
			            			</select>
			            			<span>-</span>
			            			<select name="birthDay" class="form-control input-sm" style="width: 70px; margin-right: 15px;">
			            				<option>10</option>
			            			</select>
			            			<span style="font-size: 13px;">성별</span>
			            			<select name="gender" class="form-control input-sm" style="width: 70px; margin-left: 5px;">
			            				<option value="1">남성</option>
			            				<option value="2">여성</option>
			            			</select>
			            		</td>
		            		</tr>
		            		<tr>
		            			<th class="required">휴대전화</th>
		            			<td align="left" class="form-inline">
			            			<select name="mobile1" class="form-control input-sm" style="width: 70px;">
			            				<option>010</option>
			            				<option>011</option>
			            				<option>016</option>
			            				<option>019</option>
			            			</select>
			            			<span>-</span>
			            			<input name="mobile2" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            			<span>-</span>
			            			<input name="mobile3" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            		</td>
		            		</tr>
		            		<tr>
		            			<th class="required">전화</th>
		            			<td align="left" class="form-inline">
			            			<input name="phone1" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            			<span>-</span>
			            			<input name="phone2" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            			<span>-</span>
			            			<input name="phone3" type="text" class="form-control input-sm" style="width: 70px;" maxlength="4">
			            		</td>
		            		</tr>
		            		<tr>
		            			<th class="required">주소</th>
		            			<td align="left" class="form-inline" colspan="3">
		            				<input name="postNumber" type="text" class="form-control input-sm readonlywhite" style="width: 150px;" readonly="readonly" placeholder="우편번호">
		            				<button type="button" class="btn btn-sm btn-primary" onclick="goJusoPopup(this)">검색</button><br>
		            				<input name="address1" type="text" class="form-control input-sm readonlywhite" readonly="readonly" placeholder="주소" style="width: 100%; margin-top: 5px;"><br>
		            				<input name="address2" type="text" class="form-control input-sm" placeholder="상세주소" style="width: 100%; margin-top: 5px;">
		            			</td>
		            		</tr>
		            		<tr>
		            			<th class="required">신청자와의 관계</th>
			            		<td align="left" class="form-inline">
			            			<select class="form-control input-sm" style="width: 120px;">
			            				<option>배우자</option>
			            			</select>
			            		</td>
		            		</tr>
		            		<tr>
		            			<th>이메일</th>
			            		<td align="left" class="form-inline">
			            			<input name="emailAddr" type="text" class="form-control input-sm" style="width: 120px;">
			            			<span>@</span>
			            			<select name="emailDomain" class="form-control input-sm" style="width: 120px;">
			            				<option>naver.com</option>
			            			</select>
			            		</td>
		            		</tr>
		            	</tbody>
		            </table>
				</div>
    		</div>
  		</div>
	</div><!-- 대리인 정보 panel End -->
	
	<!-- 사용(봉안) 대상자 panel -->
	<div class="panel-group" style="margin-bottom: 10px;">
  		<div class="panel panel-default">
    		<div class="panel-heading">
      			<h4 class="panel-title" style="display: inline-block;">
        			<a data-toggle="collapse" href="#collapse3"><h4>사용(봉안) 대상자<h4></a>
      			</h4>
    		</div>
    		<div id="collapse3" class="panel-collapse collapse" style="padding: 15px;">
    		</div>
  		</div>
	</div><!-- 사용(봉안) 대상자 panel End -->
	
	<!-- 동산 신청정보 panel -->
	<div class="panel-group" style="margin-bottom: 10px;">
  		<div class="panel panel-default">
    		<div class="panel-heading">
      			<h4 class="panel-title" style="display: inline-block;">
        			<a data-toggle="collapse" href="#collapse4"><h4>동산 신청정보<h4></a>
      			</h4>
    		</div>
    		<div id="collapse4" class="panel-collapse collapse" style="padding: 15px;">
    		</div>
  		</div>
	</div><!-- 동산 신청정보 panel End -->
	
	<div class="mt-30 text-center">
        <button type="button" class="btn btn-primary btn-lg">저장</button>
        <button type="button" class="btn btn-default btn-lg">취소</button>
    </div>
	
</div>

<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.number.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
	
})();

/**
 * 도로명주소 Open API 팝업호출
 */
function goJusoPopup(btn){
	var winoption = {width:570, height:420};
	common.openWindow("${contextPath}/popup/jusopopup.jsp", "jusopopup", winoption, {});
	window.jusoCallBack = function(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn , detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo){
		var td = $(btn).parent('td');
		td.find('input[name="postNumber"]').val(zipNo);
		td.find('input[name="address1"]').val(roadAddrPart1 + roadAddrPart2);
		td.find('input[name="address2"]').val(addrDetail);
		td.find('input[name="address2"]').focus();
		console.log(roadFullAddr);
		console.log(roadAddrPart1);
		console.log(roadAddrPart2);
		console.log(addrDetail);
		console.log(zipNo);
	};
}

</script>