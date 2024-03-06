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
        fn_setCodeBox("ppgcow_fee_dsc", "PPGCOW_FEE_DSC", 1, true); // 수수료구분(코드가 1개밖에 없어서 일단 무조건 선택)
        fn_setCodeBox("na_fee_c", "NA_FEE_C", 1, true, "선택"); // 수수료정보
        fn_setCodeBox("sgno_prc_dsc", "SGNO_PRC_DSC", 1, true, "선택"); // 단수처리(절상/절사/사사오입)
        fn_setCodeBox("am_rto_dsc", "AM_RTO_DSC", 1, true, "선택"); // 금액/비율

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
    }

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
        $("#btn_Insert").prop("disabled", false);
        $("#btn_Save, #btn_Delete").prop("disabled", true);

		$("#frm_fee").find("input, select").prop("disabled", false);
		fn_InitFrm('frm_fee');
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
     * 1. 함 수 명    : 추가(신규) 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
	function fn_Insert() {
        // 필수값 입력여부 체크
        if (!fn_RequiredValueValidation()) return;
        // 입력값 체크
        if (!fn_ValueValidation()) return;

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
        // 필수값 입력여부 체크
        if (!fn_RequiredValueValidation()) return;
        // 입력값 체크
        if (!fn_ValueValidation()) return;
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

        const searchResultColNames = ["경제통합사업장코드(H)", "등록일련번호(H)", "경매대상구분", "적용일자", "적용대상", "수수료구분", "수수료코드",
                                      "수수료명", "단수처리", "공제/지급", "적용기준", "구간하한", "구간상한", "금액/비율", "조합원수수료", "비조합원수수료"
                                     , "낙찰구분"];
        const searchResultColModel = [
                                     {name:"NA_BZPLC",       index:"NA_BZPLC",       width:100, align:'center', hidden: true},
                                     {name:"FEE_RG_SQNO",    index:"FEE_RG_SQNO",    width:100, align:'center', hidden: true},
                                     {name:"AUC_OBJ_DSC",    index:"AUC_OBJ_DSC",    width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"APL_DT",         index:"APL_DT",         width:100, align:'center', formatter:'gridDateFormat'},
                                     {name:"FEE_APL_OBJ_C",  index:"FEE_APL_OBJ_C",  width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("FEE_APL_OBJ_C", 1)}},
                                     {name:"PPGCOW_FEE_DSC", index:"PPGCOW_FEE_DSC", width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
                                     {name:"NA_FEE_C",       index:"NA_FEE_C",       width:100, align:'center'},

                                     {name:"SRA_FEENM",      index:"SRA_FEENM",      width:100, align:'center'},
                                     {name:"SGNO_PRC_DSC",   index:"SGNO_PRC_DSC",   width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SGNO_PRC_DSC", 1)}},
                                     {name:"AMN_HCNT",       index:"AMN_HCNT",       width:60, align:'center'},
                                     {name:"JNLZ_BSN_DSC",   index:"JNLZ_BSN_DSC",   width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:'1:구간(KG);2:마리'}},
                                     {name:"ST_SOG_WT",      index:"ST_SOG_WT",      width:100, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"ED_SOG_WT",      index:"ED_SOG_WT",      width:100, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"AM_RTO_DSC",     index:"AM_RTO_DSC",     width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AM_RTO_DSC", 1)}},
                                     {name:"MACO_FEE_UPR",   index:"MACO_FEE_UPR",   width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"NMACO_FEE_UPR",  index:"NMACO_FEE_UPR",  width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},

                                     {name:"SBID_YN",        index:"SBID_YN",        width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
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

    function fn_SetGridData(data) {
        const srhData = new Object();
		srhData["na_bzplc"] = data.NA_BZPLC;
		srhData["auc_obj_dsc"] = data.AUC_OBJ_DSC;
		srhData["apl_dt"] = data.APL_DT;
		srhData["fee_rg_sqno"] = data.FEE_RG_SQNO;
		
		const results = sendAjax(srhData, "/LALM1002_selDetail", "POST");
        console.log(setDecrypt(results));
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
                                <th scope="row">단수처리</th><!-- 절사, 절상, 사사오입 -->
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
                                        <select id="ppgcow_fee_dsc" class="required" name="ppgcow_fee_dsc" alt="수수료 구분"></select>
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
                                        <select id="sgno_prc_dsc" class="required" name="SGNO_PRC_DSC" alt="단수처리"></select>
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
                                <th scope="row" colspan="2">적용구간(이상 ~ 미만)</th>
                                <th scope="row">금액/비율</th>
                                <th scope="row">조합원수수료</th>
                                <th scope="row">비조합원수수료</th>
								<th scope="row">낙찰구분</th><!-- 여, 부 -->
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
								</td>
								<td>
                                    <div>
                                        <select id="sbid_yn" class="required" name="sbid_yn" alt="낙찰구분">
											<option value="1" selected>여</option>
											<option value="0">부</option>
										</select>
                                    </div>
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