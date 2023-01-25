<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%@ include file="/WEB-INF/common/serviceCall.jsp"%>
<%@ include file="/WEB-INF/common/head.jsp"%>

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
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
		/******************************
		 * 초기값 설정
		 ******************************/
		fn_CreateGrd_MmMwmn();

		/******************************
		 * 입력초기화
		 ******************************/
		$("#pb_Init").bind('click', function(e) {
			e.preventDefault();
			this.blur();
			fn_BtnInit();
		});

		/******************************
		 * 개인정보동의서 출력
		 ******************************/
		$("#pb_Psn").on('click', function(e) {
			e.preventDefault();
			this.blur();

			var TitleData = new Object();
			TitleData.title = "<개인정보의 수집ㆍ 이용 동의서>";
			TitleData.sub_title = "";
			TitleData.unit = "";

			var tmpObject = new Array();

			gridSaveRow('grd_MmMwmn');
			var ids = $('#grd_MmMwmn').jqGrid('getDataIDs');
			for (var i = 0, len = ids.length; i < len; i++) {
				var rowId = ids[i];
				if ($("input:checkbox[id='jqg_grd_MmMwmn_" + rowId + "']").is(":checked")) {
					var rowdata = $("#grd_MmMwmn").jqGrid('getRowData', rowId);
					tmpObject.push(rowdata);
				}
			}

			ReportPopup('LALM0113R0', TitleData, tmpObject, 'V');//V:가로 , H:세로
		});

		/******************************
		 * 주소 검색
		 ******************************/
		$("#pb_SearchZip").on('click', function(e) {
			e.preventDefault();
			this.blur();
			new daum.Postcode({
				oncomplete : function(data) {
					console.log(data);
					$("#zip").val(data.zonecode);
					$("#dongup").val(data.roadAddress);
					$("#dongbw").focus();
				}
			}).open();
		});

		/******************************
		 * 경제통합거래처 검색
		 ******************************/
		$("#pb_SearchTrpl").bind('click', function(e) {
			e.preventDefault();
			this.blur();
			fn_CallBmTrplPopup(null, null, function(result) {
				if (result) {
					fn_SetTrpl(result);
				}
			});
		});

		/******************************
		 * 경제통합거래처 삭제
		 ******************************/
		$("#pb_DelTrpl").bind('click', function(e) {
			e.preventDefault();
			this.blur();
			fn_BtnDelTrpl();
		});

		/******************************
		 * 중도매인 검색 이벤트(엔터키)
		 ******************************/
		$("#sr_sra_mwmnnm").on("keydown", function(e) {
			if (e.keyCode == 13) {
				if (fn_isNull($("#sr_sra_mwmnnm").val())) {
					MessagePopup('OK', '중도매인 명을 입력하세요.');
					return;
				} else {
					fn_Search();
				}
			}
		});
		
		
		/******************************
		 * 통합회원코드 검색 이벤트(엔터키)
		 ******************************/
		$("#mb_intg_no").bind("keydown", function(e){
			this.blur();
			var param = new Object();
			param["mb_intg_gb"] = "01";
			fn_CallSearchIntgNoPopup(param, null ,function(result){
				if(result) fn_SetIntgInfo(result);
			});
		});
		
		/******************************
		 * 통합회원코드 검색 버튼 이벤트
		 ******************************/
		$("#pb_SearchIntgNo").bind("click", function(){
			this.blur();
			var param = new Object();
			param["mb_intg_gb"] = "01";
			fn_CallSearchIntgNoPopup(param, null ,function(result){
				if(result) fn_SetIntgInfo(result);
			});
		});
		
		/******************************
		 * 경제통합거래처 검색
		 ******************************/
		$("#pb_DelIntgNo").bind("click", function(){
			this.blur();
			fn_DelIntgNo();
		});
		
		fn_Init();
	});

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 초기화 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Init() {
		$("#btn_Save").attr('disabled', false);
		$("#btn_Delete").attr('disabled', false);

		//폼 초기화
		fn_InitFrm('frm_Search');
		fn_InitFrm('frm_MmMwmn');
		//그리드 초기화
		$("#grd_MmMwmn").jqGrid("clearGridData", true);

		$("#sr_sra_mwmnnm").focus();
	}

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search() {
		$("#btn_Save").attr('disabled', false);
		$("#btn_Delete").attr('disabled', false);

		fn_InitFrm('frm_MmMwmn');
		//그리드 초기화
		$("#grd_MmMwmn").jqGrid("clearGridData", true);

		//중도매인 리스트
		var results = sendAjaxFrm("frm_Search", "/LALM0113_selListGrd_MmMwmn", "POST");
		var result;
		if (results.status != RETURN_SUCCESS) {
			showErrorMessage(results);
			return;
		} else {
			result = setDecrypt(results);
		}
		fn_CreateGrd_MmMwmn(result);
	}

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 저장 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Save() {
		if ('8808990660783|'.indexOf(App_na_bzplc) > -1 && ($("#cus_rlno").val() == '' || $("#cus_mpno").val() == '')) {
			MessagePopup('OK', '실명번호앞자리, 휴대폰번호는\n필수입력 항목 입니다.');
			return;
		}
		else if ('8808990660783|'.indexOf(App_na_bzplc) < 0 && ($("#cus_rlno").val() == '' || $("#dongup").val() == '' || $("#dongbw").val() == '' || $("#cus_mpno").val() == '')) {
			MessagePopup('OK', '실명번호앞자리, 동이상주소, 동이하주소, 휴대폰번호는\n필수입력 항목 입니다.');
			return;
		}

		//값이 없으면 신규
		if ($("#trmn_amnno").val() == '') {
			MessagePopup('YESNO', "저장하시겠습니까?", function(res) {
				if (res) {
					var results = sendAjaxFrm("frm_MmMwmn", "/LALM0113_insTrmn", "POST");
					var result;
					if (results.status != RETURN_SUCCESS) {
						showErrorMessage(results);
						return;
					} else {
						MessagePopup("OK", "정상적으로 처리되었습니다.", function(res) {
							fn_Search();
						});
					}
				} else {
					MessagePopup('OK', '취소되었습니다.');
				}
			});
		} else {
			MessagePopup('YESNO', "수정하시겠습니까?", function(res) {
				if (res) {
					var results = sendAjaxFrm("frm_MmMwmn", "/LALM0113_updTrmn", "POST");
					var result;
					if (results.status != RETURN_SUCCESS) {
						showErrorMessage(results);
						return;
					} else {
						MessagePopup("OK", "정상적으로 처리되었습니다.", function(res) {
							fn_Search();
						});
					}
				} else {
					MessagePopup('OK', '취소되었습니다.');
				}
			});
		}
	}

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 삭제 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Delete() {
		MessagePopup('YESNO', "삭제하시겠습니까?", function(res) {
			if (res) {
				var results = sendAjaxFrm("frm_MmMwmn", "/LALM0113_delTrmn", "POST");
				var result;
				if (results.status != RETURN_SUCCESS) {
					showErrorMessage(results);
					return;
				} else {
					MessagePopup("OK", "정상적으로 처리되었습니다.", function(res) {
						fn_Search();
					});
				}
			} else {
				MessagePopup('OK', '취소되었습니다.');
			}
		});
	}

	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 엑셀 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Excel() {
		fn_ExcelDownlad('grd_MmMwmn', '중도매인관리');

	}
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 출력 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Print() {
		var TitleData = new Object();
		TitleData.title = "중도매인 관리";
		TitleData.sub_title = "";
		TitleData.unit = "";
		TitleData.srch_condition = '[중도매인 : ' + $('#sra_mwmnnm').val() + ']';

		ReportPopup('LALM0113R', TitleData, 'grd_MmMwmn', 'V');
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 통합회원코드 검색결과 처리 이벤트
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_SetIntgInfo(data) {
		// 기존 input에 통합회원코드가 있는 경우 변경 여부 confirm 메시지창 보여주기.
		var ori_mb_intg_no = $("#mb_intg_no");
		if (fn_isNull(ori_mb_intg_no.val())) {
			ori_mb_intg_no.val(data.MB_INTG_NO);
			return;
		}
		
		if (ori_mb_intg_no.val() != data.MB_INTG_NO) {
			MessagePopup('YESNO', "통합회원번호를 변경하시겠습니까?<br/>(저장 후 최종 변경됩니다.)", function(res) {
				if (res) {
					ori_mb_intg_no.val(data.MB_INTG_NO);
				}
			});
		}
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 통합회원코드 삭제 이벤트
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_DelIntgNo() {
		if(fn_isNull($("#trmn_amnno").val())) {
			MessagePopup("OK", "통합회원코드를 삭제할 중도매인을 선택하세요.");
			return;
		}
		
		MessagePopup('YESNO', "통합회원코드를 삭제하시겠습니까?", function(res) {
			if (res) {
				var results = sendAjaxFrm("frm_MmMwmn", "/LALM0113_delMbIntgNo", "POST");
				var result;
				if (results.status != RETURN_SUCCESS) {
					showErrorMessage(results);
					return;
				} else {
					MessagePopup("OK", "정상적으로 처리되었습니다.", function(res) {
						fn_Search();
					});
				}
			} else {
				MessagePopup('OK', '취소되었습니다.');
			}
		});
	}

	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////
	function fn_CreateGrd_MmMwmn(data){
		var rowNoValue = 0;
		if(data != null){
			rowNoValue = data.length;
		
		}
		
		var searchResultColNames = ["경제통합거래처코드","중도매인코드","통합회원코드","중도매인명","생년월일","생년월일/사업자<br> 번호","경제통합거래처"
									,"전화번호","휴대폰","조합원","관내외구분","개인정보<br>제공동의"
									,"우편번호","주소","상세주소","비고내용","삭제여부"
									,"최초등록일시","최초등록자개인번호","최종변경일시","최종변경자개인번호"
									,"고객실명번호","전송"];
		var searchResultColModel = [
									{name:"NA_BZPLC",           index:"NA_BZPLC",                 width:60, align:'center', hidden:true},
									{name:"TRMN_AMNNO",         index:"TRMN_AMNNO",               width:60, align:'center', sorttype: "number"},
									{name:"MB_INTG_NO",         index:"MB_INTG_NO",               width:60, align:'center', sorttype: "number"},
									{name:"SRA_MWMNNM",         index:"SRA_MWMNNM",               width:60, align:'center'},
									{name:"FRLNO",              index:"FRLNO",                    width:60, align:'center', formatter:'gridDateFormat'},
									{name:"CUS_RLNO",           index:"CUS_RLNO",                 width:70, align:'left'},
									{name:"MWMN_NA_TRPL_C",     index:"MWMN_NA_TRPL_C",           width:60, align:'center'},
									{name:"OHSE_TELNO",         index:"OHSE_TELNO",               width:60, align:'center'},
									{name:"CUS_MPNO",           index:"CUS_MPNO",                 width:60, align:'center'},
									{name:"MACO_YN",            index:"MACO_YN",                  width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"JRDWO_DSC",          index:"JRDWO_DSC",                width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:관내;2:관외;"}},
									{name:"PSN_INF_OFR_AGR_YN", index:"PSN_INF_OFR_AGR_YN",       width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"ZIP",                index:"ZIP",                      width:50, align:'center', formatter:'gridPostFormat'},
									{name:"DONGUP",             index:"DONGUP",                   width:120, align:'left'},
									{name:"DONGBW",             index:"DONGBW",                   width:120, align:'left'},
									{name:"RMK_CNTN",           index:"RMK_CNTN",                 width:120, align:'left'},
									{name:"DEL_YN",             index:"DEL_YN",                   width:90, align:'center', hidden:true},
									{name:"FSRG_DTM",           index:"FSRG_DTM",                 width:90, align:'center', hidden:true},
									{name:"FSRGMN_ENO",         index:"FSRGMN_ENO",               width:90, align:'center', hidden:true},
									{name:"LSCHG_DTM",          index:"LSCHG_DTM",                width:90, align:'center', hidden:true},
									{name:"LS_CMENO",           index:"LS_CMENO",                 width:90, align:'center', hidden:true},		              
									{name:"CUS_RLNO",           index:"CUS_RLNO",                 width:90, align:'center', hidden:true},
									{name:"TMS_YN",             index:"TMS_YN",                   width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									];
		
		$("#grd_MmMwmn").jqGrid("GridUnload");
		
		$("#grd_MmMwmn").jqGrid({
			datatype:    "local",
			data:        data,
			height:      300,
			rowNum:      rowNoValue,
			resizeing:   true,
			autowidth:   false,
			shrinkToFit: false, 
			rownumbers:  true,
			rownumWidth:30,
			multiselect:true,
			colNames: searchResultColNames,
			colModel: searchResultColModel,
			beforeSelectRow:function(rowid,e){
				var $myGrid = $(this);
				var i= $.jgrid.getCellIndex($(e.target).closest('td')[0]);
				var cm = $myGrid.jqGrid('getGridParam','colModel');
			},
			onSelectRow: function(rowid, status, e){
				fn_InitFrm('frm_MmMwmn');
				
				var sel_data = $("#grd_MmMwmn").getRowData(rowid);
				var srhData = new Object();
				srhData["trmn_amnno"] = sel_data.TRMN_AMNNO;
				var results = sendAjax(srhData, "/LALM0113_selDetail", "POST");
				var result;
				
				if(results.status != RETURN_SUCCESS){
					showErrorMessage(results);
					return;
				}
				else{
					result = setDecrypt(results);
				}
				
				// 휴면회원인 경우 휴면/이용해지 관리 메뉴로 이동
				if (result.DORMACC_YN != '0') {
					MessagePopup('YESNO', "휴면회원입니다. 휴면 해제 하시겠습니까?", function(res){
						if (res) {
							var data = new Object();
							data["na_bzplc"] = result.NA_BZPLC;
							data["trmn_amnno"] = result.TRMN_AMNNO;
							data["mb_intg_no"] = result.MB_INTG_NO;
							
							fn_OpenMenu('LALM0117',data);
						}
					});
				}
				else {
					//fn_xxsDecode
					fn_setFrmByObject("frm_MmMwmn", result);
					fn_setChgRadio("maco_yn", result.MACO_YN);
					fn_setRadioChecked("maco_yn");
					fn_setChgRadio("jrdwo_dsc", result.JRDWO_DSC);
					fn_setRadioChecked("jrdwo_dsc");
					fn_setChgRadio("psn_inf_ofr_agr_yn", result.PSN_INF_OFR_AGR_YN);
					fn_setRadioChecked("psn_inf_ofr_agr_yn");
					
					if(result.NA_BZPLC == App_na_bzplc){
						$("#btn_Save").attr('disabled', false);
						$("#btn_Delete").attr('disabled', false);
					}
					else{
						$("#btn_Save").attr('disabled', true);
						$("#btn_Delete").attr('disabled', true);
					}
				}
			}
		});
		
		//행번호
		$("#grd_MmMwmn").jqGrid("setLabel", "rn","No");  
		//가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
		//$("#grd_MmMwmn .jqgfirstrow td:last-child").width($("#grd_MmMwmn .jqgfirstrow td:last-child").width() - 17);
	}

	// 임력초기화 이벤트
	function fn_BtnInit() {
		fn_InitFrm('frm_MmMwmn');
		$("#btn_Save").attr('disabled', false);
		$("#btn_Delete").attr('disabled', true);

		fn_setChgRadio("maco_yn", '0');
		fn_setRadioChecked("maco_yn");
		$("#maco_yn").attr('disabled', false);
		fn_setChgRadio("jrdwo_dsc", '1');
		fn_setRadioChecked("jrdwo_dsc");
		fn_setChgRadio("psn_inf_ofr_agr_yn", '0');
		fn_setRadioChecked("psn_inf_ofr_agr_yn");

		$("#sra_mwmnnm").focus();
	}

	// 경제통합거래처 삭제이벤트
	function fn_BtnDelTrpl() {
		$("#mwmn_na_trpl_c").val('');
		fn_setChgRadio("maco_yn", '0');
		fn_setRadioChecked("maco_yn");
		$("#maco_yn").attr('disabled', false);
	}

	// 경제통합거래처 선택 이벤트
	function fn_SetTrpl(result) {
		$("#mwmn_na_trpl_c").val(result.NA_TRPL_C);

		//조합원여부 체크
		var srchData = new Object();

		srchData["ctgrm_cd"] = "3600";
		srchData["na_bzplc"] = App_na_bzplc;
		srchData["mwmn_na_trpl_c"] = $("#mwmn_na_trpl_c").val();

		var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
		var result;

		if (results.status != RETURN_SUCCESS) {
			showErrorMessage(results);
			return;
		} else {
			result = setDecrypt(results);
		}

		fn_setChgRadio("maco_yn", result.MACO_YN);
		fn_setRadioChecked("maco_yn");
		$("#maco_yn").attr('disabled', true);
	}
</script>
<body>
	<div class="contents">
		<%@ include file="/WEB-INF/common/menuBtn.jsp"%>
		<!-- content -->
		<section class="content">
			<div class="tab_box clearfix">
				<ul class="tab_list">
					<li><p class="dot_allow">검색조건</p></li>
				</ul>
			</div>
			<div class="sec_table">
				<div class="blueTable rsp_v">
					<form id="frm_Search" name="frm_Search">
						<table>
							<colgroup>
								<col width="150">
								<col width="250">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">중도매인</th>
									<td><input type="text" id="sr_sra_mwmnnm" maxlength="30" />
									</td>
									<td></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
			<!-- 중도매인 정보 -->
			<div class="tab_box clearfix">
				<ul class="tab_list fl_L">
					<li><p class="dot_allow">중도매인 정보</p></li>
				</ul>
				<div class="pl2 fl_L">
					<!--  //버튼 모두 우측정렬 -->
					<label id="msg_Sbid"
						style="font-size: 15px; color: blue; font: message-box;">※
						필수입력사항 : 중도매인명, 생년월일/사업자 번호(숫자만 입력 가능), 주소, 휴대폰</label>
				</div>
				<div class="fl_R">
					<!--  //버튼 모두 우측정렬 -->
					<button class="tb_btn" id="pb_Init">입력초기화</button>
				</div>
			</div>
			<div class="sec_table">
				<div class="grayTable rsp_v">
					<form id="frm_MmMwmn">
						<input type="hidden" id="frlno" />
						<table>
							<colgroup>
								<col width="16%">
								<col width="16%">
								<col width="16%">
								<col width="16%">
								<col width="16%">
								<col width="17%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">중도매인코드<strong class="req_dot">*</strong></th>
									<td><input type="text" id="trmn_amnno" disabled="disabled" /></td>
									<th scope="row">중도매인명<strong class="req_dot">*</strong></th>
									<td><input type="text" id="sra_mwmnnm" class="popup" /></td>
									<th scope="row">생년월일/사업자 번호<strong class="req_dot">*</strong></th>
									<td><input type="text" id="cus_rlno" /></td>
								</tr>
								<tr>
									<th scope="row">주소<strong class="req_dot">*</strong></th>
									<td>
										<div class="cellBox v_addr">
											<div class="cell" style="width: 60px;">
												<input disabled="disabled" type="text" id="zip" disabled="disabled">
											</div>
											<div class="cell pl2" style="width: 26px;">
												<button type="button" id="pb_SearchZip" class="tb_btn white srch">
													<i class="fa fa-search"></i>
												</button>
											</div>
										</div>
									</td>
									<td>
										<input type="text" id="dongup" maxlength="40" />
									</td>
									<td>
										<input type="text" id="dongbw" maxlength="50" />
									</td>
									<th scope="row">비고</th>
									<td><input type="text" id="rmk_cntn" maxlength='30'/></td>
								</tr>
								<tr>
									<th scope="row">경제통합거래처</th>
									<td>
										<div class="cellBox v_addr">
											<div class="cell" style="width: 60px;">
												<input disabled="disabled" type="text" id="mwmn_na_trpl_c" disabled="disabled">
											</div>
											<div class="cell pl2" style="width: 26px;">
												<button type="button" id="pb_SearchTrpl" class="tb_btn white srch">
													<i class="fa fa-search"></i>
												</button>
											</div>
											<div class="cell" style="width: 26px;">
												<button type="button" id="pb_DelTrpl" class="tb_btn">삭제</button>
											</div>
										</div>
									</td>
									<th scope="row">전화번호</th>
									<td><input type="text" id="ohse_telno" class="digit" maxlength="14" /></td>
									<th scope="row">휴대폰<strong class="req_dot">*</strong></th>
									<td><input type="text" id="cus_mpno" class="digit" maxlength="14" /></td>
								</tr>
								<tr>
									<th scope="row">조합원</th>
									<td>
										<div class="cellBox" id="rd_maco_yn">
											<div class="cell">
												<input type="radio" id="maco_yn_0" name="maco_yn_radio" value="0" onclick="javascript:fn_setChgRadio('maco_yn','0');" />
												<label for="maco_yn_0">비조합원</label>
												<input type="radio" id="maco_yn_1" name="maco_yn_radio" value="1" onclick="javascript:fn_setChgRadio('maco_yn','1');" />
												<label for="maco_yn_1">조합원</label>
											</div>
										</div>
										<input type="hidden" id="maco_yn" />
									</td>
									<th scope="row">관내외구분</th>
									<td>
										<div class="cellBox" id="rd_jrdwo_dsc">
											<div class="cell">
												<input type="radio" id="jrdwo_dsc_1" name="jrdwo_dsc_radio" value="1" onclick="javascript:fn_setChgRadio('jrdwo_dsc','1');" />
												<label for="jrdwo_dsc_1">관내</label>
												<input type="radio" id="jrdwo_dsc_2" name="jrdwo_dsc_radio" value="2" onclick="javascript:fn_setChgRadio('jrdwo_dsc','2');" />
												<label for="jrdwo_dsc_2">관외</label>
											</div>
										</div>
										<input type="hidden" id="jrdwo_dsc" />
									</td>
									<th scope="row">개인정보제공동의</th>
									<td>
										<div class="cellBox" id="rd_psn_inf_ofr_agr_yn">
											<div class="cell">
												<input type="radio" id="psn_inf_ofr_agr_yn_0" name="psn_inf_ofr_agr_yn_radio" value="0"	onclick="javascript:fn_setChgRadio('psn_inf_ofr_agr_yn','0');" />
												<label for="psn_inf_ofr_agr_yn_0">미동의</label>
												<input type="radio" id="psn_inf_ofr_agr_yn_1" name="psn_inf_ofr_agr_yn_radio" value="1" onclick="javascript:fn_setChgRadio('psn_inf_ofr_agr_yn','1');" />
												<label for="psn_inf_ofr_agr_yn_1">동의</label>
											</div>
										</div> <input type="hidden" id="psn_inf_ofr_agr_yn" />
									</td>
								</tr>
								<tr>
									<th scope="row">통합회원코드</th>
									<td>
										<div class="cellBox v_addr">
											<div class="cell" style="width:60%;">
												<input type="text" id="mb_intg_no" readonly="readonly" />
												<input type="hidden" id="mb_intg_gb" value="01" readonly="readonly" />
											</div>
											<div class="cell pl2" style="width:15%;">
												<button type="button" id="pb_SearchIntgNo" class="tb_btn white srch">
													<i class="fa fa-search"></i>
												</button>
											</div>
											<div class="cell" style="width:25%;">
												<button type="button" id="pb_DelIntgNo" class="tb_btn">삭제</button>
											</div>
										</div>
									</td>
									<th scope="row">최근접속일자</th>
									<td>
										<input type="text" id="inout_dtm" readonly="readonly" />
									</td>
									<th scope="row"></th>
									<td></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
			</div>
			<!-- 검색결과 -->
			<div class="tab_box clearfix">
				<ul class="tab_list fl_L">
					<li><p class="dot_allow">검색결과</p></li>
				</ul>
				<div class="pl2 fl_L">
					<!--  //버튼 모두 우측정렬 -->
					<label id="msg_Sbid"
						style="font-size: 15px; color: blue; font: message-box;">※
						입력하신 내용(생년월일/사업자번호)과 다를경우 시스템관리자에게 문의해주세요.</label>
				</div>
				<div class="fl_R">
					<!--  //버튼 모두 우측정렬 -->
					<button class="tb_btn" id="pb_Psn">개인정보의 수집ㆍ이용 동의서</button>
				</div>
			</div>
			<div class="listTable rsp_v">
				<table id="grd_MmMwmn">
				</table>
			</div>
		</section>
	</div>
	<!-- ./wrapper -->
</body>
</html>