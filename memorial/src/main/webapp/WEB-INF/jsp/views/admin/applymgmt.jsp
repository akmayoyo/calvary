<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 그리드 샘플 -->
<div class="col-md-9">
	<!-- 검색 -->
	<div class="bx-border p-20 mb-20">
		<div class="row">
			<div class="col-xs-4 col-md-3 pr-10">
				<select class="form-control">
					<option>신청자</option>
					<option>작성자</option>
				</select>
			</div>
			<div class="col-xs-8 col-md-9 pl-0">
				<div class="input-group">
					<input type="text" class="form-control">
					<span class="input-group-btn pl-10">
						<button class="btn btn-primary" type="button">조회</button>
						<button class="btn btn-primary" type="button" style="margin-left: 4px;">신청</button>
						<button class="btn btn-success" type="button" style="margin-left: 4px;">Excel</button>
					</span>
				</div>
			</div>
		</div>
	</div>

	<!-- 테이블 -->
	<div class="table-responsive">
		<table class="table table-style">
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">신청자</th>
					<th scope="col">사용자</th>
					<th scope="col">신청형태</th>
					<th scope="col">부부형</th>
					<th scope="col">1인형</th>
					<th scope="col">신청일자</th>
					<th scope="col">신청상태</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>1001</td>
					<td>이영준</td>
					<td>이영준외1명</td>
					<td>개별형</td>
					<td>1</td>
					<td>1</td>
					<td>2018/12/05</td>
					<td>미승인</td>
				</tr>
				<tr>
					<td>1002</td>
					<td>이영준</td>
					<td>이영준외1명</td>
					<td>개별형</td>
					<td>1</td>
					<td>1</td>
					<td>2018/12/05</td>
					<td>미승인</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- 페이징 -->
	<div id="divPagination" class="text-center">
	</div>

</div>

<script type="text/javascript">
(function(){
	$('#divPagination').bootpag({
	   total: 7,
	   page: 2,
	   maxVisible: 5,
	   leaps: true
	}).on('page', function(event, num){
	    
	});
})();


</script>