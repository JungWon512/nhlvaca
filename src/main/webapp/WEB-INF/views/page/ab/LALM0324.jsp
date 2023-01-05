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

		fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true); 
		fn_setCodeBox("auc_dt", "AUC_DT", 1, true);

		fn_Init();
		/******************************
		 * 폼변경시 클리어 이벤트
		 ******************************/
		fn_setClearFromFrm("frm_Search", "#grd_MhSogCow1, #grd_MhSogCow2");

		$("#grd_MhSogCow1").jqGrid("hideCol", "OSLP_NO");
		$("#grd_MhSogCow1").jqGrid("hideCol", "AUC_DT");

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

		//폼 초기화
		fn_InitFrm('frm_Search');

		setRowStatus = "";
		$("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
	}

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search() {
		//프로그램 리스트              

		var results = sendAjaxFrm("frm_Search", "/LALM0316_selList", "POST");
		var result;
		if (results.status != RETURN_SUCCESS) {
			showErrorMessage(results);
			return;
		} else {
			result = setDecrypt(results);
		}
		fn_CreateMainGrid(result);
		
		var result_3;
		var results_3 = null;
		if (results.length > 0) {
			results_3 = sendAjaxFrm("frm_Search", "/Lalm0324_selList","POST");
			if (results_3.status == RETURN_SUCCESS) {
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

		var searchResultColNames = [ "경매<br>대상", "경매<br>번호", "출하자", "귀표번호",
				"생년월일", "성별", "KPN", "계<br>대", "산<br>차", "중량", "응찰하한가", "낙찰가",
				"진행상태","원표번호", "경매일자" ];
		var searchResultColModel = [
			{name : "AUC_OBJ_DSC",		index : "AUC_OBJ_DSC",		width : 65,	align : 'center',edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}	},
			{name : "AUC_PRG_SQ",	    index : "AUC_PRG_SQ",		width : 55,	align : 'center'}, 
			{name : "FTSNM",			index : "FTSNM",			width : 60,	align : 'center'},
			{name : "SRA_INDV_AMNNO",	index : "SRA_INDV_AMNNO",	width : 120,align : 'center'},
			{name : "BIRTH",	    	index : "BIRTH",			width : 70,	align : 'center'},
			{name : "INDV_SEX_C",		index : "INDV_SEX_C",		width : 70,	align : 'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}}, 
			{name : "KPN_NO",			index : "KPN_NO",			width : 60,	align : 'center'},
			{name : "SRA_INDV_PASG_QCN",index : "SRA_INDV_PASG_QCN",width : 40,	align : 'center'},
			{name : "MATIME",			index : "MATIME",			width : 40,	align : 'center'}, 
			{name : "COW_SOG_WT",		index : "COW_SOG_WT",		width : 35,	align : 'center'},
			{name : "LOWS_SBID_LMT_AM",	index : "LOWS_SBID_LMT_AM",	width : 85,	align : 'right', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
			{name : "SRA_SBID_AM",		index : "SRA_SBID_AM",		width : 85,	align : 'right', formatter : 'integer',formatoptions : {	thousandsSeparator : ',',decimalPlaces : 0}},
			{name : "SEL_STS_DSC",	    index : "SEL_STS_DSC",	    width : 85,	align : 'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
			{name : "OSLP_NO",	        index : "OSLP_NO",	        width : 85,	align : 'center', hidden: true}, 
			{name : "AUC_DT",	        index : "AUC_DT",	        width : 85,	align : 'center', hidden: true}, 
			];
		
		$("#grd_MhSogCow1").jqGrid("GridUnload");

		$("#grd_MhSogCow1").jqGrid({
			datatype : "local",
			data : data,
			height : 520,
			rowNum : rowNoValue,
			resizeing : true,
			autowidth : true,
			shrinkToFit : false,
			rownumbers : true,
			rownumWidth : 40,
			colNames : searchResultColNames,
			colModel : searchResultColModel,
			onSelectRow : function(rowid, status, e) {
				fn_CreateSubGrid();
				var sel_data = $("#grd_MhSogCow1").getRowData(rowid);
				var data = new Object();

				data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
				data["auc_dt"] = sel_data.AUC_DT;
				data["oslp_no"] = sel_data.OSLP_NO;
				var btnResults = sendAjax(data, "/Lalm0324_selList", "POST");
				var btnResult;
				if (btnResults.status == RETURN_SUCCESS) {
					btnResult = setDecrypt(btnResults);
				}
				fn_CreateSubGrid(btnResult);

			},
		});
		//행번호
		$("#grd_MhSogCow1").jqGrid("setLabel", "rn", "No");

	}

	function fn_CreateSubGrid(data) {
		

		var rowNoValue = 0;
		if (data != null) {
			rowNoValue = data.length;
		}
		var searchResultColNames = [ "경매<br>대상", "경매<br>번호", "출하자", "귀표번호",
			"생년월일", "KPN", "중량", "응찰하한가", "낙찰가", "낙찰자", "진행상태"
			,"원표번호", "경매일자", "변경일시", "변경사유" ];
		var searchResultColModel = [
			{name : "AUC_OBJ_DSC",		index : "AUC_OBJ_DSC",		width : 65,	align : 'center',edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}	},
			{name : "AUC_PRG_SQ",	    index : "AUC_PRG_SQ",		width : 55,	align : 'center'}, 
			{name : "FTSNM",			index : "FTSNM",			width : 60,	align : 'center'},
			{name : "SRA_INDV_AMNNO",	index : "SRA_INDV_AMNNO",	width : 120,align : 'center'},
			{name : "INDV_SEX_C",		index : "INDV_SEX_C",		width : 70,	align : 'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}}, 
			{name : "KPN_NO",			index : "KPN_NO",			width : 60,	align : 'center'},
			{name : "COW_SOG_WT",		index : "COW_SOG_WT",		width : 35,	align : 'center'},
			{name : "LOWS_SBID_LMT_AM",	index : "LOWS_SBID_LMT_AM",	width : 85,	align : 'right',formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
			{name : "SRA_SBID_AM",		index : "SRA_SBID_AM",		width : 85,	align : 'right',formatter : 'integer',formatoptions : {	thousandsSeparator : ',',decimalPlaces : 0}},
			{name : "SRA_MWMNNM",	    index : "SRA_MWMNNM",	    width : 85,	align : 'center'},
			{name : "SEL_STS_DSC",	    index : "SEL_STS_DSC",	    width : 85,	align : 'center',edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
			{name : "OSLP_NO",	        index : "OSLP_NO",	        width : 85,	align : 'center',hidden:true}, 
			{name : "AUC_DT",	        index : "AUC_DT",	        width : 85,	align : 'center',hidden:true}, 
			{name : "LSCHG_DTM",	    index : "LSCHG_DTM",	    width : 95,	align : 'center'}, 
			{name : "CHG_RMK_CNTN",	    index : "CHG_RMK_CNTN",	    width : 400,align : 'center'} 
			];

		$("#grd_MhSogCow2").jqGrid("GridUnload");

		$("#grd_MhSogCow2").jqGrid({
			datatype : "local",
			data : data,
			height : 520,
			rowNum : rowNoValue,
			resizeing : true,
			autowidth : true,
			shrinkToFit : false,
			rownumbers : true,
			rownumWidth : 40,
			colNames : searchResultColNames,
			colModel : searchResultColModel,
		});
		//행번호
		$("#grd_MhSogCow2").jqGrid("setLabel", "rn", "No");
	}
</script>

<body>
	<div class="contents">
		<%@ include file="/WEB-INF/common/menuBtn.jsp"%>
		<section class="content">

			<div class="tab_box clearfix">
				<ul class="tab_list">
					<li><p class="dot_allow">검색조건</p></li>
				</ul>
			</div>
			<!-- //tab_box e -->
			<div class="sec_table">
				<div class="blueTable rsp_v">
					<form id="frm_Search" name="frm_Search">
						<table>
							<colgroup>
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="90">
								<col width="*">

								<!-- 버튼 있는 테이블은 width 94 고정 -->
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><span class="tb_dot">경매대상</span></th>
									<td><select id="auc_obj_dsc">

									</select></td>
									<th scope="row"><span class="tb_dot">경매일자</span></th>
									<td>
										<div class="cell">
											<input type="text" class="date" id="auc_dt">
										</div>
									</td>
									<th scope="row">경매번호</th>
									<td>
										<div class="cellBox">
											<div class="cell">
												<input type="text" id="auc_prg_sq">
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
			<div class="tab_box clearfix">
				<ul class="tab_list">
					<li><p class="dot_allow">검색결과</p></li>
				</ul>
			</div>
			<ul class="clearfix">
				<li class="fl_L allow_R m_full" style="width: 40%;">
					<!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
					<div class="listTable">
						<table id="grd_MhSogCow1" style="width: 100%;">
						</table>
					</div>
				</li>
				<!-- //좌 e -->
				<li class="fl_R m_full" style="width: 59.5%">
					<div class="listTable">
						<table id="grd_MhSogCow2" style="width: 100%;">
						</table>
					</div>
				</li>
			</ul>

		</section>
	</div>
</body>
</html>