<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.grid-text {
    pointer-events: none;
}
</style>

<form id="frm" method="post">
	<input type="hidden" id="group_seq" name="group_seq">
	<input type="hidden" id="bunyang_seq" name="bunyang_seq">
	<input type="hidden" id="sectionSeq" name="sectionSeq">
	<input type="hidden" id="rowSeq" name="rowSeq">
	<input type="hidden" id="colSeq" name="colSeq">
</form>

<!-- 그리드 샘플 -->
<div class="col-md-9">
	
	<div style="background-color: #E0EFFC; padding: 10px 10px;">
		<div style="text-align: center;">
			<c:choose>
				<c:when test="${step eq 1 }">
				<h3 style="display: inline-block; color: #007BFF;">Step1. 위치를 변경할 동산 정보를 선택하세요.</h3>
				</c:when>
				<c:when test="${step eq 2 }">
				<h3 style="display: inline-block; color: #007BFF;">Step2. 변경하고자 하는 위치를 선택하세요.</h3>
				</c:when>
			</c:choose>
		</div>
		
		<div style="text-align: center; margin-top: 5px;">
			<div style="width: 10px; height: 10px; background-color: #C785C8; display: inline-block;">
			</div>
			<span>사용중</span>
			<div style="width: 10px; height: 10px; background-color: #fff; display: inline-block; margin-left: 10px; border: 1px solid #ccc;">
			</div>
			<span>사용가능</span>
			<div style="width: 10px; height: 10px; background-color: #007BFF; display: inline-block; margin-left: 10px;">
			</div>
			<span>선택한 위치</span>
			<c:choose>
				<c:when test="${step eq 2 }">
				<div style="width: 10px; height: 10px; background-color: #47CCCA; display: inline-block; margin-left: 10px;">
				</div>
				<span>변경할 위치</span>
				</c:when>
			</c:choose>
		</div>
		
		<c:if test="${step eq 999 }">
		<!--  사용자 검색 -->
		<div class="row" style="margin-top: 10px;">
			<div class="col-xs-3" style="margin: 0 auto; float: none;">
				<div class="input-group add-on">
      				<input class="form-control" placeholder="사용(봉안)자 검색" id="tiSearchUser" type="text">
      				<div class="input-group-btn">
        				<button class="btn btn-default" type="button" onclick="searchUser()"><i class="glyphicon glyphicon-search"></i></button>
      				</div>
    			</div>
			</div>
		</div>
		</c:if>
		
		<div style="text-align: center; margin-top: 10px;">
			<div id="grid1" style="display: inline-block;">
				<p style="margin-bottom: 5px; font-size: 15px;">가구역</p>
			</div>
			<div id="grid2" style="display: inline-block; margin-left: 28px;">
				<p style="margin-bottom: 5px; font-size: 15px;">나구역</p>
			</div>
		</div>
		<div style="text-align: center; margin-top: 5px;">
			<div id="grid3" style="display: inline-block;">
				<p style="margin-bottom: 5px; font-size: 15px;">다구역</p>
			</div>
			<div id="grid4" style="display: inline-block; margin-left: 28px;">
				<p style="margin-bottom: 5px; font-size: 15px;">라구역</p>
			</div>
		</div>
	</div>
	
	<div>
    	<div>
    		<c:choose>
				<c:when test="${step eq 1 }">
				<div class="pull-left"><h4 style="display: inline-block;">선택한 동산 정보</h4></div>
				</c:when>
				<c:when test="${step eq 2 }">
				<div class="pull-left"><h4 style="display: inline-block;">변경할 동산 정보</h4></div>
				</c:when>
			</c:choose>
	    </div>
	    <div class="clearfix"></div>
	    <div class="table-responsive">
	        <table id="tblModifyInfo" class="table table-style table-bordered">
	        	<colgroup>
	        		<col width="*">
	        		<col width="*">
	        		<col width="*">
	        		<col width="*">
	        		<col width="220">
	        		<col width="220">
	        	</colgroup>
	            <thead>
	                <tr>
	                    <th scope="col">계약번호</th>
	                    <th scope="col">계약자</th>
	                    <th scope="col">장묘형태</th>
	                    <th scope="col">사용자</th>
	                    <th scope="col">선택한 위치</th>
	                    <th scope="col">변경할 위치</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
	            		<c:when test="${step eq 1 }">
	            		<tr class="nodata">
	            			<td colspan="6" style="color: #888; font-size: 14px; padding: 15px 10px;">※ 위치를 변경할 동산 정보를 선택하세요.</td>
	            		</tr>
	            		</c:when>
	            		<c:when test="${step eq 2}">
	            		<c:forEach var="row" items="${graveAssignList }">
	            		<tr>
	            			<td>${cutil:nullToEmpty(row.bunyang_no) }</td>
	            			<td>${cutil:nullToEmpty(row.apply_user_name) }</td>
	            			<td>
	            				<c:choose>
	            					<c:when test="${row.grave_type eq 'COUPLE' }">부부형</c:when>
	            					<c:when test="${row.grave_type eq 'SINGLE' }">1인형</c:when>
	            				</c:choose>
	            			</td>
	            			<td>${cutil:nullToEmpty(row.user_name) }</td>
	            			<td>
	            				<div style="width: 10px; height: 10px; background-color: #007BFF; display: inline-block; margin-left: 10px;"></div>
	            				${cutil:getGraveSectionExp(row.section_seq, row.row_seq, row.col_seq, row.seq_no) }
	            			</td>
	            			<td 
	            				name="modifyGraveInfo"
	            				group_seq="${row.group_seq }"
	            				bunyang_seq="${row.bunyang_seq }"
	            				selected_section_seq="${row.section_seq }"
	            				selected_row_seq="${row.row_seq }"
	            				selected_col_seq="${row.col_seq }"
	            				>
	            			</td>
	            		</tr>
	            		</c:forEach>
	            		</c:when>
	            	</c:choose>
	            </tbody>
	        </table>
	    </div>
    </div>
    
    <div class="mt-30 text-center">
    	<c:if test="${step eq 1 }">
    	<button id="btnNext" type="button" class="btn btn-primary btn-lg" style="width: 120px;" disabled="disabled" onclick="_next()">다음단계</button>
    	</c:if>
    	<c:if test="${step eq 2 }">
    	<button id="btnSave" type="button" class="btn btn-primary btn-lg" style="width: 120px;" disabled="disabled" onclick="_save()">저장</button>
    	<button type="button" class="btn btn-default btn-lg" style="width: 120px; margin-left: 5px;" onclick="_prev()">이전단계</button>
    	</c:if>
        <button type="button" class="btn btn-default btn-lg" style="width: 120px; margin-left: 5px;" onclick="goToList()">취소</button>
    </div>
	
</div>
<div id="dummyDiv"></div>
<form id="frm" method="post">
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">
(function(){
	
	// gradient for rectangle half fill  
	var svg = d3.select("#dummyDiv")
    .append("svg")
    .attr("width",0)
    .attr("height",0);
	
	var grad = svg.append("defs")
    .append("linearGradient").attr("id", "grad")
    .attr("x1", "0%").attr("x2", "100%").attr("y1", "0%").attr("y2", "0%");

  	grad.append("stop").attr("offset", "50%").style("stop-color", "#C785C8");
  	grad.append("stop").attr("offset", "50%").style("stop-color", "#47CCCA");
	
	// add for programmatically d3 click event
	$.fn.d3Click = function () {
		this.each(function (i, e) {
			//var evt = new MouseEvent("click");
			var evt = document.createEvent("MouseEvent");
			evt.initMouseEvent("click",true,true,window,0,0,0,0,0,false,false,false,false,0,null);
			e.dispatchEvent(evt);
		});
	};
	// 사용(봉안)자 검색
	$('#tiSearchUser').keyup(function(e) {
		if (e.keyCode == 13) {
			searchUser();
		}
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
 * 이전에 클릭한 클릭상태 해제를 위해 저장해둠
 */
var clickedInfo = null;

var selectedGraves = [];

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
		.attr("grave_type",function(d) {return d.grave_type})
		.attr("assign_status",function(d) {return d.assign_status})
		.attr("id",function(d) {return 'square' + d.section_seq + '_' + d.row_seq + '_' + d.col_seq})
		.attr("x", function(d) { return d.x; })
		.attr("y", function(d) { return d.y; })
		.attr("width", function(d) { return d.width; })
		.attr("height", function(d) { return d.height; })
		.attr("class",function(d) {
			// Step1에서 선택된 위치인지 판단을 위해 class명을 selectedSquare 로 설정해줌
			if(getCurrentStep() == 2) {
				var selectedGrave = false;
				if('${group_seq}') {
					if(d.group_seq == '${group_seq}') {
						selectedGrave = true;
					}
				} else if('${bunyang_seq}') {
					if(d.bunyang_seq == '${bunyang_seq}') {
						selectedGrave = true;
					}
				} else {
					if(d.section_seq == '${sectionSeq}'
							&& d.row_seq == '${rowSeq}'
							&& d.col_seq == '${colSeq}'
							) {
						selectedGrave = true;
					}
				}
				if(selectedGrave) {
					// element 참조를 위해 저장
					selectedGraves.push(this);
					// getRectFillColor 에서 스타일설정을 위해 데이터에 값 설정해줌
					d.selectedGrave = true;
					return "square selectedSquare";
				} else {
					return "square";
				}
			}else {
				return "square";
			}
		})
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
				setSelectedAll(this, true, d);
	       }
	    })
	    .on('mouseout', function(d) {
	    	if(_clickable(this, d)) {
	    		setSelectedAll(this, false, d);
	       }
	    })
		.on('click', function(d) {
			if(_clickable(this, d)) {
				if(clickedInfo) {
					for(var key in clickedInfo) {
						setSelected(clickedInfo[key]['el'], false, clickedInfo[key]['data'], true);
					}
					clickedInfo = {};
				}
				setSelectedAll(this, true, d, true);
				if(getCurrentStep() == 1) {
					getGraveAssignInfo(d);	
				} else if(getCurrentStep() == 2) {
					setModifyGraveInfo(this);
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
	if(d.selectedGrave == true) {// Step1에서 선택된 데이터에만 Step2 넘어오면서 true 값이 설정됨
		return "#007BFF";
	}else if(d.assign_status == 'OCCUPIED') {
		return "#C785C8";
	} else if(d.assign_status == 'HALF_OCCUPIED') {
		return "#C785C8";
	} else if(d.assign_status == 'RESERVED' || d.assign_status == 'REQUESTED') {
		return "#C785C8";
	} else if(!d.is_rownum){
		return "#fff";
	} else {
		return "#92D050";
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
function setSelectedAll(el, selected, data, byClick) {
	if(getCurrentStep() == 1) {// Step1
		var group_seq = data.group_seq;
		var bunyang_seq = data.bunyang_seq;
		var connect_product_type = data.connect_product_type;
		// 가족형인 경우 전체 선택
		if(connect_product_type == '<%=CalvaryConstants.PRODUCT_TYPE_FAMILY%>') {
			d3.select(el.parentNode).selectAll('.square').each(function(d, i) {
				if(group_seq) {// 연결된 분양인 경우 group_seq 에 해당하는 구역 전부 선택
					if(d.group_seq == group_seq) {
						setSelected(this, selected, d, byClick);
					}
				} else {// 그외 bunyang_seq 에 해당하는 구역 전부 선택
					if(d.bunyang_seq == bunyang_seq) {
						setSelected(this, selected, d, byClick);
					}
				}
			});
		} else {// 개별형인 경우 해당 구역만 선택상태로
			setSelected(el, selected, data, byClick);
		}
	}else if(getCurrentStep() == 2) {// Step2
		var cnt = selectedGraves.length;
		var bStart = false;
		var selectedCnt = 0;
		// 해당 element ~ Step1에서 선택한 개수만큼 선택상태로
		d3.select(el.parentNode).selectAll('.square').each(function(d, i) {
			if(this == el) {
				bStart = true;
			}
			if(bStart && selectedCnt < cnt) {
				setSelected(this, selected, d, byClick);	
				selectedCnt++;
			}
		});
	}
}

/**
 * 
 */
function setSelected(el, selected, d, byClick) {
	if(byClick) {// click
		$(el).attr('selected', selected);
		if(selected) {
			if(!clickedInfo) {
				clickedInfo = {};
			}
			clickedInfo[$(el).attr('id')] = {el:el, data:d};
		}
		applySelectedStyle(el, selected, d, byClick);
	} else {// hover
		if(selected) {// mouseover
			applySelectedStyle(el, selected, d, byClick);
		} else {// mouseout
			if($(el).attr('selected')) {
				applySelectedStyle(el, true, d, true);
			} else {
				applySelectedStyle(el, selected, d, byClick);
			}
		}
	}
}

/**
 * 
 */
function applySelectedStyle(el, selected, d, byClick) {
	var txt = $('#' + $(el).attr('id').replace('square', 'txt'));
	if(selected) {
		d3.select(el).style("cursor", "pointer");
		if(getCurrentStep() == 1) {
			d3.select(el).style("fill", "#007BFF"); 
		} else {
			d3.select(el).style("fill", byClick ? "#47CCCA" : "#99D3D2");
		}
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
	var bRtn = false;
	if(getCurrentStep() == 1) {// Step1
		// 배정된 동산이면 선택 가능
		if(d && d.bunyang_seq) {
			bRtn = true;
		}	
	}else if(getCurrentStep() == 2) {// Step2
		var selectedGraveType = selectedGraves.length > 0 ? $(selectedGraves[0]).attr('grave_type') : "";
		// 배정되지 않았거나 Step1에서 선택한 위치중 두번째 자리부터는 선택이 가능
		if(selectedGraveType == d.grave_type && (!d.bunyang_seq || isInSelectedGraves($(el)))) {
			var nextEl = el;
			var availableCount = 0;
			var selectedGraveCount = selectedGraves.length;
			// 현재 Element에서부터 연속으로 이용가능한 자리수가 Step1에서 선택한 자리수만큼 있는지 체크
			for(var i = 0; i < selectedGraveCount; i++) {
				if(!nextEl || nextEl.length == 0) {
					break;
				}
				if($(nextEl).attr('assign_status') == 'AVAILABLE' || isInSelectedGraves($(nextEl))) {
					availableCount++;
				}else {
					break;
				}
				nextEl = $(nextEl).next();
			}
			// Step1에서
			if(availableCount == selectedGraveCount) {
				bRtn = true;
			} else {
				bRtn = false;
			}
		}
	}
	return bRtn;
}

/**
 * Step1에서 선택한 위치들중 element 가 포함되는지 확인(첫번째는 제외)
 */
function isInSelectedGraves(el) {
	var bRtn = false;
	for(var i = 0; i < selectedGraves.length; i++) {
		if($(selectedGraves[i]).attr('id') == el.attr('id')) {
			bRtn = true;
			break;
		}
	}
	return bRtn;
}

/**
 * 특정 구역에 배정된 정보 조회
 */
function getGraveAssignInfo(d) {
	var data = {};
	var group_seq = d.group_seq;
	var bunyang_seq = d.bunyang_seq;
	var connect_product_type = d.connect_product_type;
	
	// 가족형인 경우 가족배정 정보 모두 조회
	if(connect_product_type == '<%=CalvaryConstants.PRODUCT_TYPE_FAMILY%>') {
		// 분양 연결 정보가 있는 경우 모든 연결 정보 조회
		if(group_seq) {
			data.group_seq = group_seq;
		} else {
			data.bunyang_seq = bunyang_seq;
		}
	} else {// 개별형인 경우 해당 동산 정보만 조회
		data.sectionSeq = d.section_seq;
		data.rowSeq = d.row_seq;
		data.colSeq = d.col_seq;	
	}
	
	$('#group_seq').val('');
	$('#bunyang_seq').val('');
	$('#sectionSeq').val('');
	$('#rowSeq').val('');
	$('#colSeq').val('');
	$('#tblModifyInfo tbody').html('');
	$('#btnNext').attr('disabled', true);
	
	common.ajax({
		url:"${contextPath}/admin/getGraveAssignInfoByFamily", 
		data:data,
		success: function(result) {
			if(result) {
				var len = result.length;
				$.each(result, function(idx, item){
					var tr = $('<tr/>');
					var bunyang_no = item.bunyang_no ? item.bunyang_no : '';
					var apply_user_name = item.apply_user_name ? item.apply_user_name : '';
					var graveType = item.grave_type == 'COUPLE' ? '부부형' : '1인형';
					var section = item.section_seq + '구역';
					section += '  ' + item.row_seq + '행-' + seqToAlpha(item.col_seq) + '열(고유번호:' + item.seq_no + ')';
					tr.append('<td>'+ bunyang_no +'</td>');
					tr.append('<td>'+ apply_user_name +'</td>');
					tr.append('<td>'+ graveType +'</td>');
					tr.append('<td>'+ (item.user_name ? item.user_name : '') +'</td>');
					tr.append('<td>'+ section +'</td>');
					tr.append('<td></td>');
					$('#tblModifyInfo tbody').append(tr);
				});
				$('html:not(:animated), body:not(:animated)').animate({
		            scrollTop: $("#tblModifyInfo").offset().top
		        }, 1000);
			}
			if($('#tblModifyInfo tbody tr').not('tr.nodata').length > 0) {
				$('#group_seq').val(data.group_seq);
				$('#bunyang_seq').val(data.bunyang_seq);
				$('#sectionSeq').val(data.sectionSeq);
				$('#rowSeq').val(data.rowSeq);
				$('#colSeq').val(data.colSeq);
				$('#btnNext').attr('disabled', false);
			}
		}
	});
}

/** */
function setModifyGraveInfo(el) {
	var idx = 0;
	d3.select(el.parentNode).selectAll('.square').each(function(item, i) {
		if($(this).attr('selected')) {
			var section = item.section_seq + '구역';
			section += '  ' + item.row_seq + '행-' + seqToAlpha(item.col_seq) + '열(고유번호:' + item.seq_no + ')';
			var td = $('#tblModifyInfo tbody tr td[name="modifyGraveInfo"]').eq(idx);
			td.html('<span style="width: 10px; height: 10px; background-color: #47CCCA; display: inline-block; margin-left: 10px;"></span> ' + section);
			td.attr("modify_section_seq", item.section_seq);
			td.attr("modify_row_seq", item.row_seq);
			td.attr("modify_col_seq", item.col_seq);
			idx++;
			$('#btnSave').removeAttr('disabled');
		}
	});
}

var searching = false;

/**
 * 
 */
function searchUser() {
	if(searching) {
		return;
	}
	searching = true;
	var userName = $('#tiSearchUser').val();
	if(!userName) {
		common.showAlert('검색할 사용자명을 입력하세요.');
		$('#tiSearchUser').focus();
		return;
	}
	
	common.ajax({
		url:"${contextPath}/admin/searchGraveUser", 
		data:{userName:userName},
		success: function(result) {
			if(result && result.result) {
				var searchedInfo = result.result;
				var section_seq = searchedInfo.section_seq;
				var row_seq = searchedInfo.row_seq;
				var col_seq = searchedInfo.col_seq;
				var squareId = 'square' + section_seq + '_' + row_seq + '_' + col_seq;
				$('#' + squareId).d3Click();
			} else {
				common.showAlert('해당 이름으로 등록된 사용(봉안)자가 없습니다.');
			}
			searching = false;
		},
		error: function(xhr, status, message) {
			searching = false;
		}
	});
}

function getCurrentStep() {
	return ${step};
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
 * 변경할 동산 선택후 다음 Step 이동
 */
function _next() {
	if($('#tblModifyInfo tbody tr').not('tr.nodata').length > 0) {
		var frm = document.getElementById("frm");
		frm.action = "${contextPath}/admin/modifyGraveNext";
		frm.submit();
	} else {
		common.showAlert('선택된 동산 정보가 없습니다.');
		return;
	}
}

/**
 * 이전단계로
 */
function _prev() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/modifyGrave";
	frm.submit();
}

/**
 * 위치변경 정보 저장
 */
function _save() {
	var frmData = new FormData();
	var bAdded = false;
	var isChanged = false;
	$('#tblModifyInfo tbody tr td[name="modifyGraveInfo"]').each(function(idx) {
		var selected_section_seq = $(this).attr('selected_section_seq');
		var selected_row_seq = $(this).attr('selected_row_seq');
		var selected_col_seq = $(this).attr('selected_col_seq');
		var modify_section_seq = $(this).attr('modify_section_seq');
		var modify_row_seq = $(this).attr('modify_row_seq');
		var modify_col_seq = $(this).attr('modify_col_seq');
		if(selected_section_seq && selected_row_seq && selected_col_seq
				&& modify_section_seq && modify_row_seq && modify_col_seq) {
			frmData.append("group_seq", $(this).attr('group_seq') ? $(this).attr('group_seq') : "none");
			frmData.append("bunyang_seq", $(this).attr('bunyang_seq'));
			frmData.append("selected_section_seq", selected_section_seq);
			frmData.append("selected_row_seq", selected_row_seq);
			frmData.append("selected_col_seq", selected_col_seq);
			frmData.append("modify_section_seq", modify_section_seq);
			frmData.append("modify_row_seq", modify_row_seq);
			frmData.append("modify_col_seq", modify_col_seq);	
			bAdded = true;
			if(selected_section_seq != modify_section_seq || selected_row_seq != modify_row_seq || selected_col_seq != modify_col_seq) {
				isChanged = true;
			}
		}
	});
	
	if(!isChanged) {
		common.showAlert('변경할 위치가 선택한 위치와 동일합니다.');
		return;
	}
	
	if(bAdded) {
		$.ajax({
	   		dataType : 'text',
	        url:"${contextPath}/admin/saveChangedGrave",
	        data:frmData,
	        type : "POST",
	        processData: false, 
	        contentType:false,
	        success : function(result) {
	        	if(result){
	        		common.showAlert('저장되었습니다.');
	        		goToList();
	        	}else{
	        		common.showAlert('저장에 실패하였습니다.');
	        	}
			},error : function(result){
	        	alert('저장중 에러가 발생하였습니다.');
			}
	    });
	} else {
		common.showAlert('저장할 데이터가 없습니다.');
	}
}

/** 
 * 목록으로
 */
function goToList() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/usemgmt";
	frm.submit();
}

</script>