/**
 *
 */
(function(){

	$.fn.exists = function () {
	    return this.length !== 0;
	}

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
	};

	var openWindow = function(url, name, winoption, param) {
	    name = name || "newWindow";
	    winoption = winoption || {};
	    winoption = $.extend(true, {
	        width: 700,
	        height: 500,
	        location: 'no',
	        menubar: 'no',
	        scrollbars: 'yes',
	        toolbar: 'no',
	        resizable: 'yes'
	    }, winoption);

	    var w = winoption.width,
	        h = winoption.height,
	        screenX = typeof window.screenX != 'undefined' ? window.screenX : window.screenLeft,
	        screenY = typeof window.screenY != 'undefined' ? window.screenY : window.screenTop,
	        outerWidth = typeof window.outerWidth != 'undefined' ? window.outerWidth : document.documentElement.clientWidth,
	        outerHeight = typeof window.outerHeight != 'undefined' ? window.outerHeight : document.documentElement.clientHeight - 22,
	        V = screenX < 0 ? window.screen.width + screenX : screenX,
	        left = parseInt(screenX + (outerWidth - w) / 2, 10),
	        top = parseInt(screenY + (outerHeight - h) / 2.5, 10);
	    if(!winoption.left) {
	    	winoption.left = left;
	    }
	    if(!winoption.top) {
	    	winoption.top = top;
	    }

	    var winoptionstr = "";
	    var winoptions = [];
	    for (key in winoption) {
	        winoptions.push(key + '=' + winoption[key]);
	    }
	    winoptionstr = winoptions.join(",");

	    var obj = window.open('', name, winoptionstr);
	    var frm = $('<form/>', {
	        action: url,
	        target: name,
	        method: 'post'
	    });

	    $('body').append(frm);

	    if (param) {
	        for (key in param) {
	            frm.append($('<input type="hidden" value="' + param[key] + '"name="' + key + '">'));
	        }
	    }

	    frm.submit();
	    frm.remove();
	    obj.focus();

	    return obj;
	};

	var closeWindow = function() {
		var win = window.open('', '_self'); win.close();
	};

	var loading = function(show) {
		if(show) {
			$('body').append('<div class="loadingModalWrapper"><div class="loadingModal"></div><div class="spinner"></div></div>');
		} else {
			$('body div.loadingModalWrapper').remove();
		}
	};

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
	};

	var exportExcel = function(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName) {

		var data = {};
		data["excelHeaders"] = excelHeaders;
		data["excelFields"] = excelFields;
		data["searchKeys"] = searchKeys;
		data["searchValues"] = searchValues;
		data["queryId"] = queryId;
		data["fileName"] = fileName;
		data["title"] = title;
		data["sheetName"] = sheetName;

		loading(true);

		$.fileDownload("/excel/exportExcel", {
			httpMethod: "POST",
			data:data,
			successCallback: function(url) {
				loading(false);
			},
			prepareCallback: function (url) {
				loading(false);
			},
			failCallback: function (responseHtml, url, error) {
				loading(false);
			}
		});
	}

	var exportExcel2 = function(headers, fields, fileName, queryId, paramKeys, paramValues) {
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
	};

	var formatBirthday = function(birthday) {
		var rtnVal = birthday;
		var numericVal = toNumeric(rtnVal);
		if(rtnVal && numericVal && numericVal.length == 8) {
			rtnVal = numericVal.substring(0,4) + "-" + numericVal.substring(4,6) + "-" + numericVal.substring(6,8);
		}
		return rtnVal;
	}

	var toNumeric = function(val) {
		var rtnVal = val;
		if(rtnVal) {
			rtnVal = rtnVal.replace(/\D/g, "");
		}
		return rtnVal;
	}

	var showAlert = function(msg) {
		alert(msg);
	}

	var calcBunyangPrice = function(coupleType, singleType) {
		var price = 0;
		var cnt = 0;
		var pricePerCnt = 2000000;
		if(coupleType > 0) {
			cnt += (coupleType*2);
		}
		if(singleType > 0) {
			cnt += singleType;
		}
		price = cnt*pricePerCnt;
		return price;
	}

	var isValidMail = function(email) {
		var regExp = /^[0-9a-zA-Z][_a-zA-Z0-9-\.]+@[\.a-zA-Z0-9-]+\.[a-zA-Z]+$/;
		if(!email) {
			return false;
		}
		if (!email.match(regExp)) {
			return false;
		}
		return true;
	}

	var isValidMobile = function(mobile) {
		var regExp = /^(010|011|016|017|018|019)-?\d{3,4}-?\d{4}$/;
		if(!mobile) {
			return false;
		}
		if (!mobile.match(regExp)) {
			return false;
		}
		return true;
	}

	var isValidPhone = function(phone) {
		var regExp = /^\d{2,4}-?\d{3,4}-?\d{4}$/;
		if(!phone) {
			return false;
		}
		if (!phone.match(regExp)) {
			return false;
		}
		return true;
	}

	var isVisible = function(el) {
	    if (el.length > 0 && el.css('visibility') !== 'hidden' && el.css('display') !== 'none') {
	        return true;
	    } else {
	        return false;
	    }
	}

	var datePicker = function(el, opt) {
		opt = opt || {};
		opt = $.extend(true, {
			singleDatePicker:true,
			showDropdowns:true,
			linkedCalendars:false,
			locale:{
				"format": "YYYY-MM-DD",
				 "daysOfWeek": [
		                "일",
		                "월",
		                "화",
		                "수",
		                "목",
		                "금",
		                "토"
		            ],
		            "monthNames": [
		                "1월",
		                "2월",
		                "3월",
		                "4월",
		                "5월",
		                "6월",
		                "7월",
		                "8월",
		                "9월",
		                "10월",
		                "11월",
		                "12월"
		            ],
		            "separator": " ~ ",
		            "applyLabel": "확인",
		            "cancelLabel": "취소"
			}
		}, opt);
		return el.daterangepicker(opt,
				function(start, end, label) {
					$(this)[0].element.change();
				}
		);
	}

	var trimAll = function(val) {
		var sRtn = '';
		if(val) {
			sRtn = val.replace(/\s/g, '');
		}
		return sRtn;
	}

	var sendSms = function(vo, successFunc, errorFunc) {
		var sendSmsVo = $.extend(true, {
			msgKey:null,
			msgType:'S',
			msgContents:null,
			sender:null,
			receivers:null,
			subject:null,
			sequences:null
		}, vo);

		ajax({
			url:"/commrest/sendSms",
			data:JSON.stringify(sendSmsVo),
			contentType: 'application/json',
			success: function(result) {
				if(successFunc != undefined) {
					successFunc(result);
				}
			},
			error: function(xhr, status, message) {
				showAlert('SMS 전송시 에러가 발생하였습니다.');
				if(errorFunc != undefined) {
					errorFunc(xhr, status, message);
				}
			}
		});
	}

	var isFreeBunyang = function(price) {
		var bRtn = false;
		if(!price || price == 0) {
			bRtn = true;
		}
		return bRtn;
	}

	var getCookie = function(cname) {
		var name = cname + "=";
		var decodedCookie = decodeURIComponent(document.cookie);
		var ca = decodedCookie.split(';');
		for(var i = 0; i <ca.length; i++) {
			var c = ca[i];
		    while (c.charAt(0) == ' ') {
		      c = c.substring(1);
		    }
		    if (c.indexOf(name) == 0) {
		      return c.substring(name.length, c.length);
		    }
		}
		return "";
	}

	var setCookie = function (cname, cvalue, exdays) {
		var d = new Date();
		d.setTime(d.getTime() + (exdays*24*60*60*1000));
		var expires = "expires="+ d.toUTCString();
		document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	}

	var common = {};
	common.ajax = ajax;
	common.openWindow = openWindow;
	common.closeWindow = closeWindow;
	common.loading = loading;
	common.uploadFile = uploadFile;
	common.exportExcel = exportExcel;
	common.exportExcel2 = exportExcel2;
	common.formatBirthday = formatBirthday;
	common.toNumeric = toNumeric;
	common.showAlert = showAlert;
	common.calcBunyangPrice = calcBunyangPrice;
	common.datePicker = datePicker;
	common.isValidMail = isValidMail;
	common.isValidMobile = isValidMobile;
	common.isValidPhone = isValidPhone;
	common.isVisible = isVisible;
	common.trimAll = trimAll;
	common.sendSms = sendSms;
	common.isFreeBunyang = isFreeBunyang;
	common.getCookie = getCookie;
	common.setCookie = setCookie;

	window.common = common;
})();
