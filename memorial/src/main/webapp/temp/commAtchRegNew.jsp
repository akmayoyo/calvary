<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<input type="hidden" id="c_fileDivSelectId">
	<input type="hidden" id="c_siteId">
	<input type="hidden" id="c_key1">
	<input type="hidden" id="c_key2">
	<input type="hidden" id="c_key3">
	<input type="hidden" id="c_key4">
	<input type="hidden" id="c_key5">
	<input type="hidden" id="c_atchId">
	<input type="hidden" id="c_taskId">
	<input type="hidden" id="c_updateFlag">

<!-- [Lov]첨부자료 추가/삭제 팝업 -->
	<div class="popup-wrap" id="lovPopUp-attachedFile"><!-- 호출시 .ui-select li a에 btn-popup 클래스가 있어야 함 -->
		<div class="pop-head">
			<h1>첨부자료 추가/삭제</h1>
			<button class="btn-closed" type="button" id="c_file_close_up">X</button>
		</div>
		<div class="pop-cont">
			<section class="section">
				<h2 class="bl-title">추가/삭제</h2>
				<div class="panel">
					<ul class="grid col2">
						<li>
							<div class="label-area">연계 화면</div>
							<div class="field-area">
								<input type="text" id="c_filePageName" disabled="disabled" />
							</div>
						</li>
						<li>
							<div class="label-area">대상 타이틀</div>
							<div class="field-area">
								<input type="text" id="c_fileTypeName" disabled="disabled" />
							</div>
						</li>
						<li>
							<div class="label-area">key Value</div>
							<div class="field-area">
								<input type="text" id="c_fileKeyValue" disabled="disabled" />
							</div>
						</li>
						<li>
							<div class="label-area"><strong>*</strong>첨부파일</div>
							<div class="field-area">
								<!-- <button class="btn add" type="button" id="c_fileupload" style="min-width: 90px;">파일추가</button> -->
								<button class="btn add" type="button" id="c_fileupload" style="min-width: 90px;">파일추가</button> &nbsp;&nbsp;※ 80Mb 이하로 업로드 가능.
								<form id="c_fileForm" name="c_fileForm" enctype="multipart/form-data">
								</form>
							</div>
						</li>
					</ul>
				</div>
				<div class="table-wrap checkType">
					<table>
						<caption>첨부파일 목록</caption>
						<colgroup>
							<col style="width:18%;" />
							<col style="width:auto;" />
							<col style="width:10%;" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">
									<span class="input-wrap">
										<input type="checkbox" id="c_checkAllFile" />
										<label for="c_checkAllFile"></label>
									</span> 삭제 선택
								</th>
								<th scope="col">첨부자료명</th>
								<th scope="col"></th>
							</tr>
						</thead>
						<tbody id='c_fileList'>
						</tbody>
					</table>
				</div>
			</section>
		</div>
		<div class="pop-foot">
			<button class="btn" type="button" id="c_file_close_down">닫기</button>
		</div>
	</div>

	<form id="c_downFileForm">
		<input id="downloadSeq" type="hidden" name="seq">
	</form>
<!-- //[Lov]첨부자료 추가/삭제 팝업 -->

<script type="text/javascript">
$(document).ready(function () {

	// 전체 삭제 체크박스 click
	$('#c_checkAllFile').on('click', function(){
		var checked = $("#c_checkAllFile").prop("checked");
		$("input[name=c_fileChk]").each(function(idx) {
			$(this).prop("checked",checked);
			$(this).attr("checked",checked);
			var seq = $(this).closest('tr').attr('data-seq');
			setDeletedFileInfo(seq, checked);
		});
	});

	// 삭제 체크박스 click
	$(document).on("click", "input[name=c_fileChk]", function(){
		var checked = $(this).prop("checked");
		$(this).attr("checked",checked);
		var seq = $(this).closest('tr').attr('data-seq');
		setDeletedFileInfo(seq, checked);
	});

	//팝업 닫을시.
	$('#c_file_close_up, #c_file_close_down').on('click', function(){
		//닫았을때 콜백 함수.
		var atchId = $('#c_atchId').val();

		$('#c_siteId' + atchId).val($('#c_siteId').val());
		$('#c_key1' + atchId).val($('#c_key1').val());
		$('#c_key2' + atchId).val($('#c_key2').val());
		$('#c_key3' + atchId).val($('#c_key3').val());
		$('#c_key4' + atchId).val($('#c_key4').val());
		$('#c_key5' + atchId).val($('#c_key5').val());
		$('#c_atchId' + atchId).val(atchId);
		$('#c_taskId' + atchId).val($('#c_taskId').val());

		if(typeof callbackFile != 'undefined' && callbackFile != null && $.isFunction(callbackFile)) {
			callbackFile();
		} else {
			if($('#c_updateFlag').val() == 'false') {
				setAtchFileLov([], atchId, $('#c_fileDivSelectId').val(), true);
			} else {
				getFileList($('#c_siteId').val(), $('#c_key1').val(), $('#c_key2').val(), $('#c_key3').val(), $('#c_key4').val(), $('#c_key5').val(), $('#c_atchId').val(), $('#c_taskId').val(), $('#c_fileDivSelectId').val(), 'sel');
			}
		}
	});

	//파일 다운로드
	//동적 생성으로 만들어진 경우 이벤트 선언시
	$(document).on("click", "td.title a", function(){

		var seq = $(this).closest('tr').attr('data-seq');

		$('#downloadSeq').val(seq);

		var formObj = $('#c_downFileForm');
		formObj.attr("action", "/cs/common/downloadFile");
		formObj.attr("method", "post");
		formObj.submit();
	});

	$('#c_fileupload').on('click', function() {
		var atchId = $('#c_atchId').val();
		$("#c_file" + atchId).trigger('click');
	});
});

// 삭제 파일 정보 설정
function setDeletedFileInfo(seq, deleted) {
	var atchId = $('#c_atchId').val();
	if(!deletedFileInfo[atchId]) {
		deletedFileInfo[atchId] = [];
	}
	var deletedList = deletedFileInfo[atchId];
	if(deleted && deletedList.indexOf(seq) < 0) {
		deletedList.push(seq);
	}else if(!deleted && deletedList.indexOf(seq) > -1) {
		for(var i = 0; i < deletedList.length; i++) {
			if(deletedList[i] == seq) {
				deletedList.splice(i, 1);
				break;
			}
		}
	}
}

function getFileList(siteId, key1, key2, key3, key4, key5, atchId, taskId, tagId, type){

	var data = JSON.stringify({"siteId": siteId, "key1": key1, "key2": key2, "key3": key3, "key4": key4, "key5": key5, "atchId": atchId})

	$.ajax({
        url:'/cs/common/getFileList',
        type:'post',
        async: false,
        dataType:'json',
        data:data,
        contentType:"application/json; charset=utf-8",
        success:function(data){
        	if(type == 'sel'){
        		setAtchFileLov(data.result, atchId, tagId, true);
        	} else if(type == 'list'){
        		setAtchFileList(data.result, atchId);
        	}
        },
        error:function(request,status,error){
        	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    })
}

function getFileList2(siteId, key1, key2, key3, key4, key5, atchId, taskId, tagId, type){

	var data = JSON.stringify({"siteId": siteId, "key1": key1, "key2": key2, "key3": key3, "key4": key4, "key5": key5, "atchId": atchId})

	$.ajax({
        url:'/cs/common/getFileList',
        type:'post',
        async: false,
        dataType:'json',
        data:data,
        contentType:"application/json; charset=utf-8",
        success:function(data){
        	if(type == 'sel'){
        		setAtchFileLov(data.result, atchId, tagId, false);
        	} else if(type == 'list'){
        		setAtchFileList(data.result, atchId);
        	}
        },
        error:function(request,status,error){
        	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    })
}

function setAtchFileList(fileList, atchId) {
	$('#c_fileKeyValue').val(atchId);
	var html = '';
	//신규 목록
	if(addedFileInfo && addedFileInfo[atchId]) {
		html += getAddedFileRows(addedFileInfo[atchId], 'list');
	}
    //기존 목록
    html += getExistFileRows(fileList, 'list');
    $('#c_fileList').html(html);
}

function setAtchFileLov(fileList, atchId, tagId, editable) {
	var html = '<a href="#" class="change-tex" title="리스트에서 항목을 선택하세요.">선택하세요.</a>';
	html += '<p class="arrow"><span>리스트 열기</span></p>';
	html += '<ul>';
	//신규 목록
	if(addedFileInfo && addedFileInfo[atchId]) {
		html += getAddedFileRows(addedFileInfo[atchId], 'sel');
	}
    //기존 목록
    html += getExistFileRows(fileList, 'sel');
	if(editable) {
		html += '<li><a href="#lovPopUp-attachedFile" class="btn-popup" data-status="' + atchId + '">추가/삭제</a></li>';
	}
    html += '</ul>'
    $('#' + tagId)[0].innerHTML = html;
}

function uploadFileData(callBack, messageYn){

	var form = new FormData(document.getElementById('c_fileForm'));

	var fileCnt = 0;
	if(addedFileInfo) {
		for(var atchId in addedFileInfo) {
			var addedFileList = addedFileInfo[atchId];
			if(addedFileList) {
				fileCnt += addedFileList.length;
				for(var i = 0; i < addedFileList.length; i++) {
					form.append('addedFile' + atchId, addedFileList[i]);
				}
			}
		}
	}

	if(deletedFileInfo) {
		for(var atchId in deletedFileInfo) {
			var deletedFileSeqs = deletedFileInfo[atchId];
			if(deletedFileSeqs) {
				fileCnt += deletedFileSeqs.length;
				for(var i = 0; i < deletedFileSeqs.length; i++) {
					form.append('deletedFileSeqs', deletedFileSeqs[i]);
				}
			}
		}
	}
	if(fileCnt > 0){
		ncommon.ajax({
			url:'/cs/common/uploadFileNew',
			type:'post',
			dataType:'json',
			data:form,
			processData:false,
			contentType:false,
			success:function(data){
				if(data.result == 'ERROR_EXT') {
					alert('첨부 파일중 허용되지 않은 확장자가 있습니다.' + "\n" + data.forbiddenFiles.join("\n"));
				} else if(data.result == 'SUCCESS') {
					if(messageYn == 'Y'){
						alert('첨부 파일이 저장되었습니다.');
		        	}
		        	callBack();
				}
	        },
	        error:function(request,status,error){
	        	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        }
		});
	} else {
		callBack();
	}

}

var addedFileInfo = {};
var deletedFileInfo = {};

// 추가,삭제시 임시 저장된 파일 정보 초기화
function initFileInfo(atchIds){
	var atchIdArr = atchIds.split(',');
	// 추가,삭제 파일정보 초기화
	for(var i = 0; i < atchIdArr.length; i++){
		addedFileInfo[atchIdArr[i]] = [];
		deletedFileInfo[atchIdArr[i]] = [];
	}
}

//첨부파일 업로드에 필요한 항목 폼을 구성한다.
function initFileForm(allAtchId){

	initFileInfo(allAtchId);

	var atchIdArr = allAtchId.split(',');

	var html = '';

	html += '<input id="c_allAtchId" type="hidden" name="allAtchId">';
	html += '<input id="c_allFileSelectId" type="hidden" name="allFileSelectId">';

	for(i=0; i<atchIdArr.length; i++){
		html += '<div class="c_fileDiv" id="' + atchIdArr[i] + '">';
		html += '<input id="c_file' + atchIdArr[i] + '" type="file" name="file' + atchIdArr[i] + '" multiple style="display: none;">';
		html += '<input id="c_siteId' + atchIdArr[i] + '" type="hidden" name="siteId' + atchIdArr[i] + '">';
		html += '<input id="c_key1' + atchIdArr[i] + '" type="hidden" name="key1' + atchIdArr[i] + '">';
		html += '<input id="c_key2' + atchIdArr[i] + '" type="hidden" name="key2' + atchIdArr[i] + '">';
		html += '<input id="c_key3' + atchIdArr[i] + '" type="hidden" name="key3' + atchIdArr[i] + '">';
		html += '<input id="c_key4' + atchIdArr[i] + '" type="hidden" name="key4' + atchIdArr[i] + '">';
		html += '<input id="c_key5' + atchIdArr[i] + '" type="hidden" name="key5' + atchIdArr[i] + '">';
		html += '<input id="c_atchId' + atchIdArr[i] + '" type="hidden" name="atchId' + atchIdArr[i] + '">';
		html += '<input id="c_taskId' + atchIdArr[i] + '" type="hidden" name="taskId' + atchIdArr[i] + '">';
		html += '</div>';
	}

	$('#c_fileForm')[0].innerHTML = html;

	//---------- 첨부파일 추가시 List 표시 20-08-08 ----------//
	$('#c_fileForm .c_fileDiv input[type=file]').on('change', function() {
		var files = $(this).get(0).files;
		var atchId = $('#c_atchId').val();
		var filesArr = Array.prototype.slice.call(files);
	    for(var i = 0; i < filesArr.length; i++) {
	    	if(!addedFileInfo[atchId]) {
	    		addedFileInfo[atchId] = [];
	    	}
	    	addedFileInfo[atchId].push(filesArr[i]);
	    }
	    clearFiles($(this));
		$('#c_fileList tr[isNew=true]').remove();
		var fileList = addedFileInfo[atchId];
		var newFileRows = getAddedFileRows(fileList, 'list');
		newFileRows += $('#c_fileList').html();
		$('#c_fileList').html(newFileRows);
	});
}

// 신규 추가된 파일에 대한 html 문자열 반환
function getAddedFileRows(fileList, type) {
	var html = '';
	if(fileList != null && fileList.length > 0) {
		$.each(fileList, function(i, file) {
			if(type == 'sel') {
				html += '<li><a href="javascript:void(0)" value="temp">' + file.name + '</a></li>';
			} else if(type == 'list') {
				var tr = $('<tr isNew="true"></tr>');
				var td = $('<td></td>');
				var span = $('<span class="input-wrap"></span>');
				span.append('<input type="checkbox" disabled/>');
				span.append('<label></label>');
				td.append(span);
				tr.append(td);
				tr.append('<td>' + file.name + '</td>');
				tr.append('<td><button style="min-width: 45px; padding: 7px 10px;" class="btn warning" type="button" onclick="cancelAddedFile(this)">취소</button></td>');
				html += tr[0].outerHTML;
			}
		});
	}
	return html;
}

// 기존 업로드된 파일에 대한 html 문자열 반환
function getExistFileRows(fileList, type) {
	var html = '';
	if(fileList != null && fileList.length > 0) {
		var atchId = $('#c_atchId').val();
		$.each(fileList, function(i, file) {
			var deleted = false;
			if(deletedFileInfo && deletedFileInfo[atchId]) {
				if(deletedFileInfo[atchId].indexOf(file.seq+'') > -1) {
					deleted = true;
				}
			}
			if(type == 'sel') {
				// 삭제 선택된 파일은 Lov에 표시안함
				if(!deleted) {
					html += '<li><a href="#" data-seq="' + file.seq + '">' + file.fileName + '</a></li>';
				}
			} else if(type == 'list') {
				var checkedStr = deleted ? "checked" : "";
				html += '<tr data-seq="' + file.seq + '">';
				html += '<td>';
				html += '<span class="input-wrap">';
				html += '<input type="checkbox" ' + checkedStr + ' id="lovPopAttachedFile_check_' + i + '" name="c_fileChk"/>';
				html += '<label for="lovPopAttachedFile_check_' + i + '"></label>';
				html += '</span>';
				html += '</td>';
				html += '<td class="title" style="text-align: center;"><a style="font-weight: normal;" href="javascript:void(0)">' + file.fileName + '</a></td>';
				html += '<td></td>';
				html += '</tr>';
			}
		});
	}
	return html;
}

// file input 의 files 정보 삭제
function clearFiles(el) {
	var agent = navigator.userAgent.toLowerCase();
	// 파일정보 리셋
	if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
		// ie 일때 input[type=file] init.
		el.replaceWith(el.val('').clone(true));
	}
	else
	{
		// other browser 일때 input[type=file] init.
		el.val("");
	}
}

// 신규 추가한 파일 첨부 취소
function cancelAddedFile(btn) {
	var atchId = $('#c_atchId').val();
	var tr = $(btn).closest('tr');
	var idx = $('#c_fileList tr').index(tr);
	tr.remove();
	if(addedFileInfo[atchId] && addedFileInfo[atchId].length > idx) {
		addedFileInfo[atchId].splice(idx, 1);
	}
}
</script>