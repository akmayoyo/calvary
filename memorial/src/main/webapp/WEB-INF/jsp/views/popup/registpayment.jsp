<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<form id="frm" method="post">
</form>

<div class="poptitle">
	<strong>납입금 등록</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 10px 10px;">

	<div class="text-right" style="margin-top: 10px;">
    	<button class="btn btn-primary" type="button" onclick="_addRow()">추가</button>
    </div>

    <div class="table-responsive" style="margin-top: 10px;">
        <table id="tblList" class="table table-style table-bordered">
        	<colgroup>
        		<col width="20%">
        		<col width="11%">
        		<col width="11%">
        		<col width="11%">
        		<col width="11%">
        		<col width="11%">
        		<col width="11%">
        		<col width="4%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col" colspan="3">계약정보</th>
                    <th scope="col" colspan="4">납입정보</th>
                    <th scope="col" rowspan="2"></th>
                </tr>
                <tr>
                	<th scope="col">계약번호/신청자</th>
                    <th scope="col">총분양대금</th>
                    <th scope="col">기납부금액</th>
                    <th scope="col">납입일</th>
                    <th scope="col">납입금</th>
                    <th scope="col">납입유형</th>
                    <th scope="col">납부방법</th>
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
    // 계약번호
    tr.append('<td><select style="width:100%;" name="bunyangSeq" class="form-control"></select></td>');
 	// 총분양대금
    tr.append('<td><p name="totalPrice" class="form-control-static text-center"></td>');
 	// 기납부금액
    tr.append('<td><p name="totalPayment" class="form-control-static text-center"></td>');
    // 납입일
    tr.append('<td><div class="input-group date" data-provide="datepicker"><input name="paymentDate" type="text" class="form-control text-center"><div class="input-group-addon"><span class="glyphicon glyphicon-th"></span></div></div></td>');
    // 납입금
    tr.append('<td><input name="paymentAmount" type="text" class="form-control text-center"></td>');
    // 납입유형
    tr.append('<td><select name="paymentType" class="form-control"><option value="<%=CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT%>">계약금</option><option value="<%=CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT%>">분양잔금</option><option value="<%=CalvaryConstants.PAYMENT_TYPE_MAINT_PAYMENT%>">관리비</option></select></td>');
    // 납부방법
    tr.append('<td><select name="paymentMethod" class="form-control"><option value="<%=CalvaryConstants.PAYMENT_METHOD_TRANSFER%>">무통장/계좌이체</option><option value="<%=CalvaryConstants.PAYMENT_METHOD_CASH%>">현금납부</option></select></td>');
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
    	$(tr).find('p[name="totalPrice"]').text("₩" + $.number(total_price));
    	$(tr).find('p[name="totalPayment"]').text("₩" + $.number(down_payment+balance_payment));
    });

    // 납입일 datepicker
    common.datePicker($(tr).find('input[name="paymentDate"]'));

    // 납입금 포맷
    $("input[name='paymentAmount']").focusout(function(e) {
        var val = $(this).val();
        val = common.toNumeric(val);
        if (val) {
            val = "₩" + $.number(val);
        }
        $(this).val(val);
    }).focusin(function(e) {
        var val = $(this).val();
        val = common.toNumeric(val);
        $(this).val(val);
    });
}

/** 
 * 행삭제
 */
function _deleteRow(btn) {
    $(btn).parent("td").parent("tr").remove();
}

/**
 * 저장
 */
function _savePayment() {
    var bunyangSeqs = []; // 계약번호
    var paymentDates = []; // 납입일
    var paymentAmounts = []; // 납입금
    var paymentTypes = []; // 납입유형
    var paymentMethods = []; // 납입방법
    var contractBunyangSeqs = [];// 계약금이 모두 입금되어 계약상태로 변경해야될 분양건
    var fullPaymentBunyangSeqs = [];// 분양잔금이 모두 입금되어 완납상태로 변경해야될 분양건
    var bValidate = true;
    var summaryByBunyangSeq = {};// 계약번호별 입력된 납입금정보 합산을 위한 storage
    
    $('#tblList tbody tr').each(function(idx) {
        var tr = $(this);
        var data = tr.find('select[name="bunyangSeq"]').select2('data');
        var inputPaymentAmount = tr.find('input[name="paymentAmount"]');
        var bunyangInfo;// 계약정보
        var bunyang_seq;// 계약번호
        var total_price;// 총 분양대금
        var contract_price;// 총 계약금
        var balance_price;// 총 분양대금 - 계약금
        var down_payment;// 기납입된 계약금
        var balance_payment;// 기납입된 분양잔금
        if (data && data.length > 0) {
        	bunyangInfo = data[0];
            bunyang_seq = bunyangInfo['bunyang_seq'];
            total_price = bunyangInfo['total_price'];
            down_payment = bunyangInfo['down_payment'];
            balance_payment = bunyangInfo['balance_payment'];
            contract_price = total_price * (<%=CalvaryConstants.DOWN_PAYMENT_PERCENT%>/100);
            balance_price = total_price - contract_price;
        }
        var payment_date = tr.find('input[name="paymentDate"]').data('daterangepicker').startDate.format('YYYYMMDD');
        var payment_amount = common.toNumeric(inputPaymentAmount.val());
        var payment_type = tr.find('select[name="paymentType"] option:selected').val();
        var payment_method = tr.find('select[name="paymentMethod"] option:selected').val();
        
        payment_amount = payment_amount ? parseInt(payment_amount) : payment_amount;

        // 필수입력 체크
        if(!bunyang_seq) {
        	tr.find('select[name="bunyangSeq"]').select2('open');
        	common.showAlert('계약정보를 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_date) {
        	tr.find('input[name="paymentDate"]').focus();
        	common.showAlert('납입일을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_amount || payment_amount <= 0) {
        	inputPaymentAmount.focus();
        	common.showAlert('납입금을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_type) {
        	common.showAlert('납입유형을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_method) {
        	common.showAlert('납부방법을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        // 동일 계약건에 대해 복수개 입력가능하기 때문에 입력된 납입금의 validation 체크는 누적 데이터를 생성후 마지막에 수행함
        if(!summaryByBunyangSeq.hasOwnProperty(bunyang_seq)) {
        	summaryByBunyangSeq[bunyang_seq] = {};
        	summaryByBunyangSeq[bunyang_seq]['total_price'] = total_price;// 총 분양대금
            summaryByBunyangSeq[bunyang_seq]['down_payment'] = down_payment;// 기납입된 계약금 
            summaryByBunyangSeq[bunyang_seq]['balance_payment'] = balance_payment;// 기납입된 잔금
            summaryByBunyangSeq[bunyang_seq]['contract_price'] = contract_price;// 총 계약금
            summaryByBunyangSeq[bunyang_seq]['balance_price'] = balance_price;// 총 분양대금 - 총 계약금
        	summaryByBunyangSeq[bunyang_seq]['accum_down_payment'] = 0;// 화면에서 입력된 누적계약금
        	summaryByBunyangSeq[bunyang_seq]['accum_balance_payment'] = 0;// 화면에서 입력된 누적잔금
        	summaryByBunyangSeq[bunyang_seq]['accum_maint_payment'] = 0;// 화면에서 입력된 누적관리비
        }
        
     	// 납입금 누적정보 생성
        if(payment_type == '<%=CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT%>') {// 계약금
        	summaryByBunyangSeq[bunyang_seq]['accum_down_payment'] += payment_amount; 
        } else if(payment_type == '<%=CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT%>') {// 분양잔금
        	summaryByBunyangSeq[bunyang_seq]['accum_balance_payment'] += payment_amount; 
        } else if(payment_type == '<%=CalvaryConstants.PAYMENT_TYPE_MAINT_PAYMENT%>') {// 관리비
        	summaryByBunyangSeq[bunyang_seq]['accum_maint_payment'] += payment_amount; 
        }
        bunyangSeqs.push(bunyang_seq);
        paymentDates.push(payment_date);
        paymentAmounts.push(payment_amount);
        paymentTypes.push(payment_type);
        paymentMethods.push(payment_method);
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
       		common.showAlert('계약번호[' + key + '] 의 납입금 총액이 분양대금을 초과하였습니다.');
           	return;
       	}
        if(accum_down_payment > 0) {// 계약금이 있는경우
        	contractBunyangSeqs.push(key);	
        }
        if(accum_down_payment + accum_balance_payment + down_payment + balance_payment == total_price) {// 완납인경우
	       	fullPaymentBunyangSeqs.push(key);
        }
    }
    
    // 납입금 저장
    var paymentInfo = {};
    paymentInfo['bunyangSeqs'] = bunyangSeqs; 
    paymentInfo['paymentDates'] = paymentDates; 
    paymentInfo['paymentAmounts'] = paymentAmounts; 
    paymentInfo['paymentTypes'] = paymentTypes; 
    paymentInfo['paymentMethods'] = paymentMethods; 
    paymentInfo['contractBunyangSeqs'] = contractBunyangSeqs; 
    paymentInfo['fullPaymentBunyangSeqs'] = fullPaymentBunyangSeqs; 
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
    return '계약번호 : ' + repo.bunyang_seq + ' / ' + '신청자 : ' + repo.apply_user_name;
}

/**
 * 선택한 데이터 표시를 위한 포맷처리
 */
function formatRepoSelection(repo) {
    var sRtn = repo.text;
    if (repo.bunyang_seq) {
        sRtn = '계약번호 : ' + repo.bunyang_seq + ' / ' + '신청자 : ' + repo.apply_user_name;
    }
    return sRtn;
}

</script>