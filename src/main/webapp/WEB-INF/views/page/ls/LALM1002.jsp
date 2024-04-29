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
    .integer {
        text-align: right;
    }
</style>

<script type="text/javascript">
    let setRowStatus              = 'insert';

    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    $(document).ready(function(){
		$("#frm_fee").find("input, select").prop("disabled", true);

    	fn_CreateGrid();
		// 조회조건
        fn_setCodeBox("sc_auc_obj_dsc", "AUC_OBJ_DSC", 8, true); // 경매대상구분

		// 수수료정보입력
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 8, true, "선택"); // 경매대상구분
        fn_setCodeBox("fee_apl_obj_c", "FEE_APL_OBJ_C", 1, true, "선택"); // 적용대상
        //fn_setCodeBox("ppgcow_fee_dsc", "PPGCOW_FEE_DSC", 1, true); // 수수료구분(코드가 1개밖에 없어서 일단 무조건 선택)
        fn_setCodeBox("na_fee_c", "NA_FEE_C", 1, true, "선택"); // 수수료종류
        fn_setCodeBox("sgno_prc_dsc", "SGNO_PRC_DSC", 1, true, "선택"); // 단수처리(절상/절사/사사오입)
        fn_setCodeBox("am_rto_dsc", "AM_RTO_DSC", 1, true, "선택"); // 금액/비율

        // 수수료적용기준이 마리별(2)일 경우, 적용구간 input disabled처리.
        // TODO(완료) 이 경우, 적용구간 필수값 validation 해제 필요. 
        // fn_Disabled("#jnlz_bsn_dsc", "#st_sog_wt", "#ed_sog_wt", "1");

        // 금액/비율이 금액(1)일 경우, 단수처리 select box disabled처리.
        // TODO(완료) 이 경우, 단수처리 필수값 validation 해제 필요.
        // TODO(구현필요) 세번째 인자로 넘겨줄 것이 없어서 undefined처리. -> 확인필요
        // fn_Disabled("#am_rto_dsc", "#sgno_prc_dsc", undefined, "2");
        fn_DscValidation();
        
        // TODO(완료) 금액/비율이 비율(2)일 경우, 조합원 수수료 / 비조합원 수수료 최대 100까지만 입력되도록.
        fn_limitFee();

        $(".date").datepicker({
			yearRange : 'c-10:c+10'
		});

		// 입력초기화
		$("#btn_FrmInit").on('click', function(e){
			e.preventDefault();
			this.blur();
			fn_FrmInit();
		});

        $(document).on('change', "#na_fee_c", function() {
            const codeNm = fn_setCodeNm("NA_FEE_C", 1, $(this).val());
            $("#sra_feenm").val(codeNm);
        });

		// grid resize
        $(window).on('resize.jqGrid',function(){
        	$('#grd_MhFee').setGridWidth($('.content').width() - 17, true);
        });

		fn_Init();
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
        $("#btn_Insert, #btn_Save, #btn_Delete").prop("disabled", true);
        $("#frm_fee").find("input, select").prop("disabled", true);
        //그리드 초기화
        $("#grd_MhFee").jqGrid("clearGridData", true);
        //폼 초기화
        fn_InitFrm('frm_Search');
        fn_InitFrm('frm_fee');
        $("#sc_auc_obj_dsc").val($("#sc_auc_obj_dsc option:first").val());
        $("#sc_apl_dt").datepicker().datepicker("setDate", fn_getToday());
        $("#sc_auc_obj_dsc").focus();

        setRowStatus = "insert";
    }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 수수료 금액 비율 선택 시, 비율 제한.
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     * 4. 설 명 : 수수료 금액 비율 선택 시, 비율 최대 100%까지 허용.
     ------------------------------------------------------------------------------*/
    function fn_limitFee() {
        // TODO(구현필요) 백스페이스 누르고 수정 안 되는 부분 수정 필요. 
        $(document).on('change', '#am_rto_dsc', function() {
            // 기존 조합원/비조합원 수수료 값 초기화 
            $("#maco_fee_upr").val("");
            $("#nmaco_fee_upr").val("");

            // 단수처리 선택으로.
            fn_setCodeBox("sgno_prc_dsc", "SGNO_PRC_DSC", 1, true, "선택");

            // 이전의 이벤트 제거 하지 않으면, 값 수정이 안됨. 또는 이벤트가 엉킴?
            $("#maco_fee_upr").off("input");
            $("#nmaco_fee_upr").off("input");

            
        });

        // 비율(2) 선택 시,  
        // if($(this).val() === '2') {
                // 조합원 수수료 값 100 이하인지 체크
                $("#maco_fee_upr").on("input", function() {
                    if($("#am_rto_dsc").val() === "2") {
                        let macoValue = parseInt($(this).val());
                        if (isNaN(macoValue)) {
                            $(this).val("");
                        } else if(macoValue > 100) {
                            $(this).val("100");
                        }
                    }
                });
                // 비조합원 수수료 값 100 이하인지 체크
                $("#nmaco_fee_upr").on("input", function() {
                    if($("#am_rto_dsc").val() === "2") {
                        let nmacoValue = parseInt($(this).val());
                        if (isNaN(nmacoValue)) {
                            $(this).val("");
                        } else if(nmacoValue > 100) {
                            $(this).val("100");
                        }
                    }
                }); 
        

    }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 입력 칸 disabled처리 함수
     * 2. 입 력 변 수 : p_simp_tpc, p_simp_tpc_second, p_simp_tpc_third, p_simp_tpc_value (입력 칸 id, disable처리하고자하는 id, value값)
     * 3. 출 력 변 수 : N/A
     * 4. 설 명 : 입력 칸의 value가 바뀔 때마다 특정 입력 칸 disabled처리 시 사용
     ------------------------------------------------------------------------------*/
    function fn_Disabled(p_simp_tpc, p_simp_tpc_second, p_simp_tpc_third, p_simp_tpc_val) {
        $(document).on('change', p_simp_tpc, function() {
            // console.log($(this).val())
            // disabled처리대상 요소 적용.
            // p_simp_tpc 요소의 p_simp_tpc_val 값이 아닐 경우 disabled.
            $(p_simp_tpc_second).prop("disabled", $(this).val() !== p_simp_tpc_val);
            var secondEle = document.getElementById(p_simp_tpc_second.replace(/#/g, ''));
            if( $(this).val() !== p_simp_tpc_val) secondEle.classList.remove("required");

            // 세번째 인자가 있는 경우..
            var disableThird = p_simp_tpc_third !== undefined; 

            if(disableThird) {
                $(p_simp_tpc_third).prop("disabled", $(this).val() !== p_simp_tpc_val);
                var thirdEle = document.getElementById(p_simp_tpc_third.replace(/#/g, ''));
                // 해당 요소 필수 값 클래스 제거.
                if( $(this).val() !== p_simp_tpc_val) thirdEle.classList.remove("required");
            }
        });
    };

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 수수료 적용기준 및 금액/비율 value validation 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     * 4. 설 명 : 
     ------------------------------------------------------------------------------*/
     function fn_DscValidation() {
        // fn_Disabled("#jnlz_bsn_dsc", "#st_sog_wt", "#ed_sog_wt", "1");
        // fn_Disabled("#am_rto_dsc", "#sgno_prc_dsc", undefined, "2");
        // 수수료 적용 기준.
        // 수수료 적용기준이 마리별 일 때 적용구간 disabled 처리, "required" 클래스 제거
        // 수수료 적용기준이 구간별 일 때 required 클래스 추가
        var firstEle = document.getElementById('st_sog_wt');
        var secondEle = document.getElementById('ed_sog_wt');
        $(document).on('change', '#jnlz_bsn_dsc', function() {
            if($("#jnlz_bsn_dsc").val() === "2") {
            $("#st_sog_wt").prop("disabled", true);
            $("#ed_sog_wt").prop("disabled", true);
            firstEle.classList.remove("required");
            secondEle.classList.remove("required");
        } else if ($("#jnlz_bsn_dsc").val() === "1") {
            $("#st_sog_wt").prop("disabled", false);
            $("#ed_sog_wt").prop("disabled", false);
            firstEle.classList.add("required");
            secondEle.classList.add("required");
        } else;
        })

        // 금액/비율 
        // 금액/비율이 금액 일 때 단수처리 disabled 처리, "required" 클래스 제거
        // 금액/비율이 비율 일 때 required 클래스 추가
        var ele = document.getElementById('sgno_prc_dsc');
        $(document).on('change', '#am_rto_dsc', function() {
            if($("#am_rto_dsc").val() === "1") {
                $("#sgno_prc_dsc").prop("disabled", true);
                ele.classList.remove("required");
                $("#th_maco_fee_upr").html("조합원수수료(원)");
                $("#th_nmaco_fee_upr").html("비조합원수수료(원)");
            } else if ($("#am_rto_dsc").val() === "2"){
                $("#sgno_prc_dsc").prop("disabled", false);
                ele.classList.add("required");
                $("#th_maco_fee_upr").html("조합원수수료(%)");
                $("#th_nmaco_fee_upr").html("비조합원수수료(%)");
            } else {
                $("#th_maco_fee_upr").html("조합원수수료");
                $("#th_nmaco_fee_upr").html("비조합원수수료");
            }
        })
     };

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
        //정합성체크
        if(fn_isNull($("#sc_auc_obj_dsc").val()) == true) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$("#sc_auc_obj_dsc").focus();
        	});
            return;
        }
        if(fn_isNull($("#sc_apl_dt").val()) == true){
        	MessagePopup('OK','적용일자를 선택하세요.',function(){
        		$("#sc_apl_dt").focus();
            });
            return;
        }
        
        if(fn_isDate($("#sc_apl_dt").val()) == false){
        	MessagePopup('OK','적용일자가 날짜형식에 맞지 않습니다.',function(){
                $("#sc_apl_dt").focus();
            });
            return;
        }
        $("#grd_MhFee").jqGrid("clearGridData", true);
        var results = sendAjaxFrm("frm_Search", "/LALM1002_selList", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        fn_CreateGrid(result);
    }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 입력초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
	function fn_FrmInit() {
        // 입력초기화시 추가 버튼만 활성화
        // $("#btn_Insert").prop("disabled", false);
        // $("#btn_Save, #btn_Delete").prop("disabled", true);
        $("#btn_Save").prop("disabled", false);
        $("#btn_Delete").prop("disabled", true);

		$("#frm_fee").find("input, select").prop("disabled", false);
		fn_InitFrm('frm_fee');

        setRowStatus = 'insert';
	}

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 추가(신규) 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     * 4. 설 명 : 필수 값 입력외에 체크가 필요한 경우 사용
     ------------------------------------------------------------------------------*/
     function fn_ValueValidation() {
        if (Number($("#st_sog_wt").val().replace(/[^0-9]/g,'')) > Number($("#ed_sog_wt").val().replace(/[^0-9]/g,''))) {
            MessagePopup('OK', "적용구간 상/하한 값을 확인해주세요.", () => {
                $("#ed_sog_wt").focus();
            });
            return false;
        }
        return true;
    }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 추가(신규) / 수정 적용기준 관련 validation check 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     * 4. 설 명 : 적용기준 관련 체크가 필요한 경우 사용.
     ------------------------------------------------------------------------------*/
     function fn_ResultValidation(sqno) {
        // TODO(완료) 적용기준이 구간별일 경우, 적용구간이 겹치면 안됨.
        // TODO(완료) 같은 적용일자 기준 추가하려는 데이터의 수수료 적용기준이 조회api로 조회한 데이터와 상이할 경우, "수수료 적용기준을 확인해주세요." 등의 alert.
        // TODO(완료) + 마리별 적용기준은 한 적용일자의 한 건만 존재해야함.

        var params = {
            ...setFrmToData("frm_Search"),
            sc_apl_dt: $("#apl_dt").val().replace(/-/g, '')
        }

        // TODO(완료) 기존 데이터 없을 때는 추가 가능.
        var results = sendAjax(params, "/LALM1002_selList", "POST"); 
        var result;

        if(results.dataCnt > 0 && results.status === RETURN_SUCCESS ) {
            result = setDecrypt(results);

            if(sqno) {
                result = result.filter((el) => parseInt(el.FEE_RG_SQNO) !== parseInt(sqno) );
            } else {
                result = result.filter((el) => el.APL_DT === $("#apl_dt").val().replace(/-/g, ''));
            }

            let ins_fee_apl_obj_c = $("#fee_apl_obj_c").val();

            // 추가 하려는 적용 대상이 아예 존재하지 않을 경우 무조건 추가
            if (!result.every((el) => el.FEE_APL_OBJ_C !== ins_fee_apl_obj_c )) {
                // 2. 추가하려는 적용기준이 무엇이던간에 이미 데이터에 마리별이 있으면 무조건 추가 안됨. 
                // => 적용대상은 달라도 됨.
                if((result.some((el) => el.JNLZ_BSN_DSC !== "2" && el.FEE_APL_OBJ_C )) === false  && result.length > 0) {
                    MessagePopup('OK', "같은 적용일자 기준 마리별 수수료 데이터가 존재합니다.", () => {
                        $("#jnlz_bsn_dsc").focus();
                    }) 
                    return false;
                // 3. 적용기준이 같으면 true, 아니면 fale (추가하려는 적용기준이 마리별인데 이미있는 데이터에 구간별이 있으면 안됨)
                } else if ((result.some((el) => el.JNLZ_BSN_DSC === $("#jnlz_bsn_dsc").val())) === false && result.length > 0) {
                    MessagePopup('OK', "같은 적용일자 기준 동일한 적용기준으로 입력해주세요.", () => {
                        $("#jnlz_bsn_dsc").focus();
                    }) 
                    return false;
                // 4. 적용기준이 "1"일 경우, 적용구간이 result내의 적용구간과 겹치면 안됨. st_sog_wt(하한) / ed_sog_wt(상한)
                // TODO(완료) 적용구간이 같더라도 수수료 종류가 다르면 OK    
                } else if ($("#jnlz_bsn_dsc").val() === "1" && result.length > 0) {
                    var stVal = $("#st_sog_wt").val();
                    var edVal = $("#ed_sog_wt").val();
                    
                    var isOverlap = result.some((el) => {
                        if(el.JNLZ_BSN_DSC === "1") {
                            var resultStVal = parseInt(el.ST_SOG_WT);
                            var resultEdVal = parseInt(el.ED_SOG_WT);
                            var isOverLapNaFeeC = $("#na_fee_c").val() === el.NA_FEE_C; // 수수료 종류 겹침 여부

                            // 구간이 겹치면 true. 겹치는 구간이 없으면 false
                            // 사실상 기존 상한 값과 추가하려는 하한값만 비교하면 됨.(resultEdVal <= stVal )
                            // 구간 겹치고 && 수수료종류 다르면 겹치지 않는 것으로 판단.
                            if(  (stVal < resultEdVal &&  !isOverLapNaFeeC) || (edVal === resultStVal &&  !isOverLapNaFeeC) ) {
                                return false;
                            // 구간 겹치고 && 수수료종류도 같으면 겹치는 것으로 판단.
                            } else if(
                                (stVal < resultEdVal && edVal > resultStVal && isOverLapNaFeeC) ||
                                (edVal === resultStVal && isOverLapNaFeeC) ||
                                (stVal === resultEdVal && isOverLapNaFeeC)
                            ) {
                                return true;
                            }
                        }
                        return false;
                    })

                    // 겹치는지 check
                    if(isOverlap === true) {
                        MessagePopup('OK', "적용구간이 겹치는 데이터가 이미 존재합니다.", () => {
                        $("#st_sog_wt").focus();
                        $("#ed_sog_wt").focus();
                    });
                        return false;
                    }
                } 
            } else { 
                return true;
            }
            return true;
        } else if(results.status != RETURN_SUCCESS && results.dataCnt !== 0) {
            showErrorMessage(results);
            return;
        } return true;
    
    }



    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 추가(신규) 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
	function fn_Insert() {

        // 필수값 입력여부 체크
        if (!fn_RequiredValueValidation()) return;
        // 입력값 체크
        if (!fn_ValueValidation()) return;
        // 기존데이터와 수수료적용기준 관련 체크
        if (!fn_ResultValidation()) return;

        MessagePopup('YESNO', '저장하시겠습니까?', (res) => {
            if(res){
                const results = sendAjaxFrm("frm_fee", "/LALM1002_insFee", "POST");
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }
                else{
                    MessagePopup("OK", "정상적으로 처리되었습니다.", () => {
                        fn_Init();
                        // TODO (구현필요) 추가 완료 후, 추가했던 적용일자로 조회
                        fn_Search();
                    });
                }
            }
        });
	}

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장(수정) 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
	function fn_Save() {
        if (setRowStatus === 'insert') return fn_Insert();

        // hidden으로 숨겨놓은 일련번호 데이터 가져오기
        var fee_rg_sqno = $("#fee_rg_sqno").val();
        var apl_dt = new Date($("#apl_dt").val());
        var today = new Date();

        // 날짜만 비교하기 위해 시간을 0 처리 후 비교.
        apl_dt.setHours(0, 0, 0, 0);
        today.setHours(0, 0, 0, 0);

        // 필수값 입력여부 체크
        if (!fn_RequiredValueValidation()) return;
        // 입력값 체크
        if (!fn_ValueValidation()) return;
        // 기존 데이터와 유효성 체크
        if (!fn_ResultValidation(fee_rg_sqno)) return;
        // TODO(완료) 오늘날짜 이후 데이터만 수정가능.
        // TODO(구현필요) 오늘날짜는 가능하도록 수정필요.
        if(apl_dt >= today) {
            MessagePopup('YESNO', '저장하시겠습니까?', (res) => {
                if(res){
                    // 파라미터 객체에 NA_BZPLC, FEE_RG_SQNO가 NULL 값으로 들어감. 
                    var params = {
                        ...setFrmToData("frm_fee"),
                        // na_bzplc: srhData.na_bzplc,
                        fee_rg_sqno: fee_rg_sqno
                    }
                    // console.log('수정파라미터:', params)
                    var results = sendAjax(params, "/LALM1002_updFee", "POST");
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    } else {
                        MessagePopup("OK", "정상적으로 처리되었습니다.", () => {
                        fn_Init();
                        // TODO (구현필요) 수정 완료 후, 수정했던 적용일자로 조회
                        fn_Search();
                        });
                    }
                }
            });
        } else {
            MessagePopup('OK', "오늘 이후 적용일자만 수정 가능합니다.");
        }
	}

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     function fn_Delete() {
         // hidden 값으로 숨겨둔 일련번호 데이터 가져오기.! (현재선택된.)
         var fee_rg_sqno = $("#fee_rg_sqno").val();
         var apl_dt = new Date($("#apl_dt").val());
         var today = new Date();
         // 날짜만 비교하기 위해 시간을 0 처리 후 비교.
         apl_dt.setHours(0, 0, 0, 0);
         today.setHours(0, 0, 0, 0);
         
         // TODO(완료) 적용일자가 오늘날짜 이후일 경우에만 삭제가능.
         // TODO(완료) 오늘날짜는 가능하도록 수정필요.
         if(apl_dt >= today) {
            MessagePopup('YESNO', "삭제하시겠습니까?", function(res) {
                if(res) {
                    var params = {
                        ...setFrmToData("frm_fee"),
                        fee_rg_sqno: fee_rg_sqno
                    }
                    var results = sendAjax(params, "/LALM1002_delFee", "POST");
                    if(results.status !== RETURN_SUCCESS) {
                        showErrorMessage(results);
                        return;
                    } else {
                        MessagePopup("OK", "정상적으로 처리되었습니다.", () => {
                            fn_Init();
                            fn_Search();
                        })
                    }
                }
            })
         } else {
            MessagePopup('OK', "오늘 이후 적용일자만 삭제 가능합니다.");
         }
        // console.log($("#apl_dt").val())



     }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
         fn_ExcelDownlad('grd_MhFee', '수수료조회');
    } 
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    //그리드 생성
    function fn_CreateGrid(data){
        let rowNoValue = 0;
        if(data != null){
            rowNoValue = data.length;
        }

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

        $("#grd_MhFee").jqGrid("GridUnload");

        $("#grd_MhFee").jqGrid({
            datatype:    "local",
            data:        data,
            height:      520,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                fn_SetGridData($("#grd_MhFee").getRowData(rowid));
            }
        });
        //행번호
        $("#grd_MhFee").jqGrid("setLabel", "rn","No");
    }

    // 그리드 row 클릭 시
    function fn_SetGridData (data) {
        const srhData = new Object();
		srhData["na_bzplc"] = data.NA_BZPLC;
		srhData["auc_obj_dsc"] = data.AUC_OBJ_DSC;
		srhData["apl_dt"] = data.APL_DT;
		srhData["fee_rg_sqno"] = data.FEE_RG_SQNO; // 선택된 데이터의 등록일련번호 validation 함수에 인자로 넘겨줘야함.

        // TODO(완료) 상세정보 result데이터 input에 바인딩 시키기 
		const results = sendAjax(srhData, "/LALM1002_selDetail", "POST");
        const result = setDecrypt(results);

        fn_setFrmByObject("frm_fee", result);

        $("#btn_Save, #btn_Delete").prop("disabled", false);
        $("#frm_fee").find("input, select").prop("disabled", false);

        // TODO(완료) 아래 분기문 해당 데이터 change될 때 마다 적용되도록 수정 필요.
        // 수수료 적용기준이 마리별 일 때 적용구간 disabled 처리, "required" 클래스 제거
        // 수수료 적용기준이 구간별 일 때 required 클래스 추가
        var st = document.getElementById('st_sog_wt');
        var ed = document.getElementById('ed_sog_wt');
        if(data.JNLZ_BSN_DSC === "2") {
            $("#st_sog_wt").prop("disabled", true);
            $("#ed_sog_wt").prop("disabled", true);
            st.classList.remove("required");
            ed.classList.remove("required");
        } else if (data.JNLZ_BSN_DSC === "1") {
            $("#st_sog_wt").prop("disabled", false);
            $("#ed_sog_wt").prop("disabled", false);
            st.classList.add("required");
            ed.classList.add("required");
        } else;
        
        
        // // 금액/비율이 금액 일 때 단수처리 disabled 처리, "required" 클래스 제거
        // // 금액/비율이 비율 일 때 required 클래스 추가
        var sgno = document.getElementById('sgno_prc_dsc');
        if(data.AM_RTO_DSC === "1") {
            $("#sgno_prc_dsc").prop("disabled", true);
            sgno.classList.remove("required");
        } else if (data.AM_RTO_DSC === "2"){
            $("#sgno_prc_dsc").prop("disabled", false);
            sgno.classList.add("required");
        } else;
        
        setRowStatus = 'update';
    }
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            <!-- 조회조건 [s] -->
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">조회조건</p></li>
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
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상구분<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="sc_auc_obj_dsc" class="popup"></select>
                                </td>
                                <th scope="row">적용일자<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell">
											<input type="text" class="popup date" id="sc_apl_dt" />
										</div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            <!-- 조회조건 [e] -->
            <!-- 수수료정보 [s] -->
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">수수료정보</p></li>
                </ul>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 --> 
                    <button class="tb_btn" id="btn_FrmInit" type="button">입력초기화</button>
                </div>
            </div>
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_fee">
                    <table>
                        <colgroup>
                            <col width="14%">
                            <col width="14%">
                            <col width="14%">
                            <col width="14%">
                            <col width="14%">
                            <col width="14%">
                            <col width="14%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <th scope="row">적용일자</th>
                                <th scope="row">적용대상</th>
                                <!-- 가축시장에서는 해당없음, 임신우, 비임신우 등으로 나누는데 쓰이는데 나중에 비슷하게 나누는에 쓰일 경우를 대비해 남겨둠(현재는 해당사항 없음으로 고정) -->
                                <th scope="row">수수료구분</th>
                                <th scope="row">수수료종류</th>
                                <th scope="row">낙찰구분</th><!-- 여, 부 -->
                                <th scope="row">공제/지급</th><!-- 공제, 지급 -->
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <select id="auc_obj_dsc" class="required" name="auc_obj_dsc" alt="경매대상"></select>
                                    </div>
                                </td>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell">
											<input type="text" class="date required" id="apl_dt" name="apl_dt" maxlength="10" alt="적용일자" />
										</div>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="fee_apl_obj_c" class="required" name="fee_apl_obj_c" alt="적용대상"></select>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="ppgcow_fee_dsc" class="required" name="ppgcow_fee_dsc" alt="수수료 구분">
                                            <option value="5">해당없음</option>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="na_fee_c" class="required" name="NA_FEE_C" alt="수수료 종류"></select>
                                        <input type="hidden" id="sra_feenm" value="" />
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="sbid_yn" class="required" name="sbid_yn" alt="낙찰구분">
											<option value="1" selected>여</option>
											<option value="0">부</option>
										</select>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="ans_dsc" class="required" name="ANS_DSC" alt="공제/지급">
											<option value="">선택</option>
											<option value="1">공제(입금)</option>
											<option value="2">지급(출금)</option>
										</select>
                                    </div>
                                </td>
                            </tr>
							<tr>
                                <th scope="row">수수료적용기준</th><!-- 마리 별/KG구간 별 -->
                                <th scope="row" colspan="2">적용구간(KG)(이상 ~ 미만)</th>
                                <th scope="row">금액/비율</th>
                                <th scope="row">단수처리</th><!-- 절사, 절상, 사사오입 -->
                                <th id="th_maco_fee_upr" scope="row">조합원수수료</th>
                                <th id="th_nmaco_fee_upr" scope="row">비조합원수수료</th>
                            </tr>
							<tr>
								<td>
                                    <div>
                                        <select id="jnlz_bsn_dsc" class="required" name="JNLZ_BSN_DSC" alt="수수료 적용 기준">
											<option value="1" selected>구간(KG) 별</option>
											<option value="2">마리 별</option>
										</select>
                                    </div>
                                </td>
								<td colspan="2">
									<div class="cellBox">
	                                    <div class="cell">
                                            <input type="text" id="st_sog_wt" class="integer required" alt="수수료 적용 하한" maxlength="5" />
										</div>
	                                    <div class="cell ta_c"> ~ </div>
	                                    <div class="cell">
                                            <input type="text" id="ed_sog_wt" class="integer required" alt="수수료 적용 상한" maxlength="5" />
										</div>
                                    </div>
								</td>
								<td>
                                    <div>
                                        <select id="am_rto_dsc" class="required" name="AM_RTO_DSC" alt="금액/비율"></select>
                                    </div>
                                </td>
								<td>
                                    <div>
                                        <select id="sgno_prc_dsc" class="required" name="SGNO_PRC_DSC" alt="단수처리"></select>
                                    </div>
                                </td>
								<td>
									<div class="cellBox">
	                                    <div class="cell">
                                            <input type="text" id="maco_fee_upr" class="integer required" alt="조합원수수료" maxlength="15" />
										</div>
									</div>
								</td>
								<td>
									<div class="cellBox">
	                                    <div class="cell">
                                            <input type="text" id="nmaco_fee_upr" class="integer required" alt="비조합원수수료" maxlength="15" />
										</div>
									</div>
                                    <input type="hidden" id="fee_rg_sqno">
								</td>
							</tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <!-- 수수료정보 [e] -->
            <!-- 검색결과 [s] -->
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">수수료정보</p></li>
                </ul>
            </div>
            <div class="listTable mb0">
                <table id="grd_MhFee">
                </table>
            </div>
            <!-- 검색결과 [e] -->
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>