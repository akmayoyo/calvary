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
            		<td>${cutil:getBirthDateFormatString(apply.birth_date)}</td>
            		<td>${cutil:getMobileFormatString(apply.mobile)}</td>
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
    <div id="divAgentInfo" style="margin-top: 25px;">
    	<div>
	    	<div class="pull-left"><h4>대리인</h4></div>
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
	            		<td>${cutil:getBirthDateFormatString(agent.birth_date)}</td>
	            		<td>${cutil:getMobileFormatString(agent.mobile)}</td>
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
	<div style="margin-top: 25px;">
		<div class="pull-left" style=""><h4>사용(봉안) 대상자</h4></div>
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table id="tblUseUser" class="table table-style table-bordered">
            <thead>
                <tr>
                    <th scope="col">장묘형태</th>
                    <th scope="col">성명</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">휴대전화</th>
                    <th scope="col">주소</th>
                    <th scope="col">관계</th>
                    <th scope="col">교인여부</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${useUser}" var="use" varStatus="status">
            	<tr>
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
            		<td>${use.user_name}</td>
            		<td>${cutil:getBirthDateFormatString(use.birth_date)}</td>
            		<td>${cutil:getMobileFormatString(use.mobile)}</td>
            		<td>(${use.post_number}) ${use.address1} ${use.address2}</td>
            		<td>${use.relation_type_name}</td>
            		<td>${use.is_church_person}</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>

	<!-- 동산 신청 정보 -->
	<div style="margin-top: 25px;">
		<div class="pull-left"><h4>동산 신청 정보</h4></div>	
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="18%">
        		<col width="32%">
        		<col width="18%">
        		<col width="32%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;">신청번호</th>
            		<td align="left" colspan="3">${bunyangInfo.bunyang_seq}</td>
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
            		<th style="background-color: #f5f5f5;">총 분양대금</th>
            		<td align="left" colspan="3">일금 : ${cutil:convertPriceToHangul(bunyangInfo.total_price)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(bunyangInfo.total_price)})</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <c:if test="${not empty downPaymentInfo}">
    <!-- 계약금 납부 내역 -->
	<div style="margin-top: 25px;">
		<div class="pull-left"><h4>계약금 납부 내역</h4></div>
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="18%">
        		<col width="32%">
        		<col width="18%">
        		<col width="32%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부상태</p></th>
            		<td align="left">
            			<p class="form-control-static">
            				<c:choose>
								<c:when test="${downPaymentInfo.payment_amount > 0}">
									<span class="label label-info">완납</span>
								</c:when>
								<c:otherwise>
									<span class="label label-warning">미납</span>
								</c:otherwise>
							</c:choose>
            			</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부금액</p></th>
            		<td align="left"><p class="form-control-static">일금 : ${cutil:convertPriceToHangul(downPaymentInfo.payment_amount)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(downPaymentInfo.payment_amount)})</p></td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부일자</p></th>
            		<td align="left">
           				<p class="form-control-static">${downPaymentInfo.payment_date}</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부방법</p></th>
            		<td align="left">
           				<p class="form-control-static">
           					<c:choose>
           						<c:when test="${downPaymentInfo.payment_method == 'TRANSFER'}">무통장입금/계좌이체</c:when>
           						<c:when test="${downPaymentInfo.payment_method == 'CASH'}">현금납부</c:when>
           						<c:otherwise>${downPaymentInfo.payment_method}</c:otherwise>
           					</c:choose>
           				</p>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">확인일자</p></th>
            		<td align="left"><p class="form-control-static">${downPaymentInfo.create_date }</p></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">확인자</p></th>
            		<td align="left"><p class="form-control-static">${downPaymentInfo.create_user_name}</p></td>
            	</tr>
            </tbody>
        </table>
    </div>
    </c:if>
    
    <c:if test="${not empty downPaymentInfo}">
    <!-- 잔금 납부 내역 -->
	<div style="margin-top: 25px;">
		<div class="pull-left"><h4>잔금 납부 내역 (총 ₩${cutil:getThousandSeperatorFormatString(totalPaymentInfo.total_amount)})</h4></div>
	</div>
    <div class="clearfix"></div>
    <div class="table-responsive">
        <table class="table table-style">
            <thead>
                <tr>
                    <th scope="col">회차</th>
                    <th scope="col">납입일</th>
                    <th scope="col">납입금</th>
                    <th scope="col">납입유형</th>
                    <th scope="col">&nbsp;</th>
                </tr>
            </thead>
            <tbody id="tbodyPayment">
            	<tr>
            		<td><p class="form-control-static">1</p></td>
            		<td><p class="form-control-static">${downPaymentInfo.payment_date}</p></td>
            		<td><p class="form-control-static">₩${cutil:getThousandSeperatorFormatString(downPaymentInfo.payment_amount)}</p></td>
            		<td><p class="form-control-static">계약금</p></td>
            	</tr>
            	<c:forEach items="${balancePaymentList}" var="balancePayment" varStatus="status">
            	<tr>
            		<td><p class="form-control-static">${status.count+1}</p></td>
            		<td align="center"><p class="form-control-static">${balancePayment.payment_date}</p></td>
            		<td align="center"><p class="form-control-static">₩${cutil:getThousandSeperatorFormatString(balancePayment.payment_amount)}</p></td>
            		<td><p class="form-control-static">중도금</p></td>
            		<td>
            		<c:choose>
            			<c:when test="${!empty bunyangInfo.full_payment_date && status.last}"><p class="form-control-static"><span class="label label-info">완납</span></p></c:when>
            			<c:otherwise>&nbsp;</c:otherwise>
            		</c:choose>
            		</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>
    
    <c:if test="${bunyangInfo.progress_status == 'E'}">
    
    <c:set var="penalty" value="${bunyangInfo.down_payment/2}"/><!-- 위약금 -->
    <c:set var="cancelReturn" value="${bunyangInfo.down_payment + bunyangInfo.balance_payment - penalty}"/><!-- 반환금 -->
    
    <!-- 계약금 납부 내역 -->
	<div style="margin-top: 25px;">
		<div class="pull-left"><h4>해약 내역</h4></div>
	</div>
    <div class="clearfix"></div>
    
    <div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="18%">
        		<col width="32%">
        		<col width="18%">
        		<col width="32%">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약사유</p></th>
            		<td align="left" ><p class="form-control-static">${bunyangInfo.cancel_reason }</p></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">신청일자</p></th>
            		<td align="left" ><p class="form-control-static">${bunyangInfo.cancel_approval_date }</p></td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">해약 위약금</p></th>
            		<td align="left">
            			<p class="form-control-static">일금 : ${cutil:convertPriceToHangul(penalty)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(penalty)})</p>
            		</td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">반환금</p></th>
            		<td align="left">
            			<p class="form-control-static">일금 : ${cutil:convertPriceToHangul(cancelReturn)}원&nbsp;&nbsp;(₩${cutil:getThousandSeperatorFormatString(cancelReturn)})</p>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입금계좌</p></th>
            		<td align="left"><p class="form-control-static">${bunyangInfo.cancel_bank}&nbsp;${bunyangInfo.cancel_account}</p></td>
            		<th style="background-color: #f5f5f5;"><p class="form-control-static">예금주</p></th>
            		<td align="left"><p class="form-control-static">${bunyangInfo.cancel_account_holder }</p></td>
            	</tr>
            </tbody>
        </table>
    </div>
    </c:if>
    
    <!-- 관련 양식 -->
	<div style="margin-top: 25px;">
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
        <button id="btnList" type="button" class="btn btn-default btn-lg" onclick="goToList()">목록</button>
    </div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
	
})();

/**
 * 목록 클릭
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = '${listUrl}';
	frm.submit();
}

/**
 * 파일다운로드
 */
function donwloadFile(fileSeq) {
	$.fileDownload("/file/downloadFile?fileSeq=" + fileSeq).done(function(){}).fail(function(){common.showAlert("파일다운로드중 에러가 발생하였습니다.")});
}

</script>