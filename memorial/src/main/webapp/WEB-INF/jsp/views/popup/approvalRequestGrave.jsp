<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
.grid-text {
    pointer-events: none;
}
</style>
<div class="poptitle">
	<strong>사용(봉안) 신청 승인</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content">

	<div style="padding: 10px 10px;">
		<div class="table-responsive">
	        <table id="tblRequestInfo" class="table table-style table-bordered">
	        	<colgroup>
	        		<col width="25%">
	        		<col width="25%">
	        		<col width="25%">
	        		<c:if test="${fn:length(changeGraveList) > 1}">
	        		<col width="25%">
	        		</c:if>
	        		<col width="25%">
	        	</colgroup>
	            <thead>
	                <tr>
	                    <th scope="col">사용(봉안)자</th>
	                    <th scope="col">신청위치</th>
	                    <th scope="col">승인위치</th>
	                    <c:if test="${fn:length(changeGraveList) > 1}">
	                    <th scope="col">가족형<br>위치변경</th>
	                    </c:if>
	                    <th scope="col">비고</th>
	                </tr>
	            </thead>
	            <tbody>
	            <c:forEach items="${approvalGraveList}" var="rowItem" varStatus="status">
					<tr 
						assignStatus="${rowItem.assign_status}" 
						groupSeq="${rowItem.group_seq}" 
						bunyangSeq="${rowItem.bunyang_seq}" 
						graveType="${rowItem.grave_type}" 
						sectionSeq="${rowItem.section_seq}" 
						rowSeq="${rowItem.row_seq}" 
						colSeq="${rowItem.col_seq}"
						useUserSeq1="${rowItem.use_user_seq1}"
						useUserSeq2="${rowItem.use_user_seq2}"
						>
						<td>
						<c:choose>
							<c:when test="${rowItem.bunyang_seq eq bunyangSeq && (rowItem.use_user_seq1 eq userSeq || rowItem.use_user_seq2 eq userSeq || rowItem.use_user_seq eq userSeq) }">
							${requestUserInfo.user_name}
							</c:when>
							<c:otherwise>
							가족
							</c:otherwise>
						</c:choose>
	                    </td>
	                    <td>${rowItem.grave_exp}</td>
	                    <td name="tdApproval" sectionSeq="${rowItem.section_seq}" rowSeq="${rowItem.row_seq}" colSeq="${rowItem.col_seq}"><span name="approvalInfo">${rowItem.grave_exp}</span>
	                    </td>
	                    <c:if test="${fn:length(changeGraveList) > 1}">
	                    <!-- 신규 신청이고 가족형 예약자리가 있는 경우만 -->
	                    <td>
	                    	<c:if test="${rowItem.use_user_seq1 eq userSeq }">
	                    		<select id="selChangeGrave" onchange="changeGrave()">
			                    	<c:forEach items="${changeGraveList}" var="rowItem2" varStatus="status2">
			                    		<option sectionSeq="${rowItem2.section_seq}" rowSeq="${rowItem2.row_seq}" colSeq="${rowItem2.col_seq}">${rowItem2.grave_exp}</option>
			                    	</c:forEach>
			                    </select>
	                    	</c:if>
	                    </td>
	                    </c:if>
	                    <td>
	                    <c:choose>
							<c:when test="${rowItem.bunyang_seq eq bunyangSeq && (rowItem.use_user_seq1 eq userSeq || rowItem.use_user_seq2 eq userSeq || rowItem.use_user_seq eq userSeq) }">
								
							</c:when>
							<c:otherwise>
							가족형예약
							</c:otherwise>
						</c:choose>
	                    </td>
					</tr>
				</c:forEach>
	            </tbody>
	        </table>
	    </div>
	    <div class="text-center" style="margin-top: 5px;">
	        <button type="button" class="btn btn-primary btn-lg" onclick="_confirm()">승인</button>
	        <button type="button" class="btn btn-default btn-lg btnClose">닫기</button>
	    </div>
	</div>
	
	<div id="divGrave" style="background-color: #E0EFFC; padding: 10px 10px;">
		<div style="text-align: center; margin-top: 5px;">
			<div style="width: 10px; height: 10px; background-color: #BFBFBF; display: inline-block;">
			</div>
			<span>사용중</span>
			<div style="width: 10px; height: 10px; background-color: #007BFF; display: inline-block; margin-left: 10px;">
			</div>
			<span>신청위치</span>
			<div style="width: 10px; height: 10px; background-color: #47CCCA; display: inline-block; margin-left: 10px;">
			</div>
			<span>가족형예약</span>
		</div>
		
		<div style="text-align: center; margin-top: 10px;">
			<div id="grid1" class="grid" style="display: inline-block;">
				<p style="margin-bottom: 5px; font-size: 15px;">가구역</p>
			</div>
			<div id="grid2" class="grid" style="display: inline-block; margin-left: 28px;">
				<p style="margin-bottom: 5px; font-size: 15px;">나구역</p>
			</div>
		</div>
		<div style="text-align: center; margin-top: 5px;">
			<div id="grid3" class="grid" style="display: inline-block;">
				<p style="margin-bottom: 5px; font-size: 15px;">다구역</p>
			</div>
			<div id="grid4" class="grid" style="display: inline-block; margin-left: 28px;">
				<p style="margin-bottom: 5px; font-size: 15px;">라구역</p>
			</div>
		</div>
	</div>
    
</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">
(function() {
	
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
		
	common.ajax({
		url:"${contextPath}/admin/getGraveUseList", 
		data:{},
		success: function(result) {
			var sectionArr = getSectionArrayData(result);
			var idx = 0;
			var sectionData1, sectionData2, sectionData3, sectionData4;
			var gridData1, gridData2, gridData3, gridData4;
			 if(sectionArr) {
				 if(sectionArr.length > idx) {
					 sectionData1 = sectionArr[idx++];
				 }
				 if(sectionArr.length > idx) {
					 sectionData2 = sectionArr[idx++];
				 }
				 if(sectionArr.length > idx) {
					 sectionData3 = sectionArr[idx++];
				 }
				 if(sectionArr.length > idx) {
					 sectionData4 = sectionArr[idx++];
				 }
			 }
			 if(sectionData1 != null && sectionData1.length > 0) {
				 gridData1 = getGridData(sectionData1, false, 2, 20);
				 gridData1.totalwidth = 290;
				 makeGraveGrid('#grid1', gridData1);
			 }
			 if(sectionData2 != null && sectionData2.length > 0) {
				 gridData2 = getGridData(sectionData2, false, 0, 20);
				 gridData2.totalwidth = 387;
				 makeGraveGrid('#grid2', gridData2);
			 }
			 if(sectionData3 != null && sectionData3.length > 0) {
				 gridData3 = getGridData(sectionData3, false, 0, 20);
				 makeGraveGrid('#grid3', gridData3);
			 }
			 if(sectionData4 != null && sectionData4.length > 0) {
				 gridData4 = getGridData(sectionData4);
				 makeGraveGrid('#grid4', gridData4);
			 }
		}
	});
})();

/**
 * 전체 데이터를 section 별 배열로 구성하여 반환
 */
function getSectionArrayData(data) {
	var rtn = [];
	if(data != null) {
		var sections = [];
		$.each(data, function(idx){
			var section = data[idx]['section_seq'];
			if(sections.indexOf(section) < 0 ) {
				sections.push(section);
				rtn.push([]);
			}
			var lastIdx = rtn.length - 1;
			rtn[lastIdx].push(data[idx]);
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
		// 전체 신청건중에서 본페이지 신청건에 대한 데이터만 
		if(item.assign_status == 'REQUESTED' && isRequestedItem(item.section_seq, row_seq, col_seq)) {
			item.assign_status = 'REAL_REQUESTED';
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
    var rowNumWidth = 20;
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
 * 이전에 클릭한 square 클릭상태 해제를 위해 저장해둠
 */
var clickedInfo = {};

/**
 * 추모동산 배정현황 그리드 생성
 */
function makeGraveGrid(grid, gridData) {
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
		.attr("assign_status",function(d) {return d.assign_status})
		.attr("id",function(d) {return 'square' + d.section_seq + '_' + d.row_seq + '_' + d.col_seq})
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
		})
		.on('mouseover', function(d) {
			if(_clickable(this, d)) {
				setSelectedStyleAll(this, true);
	       }
	    })
	    .on('mouseout', function(d) {
	    	if(_clickable(this, d)) {
	    		setSelectedStyleAll(this, false);
	       }
	    })
		.on('click', function(d) {
			if(_clickable(this, d)) {
				var assignStatus = $('#tblRequestInfo tbody tr').eq(0).attr('assignStatus');
				if(assignStatus == 'HALF_OCCUPIED') {
					common.showAlert('배우자가 이미 사용(봉안)중인 부부형의 자리는 변경이 불가합니다.');
					return;
				}else if(assignStatus == 'RESERVED') {
					common.showAlert('가족형으로 이미 배정된 자리는 변경이 불가합니다.');
					return;
				} else {
					clearSelectedGrave();
					setSelectedStyleAll(this, true, true);	
				}
			}
	    });
	
	var txt = row.selectAll("text")
	.data(function(d) { return d; })
	.enter().append("text")
	.attr("class","squaretxt")
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
    	return getTextFillColor(d);
    })
    .attr("id",function(d) {return 'txt' + d.section_seq + '_' + d.row_seq + '_' + d.col_seq})
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
	})
	.style("cursor", "pointer")
	.attr("class", "grid-text")
	;
	
}

/**
 * 
 */
function getRectFillColor(d) {
	if(d.is_rownum) {
		return "#92D050";
	} else {
		if(d.assign_status == 'OCCUPIED') {
			return "#BFBFBF";
		} else if(d.assign_status == 'HALF_OCCUPIED') {
			if(d.bunyang_seq == '${bunyangSeq}' && d.couple_seq == '${coupleSeq}') {// 신청자리
				return "#007BFF";	
			} else {
				return "#BFBFBF";	
			}
		} else if(d.assign_status == 'RESERVED') {
			var tr = $('#tblRequestInfo tbody tr').eq(0);
			var assignStatus = tr.attr('assignStatus');
			if(assignStatus == 'RESERVED' && isRequestedItem(d.section_seq, d.row_seq, d.col_seq)) {
				return "#007BFF";	
			} else {
				if((!d.group_seq && d.bunyang_seq == '${bunyangSeq}') || (d.group_seq && d.group_seq == '${bunyangInfo.group_seq}')) {// 가족형예약
					return "#47CCCA";
				} else {
					return "#BFBFBF";	
				}	
			}
		} else if(d.assign_status == 'REQUESTED') {
			return "#BFBFBF";
		} else if(d.assign_status == 'REAL_REQUESTED') {
			if(d.use_user_seq1 == '${userSeq}' || d.use_user_seq2 == '${userSeq}') {// 신청자리
				return "#007BFF";	
			} else {// 가족형예약
				if(getRequestGraveCount() > 1) {
					return "#47CCCA";	
				}	
			}
		} else if(d.assign_status == 'APPROVAL') {
			return "#007BFF";
		} else if(d.assign_status == 'APPROVAL_RESERVED') {
			return "#47CCCA";
		} else{
			return "#ffffff";
		}
	}
}

/**
 * 
 */
function getTextFillColor(d) {
	if(d.is_rownum) {
		return "#fff";
	} else {
		if(d.assign_status == 'AVAILABLE') {
			return "#999";
		} else {
			return "#fff";
		}
	}
}

/**
 * 
 */
function setSelectedStyleAll(el, selected, changeStatus) {
	var cnt = getRequestGraveCount();
	var bStart = false;
	var selectedCnt = 0;
	var selChangeGraveOptions = [];
	d3.select(el.parentNode).selectAll('.square').each(function(d, i) {
		if(this == el) {
			bStart = true;
		}
		if(bStart && selectedCnt < cnt) {
			if(selected && changeStatus) {
				var sectionSeq = d.section_seq;
				var rowSeq = d.row_seq;
				var colSeq = d.col_seq;
				var exp = sectionSeq + '구역 ' + rowSeq + '행-' + seqToAlpha(colSeq) + '열';
				$('span[name="approvalInfo"]').eq(selectedCnt).text(exp);
				var td = $('td[name="tdApproval"]').eq(selectedCnt);
				td.attr('sectionSeq', sectionSeq);
				td.attr('rowSeq', rowSeq);
				td.attr('colSeq', colSeq);
				if(selectedCnt == 0) {
					d.assign_status = 'APPROVAL';
				} else {
					d.assign_status = 'APPROVAL_RESERVED';	
				}
				selChangeGraveOptions.push('<option sectionSeq="' + sectionSeq + '" rowSeq="' + rowSeq + '" colSeq="' + colSeq + '">' + exp + '</option>');
			}
			setSelectedStyle(this, selected, d, selectedCnt > 0 ? '#47CCCA' : null);
			selectedCnt++;
		}
	});
	if($('#selChangeGrave').length > 0 && selChangeGraveOptions.length > 0) {
		$('#selChangeGrave').html(selChangeGraveOptions.join(''));
	}
}

/**
 * 
 */
function setSelectedStyle(el, selected, d, color) {
	var txt = $('#' + $(el).attr('id').replace('square', 'txt'));
	if(selected) {
		var selectedColor = color ? color : "#007BFF";
		d3.select(el).style("cursor", "pointer");
		d3.select(el).style("fill", selectedColor);
		txt.attr("fill", "#fff");	
	} else {
		d3.select(el).style("cursor", "default"); 
		d3.select(el).style("fill", getRectFillColor(d)); 
		txt.attr("fill", getTextFillColor(d));	
	}
}

/**
 * 
 */
function _clickable(el, d) {
	var bRtn = isAssignable(d.assign_status);
	if(bRtn) {
		var requestGraveType = getRequestGraveType();
		var requestGraveCount = getRequestGraveCount();
		if(d.grave_type == requestGraveType){
			var nextEl = el;
			var availableCount = 0;
			for(var i = 0; i < requestGraveCount; i++) {
				if(!nextEl || nextEl.length == 0) {
					break;
				}
				if(isAssignable($(nextEl).attr('assign_status'))) {
					availableCount++;
				}
				nextEl = $(nextEl).next();
			}
			if(availableCount == requestGraveCount) {
				bRtn = true;
			} else {
				bRtn = false;
			}
		} else {
			bRtn = false;
		}
	}
	return bRtn;
}

/**
 * 
 */
function isAssignable(status) {
	if(status == 'AVAILABLE' || status == 'REAL_REQUESTED' || status == 'APPROVAL' || status == 'APPROVAL_RESERVED') {
		return true;
	}
	return false;
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
 * 
 */
function getRequestGraveType() {
	var sRtn = $('#tblRequestInfo tbody tr').eq(0).attr('graveType');
	return sRtn;
}

/**
 * 
 */
function getRequestGraveCount() {
	var rtn = $('#tblRequestInfo tbody tr').length;
	return rtn;
}

/**
 * 
 */
function isRequestedItem(section_seq, row_seq, col_seq) {
	var exists = false;
	$('#tblRequestInfo tbody tr').each(function(idx) {
		if(${isReserved} == 1 && idx > 0) {
			exists = false;
			return false;
		}else {
			if($(this).attr('sectionSeq') == section_seq
					&& $(this).attr('rowSeq') == row_seq
					&& $(this).attr('colSeq') == col_seq) {
				exists = true;
				return false;
			}	
		}
	});
	return exists;
}

/**
 * 
 */
function clearSelectedGrave() {
	d3.select('#divGrave').selectAll('.square').each(function(d, i) {
		if(d.assign_status == 'REAL_REQUESTED' || d.assign_status == 'APPROVAL' || d.assign_status == 'APPROVAL_RESERVED') {
			d.assign_status = 'AVAILABLE';
			setSelectedStyle(this, false, d);
		}
	});
}

/**
 * 확인
 */
function _confirm() {
	var tr = $('#tblRequestInfo tbody tr').eq(0);
	var assignStatus = tr.attr('assignStatus');
	var approvalGraveVo = {};
	approvalGraveVo.assignStatus = assignStatus;
	approvalGraveVo.bunyangSeq = '${bunyangSeq}';
	approvalGraveVo.userSeq = '${userSeq}';
	approvalGraveVo.coupleSeq = '${coupleSeq}';
	var requestGraveList = [];
	var approvalGraveList = [];
	var graveInfoVo;
	$('#tblRequestInfo tbody tr').each(function(idx) {
		// 신청자리
		graveInfoVo = {};
		graveInfoVo.groupSeq = $(this).attr('groupSeq');
		graveInfoVo.bunyangSeq = $(this).attr('bunyangSeq');
		graveInfoVo.sectionSeq = $(this).attr('sectionSeq');
		graveInfoVo.rowSeq = $(this).attr('rowSeq');
		graveInfoVo.colSeq = $(this).attr('colSeq');
		graveInfoVo.useUserSeq1 = $(this).attr('useUserSeq1');
		graveInfoVo.useUserSeq2 = $(this).attr('useUserSeq2');
		requestGraveList.push(graveInfoVo);
		// 승인자리
		var tdApproval = $(this).find('td[name="tdApproval"]');
		graveInfoVo = {};
		graveInfoVo.groupSeq = $(this).attr('groupSeq');
		graveInfoVo.bunyangSeq = $(this).attr('bunyangSeq');
		graveInfoVo.sectionSeq = $(tdApproval).attr('sectionSeq');
		graveInfoVo.rowSeq = $(tdApproval).attr('rowSeq');
		graveInfoVo.colSeq = $(tdApproval).attr('colSeq');
		graveInfoVo.useUserSeq1 = $(this).attr('useUserSeq1');
		graveInfoVo.useUserSeq2 = $(this).attr('useUserSeq2');
		approvalGraveList.push(graveInfoVo);
	});
		// 승인자리
// 		var iTmp = 0;
// 		d3.select('#divGrave').selectAll('.square').each(function(d, i) {
// 			if(d.assign_status == 'REAL_REQUESTED' || d.assign_status == 'APPROVAL' || d.assign_status == 'APPROVAL_RESERVED') {
// 				graveInfoVo = {};
// 				graveInfoVo.groupSeq = requestGraveList[iTmp].groupSeq;
// 				graveInfoVo.bunyangSeq = requestGraveList[iTmp].bunyangSeq;
// 				graveInfoVo.sectionSeq = d.section_seq;
// 				graveInfoVo.rowSeq = d.row_seq;
// 				graveInfoVo.colSeq = d.col_seq;
// 				graveInfoVo.useUserSeq1 = d.use_user_seq1;
// 				graveInfoVo.useUserSeq2 = d.use_user_seq2;
// 				approvalGraveList.push(graveInfoVo);
// 				iTmp++;
// 			}
// 		});
	
	if(approvalGraveList.length == 0) {
		common.showAlert('승인할 동산정보가 없습니다.');
		return;
	}
	
	approvalGraveVo.requestGraveList = requestGraveList;
	approvalGraveVo.approvalGraveList = approvalGraveList;
	
	common.ajax({
		url:"${contextPath}/popup/saveApprovalRequestGrave", 
		data:JSON.stringify(approvalGraveVo),
		contentType: 'application/json',
		success: function(result) {
			if(result.result) {
				common.showAlert('승인되었습니다.');
				if (window.opener && window.opener.approvalGraveCallBack != 'undefined') {
			        window.opener.approvalGraveCallBack(true);
			    }
				common.closeWindow();
    		} else {
    			if(result.errorCode == 1) {
    				common.showAlert('이미 승인된 사용자입니다.');
    			} else {
    				common.showAlert('승인처리에 실패하였습니다.');
    			}
    		}
		},
		error: function(xhr, status, message) {
			common.showAlert('승인시 에러가 발생하였습니다.');
		}
	});
    
}

/** 
 * 가족형 구역내 자리 변경 처리
 */
function changeGrave(e) {
	var selectedOption = $('#selChangeGrave').find('option:selected');
	var sectionSeq = $(selectedOption).attr('sectionSeq');
	var rowSeq = $(selectedOption).attr('rowSeq');
	var colSeq = $(selectedOption).attr('colSeq');
	var notSelectedOptions = [];
	$('#selChangeGrave option').each(function(idx) {
		if(!$(this).is(':selected')) {
			notSelectedOptions.push($(this));
		}
	});
	notSelectedOptions.sort(function(a, b) {
		return $(a).attr('colSeq') < $(b).attr('colSeq') ? -1 : $(a).attr('colSeq') > $(b).attr('colSeq') ? 1 : 0;
	});
	
	clearSelectedGrave();
	
	var idx = 0;
	$('#tblRequestInfo tbody tr').each(function() {
		var option;
		if($(this).attr('bunyangSeq') == '${bunyangSeq}' && $(this).attr('useUserSeq1') == '${userSeq}') {
			option = $(selectedOption);
		}else {
			option = $(notSelectedOptions[idx++]);
		}
		if(option) {
			$(this).find('span[name="approvalInfo"]').text(option.text());
			var sectionSeq = option.attr('sectionSeq');
			var rowSeq = option.attr('rowSeq');
			var colSeq = option.attr('colSeq');
			var td = $(this).find('td[name="tdApproval"]');
			td.attr('sectionSeq', sectionSeq);
			td.attr('rowSeq', rowSeq);
			td.attr('colSeq', colSeq);
		}
	});
	$('#selChangeGrave option').each(function(idx) {
		var sectionSeq = $(this).attr('sectionSeq');
		var rowSeq = $(this).attr('rowSeq');
		var colSeq = $(this).attr('colSeq');
		var selected = $(this).is(':selected');
		d3.select('#divGrave').selectAll('.square').each(function(d, i) {
			if(d.section_seq == sectionSeq && d.row_seq == rowSeq && d.col_seq == colSeq) {
				if(selected) {
					d.assign_status = 'APPROVAL';
				} else {
					d.assign_status = 'APPROVAL_RESERVED';
				}
				setSelectedStyle(this, true, d, !selected ? '#47CCCA' : null);
			}
		});
	});
	
}

</script>