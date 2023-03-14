<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<style>
div.fileDiv {
	width: 15%;
	height: 100%;
	float: left;
	margin: 12px;
}

button.delIndvImg {
	position: relative;
	top: 0;
	right: 0;
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
		$("#imagePreview").empty();
	});
	
	$(document).on("click",".delIndvImg", function(e){
		e.preventDefault();
		$(this).parent("div").remove();
	});
});
</script>
<body>
	<section class="content">
		<form id="frm_img" name="frm_img">
<!-- 			<div class="btn_area"> -->
<!-- 				<button type="button" class="tb_btn" id="addImg">파일 추가</button> -->
<!-- 				<button type="button" class="tb_btn" id="delAllImg">파일 일괄 삭제</button> -->
<!-- 			</div> -->
			<br>
			<br>
			<div class="img_area">
				<div style="display:none;">
					<input type="file" id="uploadImg" name="uploadImg" class="uploadImg" accept="image/*" multiple="multiple" />
				</div>
				<div id="imagePreview">
<!-- 					<ul id="imagePreview" class="uploadImg"></ul> -->
				</div>
			</div>
		</form>
	</section>
</body>
</html>