/*------------------------------------------------------------------------------
* 1. 단위업무명   : 가축시장
* 2. 파  일  명   : LALM1004
* 3. 파일명(한글) : 경매출장내역등록
*----------------------------------------------------------------------------*
------------------------------------------------------------------------------*/
////////////////////////////////////////////////////////////////////////////////
//  공통버튼 클릭함수 시작
////////////////////////////////////////////////////////////////////////////////
/*------------------------------------------------------------------------------
	* 1. 함 수 명    : onload 함수
	* 2. 입 력 변 수 : N/A
	* 3. 출 력 변 수 : N/A
	------------------------------------------------------------------------------*/
const na_bzplc = App_na_bzplc;
//mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
let mv_RunMode                = '1';
let mv_cut_am                 = '1';
let mv_sqno_prc_dsc           = '1';
let setRowStatus              = 'insert';

$(document).ready(function() {
	if (pageInfos.param) mv_RunMode = '2';

	if(parent.envList[0] == null) {
		MessagePopup("OK", "응찰단위금액이 입력되지 않았습니다.", function() {
			fn_OpenMenu('LALM0912','',true);
			return;
		});
		return;
	}

	// 최초 라디오버튼 세팅
	fn_setCodeRadio("rd_auc_obj_dsc", "auc_obj_dsc", "AUC_OBJ_DSC", 8);		// 입력창 경매대상구분
	fn_setCodeRadio("sc_auc_obj_dsc", "sch_auc_obj_dsc", "AUC_OBJ_DSC", 8);	// 검색창 경매대상구분
	
	// 최초 콤보박스 세팅
	fn_setCodeBox("indv_sex_c", "INDV_SEX_C", 1);							// 성별
	fn_setCodeBox("sel_sts_dsc", "SEL_STS_DSC", 1);							// 진행상태
	fn_setCodeBox("jrdwo_dsc", "JRDWO_DSC", 1);								// 관내/외

	// input, select 관련 이벤트 등록
	fn_setEvent();
	
	// 초기화, 기본 세팅
	fn_InitSet();

	// 경매출장내역 그리드 생성
	fn_CreateGrid();
});

/*------------------------------------------------------------------------------
* 1. 함 수 명    : 페이지 이벤트 등록 함수
* 2. 입 력 변 수 : N/A
* 3. 출 력 변 수 : N/A
------------------------------------------------------------------------------*/
function fn_setEvent() {
	/******************************
	 * 경매일자 변경이벤트
	 ******************************/
	$("#auc_dt").change(function() {
		fn_RcDtModify();
		fn_AucOnjDscModify();
	});
	
	/******************************
	 * 중도매인 검색 팝업 호출 이벤트(엔터)
	 ******************************/
	$("#sra_mwmnnm").keydown(function(e){
		if(e.keyCode == 13) {
			if(fn_isNull($("#sra_mwmnnm").val())) {
				MessagePopup('OK','중도매인 명을 입력하세요.');
			} else {
				const data = new Object();
				const qcn = $("#aucQcnGrid").getRowData();
				if(qcn[0].AUC_OBJ_DSC == '0'){
					data['auc_obj_dsc'] = qcn[0].AUC_OBJ_DSC;
				}else{
					data['auc_obj_dsc'] = $("#auc_obj_dsc").val();
				}
				
				data['auc_dt']      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
				data['sra_mwmnnm']  = $("#sra_mwmnnm").val();
				fn_CallMwmnnmNoPopup(data, true, function(result) {
					if(result){
						$("#trmn_amnno").val(result.TRMN_AMNNO);
						$("#sra_mwmnnm").val(result.SRA_MWMNNM);
						$("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
						$("#io_mwmn_maco_yn").val(result.IO_MWMN_MACO_YN);
					}
				});
			}
		} else {
			$("#trmn_amnno").val("");
			$("#lvst_auc_ptc_mn_no").val("");
			$("#io_mwmn_maco_yn").val("");
		}
	});
	
	/******************************
	 * 중도매인 검색 팝업 호출 이벤트(돋보기)
	 ******************************/
	$("#pb_sra_mwmnnm").on('click', function(e){
		e.preventDefault();
		const data = new Object();
		const qcn = $("#aucQcnGrid").getRowData();
		if(qcn[0].AUC_OBJ_DSC == '0'){
			data['auc_obj_dsc'] = qcn[0].AUC_OBJ_DSC;
		}else{
			data['auc_obj_dsc'] = $("#auc_obj_dsc").val();
		}

		data['auc_dt']      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
		data['sra_mwmnnm']  = $("#sra_mwmnnm").val();
		fn_CallMwmnnmNoPopup(data, false, function(result){
			if(result){
				$("#trmn_amnno").val(result.TRMN_AMNNO);
				$("#sra_mwmnnm").val(result.SRA_MWMNNM);
				$("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
				$("#io_mwmn_maco_yn").val(result.IO_MWMN_MACO_YN);
			} else {
				$("#trmn_amnno").val("");
				$("#sra_mwmnnm").val("");
				$("#lvst_auc_ptc_mn_no").val("");
				$("#io_mwmn_maco_yn").val("");
			}
		});
	});
	
	/******************************
	 * 출하주 검색 팝업 호출 이벤트(엔터)
	 ******************************/
	$("#ftsnm").keydown(function(e) {
		if(e.keyCode == 13) {
			if(fn_isNull($("#fhs_id_no").val())) {
				if(fn_isNull($("#ftsnm").val())) {
					MessagePopup('OK','출하주 명을 입력하세요.', function(){
						$("#ftsnm").focus();
					});
				} else {
					fn_CallFtsnmPopup(true, function() {
						$("#indv_sex_c").focus();
					});
				}
			} else {
				$("#indv_sex_c").focus();
			}
		} else{
			$("#fhs_id_no").val("");
			$("#farm_amnno").val("");
			$("#ohse_telno").val("");
			$("#zip").val("");
			$("#dongup").val("");
			$("#dongbw").val("");
			$("#sra_pdmnm").val("");
			$("#sra_pd_rgnnm").val("");
			$("#sog_na_trpl_c").val("");
			$("#io_sogmn_maco_yn").val("1");
			$("#jrdwo_dsc").val("1");
			$("#sra_farm_acno").val("");
		}
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
	 * 예방접종일 엔터 이벤트
	 ******************************/
	$("#vacn_dt").keydown(function(e) {
		if(e.keyCode == 13 || e.keyCode == 9) {
			if(!fn_isNull($("#vacn_dt").val())) {
				$("#brcl_isp_dt").focus();
			}
		}
	});
	
	/******************************
	 * 브루셀라 검사일 엔터 이벤트
	 ******************************/
	$("#brcl_isp_dt").keydown(function(e){
		if(e.keyCode == 13 || e.keyCode == 9) {
			$("#rmk_cntn").focus();
		}
	});
	
	/******************************
	 * 중량 변경 이벤트
	 ******************************/
	$("#cow_sog_wt").on("change keyup paste", function(e) {
		if(e.keyCode != 13) {
			let sbidAm = fn_calculateSbidAm($("#auc_obj_dsc").val(),
											fn_delComma($("#sra_sbid_upr").val()),
											fn_delComma($("#cow_sog_wt").val()),
											mv_sgno_prc_dsc,
											mv_cut_am);

			$("#sra_sbid_am").val(sbidAm);
		}
	});
	
	/******************************
	 * 응찰 예정가 변경 이벤트
	 ******************************/
	$("#lows_sbid_lmt_am_ex").on("change keyup paste input", function(e) {
		if(e.keyCode != 13) {
			let lowsSbidLmtAm = "0";
			if(!fn_isNull($("#lows_sbid_lmt_am_ex").val())) {
				const aucObjDsc = $("#auc_obj_dsc").val();
				const aucAtdrUntAm = fn_getAucAtdrUntAm(aucObjDsc);
				lowsSbidLmtAm = parseInt(fn_delComma($("#lows_sbid_lmt_am_ex").val()) * parseInt(aucAtdrUntAm));
			}
			$("#lows_sbid_lmt_am").val(fn_toComma(lowsSbidLmtAm));
		}
	});
	
	/******************************
	 * 낙찰가 금액변경 이벤트
	 ******************************/
	$("#sra_sbid_upr").on("change keyup paste", function(e) {
		if(e.keyCode != 13) {
			let sbidAm = fn_calculateSbidAm($("#auc_obj_dsc").val(),
											fn_delComma($("#sra_sbid_upr").val()),
											fn_delComma($("#cow_sog_wt").val()),
											mv_sgno_prc_dsc,
											mv_cut_am);
			
			$("#sra_sbid_am").val(sbidAm);
		}
	});
	
	/******************************
	 * 출하자 연속등록 체크/해제 이벤트
	 ******************************/
	$("#fhs_cont_yn").click(function() {
		if($(this).is(":checked")) {
			$("tr.fhs_info").find("input, select").addClass("reset_exc");
		} else {
			$("tr.fhs_info").find("input, select").removeClass("reset_exc");
		}
	});

	/******************************
	 * 경매대상 변경 이벤트
	 * 경매대상을 변경하면 축종구분코드도 변경
	 ******************************/
	$("#auc_obj_dsc").on("input change", function() {
		const sraSrsDsc = String($(this).val()) === '5' ? '06' : '04';
		$("#sra_srs_dsc").val(sraSrsDsc);
	});
}

/*------------------------------------------------------------------------------
	* 1. 함 수 명    : 초기화 함수
	* 2. 입 력 변 수 : N/A
	* 3. 출 력 변 수 : N/A
	------------------------------------------------------------------------------*/
function fn_Init() {
	mv_RunMode = '1';
	pageInfos.param = null;
	fn_InitFrm('frm_MhSogCow');
	fn_InitSet();
}

/*------------------------------------------------------------------------------
	* 1. 함 수 명    : 조회 함수
	* 2. 입 력 변 수 : N/A
	* 3. 출 력 변 수 : N/A
	------------------------------------------------------------------------------*/
function fn_Search() {
	if(!fn_isDate($("#sch_auc_dt").val())){
		MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.', function(){
			$("#sch_auc_dt").focus();
		});
		return;
	}
	$("#grd_Etc").jqGrid("clearGridData", true);

	const schData = {
		auc_obj_dsc: $("#sch_auc_obj_dsc").val(),
		auc_dt: fn_dateToData($("#sch_auc_dt").val()),
		fhs_id_no: $("#sch_fhs_id_no").val(),
		auc_prg_sq: $("#sch_auc_prg_sq").val(),
		ftsnm: $("#sch_ftsnm").val(),
	};

	const results = sendAjax(schData, "/LALM1003_selList", "POST");
	let result;
	if(results.status == RETURN_SUCCESS) {
		result = setDecrypt(results);
		fn_CreateGrid(result);
	}
}

// 필수 입력 값 체크
function fn_CheckRequiredVal() {
	// 경매일자 체크
	if(parseInt(fn_dateToData($("#auc_dt").val())) < parseInt(fn_dateToData($("#rc_dt").val()))) {
		MessagePopup("OK", "접수일자는 경매일자 보다 클수 없습니다.");
		$("#rc_dt").focus();
		return false;
	}

	if(fn_isNull($.trim($("#fhs_id_no").val())) || fn_isNull($.trim($("#ftsnm").val()))) {
		MessagePopup("OK", "출하주를 선택하세요.", function(){$("#ftsnm").focus();});
		return false;
	}

	// 성별, 출하주 체크
	if($("#indv_sex_c").val() === '0') {
		MessagePopup("OK", "개체성별을 선택하세요.", function(){$("#indv_sex_c").focus();});
		return false;
	}

	// 진행상태에 따라 필수 입력 값 체크
	// 낙찰(22) 인 경우 중도매인, 낙찰단가, 낙찰금액, 예정가 체크
	if($("#sel_sts_dsc").val() === '22') {
		const aucObjDsc = $("#auc_obj_dsc").val();
		// 기타 가축 단가 기준
		const aucUprDsc = fn_getAucUprDsc(aucObjDsc);

		if(($("#lows_sbid_lmt_am_ex").val()||'0') === '0') {
			MessagePopup('OK','예정가가 없습니다. 예정가를 입력해주세요.');
			return false;
		}

		if(fn_isNull($("#trmn_amnno").val()) || fn_isNull($("#sra_mwmnnm").val())) {
			MessagePopup('OK','중도매인을 입력하세요.');
			return false;
		}

		if(($("#sra_sbid_upr").val()||'0') === '0') {
			MessagePopup('OK','낙찰단가를 입력하세요.');
			return false;
		}
		// 경매 단가 기준이 KG인 경우 중량을 나중에 측정할 수 있어 낙찰 금액이 없을 수 있음
		if(aucUprDsc !== '1') {
			if(($("#sra_sbid_am").val()||'0') === '0') {
				MessagePopup('OK','낙찰금액이 없습니다.');
				return false;
			}
		}
	}
	else {
		if(($("#sra_sbid_am").val()||'0') !== '0') {
			MessagePopup('OK','낙찰이 아닌경우 낙찰금액을 입력할수 없습니다.');
			$("#sra_sbid_upr").focus();
			return false;
		}
	}
	return true;
}

// 경매에 관련된 값 체크
function fn_CheckAuctionVal() {
	// 경매차수 조회
	const resultAucQcn = fn_SelAucQcn();
	if(!resultAucQcn?.length) {
		MessagePopup('OK',"경매차수가 등록되지 않았습니다.");
		return false;
	} else {
		if(resultAucQcn[0]["DDL_YN"] == 1) {
			MessagePopup("OK", "경매마감 되었습니다.");
			return false;
		}
	}

	// 차수에 설정된 응찰한도금액 체크
	const aucQcn = resultAucQcn[0];
	if(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) > parseInt(aucQcn["BASE_LMT_AM"])){
		MessagePopup("OK", "예정가가 최고 응찰 한도금액을 초과 하였습니다.");
		$("#lows_sbid_lmt_am_ex").focus();
		return false;
	}
	if(parseInt(fn_delComma($("#sra_sbid_upr").val())) < parseInt(fn_delComma($("#lows_sbid_lmt_am_ex").val()))) {
		MessagePopup('OK','낙찰단가가 예정가 보다 작습니다.');
		return false;
	}
	
	const aucObjDsc = $("#auc_obj_dsc").val();
	const aucAtdrUntAm = fn_getAucAtdrUntAm(aucObjDsc)
	let v_sra_sbid_upr = parseInt(fn_delComma($("#sra_sbid_upr").val())) * parseInt(aucAtdrUntAm);
	
	if(parseInt(v_sra_sbid_upr) > parseInt(resultAucQcn[0]["BASE_LMT_AM"])) {
		MessagePopup('OK', '낙찰단가가 최고 응찰 한도금액을 초과 하였습니다.(최고응찰한도금액:' + resultAucQcn[0]["BASE_LMT_AM"]+'원', function() {
			$("#sra_sbid_upr").focus();
		});
		return false;
	}

	return true;
}
/*------------------------------------------------------------------------------
	* 1. 함 수 명    : 저장 함수
	* 2. 입 력 변 수 : N/A
	* 3. 출 력 변 수 : N/A
	------------------------------------------------------------------------------*/
function fn_Save() {
	if (!fn_CheckRequiredVal()) return;
	if (!fn_CheckAuctionVal()) return;
	
	let saveMessage = "저장 하시겠습니까?";
	
	if(setRowStatus == "update") {
		const resultStsDscs = sendAjaxFrm("frm_MhSogCow", "/LALM1004_selStsDsc", "POST");
		let resultStsDsc;
		
		if(resultStsDscs.status == RETURN_SUCCESS) {
			resultStsDsc = setDecrypt(resultStsDscs);
			
			if(resultStsDsc[0]["SEL_STS_DSC"] != $("#sel_sts_dsc").val()) {
				if(resultStsDsc[0]["SEL_STS_DSC"] === '22'){
					let message = `<br/>낙찰상태 변경 사유를 입력하세요.<br/><br/>
						<input id="input_rn" maxlength="30" style="padding: 4px 6px 2px 6px;width: 100%;line-height: 12px;border: 1px solid #d9d9d9;vertical-align: middle;background: #fff;outline: none;"/>
						<script type="text/javascript">
							$(document).find(\'input[id=input_rn]\').focusout(function(e){
								$(\'#chg_rmk_cntn\').val($(this).val());
								parent.inputRn=$(this).val();
							});
						</script>`;
					saveMessage += message;
					fn_SaveSogCow(saveMessage);
					parent.inputRn='';
					return;
				}
				saveMessage = "경매진행상태가 일치하지 않습니다. 그래도 저장하시겠습니까?";
			}
		}
	}
	fn_SaveSogCow(saveMessage);
}

function fn_SaveSogCow(saveMessage) {
	MessagePopup('YESNO', saveMessage, function(res) {
		if(res) {
			// 수수료 조회
			const feeList = fn_SelFee();
			// 출하자, 낙찰자에게 부과할 수수료 리스트
			const feeImpsList = [];

			// 콤마 삭제
			$("#sra_sbid_am").val(fn_delComma($("#sra_sbid_am").val()));
			$("#lows_sbid_lmt_am").val(fn_delComma($("#lows_sbid_lmt_am").val()));
			
			//수수료 데이타 처리
			if(fn_isNull(feeList)) {
				MessagePopup('OK','수수료코드가 등록되어있지 않습니다.');
				return;
			}
			else {
				for(const feeInfo of feeList) {
					let feeImps = {...feeInfo};
					let v_upr = 0;
					const sraSbidAm = fn_delComma($("#sra_sbid_am").val());
					const macoYn = feeInfo["FEE_APL_OBJ_C"] === "1" ? $("#io_sogmn_maco_yn").val() : $("#io_mwmn_maco_yn").val();
					const feeUprKey = macoYn === '1' ? 'MACO_FEE_UPR' : 'NMACO_FEE_UPR';
					
					// 출하/판매수수료
					if(['010', '011'].includes(feeInfo["NA_FEE_C"])) {
						if($("#ppgcow_fee_dsc").val() === feeInfo["PPGCOW_FEE_DSC"]) {
							// 금액
							if(feeInfo["AM_RTO_DSC"] === '1') {
								// 낙찰, 불락
								if((feeInfo["SBID_YN"] === '1' && $("#sel_sts_dsc").val() === '22')
								|| (feeInfo["SBID_YN"] === '0' && $("#sel_sts_dsc").val() === '23')) {
									feeImps["SRA_TR_FEE"] = parseInt(feeInfo[feeUprKey]);
								} else {
									feeImps["SRA_TR_FEE"] = 0;
								}
							// 율
							} else {
								// 낙찰
								if(feeInfo["SBID_YN"] === '1' && $("#sel_sts_dsc").val() === '22') {
									v_upr = parseInt(sraSbidAm) * parseInt(feeInfo[feeUprKey]) / 100;

									if(feeInfo["SGNO_PRC_DSC"] === '1') {
										feeImps["SRA_TR_FEE"] = Math.floor(parseInt(v_upr));
									} else if(feeInfo["SGNO_PRC_DSC"] === '2') {
										feeImps["SRA_TR_FEE"] = Math.ceil(parseInt(v_upr));
									} else {
										feeImps["SRA_TR_FEE"] = Math.round(parseInt(v_upr));
									}
								} else {
									feeImps["SRA_TR_FEE"] = 0;
								}
							}
						}
					// 나머지 수수료
					} else {
						var v_ppgcow_fee_dsc = fn_GetPpgcowFeeDsc(feeInfo);
						if(v_ppgcow_fee_dsc == feeInfo["PPGCOW_FEE_DSC"]) {
							// 금액
							if(feeInfo["AM_RTO_DSC"] === '1') {
								// 낙찰, 불락
								if((feeInfo["SBID_YN"] === '1' && $("#sel_sts_dsc").val() === '22')
								|| (feeInfo["SBID_YN"] === '0' && $("#sel_sts_dsc").val() === '23')) {
									feeImps["SRA_TR_FEE"] = parseInt(feeInfo[feeUprKey]);
								} else {
									feeImps["SRA_TR_FEE"] = 0;
								}
							// 율
							} else {
								// 낙찰
								if(feeInfo["SBID_YN"] === '1' && $("#sel_sts_dsc").val() === '22') {
									v_upr = parseInt(sraSbidAm) * parseInt(feeInfo[feeUprKey]) / 100;

									if(feeInfo["SGNO_PRC_DSC"] === '1') {
										feeImps["SRA_TR_FEE"] = Math.floor(parseInt(v_upr));
									} else if(feeInfo["SGNO_PRC_DSC"] === '2') {
										feeImps["SRA_TR_FEE"] = Math.ceil(parseInt(v_upr));
									} else {
										feeImps["SRA_TR_FEE"] = Math.round(parseInt(v_upr));
									}
								} else {
									feeImps["SRA_TR_FEE"] = 0;
								}
							}
						}
					}
					feeImpsList.push(feeImps);
				} // End For

				if(fn_isNull($("#case_cow").val())) {
					$("#case_cow").val("1");
				}
				// 추가운송비
				if(fn_isNull($("#sra_trpcs").val())) {
					$("#sra_trpcs").val("0");
				}
				// 출자금
				if(fn_isNull($("#sra_pyiva").val())) {
					$("#sra_pyiva").val("0");
				}
				// 사료대금
				if(fn_isNull($("#sra_fed_spy_am").val())) {
					$("#sra_fed_spy_am").val("0");
				}
				// 당일접수비
				if(fn_isNull($("#td_rc_cst").val())) {
					$("#td_rc_cst").val("0");
				}
				// 사료사용여부금액
				if(fn_isNull($("#sra_fed_spy_yn_fee").val())) {
					$("#sra_fed_spy_yn_fee").val("0");
				}
				// 출하수수료수기등록
				if(fn_isNull($("#fee_chk_yn_fee").val())) {
					$("#fee_chk_yn_fee").val("0");
				}
				// 판매수수료수기등록
				if(fn_isNull($("#selfee_chk_yn_fee").val())) {
					$("#selfee_chk_yn_fee").val("0");
				}
				// 개체 중량
				if(fn_isNull($("#cow_sog_wt").val())) {
					$("#cow_sog_wt").val("0");
				}
				if(fn_isNull($("#brcl_isp_rzt_c").val())) {
					$("#brcl_isp_rzt_c").val("0");
				}
				
				let sendUrl = "";
				if(setRowStatus == "insert") {
					sendUrl = '/LALM1004_insPgm';

					$("#fir_lows_sbid_lmt_am").val($("#lows_sbid_lmt_am").val());
					$("#chg_rmk_cntn").val("최초 저장 등록");
					$("#chg_del_yn").val("0");
				}
				else if(setRowStatus == "update") {
					sendUrl = '/LALM1004_updPgm';

					$("#fir_lows_sbid_lmt_am").val($("#lows_sbid_lmt_am").val());
					$("#chg_rmk_cntn").val("수정로그");
					$('#chg_rmk_cntn').val($('#chg_rmk_cntn').val()+' 상태변경 사유 :' + parent.inputRn);
					$("#chg_del_yn").val("0");
				}

				const srchData = {frm_MhSogCow: setFrmToData("frm_MhSogCow"), grd_MhFee: feeImpsList};
				const result = sendAjax(srchData, sendUrl, "POST");
				if(result.status == RETURN_SUCCESS){
					MessagePopup("OK", "저장되었습니다.", function() {
						fn_Init();
						fn_Search();
					});
				} else {
					showErrorMessage(result);
					return;
				}
			}
			
		}
	});
}

/*------------------------------------------------------------------------------
	* 1. 함 수 명    : 삭제 함수
	* 2. 입 력 변 수 : N/A
	* 3. 출 력 변 수 : N/A
	------------------------------------------------------------------------------*/
function fn_Delete () {
	MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
		if(res){
			// const params = Object.assign({}, setFrmToData("frm_MhSogCow"), {chg_rmk_cntn : '출장우 삭제', chg_del_yn : '1'});
			$("#chg_rmk_cntn").val("출장우 삭제");
			$("#chg_del_yn").val("1");
			const result = sendAjaxFrm("frm_MhSogCow", "/LALM1004_delPgm", "POST");
			
			if(result.status == RETURN_SUCCESS){
				MessagePopup("OK", "삭제되었습니다.", function() {
					fn_Init();
					fn_Search();
				});
			} else {
				showErrorMessage(result);
				return;
			}
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
//function  : fn_InitSet(초기화 후 기본셋팅) 
//paramater : N/A 
// result   : N/A
//**************************************
function fn_InitSet() {
	// 출하자 연속등록이 체크되어 있을 경우
	// 출하자에 관련된 항목은 reset_exc 클래스를 추가하여 예외처리
	// > fn_InitFrm 함수 참조
	if($("#fhs_cont_yn").is(":checked")) {
		$("tr.fhs_info").find("input, select").addClass("reset_exc");
	} else {
		$("tr.fhs_info").find("input, select").removeClass("reset_exc");
	}

	if(pageInfos.param) {
		// 입력 form 초기 세팅
		// 경매대상
		$("#auc_obj_dsc").val(pageInfos.param.auc_obj_dsc);
		// 접수일자, 경매일자
		$("#auc_dt").datepicker().datepicker("setDate", fn_toDate(pageInfos.param.auc_dt));
		// 검색 form 초기 세팅
		$("#sch_auc_dt").datepicker().datepicker("setDate", fn_toDate(pageInfos.param.auc_dt));
		
		// 경매대상
		fn_setChgRadio("auc_obj_dsc", pageInfos.param.auc_obj_dsc);
		fn_setChgRadio("sch_auc_obj_dsc", pageInfos.param.auc_obj_dsc);
		
		// 출장내역 정보 가져오기
		fn_SetInfo();
	} 

	if(mv_RunMode === '1') {
		// 폼 초기화
		fn_InitFrm('frm_MhSogCow');
		
		fn_setChgRadio('auc_obj_dsc','5');
		fn_setChgRadio('sch_auc_obj_dsc','5');

		// 경매일자 diasbled 해제
		// $("#auc_dt").attr("disabled", false);

		// 경매대상 disabled 해제
		fn_DisableAuc(false);
		
		fn_InitDate();
		
		fn_RcDtModify();

		// 경매일 셋팅을 위한 조회
		fn_SelAucDt();
		
		// 경매대상 관련 초기 셋팅
		fn_AucOnjDscModify();

		if(fn_isNull($("#auc_dt").val())) {
			$("#auc_dt").focus();
		} else if(fn_isNull($("#ftsnm").val())) {
			$("#ftsnm").focus();
		} else {
			$("#indv_sex_c").focus();
		}

		setRowStatus = "insert";
	}
	else {
		// $("#btn_Save").attr("disabled", false);
		// $("#btn_Delete").attr("disabled", false);
		// $("#auc_dt").attr("disabled", true);

		// 경매대상 disabled 처리
		fn_DisableAuc(true);
		
		const aucObjDsc = $("#auc_obj_dsc").val();
		const aucUprDsc = String(fn_getAucUprDsc(aucObjDsc));
		const untAm = String(fn_getAucAtdrUntAm(aucObjDsc));
		
		if(untAm === '10000') {
			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
			$("#sra_sbid_upr").attr("maxlength", "4");
			$("#msg_Sbid3").text("(응찰단위: 만원)");
		} else if(untAm === '1000') {
			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
			$("#sra_sbid_upr").attr("maxlength", "5");
			$("#msg_Sbid3").text("(응찰단위: 천원)");
		} else {
			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
			$("#sra_sbid_upr").attr("maxlength", "8");
			$("#msg_Sbid3").text("(응찰단위: 원)");
		}

		$("#lows_sbid_lmt_am_ex").val(parseInt(fn_delComma($("#lows_sbid_lmt_am").val())) / parseInt(untAm));

		// kg별
		if (aucUprDsc === '1'){
			// 경매차수 조회
			const resultAucQcn = fn_SelAucQcn();
			if(!resultAucQcn.length) {
				MessagePopup('OK',"경매차수가 등록되지 않았습니다.");
				$("#btn_Save").attr("disabled", true);
				$("#btn_Delete").attr("disabled", true);
			} else {
				mv_cut_am = resultAucQcn[0]["CUT_AM"];
				mv_sqno_prc_dsc = resultAucQcn[0]["SGNO_PRC_DSC"];
			}
		}

		setRowStatus = "update";
	}
}

//**************************************
//function  : fn_SetData(조회된 데이터 바인딩) 
//paramater : N/A 
// result   : N/A
//**************************************
function fn_SetData(result) {
	// -------------------- 출장우 정보 -------------------- //
	$("#rd_auc_obj_dsc").val(result[0]["rd_auc_obj_dsc"]);
	if(fn_isDate(result[0]["RC_DT"])) {
		$("#rc_dt").val(fn_toDate(result[0]["RC_DT"]));
	}
	if(fn_isDate(result[0]["AUC_DT"])) {
		$("#auc_dt").val(fn_toDate(result[0]["AUC_DT"]));
	}
	$("#auc_prg_sq").val(result[0]["AUC_PRG_SQ"]);
	$("#td_rc_cst").val(result[0]["TD_RC_CST"]||'0');
	
	// 출하자, 생산자 정보 [S]
	$("#fhs_id_no").val(result[0]["FHS_ID_NO"]);
	$("#farm_amnno").val(result[0]["FARM_AMNNO"]);
	$("#ftsnm").val(fn_xxsDecode(result[0]["FTSNM"]));
	$("#io_sogmn_maco_yn").val(result[0]["IO_SOGMN_MACO_YN"]);
	$("#zip").val(result[0]["ZIP"]);
	$("#dongup").val(fn_xxsDecode(result[0]["DONGUP"]));
	$("#dongbw").val(fn_xxsDecode(result[0]["DONGBW"]));
	$("#ohse_telno").val(result[0]["CUS_MPNO"]||result[0]["OHSE_TELNO"]);
	
	$("#sra_pd_rgnnm").val(fn_xxsDecode(result[0]["SRA_PD_RGNNM"]||result[0]["DONGUP"]));
	$("#sogmn_c").val(result[0]["SOGMN_C"]);
	$("#sra_pdmnm").val(fn_xxsDecode(result[0]["SRA_PDMNM"]||result[0]["FTSNM"]));
	// 출하자, 생산자 정보 [E]
	
	// 개체 정보 [S]
	// 개체번호
	$("#sra_indv_amnno").val(result[0]["SRA_INDV_AMNNO"]);
	$("#re_indv_no").val(result[0]["SRA_INDV_AMNNO"]);
	$("#indv_sex_c").val(result[0]["INDV_SEX_C"]);		// 성별
	$("#cow_sog_wt").val(result[0]["COW_SOG_WT"]||'0');	// 중량
	$("#ppgcow_fee_dsc").val("5");
	if(fn_isNull(result[0]["LOWS_SBID_LMT_AM"])) {		// 예정가
		$("#lows_sbid_lmt_am").val("0");
		$("#lows_sbid_lmt_am_ex").val("0");
	} else {
		$("#lows_sbid_lmt_am").val(fn_toComma(result[0]["LOWS_SBID_LMT_AM"]));
		const untAm = String(fn_getAucAtdrUntAm(result[0]["AUC_OBJ_DSC"]));
		console.log(untAm);
		$("#lows_sbid_lmt_am_ex").val(parseInt(result[0]["LOWS_SBID_LMT_AM"]) / parseInt(untAm));
	}
	// TODO :: 50KG 이상, 20KG 이상, 20KG 미만 두수 추가하기

	$("#rg_dsc").val(result[0]["RG_DSC"]);			// 등록구분
	if(fn_isDate(result[0]["VACN_DT"])) {			// 예방접종일
		$("#vacn_dt").val(fn_toDate(result[0]["VACN_DT"]));	
	}
	if(fn_isDate(result[0]["BRCL_ISP_DT"])) {		// 브루셀라 검사일
		$("#brcl_isp_dt").val(fn_toDate(result[0]["BRCL_ISP_DT"]));
	}
	fn_contrChBox((result[0]["BRCL_ISP_CTFW_SMT_YN"] === '1'), "brcl_isp_ctfw_smt_yn", "");	// 브루셀라 검사증 확인
	fn_contrChBox((result[0]["MT12_OVR_YN"] === '1'), "mt12_ovr_yn", "");					// 12개월 이상
	
	$("#rmk_cntn").val(fn_xxsDecode(result[0]["RMK_CNTN"]));			// 비고
	// 개체 정보 [E]
	
	// 낙찰 정보 [S]
	$("#lwpr_chg_nt").val(result[0]["LWPR_CHG_NT"]);					// 예정가 변경 횟수
	$("#trmn_amnno").val(result[0]["TRMN_AMNNO"]);						// 중도매인번호
	$("#sra_mwmnnm").val(fn_xxsDecode(result[0]["SRA_MWMNNM"]));		// 중도매인명
	$("#lvst_auc_ptc_mn_no").val(result[0]["LVST_AUC_PTC_MN_NO"]);		// 경매참가번호
	$("#sra_sbid_upr").val(result[0]["SRA_SBID_UPR"]||'0');				// 낙찰금액
	$("#sra_sbid_am").val(fn_toComma(result[0]["SRA_SBID_AM"]||'0'));	// 낙찰단가
	$("#sel_sts_dsc").val(result[0]["SEL_STS_DSC"]||'11');				// 진행상태
	$("#lvst_mkt_trpl_amnno").val(result[0]["LVST_MKT_TRPL_AMNNO"]);	// 가축시장 거래처번호
	// 낙찰 정보 [E]

	// 숨김 필드 [S]
	$("#oslp_no").val(result[0]["OSLP_NO"]);
	$("#led_sqno").val(result[0]["LED_SQNO"]);
	$("#sra_srs_dsc").val(result[0]["SRA_SRS_DSC"]);
	$("#fir_lows_sbid_lmt_am").val(result[0]["FIR_LOWS_SBID_LMT_AM"]);
	$("#sog_na_trpl_c").val(result[0]["SOG_NA_TRPL_C"]);
	$("#io_mwmn_maco_yn").val(result[0]["IO_MWMN_MACO_YN"]);
	$("#sra_farm_acno").val(result[0]["SRA_FARM_ACNO"]);
	
	$("#hd_auc_prg_sq").val($("#auc_prg_sq").val());
}

//**************************************
//function  : fn_SetInfo(조회) 
//paramater : N/A 
// result   : N/A
//**************************************
function fn_SetInfo(data) {
	const srchData = data || {
		hdn_auc_obj_dsc: pageInfos.param.auc_obj_dsc,
		hdn_auc_dt: pageInfos.param.auc_dt,
		hdn_oslp_no: pageInfos.param.oslp_no
	}
	const results = sendAjax(srchData, "/LALM1004_selList", "POST");
	let result;
	if(results.status == RETURN_SUCCESS){
		result = setDecrypt(results);
		fn_SetData(result);
	}
	else {
		showErrorMessage(results);
		$("#btn_Delete").attr("disabled", true);
		return;
	}
}

//**************************************
//function  : fn_SelAucQcn(경매차수내역 조회) : TODO > 여기 뭔가 이상..
//paramater : N/A 
// result   : N/A
//**************************************
function fn_SelAucQcn(){
	var results = sendAjaxFrm("frm_MhSogCow", "/Common_selAucQcn", "POST");
	var result = null;

	if(results.status == RETURN_SUCCESS) {
		result = setDecrypt(results);
		$("#ddl_qcn").val(result[0]["QCN"]);
		mv_sgno_prc_dsc = result[0]["SGNO_PRC_DSC"];
		fn_CreateAucQcnGrid(result);
	} else {
		$("#ddl_qcn").val("");
	}
	
	return result;
}

//**************************************
//function  : fn_SelAucDt(경매일자 조회) 
//paramater : N/A
// result   : N/A
//**************************************
function fn_SelAucDt(flag){
	var srchData = new Object();
	srchData["auc_obj_dsc"] = $("#auc_obj_dsc").val();
	srchData["auc_dt"] = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
	srchData["flag"] = flag;
	
	var resultsAuc = sendAjax(srchData, "/Common_selAucDt", "POST");
	var resultAuc;
	
	if(resultsAuc.status == RETURN_SUCCESS){
		resultAuc = setDecrypt(resultsAuc);
	}
	
	$("#auc_dt").datepicker().datepicker("setDate", fn_toDate(resultAuc.AUC_DT));
	$("#sch_auc_dt").datepicker().datepicker("setDate", fn_toDate(resultAuc.AUC_DT));
}

//**************************************
//function  : fn_SelFee(수수료코드 조회) 
//paramater : N/A 
// result   : Count
//**************************************
function fn_SelFee(){
	const results = sendAjaxFrm("frm_MhSogCow", "/LALM1004_selFee", "POST");
	let result;

	if(results.status == RETURN_SUCCESS) {
		result = setDecrypt(results);
		fn_CreateMhFeeGrid(result);
		return result;
	} else {
		return null;
	}
}

//**************************************
//function  : fn_InitDate(달력 초기값 셋팅) 
//paramater : p_param(구분자) ex) "init" 
// result   : N/A
//**************************************
function fn_InitDate() {
	$("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
	$("#rc_dt").datepicker().datepicker("setDate", fn_getToday());
	$("#sch_auc_dt").datepicker().datepicker("setDate", fn_getToday());
}

//**************************************
//function  : fn_AucOnjDscModify(경매대상 수정 시 변경) 
//paramater : N/A
// result   : N/A
//**************************************
function fn_AucOnjDscModify() {
	if (mv_RunMode === '1') {
		$("#btn_Save").attr("disabled", false);
		$("#btn_Delete").attr("disabled", true);
		
		if(!fn_isNull($("#auc_dt").val())) {
			// 경매차수 조회
			const resultAucQcn = fn_SelAucQcn();
			if(!(resultAucQcn||[]).length) {
				MessagePopup('OK',"경매차수가 등록되지 않았습니다.");
				$("#btn_Save").attr("disabled", true);
			} else {
				mv_cut_am = resultAucQcn[0]["CUT_AM"];
				mv_sqno_prc_dsc = resultAucQcn[0]["SGNO_PRC_DSC"];
			}
		} else {
			$("#btn_Save").attr("disabled", true);
		}

		const aucObjDsc = $("#auc_obj_dsc").val();
		const untAm = String(fn_getAucAtdrUntAm(aucObjDsc));
		
		if(untAm === '10000') {
			$("#lows_sbid_lmt_am_ex").attr("maxlength", "4");
			$("#sra_sbid_upr").attr("maxlength", "4");
			$("#msg_Sbid3").text("(응찰단위: 만원)");
		} else if(untAm === '1000') {
			$("#lows_sbid_lmt_am_ex").attr("maxlength", "5");
			$("#sra_sbid_upr").attr("maxlength", "5");
			$("#msg_Sbid3").text("(응찰단위: 천원)");
		} else {
			$("#lows_sbid_lmt_am_ex").attr("maxlength", "8");
			$("#sra_sbid_upr").attr("maxlength", "8");
			$("#msg_Sbid3").text("(응찰단위: 원)");
		}
	}
}

//**************************************
//function  : fn_RcDtModify(접수일자 수정시 변경) - 당일접수비용 적용
//paramater : N/A
// result   : N/A
//**************************************
function fn_RcDtModify() {
	$("#td_rc_cst").val("0");
}

//**************************************
//function  : fn_FrmClear(Frm Clear) 
//paramater : N/A
// result   : N/A
//**************************************
function fn_FrmClear() {
	// 폼 초기화
	fn_InitFrm('frm_MhSogCow');
}

//**************************************
//function  : fn_DisableAuc(경매대상 Disable 및 Enable) 
//paramater : p_boolean(disable) ex) true 
// result   : N/A
//**************************************
function fn_DisableAuc(p_boolean) {
	$("input[name='auc_obj_dsc_radio']").prop("disabled", p_boolean);
	$("#btn_Save").attr("disabled", !p_boolean);
	$("#btn_Delete").attr("disabled", !p_boolean);
	$("#auc_dt").attr("disabled", p_boolean);

	// var rd_length = $("input[name='auc_obj_dsc_radio']").length;
	// var disableItem = $("input[name='auc_obj_dsc_radio']");
	
	// for(var i = 0; i < rd_length; i++){
	// 	itemNames = $(disableItem[i]).attr("id");
	// 	if(p_boolean) {
	// 		$("#"+itemNames).attr("disabled", true);
	// 	} else {
	// 		$("#"+itemNames).attr("disabled", false);
	// 	}
	// }
}

//**************************************
//function  : maxLengthCheck(바이트 문자 입력가능 문자수 체크) 
//paramater : id(tag id), title(tag title), maxLength(최대 입력가능 수 byte)
// result   : Boolean
//**************************************
function maxLengthCheck(id, title, maxLength) {
	var obj = $("#"+id);
	if(maxLength == null) {
		maxLength = obj.attr("maxLength") != null ? obj.attr("maxLength") : 100;
	}
	
	if(Number(fn_byteCheck(obj)) > Number(maxLength)) {
		MessagePopup("OK", title + "이(가) 입력가능문자수를 초과하였습니다. \n (영문, 숫자, 일반 특수문자 : " + maxLength + " / 한글, 한자, 기타 특수문자 : " + parseInt(maxLength/2, 10) + ").",function(res){
			obj.focus();
			return false;
		});
		
	} else {
		return true;
	}
}
////////////////////////////////////////////////////////////////////////////////
//  사용자 함수 종료
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  그리드 함수 시작
////////////////////////////////////////////////////////////////////////////////
// 수수료 정보 grid 생성
function fn_CreateMhFeeGrid(data){
	const searchResultColNames = [
		"경제통합사업장코드(H)", "등록일련번호(H)", "경매대상구분", "적용일자", "적용대상", "수수료구분", "수수료코드", "수수료명",
		"낙찰구분", "공제/지급", "적용기준", "구간하한", "구간상한", "금액/비율", "단수처리", "조합원수수료", "비조합원수수료"
	];
	const searchResultColModel = [
		{name:"NA_BZPLC",       index:"NA_BZPLC",       width:100, align:'center', hidden: true},
		{name:"FEE_RG_SQNO",    index:"FEE_RG_SQNO",    width:100, align:'center', hidden: true},
		{name:"AUC_OBJ_DSC",    index:"AUC_OBJ_DSC",    width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
		{name:"APL_DT",         index:"APL_DT",         width:100, align:'center', formatter:'gridDateFormat'},
		{name:"FEE_APL_OBJ_C",  index:"FEE_APL_OBJ_C",  width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("FEE_APL_OBJ_C", 1)}},
		{name:"PPGCOW_FEE_DSC", index:"PPGCOW_FEE_DSC", width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
		{name:"NA_FEE_C",       index:"NA_FEE_C",       width:100, align:'center'},
		{name:"SRA_FEENM",      index:"SRA_FEENM",      width:100, align:'center'},

		{name:"SBID_YN",        index:"SBID_YN",        width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
		{name:"AMN_HCNT",       index:"AMN_HCNT",       width:60, align:'center'},
		{name:"JNLZ_BSN_DSC",   index:"JNLZ_BSN_DSC",   width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:'1:구간(KG);2:마리'}},
		{name:"ST_SOG_WT",      index:"ST_SOG_WT",      width:100, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
		{name:"ED_SOG_WT",      index:"ED_SOG_WT",      width:100, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
		{name:"AM_RTO_DSC",     index:"AM_RTO_DSC",     width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AM_RTO_DSC", 1)}},
		{name:"SGNO_PRC_DSC",   index:"SGNO_PRC_DSC",   width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SGNO_PRC_DSC", 1)}},
		{name:"MACO_FEE_UPR",   index:"MACO_FEE_UPR",   width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
		{name:"NMACO_FEE_UPR",  index:"NMACO_FEE_UPR",  width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	];

	$("#mhFeeGrid").jqGrid("GridUnload");
			
	$("#mhFeeGrid").jqGrid({
		datatype:    "local",
		data:        data,
		height:      220,
		rowNum:      (data||[]).length,
		resizeing:   true,
		autowidth:   true,
		shrinkToFit: false,
		rownumbers:  true,
		rownumWidth: 1,
		colNames: searchResultColNames,
		colModel: searchResultColModel,
	});
	
	$("#mhFeeGrid").jqGrid("setLabel", "rn","No");
	
}

// 차수 정보 grid 생성
function fn_CreateAucQcnGrid(data){
	/*                                       1              2         3      4           5            6              7        8          9 */
	var searchResultColNames = ["경제통합사업장코드", "경매대상구분코드", "경매일자", "차수", "기초한도금액", "절사단위금액", "단수처리구분코드", "마감여부", "삭제여부"];        
	var searchResultColModel = [						 
									{name:"NA_BZPLC",       	index:"NA_BZPLC",       width:15, align:'center'},        	
									{name:"AUC_OBJ_DSC",		index:"AUC_OBJ_DSC",	width:15, align:'center'},                                     
									{name:"AUC_DT",			index:"AUC_DT",			width:15, align:'center'},
									{name:"QCN",        		index:"QCN",        	width:15, align:'center'},
									{name:"BASE_LMT_AM",       index:"BASE_LMT_AM",    width:15, align:'center'},
									{name:"CUT_AM",        	index:"CUT_AM",        	width:15, align:'center'},
									{name:"SGNO_PRC_DSC",		index:"SGNO_PRC_DSC",	width:20, align:'center'},
									{name:"DDL_YN",       		index:"DDL_YN",      	width:20, align:'center'},
									{name:"DEL_YN",			index:"DEL_YN",    		width:15, align:'center'}
								];
		
	$("#aucQcnGrid").jqGrid("GridUnload");

	$("#aucQcnGrid").jqGrid({
		datatype:    "local",
		data:        data,
		height:      23,
		rowNum:      (data||[]).length,
		resizeing:   true,
		autowidth:   true,
		shrinkToFit: false,
		rownumbers:  true,
		rownumWidth: 1,
		colNames: searchResultColNames,
		colModel: searchResultColModel,
		onSelectRow: function(rowid, status, e){
			return;
		},
	});
	
	$("#aucQcnGrid").jqGrid("setLabel", "rn","No");
	
}

// 경매 내역 grid 생성
function fn_CreateGrid(data){
	const searchResultColNames = [
									"H사업장코드","H경매일자","H원표번호",
									"경매<br/>번호","경매<br/>대상","출하자<br/>코드","출하자","조합원<br/>여부","관내외<br>구분","접수일자","진행상태",
									"낙찰자명","참가<br/>번호","개체번호","성별","구제역백신<br/>접종여부","구제역백신<br/>접종일","중량","예정가","낙찰단가","낙찰가","비고"
								];

	const searchResultColModel = [
									{name:"NA_BZPLC",             index:"NA_BZPLC",             width:90,  sortable:false, align:'center', hidden:true},
									{name:"AUC_DT",               index:"AUC_DT",               width:90,  sortable:false, align:'center', hidden:true},
									{name:"OSLP_NO",              index:"OSLP_NO",              width:90,  sortable:false, align:'center', hidden:true},

									{name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:50,  sortable:false, align:'center', sorttype: "number"},
									{name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
									{name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:60,  sortable:false, align:'center'},
									{name:"FTSNM",                index:"FTSNM",                width:75,  sortable:false, align:'center'},
									{name:"MACO_YN",              index:"MACO_YN",              width:65,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
									{name:"JRDWO_DSC",            index:"JRDWO_DSC",            width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
									{name:"RC_DT",                index:"RC_DT",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"SEL_STS_DSC",          index:"SEL_STS_DSC",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
									{name:"SRA_MWMNNM",           index:"SRA_MWMNNM",           width:80,  sortable:false, align:'center'},
									{name:"LVST_AUC_PTC_MN_NO",   index:"LVST_AUC_PTC_MN_NO",   width:40,  sortable:false, align:'center', sorttype: "number"},
									{name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center'},
									{name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
									{name:"VACN_YN",              index:"FMD_V_YN",             width:70,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
									{name:"VACN_DT",              index:"FMD_V_DT",             width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
									{name:"COW_SOG_WT",           index:"COW_SOG_WT",           width:70,  sortable:false, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"LOWS_SBID_LMT_AM",     index:"LOWS_SBID_LMT_AM",     width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"SRA_SBID_UPR",         index:"SRA_SBID_UPR",         width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"SRA_SBID_AM",          index:"SRA_SBID_AM",          width:70,  sortable:false, align:'right' , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
									{name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable:false, align:'left'},
								];
		
	$("#grd_Etc").jqGrid("GridUnload");

	$("#grd_Etc").jqGrid({
		datatype:    "local",
		data:        data,
		height:      500,
		rowNum:      (data||[]).length,
		resizeing:   true,
		autowidth:   false,
		shrinkToFit: false, 
		rownumbers:true,
		rownumWidth:30,
		footerrow: true,
		userDataOnFooter: true,
		ondblClickRow: function(rowid){
			mv_RunMode = '2';
			const sel_data = $("#grd_Etc").getRowData(rowid);
			pageInfos.param = {
				auc_dt: sel_data.AUC_DT,
				oslp_no: sel_data.OSLP_NO,
				auc_obj_dsc: sel_data.AUC_OBJ_DSC
			}
			fn_InitSet();
		},
		colNames: searchResultColNames,
		colModel: searchResultColModel
	});
}
////////////////////////////////////////////////////////////////////////////////
//  그리드 함수 종료
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  팝업 시작
////////////////////////////////////////////////////////////////////////////////
//**************************************
//function  : fn_CallFtsnmPopup(출하주 팝업 호출) 
//paramater : N/A 
// result   : N/A
//**************************************
function fn_CallFtsnmPopup(p_param, callback) {
	const checkBoolean = p_param;
	const data = new Object();
	data['ftsnm'] = $("#ftsnm").val();
	data['auc_obj_dsc'] = $("input[name='auc_obj_dsc_radio']:checked").val();
	
	fn_CallFtsnm0127Popup(data, checkBoolean, function(result) {
		if(result){
			$("#fhs_id_no").val(result.FHS_ID_NO);
			$("#farm_amnno").val(result.FARM_AMNNO);
			$("#ftsnm").val(fn_xxsDecode(result.FTSNM));
			$("#ohse_telno").val(result.CUS_MPNO??result.OHSE_TELNO);
			
			$("#zip").val(result.ZIP);
			$("#dongup").val(fn_xxsDecode(result.DONGUP));
			$("#dongbw").val(fn_xxsDecode(result.DONGBW));
			$("#sra_pdmnm").val(fn_xxsDecode(result.FTSNM));
			$("#sra_pd_rgnnm").val(fn_xxsDecode(result.DONGUP));
			fn_contrChBox((result.SRA_FED_SPY_YN === "1"), "sra_fed_spy_yn");
			$("#sog_na_trpl_c").val(result.NA_TRPL_C);
			
			$("#io_sogmn_maco_yn").val(result.MACO_YN);
			$("#sra_farm_acno").val(result.SRA_FARM_ACNO);
			if (typeof callback === 'function') callback();
		} else {
			$("#fhs_id_no").val("");
			$("#farm_amnno").val("");
			$("#ftsnm").val("");
			$("#ohse_telno").val("");
			$("#zip").val("");
			$("#dongup").val("");
			$("#dongbw").val("");
			$("#sra_pdmnm").val("");
			$("#sra_pd_rgnnm").val("");
			fn_contrChBox(false, "sra_fed_spy_yn");
			$("#sog_na_trpl_c").val("");
			$("#io_sogmn_maco_yn").val("");
			$("#sra_farm_acno").val("");
		}
	});
}
////////////////////////////////////////////////////////////////////////////////
//  팝업 종료
////////////////////////////////////////////////////////////////////////////////
