<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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
        <table id="tblList" class="table table-style table-bordered">
        	<colgroup>
        		<col width="12%">
        		<col width="10%">
        		<col width="8%">
        		<col width="8%">
        		<col width="10%">
        		<col width="20%">
        		<col width="20%">
        		<col width="5%">
        	</colgroup>
            <thead>
                <tr>
                    <th scope="col" class="required">입출일자</th>
                    <th scope="col" class="required">입출금액</th>
                    <th scope="col" class="required">입출구분</th>
                    <th scope="col" class="required">입출유형</th>
                    <th scope="col" class="required">입금자</th>
                    <th scope="col" class="required">계약정보</th>
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
    tr.append('<td><div class="input-group date" data-provide="datepicker"><input name="paymentDate" type="text" class="form-control text-center"><div class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></div></div></td>');
    // 입출금액
    tr.append('<td><input name="paymentAmount" type="text" class="form-control text-right"></td>');
    // 입출구분
    tr.append('<td><select name="paymentDivision" type="text" class="form-control text-center"><option value="DEPOSIT" selected>입금</option><option value="WITHDRAWAL">출금</option></td>');
	// 입출유형
    tr.append('<td><select name="paymentType" class="form-control"></select></td>');
    // 입금자
    tr.append('<td><input name="paymentUser" type="text" class="form-control text-center"></td>');
    // 계약정보
    tr.append('<td><select style="width:100%;" name="bunyangSeq" class="form-control"></select></td>');
 	// 비고
    tr.append('<td><input name="remark" type="text" class="form-control"></td>');
    // 납부방법
    //tr.append('<td><select name="paymentMethod" class="form-control"><option value="<%=CalvaryConstants.PAYMENT_METHOD_TRANSFER%>">무통장/계좌이체</option><option value="<%=CalvaryConstants.PAYMENT_METHOD_CASH%>">현금납부</option></select></td>');
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
    	if(!$(tr).find('input[name="paymentUser"]').val()) {
    		$(tr).find('input[name="paymentUser"]').val(data['apply_user_name']);
    	}
    	//$(tr).find('p[name="totalPrice"]').text("₩" + $.number(total_price));
    	//$(tr).find('p[name="totalPayment"]').text("₩" + $.number(down_payment+balance_payment));
    });

    // 납입일 datepicker
    common.datePicker($(tr).find('input[name="paymentDate"]'));

    // 납입금 포맷
    $(tr).find("input[name='paymentAmount']").focusout(function(e) {
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
    var contractBunyangSeqs = [];// 계약금이 모두 입금되어 계약상태로 변경해야될 분양건
    var fullPaymentBunyangSeqs = [];// 분양잔금이 모두 입금되어 완납상태로 변경해야될 분양건
    var bValidate = true;
    var summaryByBunyangSeq = {};// 계약번호별 입력된 납입금정보 합산을 위한 storage
    
    $('#tblList tbody tr').each(function(idx) {
        var tr = $(this);
        var data = tr.find('select[name="bunyangSeq"]').select2('data');
        var inputPaymentAmount = tr.find('input[name="paymentAmount"]');
        var bunyangInfo;// 계약정보
        var bunyang_seq;// 계약seq
        var bunyang_no;// 계약번호
        var progress_status;// 진행상태
        var total_price;// 총 분양대금
        var contract_price;// 총 계약금
        var balance_price;// 총 분양대금 - 계약금
        var down_payment;// 기납입된 계약금
        var balance_payment;// 기납입된 분양잔금
        if (data && data.length > 0) {
        	bunyangInfo = data[0];
            bunyang_seq = bunyangInfo['bunyang_seq'];
            bunyang_no = bunyangInfo['bunyang_no'];
            progress_status = bunyangInfo['progress_status'];
            total_price = bunyangInfo['total_price'];
            down_payment = bunyangInfo['down_payment'];
            balance_payment = bunyangInfo['balance_payment'];
            contract_price = total_price * (<%=CalvaryConstants.DOWN_PAYMENT_PERCENT%>/100);
            balance_price = total_price - contract_price;
        }
        var payment_date = tr.find('input[name="paymentDate"]').data('daterangepicker').startDate.format('YYYYMMDD');
        var payment_amount = common.toNumeric(inputPaymentAmount.val());
        var payment_division = tr.find('select[name="paymentDivision"] option:selected').val();
        var payment_type = tr.find('select[name="paymentType"] option:selected').val();
        var payment_user = tr.find('input[name="paymentUser"]').val();
        var remark = tr.find('input[name="remark"]').val();
        var payment_method = "<%=CalvaryConstants.PAYMENT_METHOD_TRANSFER%>";
        
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
        	common.showAlert('입출구분을 입력해주세요.');
        	bValidate = false;
        	return false;
        }
        if(!payment_type) {
        	common.showAlert('입출유형을 입력해주세요.');
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
        paymentDivisions.push(payment_division);
        paymentTypes.push(payment_type);
        paymentUsers.push(payment_user);
        paymentMethods.push(payment_method);
        remarks.push(remark);
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