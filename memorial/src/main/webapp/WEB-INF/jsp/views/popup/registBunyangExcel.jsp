<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="poptitle">
	<strong>분양신청 엑셀 업로드</strong>
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
	<div class="text-center" style="margin-top: 20px;">
        <button type="button" class="btn btn-primary btn-lg" onclick="_confirm()">확인</button>
        <button type="button" class="btn btn-default btn-lg btnClose">취소</button>
    </div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script src="http://malsup.github.com/jquery.form.js"></script> 
<script type="text/javascript">

var files;

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
 * 확인
 */
function _confirm() {
	
	if(files == null || files.length == 0) {
		common.showAlert('파일을 선택해주세요.');
		return;
	}
	var fileName = $('#info').val();
	if(!fileName || !/\.xlsx$/.test(fileName)) {
		common.showAlert('엑셀파일(xlsx) 만 업로드 가능합니다.');
		return;
	}
	var fileFrm = new FormData();
	fileFrm.append("file", files[0]);
   	$.ajax({
   		dataType : 'text',
        url:"/excel/importBunyangExcel",
        data:fileFrm,
        type : "POST",
        enctype: 'multipart/form-data',
        processData: false, 
        contentType:false,
        success : function(result) {
        	if(result) {
        		var resultCode= result;
        		if(resultCode == '-300') {
            		common.showAlert('에러가 발생하였습니다.');
            	} else if(resultCode == '-200') {
            		common.showAlert('해당 승인번호로 이미 등록된 분양정보가 있습니다.');
            	} else if(resultCode == '-100') {
            		common.showAlert('엑셀 업로드중 에러가 발생하였습니다.\n엑셀 양식을 확인해주세요.');
            	} else {
            		common.showAlert('정상적으로 업로드 되었습니다.');
            		var winoption = {width:1120, height:750};
            		common.openWindow("${contextPath}/popup/bunyanginfo", "popBunyangInfo", winoption, {bunyangSeq:resultCode});
            		files = null;
            		$('#info').val('');
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

</script>