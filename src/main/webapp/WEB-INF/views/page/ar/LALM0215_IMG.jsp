<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp" %>
<%@ include file="/WEB-INF/common/head.jsp" %>

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<style>
#fileDiv {
	text-overflow:ellipsis;
	overflow:hidden;
	white-space:nowrap;
}

</style>
<script>
$(document).ready(function (){
	/******************************
     * 이미지 일괄 삭제 이벤트
     ******************************/
	$("#delAllImg").click(function(e) {
		e.preventDefault();
		
		$("#uploadImg").val("");
		$(".uploadImg").empty();
	});
	
	$(document).on("click",".delIndvImg", function(e){
		e.preventDefault();
		$(this).closest("div").parent("li").remove();
	});
});
</script>
<body>
	<section class="content">
		<div class="btn_area">
			<button type="button" class="tb_btn" id="addImg">파일 추가</button>
			<button type="button" class="tb_btn" id="delAllImg">파일 일괄 삭제</button>
		</div>
		<br>
		<br>
		<div class="img_area">
			<div style="display:none;">
				<input type="file" id="uploadImg" name="uploadImg" class="uploadImg" accept="image/*" multiple="multiple" />
			</div>
			<div>
				<ul id="imagePreview" class="uploadImg"></ul>
			</div>
		</div>
	</section>
</body>
</html>