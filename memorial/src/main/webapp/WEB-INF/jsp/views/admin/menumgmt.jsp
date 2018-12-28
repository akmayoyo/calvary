<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${contextPath}/resources/css/daterangepicker.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<link rel="stylesheet" href="${contextPath}/resources/css/loadingbar.css">
<div>
	<button onclick="addMenu()">추가</button>
	<button onclick="deleteMenu()">삭제</button>
	<button onclick="expand()">+</button>
	<button onclick="collapse()">-</button>
</div>

<div id="jstree">
<ul>
	<li class="jstree-open">Menu
	<!-- 1 Level -->
	<c:forEach items="${menuList}" var="menu">
		<ul>
			<li id="${menu.menu_seq}" menu_name="${menu.menu_name}" menu_url="${menu.menu_url}" menu_level="${menu.menu_level}" menu_type="${menu.menu_type}" display_order="${menu.display_order}" parent_menu_seq="${menu.parent_menu_seq}" use_yn="${menu.use_yn}" >
				<c:out value="${menu.menu_name}" />
				<!-- 2 Level -->
				<c:forEach items="${menu.children}" var="menu">
					<ul>
						<li id="${menu.menu_seq}" menu_name="${menu.menu_name}" menu_url="${menu.menu_url}" menu_level="${menu.menu_level}" menu_type="${menu.menu_type}" display_order="${menu.display_order}" parent_menu_seq="${menu.parent_menu_seq}" use_yn="${menu.use_yn}" >
							<c:out value="${menu.menu_name}" />
							<!-- 3 Level -->
							<c:forEach items="${menu.children}" var="menu">
								<ul>
									<li id="${menu.menu_seq}" menu_name="${menu.menu_name}" menu_url="${menu.menu_url}" menu_level="${menu.menu_level}" menu_type="${menu.menu_type}" display_order="${menu.display_order}" parent_menu_seq="${menu.parent_menu_seq}" use_yn="${menu.use_yn}" >
										<c:out value="${menu.menu_name}" />
									</li>
								</ul>
							</c:forEach>
						</li>
					</ul>
				</c:forEach>
			</li>
		</ul>
	</c:forEach>		
	</li>
</ul>
</div>

<div>
	<span style="width: 120px; display: inline-block;">메뉴명 : </span>
	<input id="tiMenuName" type="text">
</div>
<div>
	<span style="width: 120px; display: inline-block;">메뉴URL : </span>
	<input id="tiMenuURL" type="text">
</div>
<div>
	<span style="width: 120px; display: inline-block;">메뉴순서 : </span>
	<input id="tiDisplayOrder" type="text">
</div>

<div>
	<a href="javascript:void(0)" onclick="excelDownload()">Excel Download</a>
	<a href="javascript:void(0)" onclick="excelUpdate()">Excel Update</a>
	<a href="javascript:void(0)" onclick="createExcelForm()">Create Excel Form</a>
</div>

<input id="tiFile" type="file">
<button onclick="uploadFile()">Upload</button> 
<form id="excelForm" method="post" action="/excel/excelDownload" target="_top">
<input type="hidden" name="headers[0]" value="header1"></input>
<input type="hidden" name="headers[1]" value="header2"></input>
<input type="hidden" name="fields[0]" value="requestUser"></input>
<input type="hidden" name="fields[1]" value="user"></input>
<input type="hidden" name="fileName" value="분양신청.xlsx"></input>
<input type="hidden" name="queryId" value="common.findExcel"></input>
</form>

<script type="text/javascript" src="${contextPath}/resources/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/daterangepicker.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<script src="http://malsup.github.com/jquery.form.js"></script> 
<script type="text/javascript">
$('#jstree').jstree({
  "plugins" : ["checkbox"]
}).on("select_node.jstree", function (e, data) { 
	var li_attr = data.node.li_attr;
	if(li_attr.id){
		$("#tiMenuName").val(li_attr.menu_name);	
	}
});

function addMenu() {
	
}

function deleteMenu() {
	// 체크박스 사용시
	$.each($("#jstree").jstree("get_checked",null,true), function(idx){
		console.log(this);
	});
	//$("#jstree").jstree("get_checked",null,true).each(function(){}); 
}

function expand() {
	$("#jstree").jstree("open_all");
}

function collapse() {
	$("#jstree").jstree("close_all");
}

$("#tiFile").on('change',fileChanged);

var files;

function fileChanged(e){
	files=e.target.files;
	//$('#storeimagetext').val($(this).val());
}

function uploadFile() {
	common.uploadFile(files[0], "form", true, function(result){
		alert(result);
	});
}

function excelDownload() {
	var headers = ["아이디", "성명", "생년월일", "이메일", "핸드폰", "우편번호", "주소1", "주소2", "등록일"];
	var fields = ["user_id", "user_name", "birth_date", "email", "mobile", "post_number", "address1", "address2", "regist_date"];
	var fileName = "등록사용자리스트.xlsx";
	var queryId = "common.getUser";
	var paramKeys = ["userId"];
	var paramValues = ["akmayoyo"];
	common.exportExcel2(headers, fields, fileName, queryId, paramKeys, paramValues);
}

function excelUpdate() {
	var data = {};
	/** String fileName,
			int sheetnum,
			int rownum,
			int cellnum*/
	data["fileName"] = "";
	data["sheetnum"] = 0;
	data["rownum"] = 2;
	data["cellnum"] = 3;
	common.ajax({url:"${contextPath}/excel/excelUpdate", data:data});
}

function createExcelForm() {
	common.ajax({url:"${contextPath}/excel/createRequestForm", data:{bunyangSeq:"1001", fileSeq:"0000000014"}});
}


// $.ajaxSettings.traditional = true;
</script>
