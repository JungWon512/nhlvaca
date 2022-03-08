<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">

<%@ include file="../../../common/serviceCall.jsp"%>
<%@ include file="../../../common/head.jsp"%>
</head>
<script type="text/javascript">
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 시작
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : onload 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/

	$(document).ready(function() {

	//	fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true); 
	//	fn_setCodeBox("auc_dt", "AUC_DT", 1, true);

		fn_Init();
		/******************************
		 * 폼변경시 클리어 이벤트
		 ******************************/
		fn_setClearFromFrm("frm_Search", "#grd_1, #grd_2","#grd_3");

		//$("#grd_1").jqGrid("hideCol", "SIMP_TPC");
		//$("#grd_1").jqGrid("hideCol", "AUC_DT");

	});

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init() {
		//그리드 초기화
		fn_CreateMainGrid();
		fn_CreateSubGrid();
		fn_CreateThirdGrid();

	}

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search() {
		//프로그램 리스트              

		var results = sendAjaxFrm("frm_Search", "/LALM0835_selList", "POST");
		var result;
		if (results.status != RETURN_SUCCESS) {
			showErrorMessage(results);
			return;
		} else {
			result = setDecrypt(results);
		}
		fn_CreateMainGrid(result);

	
		var result_2;
		var results_2 = null;
		if (results.length > 0) {
			results_2 = sendAjaxFrm("frm_Search", "/Lalm0835_selList2","POST");
			if (results_2.status != RETURN_SUCCESS) {
				showErrorMessage(results_2);
				return;
			} else {
				result_2 = setDecrypt(results_2);
			}
		}
		var result_3;
		var results_3 = null;
		if (results.length > 0) {
			results_3 = sendAjaxFrm("frm_Search", "/Lalm0835_selList3","POST");
			if (results_3.status != RETURN_SUCCESS) {
				showErrorMessage(results_3);
				return;
			} else {
				result_3 = setDecrypt(results_3);
			}
		}
		
		
		
	}

	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////
	//그리드 생성
	function fn_CreateMainGrid(data) {

		

		var rowNoValue = 0;
		if (data != null) {
			rowNoValue = data.length;
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		var searchResultColNames = ["단순코드유형" ];
		var searchResultColModel = [
			{name : "SIMP_TPC",		index : "SIMP_TPC",		width : 65,	align : 'center'},
			];
		
		$("#grd_1").jqGrid("GridUnload");

		$("#grd_1").jqGrid({
			datatype : "local",
			data : data,
			height : 650,
			rowNum : rowNoValue,
			resizeing : true,
			autowidth : true,
			shrinkToFit : false,
			rownumbers : true,
			rownumWidth : 20,
			colNames : searchResultColNames,
			colModel : searchResultColModel,
		 	gridComplete : function(rowid, status, e) {
				var rows = $("#grd_1").getDataIDs();
				if(rows.length > 0) {
					$("#grd_2").jqGrid("clearGridData", true);
					var sel_data = $("#grd_1").getRowData(1);
					var data = new Object();

					data["SIMP_TPC"] = sel_data.SIMP_TPC;
					
					var btnResults = sendAjax(data, "/LALM0835_selList2", "POST");
				
					var btnResult;
					
					if (btnResults.status != RETURN_SUCCESS) {
						return;
					} else {
						btnResult = setDecrypt(btnResults);
					}

					fn_CreateSubGrid(btnResult);
				}
			},
			onSelectRow : function(rowid, status, e) {
				fn_CreateSubGrid();
				var sel_data = $("#grd_1").getRowData(rowid);
				var data = new Object();

				 data["SIMP_TPC"] = sel_data.SIMP_TPC;
				var btnResults = sendAjax(data, "/LALM0835_selList2", "POST");
			
				var btnResult;
				if (btnResults.status != RETURN_SUCCESS) {
					showErrorMessage(btnResults);
					return;
				} else {
					btnResult = setDecrypt(btnResults);
				}

				fn_CreateSubGrid(btnResult);
			} 
		});
		//행번호
		$("#grd_1").jqGrid("setLabel", "rn", "No");
		/* $("#grd_MhSogCow1").jqGrid("hideCol", "OSLP_NO");
		$("#grd_MhSogCow1").jqGrid("hideCol", "AUC_DT");
 */
	}

	function fn_CreateSubGrid(data) {
		

		var rowNoValue = 0;
		if (data != null) {
			rowNoValue = data.length;
		}
		var searchResultColNames = ["단순코드그룹 일련번호","코드" ];
		var searchResultColModel = [ 
									{name : "SIMP_C_GRP_SQNO",         index : "SIMP_C_GRP_SQNO",     	width : 50,	align : 'center'}, 
									{name : "SIMP_TPC",                index : "SIMP_TPC",           	width : 50,	align : 'center', hidden:true}, 
									];

		$("#grd_2").jqGrid("GridUnload");

		$("#grd_2").jqGrid({
			datatype : "local",
			data : data,
			height : 285,
			rowNum : rowNoValue,
			resizeing : true,
			autowidth : true,
			shrinkToFit : false,
			rownumbers : true,
			rownumWidth : 20,
			colNames : searchResultColNames,
			colModel : searchResultColModel,
			gridComplete : function(rowid, status, e) {
				var rows = $("#grd_2").getDataIDs();
				if(rows.length > 0) {
					$("#grd_3").jqGrid("clearGridData", true);
					var sel_data = $("#grd_2").getRowData(1);
					var data = new Object();

					data["SIMP_C_GRP_SQNO"] = sel_data.SIMP_C_GRP_SQNO;
					data["SIMP_TPC"] = sel_data.SIMP_TPC;
					
					var btnResults = sendAjax(data, "/LALM0835_selList3", "POST");
				
					var btnResult;
					
					if (btnResults.status != RETURN_SUCCESS) {
						return;
					} else {
						btnResult = setDecrypt(btnResults);
					}

					fn_CreateThirdGrid(btnResult);
				}
			},
			onSelectRow : function(rowid, status, e) {
				fn_CreateThirdGrid();
				var sel_data = $("#grd_2").getRowData(rowid);
				var data = new Object();
				
				data["SIMP_C_GRP_SQNO"] = sel_data.SIMP_C_GRP_SQNO;
				data["SIMP_TPC"] = sel_data.SIMP_TPC;
				
				 var btnResults = sendAjax(data, "/LALM0835_selList3", "POST");
				
				var btnResult;
				if (btnResults.status != RETURN_SUCCESS) {
					showErrorMessage(btnResults);
					return;
				} else {
					btnResult = setDecrypt(btnResults);
				}

				fn_CreateThirdGrid(btnResult);
			} 
		
				
		});
		//행번호
		$("#grd_2").jqGrid("setLabel", "rn", "No");
	}
		function fn_CreateThirdGrid(data) {
		

		var rowNoValue = 0;
		if (data != null) {
			rowNoValue = data.length;
		}
		var searchResultColNames = ["업무구분", "단순코드", "단순코드유형", "단순코드그룹일련번호", "단순코드여부"
            , "단순코드명", "부모단순유형코드", "부모단순코드", "정렬순서", "관리항목내용"
            , "관리항목내용2", "관리항목내용3", "관리항목내용4", "관리항목내용5", "관리항목내용6"
            , "관리항목내용7", "관리항목내용8", "관리항목내용9", "관리항목내용10", "관리항목내용11","최초등록일시"
            , "최초등록자개인번호", "최초등록자경제통합사업자번호", "최종변경일시", "최종변경자개인번호","최종변경자경제통합사업장코드"];        
var searchResultColModel = [
               {name:"BSN_DSC",         index:"BSN_DSC",         width:100, align:'center'},
               {name:"SIMP_C",          index:"SIMP_C",          width:100, align:'center'},
               {name:"SIMP_TPC",        index:"SIMP_TPC",        width:100, align:'center'},
               {name:"SIMP_C_GRP_SQNO", index:"SIMP_C_GRP_SQNO", width:100, align:'center'},
               {name:"SIMP_C_YN",       index:"SIMP_C_YN",       width:100, align:'center'},
               {name:"SIMP_CNM",        index:"SIMP_CNM",        width:100, align:'center'},
               {name:"PRET_SIMP_TPC",   index:"PRET_SIMP_TPC",   width:100, align:'center'},
               {name:"PRET_SIMP_C",     index:"PRET_SIMP_C",     width:100, align:'center'},
               {name:"SORT_SQ",         index:"SORT_SQ",         width:100, align:'center'},
               {name:"AMN_HCNT",        index:"AMN_HCNT",        width:60, align:'center'},
               {name:"AMN_HCNT2",       index:"AMN_HCNT2",       width:60,  align:'center'},
               {name:"AMN_HCNT3",       index:"AMN_HCNT3",       width:60,  align:'center'},
               {name:"AMN_HCNT4",       index:"AMN_HCNT4",       width:60,  align:'center'},
               {name:"AMN_HCNT5",       index:"AMN_HCNT5",       width:60,  align:'center'},
               {name:"AMN_HCNT6",       index:"AMN_HCNT6",       width:60,  align:'center'},
               {name:"AMN_HCNT7",       index:"AMN_HCNT7",       width:60,  align:'center'},
               {name:"AMN_HCNT8",       index:"AMN_HCNT8",       width:60,  align:'center'},
               {name:"AMN_HCNT9",       index:"AMN_HCNT9",       width:60,  align:'center'},
               {name:"AMN_HCNT10",      index:"AMN_HCNT10",      width:60,  align:'center'},
               {name:"AMN_HCNT11",      index:"AMN_HCNT11",      width:60,  align:'center'},
               {name:"FSRG_DTM",        index:"FSRG_DTM",        width:100, align:"center"},
	           {name:"FSRGMN_ENO",      index:"FSRGMN_ENO",      width:110, align:"center"},
	           {name:"FSRGMN_NA_BZPLC", index:"FSRGMN_NA_BZPLC", width:110, align:"center"},
	           {name:"LSCHG_DTM",       index:"LSCHG_DTM",       width:100, align:"center"},
	           {name:"LS_CMENO",        index:"LS_CMENO",        width:110, align:"center"},
	           {name:"LSCGMN_NA_BZPLC", index:"LSCGMN_NA_BZPLC", width:110, align:"center"},
	         
              ];             

		$("#grd_3").jqGrid("GridUnload");

		$("#grd_3").jqGrid({
			datatype : "local",
			data : data,
			height : 285,
			rowNum : rowNoValue,
			resizeing : true,
			autowidth : true,
			shrinkToFit : false,
			rownumbers : true,
			rownumWidth : 30,
			colNames : searchResultColNames,
			colModel : searchResultColModel,
			
		});
		//행번호
		$("#grd_3").jqGrid("setLabel", "rn", "No");
		
		
		$("#grd_3 .jqgfirstrow td:last-child").width($("#grd_3 .jqgfirstrow td:last-child").width() - 17);
	}
	////////////////////////////////////////////////////////////////////////////////
	//  사용자 함수 시작
	////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////
	//  사용자 함수 종료
	////////////////////////////////////////////////////////////////////////////////   

</script>

<body>
	<div class="contents">
		<%@ include file="/WEB-INF/common/menuBtn.jsp"%>
		<section class="content">

			<!-- //tab_box e -->
		
			<ul class="clearfix">
				<li class="fl_L allow_R m_full" style="width: 30%;">
					<div class="tab_box clearfix">
						<ul class="tab_list">
							<li><p class="dot_allow">코드유형</p></li>
						</ul>
					</div>
					<!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
					<div class="listTable">
						<table id="grd_1" style="width: 100%;">
						</table>
					</div>
				</li>
				<!-- //좌 e -->
				<li class="fl_R m_full" style="width: 69.5%">
					<div class="tab_box clearfix">
						<ul class="tab_list">
							<li><p class="dot_allow">단순코드그룹 일련번호</p></li>
						</ul>
					</div>
					<div class="listTable">
						<table id="grd_2" style="width: 100%;">
						</table>
					</div>
				</li>
				<li class="fl_R m_full2" style="width: 69.5%">
					<div class="tab_box clearfix">
						<ul class="tab_list">
							<li><p class="dot_allow">코드정보</p></li>
						</ul>
					</div>
					<div class="listTable">
						<table id="grd_3" style="width: 100%;">
						</table>
					</div>
				</li>
				
			</ul>

		</section>
	</div>
</body>
</html>