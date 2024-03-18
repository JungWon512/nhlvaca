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
<style>
    .ui-jqgrid tr.jqgrow{height: 30px;white-space: nowrap;}
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
        /******************************
         * 초기값 설정
         ******************************/ 
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 8, true); 

        /******************************
         * 경매대상 변경
         ******************************/
        $("#auc_obj_dsc").bind('change', function(e){
            e.preventDefault();
            fn_ChangeAucObjDsc();
        });

        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow");

        /******************************
         * 농가검색 팝업
         ******************************/
        $("#ftsnm").keydown(function(e){
            if(e.keyCode == 13){
            	if(fn_isNull($("#ftsnm").val())){
            		MessagePopup('OK','출하주 명을 입력하세요.');
                    return;
                } else {
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
             } else {
            	 $("#fhs_id_no").val('');
             }
        });

        $("#pb_searchFhs").on('click', function(e){
            e.preventDefault();
            this.blur();
            fn_CallFtsnmPopup(null, false, function(result){
                if(result){
                    $("#fhs_id_no").val(result.FHS_ID_NO);
                    $("#ftsnm").val(result.FTSNM);
                    fn_Search();
                }
            });
        });

         /******************************
          * 전체삭제 버튼클릭
          ******************************/ 
         $("#pb_AllDel").on('click', function(e){
             e.preventDefault();
             this.blur();
             if($("#auc_obj_dsc").val() == '0'){
                 MessagePopup('OK',"경매대상을 선택후 삭제하세요.");
                 return false;
             }
             MessagePopup('YESNO',"삭제하시겠습니까?", function(res){
                 if(res){
                	 $("#chg_del_yn").val("1");
                     $("#chg_pgid").val("LALM1003");
                     $("#chg_rmk_cntn").val("전체 삭제 로그");
                     const results = sendAjaxFrm("frm_Search", "/LALM1003_delSogCow", "POST");
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     } else {
                    	 MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                             fn_Search();
                         });
                     }
                  }
             });
         });

         /******************************
          * 엑셀업로드 버튼 클릭
          ******************************/ 
         $("#pb_ExcelUpload").on('click', function(e){
             e.preventDefault();
             this.blur();
             const pgid = 'LALM1003P1';
             const menu_id = $("#menu_info").attr("menu_id");
             const param = {
                auc_obj_dsc : $('#auc_obj_dsc').val()
                , auc_dt : $('#auc_dt').val()
             }
             parent.layerPopupPage(pgid, menu_id, param, null, 1800, 750, function(result){
            	 if(result)fn_Search();
                 
             });
         });

         /******************************
          * 엑셀 템플릿(다운로드) 버튼 클릭
          ******************************/ 
         // TODO :: 경매대상구분에 따라 다른 템플릿을 다운로드 받도록 수정해야함
         $('#pb_ExcelTempDownload').on('click', function(e) {
            const pom = document.createElement('a');
            pom.setAttribute('href', '/files/20230116_SOGCOW_EXCEL.xlsx');
            pom.setAttribute('type', 'application/vnd.ms-excel');
            pom.setAttribute('download', "출장우_엑셀업로드.xls");
            pom.click();
         });

         /******************************
          * 수수료재설정
          ******************************/ 
        $("#pb_FeeReset").on('click',function(e){
            e.preventDefault();
            this.blur();

            let exFeeSum = 0;
            let nowFeeSum = 0;
            //계산전수수료합계조회
            const result_feeImps = sendAjaxFrm("frm_Search", "/LALM1003_selFeeImps", "POST");
            let feeImps;

            if(result_feeImps.status != RETURN_SUCCESS){
                showErrorMessage(result_feeImps,'NOTFOUND');
                return;
            } else {
                feeImps = setDecrypt(result_feeImps);
            }
            exFeeSum = Number(feeImps.FEE_SUM);

            const results = sendAjaxFrm("frm_Search", "/LALM1003_insFeeReset", "POST");
            let result;
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            } else {
            	//계산후 수수료합계조회
            	const result_feeImps2 = sendAjaxFrm("frm_Search", "/LALM1003_selFeeImps", "POST");
            	let feeImps2;
            	if(result_feeImps2.status != RETURN_SUCCESS) {
            	    showErrorMessage(result_feeImps2,'NOTFOUND');
            	    return;
                } else {
                    feeImps2 = setDecrypt(result_feeImps2);
                }
                nowFeeSum = Number(feeImps2.FEE_SUM);
                  
                if(exFeeSum != nowFeeSum) {
                	MessagePopup('OK','수수료 수정내역이 존재합니다.<br>해당 경매일, 경매대상의 수수료를 확인하세요.');
                } else {
                	MessagePopup('OK','수수료 수정내역이 존재하지 않습니다.');
                }
            }
        });

        fn_CreateGrid();
        //초기화
        fn_Init();
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init() {
        //그리드 초기화
        $("#grd_MhSogCow").jqGrid("clearGridData", true);

        //폼 초기화
        fn_InitFrm('frm_Search');
        if(App_na_bzplc == '8808990656588' || App_na_bzplc == '8808990659008'){// 세종공주: 8808990656588 경주 8808990659008
        	$( "#auc_obj_dsc" ).val($( "#auc_obj_dsc option:last").val()).prop("selected",true);
        }else {
            $( "#auc_obj_dsc" ).val($( "#auc_obj_dsc option:first").val()).prop("selected",true);
        }        
        fn_ChangeAucObjDsc();
        
        
        $( "#auc_obj_dsc" ).focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
        //정합성체크
        if(fn_isNull($( "#auc_obj_dsc" ).val())) {
        	MessagePopup('OK','경매대상구분을 선택하세요.', null, function(){
        		$( "#auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.', function(){
        		$( "#auc_dt" ).focus();
            });
            return;
        }
        
        if(!fn_isDate($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.', function(){
                $( "#auc_dt" ).focus();
            });
            return;
        }
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
        
        const results = sendAjaxFrm("frm_Search", "/LALM1003_selList", "POST");        
        let result;
        if(results.status != RETURN_SUCCESS) {
            showErrorMessage(results);
            return;
        } else {
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
        fn_ExcelDownlad('grd_MhSogCow', '출장우내역조회');
    } 
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    //경매대상변경시 이벤트
    function fn_ChangeAucObjDsc(){
    	$("#frm_Search").append("<input type='hidden' id='flag' name='flag' value='init' />");
    	const results = sendAjaxFrm("frm_Search", "/Common_selAucDt", "POST"); 
        let result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        } else {      
            result = setDecrypt(results);
        } 
        $( "#auc_dt" ).datepicker().datepicker("setDate", fn_toDate(result.AUC_DT));
    }
    
    //그리드 생성
    // TODO :: 경매대상구분에 따라 컬럼리스트를 다르게 생성해야함
    function fn_CreateGrid(data){
        let rowNoValue = 0;
        if(data != null){
            rowNoValue = data.length;
        }
        const searchResultColNames = ["H사업장코드","H경매일자","H원표번호"
        	                       ,"경매<br/>번호","경매<br/>대상","출하자<br/>코드","출하자","출하자<br>생년월일","조합원<br/>여부","관내외<br>구분","생산자","접수<br/>일자","진행<br/>상태"
                                   ,"낙찰자명","참가번호","귀표번호","성별","자가운송여부","생년월일","월령","계대","등록번호","등록구분"
                                   ,"제각여부","KPN번호","어미귀표번호","어미구분","산차","중량","수송자","수의사","예정가","낙찰단가"
                                   ,"낙찰가","브루셀라<br>검사일자","브루셀라검사<br>증명서제출","예방접종일자","괴사감정여부","괴사여부","임신감정여부","임신여부","임신구분","인공수정일자"
                                   ,"수정KPN","임신개월","인공수정<br>증명서제출여부","우결핵검사일","전송","주소","휴대폰번호","비고","친자검사결과","친자검사여부"
                                   ,"사료미사용여부","추가운송비","사료대금","당일접수비","브랜드명","수의사구분","고능력여부","난소적출여부","등록일시","등록자"
                                   ,"계좌번호","출자금","딸린송아지<br>귀표번호","구분"
                                  
                                  ];        
        const searchResultColModel = [
        	                         {name:"NA_BZPLC",             index:"NA_BZPLC",             width:90, height:30,  sortable:false, align:'center', hidden:true},
        	                         {name:"AUC_DT",               index:"AUC_DT",               width:90,  sortable:false, align:'center', hidden:true},
                                     {name:"OSLP_NO",              index:"OSLP_NO",              width:90,  sortable:false, align:'center', hidden:true},
                                     {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:50,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:60,  sortable:false, align:'center'},
                                     {name:"FTSNM",                index:"FTSNM",                width:75,  sortable:false, align:'center'},
                                     {name:"FHS_BIRTH",            index:"FHS_BIRTH",            width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"MACO_YN",              index:"MACO_YN",              width:65,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
                                     {name:"JRDWO_DSC",            index:"JRDWO_DSC",            width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"SRA_PDMNM",            index:"SRA_PDMNM",            width:80,  sortable:false, align:'center'},
                                     {name:"RC_DT",                index:"RC_DT",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"SEL_STS_DSC",          index:"SEL_STS_DSC",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
                                     
                                     {name:"SRA_MWMNNM",           index:"SRA_MWMNNM",           width:80,  sortable:false, align:'center'},
                                     {name:"LVST_AUC_PTC_MN_NO",   index:"LVST_AUC_PTC_MN_NO",   width:40,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"TRPCS_PY_YN",          index:"TRPCS_PY_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"BIRTH",                index:"BIRTH",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"MTCN",                 index:"MTCN",                 width:40,  sortable:false, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_INDV_PASG_QCN",    index:"SRA_INDV_PASG_QCN",    width:40,  sortable:false, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_INDV_BRDSRA_RG_NO",index:"SRA_INDV_BRDSRA_RG_NO",width:60,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"RG_DSC",               index:"RG_DSC",               width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     
                                     {name:"RMHN_YN",              index:"RMHN_YN",              width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"KPN_NO",               index:"KPN_NO",               width:60,  sortable:false, align:'center'},
                                     {name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"MCOW_DSC",             index:"MCOW_DSC",             width:60,  sortable:false, align:'center', sorttype: "number", edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"MATIME",               index:"MATIME",               width:40,  sortable:false, align:'right', sorttype: "number"},
                                     {name:"COW_SOG_WT",           index:"COW_SOG_WT",           width:70,  sortable:false, align:'right', formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"VHC_DRV_CAFFNM",       index:"VHC_DRV_CAFFNM",       width:80,  sortable:false, align:'center'},
                                     {name:"BRKR_NAME",            index:"BRKR_NAME",            width:80,  sortable:false, align:'center'},
                                     {name:"LOWS_SBID_LMT_AM",     index:"LOWS_SBID_LMT_AM",     width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_UPR",         index:"SRA_SBID_UPR",         width:70,  sortable:false, align:'right', sorttype: "number" , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     
                                     {name:"SRA_SBID_AM",          index:"SRA_SBID_AM",          width:70,  sortable:false, align:'right' , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"BRCL_ISP_DT",          index:"BRCL_ISP_DT",          width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"BRCL_ISP_CTFW_SMT_YN", index:"BRCL_ISP_CTFW_SMT_YN", width:90,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"VACN_DT",              index:"VACN_DT",              width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"NCSS_JUG_YN",          index:"NCSS_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"NCSS_YN",              index:"NCSS_YN",              width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PRNY_JUG_YN",          index:"PRNY_JUG_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PRNY_YN",              index:"PRNY_YN",              width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PPGCOW_FEE_DSC",       index:"PPGCOW_FEE_DSC",       width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
                                     {name:"AFISM_MOD_DT",         index:"AFISM_MOD_DT",         width:80,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     
                                     {name:"MOD_KPN_NO",           index:"MOD_KPN_NO",           width:50,  sortable:false, align:'center'},
                                     {name:"PRNY_MTCN",            index:"PRNY_MTCN",            width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"AFISM_MOD_CTFW_SMT_YN",index:"AFISM_MOD_CTFW_SMT_YN",width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"BOVINE_DT",            index:"BOVINE_DT",            width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"TMS_YN",               index:"TMS_YN",               width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_TMS_YN_DATA}},
                                     {name:"DONGUP",               index:"DONGUP",               width:150, sortable:false, align:'left'},
                                     {name:"CUS_MPNO",             index:"CUS_MPNO",             width:120, sortable:false, align:'center'},
                                     {name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, sortable:false, align:'left'},
                                     {name:"DNA_YN",               index:"DNA_YN",               width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA}},
                                     {name:"DNA_YN_CHK",           index:"DNA_YN_CHK",           width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     
                                     {name:"SRA_FED_SPY_YN",       index:"SRA_FED_SPY_YN",       width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"SRA_TRPCS",            index:"SRA_TRPCS",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_FED_SPY_AM",       index:"SRA_FED_SPY_AM",       width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"TD_RC_CST",            index:"TD_RC_CST",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"BRANDNM",              index:"BRANDNM",              width:80,  sortable:false, align:'center'},
                                     {name:"PDA_ID",               index:"PDA_ID",               width:50,  sortable:false, align:'center'},
                                     {name:"EPD_YN",               index:"EPD_YN",               width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"SPAY_YN",              index:"SPAY_YN",              width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"FSRG_DTM",             index:"FSRG_DTM",             width:110, sortable:false, align:'center'},
                                     {name:"USRNM",                index:"USRNM",                width:80,  sortable:false, align:'center'},
                                     
                                     {name:"SRA_FARM_ACNO",        index:"SRA_FARM_ACNO",        width:120, sortable:false, align:'center'},
                                     {name:"SRA_PYIVA",            index:"SRA_PYIVA",            width:70,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"INDV_AMNNO",           index:"INDV_AMNNO",           width:120, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"CASE_COW",             index:"CASE_COW",             width:90,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)}},
                                    ];
            
        $("#grd_MhSogCow").jqGrid("GridUnload");

        $("#grd_MhSogCow").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            footerrow: true,
            userDataOnFooter: true,
            ondblClickRow: function(rowid, iRow, iCol){
                const sel_data = $("#grd_MhSogCow").getRowData(rowid);
                const data = new Object();
                data["na_bzplc"] = sel_data.NA_BZPLC;
                data["auc_dt"] = sel_data.AUC_DT;
                data["auc_obj_dsc"] = sel_data.AUC_OBJ_DSC;
                data["oslp_no"] = sel_data.OSLP_NO;
                fn_OpenMenu('LALM1004',data);
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
    }
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

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
                    <input type="hidden" id="chg_del_yn"/>
                    <input type="hidden" id="chg_pgid"/>
                    <input type="hidden" id="chg_rmk_cntn"/>
                    <table>
                        <colgroup>
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상구분</th>
                                <td>
                                    <select id="auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                    </div>
                                </td>
                                <th scope="row">출하주</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:60px;">
                                             <input disabled="disabled" type="text" id="fhs_id_no" maxlength="10">
                                         </div>
                                         <div class="cell pl2" style="width:28px;">
                                             <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>
                                         <div class="cell">
                                             <input type="text" id="ftsnm" maxlength="30">
                                         </div>
                                     </div>
                                </td>
                                <th scope="row">경매번호</th>
                                <td>
                                    <input type="text" id="auc_prg_sq" class="integer" maxlength="10">                                        
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
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                    <%-- <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 					 건은 변경이 불가능 합니다.</label> --%>
                    <%-- <button class="tb_btn" id="pb_CowReport">비육우 출력</button> --%>
                </div>
            </div>
            <div class="listTable mb5">
                <table id="grd_MhSogCow"></table>
            </div>
            <div class="tab_box clearfix">
                <div class="fl_L"><!--  //버튼 모두 좌측정렬 -->   
                    <button class="tb_btn" id="pb_FeeReset">수수료재설정</button>
                    <button class="tb_btn" id="pb_AllDel">전체삭제</button>
                </div>      
                              
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                    <button class="tb_btn" id="pb_ExcelConversion">엑셀변환</button>
                    <button class="tb_btn" id="pb_ExcelTempDownload">엑셀 템플릿</button>
                    <button class="tb_btn" id="pb_ExcelUpload">엑셀업로드</button>
                </div> 
            </div>            
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>