/**
 * 
 */

var ajax = function(opt) {
	opt = opt || {};
	opt = $.extend(true, {
		type:'post',
		dataType:'json',
		showLoading:true
	}, opt);
	var successFunc = opt.success;
	var errorFunc = opt.error;
	opt.success = function(result) {
		if(successFunc != undefined) {
			successFunc(result);
		}
	};
	opt.error = function(xhr, status, message) {
		if(errorFunc != undefined) {
			errorFunc(xhr, status, message);
		}
	};
	if(opt.showLoading) {
		opt.beforeSend = function() {
			loading(true);
		};
		opt.complete = function() {
			loading(false);
		};
	}
	return $.ajax(opt);
}

var openWindow = function() {
	
}

var loading = function(show) {
	if(show) {
		$('body').append('<div class="modalWrapper"><div class="modal"></div><div class="spinner"></div></div>');	
	} else {
		$('body div.modalWrapper').remove();
	}
}

var uploadFile = function(file, cateDir, dosave, success, error) {
	var fileFrm = new FormData();
	fileFrm.append("file", file);
	if(cateDir) {
		fileFrm.append("cateDir", cateDir);
	}
	if(dosave != undefined) {
		fileFrm.append("dosave", dosave);
	}
   	$.ajax({
   		dataType : 'text',
        url:"/file/uploadFile",
        data:fileFrm,
        type : "POST",
        enctype: 'multipart/form-data',
        processData: false, 
        contentType:false,
        success : function(result) {
        	if(result){
        		if(success != undefined) {
        			success(result);
        		}
        	}else{
        		alert('파일 업로드에 실패하였습니다.');
        	}
		},error : function(result){
        	alert('파일 업로드중 에러가 발생하였습니다.');
        	if(error != undefined) {
        		error(result);
        	}
		}
    });
}

var exportExcel = function(headers, fields, fileName, queryId, paramKeys, paramValues) {
	var frm = $('<form action="/excel/exportExcel" method="post" target="_self"/>');
	// headers
	if(headers && headers.length > 0) {
		$.each(headers, function(idx, header) {
			$('<input>').attr({
			    type: 'hidden',
			    name: 'headers[' + idx + ']',
			    value: header
			}).appendTo(frm);
		});
	}
	
	// fields
	if(fields && fields.length > 0) {
		$.each(fields, function(idx, field) {
			$('<input>').attr({
			    type: 'hidden',
			    name: 'fields[' + idx + ']',
			    value: field
			}).appendTo(frm);
		});
	}
	
	// fileName
	$('<input>').attr({
	    type: 'hidden',
	    name: 'fileName',
	    value: fileName
	}).appendTo(frm);
	
	// queryId
	$('<input>').attr({
		type: 'hidden',
		name: 'queryId',
		value: queryId
	}).appendTo(frm);
	
	// paramKeys
	if(paramKeys && paramKeys.length > 0) {
		$.each(paramKeys, function(idx, paramKey) {
			$('<input>').attr({
			    type: 'hidden',
			    name: 'paramKeys[' + idx + ']',
			    value: paramKey
			}).appendTo(frm);
		});
	}
	
	// paramValues
	if(paramValues && paramValues.length > 0) {
		$.each(paramValues, function(idx, paramValue) {
			$('<input>').attr({
			    type: 'hidden',
			    name: 'paramValues[' + idx + ']',
			    value: paramValue
			}).appendTo(frm);
		});
	}
	
	frm.appendTo('body').submit();
	frm.remove();
}

var common = {};
common.ajax = ajax;
common.openWindow = openWindow;
common.loading = loading;
common.uploadFile = uploadFile;
common.exportExcel = exportExcel;

window.common = common;
