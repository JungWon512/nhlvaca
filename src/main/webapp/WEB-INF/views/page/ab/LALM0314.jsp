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
.fontBold{
	font-size:15px;
	font-weight:700;
}
</style>
<script type="text/javascript">
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0314
 * 3. 파일명(한글) : 일괄경매시작/마감
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.31   신명진   최초작성
 ------------------------------------------------------------------------------*/
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     var na_bzplc = App_na_bzplc;
     var mv_cut_am       = "";
	 var mv_sqno_prc_dsc = "";
     
     $(document).ready(function(){
    	$(".tab_content").hide();
        $(".tab_content:first").show();
         
        var $tabEvtT = $('.tab_box .tab_list li a');        
 		$tabEvtT.on('click',function(){
 			$tabEvtT.removeClass('on');
 			$(this).addClass('on');
 			$(".tab_content").hide();
 			var activeTab = $(this).attr("href");
 			$(activeTab).fadeIn();
 			return false;
 	    });
 		
    	fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2);
    	
        fn_Init();
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MhAucStn");
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow1");
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow2");
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow3");
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow4");
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow5");
        
        //프로그램ID 대문자 변환
        $("#de_pgid").bind("keyup", function(){
            $(this).val($(this).val().toUpperCase());
        });
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //폼 초기화
        fn_InitFrm('frm_Search');
        
        $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        
      	//탭 초기화
        $(".tab_content").hide();
        $("#tab2").fadeIn('on');
        
        $("#pb_tab1").removeClass('on');
        $("#pb_tab3").removeClass('on');
        $("#pb_tab4").removeClass('on');
		$("#pb_tab2").addClass('on');
		
		//그리드 초기화
		$("#grd_MhAucStn").jqGrid("clearGridData", true);
		$("#grd_MhSogCow1").jqGrid("clearGridData", true);
		$("#grd_MhSogCow2").jqGrid("clearGridData", true);
		$("#grd_MhSogCow3").jqGrid("clearGridData", true);
		$("#grd_MhSogCow4").jqGrid("clearGridData", true);
		$("#grd_MhSogCow5").jqGrid("clearGridData", true);
        fn_CreateGrid();
        fn_CreateGridSogCow1();
        fn_CreateGridSogCow2();
        fn_CreateGridSogCow3();
        fn_CreateGridSogCow4();
        fn_CreateGridSogCow5();
        
        if(App_userId != "admin") {
        	$("#grd_MhAucStn").jqGrid("hideCol","CHG_DDL_QCN");
        }
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
    	$("#grd_MhAucStn").jqGrid("clearGridData", true);
    	$("#grd_MhSogCow1").jqGrid("clearGridData", true);
    	$("#grd_MhSogCow2").jqGrid("clearGridData", true);
    	$("#grd_MhSogCow3").jqGrid("clearGridData", true);
    	$("#grd_MhSogCow4").jqGrid("clearGridData", true);
    	$("#grd_MhSogCow5").jqGrid("clearGridData", true);
    	
    	var resultsAucQcn = sendAjaxFrm("frm_Search", "/LALM0314_selAucQcnList", "POST");
        var resultAucQcn;
        
        if(resultsAucQcn.status != RETURN_SUCCESS){
        	MessagePopup("OK", "경매차수가 등록되지 않았습니다.");
            return;
            
        } else {
        	resultAucQcn = setDecrypt(resultsAucQcn);
        	
        	mv_cut_am = resultAucQcn[0]["CUT_AM"];
        	mv_sqno_prc_dsc = resultAucQcn[0]["SGNO_PRC_DSC"];
        	
        	var results = sendAjaxFrm("frm_Search", "/LALM0314_selList", "POST");        
            var result;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            }else{
                result = setDecrypt(results);
                mv_RunMode = 2;
                fn_CreateGrid(result);
            }
        }
    	
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     function fn_Print() {
    	 
   	 	var result_3;
        var results_3 = null;
        results_3 = sendAjaxFrm("frm_Search", "/LALM0314_selList_simp", "POST");
         	  
        if(results_3.status != RETURN_SUCCESS){
            showErrorMessage(results_3);
            return;
        } else {
            result_3 = setDecrypt(results_3);
            $("#simp_cnm").val(result_3[0].SIMP_CNM);
            
            var TitleData = new Object();
         	TitleData.title = $("#simp_cnm").val() + "일괄경매시작/마감(유찰대상)";
         	TitleData.sub_title = "";
         	TitleData.unit="";
         	TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
            +  '/ [경매대상 + ' + $( "#auc_obj_dsc option:selected").text()  + ']';
         	TitleData.SIMP_CNM = $('#simp_cnm').val();
    		     	
         	if($("#pb_tab1").hasClass("on")){
         		TitleData.title = $("#simp_cnm").val()+ " 일괄경매시작/마감(낙찰자목록)";
             	TitleData.sub_title = "";
             	TitleData.unit="";
             	TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'

             	if(na_bzplc == '8808990811710'){ //영광
                 	ReportPopup('LALM0314R_1_0' ,TitleData, 'grd_MhSogCow5', 'V'); //기본 출력물             		
             	}else if(na_bzplc == '8808990659275'){ //나주
                 	ReportPopup('LALM0314R_1_1' ,TitleData, 'grd_MhSogCow5', 'V'); //기본 출력물             		
             	}else{
                 	ReportPopup('LALM0314R_1' ,TitleData, 'grd_MhSogCow5', 'V'); //기본 출력물             		
             	}
         	}
         	if($("#pb_tab2").hasClass("on")){
         		TitleData.title = $("#simp_cnm").val()+ " 일괄경매시작/마감(낙찰대상)";
             	TitleData.sub_title = "";
             	TitleData.unit="";
             	TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
             	
             	ReportPopup('LALM0314R_2' ,TitleData, 'grd_MhSogCow1', 'V'); //기본 출력물
         	}
         	if($("#pb_tab3").hasClass("on")){
         		TitleData.title = $("#simp_cnm").val()+ " 일괄경매시작/마감(유찰대상)";
             	TitleData.sub_title = "";
             	if(na_bzplc == '8808990656540') TitleData.sub_title = "출두수 : "+($('#grd_MhSogCow2').getGridParam("reccount")||'0')+" 두";
             	TitleData.unit="";
             	TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
                +  '/ [경매대상 + ' + $( "#auc_obj_dsc option:selected").text()  + ']';
             	
             	if(na_bzplc == '8808990656540'){
             		ReportPopup('LALM0314R0_1' ,TitleData, 'grd_MhSogCow2', 'V');              		
             	}else{
             		ReportPopup('LALM0314R0' ,TitleData, 'grd_MhSogCow2', 'V');             		
             	}  		      	
  		      	 
         	}
         	if($("#pb_tab4").hasClass("on")){
         		TitleData.title = $("#simp_cnm").val()+ " 일괄경매시작/마감(동가대상)";
             	TitleData.sub_title = "";
             	TitleData.unit="";
             	TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
             	
             	ReportPopup('LALM0314R_4' ,TitleData, 'grd_MhSogCow3,grd_MhSogCow4', 'V'); //기본 출력물
         	}
        } 
     
     }
     
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;
        var rowData    = new Object;
        
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매대상", "일련번호", "경매시작번호", "경매종료번호", "경매일자", "진행상태", "차수", "차수변경"];        
        var searchResultColModel = [						 
                                     {name:"AUC_OBJ_DSC",	index:"AUC_OBJ_DSC",	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 9)}},                                     
                                     {name:"RG_SQNO",   	index:"RG_SQNO", 		width:100, align:'center'},
                                     {name:"ST_AUC_NO",   	index:"ST_AUC_NO",    	width:100, align:'center'},                                     
                                     {name:"ED_AUC_NO",     index:"ED_AUC_NO",      width:100, align:'center'},
                                     {name:"AUC_DT",     	index:"AUC_DT",      	width:100, align:'center', hidden:true},
                                     {name:"SEL_STS_DSC",	index:"SEL_STS_DSC",	width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_SEL_DSC_DATA}},
                                     {name:"DDL_QCN",       index:"DDL_QCN",       	width:100, align:'center', editable:true,edittype:"select", formatter : "select", editoptions:{value:GRID_DDL_QCN_DATA}},
                                     {name:"CHG_DDL_QCN",   index:"CHG_DDL_QCN",    width:50,  align:'center', sortable: false, formatter :fn_GridChangeQcn}
                                    ];
        
        $("#grd_MhAucStn").jqGrid("GridUnload");
        
        $("#grd_MhAucStn").jqGrid({
            datatype:    "local",
            data:        data,
            height:      150,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            cellEdit:    true,
            cellsubmit:  "clientArray",
            onCellSelect:function(rowid,iCol,cellcontent,e){
            	if(iCol == 7) return;
            	$("#grd_MhSogCow1").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow2").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow3").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow4").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow5").jqGrid("clearGridData", true);
            	
            	rowData = new Object;
        		rowData = $('#grd_MhAucStn').jqGrid('getRowData', rowid);
        		
        		rowData["mv_cut_am"]              = mv_cut_am;
        		rowData["mv_sqno_prc_dsc"]        = mv_sqno_prc_dsc;
        		rowData["calf_auc_atdr_unt_am"]   = parent.envList[0]["CALF_AUC_ATDR_UNT_AM"];
        		rowData["nbfct_auc_atdr_unt_am"]  = parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"];
        		rowData["ppgcow_auc_atdr_unt_am"] = parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"];
        		rowData["nbfct_auc_upr_dsc"]      = parent.envList[0]["NBFCT_AUC_UPR_DSC"];
        		fn_SearchSogCow1(rowData);
         		fn_SearchSogCow2(rowData);
         		fn_SearchSogCow3(rowData);
         		fn_SearchSogCow5(rowData);
            },
            afterSaveCell : function(rowid,cellname,value,iRow,iCol){
            	$("#grd_MhSogCow1").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow2").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow3").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow4").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow5").jqGrid("clearGridData", true);
            	
            	rowData = new Object;
        		rowData = $('#grd_MhAucStn').jqGrid('getRowData', rowid);
        		
        		rowData["mv_cut_am"]              = mv_cut_am;
        		rowData["mv_sqno_prc_dsc"]        = mv_sqno_prc_dsc;
        		rowData["calf_auc_atdr_unt_am"]   = parent.envList[0]["CALF_AUC_ATDR_UNT_AM"];
        		rowData["nbfct_auc_atdr_unt_am"]  = parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"];
        		rowData["ppgcow_auc_atdr_unt_am"] = parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"];
        		rowData["nbfct_auc_upr_dsc"]      = parent.envList[0]["NBFCT_AUC_UPR_DSC"];
        		var selDdlQcn = $('#'+rowid+'_DDL_QCN option:selected').val();
        		if(selDdlQcn)rowData["DDL_QCN"]=value;
        		fn_SearchSogCow1(rowData);
         		fn_SearchSogCow2(rowData);
         		fn_SearchSogCow3(rowData);
         		fn_SearchSogCow5(rowData);
            },
            //onSelectRow: function(rowid, status, e){
            //	$("#grd_MhSogCow1").jqGrid("clearGridData", true);
            //	$("#grd_MhSogCow2").jqGrid("clearGridData", true);
            //	$("#grd_MhSogCow3").jqGrid("clearGridData", true);
            //	$("#grd_MhSogCow4").jqGrid("clearGridData", true);
            //	$("#grd_MhSogCow5").jqGrid("clearGridData", true);
            //	
            //	rowData = new Object;
        	//	rowData = $('#grd_MhAucStn').jqGrid('getRowData', rowid);
        	//	
        	//	rowData["mv_cut_am"]              = mv_cut_am;
        	//	rowData["mv_sqno_prc_dsc"]        = mv_sqno_prc_dsc;
        	//	rowData["calf_auc_atdr_unt_am"]   = parent.envList[0]["CALF_AUC_ATDR_UNT_AM"];
        	//	rowData["nbfct_auc_atdr_unt_am"]  = parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"];
        	//	rowData["ppgcow_auc_atdr_unt_am"] = parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"];
        	//	rowData["nbfct_auc_upr_dsc"]      = parent.envList[0]["NBFCT_AUC_UPR_DSC"];
        	//	
        	//	fn_SearchSogCow1(rowData);
         	//	fn_SearchSogCow2(rowData);
         	//	fn_SearchSogCow3(rowData);
         	//	fn_SearchSogCow5(rowData);
         	//	
            //},
            gridComplete: function(rowid, status, e){
            	
            	var getData = $("#grd_MhAucStn").jqGrid('getRowData');
            	
            	if(getData.length > 0) {
            		$("#grd_MhSogCow1").jqGrid("clearGridData", true);
                	$("#grd_MhSogCow2").jqGrid("clearGridData", true);
                	$("#grd_MhSogCow3").jqGrid("clearGridData", true);
                	$("#grd_MhSogCow4").jqGrid("clearGridData", true);
                	$("#grd_MhSogCow5").jqGrid("clearGridData", true);
                	
                	rowData = new Object;
            		rowData = $('#grd_MhAucStn').jqGrid('getRowData', 1);
            		
            		rowData["mv_cut_am"]              = mv_cut_am;
            		rowData["mv_sqno_prc_dsc"]        = mv_sqno_prc_dsc;
            		rowData["calf_auc_atdr_unt_am"]   = parent.envList[0]["CALF_AUC_ATDR_UNT_AM"];
            		rowData["nbfct_auc_atdr_unt_am"]  = parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"];
            		rowData["ppgcow_auc_atdr_unt_am"] = parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"];
            		rowData["nbfct_auc_upr_dsc"]      = parent.envList[0]["NBFCT_AUC_UPR_DSC"];
            		
            		fn_SearchSogCow1(rowData);
             		fn_SearchSogCow2(rowData);
             		fn_SearchSogCow3(rowData);
             		fn_SearchSogCow5(rowData);
            	}
            	
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        $("#grd_MhAucStn").jqGrid("setLabel", "rn","No");
        
        if(App_userId != "admin") {
        	$("#grd_MhAucStn").jqGrid("hideCol","CHG_DDL_QCN");
        }
    }
    
    
  	//그리드 생성
    function fn_CreateGridSogCow1(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        /*                                1        2       3         4         5      6      7      8      9           10        11     12         13        14             15       16       17  */
        var searchResultColNames = ["경매번호", "경매대상", "출하자", "귀표번호", "생년월일", "성별", "KPN", "중량", "예정가", "응찰금액", "예정가 차이금액", "낙찰자", "참가번호", "계대", "산차", "어미소귀표번호", "어미구분"];        
        var searchResultColModel = [						 
						        	{name:"AUC_PRG_SQ",                      index:"AUC_PRG_SQ",                      width:100, align:'center', sorttype: "number"},
						        	{name:"AUC_OBJ_DSC",                     index:"AUC_OBJ_DSC",                     width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
						        	{name:"FTSNM",                           index:"FTSNM",                           width:100, align:'center'},
						        	{name:"SRA_INDV_AMNNO",                  index:"SRA_INDV_AMNNO",                  width:150, align:'center'},
						        	{name:"BIRTH",                           index:"BIRTH",                           width:100, align:'center', formatter:'gridDateFormat'},
						        	{name:"INDV_SEX_C",                      index:"INDV_SEX_C",                      width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						        	{name:"KPN_NO",                          index:"KPN_NO",                          width:100, align:'center'},
						        	{name:"COW_SOG_WT",                      index:"COW_SOG_WT",                      width:100, align:'center'},
						        	{name:"LOWS_SBID_LMT_AM",                index:"LOWS_SBID_LMT_AM",                width:100, align:'right' , sorttype: "number",classes:"fontBold", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"ATDR_AM",                         index:"ATDR_AM",                         width:100, align:'right' , sorttype: "number",classes:"fontBold", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"DIF_AM",							 index:"DIF_AM",						  width:100, align:'right' , sorttype: "number",classes:"fontBold", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"SRA_MWMNNM",                      index:"SRA_MWMNNM",                      width:100, align:'center'},
						        	{name:"LVST_AUC_PTC_MN_NO",				 index:"LVST_AUC_PTC_MN_NO",			  width:100, align:'center', sorttype: "number"},
						        	{name:"SRA_INDV_PASG_QCN",               index:"SRA_INDV_PASG_QCN",               width:100, align:'center'},
						        	{name:"MATIME",                          index:"MATIME",                          width:100, align:'center'},
						        	{name:"MCOW_SRA_INDV_AMNNO",             index:"MCOW_SRA_INDV_AMNNO",             width:150, align:'center'},
						        	{name:"MCOW_DSC",                        index:"MCOW_DSC",                        width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}}
                                    ];
        
        $("#grd_MhSogCow1").jqGrid("GridUnload");
        
        $("#grd_MhSogCow1").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#grd_MhSogCow1").jqGrid("setLabel", "rn","No");
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow1 .jqgfirstrow td:last-child").width($("#grd_MhSogCow1 .jqgfirstrow td:last-child").width() - 17);
    }
  	
    //grd_MhSogCow2 그리드 생성
    function fn_CreateGridSogCow2(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        /*                                1        2       3         4         5      6      7      8      9           10        11     12         13  */
        var searchResultColNames = ["예정가(낙찰단위)","경매번호", "경매대상", "출하자", "귀표번호", "생년월일", "성별", "KPN", "중량", "예정가", "계대", "산차", "어미소귀표번호", "어미구분","H축산낙찰금액","H낙찰자명"];        
        var searchResultColModel = [
						        	{name:"LOWS_SBID_LMT_UPR",               index:"LOWS_SBID_LMT_UPR",               width:100, align:'center', hidden:true},
						        	{name:"AUC_PRG_SQ",                      index:"AUC_PRG_SQ",                      width:100, align:'center', sorttype: "number"},
						        	{name:"AUC_OBJ_DSC",                     index:"AUC_OBJ_DSC",                     width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
						        	{name:"FTSNM",                           index:"FTSNM",                           width:100, align:'center'},
						        	{name:"SRA_INDV_AMNNO",                  index:"SRA_INDV_AMNNO",                  width:100, align:'center'},
						        	{name:"BIRTH",                           index:"BIRTH",                           width:100, align:'center', formatter:'gridDateFormat'},
						        	{name:"INDV_SEX_C",                      index:"INDV_SEX_C",                      width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						        	{name:"KPN_NO",                          index:"KPN_NO",                          width:100, align:'center'},
						        	{name:"COW_SOG_WT",                      index:"COW_SOG_WT",                      width:100, align:'center', sorttype: "number"},
						        	{name:"LOWS_SBID_LMT_AM",                index:"LOWS_SBID_LMT_AM",                width:100, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"SRA_INDV_PASG_QCN",               index:"SRA_INDV_PASG_QCN",               width:100, align:'center'},
						        	{name:"MATIME",                          index:"MATIME",                          width:100, align:'center'},
						        	{name:"MCOW_SRA_INDV_AMNNO",             index:"MCOW_SRA_INDV_AMNNO",             width:150, align:'center'},
						        	{name:"MCOW_DSC",                        index:"MCOW_DSC",                        width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
						        	{name:"SRA_SBID_AM",                     index:"SRA_SBID_AM",                     width:100, align:'right', hidden:true},
						        	{name:"SRA_MWMNNM",                      index:"SRA_MWMNNM",                      width:100, align:'right', hidden:true}
                                    ];
        
        $("#grd_MhSogCow2").jqGrid("GridUnload");
        
        $("#grd_MhSogCow2").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        $("#grd_MhSogCow2").jqGrid("setLabel", "rn","No");
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow2 .jqgfirstrow td:last-child").width($("#grd_MhSogCow2 .jqgfirstrow td:last-child").width() - 17);
    }
  
    //grd_MhSogCow3 그리드 생성
    function fn_CreateGridSogCow3(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
      
        /*                                1        2       3         4         5      6      7      8      9     10         11        12           13        14        15*/
        var searchResultColNames = ["경매번호", "경매대상", "출하자", "귀표번호", "생년월일", "성별", "중량", "최고가입찰금액", "응찰자수", "KPN", "계대", "산차", "예정가", "원표번호", "경매일자"];        
        var searchResultColModel = [						 
						        	{name:"AUC_PRG_SQ",                      index:"AUC_PRG_SQ",                      width:100, align:'center', sorttype: "number"},
						        	{name:"AUC_OBJ_DSC",                     index:"AUC_OBJ_DSC",                     width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
						        	{name:"FTSNM",                           index:"FTSNM",                           width:100, align:'center'},
						        	{name:"SRA_INDV_AMNNO",                  index:"SRA_INDV_AMNNO",                  width:100, align:'center'},
						        	{name:"BIRTH",                           index:"BIRTH",                           width:100, align:'center', formatter:'gridDateFormat'},
						        	{name:"INDV_SEX_C",                      index:"INDV_SEX_C",                      width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						        	{name:"COW_SOG_WT",                      index:"COW_SOG_WT",                      width:100, align:'center', sorttype: "number"},
						        	{name:"LOWS_SBID_LMT_AM",                index:"LOWS_SBID_LMT_AM",                width:100, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"ATDR_CNT",                        index:"ATDR_CNT",                        width:100, align:'center', sorttype: "number"},
						        	{name:"KPN_NO",                          index:"KPN_NO",                          width:100, align:'center'},
						        	{name:"SRA_INDV_PASG_QCN",               index:"SRA_INDV_PASG_QCN",               width:100, align:'center'},
						        	{name:"MATIME",                          index:"MATIME",                          width:100, align:'center'},
						        	{name:"OSLP_NO",     					 index:"OSLP_NO",      					  width:100, align:'center', hidden:true},
						        	{name:"ATDR_AM",     					 index:"ATDR_AM",      					  width:100, align:'center', hidden:true},
						        	{name:"AUC_DT",     					 index:"AUC_DT",      					  width:100, align:'center', hidden:true}
                                    ];
        
        $("#grd_MhSogCow3").jqGrid("GridUnload");
        
        $("#grd_MhSogCow3").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            onSelectRow: function(rowid, status, e){
            	$("#grd_MhSogCow4").jqGrid("clearGridData", true);
            	rowData = new Object;
        		rowData = $('#grd_MhSogCow3').jqGrid('getRowData', rowid);
        		rowData["mv_cut_am"]       = mv_cut_am;
        		rowData["mv_sqno_prc_dsc"] = mv_sqno_prc_dsc;
        		fn_SearchSogCow4(rowData);
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        $("#grd_MhSogCow3").jqGrid("setLabel", "rn","No");
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow3 .jqgfirstrow td:last-child").width($("#grd_MhSogCow3 .jqgfirstrow td:last-child").width() - 17);
    }
  
    //grd_MhSogCow4 그리드 생성
    function fn_CreateGridSogCow4(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        /*
        
        */
        /*                              1        2         3        4         5  */
        var searchResultColNames = ["응찰자", "응찰자명", "참가번호", "응찰가", "응찰시간"];        
        var searchResultColModel = [						 
						        	{name:"TRMN_AMNNO",               index:"TRMN_AMNNO",               width:100, align:'center'},
						        	{name:"SRA_MWMNNM",               index:"SRA_MWMNNM",               width:100, align:'center'},
						        	{name:"LVST_AUC_PTC_MN_NO",       index:"LVST_AUC_PTC_MN_NO",       width:100, align:'center', sorttype: "number"},
						        	{name:"ATDR_AM",                  index:"ATDR_AM",                  width:100, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"ATDR_DTM",                 index:"ATDR_DTM",                 width:100, align:'center'}
                                    ];
        
        $("#grd_MhSogCow4").jqGrid("GridUnload");
        
        $("#grd_MhSogCow4").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        $("#grd_MhSogCow4").jqGrid("setLabel", "rn","No");
        
    }
    
    //grd_MhSogCow5 그리드 생성
    function fn_CreateGridSogCow5(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        /*
        
        */
        /*                                1        2       3         4         5      6      7      8      9           10        11     12         13        14        15             16      17        18  */
        var searchResultColNames = ["경매번호", "경매대상", "출하자", "귀표번호", "생년월일", "성별", "KPN", "중량", "예정가", "응찰금액", "낙찰금액", "예정가 차이금액", "낙찰자", "참가번호", "계대", "산차", "어미소귀표번호", "어미구분"];        
        var searchResultColModel = [						 
						        	{name:"AUC_PRG_SQ",                      index:"AUC_PRG_SQ",                      width:100, align:'center', sorttype: "number"},
						        	{name:"AUC_OBJ_DSC",                     index:"AUC_OBJ_DSC",                     width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
						        	{name:"FTSNM",                           index:"FTSNM",                           width:100, align:'center'},
						        	{name:"SRA_INDV_AMNNO",                  index:"SRA_INDV_AMNNO",                  width:150, align:'center'},
						        	{name:"BIRTH",                           index:"BIRTH",                           width:100, align:'center', formatter:'gridDateFormat'},
						        	{name:"INDV_SEX_C",                      index:"INDV_SEX_C",                      width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						        	{name:"KPN_NO",                          index:"KPN_NO",                          width:100, align:'center'},
						        	{name:"COW_SOG_WT",                      index:"COW_SOG_WT",                      width:100, align:'center', sorttype: "number"},
						        	{name:"LOWS_SBID_LMT_AM",                index:"LOWS_SBID_LMT_AM",                width:100, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"ATDR_AM",                         index:"ATDR_AM",                         width:100, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"SRA_SBID_AM",                     index:"SRA_SBID_AM",                     width:100, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"DIF_AM",							 index:"DIF_AM",						  width:100, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
						        	{name:"SRA_MWMNNM",                      index:"SRA_MWMNNM",                      width:100, align:'center'},
						        	{name:"LVST_AUC_PTC_MN_NO",				 index:"LVST_AUC_PTC_MN_NO",			  width:100, align:'center', sorttype: "number"},
						        	{name:"SRA_INDV_PASG_QCN",               index:"SRA_INDV_PASG_QCN",               width:100, align:'center'},
						        	{name:"MATIME",                          index:"MATIME",                          width:100, align:'center'},
						        	{name:"MCOW_SRA_INDV_AMNNO",             index:"MCOW_SRA_INDV_AMNNO",             width:150, align:'center'},
						        	{name:"MCOW_DSC",                        index:"MCOW_DSC",                        width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}}
                                    ];
        
        $("#grd_MhSogCow5").jqGrid("GridUnload");
        
        $("#grd_MhSogCow5").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        $("#grd_MhSogCow5").jqGrid("setLabel", "rn","No");
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow5 .jqgfirstrow td:last-child").width($("#grd_MhSogCow5 .jqgfirstrow td:last-child").width() - 17);
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 낙찰대상 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchSogCow1(p_param){
    	$("#grd_MhSogCow1").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0314_selSogCow1List", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS) {      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridSogCow1(result);
        }
    }
	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 유찰대상 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchSogCow2(p_param){
    	console.log(p_param);
    	$("#grd_MhSogCow2").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0314_selSogCow2List", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS) {      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridSogCow2(result);
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 동가대상1 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchSogCow3(p_param){
    	 console.log(p_param);
    	$("#grd_MhSogCow3").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0314_selSogCow3List", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS) {      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridSogCow3(result);
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 동가대상2 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchSogCow4(p_param){
    	 console.log(p_param);
    	$("#grd_MhSogCow4").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0314_selSogCow4List", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS) {      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridSogCow4(result);
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 낙찰자목록 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchSogCow5(p_param){
    	 console.log(p_param);
    	$("#grd_MhSogCow5").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0314_selSogCow5List", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS){
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridSogCow5(result);
        }
    }
    
    //**************************************
 	//function  : fn_GridChangeQcn(그리드 차수 변경 버튼) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_GridChangeQcn(val, options, rowdata) {
 		var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    
	    return '<button class="tb_btn" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_updDdlQcn(\'' + rowid + '\',\'' + colkey + '\'); return false;">차수변경</button>';
	}
    
  	//**************************************
 	//function  : fn_updDdlQcn(그리드 차수 변경 버튼) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_updDdlQcn(rowid, colkey) {
        MessagePopup('YESNO',"차수를 변경하시겠습니까?",function(res){
			if(res){
				var result        = null;
		    	var tmpObject = $('#grd_MhAucStn').jqGrid('getRowData', rowid);
                var insDataObj = new Object();
                
                insDataObj['frm']  = setFrmToData('frm_Search'); 
                insDataObj['list'] = tmpObject;
		    	
				var result = sendAjax(insDataObj, "/LALM0314_updDdlQcn", "POST");
	            if(result.status == RETURN_SUCCESS){
	            	MessagePopup("OK", "변경되었습니다.");
	                fn_Search();
	            } else {
	            	showErrorMessage(result);
	                return;
	            }
    		} else {    			
    			MessagePopup('OK','취소되었습니다.');
    			return;
    		}
		});		
	}
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
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
                	<form id="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상<strong class="req_dot">*</strong></th>
                                <td>
                                    <select class="popup" id="auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_dt" maxlength="10"></div>                                        
                                    </div>
                                     <input type="hidden" id="simp_cnm"> 
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
            
            <div class="listTable rsp_v">
                <table id="grd_MhAucStn" style="width:100%;">
                
                </table>
            </div>
            
            <div class="tab_box clearfix line">
				<ul class="tab_list fl_L">
					<li><a href="#tab1" id="pb_tab1">낙찰자목록</a></li>
					<li><a href="#tab2" id="pb_tab2" class="on">낙찰대상</a></li>
					<li><a href="#tab3" id="pb_tab3">유찰대상</a></li>
					<li><a href="#tab4" id="pb_tab4">동가대상</a></li>
				</ul>
			</div>
			<div id="tab1" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow5" style="width:100%;">
	                </table>
                </div>
			</div>
			<div id="tab2" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow1" style="width:100%;">
	                </table>
                </div>
			</div>
			<div id="tab3" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow2" style="width:100%;">
	               
	                </table>
                </div>
			</div>
			<div id="tab4" class="tab_content">
				<ul class="clearfix">
	                <li class="fl_L allow_R m_full" style="width:50%;"><!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
	                    <div class="listTable rsp_v">
							<table id="grd_MhSogCow3" style="width:100%;">
			                </table>
		                </div>
	               </li>
               
					<li class="fl_R m_full" style="width: 48%">
						<div class="listTable rsp_v">
							<table id="grd_MhSogCow4" style="width:100%;">
			                </table>
		                </div>
	                </li>
                </ul>
			</div>
            
        </section>       
    </div>
</body>
</html>