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
        fn_Init();
        
        fn_setCodeBox("srch_auc_obj_dsc", "AUC_OBJ_DSC", 2, true, "전체");
        
    	//날짜 선택
    	$("input[name='srch_month']").change(function(){
    		var month = $(this).val();
    		var gapDay = month == "12" ? 365 * -1 : month * 30 * -1;
    		$("input[name='st_dt']").datepicker().datepicker("setDate", fn_getDay(gapDay,'YYYY-MM-DD'));
    		$("input[name='en_dt']").datepicker().datepicker("setDate", fn_getToday());
    	});
    	
    	//탭 타이틀 클릭 시
        var $tabEvtT = $('.tab_box .tab_list li a');        
 		$tabEvtT.on('click',function(){
 			$tabEvtT.removeClass('on');
 			$(this).addClass('on');
 			$(".tab_content").hide();
 			var activeTab = $(this).attr("href");
 			$(activeTab).fadeIn();
 			
 			if(activeTab.replace("#", "") =="tab1"){
 				fn_setCodeBox("srch_auc_obj_dsc", "AUC_OBJ_DSC", 2, true, "전체");
 				$("#month_03").attr("disabled", false);
 				$(".tab1_txt").show();
 				$(".tab2_txt").hide();
 				$(".tab3_txt").hide();
 			}else if(activeTab.replace("#", "") =="tab2"){
 				fn_setCodeBox("srch_auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
 				$("#month_03").attr("disabled", true);
 				$(".tab1_txt").hide();
 				$(".tab2_txt").show();
 				$(".tab3_txt").hide();
 			} else {
 				fn_setCodeBox("srch_auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
 				$("#month_03").attr("disabled", true);
 				$(".tab1_txt").hide();
 				$(".tab2_txt").hide();
 				$(".tab3_txt").show();
 			}
 			
 			// 탭변경시 1개월로 초기화처리
//  			fn_setChgRadio('srch_month','1');
//  			fn_setRadioChecked('srch_month');
 			$("#month_01").attr("checked", true);
 			$("input[name='st_dt']").datepicker().datepicker("setDate", fn_getDay(-30,'YYYY-MM-DD'));
 	     	$("input[name='en_dt']").datepicker().datepicker("setDate", fn_getToday());
 			
 			//검색해야 하는 영역에 대한 값도 셋팅
 			$("#srch_tab_gubun").val(activeTab.replace("#", ""));
 			
 			//탭 이동 있을 때마다 그리드 초기화
 			$("#grd_MhSogCowStatics").jqGrid("clearGridData", true);
 	    	$("#grd_MhSogCowRowData").jqGrid("clearGridData", true);
 	    	$("#grd_MhSogCow").jqGrid("clearGridData", true);
 			
 			return false;
 	    });
 		
 		//경매대상 변경
 		/* $("#srch_auc_obj_dsc").bind('change',function(e){
            e.preventDefault();
            fn_ChangeAucObjDsc();
        }); */
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
    	$("input[name='st_dt']").datepicker().datepicker("setDate", fn_getDay(-30,'YYYY-MM-DD'));
     	$("input[name='en_dt']").datepicker().datepicker("setDate", fn_getToday());
     	
    	$(".tab_content").hide();
        $(".tab_content:first").show();
        
        $("#grd_MhSogCowStatics").jqGrid("clearGridData", true);
    	$("#grd_MhSogCowRowData").jqGrid("clearGridData", true);
    	$("#grd_MhSogCow").jqGrid("clearGridData", true);
    	
    	fn_CreateGridMhSogCowStatics();	
    	fn_CreateGridMhSogCowRowData();
    	fn_CreateGridMhSogCow();
    	
    	$("#srch_tab_gubun").val("tab1");
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(clearFlag){
    	var searchUrl =  ""; 
        var tabGubun = $("#srch_tab_gubun").val();
    	$("#grd_MhSogCowStatics").jqGrid("clearGridData", true);
    	$("#grd_MhSogCowRowData").jqGrid("clearGridData", true);
    	$("#grd_MhSogCow").jqGrid("clearGridData", true);
    	
    	//기간 설정 : 사용자접속현황은 최대 1년, 경매낙찰현황은 최대 3개월
        var st_dt = $("input[name='st_dt']").val().replaceAll("-", "");
     	var en_dt = $("input[name='en_dt']").val().replaceAll("-", "");
        var searchStMonth = new Date(st_dt.substr(0,4), st_dt.substr(4,2) - 1, st_dt.substr(6,2));
        var searchEnMonth = new Date(en_dt.substr(0,4), en_dt.substr(4,2) - 1, en_dt.substr(6,2));
		var monthDiff = searchEnMonth.getMonth() - searchStMonth.getMonth() + (12 * (searchEnMonth.getFullYear() - searchStMonth.getFullYear()));
		
        if(tabGubun == "tab1"){
        	searchUrl = "/LALM0919_selMhSogCowStaticsList";
        	
        	if(monthDiff > 12){
        		//en_dt 로부터 1년
        		$("input[name='st_dt']").val( fn_getAddDay(en_dt, -365 ,'YYYY-MM-DD'));
        	}
        }else if(tabGubun == "tab2"){
        	searchUrl = "/LALM0919_selMhSogCowRowDataList";
        	if(monthDiff > 3){
        		//en_dt 로부터 3개월
        		$("input[name='st_dt']").val( fn_getAddDay(en_dt, -90 ,'YYYY-MM-DD'));
        	}
        }else{
        	searchUrl = "/LALM0919_selCowList";
        	if(monthDiff > 3){
        		//en_dt 로부터 3개월
        		$("input[name='st_dt']").val( fn_getAddDay(en_dt, -90 ,'YYYY-MM-DD'));
        	}
        }
        
       	var results = sendAjaxFrm("frm_Search", searchUrl, "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            if(clearFlag != "clear"){
                showErrorMessage(results);
            }
            return;      	
        }else{
            result = setDecrypt(results);
            mv_RunMode = 2;
            if(tabGubun == "tab1"){
            	fn_CreateGridMhSogCowStatics(result);	//grd_MhSogCowStatics
            }else if(tabGubun == "tab2"){
            	fn_CreateGridMhSogCowRowData(result);	//grd_MhSogCowRowData
            }else{
            	fn_CreateGridMhSogCow(result);	//grd_MhSogCow
            }
        }                  
    } 
    
    //사용자접속현황
	function fn_CreateGridMhSogCowStatics(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["조합코드","조합명","경매일자","출장우<br/>두수", "낙찰두수", "낙찰율", "응찰참여<br/>매수인", "낙찰<br/>매수인", "참여율"];        
        var searchResultColModel = [						 
	           {name:"NA_BZPLC",	index:"NA_BZPLC",	width:100, align:'center'},                                     
	           {name:"CLNTNM",	index:"CLNTNM",	width:100, align:'center'},                                     
	           {name:"AUC_DT",   	index:"AUC_DT", 		width:80, align:'center',formatter:'gridDateFormat'},
	           {name:"FORW_CNT",   	index:"FORW_CNT",    	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"SEL_CNT",     	index:"SEL_CNT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PER",		index:"SEL_PER",	width:100, align:'center'},
	           {name:"AUC_CNT",   	index:"AUC_CNT",    	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"AUC_RCV_CNT",     index:"AUC_RCV_CNT",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AUC_RCV_PER",     	index:"AUC_RCV_PER",      	width:100, align:'center'}
        ];
        
        $("#grd_MhSogCowStatics").jqGrid("GridUnload");
        
        $("#grd_MhSogCowStatics").jqGrid({
            datatype:    "local",
            data:        data,
            height:      480,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        
        $("#grd_MhSogCowStatics").jqGrid("setLabel", "rn","No");
    }
  	
  	//경매낙찰현황
    function fn_CreateGridMhSogCowRowData(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자","경매대상", "경매순번", "출하자", "우편번호", "주소", "귀표번호", "생일", "산차", "계대", "KPN번호", "등록구분", "성별", "어미귀표", "어미구분", "중량(Kg)", "예정가", "낙찰가", "낙찰단가", "제각여부", "수송자", "참가번호", "낙찰자", "낙찰자<br/>연락처", "출하자수수료", "낙찰자수수료"];         
        var searchResultColModel = [						 
        	   {name:"AUC_DT",   	index:"AUC_DT", 		width:80, align:'center',formatter:'gridDateFormat'},                                   
	           {name:"AUC_OBJ_DSC",	index:"AUC_OBJ_DSC",	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},   
	           {name:"AUC_PRG_SQ",     	index:"AUC_PRG_SQ",      	width:100, align:'center'},
	           {name:"FTSNM",		index:"FTSNM",	width:80, align:'center'},
	           {name:"ZIP",   	index:"ZIP", 		width:100, align:'center'},
	           {name:"ADDRESS",   	index:"ADDRESS", 		width:100, align:'center'},
	           {name:"SRA_INDV_AMNNO",   	index:"SRA_INDV_AMNNO", 		width:100, align:'center'},
	           {name:"BIRTH",   	index:"BIRTH",    	width:100, align:'center'},                                     
	           {name:"MATIME",     index:"MATIME",      width:100, align:'center', formatter : 'integer'},
	           {name:"SRA_INDV_PASG_QCN",     index:"SRA_INDV_PASG_QCN",      width:100, align:'center', formatter : 'integer'},
	           {name:"KPN_NO",     	index:"KPN_NO",      	width:100, align:'center'},
	           {name:"RG_DSC",     	index:"RG_DSC",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	           {name:"INDV_SEX_C",     	index:"INDV_SEX_C",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	           {name:"MCOW_SRA_INDV_AMNNO",     	index:"MCOW_SRA_INDV_AMNNO",      	width:100, align:'center'},
	           {name:"MCOW_DSC",     	index:"MCOW_DSC",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	           {name:"COW_SOG_WT",     	index:"COW_SOG_WT",      	width:100, align:'center', formatter : 'integer'},
	           {name:"LOWS_SBID_LMT_AM",     	index:"LOWS_SBID_LMT_AM",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SRA_SBID_AM",     	index:"SRA_SBID_AM",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SRA_SBID_UPR",     	index:"SRA_SBID_UPR",      	width:100, align:'center', formatter : 'integer'},
	           {name:"RMHN_YN",     	index:"RMHN_YN",      	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
	           {name:"VHC_DRV_CAFFNM",     	index:"VHC_DRV_CAFFNM",      	width:100, align:'center'},
	           {name:"LVST_AUC_PTC_MN_NO",     	index:"LVST_AUC_PTC_MN_NO",      	width:100, align:'center', formatter : 'integer'},
	           {name:"SRA_MWMNNM",     	index:"SRA_MWMNNM",      	width:100, align:'center'},
	           {name:"CUS_MPNO",     	index:"CUS_MPNO",      	width:100, align:'center'},
	           {name:"FEE_CHK_YN_FEE",     	index:"FEE_CHK_YN_FEE",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SELFEE_CHK_YN_FEE",     	index:"SELFEE_CHK_YN_FEE",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}}
        ];
        
        $("#grd_MhSogCowRowData").jqGrid("GridUnload");
        
        $("#grd_MhSogCowRowData").jqGrid({
            datatype:    "local",
            data:        data,
            height:      480,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#grd_MhSogCowRowData").jqGrid("setLabel", "rn","No");
    }
  	
  //출장우내역
    function fn_CreateGridMhSogCow(data){              
        
        var rowNoValue = 0;
        if(data != null){
            rowNoValue = data.length;
        }
        var searchResultColNames = ["H사업장코드","H경매일자","H원표번호"
        	                       ,"경매번호","경매대상","출하자코드","출하자","출하자<br>생년월일", "출하자<br>휴대폰번호","출하자주소","조합원여부","관내외<br>구분","생산자","접수일자","진행상태"
                                   ,"낙찰자명","낙찰자<br>생년월일","낙찰자<br>휴대폰번호","낙찰자주소","참가번호","귀표번호","성별","자가운송여부","생년월일","월령","계대","등록번호","등록구분"
                                   ,"제각여부","KPN번호","어미귀표번호","어미구분","산차","중량","수송자","수의사","예정가","낙찰단가"
                                   ,"낙찰가","브루셀라<br>검사일자","브루셀라검사<br>증명서제출","예방접종일자","괴사감정여부","괴사여부","임신감정여부","임신여부","임신구분","인공수정일자"
                                   ,"수정KPN","임신개월","인공수정<br>증명서제출여부","우결핵검사일","전송","비고","친자검사결과","친자검사여부"
                                   ,"사료미사용여부","추가운송비","사료대금","당일접수비","브랜드명","수의사구분","고능력여부","난소적출여부","등록일시","등록자"
                                   ,"계좌번호","출자금","딸린송아지<br>귀표번호","구분"
                                  
                                  ];        
        var searchResultColModel = [
        	                         {name:"NA_BZPLC",             index:"NA_BZPLC",             width:90,height:30,  sortable:false, align:'center', hidden:true},
        	                         {name:"AUC_DT",               index:"AUC_DT",               width:90,  sortable:false, align:'center', hidden:true},
                                     {name:"OSLP_NO",              index:"OSLP_NO",              width:90,  sortable:false, align:'center', hidden:true},
                                     {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:40,  sortable:false, align:'center', sorttype: "number"},
                                     {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"FHS_ID_NO",            index:"FHS_ID_NO",            width:70,  sortable:false, align:'center'},
                                     {name:"FTSNM",                index:"FTSNM",                width:80,  sortable:false, align:'center'},
                                     {name:"FHS_BIRTH",            index:"FHS_BIRTH",            width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"CUS_MPNO",             index:"CUS_MPNO",             width:120, sortable:false, align:'center'},
                                     {name:"DONGUP",               index:"DONGUP",               width:150, sortable:false, align:'left'},
                                     {name:"MACO_YN",              index:"MACO_YN",              width:70,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
                                     {name:"JRDWO_DSC",            index:"JRDWO_DSC",            width:50,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"SRA_PDMNM",            index:"SRA_PDMNM",            width:80,  sortable:false, align:'center'},
                                     {name:"RC_DT",                index:"RC_DT",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"SEL_STS_DSC",          index:"SEL_STS_DSC",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
                                     
                                     {name:"SRA_MWMNNM",           index:"SRA_MWMNNM",           width:80,  sortable:false, align:'center'},
                                     {name:"MWMN_CUS_RLNO",            index:"MWMN_CUS_RLNO",            width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"MWMN_CUS_MPNO",           index:"MWMN_CUS_MPNO",           width:100,  sortable:false, align:'center'},
                                     {name:"MWMN_ADDRESS",           index:"MWMN_ADDRESS",           width:100,  sortable:false, align:'center'},
                                     
                                     {name:"LVST_AUC_PTC_MN_NO",   index:"LVST_AUC_PTC_MN_NO",   width:40,  sortable:false, align:'center'},
                                     {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"TRPCS_PY_YN",          index:"TRPCS_PY_YN",          width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"BIRTH",                index:"BIRTH",                width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                     {name:"MTCN",                 index:"MTCN",                 width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_INDV_PASG_QCN",    index:"SRA_INDV_PASG_QCN",    width:40,  sortable:false, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_INDV_BRDSRA_RG_NO",index:"SRA_INDV_BRDSRA_RG_NO",width:60,  sortable:false, align:'center'},
                                     {name:"RG_DSC",               index:"RG_DSC",               width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     
                                     {name:"RMHN_YN",              index:"RMHN_YN",              width:40,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"KPN_NO",               index:"KPN_NO",               width:60,  sortable:false, align:'center'},
                                     {name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:110, sortable:false, align:'center', formatter:'gridIndvFormat'},
                                     {name:"MCOW_DSC",             index:"MCOW_DSC",             width:60,  sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"MATIME",               index:"MATIME",               width:40,  sortable:false, align:'right'},
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
            height:      480,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel
		});
    }
  	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
    	//탭 타이틀 클릭 시
        var tabEvt = $('.tab_box .tab_list li a.on');
    	var activeId = tabEvt.attr("id");
  		
  		if(activeId == "pb_tab1"){
	    	fn_ExcelDownlad('grd_MhSogCowStatics', '사용자접속현황');
  		}else if(activeId == "pb_tab2"){
	    	fn_ExcelDownlad('grd_MhSogCowRowData', '경매낙찰현황');
  		} else {
	    	fn_ExcelDownlad('grd_MhSogCow', '출장우내역');
  		}
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    //@Deprecated
    function fn_Search_backup(clearFlag){
    	var searchUrl =  ""; 
        var tabGubun = $("#srch_tab_gubun").val();
    	$("#grd_MhSogCowCnt").jqGrid("clearGridData", true);
    	$("#grd_MhSogCowPrice").jqGrid("clearGridData", true);
    	
        if(tabGubun == "tab1"){
        	searchUrl = "/LALM0919_selMhSogCowCntList";
        }else if(tabGubun == "tab2"){
        	searchUrl = "/LALM0919_selMhSogCowPriceList";
        }
        
       	var results = sendAjaxFrm("frm_Search", searchUrl, "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            if(clearFlag != "clear"){
                showErrorMessage(results);
            }
            return;      	
        }else{
            result = setDecrypt(results);
            mv_RunMode = 2;
            if(tabGubun == "tab1"){
	            fn_CreateGridMhSogCowCnt(result);	//grd_MhSogCowCnt
            }else if(tabGubun == "tab2"){
            	fn_CreateGridMhSogCowPrice(result);	//grd_MhSogCowPrice
            }
        }                  
    } 
    
  	//그리드 생성
  	//@Deprecated
    function fn_CreateGridMhSogCowCnt(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자","총 출장두수", "송아지", "비육우", "번식우", "총 낙찰두수", "송아지","비육우", "번식우", "낙찰율"];        
        var searchResultColModel = [						 
	           {name:"AUC_DT",	index:"AUC_DT",	width:100, align:'center'},                                     
	           {name:"FORW_CNT",	index:"FORW_CNT",	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"FORW_CALF",   	index:"FORW_CALF", 		width:80, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"FORW_NBFCT",   	index:"FORW_NBFCT",    	width:80, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"FORW_PPGCOW",     index:"FORW_PPGCOW",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_CNT",     	index:"SEL_CNT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_CALF",     	index:"SEL_CALF",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_NBFCT",     	index:"SEL_NBFCT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PPGCOW",     	index:"SEL_PPGCOW",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PER",		index:"SEL_PER",	width:100, align:'center'}
        ];
        
        $("#grd_MhSogCowCnt").jqGrid("GridUnload");
        
        $("#grd_MhSogCowCnt").jqGrid({
            datatype:    "local",
            data:        data,
            height:      480,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            /* multiselect:true, */	/*체크박스 선택 가능하게끔 하는 속성*/
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            afterInsertRow : function(rowId, data){
            	$("#grd_MhSogCowCnt").setCell(rowId, 'FORW_CNT', '', {'background-color':'#ccffcc', 'border-left':'1px solid #999'});
            	$("#grd_MhSogCowCnt").setCell(rowId, 'SEL_CNT', '', {'background-color':'#ccffcc', 'border-left':'1px solid #999'});
            	$("#grd_MhSogCowCnt").setCell(rowId, 'SEL_PER', '', {'background-color':'#ffcc99', 'border-left':'1px solid #999'});
            }
        });
        
        $("#grd_MhSogCowCnt").jqGrid("setLabel", "rn","No");
    }
  	
  	//@Deprecated
    function fn_CreateGridMhSogCowPrice(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자","총 출장두수", "총 낙찰두수", "낙찰율", "송아지(암) 평균 낙찰가", "송아지(수) 평균 낙찰가", "비육우(암) 평균 낙찰가", "비육우(수) 평균 낙찰가", "번식우 평균 낙찰가"];         
        var searchResultColModel = [						 
        	   {name:"AUC_DT",	index:"AUC_DT",	width:80, align:'center'},                                     
	           {name:"FORW_CNT",	index:"FORW_CNT",	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},   
	           {name:"SEL_CNT",     	index:"SEL_CNT",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"SEL_PER",		index:"SEL_PER",	width:80, align:'center'},
	           {name:"AVG_FCALF",   	index:"AVG_FCALF", 		width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AVG_MCALF",   	index:"AVG_MCALF",    	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},                                     
	           {name:"AVG_FNBFCT",     index:"AVG_FNBFCT",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AVG_MNBFCT",     index:"AVG_MNBFCT",      width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}},
	           {name:"AVG_PPGCOW",     	index:"AVG_PPGCOW",      	width:100, align:'center', formatter : 'integer',formatoptions : {thousandsSeparator : ',',decimalPlaces : 0}}
        ];
        
        $("#grd_MhSogCowPrice").jqGrid("GridUnload");
        
        $("#grd_MhSogCowPrice").jqGrid({
            datatype:    "local",
            data:        data,
            height:      480,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#grd_MhSogCowPrice").jqGrid("setLabel", "rn","No");
    }
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                	<form id="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="250">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <select id="srch_auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox" id="rd_month" style="width:555px;">
                                        <div class="cell">
                                            <input type="radio" id="month_01" name="srch_month" value="1" checked="checked" onclick="javascript:fn_setChgRadio('srch_month','1');fn_setRadioChecked('srch_month');"/>
                                            <label for="month_01">1개월</label>
                                            <input type="radio" id="month_02" name="srch_month" value="3" onclick="javascript:fn_setChgRadio('srch_month','3');fn_setRadioChecked('srch_month');"/>
                                            <label for="month_02">3개월</label>
                                            <input type="radio" id="month_03" name="srch_month" value="12" onclick="javascript:fn_setChgRadio('srch_month','12');fn_setRadioChecked('srch_month');"/>
                                            <label for="month_03">1년</label>
                                            
                                            <input type="text" class="date search_date" name="st_dt" id="st_dt" maxlength="10" style="width:150px;margin-left:15px;">
						        			~
						        			<input type="text" class="date search_date" name="en_dt" id="en_dt" maxlength="10" style="width:150px;">
                                        </div>
                                        
                                        <span class="tab1_txt">* 최대 1년</span>
                                    	<span class="tab2_txt" style="display:none;">* 최대 3개월</span>
                                    	<span class="tab3_txt" style="display:none;">* 최대 3개월</span>
                                    </div>
                                    <input type="hidden" id="srch_month" />
                                    <input type="hidden" id="srch_tab_gubun" />
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
            
            <div class="tab_box clearfix line">
				<ul class="tab_list fl_L">
					<li><a href="#tab1" id="pb_tab1" class="on">사용자접속현황</a></li>
					<li><a href="#tab2" id="pb_tab2">경매낙찰현황</a></li>
					<li><a href="#tab3" id="pb_tab3">출장우내역</a></li>
				</ul>
				
				<div class="fl_R dorm_secs_btn"><!--  //버튼 모두 우측정렬 -->
                </div>
			</div>
			
			<div id="tab1" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCowStatics" style="width:100%;">
	                </table>
                </div>
			</div>
			<div id="tab2" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCowRowData" style="width:100%;">
	                </table>
                </div>
			</div>
			<div id="tab3" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow" style="width:100%;">
	                </table>
                </div>
			</div>
        </section>
        
        
    </div>
</body>
</html>