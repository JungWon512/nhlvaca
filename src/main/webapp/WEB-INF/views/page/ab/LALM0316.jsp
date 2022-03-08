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

		var result_2;
		var results_2 = null;
		
		//if (results.length > 0) {
			results_2 = sendAjaxFrm("frm_Search", "/Lalm0316_selList_MhAucQcn","POST");
			if (results_2.status != RETURN_SUCCESS) {
				showErrorMessage(results_2);
				return;
			} else {
				result_2 = setDecrypt(results_2);
			//	$("#grd_MhSogCow1").jqGrid("clearGridData", true);
			}
				$("#qcn").val(result_2[0].QCN);
		//}
		var result_3;
		var results_3 = null;
		if (results.length > 0) {
			results_3 = sendAjaxFrm("frm_Search", "/Lalm0316_selList2","POST");
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

		var searchResultColNames = [ "경매<br>대상", "경매<br>번호", "출하자", "귀표번호",
				"생년월일", "성별", "KPN", "계<br>대", "산<br>차", "중량", "응찰하한가", "낙찰가",
				"원표번호", "경매일자", "진행상태" ];
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
			{name : "LOWS_SBID_LMT_AM",	index : "LOWS_SBID_LMT_AM",	width : 85,	align : 'right',	formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
			{name : "SRA_SBID_AM",		index : "SRA_SBID_AM",		width : 85,	align : 'right',			formatter : 'integer',formatoptions : {	thousandsSeparator : ',',decimalPlaces : 0}},
			{name : "OSLP_NO",	        index : "OSLP_NO",	        width : 85,	align : 'center'}, 
			{name : "AUC_DT",	        index : "AUC_DT",	        width : 85,	align : 'center'},
			{name : "SEL_STS_DSC",	    index : "SEL_STS_DSC",	    width : 85,	align : 'center',edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}}, 
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
			gridComplete : function(rowid, status, e) {
				var rows = $("#grd_MhSogCow1").getDataIDs();
				if(rows.length > 0) {
					$("#grd_MhSogCow2").jqGrid("clearGridData", true);
					var sel_data = $("#grd_MhSogCow1").getRowData(1);
					var data = new Object();

					data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
					data["auc_dt"] = sel_data.AUC_DT;
					data["oslp_no"] = sel_data.OSLP_NO;
					data["sel_sts_dsc"] = sel_data.SEL_STS_DSC;
					
					var btnResults = sendAjax(data, "/LALM0316_selList2", "POST");
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
				var sel_data = $("#grd_MhSogCow1").getRowData(rowid);
				var data = new Object();

				data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
				data["auc_dt"] = sel_data.AUC_DT;
				data["oslp_no"] = sel_data.OSLP_NO;
				data["sel_sts_dsc"] = sel_data.SEL_STS_DSC;
				var btnResults = sendAjax(data, "/LALM0316_selList2", "POST");
				var btnResult;
				if (btnResults.status != RETURN_SUCCESS) {
					showErrorMessage(btnResults);
					return;
				} else {
					btnResult = setDecrypt(btnResults);
				}

				fn_CreateSubGrid(btnResult);
			},
		});
		//행번호
		$("#grd_MhSogCow1").jqGrid("setLabel", "rn", "No");

		$("#grd_MhSogCow1").jqGrid("setLabel", "rn", "No");
		$("#grd_MhSogCow1").jqGrid("hideCol", "OSLP_NO");
		$("#grd_MhSogCow1").jqGrid("hideCol", "AUC_DT");

	}

	function fn_CreateSubGrid(data) {
		

		var rowNoValue = 0;
		if (data != null) {
			rowNoValue = data.length;
		}
		var searchResultColNames = [ "응찰자", "응찰자명", "참가<br>번호", "응찰가", "응찰시간",
				"삭제", "원표번호", "경매일자", "일련번호", "경매대상", "상태구분" ,"경매번호"];
		var searchResultColModel = [ 
									{name : "TRMN_AMNNO",         index : "TRMN_AMNNO",     	width : 40,	align : 'center'}, 
									{name : "SRA_MWMNNM",         index : "SRA_MWMNNM",     	width : 50,	align : 'center'}, 
									{name : "LVST_AUC_PTC_MN_NO", index : "LVST_AUC_PTC_MN_NO", width : 50, align : 'center'}, 
									{name : "ATDR_AM",            index : "ATDR_AM"            ,width : 60,	align : 'right',formatter : 'integer',formatoptions : {	thousandsSeparator : ',',decimalPlaces : 0}	}, 
									{name : "ATDR_DTM",	          index : "ATDR_DTM",	        width : 100,align : 'center'},
									{name : "BTNDEL",	          index : "BTNDEL",	            width : 40,	align : 'center',	sortable : false,formatter : gridCboxFormat	},
									{name : "OSLP_NO",	          index : "OSLP_NO",	        width : 85,	align : 'center',	hidden : true}, 
									{name : "AUC_DT",	          index : "AUC_DT",            	width : 85,	align : 'center',	hidden : true},
									{name : "RG_SQNO",	          index : "RG_SQNO",            width : 85,	align : 'center',	hidden : true},
									{name : "AUC_OBJ_DSC",	      index : "AUC_OBJ_DSC",       	width : 85,	align : 'center',	hidden : true}, 
									{name : "SEL_STS_DSC",	      index : "SEL_STS_DSC",	    width : 85,	align : 'center',	hidden : true},
									{name : "AUC_PRG_SQ",	      index : "AUC_PRG_SQ",	        width : 85,	align : 'center',	hidden : true},

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
	////////////////////////////////////////////////////////////////////////////////
	//  사용자 함수 시작
	////////////////////////////////////////////////////////////////////////////////
	function gridCboxFormat(val, options, rowdata) {
		var gid = options.gid;
		var rowid = options.rowId;
		var colkey = options.colModel.name;
		return '<input style="margin-left:1px;" type="button" id="' + gid + '_'
				+ rowid + '_' + colkey + '" ' + 'onclick="fn_delete(\'' + gid
				+ '\',\'' + rowid + '\',\'' + colkey + '\')" value="행삭제" />';
	}

	function fn_delete(gid, rowid, colkey) {
		//      	var sel_rowid = $("#grd_MhSogCow2").jqGrid('getGridParam', 'selarrow'); 
		var sel_data = $("#grd_MhSogCow2").jqGrid("getRowData", rowid);
		var sub_data = new Object();

		sub_data["auc_dt"] = sel_data.AUC_DT;
		sub_data["trmn_amnno"] = sel_data.TRMN_AMNNO;
		sub_data["oslp_no"] = sel_data.OSLP_NO;
		sub_data["rg_sqno"] = sel_data.RG_SQNO;
		sub_data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
		sub_data["sel_sts_dsc"] = sel_data.SEL_STS_DSC;
		//프로그램삭제 validation check     
		if (sel_data.SEL_STS_DSC == '22') {
			MessagePopup("OK", "경매진행 낙찰 상태는 삭제 할수 업습니다.");
			return;
		}
		MessagePopup('YESNO', "삭제 하시겠습니까?",
				function(res) {
					if (res) {
						var results = sendAjax(sub_data,
								"/LALM0316_updAtdrLog", "POST");
						if (results.status != RETURN_SUCCESS) {
							showErrorMessage(results);
							return;
						} else {
							MessagePopup("OK", "삭제되었습니다.");
							fn_CreateSubGrid();
							var btnResults = sendAjax(sub_data,
									"/LALM0316_selList2", "POST");
							var btnResult;
							if (btnResults.status != RETURN_SUCCESS) {
								showErrorMessage(btnResults);
								return;
							} else {
								btnResult = setDecrypt(btnResults);
							}

							fn_CreateSubGrid(btnResult);
						}
					} else {
						MessagePopup('OK', '취소되었습니다.');
					}
				});

	}
	////////////////////////////////////////////////////////////////////////////////
	//  사용자 함수 종료
	////////////////////////////////////////////////////////////////////////////////   

	function fn_Print() {

		var TitleData = new Object();
		TitleData.title = "제 " + $("#qcn").val() + " 차 응찰내역 조회 ("+fn_toDate(fn_dateToData($('#auc_dt').val()), "KR")+")";
		TitleData.sub_title = "";
		TitleData.unit = "";
		TitleData.srch_condition = '[경매일자 : ' + $('#auc_dt').val() + ']'
				+ '/ [경매대상 : ' + $("#auc_obj_dsc option:selected").text() + ']';
		TitleData.trmn_amnmmo = $("#trmn_amnno").val();
		//TitleData.qcn  = $("#qcn").val();
		
		
	//	TitleData.auc_prg_sq = $("#auc_prg_sq")
		ReportPopup('LALM0316R0', TitleData, 'grd_MhSogCow1,grd_MhSogCow2', 'V');

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
												<input hidden="ture" id="qcn">
												
												
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
				<li class="fl_L allow_R m_full" style="width: 60%;">
					<!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
					<div class="listTable">
						<table id="grd_MhSogCow1" style="width: 100%;">
						</table>
					</div>
				</li>
				<!-- //좌 e -->
				<li class="fl_R m_full" style="width: 39.5%">
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