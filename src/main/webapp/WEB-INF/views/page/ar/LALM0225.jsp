<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
	<!-- 암호화 -->
	<%@ include file="/WEB-INF/common/serviceCall.jsp"%>
	<%@ include file="/WEB-INF/common/head.jsp"%>
	
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Tell the browser to be responsive to screen width -->
	<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"	name="viewport">
</head>
<style>
	#gbox_grd_MhSogCow_1 .ui-jqgrid-hbox {
		width: 100% !important;
		padding-right: 0 !important;
	}
	
	#gbox_grd_MhSogCow_1 .ui-jqgrid-bdiv {
		overflow-y: hidden !important;
	}
	
	.ui-jqgrid tr.jqgrow {
		height: 30px;
		white-space: nowrap;
	}
</style>

<script type="text/javascript">
	var locGbList              = [{value : "", text : "선택", details : ""}
								, {value : "L1", text : "중부1", details : "합천읍,대병,묘산,봉산"}
								, {value : "L2", text : "중부2", details : "대양,용주,율곡"}
								, {value : "L3", text : "동부", details : "초계,적중,청덕,쌍책,덕곡"}
								, {value : "L4", text : "남부", details : "삼가,쌍백,가희"}
								, {value : "L5", text : "북부", details : "가야,야로"}];
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 시작
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : onload 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/    
	$(document).ready(function(){
		/******************************
		 * 초기값 설정
		 ******************************/ 
		fn_CreateGrid();

		//귀표번호 컨트롤
		$("#sra_indv_amnno").on("keypress",function(e){
			if(e.keyCode == 13 && fn_isNull($("#sra_indv_amnno").val()) == false){
				fn_Search();
			}
		}).on("focus",function(e){
			this.select();
		});
		
		/******************************
		 * 폼변경시 클리어 이벤트
		 ******************************/   
		fn_setClearFromFrm("frm_Search","#grd_MhSogCow, #grd_MhSogCow_1,#grd_MhSogCow_2");

		/******************************
		 * 농가검색 팝업
		 ******************************/
		$("#ftsnm").keydown(function(e){
			if(e.keyCode == 13){
				if(fn_isNull($("#ftsnm").val())){
					MessagePopup('OK','출하주 명을 입력하세요.');
					return;
				}
				else {
					var data = new Object();
					data['ftsnm'] = $("#ftsnm").val();
					fn_CallFtsnmPopup(data,true,function(result){
						if(result){
							$("#fhs_id_no").val(result.FHS_ID_NO);
							$("#ftsnm").val(result.FTSNM);
							fn_Search();
						}
					});
				}
			}
			else {
				$("#fhs_id_no").val('');
			}
		});
		
		$("#pb_searchFhs").on('click',function(e){
			e.preventDefault();
			this.blur();
			fn_CallFtsnmPopup(null,false,function(result){
				if(result){
					$("#fhs_id_no").val(result.FHS_ID_NO);
					$("#ftsnm").val(result.FTSNM);
					fn_Search();
				}
			});
		});

		//초기화
		fn_Init();
		
	});
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init(){
		//그리드 초기화
		$("#grd_MhSogCow").jqGrid("clearGridData", true);
		$("#grd_MhSogCow_1").jqGrid("clearGridData", true);
		$("#grd_MhSogCow_2").jqGrid("clearGridData", true);
		
		//폼 초기화
		fn_InitFrm('frm_Search');
		
		$("#auc_dt_st").datepicker().datepicker("setDate", fn_getDay(0, 'YYYY-MM-DD'));
		$("#auc_dt_en").datepicker().datepicker("setDate", fn_getDay(365, 'YYYY-MM-DD'));
		fn_setChgRadio('auc_obj_dsc','0')
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search(){
		//정합성체크
		if(fn_isNull($("#auc_dt_st").val()) || fn_isNull($("#auc_dt_en").val())){
			MessagePopup('OK','경매일자를 선택하세요.',function(){
				$( "#auc_dt" ).focus();
			});
			return;
		}
		
		if(!fn_isDate($("#auc_dt_st").val()) || !fn_isDate($("#auc_dt_en").val())){
			MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
				$("#auc_dt" ).focus();
			});
			return;
		}
		$("#grd_MhSogCow").jqGrid("clearGridData", true);
		
		var results = sendAjaxFrm("frm_Search", "/LALM0225_selList", "POST");
		var result;
		
		if(results.status != RETURN_SUCCESS){
			showErrorMessage(results);
			return;
		}
		else{
			result = setDecrypt(results);
			fn_CreateGrid(result);
		}
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 엑셀 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Excel(){
		var tempObj = [];
		$('#gbox_grd_MhSogCow_1 tr.footrow:visible td:visible').each((i,o)=>{
			tempObj.push({label:$(o).text(),name:$(o).attr('aria-describedby')?.replace('grd_MhSogCow_1_',''),width:$(o).outerWidth(),align:$(o).css('text-align'),formatter:'',colspan:$(o).attr('colspan')??'1'});
		});
		$('#gbox_grd_MhSogCow_2 tr.footrow:visible td:visible').each((i,o)=>{
			tempObj.push({label:$(o).text(),name:$(o).attr('aria-describedby')?.replace('grd_MhSogCow_1_',''),width:$(o).outerWidth(),align:$(o).css('text-align'),formatter:'',colspan:$(o).attr('colspan')??'1'});
		});
	
		fn_ExcelDownlad('grd_MhSogCow', '출장우내역조회',tempObj);
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 축경통자료 엑셀 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_ExcelMca() {
		fn_ExcelDownlad('grd_MhSogCow_mca', '축경통자료', null);
	}
	
	
    function fn_Print(){
    	 
    	 var results = sendAjaxFrm("frm_Search", "/Common_selAucQcn", "POST");
    	 var result = null;
         
    	 var TitleData = new Object();
    	 TitleData.title = App_na_bzplnm+" ("+ App_userNm +")";
    	 
		 ReportPopup('LALM0225R0',TitleData, 'grd_MhSogCow', 'V');              //V:세로 , H:가로  , T :콘솔로그      
    }
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 엑셀자료 엑셀 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_ExcelData() {
		fn_ExcelDownlad('grd_MhSogCow_data', '엑셀자료', null);
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 출장우 등록 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_RegistEntry() {
		var srchData		= new Object();
		var result			= null;
	
		var aucDtSt = $("#auc_dt_st").val();
		var aucDtEn = $("#auc_dt_en").val();
		if(aucDtSt != aucDtEn) {
			MessagePopup('OK','경매일자를 확인하세요.', null);
			return;
		}
		
		srchData["frm_Search"]	= setFrmToData("frm_Search");
		
		result = sendAjax(srchData, "/LALM0225_insSogCow", "POST");
		
		if(result.status == RETURN_SUCCESS){
			MessagePopup("OK", "저장되었습니다.",function(res){
				mv_RunMode = 3;
				mv_auc_dt = $("#auc_dt").val();
				mv_auc_obj_dsc = $("#auc_obj_dsc").val();
				mv_InitBoolean = true;
				fn_Init();
			});
		}
		else {
			showErrorMessage(result);
// 			mv_InitBoolean = true;
// 			fn_Init();
			return;
		}
		
	}
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////

	//그리드 생성1
	function fn_CreateGrid(data){

		var scrollPositionT	= $("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollTop();
		var scrollPositionL	= $("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollLeft();
		var selectId		= $("#grd_MhSogCow_1").jqGrid("getGridParam", "selrow");
		
		var rowNoValue = 0;
		if(data != null){
			rowNoValue = data.length;
		}
		var searchResultColNames = ["H사업장코드", "H농장번호"
									,"경매<br/>대상", "경매일자", "경매<br/>번호", "접수일자", "접수<br/>번호", "예약취소", "취소일자", "바코드", "성별", "출하자"
									,"주소", "동이하주소", "지역구분", "사료<br/>사용여부", "생년월일", "어미구분", "어미<br/>바코드", "개체<br/>관리번호", "등록구분", "월령", "산차"
									,"계대", "아비<br/>KPN", "브루셀라", "백신접종", "전화번호","휴대전화", "계좌번호", "비고", "친자검사<br/>여부", "친자검사<br/>결과"
									,"자가여부", "수송자", "추가운송비", "사료대금", "임신구분", "인공수정일", "수정<br/>KPN", "분만예정일", "임신<br/>개월수", "임신<br/>감정여부"
									,"괴사<br/>감정여부", "제각여부", "최초등록자", "최초등록일", "최종수정자", "최종수정일"];
		
		var searchResultColModel = [{name:"NA_BZPLC",             index:"NA_BZPLC",             width:90,height:30,  sortable:false, align:'center', hidden:true},
									{name:"FHS_FARM_NO",          index:"FHS_FARM_NO",                width:80,  sortable:false, align:'center', hidden:true},
			
									{name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
									{name:"AUC_DT",               index:"AUC_DT",               width:90,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:40,  sortable:false, align:'center', sorttype: "number"},
									{name:"AUC_RECV_DT",          index:"AUC_RECV_DT",          width:90,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"AUC_RECV_NO",          index:"AUC_RECV_NO",          width:40,  sortable:false, align:'center', sorttype: "number"},
									{name:"RECV_CAN_YN",          index:"RECV_CAN_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"RECV_CAN_DT",          index:"RECV_CAN_DT",          width:90,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
									{name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
									{name:"FTSNM",                index:"FTSNM",                width:80,  sortable:false, align:'center'},
									
									{name:"DONGUP",               index:"DONGUP",               width:200, sortable:false, align:'left'},
									{name:"DONGBW",               index:"DONGBW",               width:150, sortable:false, align:'left'},
									{name:"LOC_GB",               index:"LOC_GB",               width:150, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCustonCodeString(locGbList)}},
									{name:"SRA_FED_SPY_YN",       index:"SRA_FED_SPY_YN",       width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"BIRTH",                index:"BIRTH",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"MCOW_DSC",             index:"MCOW_DSC",             width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
									{name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
									{name:"INDV_ID_NO",           index:"INDV_ID_NO",           width:60,  sortable:false, align:'center'},
									{name:"RG_DSC",               index:"RG_DSC",               width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
									{name:"MTCN",                 index:"MTCN",                 width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"MATIME",               index:"MATIME",               width:40,  sortable:false, align:'right'},
									
									{name:"SRA_INDV_PASG_QCN",    index:"SRA_INDV_PASG_QCN",    width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"KPN_NO",               index:"KPN_NO",               width:50,  sortable:false, align:'center'},
									{name:"BRCL_ISP_DT",          index:"BRCL_ISP_DT",          width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"VACN_DT",              index:"VACN_DT",              width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"OHSE_TELNO",           index:"OHSE_TELNO",           width:120, sortable:false, align:'center'},
									{name:"CUS_MPNO",             index:"CUS_MPNO",             width:120, sortable:false, align:'center'},
									{name:"SRA_FARM_ACNO",        index:"SRA_FARM_ACNO",        width:120, sortable:false, align:'center'},
									{name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable:false, align:'left'},
									{name:"DNA_YN_CHK",           index:"DNA_YN_CHK",           width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"DNA_JUG_RESULT",       index:"DNA_JUG_RESULT",       width:60,  sortable:false, align:'center'},
									
									{name:"TRPCS_PY_YN",          index:"TRPCS_PY_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"VHC_DRV_CAFFNM",       index:"VHC_DRV_CAFFNM",       width:80,  sortable:false, align:'center'},
									{name:"SRA_TRPCS",            index:"SRA_TRPCS",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"SRA_FED_SPY_AM",       index:"SRA_FED_SPY_AM",       width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"PPGCOW_FEE_DSC",       index:"PPGCOW_FEE_DSC",       width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
									{name:"AFISM_MOD_DT",         index:"AFISM_MOD_DT",         width:80,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"MOD_KPN_NO",           index:"MOD_KPN_NO",           width:50,  sortable:false, align:'center'},
									{name:"PTUR_PLA_DT",          index:"PTUR_PLA_DT",          width:80,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"PRNY_MTCN",            index:"PRNY_MTCN",            width:50,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"PRNY_JUG_YN",          index:"PRNY_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									
									{name:"NCSS_JUG_YN",          index:"NCSS_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"DEBD_CANCEL_YN",       index:"DEBD_CANCEL_YN",       width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"FSRGMN_NM",            index:"FSRGMN_NM",            width:80,  sortable:false, align:'center'},
									{name:"FSRG_DTM",             index:"FSRG_DTM",             width:110, sortable:false, align:'center'},
									{name:"LSCHG_NM",             index:"LSCHG_NM",             width:80,  sortable:false, align:'center'},
									{name:"LSCHG_DTM",            index:"LSCHG_DTM",            width:110, sortable:false, align:'center'}
									];

		$("#grd_MhSogCow").jqGrid("GridUnload");
		
		$("#grd_MhSogCow").jqGrid({
			datatype:    "local",
			data:        data,
			height:      340,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   false,
			shrinkToFit: false, 
			rownumbers:true,
			rownumWidth:30,
			footerrow: true,
			userDataOnFooter: true,
			onSelectRow: function(rowid, status, e){
			
			},
			ondblClickRow: function(rowid, iRow, iCol){
				var sel_data = $("#grd_MhSogCow").getRowData(rowid);
				
				var data = new Object();
				data["na_bzplc"] = sel_data.NA_BZPLC;
				data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
				data["auc_dt"] = sel_data.AUC_DT;
				data["auc_recv_no"] = sel_data.AUC_RECV_NO;
				data["auc_recv_dt"] = sel_data.AUC_RECV_DT;
				
				fn_OpenMenu('LALM0226',data);
			},
			colNames: searchResultColNames,
			colModel: searchResultColModel
		});

		///////////////////////////////////////////////////////////////////////
		//틀고정 grd
		///////////////////////////////////////////////////////////////////////
		$("#grd_MhSogCow_1").jqGrid("GridUnload");
		
		$("#grd_MhSogCow_1").jqGrid({
			datatype:    "local",
			data:        data,
			height:      340,
			rowNum:      rowNoValue,
			resizeing:   false,
			autowidth:   false,
			shrinkToFit: false, 
			rownumbers:true,
			rownumWidth:30,
			footerrow: true,
			userDataOnFooter: true,
			onSelectRow: function(rowid, status, e){
			},
			ondblClickRow: function(rowid, iRow, iCol){
				var sel_data = $("#grd_MhSogCow_1").getRowData(rowid);
				
				var data = new Object();
				data["na_bzplc"] = sel_data.NA_BZPLC;
				data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
				data["auc_dt"] = sel_data.AUC_DT;
				data["auc_recv_no"] = sel_data.AUC_RECV_NO;
				data["auc_recv_dt"] = sel_data.AUC_RECV_DT;
				
				fn_OpenMenu('LALM0226',data);
			},
			gridComplete : function() {
				$(".jqgrow", $("#grd_MhSogCow_1")).bind("mouseover", function(){
					var rowId = $(this).attr("id");
					$(".jqgrow#" + rowId, $("#grd_MhSogCow_2")).addClass("ui-state-hover");
				})
				.bind("mouseout", function(){
					var rowId = $(this).attr("id");
					$(".jqgrow#" + rowId, $("#grd_MhSogCow_2")).removeClass("ui-state-hover");
				});
				if (selectId != null) {
					$("#grd_MhSogCow_1").jqGrid('setSelection',selectId,false);
				}
			},
			colNames: searchResultColNames,
			colModel: searchResultColModel
		});

		//행번호
		$("#grd_MhSogCow_1").jqGrid("setLabel", "rn","No");  
		//고정 타이틀 빼고 전부 숨김처리
		$("#grd_MhSogCow_1").jqGrid("hideCol",[
			"DONGUP", "DONGBW", "LOC_GB", "SRA_FED_SPY_YN", "BIRTH", "MCOW_DSC", "MCOW_SRA_INDV_AMNNO", "INDV_ID_NO", "RG_DSC", "MTCN", "MATIME"
			, "SRA_INDV_PASG_QCN", "KPN_NO", "BRCL_ISP_DT", "VACN_DT", "OHSE_TELNO", "CUS_MPNO", "SRA_FARM_ACNO", "RMK_CNTN", "DNA_YN_CHK", "DNA_JUG_RESULT"
			, "TRPCS_PY_YN", "VHC_DRV_CAFFNM", "SRA_TRPCS", "SRA_FED_SPY_AM", "PPGCOW_FEE_DSC", "AFISM_MOD_DT", "MOD_KPN_NO", "PTUR_PLA_DT", "PRNY_MTCN", "PRNY_JUG_YN"
			, "NCSS_JUG_YN", "DEBD_CANCEL_YN", "FSRGMN_NM", "FSRG_DTM", "LSCHG_NM", "LSCHG_DTM"]);
		
		///////////////////////////////////////////////////////////////////////
		//스크롤 grd
		///////////////////////////////////////////////////////////////////////
		$("#grd_MhSogCow_2").jqGrid("GridUnload");
		
		$("#grd_MhSogCow_2").jqGrid({
			datatype:    "local",
			data:        data,
			height:      340,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   false,
			shrinkToFit: false, 
			footerrow: true,
			userDataOnFooter: true,
			onSelectRow: function(rowid, status, e){},
			ondblClickRow: function(rowid, iRow, iCol){
				var sel_data = $("#grd_MhSogCow_2").getRowData(rowid);
				
				var data = new Object();
				data["na_bzplc"] = sel_data.NA_BZPLC;
				data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
				data["auc_dt"] = sel_data.AUC_DT;
				data["auc_recv_no"] = sel_data.AUC_RECV_NO;
				data["auc_recv_dt"] = sel_data.AUC_RECV_DT;
				
				fn_OpenMenu('LALM0226',data);
			},
			gridComplete : function() {
				$(".jqgrow", $("#grd_MhSogCow_2")).bind("mouseover", function(){
					var rowId = $(this).attr("id");
					$(".jqgrow#" + rowId, $("#grd_MhSogCow_1")).addClass("ui-state-hover");
				})
				.bind("mouseout", function(){
					var rowId = $(this).attr("id");
					$(".jqgrow#" + rowId, $("#grd_MhSogCow_1")).removeClass("ui-state-hover");
				});
				$("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollTop(scrollPositionT);
				$("#grd_MhSogCow_2").closest(".ui-jqgrid-bdiv").scrollLeft(scrollPositionL);
				if (selectId != null) {
					$("#grd_MhSogCow_2").jqGrid('setSelection',selectId,false);
				}
			},
			colNames: searchResultColNames,
			colModel: searchResultColModel
		});
		
		//고정 전부 숨김처리
		$("#grd_MhSogCow_2").jqGrid("hideCol",["AUC_OBJ_DSC", "AUC_DT", "AUC_PRG_SQ", "AUC_RECV_DT", "AUC_RECV_NO", "RECV_CAN_YN", "RECV_CAN_DT", "SRA_INDV_AMNNO", "INDV_SEX_C", "FTSNM"]);
		
		//합계행에 가로스크롤이 있을경우 추가
		var $obj = document.getElementById('grd_MhSogCow_2');
		var $tgObj = document.getElementById('grd_MhSogCow_1');
		var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv), $tgbDiv = $($tgObj.grid.bDiv);
		
		$bDiv.css({'overflow-x':'hidden'});
		$sDiv.css({'overflow-x':'scroll'});
		$sDiv.scroll(function(){
			$bDiv.scrollLeft($sDiv.scrollLeft());
		});
		$bDiv.scroll(function(){
			$tgbDiv.scrollTop($bDiv.scrollTop());
		});

		//가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
		$("#grd_MhSogCow_2 .jqgfirstrow td:last-child").width($("#grd_MhSogCow .jqgfirstrow td:last-child").width() - 17);
		
		//footer
		var gridDatatemp = $('#grd_MhSogCow').getRowData();
		var tot_sra_indv_amnno		= 0; //총두수
		var am_sra_indv_amnno		= 0; //암, 미경산, 프리마틴 총두수
		var su_sra_indv_amnno		= 0; //수 총두수
		$.each(gridDatatemp,function(i){
			tot_sra_indv_amnno++;
			if(gridDatatemp[i].INDV_SEX_C  == '1' || gridDatatemp[i].INDV_SEX_C  == '4' || gridDatatemp[i].INDV_SEX_C  == '6'){
				am_sra_indv_amnno++;
			}else {
				su_sra_indv_amnno++;
			}
		});
		
		var arr1 = [
			[//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
				 ["AUC_OBJ_DSC","총두수",2 ,"String"]
				,["AUC_PRG_SQ",tot_sra_indv_amnno, 1,"Integer"]
				,["AUC_RECV_DT","총두수(암)",1,"String"]
				,["AUC_RECV_NO",am_sra_indv_amnno,1,"Integer"]
				,["RECV_CAN_YN","총두수(수)",1,"String"]
				,["RECV_CAN_DT",su_sra_indv_amnno, 1,"Integer"]
			]
		];
		
		fn_setGridFooter('grd_MhSogCow_1', arr1); 
		//grd_MhSogCow
		$(".ui-jqgrid-sortable").unbind('click');
		$(".ui-jqgrid-sortable").on('click',function(e){
        	$(".s-ico").hide();
			var tr_nm = e.target.id || e.target.offsetParent.id;
			if(tr_nm.indexOf('jqgh_grd_MhSogCow_1') >= 0 || tr_nm.indexOf('jqgh_grd_MhSogCow_2') >= 0){
				var sort_tr = tr_nm.replace('jqgh_grd_MhSogCow_1_','').replace('jqgh_grd_MhSogCow_2_','');
				var before_tr = $('#grd_MhSogCow_1').jqGrid("getGridParam",'sortname');
				var sort_order = 'asc';
				if(sort_tr == before_tr){
					if($('#grd_MhSogCow_1').jqGrid("getGridParam",'sortorder') == 'asc')sort_order = 'desc';
				}
				$('#grd_MhSogCow_1').jqGrid("setGridParam",{sortname:sort_tr,sortorder:sort_order}).trigger('reloadGrid');
				$('#grd_MhSogCow_2').jqGrid("setGridParam",{sortname:sort_tr,sortorder:sort_order}).trigger('reloadGrid');
				$('#grd_MhSogCow').jqGrid("setGridParam",{sortname:sort_tr,sortorder:sort_order}).trigger('reloadGrid');
                $(this).find(".s-ico").show();
                if (sort_order == "asc") {
                	$(this).find(".s-ico").find(".ui-icon-asc").removeClass("ui-state-disabled");
                	$(this).find(".s-ico").find(".ui-icon-desc").addClass("ui-state-disabled");
                }
                else {
                	$(this).find(".s-ico").find(".ui-icon-asc").addClass("ui-state-disabled");
                	$(this).find(".s-ico").find(".ui-icon-desc").removeClass("ui-state-disabled");
                }
			}
		});
		
		var mcaColNames = ["H사업장코드"
							,"*필수*<br/>경매대상구분코드<br/>1: 송아지<br/>2: 비육우<br/>3: 번식우", "*필수*<br/>농가명", "생산자명", "생산지역명", "*필수*<br/>축산개체관리번호<br/>(15자리)"
							, "*필수*<br/>경매번호<br/>예) 1", "자가운송여부<br/>0: 부<br/>1: 여", "추가운송비", "출자금", "사료대금"
							, "당일접수비용", "예방접종일자<br/>예) 20220101", "브루셀라<br/>검사일자<br/>예) 20220101", "브루셀라 검사증<br/>확인여부<br/>0: 부<br/>1: 여", "제각여부<br/>0: 부<br/>1: 여"
							, "12개월 이상여부<br/>0: 부<br/>1: 여", "12개월 이상 수수료", "*필수*<br/>임신구분<br/>1: 임신우<br/>2: 비임신우<br/>3: 임신우+송아지<br/>4: 비임신우 + 송아지<br/>5: 해당없음"
							, "인공수정일자<br/>예) 20220101", "인공수정 증명서<br/>제출여부<br/>0: 부<br/>1: 여", "수정KPN<br/>예) KPN358", "임신개월수", "*필수*<br/>임신감정여부<br/>0: 부<br/>1: 여"
							, "임신여부<br/>0: 부<br/>1: 여", "*필수*<br/>괴사감정여부<br/>0: 부<br/>1: 여", "괴사여부<br/>0: 부<br/>1: 여", "비고", "농가식별번호<br/>(입력하지않음)"
							, "농가관리번호<br/>(입력하지않음)", "주소", "연락처", "성별<br/>0: 없음<br/>1: 암<br/>2: 수<br/>3: 거세<br/>4: 미경산<br/>5: 비거세<br/>6: 프리마틴<br/>7: 공통"
							, "접수일자", "접수번호"
							];

		var mcaColModel = [{name:"NA_BZPLC",             index:"NA_BZPLC",             width:90,height:30,  sortable:false, align:'center', hidden:true},

							{name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:100,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
							{name:"FTSNM",                index:"FTSNM",                width:80,  sortable:false, align:'center'},
							{name:"FTSNM",                index:"FTSNM",                width:80,  sortable:false, align:'center'},
							{name:"DONGUP",               index:"DONGUP",               width:150, sortable:false, align:'left'},
							{name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
							
							{name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:60,  sortable:false, align:'center', sorttype: "number"},
							{name:"TRPCS_PY_YN",          index:"TRPCS_PY_YN",          width:70,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"SRA_TRPCS",            index:"SRA_TRPCS",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
							{name:"SRA_PYIVA",            index:"SRA_PYIVA",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
							{name:"SRA_FED_SPY_AM",       index:"SRA_FED_SPY_AM",       width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
							
							{name:"TD_RC_CST",            index:"TD_RC_CST",            width:80,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
							{name:"VACN_DT",              index:"VACN_DT",              width:80,  sortable:false, align:'center', formatter:'gridDateFormat'},
							{name:"BRCL_ISP_DT",          index:"BRCL_ISP_DT",          width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
							{name:"BRCL_ISP_CTFW_SMT_YN", index:"BRCL_ISP_CTFW_SMT_YN", width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"DEBD_CANCEL_YN",       index:"DEBD_CANCEL_YN",       width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},

							{name:"MT12_OVR_YN",          index:"MT12_OVR_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"MT12_OVR_FEE",         index:"MT12_OVR_FEE",         width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
							{name:"PPGCOW_FEE_DSC",       index:"PPGCOW_FEE_DSC",       width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
							
							{name:"AFISM_MOD_DT",         index:"AFISM_MOD_DT",         width:80,  sortable:false, align:'center', formatter:'gridDateFormat'},
							{name:"AFISM_MOD_CTFW_SMT_YN",index:"AFISM_MOD_CTFW_SMT_YN",width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"MOD_KPN_NO",           index:"MOD_KPN_NO",           width:50,  sortable:false, align:'center'},
							{name:"PRNY_MTCN",            index:"PRNY_MTCN",            width:50,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
							{name:"PRNY_JUG_YN",          index:"PRNY_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							
							{name:"PRNY_YN",              index:"PRNY_YN",              width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"NCSS_JUG_YN",          index:"NCSS_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"NCSS_YN",              index:"NCSS_YN",              width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable:false, align:'left'},
							{name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:80, sortable:false, align:'left'},
							
							{name:"FARM_AMNNO",           index:"FARM_AMNNO",           width:80, sortable:false, align:'left'},
							{name:"DONGUP",               index:"DONGUP",               width:150, sortable:false, align:'left', formatter : function(cell, option, rowData) {return cell + rowData.DONGBW}},
							{name:"CUS_MPNO",             index:"CUS_MPNO",             width:80, sortable:false, align:'left'},
							{name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:80,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
							
							{name:"AUC_RECV_DT",          index:"AUC_RECV_DT",          width:90,  sortable:false, align:'center'},
							{name:"AUC_RECV_NO",          index:"AUC_RECV_NO",          width:40,  sortable:false, align:'center', sorttype: "number"}
							];

		$("#grd_MhSogCow_mca").jqGrid("GridUnload");
		
		$("#grd_MhSogCow_mca").jqGrid({
			datatype:    "local",
			data:        data,
			height:      340,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   false,
			shrinkToFit: false, 
			rownumbers:true,
			rownumWidth:30,
			footerrow: true,
			userDataOnFooter: true,
			colNames: mcaColNames,
			colModel: mcaColModel
		});
		
		var dataColNames = ["H사업장코드"
							,"예약취소", "경매일자", "출하주코드", "바코드", "산차", "계대", "아비KPN", "생년월일", "어미바코드", "성별"
							,"어미구분", "주소", "전화번호", "출하주명", "자가여부", "수송자코드", "수송자", "비고", "친자검사여부", "친자검사결과<br/>1: 일치<br/>2: 불일치<br/>3: 미확인"
							,"접수일자", "경매번호", "제각여부"
							];

		var dataColModel = [{name:"NA_BZPLC",             index:"NA_BZPLC",             width:90,height:30,  sortable:false, align:'center', hidden:true},
			
							{name:"RECV_CAN_YN",          index:"RECV_CAN_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:예약취소;0:예약;"}},
							{name:"AUC_DT",               index:"AUC_DT",               width:90,  sortable:false, align:'center', formatter:'gridDateFormat'},
							{name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:80, sortable:false, align:'center', formatter: function(cell, option, rowData) {return cell + '-' + rowData.FARM_AMNNO}},
							{name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridBarCodeFormat'},
							{name:"MATIME",               index:"MATIME",               width:40,  sortable:false, align:'right'},
							{name:"SRA_INDV_PASG_QCN",    index:"SRA_INDV_PASG_QCN",    width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
							{name:"MOD_KPN_NO",           index:"MOD_KPN_NO",           width:50,  sortable:false, align:'center'},
							{name:"BIRTH",                index:"BIRTH",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
							{name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, sortable:false, align:'center'},
							{name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
							
							{name:"MCOW_DSC",             index:"MCOW_DSC",             width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
							{name:"DONGUP",               index:"DONGUP",               width:150, sortable:false, align:'left', formatter : function(cell, option, rowData) {return cell + ' ' + rowData.DONGBW}},
							{name:"OHSE_TELNO",           index:"OHSE_TELNO",           width:120, sortable:false, align:'center'},
							{name:"FTSNM",                index:"FTSNM",                width:80,  sortable:false, align:'center'},
							{name:"TRPCS_PY_YN",          index:"TRPCS_PY_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"VHC_SHRT_C",           index:"VHC_SHRT_C",           width:80,  sortable:false, align:'center'},
							{name:"VHC_DRV_CAFFNM",       index:"VHC_DRV_CAFFNM",       width:80,  sortable:false, align:'center'},
							{name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable:false, align:'left'},
							{name:"DNA_YN_CHK",           index:"DNA_YN_CHK",           width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
							{name:"DNA_JUG_RESULT",       index:"DNA_JUG_RESULT",       width:60,  sortable:false, align:'center'},
							
							{name:"AUC_RECV_DT",          index:"AUC_RECV_DT",          width:90,  sortable:false, align:'center', formatter:'gridDateFormat'},
							{name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:60,  sortable:false, align:'center', sorttype: "number"},
							{name:"DEBD_CANCEL_YN",       index:"DEBD_CANCEL_YN",       width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}}
							];

		$("#grd_MhSogCow_data").jqGrid("GridUnload");
		
		$("#grd_MhSogCow_data").jqGrid({
			datatype:    "local",
			data:        data,
			height:      340,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   false,
			shrinkToFit: false, 
			rownumbers:true,
			rownumWidth:30,
			footerrow: true,
			userDataOnFooter: true,
			colNames: dataColNames,
			colModel: dataColModel
		});
	}
</script>

<body>
	<div class="contents">
		<%@ include file="/WEB-INF/common/menuBtn.jsp"%>

		<!-- content -->
		<section class="content">
			<div class="tab_box clearfix">
				<ul class="tab_list">
					<li><p class="dot_allow">조회조건</p></li>
				</ul>
			</div>
			<!-- //tab_box e -->
			<div class="sec_table">
				<div class="blueTable rsp_v">
					<form id="frm_Search" name="frm_Search">
						<input type="hidden" id="chg_del_yn" />
						<input type="hidden" id="chg_pgid" />
						<input type="hidden" id="chg_rmk_cntn" />
						<table>
							<colgroup>
								<col width="90">
								<col width="*">
								<col width="90">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">경매대상구분</th>
									<td>
										<div class="cellBox" id="rd_auc_obj_dsc" style="width:40%;">
											<input type="hidden" id="auc_obj_dsc" name="auc_obj_dsc" value="0" />
											<div class="cell">
												<input type="radio" id="auc_obj_dsc_0" name="auc_obj_dsc_radio" value="0" onclick="javascript:fn_setChgRadio('auc_obj_dsc','0');" checked="checked" />
												<label>전체</label>
											</div>
											<div class="cell">
												<input type="radio" id="auc_obj_dsc_1" name="auc_obj_dsc_radio" value="1" onclick="javascript:fn_setChgRadio('auc_obj_dsc','1');" />
												<label>송아지</label>
											</div>
											<div class="cell">
												<input type="radio" id="auc_obj_dsc_2" name="auc_obj_dsc_radio" value="2" onclick="javascript:fn_setChgRadio('auc_obj_dsc','2');" />
												<label>비육우</label>
											</div>
											<div class="cell">
												<input type="radio" id="auc_obj_dsc_3" name="auc_obj_dsc_radio" value="3" onclick="javascript:fn_setChgRadio('auc_obj_dsc','3');" />
												<label>번식우</label>
											</div>
										</div>
									</td>
									<th scope="row">경매일자</th>
									<td>
										<div class="cellBox">
											<div class="cell">
												<input type="text" class="date" id="auc_dt_st" maxlength="10" style="width:48.3%;" /> ~ <input type="text" class="date" id="auc_dt_en" maxlength="10"  style="width:48.3%;" />
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row">출하주</th>
									<td>
										<div class="cellBox v_addr">
											<div class="cell" style="width: 60px;">
												<input disabled="disabled" type="text" id="fhs_id_no" maxlength="10" />
											</div>
											<div class="cell pl2" style="width: 28px;">
												<button id="pb_searchFhs" class="tb_btn white srch">
													<i class="fa fa-search"></i>
												</button>
											</div>
											<div class="cell">
												<input type="text" id="ftsnm" maxlength="30" />
											</div>
										</div>
									</td>
									<th scope="row">조회대상</th>
									<td>
										<div class="cellBox" id="rd_recv_can_yn" style="width:33%;">
											<input type="hidden" name="recv_can_yn" id="recv_can_yn" value="" />
											<div class="cell">
												<input type="radio" id="rd_recv_can_yn" name="rd_recv_can_yn_radio" value="" onclick="javascript:fn_setChgRadio('recv_can_yn','');" />
												<label>전체</label>
											</div>
											<div class="cell">
												<input type="radio" id="rd_recv_can_yn0" name="rd_recv_can_yn_radio" value="0" onclick="javascript:fn_setChgRadio('recv_can_yn','0');" />
												<label>예약</label>
											</div>
											<div class="cell">
												<input type="radio" id="rd_recv_can_yn1" name="rd_recv_can_yn_radio" value="1" onclick="javascript:fn_setChgRadio('recv_can_yn','1');" />
												<label>취소</label>
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
				<ul class="tab_list fl_L">
					<li><p class="dot_allow">검색결과</p></li>
				</ul>
			</div>
			<div class="listTable mb5" style="display: none;">
				<table id="grd_MhSogCow_mca"></table>
			</div>
			<div class="listTable mb5" style="display: none;">
				<table id="grd_MhSogCow_data"></table>
			</div>
			<div class="listTable mb5" style="display: none;">
				<table id="grd_MhSogCow"></table>
			</div>
			<div class="clearfix">
				<div style="width: 860px; float: left;">
					<div class="listTable mb30">
						<table id="grd_MhSogCow_1">
						</table>
					</div>
				</div>
				<div style="position: absolute; width: 100%; padding-left: 860px; padding-right: 30px;">
					<div class="listTable">
						<table id="grd_MhSogCow_2">
						</table>
					</div>
				</div>
			</div>
		</section>

	</div>
	<!-- ./wrapper -->
</body>
</html>