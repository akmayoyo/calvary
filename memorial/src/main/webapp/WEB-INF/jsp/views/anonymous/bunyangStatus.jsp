<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.grid-text {
    pointer-events: none;
}

#tblBunyangStatus td,th{
	padding: 20px 7px;
}
</style>

<header>
    <div class="wrap">
        <!-- 사이트 로고 -->
        <a class="logo" href="${contextPath}/anonymous/bunyangStatus">
            <img src="${contextPath}/resources/assets/images/logo_w.png" alt="">
        </a>
    </div>
</header>

<!-- 분양현황 -->
<div style="margin-top: 60px; padding: 15px;">
    <div class="col-xs-8" style="margin: 0 auto; float: none; text-align: center; padding:40px 10px; ">
        <p style="font-size: 26px; font-weight: bold; color: #333;">갈보리 추모동산 분양현황</p>
        <p style="font-size: 18px; font-weight: bold; color: #333;">${currDate} 기준</p>

        <div style="margin-top: 20px; border-top: 1px solid #999;">
            <table id="tblBunyangStatus" class="table table-style table-bordered">
                <colgroup>
                    <col width="10%">
                    <col width="10%">
                    <col width="10%">
                    <col width="15%">
                    <col width="10%">
                    <col width="10%">
                    <col width="10%">
                    <col width="10%">
                    <col width="10%">
                </colgroup>
                <tbody>
                    <tr>
                        <th style="background-color: #f5f5f5;">개별형</th>
                        <td>${statusByProductType.each_cnt}</td>
                        <th style="background-color: #f5f5f5;">부부형</th>
                        <td>${statusByGraveType.total_couple_cnt} 기중 ${statusByGraveType.couple_cnt} 기 신청</td>
                        <td>${statusByGraveType.couple_usage}%</td>
                        <td>${statusByGraveType.total_couple_cnt - statusByGraveType.couple_cnt}기 남음</td>
                        <th style="background-color: #f5f5f5;">계약자</th>
                        <td>${statusByProgress.contract_cnt}명</td>
                        <td rowspan="2" valign="middle" style="vertical-align: middle;">총 ${statusByGraveType.couple_cnt*2 + statusByGraveType.single_cnt}기 분양</td>
                    </tr>
                    <tr>
                        <th style="background-color: #f5f5f5;">가족형</th>
                        <td>${statusByProductType.family_cnt}</td>
                        <th style="background-color: #f5f5f5;">1인형</th>
                        <td>${statusByGraveType.total_single_cnt} 기중 ${statusByGraveType.single_cnt} 기 신청</td>
                        <td>${statusByGraveType.single_usage}%</td>
                        <td>${statusByGraveType.total_single_cnt - statusByGraveType.single_cnt}기 남음</td>
                        <th style="background-color: #f5f5f5;">완납자</th>
                        <td>${statusByProgress.fullpayment_cnt}명</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>

<!-- 추모동산 배치판 -->
<div style="background-color: #E0EFFC; padding: 10px 10px;">
    <div style="text-align: center;">
        <h3 style="display: inline-block;">추모동산 사용(봉안) 현황</h3>
    </div>
    <div style="text-align: center; margin-top: 5px;">
        <div style="width: 10px; height: 10px; background-color: #C785C8; display: inline-block;">
        </div>
        <span>사용중</span>
        <div style="width: 10px; height: 10px; background-color: #47CCCA; display: inline-block; margin-left: 10px;">
        </div>
        <span>사용예정</span>
        <div style="width: 10px; height: 10px; background-color: #fff; display: inline-block; margin-left: 10px; border: 1px solid #ccc;">
        </div>
        <span>사용가능</span>
        <div style="width: 10px; height: 10px; background-color: #007BFF; display: inline-block; margin-left: 10px;">
        </div>
        <span>선택</span>
    </div>

    <div style="text-align: center; margin-top: 5px;"><span style="color: #007BFF; margin-left: 10px;">※ 사용(봉안) 구역을 선택하면 하단에 상세 정보가 표시됩니다.</span></div>

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

    <div style="text-align: center; margin-top: 25px;">
        <div id="grid1" style="display: inline-block;">
            <p style="margin-bottom: 5px; font-size: 15px;">가구역 (부부형)</p>
        </div>
        <div id="grid2" style="display: inline-block; margin-left: 28px;">
            <p style="margin-bottom: 5px; font-size: 15px;">나구역 (부부형)</p>
        </div>
    </div>
    <div style="text-align: center; margin-top: 5px;">
        <div id="grid3" style="display: inline-block;">
            <p style="margin-bottom: 5px; font-size: 15px;">다구역 (부부형)</p>
        </div>
        <div id="grid4" style="display: inline-block; margin-left: 28px;">
            <p style="margin-bottom: 5px; font-size: 15px;">라구역 (1인형)</p>
        </div>
    </div>
</div>

<div class="col-xs-8" style="margin: 0 auto; float: none; text-align: center; padding:40px 10px;">
	<p style="font-size: 20px; font-weight: bold;">동산 사용 정보</p>
	<div class="table-responsive">
        <table id="tblAssignInfo" class="table table-style table-bordered">
            <colgroup>
                <col width="16%">
                <col width="12%">
                <col width="12%">
                <col width="12%">
                <col width="12%">
                <col width="12%">
                <col width="12%">
                <col width="12%">
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
                    <th scope="col">생년월일</th>
                    <th scope="col">관계</th>
                    <th scope="col">봉안일시</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>


<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
<script type="text/javascript">
(function(){
	
	// add for programmatically d3 click event
	$.fn.d3Click = function () {
		this.each(function (i, e) {
			var evt = new MouseEvent("click");
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
		url:"${contextPath}/anonymous/getGraveUseList", 
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
			if(_clickable(d) && !$(this).attr('selected')) {
				setSelectedStyle(this, true, d);
	       }
	    })
	    .on('mouseout', function(d) {
	    	if(_clickable(d) && !$(this).attr('selected')) {
	    		setSelectedStyle(this, false, d);
	       }
	    })
		.on('click', function(d) {
			if(_clickable(d)) {
				if(clickedInfo && clickedInfo.square) {
					$(clickedInfo.square).attr('selected', false);
					setSelectedStyle(clickedInfo.square, false, clickedInfo.data);
				}
				clickedInfo.square = this;
				clickedInfo.data = d;
				$(this).attr('selected', true);
				setSelectedStyle(this, true, d);
				_getGraveAssignInfo(d);
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
	if(d.assign_status == 'OCCUPIED') {
		return "#C785C8";
	} else if(d.assign_status == 'HALF_OCCUPIED') {
		return "#C785C8";
	} else if(d.assign_status == 'RESERVED' || d.assign_status == 'REQUESTED') {
		return "#47CCCA";
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
function _clickable(d) {
	var bRtn = true;
	if(d.is_rownum) {
		bRtn = false;
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
		url:"${contextPath}/anonymous/getGraveAssignInfo", 
		data:data,
		success: function(result) {
			$('#tblAssignInfo tbody').html('');
			if(result) {
				var len = result.length;
				$.each(result, function(idx, item){
					var tr = $('<tr/>');
					var section = item.section_seq + '구역';
					section += '  ' + item.row_seq + '행-' + seqToAlpha(item.col_seq) + '열<br>(고유번호:' + item.seq_no + ')';
					var graveType = item.grave_type == 'COUPLE' ? '부부형' : '1인형';
					var address = item.post_number ? '(' + item.post_number + ') ' + item.address1 + (item.address2 ? item.address2 : '') : '';
					var bunyang_no = item.bunyang_no ? item.bunyang_no : '';
					var apply_user_name = item.apply_user_name ? item.apply_user_name : '';
					var assign_date = item.assign_date ? item.assign_date : '';
					if(idx == 0) {
						tr.append('<td rowspan="' + len + '">'+ section +'</td>');
						tr.append('<td rowspan="' + len + '">'+ bunyang_no +'</td>');
						tr.append('<td rowspan="' + len + '">'+ apply_user_name +'</td>');
						tr.append('<td rowspan="' + len + '">'+ graveType +'</td>');	
					}
					tr.append('<td>'+ (item.user_name ? item.user_name : '') +'</td>');
					tr.append('<td>'+ (item.birth_date ? item.birth_date : '') +'</td>');
					tr.append('<td>'+ (item.relation_type_name ? item.relation_type_name : '') +'</td>');
					tr.append('<td>'+ assign_date +'</td>');
					$('#tblAssignInfo tbody').append(tr);
				});
				$('html:not(:animated), body:not(:animated)').animate({
		            scrollTop: $("#tblAssignInfo").offset().top
		        }, 1000);
			}
		}
	});
}

/**
 * 
 */
function searchUser() {
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
		}
	});
}

/**
 * 
 */
function seqToAlpha(seq) {
	var seqOfA = "A".charCodeAt(0) + (seq-1);
	var alpha = String.fromCharCode(seqOfA);
	return alpha;
}

</script>
