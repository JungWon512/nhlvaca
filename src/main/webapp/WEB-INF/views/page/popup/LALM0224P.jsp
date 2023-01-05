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
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
</head>
<body>
	<div class="pop_warp">
		<div class="tab_box btn_area clearfix">
			<ul class="tab_list fl_L">
				<li><p class="dot_allow">검색조건</p></li>
			</ul>
			<%@ include file="/WEB-INF/common/popupBtn.jsp"%>
		</div>
		<div class="sec_table">
			<div class="blueTable rsp_v">
				<form id="frm_Search" name="frm_Search">
					<input type="hidden" id="io_all_yn">
					<input type="hidden" id="ctgrm_cd">
					<table style="width:100%;"> 
						<colgroup>
							<col width="85">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th><span class="tb_dot">귀표번호</span></th>
								<td><input type="text" id="sra_indv_amnno" maxlength="15" /></td>
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
			<table id="grd_MmIndv">
			</table>
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
	$(document).ready(function() {
		//그리드 초기화
		fn_CreateGrid();
		fn_Init();

		/******************************
		 * 폼변경시 클리어 이벤트
		 ******************************/
		fn_setClearFromFrm("frm_Search", "#grd_MmTrpl");

		$("#grd_MmIndv").jqGrid("hideCol", "SRA_SRS_DSC");
		$("#grd_MmIndv").jqGrid("hideCol", "NA_TRPL_C");
		$("#grd_MmIndv").jqGrid("hideCol", "ZIP");
		$("#grd_MmIndv").jqGrid("hideCol", "DONGUP");
		$("#grd_MmIndv").jqGrid("hideCol", "DONGBW");
		$("#grd_MmIndv").jqGrid("hideCol", "OHSE_TELNO");
		$("#grd_MmIndv").jqGrid("hideCol", "CUS_MPNO");
		$("#grd_MmIndv").jqGrid("hideCol", "MACO_YN");
		$("#grd_MmIndv").jqGrid("hideCol", "DEL_YN");
		$("#grd_MmIndv").jqGrid("hideCol", "JRDWO_DSC");
		$("#grd_MmIndv").jqGrid("hideCol", "SRA_FARM_ACNO");
		$("#grd_MmIndv").jqGrid("hideCol", "SRA_FED_SPY_YN");
		$("#hid_sra_indv_amnno_c").hide();

	});

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init() {
		//그리드 초기화
		$("#grd_MmIndv").jqGrid("clearGridData", true);
		//폼 초기화
		fn_InitFrm('frm_Search');
		$("#io_all_yn").val('0');
		$("#ctgrm_cd").val('4700');
		$("#sra_indv_amnno").val("410002").focus();
	}

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search() {

		if (fn_isNull($("#sra_indv_amnno").val()) || $("#sra_indv_amnno").val().length != 15) {
			MessagePopup('OK', '개체번호는 410포함 15자를 입력하세요.', function(){$("#sra_indv_amnno").focus();});
			return;
		}
		//정합성체크
		var results = sendAjaxFrm("frm_Search", "/LALM0899_selIfSend", "POST");
		var result;

		//그리드 초기화
		$("#grd_MmIndv").jqGrid("clearGridData", true);
		if (results.status != RETURN_SUCCESS) {
			showErrorMessage(results);
			return;
		} else {
			result = setDecrypt(results);
		}

		var dataAry = new Array();
		var dataObj = new Object();

		if (result.INQ_CN != 0) {
			dataObj["SRA_INDV_AMNNO"] = $.trim(result.SRA_INDV_AMNNO);
			dataObj["FHS_ID_NO"] = $.trim(result.FHS_ID_NO);
			dataObj["FARM_AMNNO"] = parseInt($.trim(result.FARM_AMNNO));
			dataObj["SRA_FHSNM"] = $.trim(result.SRA_FHSNM);
			dataObj["SRA_INDV_BIRTH"] = $.trim(result.SRA_INDV_BIRTH);
			dataObj["SRA_INDV_MCOW_BRDSRA_RG_DSC"] = $.trim(result.SRA_INDV_MCOW_BRDSRA_RG_DSC);
			dataObj["SRA_KPN_NO"] = $.trim(result.SRA_KPN_NO);
			dataObj["INDV_SEX_C"] = $.trim(result.INDV_SEX_C);
			dataObj["MCOW_SRA_INDV_EART_NO"] = $.trim(result.MCOW_SRA_INDV_EART_NO);
			dataObj["SRA_INDV_LS_MATIME"] = parseInt($.trim(result.SRA_INDV_MOTHR_MATIME) == '' ? '0' : $.trim(result.SRA_INDV_MOTHR_MATIME))
			dataObj["SRA_INDV_PASG_QCN"] = parseInt($.trim(result.SRA_INDV_PASG_QCN) == '' ? '0' : $.trim(result.SRA_INDV_PASG_QCN));
			dataObj["SRA_INDV_ID_NO"] = $.trim(result.SRA_INDV_ID_NO);
			dataObj["SRA_INDV_BRDSRA_RG_NO"] = $.trim(result.SRA_INDV_BRDSRA_RG_NO);
			dataObj["SRA_SRS_DSC"] = $.trim(result.SRA_SRS_DSC);
			dataObj["NA_TRPL_C"] = $.trim(result.NA_TRPL_C);
			dataObj["ZIP"] = result.SRA_FARM_FZIP.trim() + '-' + result.SRA_FARM_RZIP.trim();
			dataObj["DONGUP"] = $.trim(result.SRA_FHS_DONGUP);
			dataObj["DONGBW"] = $.trim(result.SRA_FHS_DONGBW);
			dataObj["OHSE_TELNO"] = result.SRA_FARM_AMN_ATEL + '-' + result.SRA_FARM_AMN_HTEL + '-' + result.SRA_FARM_AMN_STEL;
			dataObj["CUS_MPNO"] = result.SRA_FHS_REP_MPSVNO + '-' + result.SRA_FHS_REP_MPHNO + '-' + result.SRA_FHS_REP_MPSQNO;
			//         	dataObj["MACO_YN"]                     = $.trim(result.MACO_YN);         //조합원여부
			dataObj["DEL_YN"] = $.trim(result.DEL_YN);
			//         	dataObj["JRDWO_DSC"]                   = $.trim(result.JRDWO_DSC);       //관내외구분
			dataObj["SRA_FARM_ACNO"] = $.trim(result.SRA_FARM_ACNO);
			//         	dataObj["SRA_FED_SPY_YN"]              = $.trim(result.SRA_FED_SPY_YN);  //사료사용여부
			dataObj["GRFA_SRA_KPN_NO"] = $.trim(result.GRFA_SRA_KPN_NO);						// 조부 KPN	
			dataObj["GRFA_SRA_INDV_EART_NO"] = $.trim(result.GRFA_SRA_INDV_EART_NO);			// 조부축산개체관리번호
			dataObj["GRMO_SRA_INDV_EART_NO"] = $.trim(result.GRMO_SRA_INDV_EART_NO);			// 조모축산개체관리번호
			dataObj["MTGRFA_SRA_KPN_NO"] = $.trim(result.MTGRFA_SRA_KPN_NO);					// 외조부KPN
			dataObj["MTGRFA_SRA_INDV_EART_NO"] = $.trim(result.MTGRFA_SRA_INDV_EART_NO);		// 외조부축산개체관리번호
			dataObj["MTGRMO_SRA_INDV_EART_NO"] = $.trim(result.MTGRMO_SRA_INDV_EART_NO);		// 외조모축산개체관리번호
			dataObj["SRA_FHS_BIRTH"] = $.trim(result.SRA_FHS_BIRTH);							// 농가생년월일
			dataObj["METRB_METQLT_GRD"] = $.trim(result.METRB_METQLT_GRD);						// 육질등급
			dataAry.push(dataObj);
			fn_CreateGrid(dataAry);
		}
		else {
			MessagePopup('OK', '조회된 내역이 없습니다.');
			return;
		}
	}

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 선택함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Select() {
		var sel_rowid = $("#grd_MmIndv").jqGrid("getGridParam", "selrow");
		pageInfo.returnValue = $("#grd_MmIndv").jqGrid("getRowData", sel_rowid);

		var parentInput = parent.$("#pop_result_" + pageInfo.popup_info.PGID);
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
		
		var searchResultColNames = ["귀표번호", "농가코드", "농장관리번호", "농가명","생년월일","어미구분","KPN","개체성별","어미귀표번호","산차","계대","식별번호", "종축등록번호"
								  , "축종구분", "거래처코드", "우편번호", "동이상주소", "동이하주소", "자택전화번호", "고객휴대전화번호", "삭제여부", "계좌번호", "등록구분"];
		
		var searchResultColModel = [
									{name:"SRA_INDV_AMNNO"             , index:"SRA_INDV_AMNNO"             , width:120  , align:'center', formatter:'gridIndvFormat'},
									{name:"FHS_ID_NO"                  , index:"FHS_ID_NO"                  , width:80   , align:'center'},
									{name:"FARM_AMNNO"                 , index:"FARM_AMNNO"                 , width:80   , align:'center'},
									{name:"SRA_FHSNM"                  , index:"SRA_FHSNM"                  , width:80   , align:'center'},
									{name:"SRA_INDV_BIRTH"             , index:"SRA_INDV_BIRTH"             , width:80   , align:'center', formatter:'gridDateFormat'},
									{name:"SRA_INDV_MCOW_BRDSRA_RG_DSC", index:"SRA_INDV_MCOW_BRDSRA_RG_DSC", width:80   , align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
									{name:"SRA_KPN_NO"                 , index:"SRA_KPN_NO"                 , width:70   , align:'center'},
									{name:"INDV_SEX_C"                 , index:"INDV_SEX_C"                 , width:90   , align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
									{name:"MCOW_SRA_INDV_EART_NO"      , index:"MCOW_SRA_INDV_EART_NO"      , width:90   , align:'center'},
									{name:"SRA_INDV_LS_MATIME"         , index:"SRA_INDV_LS_MATIME"         , width:70   , align:'center'},
									{name:"SRA_INDV_PASG_QCN"          , index:"SRA_INDV_PASG_QCN"          , width:70   , align:'center'},
									{name:"SRA_INDV_ID_NO"             , index:"SRA_INDV_ID_NO"             , width:100  , align:'center'},
									{name:"SRA_INDV_BRDSRA_RG_NO"      , index:"SRA_INDV_BRDSRA_RG_NO"      , width:80   , align:'center'},
									{name:"SRA_SRS_DSC"                , index:"SRA_SRS_DSC"                , width:70   , align:'center'},
									{name:"NA_TRPL_C"                  , index:"NA_TRPL_C"                  , width:70   , align:'center'},
									{name:"ZIP"                        , index:"ZIP"                        , width:70   , align:'center'},
									{name:"DONGUP"                     , index:"DONGUP"                     , width:70   , align:'center'},
									{name:"DONGBW"                     , index:"DONGBW"                     , width:70   , align:'center'},
									{name:"OHSE_TELNO"                 , index:"OHSE_TELNO"                 , width:70   , align:'center'},
									{name:"CUS_MPNO"                   , index:"CUS_MPNO"                   , width:70   , align:'center'},
// 									{name:"MACO_YN"                    , index:"MACO_YN"                    , width:70   , align:'center'},
									{name:"DEL_YN"                     , index:"DEL_YN"                     , width:70   , align:'center'},
// 									{name:"JRDWO_DSC"                  , index:"JRDWO_DSC"                  , width:70   , align:'center'},
									{name:"SRA_FARM_ACNO"              , index:"SRA_FARM_ACNO"              , width:70   , align:'center'},
// 									{name:"SRA_FED_SPY_YN"             , index:"SRA_FED_SPY_YN"             , width:70   , align:'center'},
									{name:"SRA_INDV_BRDSRA_RG_DSC"     , index:"SRA_INDV_BRDSRA_RG_DSC"     , width:80   , align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}}
									];

		$("#grd_MmIndv").jqGrid("GridUnload");

		$("#grd_MmIndv").jqGrid({
			datatype:    "local",
			data:        data,
			height:      330,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   false,
			shrinkToFit: false, 
			rownumbers:true,
			rownumWidth:40,
			colNames: searchResultColNames,
			colModel: searchResultColModel,
			ondblClickRow: function(rowid, row, col) {
				fn_Select();
			}
		});

		//가로스크롤 있는경우 추가
		$("#grd_MmIndv .jqgfirstrow td:last-child").width(
		$("#grd_MmIndv .jqgfirstrow td:last-child").width() - 17);

		$("#grd_MmIndv").jqGrid("hideCol", "SRA_SRS_DSC");
		$("#grd_MmIndv").jqGrid("hideCol", "NA_TRPL_C");
		$("#grd_MmIndv").jqGrid("hideCol", "ZIP");
		$("#grd_MmIndv").jqGrid("hideCol", "DONGUP");
		$("#grd_MmIndv").jqGrid("hideCol", "DONGBW");
		$("#grd_MmIndv").jqGrid("hideCol", "OHSE_TELNO");
		$("#grd_MmIndv").jqGrid("hideCol", "CUS_MPNO");
		$("#grd_MmIndv").jqGrid("hideCol", "MACO_YN");
		$("#grd_MmIndv").jqGrid("hideCol", "DEL_YN");
		$("#grd_MmIndv").jqGrid("hideCol", "JRDWO_DSC");
		$("#grd_MmIndv").jqGrid("hideCol", "SRA_FARM_ACNO");
		$("#grd_MmIndv").jqGrid("hideCol", "SRA_FED_SPY_YN");
	}
</script>
</html>