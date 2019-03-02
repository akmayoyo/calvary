<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 그리드 샘플 -->
<div class="col-md-9">
	
<div class="pull-left"><h3 style="margin-top: 0;">추모동산 사용(봉안)현황</h3></div>
   	<div class="clearfix"></div>
	<div class="table-responsive" style="border-top: 1px solid #999;">
        <table class="table table-style table-bordered" style="border-top: 0;">
        	<colgroup>
        		<col width="16%">
        		<col width="16%">
        		<col width="16%">
        		<col width="16%">
        		<col width="16%">
        		<col width="16%">
        	</colgroup>
			<thead>
				<tr>
					<th scope="col">구분</th>
					<th scope="col">구역명</th>
					<th scope="col">사용중</th>
					<th scope="col">사용예정</th>
					<th scope="col">사용가능</th>
					<th scope="col">전체</th>
				</tr>
			</thead>
            <tbody>
            	<c:forEach items="${graveStatusList}" var="rowItem">
            	<tr <c:if test="${rowItem.grave_type == 'sub_total' || rowItem.grave_type == 'total'}">style="background-color: #FFFCCC; font-weight: bold;"</c:if>>
            		<td <c:if test="${rowItem.grave_type == 'sub_total' || rowItem.grave_type == 'total'}">colspan="2"</c:if>>
            			<c:choose>
            				<c:when test="${rowItem.grave_type == 'COUPLE'}">부부형</c:when>
            				<c:when test="${rowItem.grave_type == 'SINGLE'}">1인형</c:when>
            				<c:when test="${rowItem.grave_type == 'sub_total'}">소계</c:when>
            				<c:when test="${rowItem.grave_type == 'total'}">합계</c:when>
            			</c:choose>
            		</td>
            		<c:if test="${rowItem.grave_type != 'sub_total' && rowItem.grave_type != 'total'}">
            		<td >${rowItem.section_seq}</td>
            		</c:if>
            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.available_cnt)}</td>
            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.reserved_cnt)}</td>
            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.occupied_cnt)}</td>
            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.total_cnt)}</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>
	
	<div style="background-color: #E0EFFC; padding: 10px 10px; margin-top: 15px;">
		<div style="text-align: center;">
			<h3 style="display: inline-block;">추모동산 배치판</h3>
		</div>
		<div style="text-align: center; margin-top: 5px;">
			<div style="width: 10px; height: 10px; background-color: #FF7F27; display: inline-block;">
			</div>
			<span>사용중</span>
			<div style="width: 10px; height: 10px; background-color: #FFCCA9; display: inline-block; margin-left: 10px;">
			</div>
			<span>1/2 사용중(부부형)</span>
			<div style="width: 10px; height: 10px; background-color: #007BFF; display: inline-block; margin-left: 10px;">
			</div>
			<span>사용예정</span>
			<div style="width: 10px; height: 10px; background-color: #fff; display: inline-block; margin-left: 10px; border: 1px solid #ccc;">
			</div>
			<span>사용가능</span>
		</div>
		
		<div style="text-align: center; margin-top: 5px;"><span style="color: #007BFF; margin-left: 10px;">※ 사용(봉안) 구역을 클릭하면 하단에 상세 정보가 표시됩니다.</span></div>
		
		<div style="text-align: center; margin-top: 10px;">
			<div id="grid1" style="display: inline-block;">
				<p style="margin: 0;">가구역</p>
			</div>
			<div id="grid2" style="display: inline-block; margin-left: 5px;">
				<p style="margin: 0;">나구역</p>
			</div>
		</div>
		<div style="text-align: center; margin-top: 5px;">
			<div id="grid3" style="display: inline-block;">
				<p style="margin: 0;">다구역</p>
			</div>
			<div id="grid4" style="display: inline-block; margin-left: 5px;">
				<p style="margin: 0;">라구역</p>
			</div>
		</div>
	</div>
	
    <div style="margin-top: 10px;">
    	<div>
	    	<div class="pull-left"><h4 style="display: inline-block;">동산 사용 정보</h4></div>
	    </div>
	    <div class="clearfix"></div>
	    <div class="table-responsive">
	        <table id="tblAssignInfo" class="table table-style table-bordered">
	        	<colgroup>
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="30%">
	        	</colgroup>
	            <thead>
	                <tr>
	                    <th scope="col" rowspan="2">구역</th>
	                    <th scope="col" rowspan="2">계약번호</th>
	                    <th scope="col" rowspan="2">계약자</th>
	                    <th scope="col" rowspan="2">장묘형태</th>
	                    <th scope="col" colspan="5">사용(봉안)자</th>
	                </tr>
	                <tr>
	                	<th scope="col">성명</th>
	                    <th scope="col">관계</th>
	                    <th scope="col">생년월일</th>
	                    <th scope="col">주소</th>
	                </tr>
	            </thead>
	            <tbody>
	            </tbody>
	        </table>
	    </div>
    </div>
	
</div>
<form id="frm" method="post">
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">
(function(){
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
				 gridData1 = getGridData(sectionData1);
				 gridData1.totalwidth = 155;
				 makeGraveGrid('#grid1', gridData1);
			 }
			 if(sectionData2 != null && sectionData2.length > 0) {
				 gridData2 = getGridData(sectionData2);
				 gridData2.totalwidth = 267;
				 gridData2.totalheight = 211;
				 makeGraveGrid('#grid2', gridData2);
			 }
			 if(sectionData3 != null && sectionData3.length > 0) {
				 gridData3 = getGridData(sectionData3);
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
function getGridData(data) {
	var rows = [], cols = [], rowCols = [], rowIdx = -1, colIdx = -1,
	row_seq, col_seq, max_col_cnt
	;
	$.each(data, function(idx, item){
		row_seq = item['row_seq'];
		col_seq = item['col_seq'];
		max_col_cnt = item['max_col_cnt'];
		if(rows.indexOf(row_seq) < 0) {
			rows.push(row_seq);
			cols = [];
			for(i = 0; i < max_col_cnt; i++) {
				cols.push({});
			}
			rowCols.push(cols);
			rowIdx++
		}
		rowCols[rowIdx][col_seq -1] = item;
	});
	
	var xpos = 1;
    var ypos = 1;
    var width = 10;
    var height = 10;
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
                    width: width,
                    height: height
                }, colInfo))	
        	}
            xpos += width + margin;
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
			if(d.assign_status == 'OCCUPIED') {
				if(d.grave_type == 'SINGLE' || (d.use_user_seq1 && d.use_user_seq2)) {// 1인형 또는 2기 모두 사용중인 부부형
					return "#FF7F27";
				}else {
					return "#FFCCA9";
				}
			} else if(d.assign_status == 'RESERVED') {
				return "#007BFF";
			} else {
				return "#fff";
			}
		})
		.style("stroke", "#999")
		.style("stroke-width", 1)
		.on('mouseover', function(d) {
	       if(_clickable(d)) {
	    	   d3.select(this).style("cursor", "pointer"); 
	       }
	    })
	    .on('mouseout', function(d) {
	       if(_clickable(d)) {
	    	   d3.select(this).style("cursor", "default"); 
	       }
	    })
		.on('click', function(d) {
			if(_clickable(d)) {
				_getGraveAssignInfo(d);
			}
	    });
}

/**
 * 
 */
function _clickable(d) {
	var bRtn = true;
	if(d.assign_status == 'OCCUPIED') {
		bRtn = true;
	}
	return bRtn;
}

/**
 * 특정 구역에 배정된 정보 조회
 */
function _getGraveAssignInfo(d) {
	var data = {};
	data.sectionSeq = d.section_seq;
	data.rowSeq = d.row_seq;
	data.colSeq = d.col_seq;
	common.ajax({
		url:"${contextPath}/admin/getGraveAssignInfo", 
		data:data,
		success: function(result) {
			$('#tblAssignInfo tbody').html('');
			if(result) {
				var len = result.length;
				$.each(result, function(idx, item){
					var tr = $('<tr/>');
					var section = item.section_seq + '구역';
					section += '  ' + item.row_seq + ' - ' + item.col_seq;
					var graveType = item.grave_type == 'COUPLE' ? '부부형' : '1인형';
					var address = item.post_number ? '(' + item.post_number + ') ' + item.address1 + (item.address2 ? item.address2 : '') : '';
					var bunyang_no = item.bunyang_no ? item.bunyang_no : '';
					var apply_user_name = item.apply_user_name ? item.apply_user_name : '';
					if(idx == 0) {
						tr.append('<td rowspan="' + len + '">'+ section +'</td>');
						tr.append('<td rowspan="' + len + '">'+ bunyang_no +'</td>');
						tr.append('<td rowspan="' + len + '">'+ apply_user_name +'</td>');
						tr.append('<td rowspan="' + len + '">'+ graveType +'</td>');	
					}
					tr.append('<td>'+ (item.user_name ? item.user_name : '') +'</td>');
					tr.append('<td>'+ (item.relation_type_name ? item.relation_type_name : '') +'</td>');
					tr.append('<td>'+ (item.birth_date ? item.birth_date : '') +'</td>');
					tr.append('<td>'+ address +'</td>');
					$('#tblAssignInfo tbody').append(tr);
				});
			}
		}
	});
}

</script>