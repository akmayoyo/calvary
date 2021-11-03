<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Calendar currDt = Calendar.getInstance();
int currYear = currDt.get(Calendar.YEAR);
int currMonth = currDt.get(Calendar.MONTH) + 1;
int currDay = currDt.get(Calendar.DATE);
%>

<form id="frm" method="post">
	<input type="hidden" name="bunyangSeq">
	<input type="hidden" name="userId">
	<input type="hidden" name="sectionSeq">
	<input type="hidden" name="seqNo">
	<input type="hidden" name="deathDate">
	<input type="hidden" name="borneOutDate">
</form>
<c:choose>
<c:when test="${errorCode == '1'}">
<script type="text/javascript">
	alert('가족형의 경우 가족 구성원중 최초 사용신청건의 승인이 완료된 후 신청가능합니다.');
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
</script>
</c:when>
<c:when test="${errorCode == '2'}">
<script type="text/javascript">
	alert('이미 봉안된 사용자입니다.');
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
</script>
</c:when>
<c:when test="${errorCode == '3'}">
<script type="text/javascript">
	alert('배우자의 사용신청건이 승인완료 후 신청가능합니다.');
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
</script>
</c:when>
<c:when test="${errorCode == '4'}">
<script type="text/javascript">
	alert('이미 신청된 사용자입니다.');
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/mobile/main";
	frm.submit();
</script>
</c:when>
<c:when test="${errorCode == '5'}">
<script type="text/javascript">
	alert('사용자 정보를 조회할 수 없습니다.');
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
				<a href="javascript:void(0)" style="font-size: 14px;">부활동산 배치도</a>
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
							<tr>
								<th scope="sel">사용(봉안)위치</th>
								<td class="text-left">
									<c:choose>
										<c:when test="${empty assignedGraveInfo}">
											<ul id="ulGrave"></ul>
										</c:when>
										<c:otherwise>
											<ul id="ulGrave">
												<c:forEach items="${assignedGraveList}" var="rowItem">
													<c:choose>
														<c:when test="${coupuleReserved eq '1'}">
															<c:choose>
																<c:when test="${rowItem.couple_reserved eq '1' }">
																	<li>
																		<label class="radio-inline">
																			<input type="radio" name="rbRequest" sectionSeq="${rowItem.section_seq}" rowSeq="${rowItem.row_seq}" colSeq="${rowItem.col_seq}"  seqNo="${rowItem.seq_no}" onchange="rbRequestChange()">${rowItem.grave_exp}
																		</label>
																	</li>
																</c:when>
																<c:otherwise>
																	<li>
																		<label class="radio-inline">
																			<input type="radio" name="rbRequest" sectionSeq="${rowItem.section_seq}" rowSeq="${rowItem.row_seq}" colSeq="${rowItem.col_seq}"  seqNo="${rowItem.seq_no}" disabled>${rowItem.grave_exp} (선택불가)
																		</label>
																	</li>
																</c:otherwise>
															</c:choose>
														</c:when>
														<c:otherwise>
															<c:choose>
																<c:when test="${rowItem.assign_status eq 'RESERVED' && rowItem.request_count eq 0 }">
																	<li>
																		<label class="radio-inline">
																			<input type="radio" name="rbRequest" sectionSeq="${rowItem.section_seq}" rowSeq="${rowItem.row_seq}" colSeq="${rowItem.col_seq}"  seqNo="${rowItem.seq_no}" onchange="rbRequestChange()">${rowItem.grave_exp}
																		</label>
																	</li>
																</c:when>
																<c:otherwise>
																	<li>
																		<label class="radio-inline">
																			<input type="radio" name="rbRequest" sectionSeq="${rowItem.section_seq}" rowSeq="${rowItem.row_seq}" colSeq="${rowItem.col_seq}"  seqNo="${rowItem.seq_no}" disabled>${rowItem.grave_exp} (선택불가)
																		</label>
																	</li>
																</c:otherwise>
															</c:choose>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</ul>
<!-- 											<a id="aDetailGraveInfo" href="javascript:void(0);" style="padding: 5px 0;"></a> -->
<%-- 											<c:if test="${empty assignedGraveInfo}"> --%>
<!-- 												<span style="color: #007BFF;">※사용(봉안)위치는 선택하신 구역내 순차적으로 배정됩니다.</span> -->
<%-- 											</c:if> --%>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th scope="sel">부고일시</th>
								<td class="text-left">
									<select id="selDeathMonth" class="form-control input-sm dateselect">
										<option value="1">1월</option>
										<option value="2">2월</option>
										<option value="3">3월</option>
										<option value="4">4월</option>
										<option value="5">5월</option>
										<option value="6">6월</option>
										<option value="7">7월</option>
										<option value="8">8월</option>
										<option value="9">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select><span> - </span>
									<select id="selDeathDay" class="form-control input-sm dateselect"><option>1일</option></select><span> - </span>
									<select id="selDeathHour" class="form-control input-sm dateselect"></select>
								</td>
							</tr>
							<tr>
								<th scope="sel">발인일시</th>
								<td class="text-left">
									<select id="selBorneOutMonth" class="form-control input-sm dateselect">
										<option value="1">1월</option>
										<option value="2">2월</option>
										<option value="3">3월</option>
										<option value="4">4월</option>
										<option value="5">5월</option>
										<option value="6">6월</option>
										<option value="7">7월</option>
										<option value="8">8월</option>
										<option value="9">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select><span> - </span>
									<select id="selBorneOutDay" class="form-control input-sm dateselect"><option>1일</option></select><span> - </span>
									<select id="selBorneOutHour" class="form-control input-sm dateselect"></select>
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
							<span id="assignLegend">신청위치</span>
							<c:if test="${requiredCnt > 1 && bunyangInfo.connect_product_type eq 'FAMILY' }">
								<div style="width: 10px; height: 10px; background-color: #47CCCA; display: inline-block; margin-left: 15px;">
								</div>
								<span id="assignLegend">가족</span>
							</c:if>
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
<input id="userId" type="hidden" value="${useUserInfo.user_id}">
<c:if test="${!empty assignedGraveInfo}">
<input id="assignedSectionSeq" type="hidden" value="${assignedGraveInfo.section_seq}">
<input id="assignedRowSeq" type="hidden" value="${assignedGraveInfo.row_seq}">
<input id="assignedColSeq" type="hidden" value="${assignedGraveInfo.col_seq}">
<input id="assignedSeqNo" type="hidden" value="${assignedGraveInfo.seq_no}">
</c:if>

<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">

(function() {

	var hourOptions = "";
	for(var i = 0; i <= 23; i++) {
		hourOptions += '<option value="' + i + '">' + i + '시' + '</option>';
	}
	$('#selDeathHour, #selBorneOutHour').html(hourOptions);

	$('#selDeathMonth').change(function(e) {
		var selectedYear = <%=currYear%>;
		var selectedMonth = $(this).find('option:selected').val();
		generateDays(selectedYear, selectedMonth, $('#selDeathDay'));
	});
	$('#selBorneOutMonth').change(function(e) {
		var selectedYear = <%=currYear%>;
		var selectedMonth = $(this).find('option:selected').val();
		generateDays(selectedYear, selectedMonth, $('#selBorneOutDay'));
	});

	$('#selDeathMonth option[value=' + <%=currMonth%> + ']').attr('selected', 'selected');
	$('#selBorneOutMonth option[value=' + <%=currMonth%> + ']').attr('selected', 'selected');

	$('#selDeathMonth, #selBorneOutMonth').trigger('change');

	$('#selDeathDay option[value=' + <%=currDay%> + ']').attr('selected', 'selected');
	$('#selBorneOutDay option[value=' + <%=currDay%> + ']').attr('selected', 'selected');

	if(isAssigned()) {
		var sectionSeq = $('#assignedSectionSeq').val();
		var rowSeq = $('#assignedRowSeq').val();
		var colSeq = $('#assignedColSeq').val();
		var seqNo = $('#assignedSeqNo').val();
		showGraveMap(sectionSeq, rowSeq, colSeq, seqNo);
	} else {
		$('#selGraveSection').trigger('change');
	}
})();

/**
 * 이미 배정된 자리가 있는지 여부 반환
 */
function isAssigned() {
	var bRtn = false;
	if($('#assignedSectionSeq').val()) {
		bRtn = true;
	}
	return bRtn;
}

/**
 *
 */
function _changeGraveSection() {
	var selectedOption = $('#selGraveSection').find('option:selected');
	var sectionSeq = selectedOption.val();
	var rowSeq = selectedOption.attr('rowSeq');
	var colSeq = selectedOption.attr('colSeq');
	var seqNo = selectedOption.attr('seqNo');
	showGraveMap(sectionSeq, rowSeq, colSeq, seqNo);
}

/**
 *
 */
function showGraveMap(sectionSeq, rowSeq, colSeq, seqNo) {

	if(sectionSeq && rowSeq && colSeq) {
		$('#mapTitle').text('[' + sectionSeq + '구역] 사용(봉안)위치 정보');
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
				 showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo);
			}
		});
	}
}

/**
 *
 */
function showDetailGraveInfo(sectionSeq, rowSeq, colSeq, seqNo) {
	if(sectionSeq) {
		var detailGraveInfo = '';
		var requiredCnt = getRequiredCnt();
		if(!isAssigned()) {
			var html = '';
			for(var i = 0; i < requiredCnt; i++) {
				detailGraveInfo = sectionSeq + '구역';
				var colSeq2 = Number(colSeq)+i;
				//detailGraveInfo += '  ' + (rowSeq ? rowSeq : '') + '행 - ' + seqToAlpha(Number(colSeq)+i) + '열 (고유번호 : ' + (seqNo ? seqNo : '') + ')';
				detailGraveInfo += '  ' + (rowSeq ? rowSeq : '') + '행 - ' + seqToAlpha(colSeq2) + '열';
				html += '<li><label class="radio-inline"><input type="radio" name="rbRequest" sectionSeq="' + sectionSeq + '" rowSeq="' + rowSeq + '" colSeq="' + colSeq2 + '">' + detailGraveInfo + '</label></li>';
			}
			$('#ulGrave').html(html);
			$('#ulGrave li input[name="rbRequest"]:radio').change(rbRequestChange);
			$('#ulGrave li input[name="rbRequest"]:radio').each(function(idx) {
				if(idx == 0) {
					$(this).attr('checked', true);
					$(this).trigger('change');
				}
			});
		} else {
			var bChecked = false;
			$('#ulGrave li input[name="rbRequest"]:radio').each(function(idx) {
				if($(this).is(':enabled') && !bChecked) {
					bChecked = true;
					$(this).attr('checked', true);
					$(this).trigger('change');
				}
			});
		}


		if(requiredCnt > 1) {// 가족형인 경우 선택가능한 리스트를 표시

		} else {
// 			detailGraveInfo = sectionSeq + '구역';
// 			//detailGraveInfo += '  ' + (rowSeq ? rowSeq : '') + '행 - ' + seqToAlpha(colSeq) + '열 (고유번호 : ' + (seqNo ? seqNo : '') + ')';
// 			detailGraveInfo += '  ' + (rowSeq ? rowSeq : '') + '행 - ' + seqToAlpha(colSeq) + '열';
// 			$('#aDetailGraveInfo').text(detailGraveInfo);
// 			$('#assignLegend').text('신청위치 (' + rowSeq + '행 - ' + seqToAlpha(colSeq) + '열)');
		}
	}
}

/**
 * 이전에 클릭한 square 클릭상태 해제를 위해 저장해둠
 */
var clickedInfo = {};

/**
 *
 */
function rbRequestChange(e) {
	var selectedInput = $(":input:radio[name=rbRequest]:checked");
	var sectionSeq = selectedInput.attr('sectionSeq');
	var rowSeq = selectedInput.attr('rowSeq');
	var colSeq = selectedInput.attr('colSeq');
	var squareId = 'square' + sectionSeq + '_' + rowSeq + '_' + colSeq;
	var square = $('#' + squareId)[0];
	var d = squareData[squareId];
	if(clickedInfo && clickedInfo.square) {
		setSelectedStyle(clickedInfo.square, false, clickedInfo.data);
	}
	clickedInfo.square = square;
	clickedInfo.data = d;
	setSelectedStyle(square, true, d);
	$('#assignLegend').text('신청위치 (' + rowSeq + '행 - ' + seqToAlpha(colSeq) + '열)');
}

/**
 * 필요한 묘개수 반환
 */
function getRequiredCnt() {
	if('${bunyangInfo.connect_product_type}' == 'FAMILY') {
		return Number(${requiredCnt});
	} else {
		return 1;
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

var squareData = {};

/**
 * 부활동산 배정현황 그리드 생성
 */
function makeGraveGrid(grid, gridData) {
	d3.select("svg").remove();
	squareData = {};
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
		.attr("id",function(d) {
			var id = 'square' + d.section_seq + '_' + d.row_seq + '_' + d.col_seq;
			squareData[id] = d;
			return id;
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
	});

}

/**
 *
 */
function setSelectedStyle(el, selected, d) {
	var txt = $('#' + $(el).attr('id').replace('square', 'txt'));
	if(selected) {
		d3.select(el).style("cursor", "pointer");
		d3.select(el).style("fill", "#007BFF");
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
function getRectFillColor(d) {
	var groupSeq = '${bunyangInfo.group_seq}';
	var bunyangSeq = '${bunyangInfo.bunyang_seq}';
	var isFamilyGrave = false;

	if('${bunyangInfo.connect_product_type}' == 'FAMILY') {
		if(isAssigned()) {
			if(!groupSeq) {
				if(bunyangSeq == d.bunyang_seq) {
					isFamilyGrave = true;
				}
			} else {
				if(groupSeq == d.group_seq) {
					isFamilyGrave = true;
				}
			}
		} else {
			var selectedOption = $('#selGraveSection').find('option:selected');
			var sectionSeq = selectedOption.val();
			var rowSeq = selectedOption.attr('rowSeq');
			var colSeq = selectedOption.attr('colSeq');
			var seqNo = selectedOption.attr('seqNo');
			var requiredCnt = getRequiredCnt();
			if(d.section_seq == sectionSeq && d.row_seq == rowSeq && Number(d.col_seq) >= Number(colSeq) && Number(d.col_seq) < (Number(colSeq) + requiredCnt)) {
				isFamilyGrave = true;
			}
		}
	}

	if(isFamilyGrave) {// 가족자리
		return "#47CCCA";
	} else if(d.is_rownum){// 행번호
		return "#92D050";
	} else if(d.assign_status != 'AVAILABLE') {// 사용중
		return "#BFBFBF";
	} else {
		return "#fff";
	}
}

/**
 *
 */
function getTextFillColor(d) {
	var groupSeq = '${bunyangInfo.group_seq}';
	var bunyangSeq = '${bunyangInfo.bunyang_seq}';
	var isFamilyGrave = false;

	if(isAssigned()) {
		if(!groupSeq) {
			if(bunyangSeq == d.bunyang_seq) {
				isFamilyGrave = true;
			}
		} else {
			if(groupSeq == d.group_seq) {
				isFamilyGrave = true;
			}
		}
	} else {
		var selectedOption = $('#selGraveSection').find('option:selected');
		var sectionSeq = selectedOption.val();
		var rowSeq = selectedOption.attr('rowSeq');
		var colSeq = selectedOption.attr('colSeq');
		var seqNo = selectedOption.attr('seqNo');
		var requiredCnt = getRequiredCnt();
		if(d.section_seq == sectionSeq && d.row_seq == rowSeq && Number(d.col_seq) >= Number(colSeq) && Number(d.col_seq) < (Number(colSeq) + requiredCnt)) {
			isFamilyGrave = true;
		}
	}

	if(isFamilyGrave) {// 가족자리
		return "#fff";
	} else if(d.is_rownum){// 행번호
		return "#fff";
	} else if(d.assign_status != 'AVAILABLE') {// 사용중
		return "#fff";
	} else {
		return "#999";
	}
}

/**
 * 배정된 부활동산 구역 정보를 반환
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
function _request() {
	var sectionSeq = '', rowSeq = 0, colSeq = 0, firstColSeq = 0, isReserved = 0, seqNo = '';
	var assignedSectionSeq = $('#assignedSectionSeq').val();
	if(assignedSectionSeq) {// 배정된 자리가 있는 경우
		isReserved = 1;
		sectionSeq = clickedInfo.data['section_seq'];
		rowSeq = clickedInfo.data['row_seq'];
		colSeq = clickedInfo.data['col_seq'];
		firstColSeq = colSeq;
		seqNo = clickedInfo.data['seq_no'];
	}else {// 신규 신청인 경우
		var selectedOption = $('#selGraveSection').find('option:selected');
		sectionSeq = clickedInfo.data['section_seq'];
		rowSeq = clickedInfo.data['row_seq'];
		colSeq = clickedInfo.data['col_seq'];
		firstColSeq = parseInt(selectedOption.attr('colSeq'));
		seqNo = clickedInfo.data['seq_no'];
	}

	// 부고일시,발인일시
	var selectedHour = $('#selDeathHour option:selected').val();
	if(selectedHour < 10) {
		selectedHour = '0' + selectedHour;
	}
	selectedHour += '시';
	var deathDate = $('#selDeathMonth option:selected').text();
	deathDate += $('#selDeathDay option:selected').text();
	deathDate += ' ' + selectedHour;

	selectedHour = $('#selBorneOutHour option:selected').val();
	if(selectedHour < 10) {
		selectedHour = '0' + selectedHour;
	}
	selectedHour += '시';
	// 교회행정담당자, 용인공원담당자에게 SMS 전송
	var borneOutDate = $('#selBorneOutMonth option:selected').text();
	borneOutDate += $('#selBorneOutDay option:selected').text();
	borneOutDate += ' ' + selectedHour;

	var data = {};
	data.productType = '${bunyangInfo.connect_product_type}';
	data.bunyangSeq = '${bunyangInfo.bunyang_seq}';
	data.coupleSeq = $('#coupleSeq').val() ? $('#coupleSeq').val() : 0;
	data.userSeq = $('#userSeq').val();
	data.userId = $('#userId').val();
	data.sectionSeq = sectionSeq;
	data.seqNo = seqNo;
	data.deathDate = deathDate;
	data.borneOutDate = borneOutDate;
	data.rowSeq = rowSeq;
	data.colSeq = colSeq;
	data.firstColSeq = firstColSeq;
	data.isReserved = isReserved;

	common.ajax({
		//url:"${contextPath}/mobile/assignGrave",
		url:"${contextPath}/mobile/saveRequestGrave",
		data:data,
		success: function(result) {
			if(result && result.result) {
				//common.showAlert('신청되었습니다.\n부고 알림 메세지 전송 페이지로 이동합니다.');
				common.showAlert('신청되었습니다.\n원활한 장례 진행을 위해서 용인공원 고객센터(031-334-3484)에 장례접수를 해주시기 부탁드립니다.\n장례접수시 상주, 고인명, 발인일시, 배정구역(구역,행,열-고유번호)를 말씀해주시면 감사하겠습니다.');
				// 장지
				var graveInfo = result.graveInfo;
				var locationInfo = graveInfo.section_seq + '구역';
				locationInfo += ' ' + graveInfo.row_seq + '행 - ' + seqToAlpha(graveInfo.col_seq) + '열 (고유번호 : ' + graveInfo.seq_no + ')';
				var receivers = ['${contract1.mobile}', '${contract2.mobile}'];
				var contract3 = '${contract3}';
				if (contract3) {
					receivers.push(contract3);
				}
				var sendSmsVo = {};
				sendSmsVo.msgKey = 'M0009';
				sendSmsVo.receivers = receivers.join(',');
				sendSmsVo.sequences = ['${useUserInfo.user_name}', '${useUserInfo.user_name}', deathDate, locationInfo, borneOutDate];
				common.sendSms(sendSmsVo, function(result) {
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/mobile/main";
					frm.submit();
					//---------------------------- 21-11-03 부고 알림 메세지 페이지 이동 처리 삭제함
					/*
					$('input[name="bunyangSeq"]').val('${bunyangInfo.bunyang_seq}');
					$('input[name="userId"]').val('${useUserInfo.user_id}');
					$('input[name="sectionSeq"]').val(sectionSeq);
					$('input[name="seqNo"]').val(seqNo);
					$('input[name="deathDate"]').val(deathDate);
					$('input[name="borneOutDate"]').val(borneOutDate);
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/mobile/registFuneralInfo";
					frm.submit();
					*/
				}, function(xhr, status, message) {
					//console.log(message);
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/mobile/main";
					frm.submit();
				});
			} else {
				var errorCode = result.errorCode;
				if(errorCode == '1') {
					common.showAlert('가족형의 경우 가족 구성원중 최초 사용신청건의 승인이 완료된 후 신청가능합니다.');
				} else if(errorCode == '2') {
					common.showAlert('이미 봉안된 사용자입니다.');
				} else if(errorCode == '3') {
					common.showAlert('배우자의 사용신청건이 승인완료 후 신청가능합니다.');
				} else if(errorCode == '4') {
					common.showAlert('이미 신청된 사용자입니다.');
				} else {
					common.showAlert('저장에 실패하였습니다.');
				}
			}
		},
		error: function(xhr, status, message) {
			common.showAlert('사용(봉안)신청시 에러가 발생하였습니다.');
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
 * 연월에 해당하는 날짜 선택용 select box 생성
 */
function generateDays(year, month, el) {
	var firstDay = 1;
	var lastDay = new Date(year, month, 0).getDate();
	var options = "";
	for(var i = firstDay; i <= lastDay; i++) {
		options += '<option value="' + i + '">' + i + '일' + '</option>';
	}
	var selectedDay = $(el).val();
	$(el).html(options);
	if(selectedDay > 0 && selectedDay <= lastDay) {
		$(el).find('option[value=' + selectedDay + ']').attr('selected', 'selected');
	}
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



