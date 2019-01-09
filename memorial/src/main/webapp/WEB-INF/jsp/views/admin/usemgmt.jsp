<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 그리드 샘플 -->
<div class="col-md-9">
	
	<div style="background-color: #E0EFFC; padding: 10px 10px;">
		<div style="text-align: center;">
			<h3 style="display: inline-block;">추모동산 사용(봉안)현황</h3>
		</div>
		<div style="text-align: center; margin-top: 5px;">
			<div style="width: 10px; height: 10px; background-color: #FF7F27; display: inline-block; margin-left: 20px;">
			</div>
			<span>사용중</span>
			<div style="width: 10px; height: 10px; background-color: #FFCCA9; display: inline-block; margin-left: 5px;">
			</div>
			<span>사용예정</span>
			<div style="width: 10px; height: 10px; background-color: #fff; display: inline-block; margin-left: 5px; border: 1px solid #ccc;">
			</div>
			<span>사용가능</span>
		</div>
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
	
	<div class="mt-30 text-center">
        <button type="button" class="btn btn-primary btn-lg" onclick="_useapply()">사용신청</button>
    </div>
	
</div>

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
				return "#FF7F27";
			} else if(d.assign_status == 'RESERVED') {
				return "#FFCCA9";
			} else {
				return "#fff";
			}
		})
		.style("stroke", "#999")
		.style("stroke-width", 1)
		.on('click', function(d) {
	       d.click ++;
	       if ((d.click)%4 == 0 ) { d3.select(this).style("fill","#fff"); }
		   if ((d.click)%4 == 1 ) { d3.select(this).style("fill","#2C93E8"); }
		   if ((d.click)%4 == 2 ) { d3.select(this).style("fill","#F56C4E"); }
		   if ((d.click)%4 == 3 ) { d3.select(this).style("fill","#838690"); }
	    });
}

/**
 * 사용신청
 */
function _useapply() {
	var winoption = {width:1024, height:830};
	var param = {};
	common.openWindow("${contextPath}/popup/useapply", "popUseApply", winoption, param);
	// callback 함수
	window.saveCallBack = function(result) {
		
	};
}

</script>