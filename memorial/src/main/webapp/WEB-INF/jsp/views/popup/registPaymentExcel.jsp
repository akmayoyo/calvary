<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="poptitle">
	<strong>입출금 엑셀 업로드</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">
	
	<!-- 검색 -->
	<div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style" style="border-top: 0;">
        	<colgroup>
        		<col width="15%">
        		<col width="*">
        	</colgroup>
            <tbody>
            	<tr>
            		<th style="background-color: #f5f5f5;">은행</th>
            		<td>
            			<select name="bank" class="form-control" style="width: 225px;">
            				<c:forEach items="${bankList}" var="bankItem">
            				<option value="${bankItem.code_seq}">${bankItem.code_name}</option>
							</c:forEach>
            			</select>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">입출금기간</th>
            		<td>
            			<div class="input-group date" data-provide="datepicker" style="width: 225px;">
						    <input id="tiPeriod" type="text" class="form-control">
						    <div class="input-group-addon">
						        <span class="glyphicon glyphicon-calendar"></span>
						    </div>
						</div>
            		</td>
            	</tr>
            	<tr>
            		<th style="background-color: #f5f5f5;">파일선택</th>
            		<td align="left">
            			<label for="file" style="display: inherit;">
							<div class="input-group">
								<input type="text" class="form-control" id="info" readonly="" style="background: #fff; width: 400px;" placeholder="업로드할 파일을 선택하세요.">
								<span class="input-group-btn">
									<button class="btn btn-primary" type="button">파일선택</button>
								</span>
							</div>
						</label>
            		</td>
            	</tr>
            </tbody>
        </table>
    </div>
    
    <div class="text-right" style="margin-top: 10px;">
    	<button class="btn btn-primary btn-lg" type="button" style="width: 105px;" onclick="_uploadExcel()">업로드</button>
		<button class="btn btn-primary btn-lg" type="button" style="width: 105px;" onclick="_savePayment()">저장</button>
    </div>
	
	<input type="file" style="display: none;" name="file" id="file">
	
	<div class="table-responsive" style="margin-top: 10px;">
        <table id="tblList" class="table table-style table-bordered">
        	<colgroup>
        		<col width="5%">
        		<col width="8%">
        		<col width="8%">
        		<col width="8%">
        		<col width="8%">
        		<col width="11%">
        		<col width="23%">
        		<col width="20%">
        		<col width="3%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col">No.</th>
                    <th scope="col">입출일자</th>
                    <th scope="col">입출금액</th>
                    <th scope="col">입출구분</th>
                    <th scope="col" class="required">입출유형</th>
                    <th scope="col">내용</th>
                    <th scope="col">계약정보</th>
                    <th scope="col">비고</th>
                    <th scope="col"></th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
    
</div>
<ul id="DEPOSITList" style="display: none;">
	<c:forEach items="${depositTypeList}" var="typeItem">
	<li code_seq="${typeItem.code_seq}" code_name="${typeItem.code_name}"></li>
	</c:forEach>
</ul>
<ul id="WITHDRAWALList" style="display: none;">
	<c:forEach items="${withdrawalTypeList}" var="typeItem">
	<li code_seq="${typeItem.code_seq}" code_name="${typeItem.code_name}"></li>
	</c:forEach>
</ul>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/daterangepicker.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery.number.min.js"></script>
<script src="http://malsup.github.com/jquery.form.js"></script> 
<script type="text/javascript">

var files;

(function() {
	
	var option = {};
	option['singleDatePicker'] = false;
	option['startDate'] = moment().subtract(1, 'month');
	option['endDate'] = moment();
	common.datePicker($("#tiPeriod"),option);
	
	$("label[for=file]").click(function(event) {
        event.preventDefault();
        $("#file").click();
    });
	
	$('#file').change(function(e) {
		if($(this).val()) {
			$('#info').val($(this).val().split(/[\\|/]/).pop());
			files=e.target.files;
		}
	});
	
    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
})();

/**
 * 확인
 */
function _uploadExcel() {
	
	if(files == null || files.length == 0) {
		common.showAlert('파일을 선택해주세요.');
		return;
	}
	var fileName = $('#info').val();
	if(!fileName || !/\.xlsx$/.test(fileName)) {
		common.showAlert('엑셀파일(xlsx) 만 업로드 가능합니다.');
		return;
	}
	// 은행
	var bank = $('select[name="bank"] option:selected').val();
	if(!bank) {
		common.showAlert('은행을 선택해주세요.');
		return;
	}
	// 입출금기간
	var dateData = $('#tiPeriod').data('daterangepicker');
	var fromDt = '';
	var toDt = '';
	if(dateData) {
		if(dateData.startDate) {
			fromDt = dateData.startDate.format('YYYYMMDD');
		}
		if(dateData.endDate) {
			toDt = dateData.endDate.format('YYYYMMDD');
		}
	}
	
	var fileFrm = new FormData();
	fileFrm.append("file", files[0]);
	fileFrm.append("bank", bank);
	fileFrm.append("fromDt", fromDt);
	fileFrm.append("toDt", toDt);
   	$.ajax({
   		dataType : 'text',
        url:"/excel/importPaymentExcel",
        data:fileFrm,
        type : "POST",
        enctype: 'multipart/form-data',
        processData: false, 
        contentType:false,
        success : function(result) {
       		var jsonResult = $.parseJSON(result);
       		var isError = jsonResult.isError;
       		var rtnList = jsonResult.rtnList;
       		if(isError) {
       			common.showAlert('엑셀을 읽는중 에러가 발생하였습니다.');
       		} else {
       			if(rtnList != null && rtnList.length > 0) {
       				displayExcelRow(rtnList);
               	} else {
               		common.showAlert('업로드 할 데이터가 없습니다.');
               	}
       		}
		},error : function(result){
			common.showAlert('엑셀 업로드중 에러가 발생하였습니다.');
		},beforeSend : function() {
			common.loading(true);
		}, complete : function() {
			common.loading(false);
		}
    });
}


/**
 * 엑셀업로드 리스트를 화면에 표시
 */
function displayExcelRow(excelList) {
	var tbody = $('#tblList tbody');
	tbody.html('');
	$.each(excelList, function(idx, item) {
		var paymentDate = item.paymentDate;
		var paymentAmount = item.paymentAmount;
		var paymentDivision = item.paymentDivision;
		var paymentDivisionDesc = '';
		if(paymentDivision == '<%=CalvaryConstants.PAYMENT_DIVISION_DEPOSIT%>') {
			paymentDivisionDesc = '입금';
		} else if(paymentDivision == '<%=CalvaryConstants.PAYMENT_DIVISION_WITHDRAWAL%>') {
			paymentDivisionDesc = '출금';
		}
		var content = item.content;
		var bunyangNo = item.bunyangNo;
		var bunyangInfoList = item.bunyangInfoList;
		
		var tr = $('<tr/>');
	    // No.
	    tr.append('<td><span name="rowNo">' + (idx+1) + '</span></td>');
	    // 입출일자
	    tr.append('<td><span name="paymentDate">' + paymentDate + '</span></td>');
	    // 입출금액
	    tr.append('<td align="right"><span name="paymentAmount">' + $.number(paymentAmount) + '</span></td>');
	    // 입출구분
	    tr.append('<td><span name="paymentDivision" code="' + paymentDivision + '">' + paymentDivisionDesc + '</span></td>');
		// 입출유형
	    tr.append('<td><select name="paymentType" class="form-control"></select></td>');
	 	// 내용
	    tr.append('<td><span name="content">' + content + '</span></td>');
	 	// 계약정보
	    tr.append('<td><select name="bunyangInfo" class="form-control"></select></td>');
	 	// 비고
	    tr.append('<td><input name="remark" type="text" class="form-control"></td>');
	    // 삭제버튼
	    tr.append('<td><button type="button" class="btn btn-default btn-sm" data-toggle="tooltip" title="삭제" onclick="_deleteRow(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>');

	    var paymentTypeOptions = '<option value="">선택</option>';
	    
	    if(paymentDivision == '<%=CalvaryConstants.PAYMENT_DIVISION_DEPOSIT%>') {
	    	$('#DEPOSITList li').each(function(idx) {
				paymentTypeOptions += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
		} else if(paymentDivision == '<%=CalvaryConstants.PAYMENT_DIVISION_WITHDRAWAL%>') {
	    	$('#WITHDRAWALList li').each(function(idx) {
				paymentTypeOptions += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
		}
	    
	    if(paymentTypeOptions) {
	    	$(tr).find('select[name="paymentType"]').html(paymentTypeOptions);
	    }
	    
	    if(bunyangInfoList != null && bunyangInfoList.length > 0) {
	    	$.each(bunyangInfoList, function(idx, item) {
	    		var desc = item.bunyang_no + ' / ' + item.apply_user_name + ' / ' + item.apply_user_mobile;
	    		var option = $('<option value="' + item.bunyang_seq + '">' + desc + '</option>');
	    		option.attr('bunyang_seq', item.bunyang_seq);
	    		option.attr('bunyang_no', item.bunyang_no);
	    		option.attr('apply_user_name', item.apply_user_name);
	    		option.attr('apply_user_mobile', item.apply_user_mobile);
	    		option.attr('total_price', item.total_price);
	    		option.attr('down_payment', item.down_payment);
	    		option.attr('balance_payment', item.balance_payment);
	    		$(tr).find('select[name="bunyangInfo"]').append(option);
	    	});
	    } else {
	    	var option = $('<option value="">계약정보 없음</option>');
    		$(tr).find('select[name="bunyangInfo"]').append(option);
	    }
	    
	    tbody.append(tr);
	});
}

/**
 * 행삭제
 */
function _deleteRow(btn) {
	$(btn).parent("td").parent("tr").remove();
	$('#tblList tbody tr').each(function(idx) {
		$(this).find('span[name="rowNo"]').text(idx+1);
	});
}

/**
 * 계약정보 찾기
 */
function _searchBunyangInfo(btn) {
	
}

/**
 * 저장
 */
function _savePayment() {
	var bunyangSeqs = []; // 계약 seq
    var paymentDates = []; // 입출일자
    var paymentAmounts = []; // 입출금
    var paymentDivisions = []; // 입출구분
    var paymentTypes = []; // 입출유형
    var paymentUsers = []; // 입출유형
    var paymentMethods = []; // 납입방법
    var remarks = []; // 비고
    var rowNumbers = [];// 행번호
    var bValidate = true;
    var summaryByBunyangSeq = {};// 계약번호별 입력된 납입금정보 합산을 위한 storage
    
    $('#tblList tbody tr').each(function(idx) {
        var tr = $(this);
        var bunyangInfo;// 계약정보
        var bunyang_seq = ' ';// 계약seq
        var bunyang_no;// 계약번호
        var total_price;// 총 분양대금
        var contract_price;// 총 계약금
        var balance_price;// 총 분양대금 - 계약금
        var down_payment;// 기납입된 계약금
        var balance_payment;// 기납입된 분양잔금
        var apply_user_name;// 신청자명
        var apply_user_mobile;// 신청자 연락처
        var selectedBunyangInfo = tr.find('select[name="bunyangInfo"] option:selected');
        if (selectedBunyangInfo && selectedBunyangInfo.attr('bunyang_seq')) {
            bunyang_seq = selectedBunyangInfo.attr('bunyang_seq');
            bunyang_no = selectedBunyangInfo.attr('bunyang_no');
            total_price = selectedBunyangInfo.attr('total_price');
            down_payment = selectedBunyangInfo.attr('down_payment');
            balance_payment = selectedBunyangInfo.attr('balance_payment');
            apply_user_name = selectedBunyangInfo.attr('apply_user_name');
            apply_user_mobile = selectedBunyangInfo.attr('apply_user_mobile');
            total_price = total_price ? parseInt(total_price) : total_price;
            down_payment = down_payment ? parseInt(down_payment) : down_payment;
            balance_payment = balance_payment ? parseInt(balance_payment) : balance_payment;
            contract_price = total_price * (<%=CalvaryConstants.DOWN_PAYMENT_PERCENT%>/100);
            balance_price = total_price - contract_price;
        }
        var payment_date = common.toNumeric(tr.find('span[name="paymentDate"]').text());
        var payment_amount = common.toNumeric(tr.find('span[name="paymentAmount"]').text());
        var payment_division = tr.find('span[name="paymentDivision"]').attr('code');
        var payment_type = tr.find('select[name="paymentType"] option:selected').val();
        var content = tr.find('span[name="content"]').text();
        var payment_user = apply_user_name ? apply_user_name : content;
        var remark = tr.find('input[name="remark"]').val();
        if(!remark) {
        	remark = ' ';
        }
        var payment_method = "<%=CalvaryConstants.PAYMENT_METHOD_TRANSFER%>";
        var rowNo = tr.find('span[name="rowNo"]').text();
        
        payment_amount = payment_amount ? parseInt(payment_amount) : payment_amount;

        // 필수입력 체크
        if(!payment_date) {
        	common.showAlert((idx+1) + '행 데이터에 입출일자가 없습니다.');
        	bValidate = false;
        	return false;
        }
        if(!payment_amount || payment_amount <= 0) {
        	common.showAlert((idx+1) + '행 데이터에 입출금액이 없습니다.');
        	bValidate = false;
        	return false;
        }
        if(!payment_division) {
        	common.showAlert((idx+1) + '행 데이터에 입출구분이 없습니다.');
        	bValidate = false;
        	return false;
        }
        if(!payment_type) {
        	tr.find('select[name="paymentType"]').focus();
        	common.showAlert((idx+1) + '행 데이터에 입출유형이 입력되지 않았습니다.');
        	bValidate = false;
        	return false;
        }
        
        // 동일 계약건에 대해 복수개 입력가능하기 때문에 입력된 납입금의 validation 체크는 누적 데이터를 생성후 마지막에 수행함
        if(bunyang_seq && !summaryByBunyangSeq.hasOwnProperty(bunyang_seq)) {
        	summaryByBunyangSeq[bunyang_seq] = {};
        	summaryByBunyangSeq[bunyang_seq]['bunyang_no'] = bunyang_no;// 계약번호
        	summaryByBunyangSeq[bunyang_seq]['total_price'] = total_price;// 총 분양대금
            summaryByBunyangSeq[bunyang_seq]['down_payment'] = down_payment;// 기납입된 계약금 
            summaryByBunyangSeq[bunyang_seq]['balance_payment'] = balance_payment;// 기납입된 잔금
            summaryByBunyangSeq[bunyang_seq]['contract_price'] = contract_price;// 총 계약금
            summaryByBunyangSeq[bunyang_seq]['balance_price'] = balance_price;// 총 분양대금 - 총 계약금
        	summaryByBunyangSeq[bunyang_seq]['accum_down_payment'] = 0;// 화면에서 입력된 누적계약금
        	summaryByBunyangSeq[bunyang_seq]['accum_balance_payment'] = 0;// 화면에서 입력된 누적잔금
        	summaryByBunyangSeq[bunyang_seq]['accum_maint_payment'] = 0;// 화면에서 입력된 누적관리비
        }
        if(bunyang_seq) {
        	// 납입금 누적정보 생성
            if(payment_type == '<%=CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT%>') {// 계약금
            	summaryByBunyangSeq[bunyang_seq]['accum_down_payment'] += payment_amount; 
            } else if(payment_type == '<%=CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT%>') {// 분양잔금
            	summaryByBunyangSeq[bunyang_seq]['accum_balance_payment'] += payment_amount; 
            } else if(payment_type == '<%=CalvaryConstants.PAYMENT_TYPE_MAINT_PAYMENT%>') {// 관리비
            	summaryByBunyangSeq[bunyang_seq]['accum_maint_payment'] += payment_amount; 
            }	
        }
        bunyangSeqs.push(bunyang_seq);
        paymentDates.push(payment_date);
        paymentAmounts.push(payment_amount);
        paymentDivisions.push(payment_division);
        paymentTypes.push(payment_type);
        paymentUsers.push(payment_user);
        paymentMethods.push(payment_method);
        remarks.push(remark);
        rowNumbers.push(rowNo);
    });
    
    if(!bValidate) {
    	return;
    }
    
    if (bunyangSeqs.length == 0) {
        common.showAlert('저장할 데이터가 없습니다.');
        return;
    }
    
    // 계약건별로 입력된 금액에 대해 validation 체크 수행
    for(var key in summaryByBunyangSeq) {
    	var bunyangInfo = summaryByBunyangSeq[key];
    	var total_price = bunyangInfo['total_price'];
    	var down_payment = bunyangInfo['down_payment'];
    	var balance_payment = bunyangInfo['balance_payment'];
    	var contract_price = bunyangInfo['contract_price'];
    	var balance_price = bunyangInfo['balance_price'];
        // 화면에서 입력된 계약금,분양잔금,관리비의 누적분
        var accum_down_payment = bunyangInfo['accum_down_payment'];
        var accum_balance_payment = bunyangInfo['accum_balance_payment'];
        var accum_maint_payment = bunyangInfo['accum_maint_payment'];
        // 기납부금액 + 입력된 납입금이 총 분양대금보다 클 경우
       	if(accum_down_payment + accum_balance_payment + down_payment + balance_payment > total_price) {
       		common.showAlert('계약번호[' + bunyangInfo['bunyang_no'] + '] 의 납입금 총액이 분양대금을 초과하였습니다.');
           	return;
       	}
    }
    
    var paymentInfo = {};
    paymentInfo['bunyangSeqs'] = bunyangSeqs;
    paymentInfo['paymentDates'] = paymentDates;
    paymentInfo['paymentAmounts'] = paymentAmounts;
    paymentInfo['paymentDivisions'] = paymentDivisions;
    paymentInfo['paymentTypes'] = paymentTypes;
    paymentInfo['paymentUsers'] = paymentUsers;
    paymentInfo['paymentMethods'] = paymentMethods;
    paymentInfo['remarks'] = remarks;
    
    common.ajax({
		url:"${contextPath}/popup/savepayment", 
		data:paymentInfo,
		success: function(result) {
			if(result.result) {
				common.showAlert('저장되었습니다.');
				if (window.opener && window.opener.saveCallBack != 'undefined') {
		            window.opener.saveCallBack(result);
		            common.closeWindow();
		        }
    		} else {
    			common.showAlert('저장에 실패하였습니다.');
    		}
		},
		error: function(xhr, status, message) {
			common.showAlert('저장시 에러가 발생하였습니다.');
		}
	});
    
    // 한건씩 저장
    //saveRecursive(bunyangSeqs, paymentDates, paymentAmounts, paymentDivisions, paymentTypes, paymentUsers, paymentMethods, remarks, rowNumbers);
}

/**
 * 입출금 리스트를 재귀호출하면서 한건씩 저장
 */
function saveRecursive(bunyangSeqs, paymentDates, paymentAmounts, paymentDivisions, paymentTypes, paymentUsers, paymentMethods, remarks, rowNumbers) {
	if(bunyangSeqs != null && bunyangSeqs.length > 0) {
		var bunyangSeq = bunyangSeqs.shift();
		var paymentDate = paymentDates.shift();
		var paymentAmount = paymentAmounts.shift();
		var paymentDivision = paymentDivisions.shift();
		var paymentType = paymentTypes.shift();
		var paymentUser = paymentUsers.shift();
		var paymentMethod = paymentMethods.shift();
		var remark = remarks.shift();
		var rowNumber = rowNumbers.shift();
		
		var paymentInfo = {};
	    paymentInfo['bunyangSeq'] = bunyangSeq;
	    paymentInfo['paymentDate'] = paymentDate;
	    paymentInfo['paymentAmount'] = paymentAmount;
	    paymentInfo['paymentDivision'] = paymentDivision;
	    paymentInfo['paymentType'] = paymentType;
	    paymentInfo['paymentUser'] = paymentUser;
	    paymentInfo['paymentMethod'] = paymentMethod;
	    paymentInfo['remark'] = remark;
	    
	    common.ajax({
			url:"${contextPath}/popup/savepaymentone", 
			data:paymentInfo,
			success: function(result) {
				if(result.result) {
					showSaveResultIcon(rowNumber, true, '');
	    		}else {
	    			showSaveResultIcon(rowNumber, false, result.errorMessage ? result.errorMessage : '저장에 실패하였습니다.');
	    		}
				saveRecursive(bunyangSeqs, paymentDates, paymentAmounts, paymentDivisions, paymentTypes, paymentUsers, paymentMethods, remarks, rowNumbers);
			}
		});
	} else {
		if($('#tblList tbody tr[saveresult=false]').length > 0) {
			setTimeout(function() {
				common.showAlert('저장시 에러가 발생한 데이터가 있습니다. \n에러 아이콘에 마우스를 올리면 에러 메세지가 표시됩니다.');
			}, 100);
		} else {
			setTimeout(function() {
				common.showAlert('정상적으로 저장되었습니다.');
			}, 100);	
		}
	}
}

/**
 * 
 */
function showSaveResultIcon(rowNumber, success, message) {
	var tr = $('#tblList tbody tr').eq(rowNumber-1);
	tr.attr('saveresult', success);
	if(success) {
		tr.find('div[name="saveresult"]').html('<span class="glyphicon glyphicon-ok" style="color:#60C060;"></span>');
	} else {
		tr.find('div[name="saveresult"]').html('<span class="glyphicon glyphicon-exclamation-sign" style="color:#D9534F;" data-toggle="tooltip" title="' + message + '"></span>');
		tr.css('backgroundColor', '#F2DEDE');
	}
}

</script>