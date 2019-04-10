<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" name="bunyangSeq">
	<input type="hidden" name="userId">
	<input type="hidden" name="sectionSeq">
	<input type="hidden" name="seqNo">
</form>
<c:choose>
<c:when test="${isOccupied }">
<script type="text/javascript">
	alert('이미 사용(봉안)중인 사용자입니다.');
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
</script>
</c:when>
<c:otherwise>
<header class="m_header">
	<!-- 사이트 로고 -->
	<a class="logo" href="${contextPath}/mobile/main">
		<img src="${contextPath}/resources/assets/images/logo_w.png" alt="" style="width: 145px;">
	</a>

	<!-- 로그아웃 -->
	<div class="pull-right bx_logout">
		<a href="http://b2b.yonginparklife.com/mobile.b2b/m.index.asp#" target="_blank" style="display: inline-block;">용인공원</a>
		<a href="javascript:void(0)" onclick="_logout()" style="display: inline-block;">로그아웃</a></li>
	</div>
</header>

<!-- 컨텐츠 -->
<div class="m_contents">
	
	<!-- 아코디언 메뉴 -->
	<div id="m_menu" class="m_menu">
		
		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">추모동산 배치도</a>
			</div>
			<div id="menu2">
				<div class="padding-15" style="border-bottom: 1px solid #e7e7e7; text-align: center;">
					<img alt="" src="${contextPath}/resources/assets/images/grave.png" style="width: 100%; border: 1px solid #f0f0f0; max-width: 1002px;">
				</div>
			</div>
		</div>

		<div class="panel">
			<div class="depth1">
				<a href="javascript:void(0)" style="font-size: 14px;">사용(봉안) 신청정보</a>
			</div>
			<div id="menu2">
				<div class="padding-15">
					<table class="table m_table">
						<colgroup>
							<col width="30%">
							<col width="70%">
						</colgroup>
						<tbody>
							<tr>
								<th scope="sel">사용(봉안)자</th>
								<td class="text-left">${useUserInfo.user_name}</td>
							</tr>
							<tr>
								<th scope="sel">장묘형태</th>
								<td class="text-left">
									<c:choose>
            							<c:when test="${!empty useUserInfo.couple_seq}">부부형</c:when>
            							<c:otherwise>1인형</c:otherwise>
            						</c:choose>
								</td>
							</tr>
							<c:if test="${empty assignedGraveInfo}">
							<tr>
								<th scope="sel">구역</th>
								<td class="text-left">
									<c:choose>
										<c:when test="${!empty assignedGraveInfo}">${assignedGraveInfo.section_seq}</c:when>
										<c:otherwise>
											<select id="selGraveSection" class="form-control" onchange="_changeGraveSection()">
											<c:forEach items="${avaliableGraveList}" var="rowItem">
												<option value="${rowItem.section_seq}" rowSeq="${rowItem.row_seq}" colSeq="${rowItem.col_seq}"  seqNo="${rowItem.seq_no}">${rowItem.section_seq}</option>
											</c:forEach>
											</select>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							</c:if>
							<tr>
								<th scope="sel">사용(봉안)위치</th>
								<td class="text-left">
									<a id="aDetailGraveInfo" href="javascript:void(0);" style="padding: 5px 0;"></a>
									<c:if test="${empty assignedGraveInfo}">
									<span style="color: #007BFF;">※사용(봉안)위치는 선택하신 구역내 순차적으로 배정됩니다.</span>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>
    				
    				<div style="background-color: #E0EFFC; padding: 10px 10px; margin-top: 15px;">
    					<div style="text-align: center;">
							<h4 id="mapTitle" style="display: inline-block;">[ 구역] 사용(봉안)위치 정보</h3>
						</div>
						<div style="text-align: center; margin-top: 5px;">
							<div style="width: 10px; height: 10px; background-color: #BFBFBF; display: inline-block;">
							</div>
							<span>사용중</span>
							<div style="width: 10px; height: 10px; background-color: #007BFF; display: inline-block; margin-left: 15px;">
							</div>
							<span id="assignLegend">배정구역</span>
						</div>
						
						<div id="grid" style="text-align: center; margin-top: 20px;">
						</div>			
						
						
    				</div>
    				
    				<div class="text-center" style="margin-top: 15px;">
        				<button type="button" class="btn btn-primary btn-lg" onclick="_request()">신청</button>
        				<button type="button" class="btn btn-default btn-lg" onclick="_cancel()">취소</button>
    				</div>
    				
				</div>
			</div>
		</div>
		
	</div>
	
</div>

<c:if test="${!empty useUserInfo.couple_seq}">
<input id="coupleSeq" type="hidden" value="${useUserInfo.couple_seq}">
</c:if>
<input id="userSeq" type="hidden" value="${useUserInfo.user_seq}">
<c:if test="${!empty assignedGraveInfo}">
<input id="assignedSectionSeq" type="hidden" value="${assignedGraveInfo.section_seq}">
<input id="assignedRowSeq" type="hidden" value="${assignedGraveInfo.row_seq}">
<input id="assignedColSeq" type="hidden" value="${assignedGraveInfo.col_seq}">
<input id="assignedSeqNo" type="hidden" value="${assignedGraveInfo.seq_no}">
</c:if>

<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">

(function() {
	if($('#assignedSectionSeq').val()) {
		var sectionSeq = $('#assignedSectionSeq').val();
		var rowSeq = $('#assignedRowSeq').val();
		var colSeq = $('#assignedColSeq').val();
		var seqNo = $('#assignedSeqNo').val();
		showGraveMap();
		showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo);
	} else {
		$('#selGraveSection').trigger('change');	
	}
})();

/**
 * 
 */
function _changeGraveSection() {
	var selectedOption = $('#selGraveSection').find('option:selected');
	var sectionSeq = selectedOption.val();
	var rowSeq = selectedOption.attr('rowSeq');
	var colSeq = selectedOption.attr('colSeq');
	var seqNo = selectedOption.attr('seqNo');
	showGraveMap();
	showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo);
}

/**
 * 
 */
function showGraveMap() {
	var assignedInfo = getAssignedGraveInfo();
	var sectionSeq = assignedInfo['sectionSeq'];
	var rowSeq = assignedInfo['rowSeq'];
	var colSeq = assignedInfo['colSeq'];
	var seqNo = assignedInfo['seqNo'];
	
	if(sectionSeq && rowSeq && colSeq) {
		$('#mapTitle').text('[' + sectionSeq + '구역] 사용(봉안)위치 정보');
		$('#assignLegend').text('배정구역 (' + rowSeq + '행 - ' + seqToAlpha(colSeq) + '열)');
		common.ajax({
			url:"${contextPath}/mobile/getGraveUseList", 
			data:{},
			success: function(result) {
				var sectionData = getSectionData(result, sectionSeq);
				var gridData;
				 if(sectionData != null && sectionData.length > 0) {
					 gridData = getGridData(sectionData, false, 0, 15);
					 makeGraveGrid('#grid', gridData);
				 }
			}
		});
	}
}

/**
 * section 에 해당하는 데이터를 반환
 */
function getSectionData(data, section_seq) {
	var rtn = [];
	if(data != null) {
		$.each(data, function(idx){
			var section = data[idx]['section_seq'];
			if(section == section_seq) {
				rtn.push(data[idx]);
			}
		});
	}
	return rtn;
}

/**
 * d3 Grid 배치를 위한 데이터 반환
 */
function getGridData(data, reverse, offset, w, h) {
	var rows = [], cols = [], rowCols = [], rowIdx = -1, colIdx = -1,
	row_seq, col_seq, max_col_cnt, min_col_seq
	;
	if(!offset) offset = 0;
	$.each(data, function(idx, item){
		row_seq = item['row_seq'];
		col_seq = item['col_seq'];
		min_col_seq = item['min_col_seq'];
		max_col_cnt = item['max_col_cnt'] + 1;// 행번호표시를 위한 rect 1개 plus
		if(rows.indexOf(row_seq) < 0) {
			rows.push(row_seq);
			cols = [];
			for(i = 0; i < max_col_cnt+offset; i++) {
				cols.push({});
			}
			rowCols.push(cols);
			rowIdx++
		}
		// 행번호 표시용 정보 추가
		rowCols[rowIdx][min_col_seq -1 + offset] = {row_seq:row_seq, is_rownum:true, col_seq:min_col_seq};
		if(reverse) {
			rowCols[rowIdx][max_col_cnt - col_seq] = item;
		} else {
			rowCols[rowIdx][col_seq + offset] = item;
		}
	});
	
	var xpos = 1;
    var ypos = 1;
    var width = w ? w : 15;
    var height = h ? h : 15;
    var rowNumWidth = 15;
    var rtnData = {};
    var totalwidth = 0;
    var totalheight = 0;
    var gridData = [];
    var margin = 4;
    for (rowIdx = 0; rowIdx < rowCols.length; rowIdx++) {
        var rowInfo = rowCols[rowIdx];
        gridData.push([]);
        for (colIdx = 0; colIdx < rowInfo.length; colIdx++) {
        	var colInfo = rowInfo[colIdx];
        	if(colInfo['col_seq']) {
        		gridData[rowIdx].push($.extend(true, {
                    x: xpos,
                    y: ypos,
                    width: colInfo['is_rownum'] ? rowNumWidth : width,
                    height: height
                }, colInfo))	
        	}
        	if(colInfo['is_rownum']) {
        		xpos += rowNumWidth + margin;	
        	} else {
        		xpos += width + margin;
        	}
        }
        totalwidth = xpos;
        xpos = 1;
        ypos += height + margin; 
    }
    totalheight = ypos;
	
    rtnData['totalwidth'] = totalwidth;
    rtnData['totalheight'] = totalheight;
    rtnData['gridData'] = gridData;
    
    return rtnData; 
}

/**
 * 추모동산 배정현황 그리드 생성
 */
function makeGraveGrid(grid, gridData) {
	d3.select("svg").remove();
	var totalwidth = gridData.totalwidth;
	var totalheight = gridData.totalheight;
	var grid = d3.select(grid)
		.append("svg")
		.attr("width",totalwidth)
		.attr("height",totalheight);
		
	var row = grid.selectAll(".row")
		.data(gridData.gridData)
		.enter().append("g")
		.attr("class", "row");
		
	var column = row.selectAll(".square")
		.data(function(d) { return d; })
		.enter().append("rect")
		.attr("class","square")
		.attr("x", function(d) { return d.x; })
		.attr("y", function(d) { return d.y; })
		.attr("width", function(d) { return d.width; })
		.attr("height", function(d) { return d.height; })
		.style("fill", function(d) {
			return getRectFillColor(d);
		})
		.style("stroke", "#999")
		.style("stroke-width", function(d) {
			if(d.is_rownum) {
	    		return 0;
			} else {
				return 1;	
			}
		});
	
	var txt = row.selectAll("text")
	.data(function(d) { return d; })
	.enter().append("text")
	.attr("x", function(d) { return d.x + d.width/2; })
	.attr("y", function(d) { return d.y + d.height/2 + 3; })
    .attr("font-size", function(d) {
    	if(d.is_rownum) {
    		return "10px";
		} else {
			return "9px";
		}
	})
    .attr("fill", function(d) {
    	var assignedInfo = getAssignedGraveInfo();
    	var sectionSeq = assignedInfo['sectionSeq'];
    	var rowSeq = assignedInfo['rowSeq'];
    	var colSeq = assignedInfo['colSeq'];
    	if(d.is_rownum) {
    		return "#fff";
		} else if(d.section_seq == sectionSeq && d.row_seq == rowSeq && d.col_seq == colSeq) {
			return "#fff";
		} else {
			return "#999";	
		}
    })
	.text(function(d) {
		if(d.is_rownum) {
			return d.row_seq;
		} else {
			return seqToAlpha(d.col_seq);	
		}
	})
	.style("text-anchor", function(d) {
		if(d.is_rownum) {
			return "middle";
		} else {
			return "middle";
		}
	});
	
}

/**
 * 
 */
function getRectFillColor(d) {
	var assignedInfo = getAssignedGraveInfo();
	var sectionSeq = assignedInfo['sectionSeq'];
	var rowSeq = assignedInfo['rowSeq'];
	var colSeq = assignedInfo['colSeq'];
	if(d.section_seq == sectionSeq && d.row_seq == rowSeq && d.col_seq == colSeq) {// 배정구역
		return "#007BFF";
	} else if(d.is_rownum){// 행번호
		return "#92D050";
	} else if(d.assign_status != 'AVAILABLE') {// 사용중
		return "#BFBFBF";
	} else {
		return "#fff";
	}
}

/**
 * 배정된 추모동산 구역 정보를 반환
 */
function getAssignedGraveInfo() {
	var sectionSeq, rowSeq, colSeq, seqNo;
	// 부부형, 가족형 사용자로 이미 배정된 자리가 있는경우
	if($('#assignedSectionSeq').val()) {
		sectionSeq = $('#assignedSectionSeq').val();
		rowSeq = $('#assignedRowSeq').val();
		colSeq = $('#assignedColSeq').val();
		seqNo = $('#assignedSeqNo').val();
	} else {// 구역을 선택한경우
		var selectedOption = $('#selGraveSection').find('option:selected');
		sectionSeq = selectedOption.val();
		rowSeq = selectedOption.attr('rowSeq');
		colSeq = selectedOption.attr('colSeq');
		seqNo = selectedOption.attr('seqNo');
	}
	var assignedInfo = {};
	assignedInfo['sectionSeq'] = sectionSeq;
	assignedInfo['rowSeq'] = rowSeq;
	assignedInfo['colSeq'] = colSeq;
	assignedInfo['seqNo'] = seqNo;
	return assignedInfo;
}

/**
 * 
 */
function showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo) {
	if(sectionSeq) {
		var detailGraveInfo = sectionSeq + '구역';
		detailGraveInfo += '  ' + (rowSeq ? rowSeq : '') + '행 - ' + seqToAlpha(colSeq) + '열 (고유번호 : ' + (seqNo ? seqNo : '') + ')';
		$('#aDetailGraveInfo').text(detailGraveInfo);	
	}
}

/**
 * 
 */
function _request() {
	var sectionSeq = '', rowSeq = 0, colSeq = 0, isReserved = 0, seqNo = '';
	var assignedSectionSeq = $('#assignedSectionSeq').val();
	if(assignedSectionSeq) {
		isReserved = 1;
		sectionSeq = assignedSectionSeq;
		rowSeq = $('#assignedRowSeq').val();
		colSeq = $('#assignedColSeq').val();
		seqNo = $('#assignedSeqNo').val();
	}else {
		var selectedOption = $('#selGraveSection').find('option:selected');
		sectionSeq = selectedOption.val();
		rowSeq = selectedOption.attr('rowSeq');
		colSeq = selectedOption.attr('colSeq');
		seqNo = selectedOption.attr('seqNo');
	}
	
	var data = {};
	data.productType = '${bunyangInfo.product_type}';
	data.bunyangSeq = '${bunyangInfo.bunyang_seq}';
	data.coupleSeq = $('#coupleSeq').val() ? $('#coupleSeq').val() : 0;
	data.userSeq = $('#userSeq').val();
	data.sectionSeq = sectionSeq;
	data.rowSeq = rowSeq;
	data.colSeq = colSeq;
	data.isReserved = isReserved;
	
	common.ajax({
		//url:"${contextPath}/mobile/assignGrave", 
		url:"${contextPath}/mobile/saveRequestGrave", 
		data:data,
		success: function(result) {
			if(result && result.result) {
				common.showAlert('신청되었습니다.\n부고 알림 메세지 전송 페이지로 이동합니다.');
				$('input[name="bunyangSeq"]').val('${bunyangInfo.bunyang_seq}');
				$('input[name="userId"]').val('${useUserInfo.user_id}');
				$('input[name="sectionSeq"]').val(sectionSeq);
				$('input[name="seqNo"]').val(seqNo);
				var frm = document.getElementById("frm");
				frm.action = "${contextPath}/mobile/registFuneralInfo";
				frm.submit();
			} else {
				common.showAlert('저장에 실패하였습니다.');
			}
		}
	});
}

/**
 * 
 */
function _cancel() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
}

/**
 * 
 */
function seqToAlpha(seq) {
	var seqOfA = "A".charCodeAt(0) + (seq-1);
	var alpha = String.fromCharCode(seqOfA);
	return alpha;
}

/**
 * 로그아웃처리
 */
function _logout() {
	common.ajax({
		url:"${contextPath}/account/mobile/logout", 
		data:{},
		success: function(result) {
			if(result) {
				location.replace('${contextPath}/account/mobile/login');
			}
		}
	});
}

</script>
</c:otherwise>
</c:choose>



