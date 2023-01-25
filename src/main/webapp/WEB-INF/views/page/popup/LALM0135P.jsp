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
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<body>
	<div class="pop_warp">
		<div class="tab_box btn_area clearfix">
			<ul class="tab_list fl_L">
				<li><p class="dot_allow" >검색조건</p></li>
			</ul>
			<%@ include file="/WEB-INF/common/popupBtn.jsp" %>
		</div>
		<div class="sec_table">
			<div class="blueTable rsp_v">
				<form id="frm_Search" name="frm_Search">
				<table style="width:100%;">
					<colgroup>
						<col width="100">
						<col width="150">
						<col width="*">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">통합회원구분</th>
							<td>
								<select id="search_type">
									<option value="1">통합회원이름</option>
									<option value="0">통합회원번호</option>
								</select>
							</td>
							<td>
								<input type="text" name="search_text" id="search_text" value="" alt="검색" />
								<input type="hidden" name="mb_intg_gb" id="mb_intg_gb" value="" alt="통합회원구분" />
							</td>
							<td></td>
						</tr>
					</tbody>
				</table>
				</form>
			</div>
			<!-- //blueTable e -->
		</div>
		<div class="tab_box clearfix">
			<ul class="tab_list">
				<li><p class="dot_allow">검색결과</p></li>
			</ul>
		</div>
		<div class="listTable">
			<table id="grd_MbIntg"></table>
		</div>
	</div>
	<!-- //pop_body e -->
</body>

<script type="text/javascript">
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 시작
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : onload 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	$(document).ready(function(){
		//그리드 초기화
		fn_CreateGrid();
		if(pageInfo.param){
			//폼 초기화
			fn_InitFrm('frm_Search');
			$("#mb_intg_gb").val(pageInfo.param.mb_intg_gb); 

			if( pageInfo.result != null){
				fn_CreateGrid(pageInfo.result);
			}
			$("#search_text").focus();
		}
		else {
			fn_Init();
		}
		
		$("#search_text").keydown(function(e) {
			if(e.keyCode == 13) {
				fn_Search();
				return;
			}
		});
	});
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init(){
		//그리드 초기화
		$("#grd_MbIntg").jqGrid("clearGridData", true);
		//폼 초기화
		fn_InitFrm('frm_Search');
		$("#search_text").focus();
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search(){
		var errMsg = $("#search_type").val() == "0" ? "통합회원번호를 입력하세요." : "통합회원번호를 입력하세요.";
		//정합성체크
		if(fn_isNull($("#search_text").val())){
			MessagePopup('OK', errMsg, function(){
				$( "#search_text" ).focus();
			});
			return;
		}
		
		$("#grd_MbIntg").jqGrid("clearGridData", true);
		
		var results = sendAjaxFrm("frm_Search", "/LALM0135P_selList", "POST");
		var result;
		
		if(results.status != RETURN_SUCCESS){
			showErrorMessage(results);
			return;
		}
		else{
			result = setDecrypt(results);
		}
		fn_CreateGrid(result);
	} 
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 선택함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Select(){
		var sel_rowid = $("#grd_MbIntg").jqGrid("getGridParam", "selrow");
		pageInfo.returnValue = $("#grd_MbIntg").jqGrid("getRowData", sel_rowid);
		var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
		parentInput.val(true).trigger('change');
	}
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////
	
	//그리드 생성
	function fn_CreateGrid(data){
		var rowNoValue = 0;
		if(data != null){
			rowNoValue = data.length;
		}
		
		var searchResultColNames = ["통합회원코드", "통합회원이름", "생년월일<br/>사업자번호", "휴대전화번호", "회원통합일자", "통합회원구분"];
		var searchResultColModel = [
										{name:"MB_INTG_NO",     index:"NA_BZPLC",       width:70,  align:'center'},
										{name:"MB_INTG_NM",     index:"NA_TRPL_C",      width:70,  align:'center'},
										{name:"MB_RLNO",        index:"MB_RLNO",        width:70,  align:'center'},
										{name:"MB_MPNO",        index:"MB_MPNO",        width:70,  align:'center'},
										{name:"MB_INTG_DT",     index:"MB_INTG_DT",     width:80,  align:'center'},
										{name:"MB_INTG_GB",     index:"MB_INTG_GB",     width:80,  align:'center', hidden:true}
									];
		$("#grd_MbIntg").jqGrid("GridUnload");

		$("#grd_MbIntg").jqGrid({
			datatype:    "local",
			data:        data,
			height:      330,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   true,
			shrinkToFit: false, 
			rownumbers:true,
			rownumWidth:40,
			colNames: searchResultColNames,
			colModel: searchResultColModel,
			ondblClickRow: function(rowid, row, col){
				fn_Select();
			}
		});
	
		//행번호
		$("#grd_MbIntg").jqGrid("setLabel", "rn","No");
		
		//가로스크롤 있는경우 추가
		$("#grd_MbIntg .jqgfirstrow td:last-child").width($("#grd_MbIntg .jqgfirstrow td:last-child").width() - 17);
	}
</script>

</html>