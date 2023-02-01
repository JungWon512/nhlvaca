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
<style type="text/css">
	.content {
		padding: 2px 15px !important;
	}
	.sec_table {
		margin-bottom:15px;
	}
</style>
<script type="text/javascript">
/*----------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0215
 * 3. 파일명(한글) : 출장우내역등록
 *----------------------------------------------------------------------------
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------
 * 2022.10.17   아이시프트   최초작성
------------------------------------------------------------------------------*/
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 시작
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : onload 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	 
	var pageInfos = setDecryptData('${pageInfo}');
	var na_bzplc = App_na_bzplc;
	//mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
	var mv_RunMode             = 0;
	var mv_flg                 = "";
	var mv_vhc_shrt_c          = "";
	var mv_vhc_drv_caffnm      = "";
	var mv_auc_dt              = "";
	var mv_Today               = "";
	var mv_auc_obj_dsc         = "";
	var mv_gvno_bascd          = "";
	var mv_lvst_mkt_trpl_amnno = "";
	var mv_vhc_shrt_c          = "";
	var mv_vhc_drv_caffnm      = "";
	var mv_Today               = "";
	var mv_sgno_prc_dsc        = "";
	var setRowStatus           = "";
	// init시 저장 후 init인지 아닌지 체크
	var mv_InitBoolean         = true;
	var rowId                  = "";
	// 등록권한 1:등록, 0:조회 > 이 권한이 있을 경우에만 경매일자 수정 가능
	var isRegAuth              = (localStorage.getItem("nhlvaca_strg_yn") == "1") ? true : false;
	// 지역별 구분 리스트
	var locGbList              = [{value : "", text : "선택", details : ""}
								, {value : "L1", text : "중부1", details : "합천읍,대병,묘산,봉산"}
								, {value : "L2", text : "중부2", details : "대양,용주,율곡"}
								, {value : "L3", text : "동부", details : "초계,적중,청덕,쌍책,덕곡"}
								, {value : "L4", text : "남부", details : "삼가,쌍백,가희"}
								, {value : "L5", text : "북부", details : "가야,야로"}];
	
	$(document).ready(function(){

		$("#chg_pgid").val("[LM0226]");
		
		// 최초 콤보박스 세팅
		fn_setCodeBox("indv_sex_c", "INDV_SEX_C", 1);				// 성별
		fn_setCodeBox("rg_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);		// 등록구분
		fn_setCodeBox("mcow_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);		// 어미구분
		fn_setCodeBox("ppgcow_fee_dsc", "PPGCOW_FEE_DSC",1);		// 임신구분

		fn_setCustomCodeBox("loc_gb", locGbList);
		
		// 최초 라디오버튼 세팅
		fn_setCodeRadio("rd_auc_obj_dsc","auc_obj_dsc","AUC_OBJ_DSC", 1);
		
		$("#auc_dt_st").datepicker().datepicker("setDate", fn_getDay(0, 'YYYY-MM-DD'));
		$("#auc_dt_en").datepicker().datepicker("setDate", fn_getDay(365, 'YYYY-MM-DD'));
		
		mv_auc_dt			= "";
		mv_auc_obj_dsc		= "1";

		// 라디오버튼 초기화
		fn_InitRadioSet();

		fn_InitSet();

		// 사료미사용여부
		if($("#sra_fed_spy_yn").is(":checked")) {
			$("#sra_fed_spy_yn_fee").val("0");
		}
		else {
			$("#sra_fed_spy_yn_fee").val(parent.envList[0]["SRA_FED_SPY_YN_FEE"]);	/* 사료미사용여부수수료  */
		}

		/******************************
		 * 프로그램ID 대문자 변환
		 ******************************/
		$("#de_pgid").bind("keyup", function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		/******************************
		 * 경매대상 라디오 버튼클릭 이벤트
		 ******************************/
		$(document).on("click", "input[name='auc_obj_dsc_radio']", function(e) {
			fn_AucOnjDscModify("init");
		});
		
		/******************************
		 * 임신구분 콤보박스 이벤트
		******************************/
		$("#ppgcow_fee_dsc").change(function(e) {
			// 번식우
			if($("#auc_obj_dsc").val() == "3") {
				if($(this).val() == "1" || $(this).val() == "3") {
					fn_contrChBox(true, "prny_jug_yn", "");
				}
				else {
					fn_contrChBox(false, "prny_jug_yn", "");
					$("#afism_mod_dt").val("");
					$("#prny_mtcn").val("");
					fn_AfismModDtModify();
				}
				
				// 임신우 + 송아지, 비임신우 + 송아지인 경우
				if ($(this).val() == "3" || $(this).val() == "4") {
					$("#ccow_sra_indv_amnno").prop("disabled", false).val("");
				}
				else {
					$("#ccow_sra_indv_amnno").prop("disabled", true).val("");
				}
			}
		});
		
		/******************************
		 * 경매일자 변경이벤트
		******************************/
		$("#auc_dt").change(function(e) {
			fn_setPrnyMtcn();
		});
		
		/******************************
		 * 인공수정일자 변경 이벤트
		******************************/
		$("#afism_mod_dt").change(function(e) {
			fn_setPrnyMtcn();
		});
		
		/******************************
		 * 수송자 검색 팝업 호출 이벤트(엔터)
		******************************/
		$("#vhc_drv_caffnm").keydown(function(e){
			if(e.keyCode == 13){
				if(fn_isNull($("#vhc_drv_caffnm").val())) {
					MessagePopup('OK','수송자 명을 입력하세요.');
				}
				else {
					var data = new Object();
					data['vhc_drv_caffnm'] = $("#vhc_drv_caffnm").val();
					fn_CallCaffnmPopup(data,true,function(result) {
						if(result){
							$("#vhc_shrt_c").val(result.VHC_SHRT_C);
							$("#vhc_drv_caffnm").val(result.VHC_DRV_CAFFNM);
						}
					}); 
				}
			}
			else {
				$("#vhc_shrt_c").val("");
			}
		});
		
		/*******************************
		 * 생년월일 변경 이벤트
		*******************************/
		$("#birth").on("propertychange change keyup paste input", function(e) {
			console.log("change");
			($("#auc_obj_dsc").val() == "1" || $("#hdn_auc_obj_dsc").val() == "1") ? fn_setAucDt() : "";
		});
		
		/******************************
		 * 개체성별코드 선택 이벤트
		 ******************************/
		$("#indv_sex_c").on("propertychange change keyup paste input", function(e) {
			($("#auc_obj_dsc").val() == "1" || $("#hdn_auc_obj_dsc").val() == "1") ? fn_setAucDt() : "";
		});
		
		/******************************
		 * 수송자 검색 팝업 호출 이벤트(돋보기)
		******************************/
		$("#pb_vhc_drv_caffnm").on('click',function(e){
			e.preventDefault();
			this.blur();
			fn_CallCaffnmPopup(null,false,function(result){
				if(result){
					$("#vhc_shrt_c").val(result.VHC_SHRT_C);
					$("#vhc_drv_caffnm").val(result.VHC_DRV_CAFFNM);
				}
			});
		});

		/******************************
		 * 귀표번호 검색 팝업 호출 이벤트(돋보기)
		******************************/
		$("#pb_sra_indv_amnno").on('click',function(e){
			e.preventDefault();
			this.blur();
			var p_sra_indv_amnno = "410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val();
			fn_CallIndvInfSrchPopup(false, p_sra_indv_amnno);
		});
	
		/******************************
		 * 귀표번호 검색 팝업 호출 이벤트(엔터)
		******************************/
		$("#sra_indv_amnno").keydown(function(e) {
			// 엔터키인 경우
			if(e.keyCode == 13) {
				if(fn_isNull($("#sra_indv_amnno").val())) {
					MessagePopup('OK','귀표번호를 입력하세요.');
					return;
				}
				else {
					fn_CallIndvInfSrch();
				}
			}
			else if (e.keyCode != 116 && e.keyCode != 115) {
				// 기존 정보 초기화
				fn_contrChBox(false, "recv_can_yn", "");	// 예약취소여부
				$("#recv_can_dt").val("");					// 예약취소일자
				
				$("#hed_indv_no").val("002");
				fn_contrChBox(false, "debd_cancel_yn", "");	// 제각여부
				$("#sra_trpcs").val("");					// 추가운송비
				fn_TrpcsPyYnModify("0");					// 수송자
				$("#rmk_cntn").val("");						// 비고
				$("#sra_fed_spy_am").val("")				// 사료대금
				
				$("#brcl_isp_dt").val("")					// 브루셀라검사일
				$("#vacn_dt").val("");						// 예방접종일
				fn_contrChBox(false, "dna_yn_chk", "");		// 친자감정여부
				$("#dna_yn").val("3");						// 친자확인결과
				fn_contrChBox(false, "dna_sampled_yn", "");	// 모근채취여부
				
				$("#indv_sex_c").val("0");					// 개체성별코드
				$("#birth").val("").trigger("change");		// 생년월일
				$("#mcow_dsc").val("09");					// 어미구분
				$("#mcow_sra_indv_amnno").val("");			// 어미귀표번호
				
				$("#indv_id_no").val("");					// 개체관리번호
				$("#rg_dsc").val("09");						// 등록구분
				$("#matime").val("");						// 산차
				$("#sra_indv_pasg_qcn").val("");			// 계대
				$("#sra_indv_brdsra_rg_no").val("");		// 등록번호
				$("#kpn_no").val("");						// KPN번호
				
				$("#fhs_id_no").val("");					// 농가관리번호
				$("#ftsnm").val("");						// 농가명
				$("#farm_amnno").val("");					// 농장관리번호
				$("#ohse_telno").val("");					// 자택전화번호
				$("#cus_mpno").val("");						// 휴대전화번호
				fn_contrChBox(false, "sra_fed_spy_yn", "");	// 사료사용여부
				
				$("#zip").val("");							// 우편번호
				$("#dongup").val("").trigger("change");		// 주소
				$("#dongbw").val("").trigger("change");		// 동이하주소
				$("#sra_farm_acno").val("");				// 계좌번호
				
				if ($("#auc_obj_dsc").val() == "3") {
					$("#ppgcow_fee_dsc").val("1");			// 임신구분
					fn_contrChBox(true, "prny_jug_yn", "");// 임신감정여부
				}
				else {
					$("#ppgcow_fee_dsc").val("5");			// 임신구분
					fn_contrChBox(false, "prny_jug_yn", "");// 임신감정여부
				}
				$("#afism_mod_dt").val("");					// 인공수정일자
				$("#mod_kpn_no").val("");					// 수정 KPN
				$("#ptur_pla_dt").val("");					// 분만예정일
				$("#prny_mtcn").val("");					// 임신개월수
				fn_contrChBox(false, "ncss_jug_yn", "");	// 임신감정여부
				
				$("#sog_na_trpl_c").val("");				// 출하주 경제통합코드
				
				$("#ccow_sra_indv_amnno").prop("disabled", true).val("");			// 딸린 송아지귀표번호
			}
		});
		
		/******************************
		 * 귀표번호 앞자리 변경 이벤트
		******************************/
		$("#hed_indv_no").change(function(e) {
			// 기존 정보 초기화
			fn_contrChBox(false, "recv_can_yn", "");	// 예약취소여부
			$("#recv_can_dt").val("");					// 예약취소일자
			
			fn_contrChBox(false, "debd_cancel_yn", "");	// 제각여부
			$("#sra_trpcs").val("");					// 추가운송비
			fn_TrpcsPyYnModify("0");					// 수송자
			$("#rmk_cntn").val("");						// 비고
			$("#sra_fed_spy_am").val("")				// 사료대금
			
			$("#brcl_isp_dt").val("")					// 브루셀라검사일
			$("#vacn_dt").val("");						// 예방접종일
			fn_contrChBox(false, "dna_yn_chk", "");		// 친자감정여부
			$("#dna_yn").val("3");						// 친자확인결과
			fn_contrChBox(false, "dna_sampled_yn", "");	// 모근채취여부
			
			$("#indv_sex_c").val("0");					// 개체성별코드
			$("#birth").val("").trigger("change");		// 생년월일
			$("#mcow_dsc").val("09");					// 어미구분
			$("#mcow_sra_indv_amnno").val("");			// 어미귀표번호
			
			$("#indv_id_no").val("");					// 개체관리번호
			$("#rg_dsc").val("09");						// 등록구분
			$("#matime").val("");						// 산차
			$("#sra_indv_pasg_qcn").val("");			// 계대
			$("#sra_indv_brdsra_rg_no").val("");		// 등록번호
			$("#kpn_no").val("");						// KPN번호
			
			$("#fhs_id_no").val("");					// 농가관리번호
			$("#ftsnm").val("");						// 농가명
			$("#farm_amnno").val("");					// 농장관리번호
			$("#ohse_telno").val("");					// 자택전화번호
			$("#cus_mpno").val("");						// 휴대전화번호
			fn_contrChBox(false, "sra_fed_spy_yn", "");	// 사료사용여부
			
			$("#zip").val("");							// 우편번호
			$("#dongup").val("").trigger("change");		// 주소
			$("#dongbw").val("").trigger("change");		// 동이하주소
			$("#sra_farm_acno").val("");				// 계좌번호
			
			if ($("#auc_obj_dsc").val() == "3") {
				$("#ppgcow_fee_dsc").val("1");			// 임신구분
				fn_contrChBox(true, "prny_jug_yn", "");// 임신감정여부
			}
			else {
				$("#ppgcow_fee_dsc").val("5");			// 임신구분
				fn_contrChBox(false, "prny_jug_yn", "");// 임신감정여부
			}
			$("#afism_mod_dt").val("");					// 인공수정일자
			$("#mod_kpn_no").val("");					// 수정 KPN
			$("#ptur_pla_dt").val("");					// 분만예정일
			$("#prny_mtcn").val("");					// 임신개월수
			fn_contrChBox(false, "ncss_jug_yn", "");	// 임신감정여부
			
			$("#sog_na_trpl_c").val("");				// 출하주 경제통합코드
			$("#ccow_sra_indv_amnno").prop("disabled", true).val("");			// 딸린 송아지귀표번호
		});
	
		/******************************
		 * 귀표번호 변경 이벤트
		 ******************************/
		$("#sra_indv_amnno").change(function() {
			if(!fn_isNull($("#sra_indv_amnno").val())) {
				$("#re_indv_no").val("410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val());
			}
		});
		
		/******************************
		 * 출하주 검색 팝업 호출 이벤트(엔터)
		 ******************************/
		$("#ftsnm").keydown(function(e){
			if(e.keyCode == 13){
				if(fn_isNull($("#fhs_id_no").val())) {
					if(fn_isNull($("#ftsnm").val())) {
						MessagePopup('OK','출하주 명을 입력하세요.');
					}
					else {
						fn_CallFtsnmPopup(true);
					}
				}
				else if(!fn_isNull($("#indv_sex_c").val()) || !fn_isNull($("#birth").val())) {
					$("#vacn_dt").focus();
				}
			}
		});
		
		/*********************************
		 * 주소 변경 이벤트
		 *********************************/
		$("#dongup, #dongbw").on("propertychange change keyup paste input", function(){
			fn_setLocGb();
		});
		
		/******************************
		 * 출하주 검색 팝업 호출 이벤트(돋보기)
		 ******************************/
		$("#pb_ftsnm").on('click',function(e){
			e.preventDefault();
			this.blur();
			fn_CallFtsnmPopup(false);
		});
		
		/******************************
		 * 출장우 접수 검색영역 출하주 검색 팝업 이벤트
		 ******************************/
		$("#pb_searchFhs").on("click", function(e){
			e.preventDefault();
			this.blur();
			fn_CallFhsPopup(true);
		});
		
		/******************************
		 * 검색영역 출하주 keydown 이벤트
		 * 엔터키 : 출하주 검색 팝업
		 * backspace 또는 delete인 경우 검색영역 농가 코드 삭제
		 ******************************/
		$("#sch_ftsnm").keydown(function(e) {
			// 엔터키인 경우
			if(e.keyCode == 13) {
				this.blur();
				fn_CallFhsPopup(true);
			}
		});
		
		/******************************
		 * 검색영역 출하주 변경 이벤트
		 * 남은 글자 수가 0인 경우 검색영역 농가 코드 삭제
		 ******************************/
		$("#sch_ftsnm").on("propertychange change keyup paste input", function(e) {
			$("#sch_fhs_id_no").val("");
		});

		/******************************
		 * 출하주 변경 이벤트(키업)
		 ******************************/
		$("#ftsnm").on("change keyup paste", function(e){
			if(e.keyCode != 13) {
				$("#fhs_id_no").val("");
				$("#farm_amnno").val("");
				$("#ohse_telno").val("");
				$("#zip").val("");
				$("#dongup").val("").trigger("change");
				$("#dongbw").val("").trigger("change");
				$("#sra_pdmnm").val("");
				$("#sra_pd_rgnnm").val("");
				$("#sog_na_trpl_c").val("");
				$("#io_sogmn_maco_yn").val("");
				$("#sra_farm_acno").val("");
			}
		});

		/******************************
		 * 예방접종일 엔터 이벤트
		 ******************************/
		$("#vacn_dt").keydown(function(e){
			if(e.keyCode == 13 && !fn_isNull($("#vacn_dt").val())) {
				$("#brcl_isp_dt").focus();
			}
		});
		
		/******************************
		 * 자가운송여부 변경 이벤트
		 ******************************/
		$("input[name='trpcs_py_yn']").change(function() {
			fn_TrpcsPyYnModify($(this).val());
		});
		
		$("input[name='rd_trpcs_py_yn']").on("change", function(){
			console.log($(this).val());
			fn_TrpcsPyYnModify($(this).val());
		});
		
		/******************************
		 * 사료사용여부 checkbox 이벤트
		 ******************************/
		$("#sra_fed_spy_yn").change(function() {
			fn_contrChBox($(this).is(":checked"), "sra_fed_spy_yn", "");
			if($(this).is(":checked")) {
				$("#sra_fed_spy_yn_fee").val(parent.envList[0]["SRA_FED_SPY_YN_FEE"]);
				$("#sra_fed_spy_yn_fee").attr("disabled", false);
			}
			else {
				$("#sra_fed_spy_yn_fee").val("0");
				$("#sra_fed_spy_yn_fee").attr("disabled", true);
			}
		});

		/******************************
		 * 예약취소여부 checkbox 이벤트
		******************************/
		$("#recv_can_yn").change(function() {
			fn_contrChBox($(this).is(":checked"), "recv_can_yn", "");
			if ($(this).is(":checked")) {
				$("#recv_can_dt").prop("disabled", false);
				$("#recv_can_dt").datepicker().datepicker("setDate", fn_getToday());
			}
			else {
				$("#recv_can_dt").prop("disabled", true).val("");
			}
		});
		
		/******************************
		 * 제각여부 checkbox 이벤트
		******************************/
		$("#debd_cancel_yn").change(function() {
			fn_contrChBox($(this).is(":checked"), "debd_cancel_yn", "");
		});
		
		/******************************
		 * 친자검사여부 checkbox 이벤트
		 ******************************/
		$("#dna_yn_chk").change(function() {
			fn_contrChBox($(this).is(":checked"), "dna_yn_chk", "");
		});
		
		/******************************
		 * 임신감정여부 checkbox 이벤트
		 ******************************/
		$("#prny_jug_yn").change(function() {
			if($("#prny_jug_yn").is(":checked")) {
				fn_contrChBox(true, "prny_jug_yn", "");
				$("#prny_jug_yn_text").text("여");
			} else {
				fn_contrChBox(false, "prny_jug_yn", "");
				$("#prny_jug_yn_text").text("부");
			}
		});

		/******************************
		 * 사료사용여부 checkbox 이벤트
		 ******************************/
		$("#fed_spy_yn").change(function() {
			if($("#fed_spy_yn").is(":checked")) {
				fn_contrChBox(true, "fed_spy_yn", "");
				$("#fed_spy_yn_text").text("여");
			} else {
				fn_contrChBox(false, "fed_spy_yn", "");
				$("#fed_spy_yn_text").text("부");
			}
		});
		
		/******************************
		 * 모근채취여부 checkbox 이벤트
		 ******************************/
		$("#dna_sampled_yn").change(function() {
			if($("#dna_sampled_yn").is(":checked")) {
				fn_contrChBox(true, "fed_spy_yn", "");
				$("#dna_sampled_yn_text").text("여");
			} else {
				fn_contrChBox(false, "fed_spy_yn", "");
				$("#dna_sampled_yn_text").text("부");
			}
		});
		
		fn_CreateGrid();

	});

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init() {
		//그리드 초기화
		$(".tab_content").hide();
		$(".tab_content:first").show();
		$("#tab2_text").hide();
		
		$("#pb_tab2").removeClass('on');
		$("#pb_tab1").addClass('on');
		
		if(mv_InitBoolean) {
			fn_Reset();
		}
		else {
			MessagePopup('YESNO',"초기화 하시겠습니까?",function(res){
				if(res){
					fn_Reset();
					mv_InitBoolean = true;
					}
				else {
					MessagePopup('OK','취소되었습니다.');
					return;
				}
			});
		}
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search() {
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
		
		var results = sendAjaxFrm("frm_Search", "/LALM0226_selList", "POST");
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
	 * 1. 함 수 명    : 저장 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Save() {
		$("#re_indv_no").val("410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val());

		var srchData		= new Object();
		var result			= null;
		
		if(parseInt(fn_dateToData($("#auc_dt").val())) < parseInt(fn_dateToData($("#afism_mod_dt").val()))) {
			MessagePopup("OK", "인공 수정 일자는 경매 일자보다 클 수 없습니다.");
			return;
		}
		
		//============================================================fn_CheckValidSave Start=========================================================================//
		if(fn_isNull($("#sra_indv_amnno").val())) {
			MessagePopup("OK", "귀표번호가 정확하지 않습니다.");
			return;
		}
		if(("" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val()).length != 12) {
			MessagePopup("OK", "귀표번호는 12자리를 입력하시기 바랍니다.");
			return;
		}
		if($("#indv_sex_c").val().length == 0) {
			MessagePopup("OK", "개체성별코드를 입력하기 바랍니다.");
			return;
		}
		
		console.log($("#fhs_id_no").val(), $("#ftsnm").val());
		if(fn_isNull($("#fhs_id_no").val()) || fn_isNull($("#ftsnm").val())) {
			MessagePopup("OK", "출하주가 정확하지 않습니다.");
			return;
		}
		
		// 수기등록 정합성체크
		if(fn_isNull($("#birth").val())) {
			MessagePopup("OK", "개체 생년월일을 입력하기 바랍니다.");
			return;
		}
		
		if(fn_isNull($("#matime").val())) {
			MessagePopup("OK", "어미산차를 입력하기 바랍니다.");
			return;
		}
		
		if(fn_isNull($("#sra_indv_pasg_qcn").val())) {
			MessagePopup("OK", "개체 계대를 입력하기 바랍니다.");
			return;
		}
		
		if(parseInt(fn_dateToData($("#auc_dt").val())) < parseInt(fn_dateToData($("#auc_recv_dt").val()))) {
			MessagePopup("OK", "접수일자는 경매일자 보다 클수 없습니다.");
			$("#auc_recv_dt").focus();
			return;
		}
		//============================================================fn_CheckValidSave End=========================================================================//

		var saveMessage = "저장 하시겠습니까?";
	
		MessagePopup('YESNO', saveMessage, function(res){
			
			if(res) {
				// 추가운송비
				if(fn_isNull($("#sra_trpcs").val())) {
					$("#sra_trpcs").val("0");
				}
				// 사료대금
				if(fn_isNull($("#sra_fed_spy_am").val())) {
					$("#sra_fed_spy_am").val("0");
				}
				if(setRowStatus == "insert") {
					$("#chg_rmk_cntn").val("최초 저장 등록");
					$("#chg_del_yn").val("0");
					
					srchData["frm_MhSogCow"]	= setFrmToData("frm_MhSogCow");
					
					result = sendAjax(srchData, "/LALM0226_insPgm", "POST");
					
					if(result.status == RETURN_SUCCESS){
						MessagePopup("OK", "저장되었습니다.",function(res){
							mv_RunMode = 3;
							mv_auc_dt = $("#auc_dt").val();
							mv_auc_obj_dsc = $("#auc_obj_dsc").val();
							mv_InitBoolean = true;
							fn_Init();
							fn_Search();
						});
					}
					else {
						showErrorMessage(result);
						mv_InitBoolean = true;
						fn_Init();
						return;
					}
				}
				else if(setRowStatus == "update") {
					$("#chg_rmk_cntn").val("수정로그");
					$("#chg_del_yn").val("0");
					srchData["frm_MhSogCow"]	= setFrmToData("frm_MhSogCow");
					
					result = sendAjax(srchData, "/LALM0226_updPgm", "POST");
					
					if(result.status == RETURN_SUCCESS){
						MessagePopup("OK", "저장되었습니다.",function(res){
							mv_RunMode = 3;
							mv_auc_dt = $("#auc_dt").val();
							mv_auc_obj_dsc = $("#auc_obj_dsc").val();
							
							if(fn_isNull($("gvno_bascd").val())) {
								mv_gvno_bascd = 0;
							} else {
								mv_gvno_bascd = $("#gvno_bascd").val();
							}
							mv_lvst_mkt_trpl_amnno = $("#lvst_mkt_trpl_amnno").val();
							
							mv_InitBoolean = true;
							fn_Init();
							fn_Search();
						});
				
					}
					else {
						showErrorMessage(result);
						return;
					}
				}
				
			}
			else {
				MessagePopup('OK','취소되었습니다.');
				return;
			}
		});
	}
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////
	//  사용자 함수 시작
	////////////////////////////////////////////////////////////////////////////////
	//**************************************
	// function  : fn_GridCboxFormat(그리드 돋보기 버튼) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_GridCboxFormat(val, options, rowdata) {
		var gid = options.gid;
		var rowid = options.rowId;
		var colkey = options.colModel.name;
		return '<button id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popSearch(\'' + rowid + '\',\'' + colkey + '\'); return false;" class="tb_btn white srch"><i class="fa fa-search"></i></button>';
	}
	
	//**************************************
	// function  : fn_GridCboxFormat(그리드 검색 버튼) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_GridCboxFormat2(val, options, rowdata) {
		var gid = options.gid;
		var rowid = options.rowId;
		var colkey = options.colModel.name;
		return '<button class="tb_btn" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popSearch2(\'' + rowid + '\',\'' + colkey + '\'); return false;">개체이력조회</button>';
	}
	
	//**************************************
	// function  : fn_popInfHstPopup(귀표번호 인터페이스 버튼 이벤트) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_popInfHstPopup(chkBool){
		var checkBoolean = chkBool;
		var cheackParam = "410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val();
		var data =  new Object;
		
		data["sra_indv_amnno"] = cheackParam;
		
		fn_CallIndvInfHstPopup(data, checkBoolean, function(result){
			if(result){
// 				if(chkBool == true) {
// 					var results = sendAjax(result, "/LALM0222P_updReturnValue", "POST");
// 					var returnVal;
					
// 					if(results.status != RETURN_SUCCESS) {
// 						showErrorMessage(results);
// 						return;
// 					}
// 					else {
// 						returnVal = setDecrypt(results);
// 						$("#sra_srs_dsc").val(returnVal[0].SRA_SRS_DSC);
						
// 						if(!fn_isNull(returnVal[0].SRA_INDV_AMNNO)) {
// 							$("#hed_indv_no").val()
// 							$("#sra_indv_amnno").val(returnVal[0].SRA_INDV_AMNNO.substr(6, 12));
// 						}
						
// 						$("#fhs_id_no").val(returnVal[0].FHS_ID_NO);
// 						$("#farm_amnno").val(returnVal[0].FARM_AMNNO);
// 						$("#ftsnm").val(fn_xxsDecode(returnVal[0].FTSNM));
						
// 						if(!fn_isNull(returnVal[0].CUS_MPNO)) {
// 							$("#ohse_telno").val(returnVal[0].CUS_MPNO);
// 						}
// 						else {
// 							$("#ohse_telno").val(returnVal[0].OHSE_TELNO);
// 						}
						
// 						if(!fn_isNull(returnVal[0].ZIP)) {
// 							$("#zip").val(returnVal[0].ZIP.substr(0, 3) + "-" + returnVal[0].ZIP.substr(3, 3));
// 						}
						
// 						$("#dongup").val(fn_xxsDecode(returnVal[0].DONGUP)).trigger("change");
// 						$("#dongbw").val(fn_xxsDecode(returnVal[0].DONGBW)).trigger("change");
// 						$("#sra_pdmnm").val(fn_xxsDecode(returnVal[0].FTSNM));
// 						$("#sra_pd_rgnnm").val(fn_xxsDecode(returnVal[0].DONGUP));
// 						$("#sog_na_trpl_c").val(returnVal[0].NA_TRPL_C);
// 						$("#indv_sex_c").val(returnVal[0].INDV_SEX_C);
// 						$("#birth").val(fn_toDate(returnVal[0].BIRTH)).trigger("change");
// 						$("#indv_id_no").val(returnVal[0].INDV_ID_NO);
// 						$("#sra_indv_brdsra_rg_no").val(returnVal[0].SRA_INDV_BRDSRA_RG_NO);
// 						$("#rg_dsc").val(returnVal[0].RG_DSC);
// 						$("#kpn_no").val(returnVal[0].KPN_NO);
// 						$("#mcow_dsc").val(returnVal[0].MCOW_DSC);
// 						$("#mcow_sra_indv_amnno").val(returnVal[0].MCOW_SRA_INDV_AMNNO);
						
// 						if(!fn_isNull(returnVal[0].MATIME)) {
// 							$("#matime").val(parseInt(returnVal[0].MATIME));
// 						}
						
// 						if(!fn_isNull(returnVal[0].SRA_INDV_PASG_QCN)) {
// 							$("#sra_indv_pasg_qcn").val(parseInt(returnVal[0].SRA_INDV_PASG_QCN));
// 						}
						
// 						$("#io_sogmn_maco_yn").val(returnVal[0].MACO_YN);
// 						$("#sra_farm_acno").val(returnVal[0].SRA_FARM_ACNO);
// 					}
// 				}
// 				else {
					$("#sra_srs_dsc").val(result.SRA_SRS_DSC);
					
					if(!fn_isNull(result.SRA_INDV_AMNNO)) {
						$("#sra_indv_amnno").val(result.SRA_INDV_AMNNO.substr(6, 12));
					}
					
					$("#fhs_id_no").val(result.FHS_ID_NO).prop("disabled", false);
					$("#farm_amnno").val(result.FARM_AMNNO).prop("disabled", false);
					$("#ftsnm").val(fn_xxsDecode(result.FTSNM)).prop("disabled", false);
					
					if(!fn_isNull(result.CUS_MPNO)) {
						$("#ohse_telno").val(result.CUS_MPNO);
					} else {
						$("#ohse_telno").val(result.OHSE_TELNO);
					}
					
					if(!fn_isNull(result.ZIP)) {
						$("#zip").val(result.ZIP.substr(0, 3) + "-" + result.ZIP.substr(3, 3));
					}
					
					$("#dongup").val(fn_xxsDecode(result.DONGUP)).trigger("change");
					$("#dongbw").val(fn_xxsDecode(result.DONGBW)).trigger("change");
					$("#sra_pdmnm").val(fn_xxsDecode(result.FTSNM));
					$("#sra_pd_rgnnm").val(fn_xxsDecode(result.DONGUP));
					$("#sog_na_trpl_c").val(result.NA_TRPL_C);
					$("#indv_sex_c").val(result.INDV_SEX_C);
					$("#birth").val(fn_toDate(result.BIRTH)).trigger("change");
					$("#indv_id_no").val(result.INDV_ID_NO);
					$("#sra_indv_brdsra_rg_no").val(result.SRA_INDV_BRDSRA_RG_NO);
					$("#rg_dsc").val(result.RG_DSC);
					$("#kpn_no").val(result.KPN_NO);
					$("#mcow_dsc").val(result.MCOW_DSC);
					$("#mcow_sra_indv_amnno").val(result.MCOW_SRA_INDV_AMNNO);
					
					if(!fn_isNull(result.MATIME)) {
						$("#matime").val(parseInt(result.MATIME));
					}
					
					if(!fn_isNull(result.SRA_INDV_PASG_QCN)) {
						$("#sra_indv_pasg_qcn").val(parseInt(result.SRA_INDV_PASG_QCN));
					}
					
					$("#io_sogmn_maco_yn").val(result.MACO_YN);
					$("#sra_farm_acno").val(result.SRA_FARM_ACNO);
// 				}
				
				// 브루셀라검사 조회
				fn_CallBrclIspSrch();
				// 친자확인 조회
				fn_CallLsPtntInfSrch();
				//유전체 분석 조회
				fn_CallGeneBredrInfSrch();
				// 해당 출장우의 분만정보 조회
				fn_SelBhCross();
			}
		});
	}
	
	//**************************************
	// function  : fn_Reset(초기화 후 기본셋팅) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_Reset() {
		
		$("#pb_Indvfhs").show();
		$("#chk_AucNoChg").show();
		
		fn_InitSet();

		if ($("#chack_on").is(":checked")) {
			$("#auc_prg_sq").focus().select();
		}
		else {
			$("#sra_indv_amnno").focus();
		}
	}
	
	//**************************************
	// function  : fn_InitRadioSet(라디오버튼 기본셋팅) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_InitRadioSet() {
		fn_setChgRadio("auc_obj_dsc", "1");
		fn_setRadioChecked("auc_obj_dsc");
		$("#auc_obj_dsc").val("1");
		$("input[name='rd_gvno_bascd']:radio[value='0']").prop("checked", true);
		$("#gvno_bascd").val("0");
	}

	//**************************************
	// function  : fn_InitSet(초기화 후 기본셋팅) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_InitSet() {
		if(pageInfos.param != null) {
			$("#auc_recv_dt").val(fn_getToday());
			$("#birth").datepicker();
			$("#afism_mod_dt").datepicker().datepicker("setDate", fn_getToday());
			$("#auc_dt").val(pageInfos.param.auc_dt);
			$("#auc_obj_dsc").val(pageInfos.param.auc_obj_dsc);
			
			// 개체 검색을 위한 hidden form 세팅
			$("#hdn_auc_recv_dt").val(pageInfos.param.auc_recv_dt);
			$("#hdn_auc_recv_no").val(pageInfos.param.auc_recv_no);
			$("#hdn_auc_obj_dsc").val(pageInfos.param.auc_obj_dsc);
			
			fn_setChgRadio("auc_obj_dsc", pageInfos.param.auc_obj_dsc);
			fn_setRadioChecked("auc_obj_dsc");

			// 사용자가 등록 권한이 있는 경우에만 경매일자 datepicker 활성화 
			if (isRegAuth) {
				$("#auc_dt").datepicker();
			}
			
			mv_RunMode = 1;
			fn_AucOnjDscModify("init");
			
			mv_RunMode = 2;
			fn_SelInfo();
		}
		else {
			// 실행모드 설정 (Window.mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정)
			mv_RunMode = 1;
		}
		
		if(mv_RunMode == 1) {
			$("#sra_indv_amnno").attr("disabled", false);
			$("#pb_sra_indv_amnno").attr("disabled", false);
			$("#pb_IndvHst").attr("disabled", false);
			$("#pb_sra_indv_amnno").attr("disabled", false);
			
			mv_flg = "init";
			mv_vhc_shrt_c = $("#vhc_shrt_c").val();
			mv_vhc_drv_caffnm = $("#vhc_drv_caffnm").val();
			
			// 폼 초기화
			fn_InitFrm('frm_MhSogCow');
			
			// 사용자가 등록 권한이 있는 경우에만 경매일자 datepicker 활성화 
			if (isRegAuth) {
				$("#auc_dt").datepicker();
			}
			
			fn_DisableAuc(false);
			
			setRowStatus = "insert";
			
			fn_ClearCal("init");
			
// 			$("#auc_dt").val(mv_auc_dt);											// 경매일자
			$("#auc_obj_dsc").val(mv_auc_obj_dsc);									// 경매대상
			$("#birth").datepicker();												// 생년월일
			$("#vhc_shrt_c").val(mv_vhc_shrt_c); 									// 수송자
			$("#vhc_drv_caffnm").val(mv_vhc_drv_caffnm); 							// 수송자명
			$("#auc_recv_dt").val(fn_getToday());									// 접수일자
			$("#dna_yn").val("3");													// 친자확인결과
			
			fn_TrpcsPyYnModify("0");
			
			mv_flg = "";
			
			// 경매대상 관련 초기 셋팅
			fn_AucOnjDscModify("init");
			
			$("#hed_indv_no").val("002");
			$("#sra_indv_amnno").focus();
		}
		else {
			$("#btn_Save").attr("disabled", false);
			$("#btn_Delete").attr("disabled", false);
			
			$("#hed_indv_no").attr("disabled", true);
			$("#sra_indv_amnno").attr("disabled", true);
			$("#pb_IndvHst").attr("disabled", true);
			$("#pb_sra_indv_amnno").attr("disabled", true);
			// 사용자가 등록 권한이 있는 경우에만 경매일자 datepicker 활성화
			if (!isRegAuth) $("#auc_dt").datepicker("destroy");
			
			fn_DisableAuc(true);
			
			// 송아지
			if($("#auc_obj_dsc").val() == "1") {
				$("#firstBody").hide();
			// 비육우	
			}
			else if($("#auc_obj_dsc").val() == "2") {
				$("#firstBody").hide();
			// 번식우
			}
			else if($("#auc_obj_dsc").val() == "3") {
				$("#firstBody").show();
			}
			
			if($("#trpcs_py_yn").val() == "0") {
				$("#sra_trpcs").attr("disabled", true);
				$("#vhc_drv_caffnm").attr("disabled", true);
			}
			else {
				$("#sra_trpcs").attr("disabled", false);
				$("#vhc_drv_caffnm").attr("disabled", false);
			}
			
		}
		
		if($("#auc_obj_dsc").val() == "3") {
			// 번식우
			if($("#ppgcow_fee_dsc").val() == "1" ||  $("#ppgcow_fee_dsc").val() == "3") {
				fn_contrChBox(true, "prny_jug_yn", "");
			}
			else {
				fn_contrChBox(false, "prny_jug_yn", "");
			}
		}
		
		if(fn_isNull($("#auc_recv_dt").val())) {
			$("#auc_recv_dt").datepicker().datepicker("setDate", fn_getToday());
		}

	}
	
	//**************************************
	// function  : fn_SetData(조회된 데이터 바인딩) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_SetData(result) {
		// -------------------- 출장우 정보 [s] -------------------- //
		// 경매대상
		$("#rd_auc_obj_dsc").val(result[0]["rd_auc_obj_dsc"]);
		// 접수일자
		if(fn_isDate(result[0]["AUC_RECV_DT"])) {
			$("#auc_recv_dt").val(fn_toDate(result[0]["AUC_RECV_DT"]));
		}
		// 접수번호
		$("#auc_recv_no").val(result[0]["AUC_RECV_NO"]);
		// 예약취소여부
		if(result[0]["RECV_CAN_YN"] == "1") {
			fn_contrChBox(true, "recv_can_yn", "");
		}
		else {
			fn_contrChBox(false, "recv_can_yn", "");
		}
		// 예약취소일자
		if(fn_isDate(result[0]["RECV_CAN_DT"])) {
			$("#recv_can_dt").val(fn_toDate(result[0]["RECV_CAN_DT"]));
		}
		
		// 귀표번호1X 410 고정
		$("#hed_indv_no").val(result[0]["SRA_INDV_AMNNO"].substring(3, 6));
		$("#sra_indv_amnno").val(result[0]["SRA_INDV_AMNNO"].substring(6, 15));
		// 경매일자
		if(fn_isDate(result[0]["AUC_DT"])) {
			$("#auc_dt").val(fn_toDate(result[0]["AUC_DT"]));
		}
		// 제각여부
		if(result[0]["DEBD_CANCEL_YN"] == "1") {
			fn_contrChBox(true, "debd_cancel_yn", "");
		}
		else {
			fn_contrChBox(false, "debd_cancel_yn", "");
		}
		// 자가, 운송협회에 따른 수송자 + 추가 수송비용
		// 운송협회
		if(result[0]["TRPCS_PY_YN"] == "1") {
			$("#vhc_shrt_c").val(result[0]["VHC_SHRT_C"]);
			$("#vhc_drv_caffnm").val(result[0]["VHC_DRV_CAFFNM"]);
			fn_setChgRadio("trpcs_py_yn", "1");
			
			$("#vhc_drv_caffnm").attr("disabled", true);
			$("#pb_vhc_drv_caffnm").attr("disabled", true);
			$("#sra_trpcs").attr("disabled", true);
			if(fn_isNull(result[0]["SRA_TRPCS"])) {
				$("#sra_trpcs").val("0");
			}
			else {
				$("#sra_trpcs").val(result[0]["SRA_TRPCS"]);
			}
		}
		else {
			fn_setChgRadio("trpcs_py_yn", "0");
			$("#vhc_drv_caffnm").attr("disabled", false);
			$("#pb_vhc_drv_caffnm").attr("disabled", false);
			$("#sra_trpcs").attr("disabled", false);
		}
		$("#trpcs_py_yn").trigger("change");
		
		// 비고
		$("#rmk_cntn").val(fn_xxsDecode(result[0]["RMK_CNTN"]));
		
		// 사료대금
		if(fn_isNull(result[0]["SRA_FED_SPY_AM"])) {
			$("#sra_fed_spy_am").val("0");
		} else {
			$("#sra_fed_spy_am").val(result[0]["SRA_FED_SPY_AM"]);
		}
		// 브루셀라검사
		if(fn_isDate(result[0]["BRCL_ISP_DT"])) {
			$("#brcl_isp_dt").val(fn_toDate(result[0]["BRCL_ISP_DT"]))
		}
		$("#brcl_isp_dt").datepicker();
		
		// 예방접종일
		if(fn_isDate(result[0]["VACN_DT"])) {
			$("#vacn_dt").val(fn_toDate(result[0]["VACN_DT"])).datepicker();;
		}
		$("#vacn_dt").datepicker();
		
		// 친자감정여부
		if(result[0]["DNA_YN_CHK"] == "1") {
			fn_contrChBox(true, "dna_yn_chk", "");
		}
		else {
			fn_contrChBox(false, "dna_yn_chk", "");
		}
		// 친자확인결과
		$("#dna_yn").val(result[0]["DNA_YN"]);
		// 모근채취여부
		if(result[0]["DNA_SAMPLED_YN"] == "1") {
			fn_contrChBox(true, "dna_sampled_yn", "");
		}
		else {
			fn_contrChBox(false, "dna_sampled_yn", "");
		}
		// -------------------- 출장우 정보 [e] -------------------- //
		
		// -------------------- 개체 정보 [s]-------------------- //
		// 성별
		$("#indv_sex_c").val(result[0]["INDV_SEX_C"]);
		// 생년월일
		if(fn_isDate(result[0]["BIRTH"])) {
			$("#birth").val(fn_toDate(result[0]["BIRTH"])).trigger("change");
		}
		// 어미구분
		$("#mcow_dsc").val(result[0]["MCOW_DSC"]);
		// 어미귀표번호
		$("#mcow_sra_indv_amnno").val(result[0]["MCOW_SRA_INDV_AMNNO"]);
		// 개체관리번호
		$("#indv_id_no").val(result[0]["INDV_ID_NO"]);
		// 개체등록번호
		$("#sra_indv_brdsra_rg_no").val(result[0]["SRA_INDV_BRDSRA_RG_NO"]);
		// 등록구분
		$("#rg_dsc").val(result[0]["RG_DSC"]);
		// 산차
		$("#matime").val(result[0]["MATIME"]);
		// 계대
		$("#sra_indv_pasg_qcn").val(result[0]["SRA_INDV_PASG_QCN"]);
		// KPN번호
		$("#kpn_no").val(result[0]["KPN_NO"]);
		// -------------------- 개체 정보 [e]-------------------- //
		
		// -------------------- 출하주 정보 [s]-------------------- //
		// 농가관리번호
		$("#fhs_id_no").val(result[0]["FHS_ID_NO"]);
		// 농장관리번호
		$("#farm_amnno").val(result[0]["FARM_AMNNO"]);
		// 출하주명
		$("#ftsnm").val(fn_xxsDecode(result[0]["FTSNM"]));
		// 자택전화번호
		$("#ohse_telno").val(result[0]["OHSE_TELNO"]);
		// 핸드폰번호
		$("#cus_mpno").val(result[0]["CUS_MPNO"]);
		// 사료사용여부
		if(result[0]["SRA_FED_SPY_YN"] == "1") {
			fn_contrChBox(true, "sra_fed_spy_yn", "");
		} else {
			fn_contrChBox(false, "sra_fed_spy_yn", "");
		}
		// 주소
		$("#zip").val(result[0]["ZIP"]);
		$("#dongup").val(fn_xxsDecode(result[0]["DONGUP"]));
		$("#dongbw").val(fn_xxsDecode(result[0]["DONGBW"]));
		// 지역구분
		$("#loc_gb").val(result[0]["LOC_GB"]);
		
		// 계좌번호
		$("#sra_farm_acno").val(result[0]["SRA_FARM_ACNO"]);
		// -------------------- 출하주 정보 [e]-------------------- //

		// -------------------- 번식우 정보 [s]-------------------- //
		if($("#rd_auc_obj_dsc").val() == "3") {
			// 임신구분
			$("#ppgcow_fee_dsc").val(result[0]["PPGCOW_FEE_DSC"]).trigger("change");
			// 인공수정일
			if(fn_isDate(result[0]["AFISM_MOD_DT"])) {
				$("#afism_mod_dt").val(fn_toDate(result[0]["AFISM_MOD_DT"]));
			}
			else{
				$("#afism_mod_dt").val('');
			}
			// 수정KPN
			$("#mod_kpn_no").val(result[0]["MOD_KPN_NO"]);
			// 분만예정일
			if(fn_isDate(result[0]["PTUR_PLA_DT"])) {
				$("#ptur_pla_dt").val(fn_toDate(result[0]["PTUR_PLA_DT"]));
			}
			else{
				$("#ptur_pla_dt").val('');
			}
			// 임신개월수
			if(fn_isNull(result[0]["PRNY_MTCN"])) {
				$("#prny_mtcn").val("0");
			}
			else {
				$("#prny_mtcn").val(result[0]["PRNY_MTCN"]);
			}
			// 임신감정여부
			if(result[0]["PRNY_JUG_YN"] == "1") {
				fn_contrChBox(true, "prny_jug_yn", "");
			}
			else {
				fn_contrChBox(false, "prny_jug_yn", "");
			}
			// 괴사감정여부
			if(result[0]["NCSS_JUG_YN"] == "1") {
				fn_contrChBox(true, "ncss_jug_yn", "");
			}
			else {
				fn_contrChBox(false, "ncss_jug_yn", "");
			}
			
			$("#ccow_sra_indv_amnno").val(result[0]["CCOW_SRA_INDV_AMNNO"]);			// 딸린 송아지귀표번호
		}
		// -------------------- 번식우 정보 [e]-------------------- //
		
		// -------------------- 히든 정보 [s]-------------------- //
		$("#oslp_no").val(result[0]["OSLP_NO"]);
		$("#led_sqno").val(result[0]["LED_SQNO"]);
		$("#sog_na_trpl_c").val(result[0]["SOG_NA_TRPL_C"]);
		$("#sra_farm_acno").val(result[0]["SRA_FARM_ACNO"]);
		$("#hd_auc_prg_sq").val($("#auc_prg_sq").val());
		// -------------------- 히든 정보 [s]-------------------- //

		setRowStatus = "update";

		if(pageInfos.param != null) {
			fn_setChgRadio("auc_obj_dsc", pageInfos.param.auc_obj_dsc);
// 			fn_setRadioChecked("auc_obj_dsc");
			pageInfos.param = null;
		}
		
		if(fn_isNull($("#brcl_isp_dt").val())) {
			// 브루셀라검사 조회
			fn_CallBrclIspSrch();
		}
	}
	
	//**************************************
	// function  : fn_SelInfo(조회) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_SelInfo() {
		if(mv_RunMode == 1) {
			mv_InitBoolean = true;
			fn_Init();
		}
		else {
			var results = sendAjaxFrm("frm_Hdn", "/LALM0226_selInfo", "POST");
			var result;
			
			if(results.status == RETURN_SUCCESS){
				result = setDecrypt(results);
				fn_SetData(result);
			}
			else {
				showErrorMessage(results);
				mv_InitBoolean = true;
				fn_Init();
				$("#btn_Delete").attr("disabled", true);
				return;
			}
		}
	}
	
	//**************************************
	// function  : fn_ClearCal(달력 초기값 셋팅) 
	// paramater : p_param(구분자) ex) "init" 
	// result   : N/A
	//**************************************
	function fn_ClearCal(p_param) {
		$("#auc_recv_dt").val(fn_getToday());		// 접수일자
// 		$("#auc_dt").datepicker().datepicker("setDate", fn_getToday());				// 경매일자
		$("#brcl_isp_dt").datepicker().datepicker("setDate", fn_getToday());		// 브루셀라검사
		$("#vacn_dt").datepicker().datepicker("setDate", fn_getToday());			// 예방접종일
 		$("#afism_mod_dt").datepicker().datepicker("setDate", fn_getToday());
	}

	//**************************************
	// function  : fn_AucOnjDscModify(경매대상 수정 시 변경) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_AucOnjDscModify(flag) {
		fn_FrmClear();
		var tmp_check_val = $("#auc_obj_dsc").val();
		
		if(tmp_check_val == 3) {
			$("#firstBody").show();
			$("#ppgcow_fee_dsc").val("1");
			fn_contrChBox(true, "prny_jug_yn", "");
		}
		else {
			$("#firstBody").hide();
			$("#ppgcow_fee_dsc").val("5");
		}
		
		if(tmp_check_val == 1) {
			if (!isRegAuth) {
				$("#auc_dt").prop("readonly", true).datepicker("setDate", "").datepicker("destroy");
			}
			else {
				$("#auc_dt").prop("readonly", false).datepicker().datepicker("setDate", "");;
			}
		}
		else {
			$("#auc_dt").datepicker().datepicker("setDate", "");
			$("#auc_dt").prop("readonly", false);
		}
	}
	
	//**************************************
	// function  : fn_AfismModDtModify(경매일자 수정 시 변경) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_AfismModDtModify() {
		// 6. 분만예정일 = 인공수정일자 + 285
		if(!fn_isNull($("#afism_mod_dt").val()) && !fn_isNull($("#auc_dt").val())) {
			$("#ptur_pla_dt").val(fn_getAddDay($("#afism_mod_dt").val(), 285));
			$("#prny_mtcn").val(parseInt(fn_SpanDay($("#afism_mod_dt").val(), $("#auc_dt").val(), "Month")) + 1);
		}
	}
	
	//**************************************
	// function  : fn_TrpcsPyYnModify(자가운송여부 수정 시 변경) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_TrpcsPyYnModify(val) {
		fn_setChgRadio("trpcs_py_yn", val);
		// trpcs_py_yn 가 추가운송비 부과 여부를 함 따라서 값이 1인 경우 수송자 검색을 활성화 
		if(val == "1") {
			$("#vhc_drv_caffnm").prop("disabled", false);
			$("#pb_vhc_drv_caffnm").prop("disabled", false);
			$("#sra_trpcs").prop("disabled", false);
			$("#sra_trpcs").val("");
		} else {
			$("#vhc_drv_caffnm").prop("disabled", true);
			$("#pb_vhc_drv_caffnm").prop("disabled", true);
			$("#sra_trpcs").prop("disabled", true);
			$("#vhc_shrt_c").val("");
			$("#vhc_drv_caffnm").val("");
			$("#sra_trpcs").val("0");
		}
	}
	
	//**************************************
	// function  : fn_FrmClear(Frm Clear) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_FrmClear() {
		// 경매일(auc_dt),경매대상(rd_auc_obj_dsc), 접수일자(auc_recv_dt)를 제외한 나머지 항목 초기화
		var tmpAucDt		= $("#auc_dt").val();
		var tmpAucObjDsc	= $("#auc_obj_dsc").val();
		var tmpAucRecvDt	= $("#auc_recv_dt").val();
		
		// 폼 초기화
		fn_InitFrm('frm_MhSogCow');
// 		$("#auc_dt").val(tmpAucDt);
		$("#auc_recv_dt").val(tmpAucRecvDt);
		$("#auc_obj_dsc").val(tmpAucObjDsc);
		fn_setChgRadio("auc_obj_dsc", tmpAucObjDsc);
		$("#dna_yn").val("3");
		fn_TrpcsPyYnModify("0");
		$("#hed_indv_no").val("002")
	}
	
	//**************************************
	// function  : fn_DisableAuc(경매대상 Disable 및 Enable) 
	// paramater : p_boolean(disable) ex) true 
	// result   : N/A
	//**************************************
	function fn_DisableAuc(p_boolean){
		// 신규등록 또는 수정여부에 따라 경매대상을 disable 또는 enable 전환
		var rd_length = $("input[name='auc_obj_dsc_radio']").length;
		var disableItem = $("input[name='auc_obj_dsc_radio']");

		for(var i=0; i<rd_length; i++){
			itemNames = $(disableItem[i]).attr("id");
			if(p_boolean) {
				$("#"+itemNames).attr("disabled", true);
			}
			else {
				$("#"+itemNames).attr("disabled", false);
			}
		}
	}
	
	//**************************************
	// function  : fn_CallBrclIspSrch(브루셀라검사 조회) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_CallBrclIspSrch() {
		if ($("#brcl_chk_yn").val() != "0") return;
		
		var srchData = new Object();
		var P_sra_indv_amnno = "";
		
		if($("#sra_indv_amnno").val().replace("-", "").length == 9) {
			P_sra_indv_amnno = "410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");
		}
		else {
			MessagePopup('OK','귀표번호를 확인하세요.',null,function(){
				$("#sra_indv_amnno").focus();
			});
			return;
		}
		
		srchData["trace_no"]	= P_sra_indv_amnno;
		srchData["option_no"]	= "7";
		
		var results = sendAjax(srchData, "/LALM0899_selRestApi", "POST");
		var result;
		
		if(results.status != RETURN_SUCCESS) {
			$("#brcl_isp_rzt_c").val("9");
			return;
		}
		else {
			result = setDecrypt(results);
			$("#brcl_isp_dt").val(fn_toDate($.trim(result["insepctDt"])));
		}
	}

	//**************************************
	// function  : fn_CallLsPtntInfSrch(축산연구원 친자확인 조회 인터페이스) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_CallLsPtntInfSrch() {
		var P_sra_indv_amnno = "";
		
		if($("#sra_indv_amnno").val().replace("-", "").length == 9) {
			P_sra_indv_amnno = "410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");
		}
		else {
			MessagePopup('OK','귀표번호를 확인하세요.',null,function(){
				$("#sra_indv_amnno").focus();
			});
			return;
		}

		//개체이력정보
		var srchData = new Object();
		var results = null;
		var result = null;
		
		srchData["ctgrm_cd"]     = "4300";
		srchData["rc_na_trpl_c"] = "8808990768700";
		srchData["indv_id_no"]   = P_sra_indv_amnno;
		
		results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
		
		if(results.status != RETURN_SUCCESS) {
			MessagePopup('OK','친자확인 데이터 조회 실패.',null,function(){
				$("#dna_yn").val("3");
			});
		}
		else {
			result = setDecrypt(results);
			if(fn_isNull($.trim(result.LS_PTNT_DSC))) {
				$("#dna_yn").val("3");
			}
			else if(result.LS_PTNT_DSC != "00" && result.LS_PTNT_DSC != "10" && result.LS_PTNT_DSC != "11" && result.LS_PTNT_DSC != "12" && result.LS_PTNT_DSC != "13") {
				$("#dna_yn").val("3");
			}
			else {
				if(result.LS_PTNT_DSC == "00"){
					$("#dna_yn").val("1");
				}
				else if(result.LS_PTNT_DSC == "10"){
					$("#dna_yn").val("2");
				}
				else if(result.LS_PTNT_DSC == "11"){
					$("#dna_yn").val("4");
				}
				else if(result.LS_PTNT_DSC == "12"){
					$("#dna_yn").val("5");
				}
				else if(result.LS_PTNT_DSC == "13"){
					$("#dna_yn").val("6");
				}
			}
		}
	}
	
	//**************************************
	// function  : fn_SelBhCross(교배정보 조회 인터페이스) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_SelBhCross() {
		if ($("#auc_obj_dsc").val() != "3") return;												// 번식우가 아닌 경우
		if ($("#ppgcow_fee_dsc").val() != "1" && $("#ppgcow_fee_dsc").val() != "3") return;		// 임신우, 임신우+송아지가 아닌 경우
		
		var srchData = new Object();
		var resultsBhCross = null;
		var resultBhCross = null;
		
		srchData["ctgrm_cd"]  = "2400";
		srchData["mcow_sra_indv_eart_no"] = "410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val();
		resultsBhCross = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
		if(resultsBhCross.status != RETURN_SUCCESS){
			showErrorMessage(resultsBhCross,'NOTFOUND');
			return;
		}
		else {
			resultBhCross = setDecrypt(resultsBhCross);
			if (resultBhCross.length > 0) {
				console.log(resultBhCross)
			}
		}
	}

	//**************************************
	// function  : maxLengthCheck(바이트 문자 입력가능 문자수 체크) 
	// paramater : id(tag id), title(tag title), maxLength(최대 입력가능 수 byte)
	// result   : Boolean
	//**************************************
	function maxLengthCheck(id, title, maxLength) {
		var obj = $("#"+id);
		if(maxLength == null) {
			maxLength = obj.attr("maxLength") != null ? obj.attr("maxLength") : 100;
		}
		if(Number(byteCheck(obj)) > Number(maxLength)) {
			MessagePopup("OK", title + "이(가) 입력가능문자수를 초과하였습니다. \n (영문, 숫자, 일반 특수문자 : " + maxLength + " / 한글, 한자, 기타 특수문자 : " + parseInt(maxLength/2, 10) + ").",function(res){
				obj.focus();
				return false;
			});
			
		} else {
			return true;
		}
	}
	
	//**************************************
	// function  : byteCheck(바이트수 반환) 
	// paramater : el(tag jquery object)
	// result   : number
	//**************************************
	function byteCheck(el) {
		var codeByte = 0;
		var Encode = fn_xxsEncode(el.val());
		for (var i = 0; i < Encode.length; i++) {
			var oneChar = Encode.charAt(i);
			var uniChar = escape(oneChar);
			if(uniChar.length == 1) {
				codeByte ++;
			} else if(uniChar.indexOf("%u") != -1) {
				codeByte += 2;
			} else if(uniChar.indexOf("%") != -1) {
				codeByte ++;
			} else {
				codeByte ++;
			}
		}
		return codeByte;
	}
	
	//**************************************
	// function  : fn_xxsEncode(특수문자 치환) 
	// paramater : p_str
	// result   : result
	//**************************************
	function fn_xxsEncode(p_str){
		var result = "";
		if(p_str != null && typeof p_str == 'string' && p_str != ""){
			result = p_str;
			result = result.replace("&", "/&amp");
			result = result.replace("#", "/&#35");
			result = result.replace("<", "/&lt");
			result = result.replace(">", "/&gt");
			result = result.replace("(", "/&#40");
			result = result.replace(")", "/&#41");
			result = result.replace("\"", "/&quot");
			result = result.replace("'", "/&#x27");
			return result;
		}
		else{
			return p_str;
		}
	}
	
	/*******************************
	 * 경매일자 자동 변경 이벤트
	 * 합천축협 송아지 경매일자 결정 방식
	 * 1. 수송아지 7개월령이 넘기 직전의 목요일, 암송아지 8개월령이 넘기 직전의 목요일 (두번째, 네번째)
	 * 2. 25일 ~ 9일 출생 송아지는 네번째 목요일, 10일 ~ 24일 출생 송아지는 두번째 목요일 (deprecated)
	 * 
	 * 변경 이력
	 * -------------------------------------------------------------------------------------------------------------------------------------
	 *  변경일자  ||                                            변경내역                                            ||      요청자        
	 * -------------------------------------------------------------------------------------------------------------------------------------
	 * 2022.11.16 || 25일 ~ 9일 출생 송아지는 네번째 목요일, 10일 ~ 24일 출생 송아지는 두번째 목요일 조건 삭제 요청 || 합천축협 박미정 과장
	 *            || 수송아지 7개월령이 넘기 직전의 목요일, 암송아지 8개월령이 넘기 직전의 목요일 (두번째, 네번째)  || 합천축협 박미정 과장
	 *            || 추후 두번째, 세번째, 네번째 목요일로 변경 가능한지 확인요청                                    || 합천축협 박미정 과장
	 *            || 수송아지 7개월령 -> 6개월령 15일, 암송아지 8개월령 -> 7개월령 15일로 변경 가능한지 확인 요청   || 합천축협 박미정 과장
	 * -------------------------------------------------------------------------------------------------------------------------------------
	*******************************/
	function fn_setAucDt() {
		if (fn_isDate($("#birth").val())) {
			var feCow	= ["1", "6"];											// 암송아지 > 성별이 암 또는 프리마틴
			var mtcn	= feCow.includes($("#indv_sex_c").val()) ? 8 : 7;		// 암송아지면 8개월령 수송아지면 7개월령
			var birth	= dayjs($("#birth").val());								// 입력한 생년월일
			var aucDtSt	= birth.add((mtcn-1), "month");							// 입력한 생년월일을 기반으로 경매기간 시작 계산 
			var aucDtEn	= birth.add(mtcn, "month").add(-1, "day");				// 입력한 생년월일을 기반으로 경매기간 종료 계산
// 			var aucWeek	= (birth.date() > 9 && birth.date() < 25) ? 2 : 4;
			var aucWeek = [2, 4];
			
			// 시작일과 가장 가까운 특정 요일(목요일) 찾기
			var nearest = aucDtSt.add(7 * parseInt((aucDtSt.day()-1)/4), "day").day(4);
			
			console.log(aucDtSt.format("YYYY-MM-DD"), aucDtEn.format("YYYY-MM-DD"), aucWeek, mtcn);
			// 경매기간 종료 이전의 요일 데이터 저장
			var arrAucDt = [];
			while(nearest.isBefore(aucDtEn)) {
				if (aucWeek.includes(parseInt((nearest.date()-1)/7) + 1)) {
					arrAucDt.push(nearest);
				}
				nearest = nearest.add(7, "day");
			}
			console.log(arrAucDt);
			if (arrAucDt.length == 0) {
				console.log(aucDtEn.day(4).format("YYYY-MM-DD"));
				$("#auc_dt").val(aucDtEn.day(4).format("YYYY-MM-DD"));
				$("#mtcn").val(aucDtEn.day(4).diff(birth, "month") + 1);
			}
			else if(arrAucDt[arrAucDt.length -1] instanceof dayjs) {
				$("#auc_dt").val(arrAucDt[arrAucDt.length -1].format("YYYY-MM-DD"));
				$("#mtcn").val(arrAucDt[arrAucDt.length -1].diff(birth, "month") + 1);
			}
		}
		else {
			$("#auc_dt").val("");
		}
	}
	
	/*******************************
	 임신개월수, 분만예정일 산정 이벤트
	*******************************/
	function fn_setPrnyMtcn() {
		if($("#auc_obj_dsc").val() != "3") return;
		if(!fn_isDate($("#auc_dt").val()) || !fn_isDate($("#afism_mod_dt").val())) return;
		
		var aucDt		= dayjs($("#auc_dt").val());				// 경매일자
		var afismModDt	= dayjs($("#afism_mod_dt").val());			// 인공수정일자
		$("#prny_mtcn").val(aucDt.diff(afismModDt, "month") + 1);	// 임신개월수
		// 분만예정일 = 인공수정일자 + 285
		$("#ptur_pla_dt").val(afismModDt.add(285, "day").format("YYYY-MM-DD"));
	}
	
	//**************************************
	// function  : fn_Excel(접수내역 엑셀 저장) 
	//**************************************
	function fn_Excel(){
		var tempObj = [];
		$('#gbox_grd_MhSogCow_1 tr.footrow:visible td:visible').each((i,o)=>{
			tempObj.push({label:$(o).text(),name:$(o).attr('aria-describedby')?.replace('grd_MhSogCow_1_',''),width:$(o).outerWidth(),align:$(o).css('text-align'),formatter:'',colspan:$(o).attr('colspan')??'1'});
		});
		$('#gbox_grd_MhSogCow_2 tr.footrow:visible td:visible').each((i,o)=>{
			tempObj.push({label:$(o).text(),name:$(o).attr('aria-describedby')?.replace('grd_MhSogCow_1_',''),width:$(o).outerWidth(),align:$(o).css('text-align'),formatter:'',colspan:$(o).attr('colspan')??'1'});
		});
		fn_ExcelDownlad('grd_MhSogCow', '출장우접수내역조회',tempObj);
	} 
	
	//**************************************
	// function  : fn_setLocGb(지역구분 선택) 
	//**************************************
	function fn_setLocGb() {
		var addr = $("#dongup").val().trim() + $("#dongbw").val().trim();
		if(fn_isNull(addr)) {
			$("#loc_gb").val("");
			return;
		}
		var options = $("#loc_gb").find("option").toArray();
		var selValue = "";
		
		for (option of options) {
			var details = $(option).data("details");
			if (details == "") {
				continue;
			}
			
			for (detail of details.split(",")) {
				if (addr.indexOf(detail) > -1) {
					selValue = $(option).val();
					break;
				}
			}
		}
		$("#loc_gb").val(selValue);
	}
	////////////////////////////////////////////////////////////////////////////////
	//  사용자 함수 종료
	////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////////
	//  그리드 함수 시작
	////////////////////////////////////////////////////////////////////////////////
	//그리드 생성1
	function fn_CreateGrid(data){
		var rowNoValue = 0;
		if(data != null){
			rowNoValue = data.length;
		}
		var searchResultColNames = ["H사업장코드"
									,"경매<br/>대상", "경매일자", "경매<br/>번호", "접수일자", "접수<br/>번호", "예약취소", "취소일자", "바코드", "성별", "출하자"
									,"주소", "동이하주소", "지역구분", "사료<br/>사용여부", "생년월일", "어미구분", "어미<br/>바코드", "개체<br/>관리번호", "등록구분", "월령", "산차"
									,"계대", "아비<br/>KPN", "브루셀라", "백신접종", "전화번호","휴대전화", "계좌번호", "비고", "친자검사<br/>여부", "친자검사<br/>결과"
									,"자가여부", "수송자", "추가운송비", "사료대금", "임신구분", "인공수정일", "수정<br/>KPN", "분만예정일", "임신<br/>개월수", "임신<br/>감정여부"
									,"괴사<br/>감정여부", "제각여부", "최초등록자", "최초등록일", "최종수정자", "최종수정일"];
		
		var searchResultColModel = [{name:"NA_BZPLC",             index:"NA_BZPLC",             width:90,height:30, align:'center', hidden:true},
			
									{name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
									{name:"AUC_DT",               index:"AUC_DT",               width:90, align:'center', formatter:'gridDateFormat', sorttype: "number"},
									{name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:40, align:'center', sorttype: "number"},
									{name:"AUC_RECV_DT",          index:"AUC_RECV_DT",          width:90, align:'center', formatter:'gridDateFormat', sorttype: "number"},
									{name:"AUC_RECV_NO",          index:"AUC_RECV_NO",          width:40, align:'center', sorttype: "number"},
									{name:"RECV_CAN_YN",          index:"RECV_CAN_YN",          width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"RECV_CAN_DT",          index:"RECV_CAN_DT",          width:90, align:'center', sorttype: "number"},
									{name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, align:'center', formatter:'gridIndvFormat'},
									{name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
									{name:"FTSNM",                index:"FTSNM",                width:80, align:'center'},
									
									{name:"DONGUP",               index:"DONGUP",               width:200, align:'left'},
									{name:"DONGBW",               index:"DONGBW",               width:150, align:'left'},
									{name:"LOC_GB",               index:"LOC_GB",               width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCustonCodeString(locGbList)}},
									{name:"SRA_FED_SPY_YN",       index:"SRA_FED_SPY_YN",       width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"BIRTH",                index:"BIRTH",                width:70, align:'center', formatter:'gridDateFormat'},
									{name:"MCOW_DSC",             index:"MCOW_DSC",             width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
									{name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, align:'center', formatter:'gridIndvFormat'},
									{name:"INDV_ID_NO",           index:"INDV_ID_NO",           width:60, align:'center'},
									{name:"RG_DSC",               index:"RG_DSC",               width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
									{name:"MTCN",                 index:"MTCN",                 width:40, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"MATIME",               index:"MATIME",               width:40, align:'right'},
									
									{name:"SRA_INDV_PASG_QCN",    index:" SRA_INDV_PASG_QCN",    width:40, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"KPN_NO",               index:"KPN_NO",               width:50, align:'center'},
									{name:"BRCL_ISP_DT",          index:"BRCL_ISP_DT",          width:70, align:'center', formatter:'gridDateFormat'},
									{name:"VACN_DT",              index:"VACN_DT",              width:70, align:'center', formatter:'gridDateFormat'},
									{name:"OHSE_TELNO",           index:"OHSE_TELNO",           width:120, align:'center'},
									{name:"CUS_MPNO",             index:"CUS_MPNO",             width:120, align:'center'},
									{name:"SRA_FARM_ACNO",        index:"SRA_FARM_ACNO",        width:120, align:'center'},
									{name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, align:'left'},
									{name:"DNA_YN_CHK",           index:"DNA_YN_CHK",           width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"DNA_JUG_RESULT",       index:"DNA_JUG_RESULT",       width:60, align:'center'},
									
									{name:"TRPCS_PY_YN",          index:"TRPCS_PY_YN",          width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"VHC_DRV_CAFFNM",       index:"VHC_DRV_CAFFNM",       width:80, align:'center'},
									{name:"SRA_TRPCS",            index:"SRA_TRPCS",            width:70, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"SRA_FED_SPY_AM",       index:"SRA_FED_SPY_AM",       width:70, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"PPGCOW_FEE_DSC",       index:"PPGCOW_FEE_DSC",       width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
									{name:"AFISM_MOD_DT",         index:"AFISM_MOD_DT",         width:80, align:'center', formatter:'gridDateFormat'},
									{name:"MOD_KPN_NO",           index:"MOD_KPN_NO",           width:50, align:'center'},
									{name:"PTUR_PLA_DT",          index:"PTUR_PLA_DT",          width:80, align:'center', formatter:'gridDateFormat'},
									{name:"PRNY_MTCN",            index:"PRNY_MTCN",            width:50, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"PRNY_JUG_YN",          index:"PRNY_JUG_YN",          width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									
									{name:"NCSS_JUG_YN",          index:"NCSS_JUG_YN",          width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"DEBD_CANCEL_YN",       index:"DEBD_CANCEL_YN",       width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"FSRGMN_NM",            index:"FSRGMN_NM",            width:80, align:'center'},
									{name:"FSRG_DTM",             index:"FSRG_DTM",             width:110, align:'center'},
									{name:"LSCHG_NM",             index:"LSCHG_NM",             width:80, align:'center'},
									{name:"LSCHG_DTM",            index:"LSCHG_DTM",            width:110, align:'center'}
									];

		$("#grd_MhSogCow").jqGrid("GridUnload");

		$("#grd_MhSogCow").jqGrid({
			datatype:    "local",
			data:        data,
			height:      150,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   true,
			shrinkToFit: false,
			rownumbers:  true,
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
				pageInfos.param = data;
				fn_InitSet();
			},
			colNames: searchResultColNames,
			colModel: searchResultColModel
		});

		//행번호
		$("#grd_MhSogCow").jqGrid("setLabel", "rn","No");
		$("#grd_MhSogCow").jqGrid("destroyFrozenColumns")
						  .jqGrid("setColProp", "FTSNM", {frozen:true})
						  .jqGrid("setFrozenColumns")
						  .trigger("reloadGrid", [{current : true}]);
		//고정 타이틀 빼고 전부 숨김처리
// 		$("#grd_MhSogCow").jqGrid("hideCol",[
// 			"DONGUP", "DONGBW", "SRA_FED_SPY_YN", "BIRTH", "MCOW_DSC", "MCOW_SRA_INDV_AMNNO", "INDV_ID_NO", "RG_DSC", "MTCN", "MATIME"
// 			, "SRA_INDV_PASG_QCN", "KPN_NO", "BRCL_ISP_DT", "VACN_DT", "OHSE_TELNO", "CUS_MPNO", "SRA_FARM_ACNO", "RMK_CNTN", "DNA_YN_CHK", "DNA_JUG_RESULT"
// 			, "TRPCS_PY_YN", "VHC_DRV_CAFFNM", "SRA_TRPCS", "SRA_FED_SPY_AM", "PPGCOW_FEE_DSC", "AFISM_MOD_DT", "MOD_KPN_NO", "PTUR_PLA_DT", "PRNY_MTCN", "PRNY_JUG_YN"
// 			, "NCSS_JUG_YN", "DEBD_CANCEL_YN", "FSRGMN_NM", "FSRG_DTM", "LSCHG_NM", "LSCHG_DTM"]);
	}
	////////////////////////////////////////////////////////////////////////////////
	//  그리드 함수 종료
	////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////
	//  팝업 시작
	////////////////////////////////////////////////////////////////////////////////
	//**************************************
	// function  : fn_CallFtsnmPopup(출하주 팝업 호출) 
	// paramater : N/A 
	// result   : N/A
	//**************************************
	function fn_CallFtsnmPopup(p_param) {
		var checkBoolean = p_param;
		var data = new Object();
		data['ftsnm'] = $("#ftsnm").val();
		if(!p_param) {
			data = null;
		}
		fn_CallFtsnm0127Popup(data,checkBoolean,function(result) {
			if(result){
				$("#fhs_id_no").val(result.FHS_ID_NO);
				$("#farm_amnno").val(result.FARM_AMNNO);
				$("#ftsnm").val(fn_xxsDecode(result.FTSNM));
				
				if(!fn_isNull(result.CUS_MPNO)) {
					$("#ohse_telno").val(result.CUS_MPNO);
				} else {
					$("#ohse_telno").val(result.OHSE_TELNO);
				}
			
				if(!fn_isNull(result.ZIP)) {
					$("#zip").val(result.ZIP.substr(0, 3) + "-" + result.ZIP.substr(3, 3));
				}
				
				$("#dongup").val(fn_xxsDecode(result.DONGUP)).trigger("change");
				$("#dongbw").val(fn_xxsDecode(result.DONGBW)).trigger("change");
				$("#sra_pdmnm").val(fn_xxsDecode(result.FTSNM));
				$("#sra_pd_rgnnm").val(fn_xxsDecode(result.DONGUP));
				
				if(result.SRA_FED_SPY_YN == 1) {
					fn_contrChBox(true, "sra_fed_spy_yn");
				}
				else {
					fn_contrChBox(false, "sra_fed_spy_yn");
				}
				
				if (fn_isNull($("#sogmn").val)) {
					$("#sog_na_trpl_c").val(result.NA_TRPL_C);
				}

				if(!fn_isNull($("#fhs_id_no").val()) && !fn_isNull($("#indv_sex_c").val()) && !fn_isNull($("#birth").val())) {
					$("#vacn_dt").focus();
				}
				else if(!fn_isNull($("#fhs_id_no").val()) && fn_isNull($("#indv_sex_c").val()) && fn_isNull($("#birth").val())) {
					$("#indv_sex_c").val("0");
					$("#indv_sex_c").focus();
				}
				
			}
			else {
				$("#fhs_id_no").val("");
				$("#farm_amnno").val("");
				$("#ftsnm").val("");
				$("#ohse_telno").val("");
				$("#zip").val("");
				$("#dongup").val("").trigger("change");
				$("#dongbw").val("").trigger("change");
				$("#sra_pdmnm").val("");
				$("#sra_pd_rgnnm").val("");

				fn_contrChBox(false, "sra_fed_spy_yn");
				
				$("#sog_na_trpl_c").val("");
				$("#io_sogmn_maco_yn").val("");
				$("#sra_farm_acno").val("");

				if(!fn_isNull($("#fhs_id_no").val()) && !fn_isNull($("#indv_sex_c").val()) && !fn_isNull($("#birth").val())) {
					$("#vacn_dt").focus();
				}
				else if(!fn_isNull($("#fhs_id_no").val()) && fn_isNull($("#indv_sex_c").val()) && fn_isNull($("#birth").val())) {
					$("#indv_sex_c").val("0");
					$("#indv_sex_c").focus();
				}
			}
		});
	}
	
	function fn_CallFhsPopup(p_param) {
		var checkBoolean = p_param;
		var data = new Object();
		data['ftsnm'] = $("#sch_ftsnm").val();
		if(!p_param) {
			data = null;
		}
		fn_CallFtsnm0127Popup(data,checkBoolean,function(result) {
			if(result){
				$("#sch_fhs_id_no").val(result.FHS_ID_NO);
				$("#farm_amnno").val(result.FARM_AMNNO);
				$("#sch_ftsnm").val(fn_xxsDecode(result.FTSNM));
			}
		});
	
		
	}
	
	//**************************************
	// function  : fn_CallIndvInfSrch(개체정보검색 전 셋팅) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_CallIndvInfSrch() {
		var P_sra_indv_amnno = "";
		if($("#sra_indv_amnno").val().replace("-", "").length == 9) {
			P_sra_indv_amnno = "410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", "");
			$("#re_indv_no").val("410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val().replace("-", ""));

			var resultsTmpIndv = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selTmpIndvAmnnoPgm", "POST");   
			var resultTmpIndv;
			
			if(resultsTmpIndv.status == RETURN_SUCCESS) {
				resultTmpIndv = setDecrypt(resultsTmpIndv);
				
				if(resultTmpIndv.length == 1) {
					fn_CallIndvInfSrchPopup(true, P_sra_indv_amnno);
				}
			}
			else {
				var cheackParam = "410" + $("#hed_indv_no").val() + $("#sra_indv_amnno").val();
				if(cheackParam.length == 15) {
					// 개체 인터페이스 호출
					fn_popInfHstPopup(true);
					
					if(fn_isNull($("#sra_indv_amnno").val())) {
						MessagePopup('OK','등록된개체가 없습니다 중간의 개체정보를 입력하여 저장해주세요.');
						$("#rg_dsc").val("09");
						$("#mcow_dsc").val("09");
						// 정합성체크 해제
					}
				}
			}
			
		} else {
			P_sra_indv_amnno = $("#sra_indv_amnno").val().replace("-", "");
			$("#re_indv_no").val($("#sra_indv_amnno").val().replace("-", ""));
			fn_CallIndvInfSrchPopup(true, P_sra_indv_amnno);
		}
		
	}
	
	//**************************************
	// function  : fn_CallIndvInfSrchPopup(개체정보검색팝업 호출) 
	// paramater : p_param(true, false), P_sra_indv_amnno(sra_indv_amnno Value)
	// result   : N/A
	//**************************************
	function fn_CallIndvInfSrchPopup(p_param, P_sra_indv_amnno) {
		var checkBoolean = p_param;
		var data = new Object();
			
		if(!p_param) {
			data = null;
		}
		else {
			data['sra_indv_amnno'] = P_sra_indv_amnno;
		}
			
		fn_CallMmIndvPopup(data, p_param, function(result) {
			console.log(result.SRA_INDV_AMNNO.substr(3, 6));
			if(result) {
				$("#sra_srs_dsc").val(result.SRA_SRS_DSC);
				if(!fn_isNull(result.SRA_INDV_AMNNO)) {
					$("#sra_indv_amnno").val(result.SRA_INDV_AMNNO.substr(6, 9));
					$("#hed_indv_no").val(result.SRA_INDV_AMNNO.substr(3, 3));
				}
				$("#fhs_id_no").val(result.FHS_ID_NO);
				$("#farm_amnno").val(result.FARM_AMNNO);
				$("#ftsnm").val(fn_xxsDecode(result.FTSNM));
				$("#cus_mpno").val(result.CUS_MPNO);
				$("#ohse_telno").val(result.OHSE_TELNO);
				
				if(!fn_isNull(result.ZIP)) {
					$("#zip").val(result.ZIP);
				}
				
				$("#dongup").val(fn_xxsDecode(result.DONGUP)).trigger("change");
				$("#dongbw").val(fn_xxsDecode(result.DONGBW)).trigger("change");
				$("#sra_pdmnm").val(fn_xxsDecode(result.FTSNM));
				$("#sra_pd_rgnnm").val(fn_xxsDecode(result.DONGUP));
				$("#sog_na_trpl_c").val(result.NA_TRPL_C);
				$("#indv_sex_c").val(result.INDV_SEX_C);
				$("#birth").val(fn_toDate(result.BIRTH)).trigger("change");
				$("#indv_id_no").val(result.INDV_ID_NO);
				$("#sra_indv_brdsra_rg_no").val(result.SRA_INDV_BRDSRA_RG_NO);
				$("#rg_dsc").val(result.RG_DSC);
				$("#kpn_no").val(result.KPN_NO);
				$("#mcow_dsc").val(result.MCOW_DSC);
				$("#mcow_sra_indv_amnno").val(result.MCOW_SRA_INDV_AMNNO);
				$("#matime").val(result.MATIME);
				$("#sra_indv_pasg_qcn").val(result.SRA_INDV_PASG_QCN);
				$("#sra_farm_acno").val(result.SRA_FARM_ACNO);
				if(result.SRA_FED_SPY_YN == 1) {
					fn_contrChBox(true, "sra_fed_spy_yn");
				} else {
					fn_contrChBox(false, "sra_fed_spy_yn");
				}
				
				fn_CallIndvInfSrchSet();
			}
		});
	}
	
	//**************************************
	// function  : fn_CallIndvInfSrchSet(개체정보검색 팝업 후 세팅) 
	// paramater : N/A
	// result   : N/A
	//**************************************
	function fn_CallIndvInfSrchSet() {
		var resultsFhsIdNo = sendAjaxFrm("frm_MhSogCow", "/LALM0215_selFhsIdNo", "POST");
		var resultFhsIdNo;
		
		if(resultsFhsIdNo.status == RETURN_SUCCESS) {
			resultFhsIdNo = setDecrypt(resultsFhsIdNo);
			if(resultFhsIdNo.length == 1) {
				$("#fhs_id_no").val(resultFhsIdNo[0]["FHS_ID_NO"]);
				$("#farm_amnno").val(resultFhsIdNo[0]["FARM_AMNNO"]);
				$("#ftsnm").val(fn_xxsDecode(resultFhsIdNo[0]["FTSNM"]));
				
				$("#cus_mpno").val(resultFhsIdNo[0]["CUS_MPNO"]);
				$("#ohse_telno").val(resultFhsIdNo[0]["OHSE_TELNO"]);
				
				if(!fn_isNull(resultFhsIdNo[0]["ZIP"])) {
					$("#zip").val(resultFhsIdNo[0]["ZIP"]);
				}
				
				$("#dongup").val(fn_xxsDecode(resultFhsIdNo[0]["DONGUP"])).trigger("change");
				$("#dongbw").val(fn_xxsDecode(resultFhsIdNo[0]["DONGBW"])).trigger("change");
				$("#sra_pdmnm").val(fn_xxsDecode(resultFhsIdNo[0]["FTSNM"]));
				$("#sra_pd_rgnnm").val(fn_xxsDecode(resultFhsIdNo[0]["DONGUP"]));
				$("#sog_na_trpl_c").val(resultFhsIdNo[0]["NA_TRPL_C"]);
				$("#sra_farm_acno").val(resultFhsIdNo[0]["SRA_FARM_ACNO"]);
				
				mv_InitBoolean = false;
				
			}
		}
		else {
			mv_InitBoolean = false;
		}
		// 브루셀라검사 조회
		fn_CallBrclIspSrch();
		// 친자확인 조회
//		fn_CallLsPtntInfSrch();
		// 유전체 분석 조회
//		fn_CallGeneBredrInfSrch();
		// 해당 출장우의 분만정보 조회
		fn_SelBhCross();
	}
	////////////////////////////////////////////////////////////////////////////////
	//  팝업 종료
	////////////////////////////////////////////////////////////////////////////////
</script>

<body>
	<div class="contents">
		<%@ include file="/WEB-INF/common/menuBtn.jsp" %>

		<!-- content -->
		<section class="content">
			<div class="tab_box clearfix line">
				<div class="fl_R" id="tab1_text"><!--  //버튼 모두 우측정렬 -->   
					<input type="checkbox" id=brcl_chk_yn name="brcl_chk_yn" value="1" checked="checked" />
					<label for="brcl_chk_yn" style="font-size:5px;color: red;font: message-box;">브루셀라 검사일, 백신접종일 확인 안함.</label>
					<label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 개체정보가 없을 경우 개체 정보를 정확히 입력 후 저장하면 됩니다.</label>
				</div>
			</div>
			
			<!-- //tab_box e -->
			<form id="frm_MhSogCow" autocomplete="off">
			<!-- ------------------------------ 출장우 정보 탭 ------------------------------ -->
			<!-- ------------------------------ 출장우 정보 ------------------------------ -->
				<div class="sec_table">
					<div class="sec_table">
						<div class="grayTable rsp_v">
							<table>
								<colgroup>
									<col width="100">
									<col width="*">
									<col width="100">
									<col width="*">
									<col width="130">
									<col width="120">
									<col width="*">
									<col width="*">
									<col width="150">
									<col width="150">
									<col width="150">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><span class="tb_dot">경매대상</span></th>
										<td colspan=2>
											<div class="cellBox" id="rd_auc_obj_dsc"></div>
											<input type="hidden" id="auc_obj_dsc" name="auc_obj_dsc" />
										</td>
										<th scope="row"><span class="tb_dot">접수일자</span></th>
										<td colspan=2>
											<div class="cellBox">
												<div class="cell">
													<input type="text" class="date" id="auc_recv_dt" maxlength="10" readonly="readonly" />
												</div>
											</div>
										</td>
										<th scope="row"><span class="tb_dot">예약취소</span></th>
										<td>
											<input type="checkbox" id="recv_can_yn" name="recv_can_yn" value="0" />
											<label id="recv_can_yn_text" for="recv_can_yn"> 부</label>
										</td>
										<th scope="row"><span>취소일자</span></th>
										<td colspan="2">
											<div class="cellBox">
												<div class="cell">
													<input type="text" class="date" id="recv_can_dt" maxlength="10" disabled="disabled" />
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><span class="tb_dot">귀표번호</span></th>
										<td colspan=2>
											<input type="text" id="hed_indv_no" class="digit" style="width:70px" value="002" maxlength="3" />
											<input type="text" id="sra_indv_amnno" class="popup digit" style="width:150px"  maxlength="9" />
											<button id="pb_sra_indv_amnno" class="tb_btn white srch"><i class="fa fa-search"></i></button>
										</td>
										<th scope="row"><span>경매일자</span></th>
										<td colspan="2">
											<div class="cellBox">
												<div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10" readonly="readonly" /></div>
											</div>
										</td>
										<th scope="row"><span>제각여부</span></th>
										<td>
											<input type="checkbox" id="debd_cancel_yn"  name="debd_cancel_yn" value="0" />
											<label id="debd_cancel_yn_text" for="debd_cancel_yn"> 부</label>
										</td>
										<th scope="row"><span>추가운송비</span></th>
										<td colspan="2">
											<input type="text" class="number" id="sra_trpcs" maxlength="8" />
										</td>
									</tr>
									<tr>
										<th scope="row"><span>수송자</span></th>
										<td>
											<input type="radio" id="trpcs_py_yn_0"  name="rd_trpcs_py_yn" value="0" checked="checked" onclick="javascript:fn_setChgRadio('trpcs_py_yn','0');" /><label for="trpcs_py_yn_0">자가</label>
											<input type="radio" id="trpcs_py_yn_1"  name="rd_trpcs_py_yn" value="1" onclick="javascript:fn_setChgRadio('trpcs_py_yn','1');" /><label for="trpcs_py_yn_1">운송협회</label>
											<input type="hidden" id="trpcs_py_yn" name="trpcs_py_yn" value="0" />
										</td>
										<td>
											<input disabled="disabled" type="text" id="vhc_shrt_c">
										</td>
										<td>
											<input disabled="disabled" type="text" id="vhc_drv_caffnm" style="width:140px" />
											<button id="pb_vhc_drv_caffnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
										</td>
										<th scope="row"><span>비고</span></th>
										<td colspan="3">
											<input type="text" id="rmk_cntn" />
										</td>
										<th scope="row"><span>사료대금</span></th>
										<td colspan=2>
											<input type="text" class="number" id="sra_fed_spy_am" maxlength="8" />
										</td>
									</tr>
									<tr>
										<th scope="row"><span>브루셀라검사</span></th>
										<td>
											<div class="cellBox">
												<div class="cell">
													<input type="text" class="date" id="brcl_isp_dt" style="font-weight:bold;" />
												</div>
											</div>
										</td>
										<th scope="row"><span>예방접종일</span></th>
										<td>
											<div class="cellBox">
												<div class="cell">
													<input type="text" class="date" id="vacn_dt" style="font-weight:bold;" />
												</div>
											</div>
										</td>
										<th scope="row"><span>친자감정여부</span></th>
										<td>
											<input type="checkbox" id="dna_yn_chk" name="dna_yn_chk" value="0" />
											<label id="dna_yn_chk_text" for="dna_yn_chk"> 부</label>
										</td>
										<th scope="row"><span>친자확인결과</span></th>
										<td>
											<select id="dna_jug_result" name="dna_jug_result">
												<option value="3">미확인</option>
												<option value="1">일치</option>
												<option value="2">불일치</option>
											</select>
										</td>
										<th scope="row"><span>모근채취여부</span></th>
										<td colspan="2">
											<input type="checkbox" id="dna_sampled_yn" name="dna_sampled_yn" value="0" />
											<label id="dna_sampled_yn_text" for="dna_sampled_yn"> 부</label>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				
				<div class="tab_box clearfix">
					<p>※등록되지 않은 개체의 경우 하단의 개체정보를 입력하신 후 저장하시기 바랍니다.</p>
				</div>

				<!-- ------------------------------ 개체 정보 ------------------------------ -->
				<div class="sec_table">
					<div class="grayTable rsp_v">
						<table>
							<colgroup>
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><span>개체성별코드</span></th>
									<td>
										<select id="indv_sex_c"  style="font-weight:bold;"></select>
									</td>
									<th scope="row"><span>생년월일</span></th>
									<td>
										<div class="cellBox">
											<div class="cell">
												<input type="text" class="date" id="birth" style="width:80%;" />
												<input type="text" class="digit" id="mtcn" style="width:18%;" />
											</div>
										</div>
									</td>
									<th scope="row"><span>어미구분</span></th>
									<td>
										<select id="mcow_dsc"></select>
									</td>
									<th scope="row"><span>어미귀표번호</span></th>
									<td>
										<input type="text" id="mcow_sra_indv_amnno">
									</td>
								</tr>
								
								<tr>
									<th scope="row"><span>개체관리번호</span></th>
									<td>
										<input type="text" id="indv_id_no">
										<input type="hidden" style="text-align:right;" id="sra_indv_brdsra_rg_no">
									</td>
									<th scope="row"><span>등록구분</span></th>
									<td>
										<select id="rg_dsc" name="rg_dsc"></select>
									</td>
									<th scope="row"><span>산차/계대</span></th>
									<td>
										<input type="text" style="text-align:right;width:44%;" id="matime" value="0" /> /
										<input type="text" style="text-align:right;width:44%;" id="sra_indv_pasg_qcn" value="0" />
									</td>
									<th scope="row"><span>KPN번호</span></th>
									<td>
										<input type="text" id="kpn_no" style="font-weight:bold;">
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<!-- ------------------------------ 출하주 정보 ------------------------------ -->
				<div class="sec_table">
					<div class="grayTable rsp_v">
						<table>
							<colgroup>
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><span>출하주</span></th>
								<td>
									<input type="text" id="fhs_id_no" style="width:85px;" readonly="readonly" />
									<span> - </span>
									<input type="text" id="farm_amnno" style="width:85px;" readonly="readonly" />
									<input type="text" id="ftsnm" style="width:90px; font-weight:bold;">
									<button id="pb_ftsnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
								</td>
								<th scope="row"><span>자택전화번호</span></th>
								<td>
									<input type="text" id="ohse_telno" readonly="readonly" />
								</td>
								<th scope="row"><span>핸드폰</span></th>
								<td>
									<input type="text" id="cus_mpno" readonly="readonly" />
								</td>
								<th scope="row"><span>사료사용여부</span></th>
								<td>
									<input type="checkbox" id="sra_fed_spy_yn" name="sra_fed_spy_yn" value="0">
									<label id="sra_fed_spy_yn_text" for="sra_fed_spy_yn"> 부</label>
									<input type="hidden" class="number"id="sra_fed_spy_yn_fee" style="width:80px" readonly="readonly" />
								</td>
							</tr>
							<tr>
								<th scope="row"><span>주소</span></th>
								<td colspan="3">
									<input readonly="readonly" type="text" id="zip" style="width:10%;" />
									<input type="text" id="dongup" style="width:44%;" />
									<input type="text" id="dongbw" style="width:44%;" />
								</td>
								<th scope="row"><span>지역구분</span></th>
								<td>
									<select id="loc_gb" name="loc_gb"></select>
								</td>
								<th scope="row"><span>계좌번호</span></th>
								<td>
									<input type="text" id="sra_farm_acno" readonly="readonly" />
								</td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
					
				<!-- ------------------------------ 번식우 임신 정보 ------------------------------ -->
				<div class="sec_table">
					<div class="grayTable rsp_v">
						<table>
							<colgroup>
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
							</colgroup>
							<tbody id="firstBody" style="display:none;">
								<tr>
									<th scope="row"><span>임신구분</span></th>
									<td>
										<select id="ppgcow_fee_dsc"></select>
									</td>
									<th scope="row"><span>인공수정일자</span></th>
									<td>
										<div class="cellBox">
											<div class="cell"><input type="text" class="date" id="afism_mod_dt"></div>
										</div>
									</td>
									<th scope="row"><span>수정KPN</span></th>
									<td>
										<input type="text" id="mod_kpn_no" maxlength="9">
									</td>
									<th scope="row"><span>분만예정일</span></th>
									<td>
										<input disabled="disabled" type="text" class="date" id="ptur_pla_dt" maxlength="10">
									</td>
								</tr>
								<tr>
									<th scope="row"><span>임신개월수</span></th>
									<td>
										<input type="text" class="number" id="prny_mtcn" maxlength="2">
									</td>
									<th scope="row"><span>임신감정여부</span></th>
									<td>
										<input type="checkbox" id="prny_jug_yn" name="prny_jug_yn" value="0">
										<label id="prny_jug_yn_text" for="prny_jug_yn"> 부</label>
									</td>
									<th scope="row"><span>괴사감정여부</span></th>
									<td>
										<input type="checkbox" id="ncss_jug_yn" name="ncss_jug_yn" value="0">
										<label id="ncss_jug_yn_text" for="ncss_jug_yn"> 부</label>
									</td>
									<th scope="row"><span>송아지<br/>귀표번호</span></th>
									<td>
										<input type="text" id="ccow_sra_indv_amnno" disabled="disabled">
									</td>
								</tr>
							</tbody>
							<tbody id="hiddenBody" style="display:none">
								<tr>
									<td>
										<input type="hidden" id="auc_recv_no">
									</td>
									<td>
										<input type="hidden" id="led_sqno">
									</td>
									<td>
										<input type="hidden" id="sog_na_trpl_c">
									</td>
									<td>
										<input type="hidden" id="re_indv_no">
									</td>
									<td>
										<input type="hidden" id="chg_pgid">
									</td>
									<td>
										<input type="hidden" id="chg_rmk_cntn">
									</td>
									<td>
										<input type="hidden" id="chg_del_yn">
									</td>
									<td>
										<input type="hidden" id="sra_farm_acno">
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</form>
			
			<div class="tab_box clearfix line"></div>
			<div class="sec_table">
				<div class="grayTable rsp_v">
					<form id="frm_Search" name="frm_Search" autocomplete="off">
						<table>
							<colgroup>
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">경매대상구분</th>
									<td>
										<div class="cellBox" id="rd_auc_obj_dsc" style="width:40%;">
											<input type="hidden" id="shc_auc_obj_dsc" name="shc_auc_obj_dsc" />
											<div class="cell">
												<input type="radio" id="sch_auc_obj_dsc_0" name="sch_auc_obj_dsc_radio" value="0" onclick="javascript:fn_setChgRadio('shc_auc_obj_dsc','0');" checked="checked" />
												<label>전체</label>
											</div>
											<div class="cell">
												<input type="radio" id="sch_auc_obj_dsc_1" name="sch_auc_obj_dsc_radio" value="1" onclick="javascript:fn_setChgRadio('shc_auc_obj_dsc','1');" />
												<label>송아지</label>
											</div>
											<div class="cell">
												<input type="radio" id="sch_auc_obj_dsc_2" name="sch_auc_obj_dsc_radio" value="2" onclick="javascript:fn_setChgRadio('shc_auc_obj_dsc','2');" />
												<label>비육우</label>
											</div>
											<div class="cell">
												<input type="radio" id="sch_auc_obj_dsc_3" name="sch_auc_obj_dsc_radio" value="3" onclick="javascript:fn_setChgRadio('shc_auc_obj_dsc','3');" />
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
												<input type="text" id="sch_fhs_id_no" maxlength="10" readonly="readonly" />
											</div>
											<div class="cell pl2" style="width: 28px;">
												<button id="pb_searchFhs" class="tb_btn white srch" type="button">
													<i class="fa fa-search"></i>
												</button>
											</div>
											<div class="cell">
												<input type="text" id="sch_ftsnm" maxlength="30" />
											</div>
										</div>
									</td>
									<th scope="row">작업자</th>
									<td>
										<div class="cellBox" >
											<input type="text" name="usrnm" id="usrnm" value="" maxlength="10" />
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
			
			<form id="frm_Hdn" style="display:none">
				<input type="hidden" id="hdn_auc_recv_dt">
				<input type="hidden" id="hdn_auc_recv_no">
				<input type="hidden" id="hdn_auc_obj_dsc">
			</form>
			<div class="tab_box clearfix">
				<ul class="tab_list fl_L">
					<li><p class="dot_allow">검색결과</p></li>
				</ul>
			</div>
			<div class="listTable mb5">
				<table id="grd_MhSogCow"></table>
			</div>
			
		</section>
	</div>
</body>
</html>