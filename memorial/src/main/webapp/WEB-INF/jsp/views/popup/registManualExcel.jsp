<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<div class="poptitle">
	<strong>분양대금 입출금대장 엑셀 업로드</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">
	
	<div class="alert alert-info" role="alert" style="padding: 10px; margin-bottom: 10px;">! 지정된 양식의 엑셀파일만 업로드 가능합니다.</div>
	
	<label for="file">
		<div class="input-group">
			<input type="text" class="form-control" id="info" readonly="" style="background: #fff;" placeholder="업로드할 파일을 선택하세요.">
			<span class="input-group-btn">
				<button class="btn btn-primary" type="button">파일선택</button>
			</span>
		</div>
	</label>
	<input type="file" style="display: none;" name="file" id="file">
	
	<div class="text-right" style="margin-top: 10px;">
    	<button class="btn btn-primary btn-lg" type="button" style="width: 105px;" onclick="_uploadExcel()">업로드</button>
		<button class="btn btn-primary btn-lg" type="button" style="width: 105px;" onclick="_savePayment()">저장</button>
    </div>
    
    <div style="margin-top: 10px; height: 40px; overflow-y: scroll; ">
    	<table class="table table-style table-bordered">
        	<colgroup>
        		<col width="5%">
        		<col width="15%">
        		<col width="13%">
        		<col width="13%">
        		<col width="13%">
        		<col width="13%">
        		<col width="23%">
        		<col width="5%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col">No.</th>
                    <th scope="col">입출일자</th>
                    <th scope="col">입출금액</th>
                    <th scope="col">입출구분</th>
                    <th scope="col">입출유형</th>
                    <th scope="col">계약번호</th>
                    <th scope="col">비고</th>
                    <th scope="col"></th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
    <div id="divTbl" style="height: 409px; overflow-y: scroll; border-bottom: 1px solid #e0e0e0; ">
        <table id="tblList" class="table table-style table-bordered">
        	<colgroup>
        		<col width="5%">
        		<col width="15%">
        		<col width="13%">
        		<col width="13%">
        		<col width="13%">
        		<col width="13%">
        		<col width="23%">
        		<col width="5%">
        	</colgroup>
            <tbody>
            </tbody>
        </table>
    </div>
    
   	<h2 id="uploadResult" style="text-align: center; color: #0000ff;"></h2>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script src="http://malsup.github.com/jquery.form.js"></script> 
<script type="text/javascript" src="${contextPath}/resources/js/jquery.number.min.js"></script>
<script type="text/javascript">

var files;
var arrSavedBunyangNo = [];
var arrCanceledBunyangNo = [];
var succeedRows = [];
var failedRows = [];

(function() {
	
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
 * 업로드
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
	
	arrSavedBunyangNo = [];
	succeedRows = [];
	failedRows = [];
	$('#uploadResult').text('');
	
	var fileFrm = new FormData();
	fileFrm.append("file", files[0]);
   	$.ajax({
   		dataType : 'text',
        url:"/excel/importPaymentManualExcel",
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
		var paymentType = item.paymentType;
		var bunyangNo = item.bunyangNo;
		var paymentUser = item.paymentUser;
		var remarks = item.remarks;
		var errorFlag = item.errorFlag;
		var errorMsg = item.errorMsg;
		var bunyangSeq = item.bunyangSeq;
		var totalPrice = item.totalPrice;
		
		var tr = $('<tr/>', {id:'tr' + idx});
	    // No.
	    tr.append('<td align="right"><span name="rowNo">' + (idx+1) + '</span></td>');
	    // 입출일자
	    tr.append('<td><span name="paymentDate">' + paymentDate + '</span></td>');
	    // 입출금액
	    tr.append('<td align="right"><span name="paymentAmount">' + $.number(paymentAmount) + '</span></td>');
	    // 입출구분
	    tr.append('<td><span name="paymentDivision">' + paymentDivision + '</span></td>');
		// 입출유형
	    tr.append('<td><span name="paymentType">' + paymentType + '</span></td>');
	 	// 계약정보
	    tr.append('<td><span name="bunyangNo" paymentUser="' + paymentUser + '">' + bunyangNo + '</span></td>');
	 	// 비고
	 	if(errorFlag) {
		    tr.append('<td align="left"><span name="remarks" style="color:#D9534F;">' + errorMsg + '</span></td>');
		    tr.append('<td align="left"><div name="saveresult" style="text-align: center;"><span class="glyphicon glyphicon-exclamation-sign" style="color:#D9534F;"></span></div></td>');
		    tr.css('backgroundColor', '#F2DEDE');
	 	} else {
	 		tr.append('<td align="left"><span name="remarks">' + remarks + '</span></td>');
	 		tr.append('<td align="left"><div name="saveresult" style="text-align: center;"></div></td>');
	 	}
	 	tr.attr('errorFlag', errorFlag);
	 	tr.attr('bunyangSeq', bunyangSeq);
	 	tr.attr('totalPrice', totalPrice);
	    tbody.append(tr);
	});
}

/**
 * 
 */
function _savePayment(idx) {
	var len = $('#tblList tbody tr').length;
	if(len == 0) {
		common.showAlert('저장할 데이터가 없습니다.');
		return;
	}
	if($('#tblList tbody tr[errorFlag=true]').length > 0) {
		common.showAlert('유효하지 않은 데이터가 있습니다.');
		$('#divTbl:not(:animated)').animate({scrollTop: $('#tblList tbody tr[errorFlag=true]').eq(0).position().top}, 400);
		return;
	}
	var totalPaymentInfo = {};
	$('#tblList tbody tr').each(function(idx) {
		var bunyangSeq = $(this).attr('bunyangSeq');
		var totalPrice = $(this).attr('totalPrice');
		var bunyangNo = $(this).find('span[name="bunyangNo"]').text();
		var paymentDivision = $(this).find('span[name="paymentDivision"]').text();
		var paymentType = $(this).find('span[name="paymentType"]').text();
		var paymentAmount = common.toNumeric($(this).find('span[name="paymentAmount"]').text());
		// 분양건별로 계약금,중도금 합계를 산출
		if(paymentDivision == '입금') {
			if(paymentType == '계약금' || paymentType == '중도금') {
				if(!totalPaymentInfo[bunyangSeq]) {
					totalPaymentInfo[bunyangSeq] = {totalPrice:totalPrice, totalPayment:0, bunyangNo:bunyangNo};
				}
				totalPaymentInfo[bunyangSeq]['totalPayment'] += parseInt(paymentAmount);
			}
		}
	});
	// 계약금, 중도금 합계가 분양대금을 초과하는 건이 있는지 체크
	for(var key in totalPaymentInfo) {
		var info = totalPaymentInfo[key];
		if(info.totalPayment > info.totalPrice) {
			common.showAlert('계약번호 ' + info.bunyangNo + '의 계약금,중도금의 합계가 총분양대금 ' + $.number(info.totalPrice) + '원을 초과하였습니다.');
			$('#divTbl:not(:animated)').animate({scrollTop: $('tr[bunyangSeq="' + key + '"]').position().top}, 400);
			return;
		}
	}
	common.loading(true);
	doSave($('#tblList tbody tr').eq(0));	
}

/**
 * 
 */
function doSave(tr) {
	var paymentDate = tr.find('span[name="paymentDate"]').text();
	var paymentAmount = tr.find('span[name="paymentAmount"]').text();
	var paymentDivision = tr.find('span[name="paymentDivision"]').text();
	var paymentType = tr.find('span[name="paymentType"]').text();
	var bunyangNo = tr.find('span[name="bunyangNo"]').text();
	var paymentUser = tr.find('span[name="bunyangNo"]').attr('paymentUser');
	var remarks = tr.find('span[name="remarks"]').text();
	var data = {};
	data.paymentDate = common.toNumeric(paymentDate);
	data.paymentAmount = common.toNumeric(paymentAmount);
	if(paymentDivision == '입금') {
		data.paymentDivision = 'DEPOSIT';
		if(paymentType == '계약금') {
			data.paymentType = 'DOWN_PAYMENT';
		} else if(paymentType == '중도금') {
			data.paymentType = 'BALANCE_PAYMENT';
		} else if(paymentType == '관리비') {
			data.paymentType = 'MAINT_PAYMENT';
		} else if(paymentType == '이자') {
			data.paymentType = 'INTEREST';
		} else if(paymentType == '대체') {
			data.paymentType = 'VIREMENT';
		} else {
			data.paymentType = 'ETC';
		}
	} else if(paymentDivision == '출금') {
		data.paymentDivision = 'WITHDRAWAL';
		if(paymentType == '경비') {
			data.paymentType = 'EXPENSE';
		} else if(paymentType == '관리비') {
			data.paymentType = 'WITHDRAWAL_MAINT_PAYMENT';
		} else if(paymentType == '대체') {
			data.paymentType = 'WITHDRAWAL_VIREMENT';
		} else if(paymentType == '개발비') {
			data.paymentType = 'DEV_COST';
		} else if(paymentType == '해약금') {
			data.paymentType = 'CANCEL_PAYMENT';
		} else if(paymentType == '계약금') {
			data.paymentType = 'WITHDRAWAL_DOWN_PAYMENT';
		} else if(paymentType == '중도금') {
			data.paymentType = 'WITHDRAWAL_BALANCE_PAYMENT';
		} else {
			data.paymentType = 'ETC';
		}
	}
	data.bunyangNo = bunyangNo;
	data.paymentUser = paymentUser;
	data.remarks = remarks;
	
	common.ajax({
		url:"${contextPath}/popup/saveManualPayment", 
		data:data,
		showLoading:false,
		success: function(result) {
			if(result.result) {
				showSaveResultIcon(tr, true);
				if(bunyangNo) {
					if(data.paymentType == 'DOWN_PAYMENT' || data.paymentType == 'BALANCE_PAYMENT') {// 계약금, 중도금 입금시
						if(arrSavedBunyangNo.indexOf(bunyangNo) < 0) {
							arrSavedBunyangNo.push(bunyangNo);	
						}
					} else if(data.paymentType == 'CANCEL_PAYMENT') {// 해약금 출금시
						if(arrCanceledBunyangNo.indexOf(bunyangNo) < 0) {
							arrCanceledBunyangNo.push(bunyangNo);	
						}
					}
				}
				succeedRows.push(tr);
    		} else {
    			showSaveResultIcon(tr, false, result.errorMsg);
    			failedRows.push(tr);
    		}
			doNext(tr);
		},
		error: function(xhr, status, message) {
			showSaveResultIcon(tr, false, message);
			failedRows.push(tr);
			doNext(tr);
		}
	});
}

/**
 * 
 */
function doNext(tr) {
	$('#divTbl:not(:animated)').animate({scrollTop: $(tr).position().top}, 
			{complete : function() {
		    	if(tr.next().length > 0) {
					doSave(tr.next());
				} else {// 모든 데이터 저장
					common.loading(false);
					if(arrSavedBunyangNo.length > 0 || arrCanceledBunyangNo.length > 0) {
						common.showAlert('입출금내역이 저장되었습니다.\n계속해서 분양건 계약상태 업데이트를 진행합니다.');
						updateBunyangProgress();
					} else {
						common.showAlert('입출금내역이 저장되었습니다.');
						doEnd();
					}
				}
		    }, duration : 50
		  }
	);
}

/**
 * 
 */
function doEnd() {
	var totalCount = $('#tblList tbody tr').length;
	var successCount = succeedRows.length;
	var failedCount = failedRows.length;
	var resultText = '총 ' + totalCount +'건 / 성공 : ' + successCount + '건 / 실패 : ' + failedCount + '건';
	$('#uploadResult').text(resultText);
}

/**
 * 
 */
function updateBunyangProgress() {
	var arrTmp = [];
	// 저장된 분양건중에서 해약된 분양건은 제외
	$.each(arrSavedBunyangNo, function(idx) {
		var bno = arrSavedBunyangNo[idx];
		if(arrCanceledBunyangNo.indexOf(bno) < 0) {
			arrTmp.push(bno);
		}
	});
	if(arrTmp.length > 0 || arrCanceledBunyangNo.length > 0) {
		var data = {};
		data['savedBunyangNo'] = arrTmp;
		data['canceledBunyangNo'] = arrCanceledBunyangNo;
		common.ajax({
			url:"${contextPath}/popup/updateBunyangProgress", 
			data:JSON.stringify(data),
			contentType: 'application/json',
			success: function(result) {
				if(result.result) {
					common.showAlert('계약상태가 정상적으로 업데이트되었습니다.');
	    		}
				doEnd();
			},
			error: function(xhr, status, message) {
				common.showAlert('계약상태 업데이트시 에러가 발생하였습니다.');
			}
		});
	}
}

/**
 * 
 */
function showSaveResultIcon(tr, success, message) {
	tr.attr('saveresult', success);
	if(success) {
		tr.find('div[name="saveresult"]').html('<span class="glyphicon glyphicon-ok" style="color:#60C060;"></span>');
	} else {
		tr.find('div[name="saveresult"]').html('<span class="glyphicon glyphicon-exclamation-sign" style="color:#D9534F;" data-toggle="tooltip" title="' + message + '"></span>');
		tr.find('span[name="remarks"]').text(message);
		tr.css('backgroundColor', '#F2DEDE');
	}
}

</script>