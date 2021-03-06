<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style>
.select2-selection__rendered, .select2-results__option {
	font-size: 13px;
}
</style>

<form id="frm" method="post">
</form>

<div class="poptitle">
	<strong>입출금 등록</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">

	<div class="text-right" style="margin-top: 10px;">
    	<button class="btn btn-primary" type="button" onclick="_addRow()">추가</button>
    </div>

    <div class="table-responsive" style="margin-top: 10px;">
        <table id="tblList" class="table table-style table-bordered table-condensed">
        	<colgroup>
        		<col width="12%">
        		<col width="8%">
        		<col width="7%">
        		<col width="9%">
        		<col width="12%">
        		<col width="7%">
        		<col width="22%">
        		<col width="13%">
        		<col width="2%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col" class="required">입출일자</th>
                    <th scope="col" class="required">입출금액</th>
                    <th scope="col" class="required">입출구분</th>
                    <th scope="col" class="required">입출유형</th>
                    <th scope="col" class="required">납부방법</th>
                    <th scope="col" class="required">입금자</th>
                    <th scope="col">계약정보</th>
                    <th scope="col">비고</th>
                    <th scope="col"></th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>

	<div class="mt-30 text-center">
        <button type="button" class="btn btn-primary btn-lg" onclick="_savePayment()">저장</button>
        <button type="button" class="btn btn-default btn-lg btnClose">취소</button>
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
<script type="text/javascript" src="${contextPath}/resources/js/select2.min.js"></script>
<script type="text/javascript">
(function() {
    // 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
    // default 행 추가
    _addRow();
})();

/**
 * 행추가
 */
function _addRow() {
    var tr = $('<tr/>');
    // 입출일자
    tr.append('<td><div class="input-group date" data-provide="datepicker"><input name="paymentDate" type="text" class="form-control text-center font-13"><div class="input-group-addon" style="cursor: pointer;"><span class="glyphicon glyphicon-calendar"></span></div></div></td>');
    // 입출금액
    tr.append('<td><input name="paymentAmount" type="text" class="form-control text-right font-13"></td>');
    // 입출구분
    tr.append('<td><select name="paymentDivision" type="text" class="form-control text-center font-13"><option value="DEPOSIT" selected>입금</option><option value="WITHDRAWAL">출금</option></td>');
	// 입출유형
    tr.append('<td><select name="paymentType" class="form-control font-13"></select></td>');
 	// 납부방법
    tr.append('<td><select name="paymentMethod" class="form-control font-13"><option value="<%=CalvaryConstants.PAYMENT_METHOD_TRANSFER%>">무통장/계좌이체</option><option value="<%=CalvaryConstants.PAYMENT_METHOD_CASH%>">현금납부</option></select></td>');
    // 입금자
    tr.append('<td><input name="paymentUser" type="text" class="form-control text-center font-13"></td>');
    // 계약정보
    tr.append('<td class="form-inline"><select style="width:250px;" name="bunyangSeq" class="form-control font-13"></select><button name="btnMaintUser" type="button" style="display:none;" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button></td>');
 	// 비고
    tr.append('<td><input name="remark" type="text" class="form-control font-13" placeholder="20자 이내" maxlength="20"></td>');
    // 삭제버튼
    tr.append('<td><button type="button" class="btn btn-default btn-sm" onclick="_deleteRow(this)"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button></td>');

    $('#tblList tbody').append(tr);

    // 계약정보 선택 select box
    $(tr).find('select[name="bunyangSeq"]').select2({
        ajax: {
            url: "${contextPath}/admin/getBunyangSelectList",
            dataType: 'json',
            delay: 500,
            data: function(params) {
                return {
                    searchVal: params.term,
                    pageIndex: params.page || 1
                };
            },
            processResults: function(data, params) {
                params.page = params.page || 1;
                return {
                    results: data.result,
                    pagination: {
                        more: (params.page * 10) < data.total_count
                    }
                };
            },
            cache: false
        },
        placeholder: '계약정보 선택',
        escapeMarkup: function(markup) {
            return markup;
        },
        allowClear: true,
        minimumInputLength: 1,
        templateResult: formatRepo,
        templateSelection: formatRepoSelection,
        language: {
            inputTooShort: function(args) {
                // 	        var remainingChars = args.minimum - args.input.length;
                // 	        var message = '너무 짧습니다. ' + remainingChars + ' 글자 더 입력해주세요.';
                // 	        return message;
                //return '최소 두글자 이상 입력해주세요.';
                return '계약번호 또는 신청자명 입력';
            },
            loadingMore: function() {
                return '불러오는 중…';
            },
            noResults: function() {
                return '결과가 없습니다.';
            },
            searching: function() {
                return '검색 중…';
            },
            errorLoading: function() {
                return '결과를 불러올 수 없습니다.';
            }
        }
    });
    // 계약정보 select2 선택시 총분양대금 및 기납부금액 표시
    $(tr).find('select[name="bunyangSeq"]').on('select2:select', function (e) {
    	var data = e.params.data;
    	var total_price = data['total_price'];
    	var down_payment = data['down_payment'];
    	var balance_payment = data['balance_payment'];
    	$(tr).find('input[name="paymentUser"]').val(data['apply_user_name']);
    	//$(tr).find('p[name="totalPrice"]').text("₩" + $.number(total_price));
    	//$(tr).find('p[name="totalPayment"]').text("₩" + $.number(down_payment+balance_payment));
    });

    // 납입일 datepicker
    common.datePicker($(tr).find('input[name="paymentDate"]'));
    
    $('input[name="paymentDate"]').next().click(function() {
		$(this).prev().focus();
	});

    // 납입금 포맷
    $(tr).find("input[name='paymentAmount']").focusout(function(e) {
        var val = $(this).val();
        val = common.toNumeric(val);
        if (val) {
            val = $.number(val);
        }
        $(this).val(val);
    }).focusin(function(e) {
        var val = $(this).val();
        val = common.toNumeric(val);
        $(this).val(val);
    });
    
    // 입출구분 별 입출유형 코드리스트 표시
    $(tr).find('select[name="paymentDivision"]').change(function(e) {
		var paymentTypeList = '';
		var selected = $(this).find('option:selected').val();
		if(selected) {
			$('#'+selected+'List li').each(function(idx) {
				paymentTypeList += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
		}else {
			$('#DEPOSITList li').each(function(idx) {
				paymentTypeList += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
			$('#WITHDRAWALList li').each(function(idx) {
				paymentTypeList += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
		}
		$(tr).find('select[name="paymentType"]').html(paymentTypeList);
	});
    
 	// 입출유형 변경이벤트
    $(tr).find('select[name="paymentType"]').change(function(e) {
    	var selectedPaymentDivision = $(tr).find('select[name="paymentDivision"]').find('option:selected').val();
    	var selectedPaymentType = $(this).find('option:selected').val();
    	if(selectedPaymentDivision == '<%=CalvaryConstants.PAYMENT_DIVISION_DEPOSIT%>' 
    			&& selectedPaymentType == '<%=CalvaryConstants.PAYMENT_TYPE_MAINT_PAYMENT%>') {// 관리비 입금의 경우만 사용자 선택 버튼 표시
    		$(tr).find('button[name="btnMaintUser"]').show();
    	} else {
    		$(tr).find('button[name="btnMaintUser"]').hide();
    	}
    });
 	
 	// 관리비 대상자 조회 버튼 클릭
    $(tr).find('button[name="btnMaintUser"]').click(function(e) {
    	var data = $(tr).find('select[name="bunyangSeq"]').select2('data');
    	if(!data || data.length == 0) {
    		common.showAlert('계약정보를 선택해주세요.');
    		$(tr).find('select[name="bunyangSeq"]').select2('open');
    	} else {
    		var bunyangInfo = data[0];
            var bunyangSeq = bunyangInfo['bunyang_seq'];
            var winoption = {width:1180, height:750};
        	var param = {};
        	param['bunyangSeq'] = bunyangSeq;
        	param['maintYear'] = 0;
        	param['paymentYn'] = 'N';
        	param['popupTitle'] = '관리비 납부대상 선택';
        	param['selectable'] = '1';
        	common.openWindow("${contextPath}/popup/maintPaymentDetailInfo", "popMaintPaymentDetailInfo", winoption, param);
        	window.selectuserCallBack = function(selectedItems) {
        		var idx = 0;
        		var maintSeq = selectedItems[idx++];
        		var userName = selectedItems[idx++];
        		var chargerName = selectedItems[idx++];
        		var paymentPrice = selectedItems[idx++];
        		$(tr).find('input[name="paymentUser"]').val(chargerName);
        		$(tr).find('input[name="paymentAmount"]').val($.number(paymentPrice));
        		data[0].maint_seq = maintSeq;
        	};
    	}
    });
	
    $(tr).find('select[name="paymentDivision"]').trigger('change');
}

/** 
 * 행삭제
 */
function _deleteRow(btn) {
    $(btn).parent("td").parent("tr").remove();
}

/**
 * 납부자 선택 팝업 표시
 */
function _selectPaymentUser(btn) {
	var winoption = {width:1240, height:830};
	var param = {popupTitle: "납부자 입력"};
	common.openWindow("${contextPath}/popup/selectuser", "popRegistPaymentUser", winoption, param);
	// 납부자 입력 팝업 callback 함수
	window.selectuserCallBack = function(type, item) {
		var idx = 0, userId = '', userName = '', birthDate = '', email = '', mobile = '', postNumber = '', address1 = '', address2 = '', fulladdress = '', churchOfficer = '', diocese = '';
		if(item && item.length > 0) {
			var input = $(btn).parent('span').prev('input');
			userId = item[idx++];
			userName = item[idx++];
			birthDate = item[idx++];
			email = item[idx++];
			mobile = item[idx++];
			postNumber = item[idx++];
			address1 = item[idx++];
			address2 = item[idx++];
			fulladdress = item[idx++];
			churchOfficer = item[idx++];
			churchOfficerName = item[idx++];
			diocese = item[idx++];
			input.attr('userId', userId);
			input.attr('userName', userName);
			input.attr('birthDate', birthDate);
			input.attr('email', email);
			input.attr('mobile', mobile);
			input.attr('postNumber', postNumber);
			input.attr('address1', address1);
			input.attr('address2', address2);
			input.attr('fulladdress', fulladdress);
			input.attr('churchOfficer', churchOfficer);
			input.attr('churchOfficerName', churchOfficerName);
			input.attr('diocese', diocese);
			input.val(userName);
		}
	};
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
    var maintSeqs = []; // 관리비 납부대상자정보
    var contractBunyangSeqs = [];// 계약금이 모두 입금되어 계약상태로 변경해야될 분양건
    var fullPaymentBunyangSeqs = [];// 분양잔금이 모두 입금되어 완납상태로 변경해야될 분양건
    var bValidate = true;
    var summaryByBunyangSeq = {};// 계약번호별 입력된 납입금정보 합산을 위한 storage
    var existSmsReceiver = false;
    var tmpMap = {};
    $('#tblList tbody tr').each(function(idx) {
        var tr = $(this);
        var data = tr.find('select[name="bunyangSeq"]').select2('data');
        var inputPaymentAmount = tr.find('input[name="paymentAmount"]');
        var bunyangInfo;// 계약정보
        var bunyang_seq = ' ';// 계약seq
        var bunyang_no;// 계약번호
        var progress_status;// 진행상태
        var total_price;// 총 분양대금
        var contract_price;// 총 계약금
        var balance_price;// 총 분양대금 - 계약금
        var down_payment;// 기납입된 계약금
        var balance_payment;// 기납입된 분양잔금
        var maint_seq;// 관리비 납부대상자정보 seq
        if (data && data.length > 0) {
        	bunyangInfo = data[0];
            bunyang_seq = bunyangInfo['bunyang_seq'];
            bunyang_no = bunyangInfo['bunyang_no'];
            progress_status = bunyangInfo['progress_status'];
            total_price = bunyangInfo['total_price'];
            down_payment = bunyangInfo['down_payment'];
            balance_payment = bunyangInfo['balance_payment'];
            maint_seq = bunyangInfo['maint_seq'];
            contract_price = total_price * (<%=CalvaryConstants.DOWN_PAYMENT_PERCENT%>/100);
            balance_price = total_price - contract_price;
        }
        var payment_date = tr.find('input[name="paymentDate"]').data('daterangepicker').startDate.format('YYYYMMDD');
        var payment_amount = common.toNumeric(inputPaymentAmount.val());
        var payment_division = tr.find('select[name="paymentDivision"] option:selected').val();
        var payment_type = tr.find('select[name="paymentType"] option:selected').val();
        var payment_user = tr.find('input[name="paymentUser"]').val();
        var remark = tr.find('input[name="remark"]').val();
        if(!remark) {
        	remark = ' ';
        }
        var payment_method = tr.find('select[name="paymentMethod"] option:selected').val();
        
        payment_amount = payment_amount ? parseInt(payment_amount) : payment_amount;

        // 필수입력 체크
//         if(!bunyang_seq) {
//         	tr.find('select[name="bunyangSeq"]').select2('open');
//         	common.showAlert('계약정보를 입력해주세요.');
//         	bValidate = false;
//         	return false;
//         }
        if(!payment_date) {
        	tr.find('input[name="paymentDate"]').focus();
        	common.showAlert('입출일자를 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_amount || payment_amount <= 0) {
        	inputPaymentAmount.focus();
        	common.showAlert('입출금액을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_division) {
        	tr.find('select[name="paymentDivision"]').focus();
        	common.showAlert('입출구분을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_type) {
        	tr.find('select[name="paymentType"]').focus();
        	common.showAlert('입출유형을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_method) {
        	tr.find('select[name="paymentMethod"]').focus();
        	common.showAlert('납부방법을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_user) {
        	tr.find('input[name="paymentUser"]').focus();
        	common.showAlert('입금자를 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        // 입금/관리비의 경우 관리비대상 사용자 선택여부 체크
        if(payment_division == 'DEPOSIT' && payment_type == 'MAINT_PAYMENT' && !maint_seq) {
        	tr.find('button[name="btnMaintUser"]').focus();
        	common.showAlert('관리비 입금의 경우 계약정보란의 검색 버튼을 클릭하여 관리비 대상을 선택해주세요.');
        	bValidate = false;
        	return false;
        }
        
       	var key;
       	if(bunyang_seq) {
       		key = payment_date + '_' +bunyang_seq;
       		if(tmpMap[key]) {
           		common.showAlert('입출일자/계약정보가 중복된 데이터가 있습니다.\n입출일자 : ' + payment_date + ', 계약번호 : ' + bunyang_no);
            	bValidate = false;
            	return false;
           	} else {
           		tmpMap[key] = true;
           	}	
       	}
        
        // 동일 계약건에 대해 복수개 입력가능하기 때문에 입력된 납입금의 validation 체크는 누적 데이터를 생성후 마지막에 수행함
        if(bunyang_seq && !summaryByBunyangSeq.hasOwnProperty(bunyang_seq)) {
        	summaryByBunyangSeq[bunyang_seq] = {};
        	summaryByBunyangSeq[bunyang_seq]['bunyang_no'] = bunyang_no;// 계약번호
        	summaryByBunyangSeq[bunyang_seq]['progress_status'] = progress_status;// 진행상태
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
            if(payment_division == 'DEPOSIT') {
            	existSmsReceiver = true;
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
        maintSeqs.push(maint_seq ? maint_seq : 'none');
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
        // 입력된 계약금 + 기납부된 계약금이 총 계약금보다 클 경우
//         if(accum_down_payment + down_payment > contract_price) {
//         	common.showAlert('계약번호[' + key + ']  계약건에대해 입력된 계약금이 입력가능한 ');
//         	return;
//         }
        // 기납부금액 + 입력된 납입금이 총 분양대금보다 클 경우
       	if(accum_down_payment + accum_balance_payment + down_payment + balance_payment > total_price) {
       		common.showAlert('계약번호[' + bunyangInfo['bunyang_no'] + '] 의 납입금 총액이 분양대금을 초과하였습니다.');
           	return;
       	}
        if(bunyangInfo['progress_status'] == '<%=CalvaryConstants.PROGRESS_STATUS_A%>' && accum_down_payment > 0 && (accum_down_payment+down_payment) >= contract_price) {// 계약금 모두 납부한경우
        	contractBunyangSeqs.push(key);	
        }
        if(bunyangInfo['progress_status'] == '<%=CalvaryConstants.PROGRESS_STATUS_B%>' && accum_down_payment + accum_balance_payment + down_payment + balance_payment == total_price) {// 완납인경우
	       	fullPaymentBunyangSeqs.push(key);
        }
    }
    
    // 납입금 저장
    var paymentInfo = {};
    paymentInfo['bunyangSeqs'] = bunyangSeqs; 
    paymentInfo['paymentDates'] = paymentDates; 
    paymentInfo['paymentAmounts'] = paymentAmounts; 
    paymentInfo['paymentDivisions'] = paymentDivisions; 
    paymentInfo['paymentTypes'] = paymentTypes; 
    paymentInfo['paymentUsers'] = paymentUsers; 
    paymentInfo['paymentMethods'] = paymentMethods; 
    paymentInfo['remarks'] = remarks; 
    paymentInfo['maintSeqs'] = maintSeqs; 
    paymentInfo['contractBunyangSeqs'] = contractBunyangSeqs; 
    paymentInfo['fullPaymentBunyangSeqs'] = fullPaymentBunyangSeqs; 
    if(existSmsReceiver && confirm('계약자에게 입금 안내 메세지를 전송하시겠습니까?')) {
    	paymentInfo['sendSmsYn'] = 'Y';	
    }
    common.ajax({
		url:"${contextPath}/popup/savepayment", 
		data:paymentInfo,
		success: function(result) {
			if(result && result.result) {
	        	common.showAlert('저장되었습니다.');
	        	if (window.opener && window.opener.saveCallBack != 'undefined') {
		            window.opener.saveCallBack(result);
		            common.closeWindow();
		        }
        	}else {
        		common.showAlert('저장에 실패하였습니다.');
        	}
		}
	});
}

/**
 * select list행 표시를 위한 포맷처리
 */
function formatRepo(repo) {
    if (repo.loading) {
        return repo.text;
    }
    var bunyang_no = repo.bunyang_no;
    if(!bunyang_no) {
    	bunyang_no = '-';
    }
    return '계약번호 : ' + bunyang_no + ' / ' + '신청자 : ' + repo.apply_user_name;
}

/**
 * 선택한 데이터 표시를 위한 포맷처리
 */
function formatRepoSelection(repo) {
    var sRtn = repo.text;
    if (repo.bunyang_seq) {
    	var bunyang_no = repo.bunyang_no;
        if(!bunyang_no) {
        	bunyang_no = '-';
        }
        sRtn = '계약번호 : ' + bunyang_no + ' / ' + '신청자 : ' + repo.apply_user_name;
    }
    return sRtn;
}

</script>