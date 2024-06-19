<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

<%@ include file="../../../common/serviceCall.jsp"%>
<%@ include file="../../../common/head.jsp"%>



</head>
<script type="text/javascript">
var pageInfos = setDecryptData('${pageInfo}');
var na_bzplc = App_na_bzplc;
   /*------------------------------------------------------------------------------
    * 1. 단위업무명   : 가축시장
    * 2. 파  일  명   : LALM1010
    * 3. 파일명(한글) : 출장염소내역 출력
    *----------------------------------------------------------------------------* 
    *  작성일자      작성자     내용
    *----------------------------------------------------------------------------*
    * 2024.06.13   임다영   최초작성
    ------------------------------------------------------------------------------*/
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     $(document).ready(function(){
    	//그리드 초기화
        fn_CreateGrid();
        // fn_CreateGrid_2();
        fn_CreateGrid_3();
        fn_CreateGrid_4();
         
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
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 8, true);
        fn_setCustomCodeBox("indv_sex_c", ETC_INDV_SEX_C, "전체");
        fn_setCodeBox("sel_sts_dsc", "SEL_STS_DSC", 1, true,"전체");
        fn_setCodeBox("st_auc_no", "ST_AUC_NO", 1, true); 
        fn_setCodeBox("ed_auc_no", "ED_AUC_NO", 1, true); 
        fn_setCodeBox("ftsnm", "FTSNM", 1, true); 
        fn_setCodeBox("dongup", "DONGUP", 1, true);
        
 		fn_Init();
 		
 		
 		/******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MhSogCow1, #grd_MhSogCow2, #grd_MhSogCow3, #grd_MhSogCow4");
        
        $("#st_auc_no").on('keyup',function(e){
        	if(e.keyCode == 13){
        		$('#ed_auc_no').focus();
        	}
        });
 		
 		$("#tab_1").click(function(){
            $(".ftsnm_td").show();             
            $(".dong_td").hide();
            $(".bothPrint_td").hide();
            $(".sordOrder_td").show();
            $("#holder").hide();
          
        });
        
        
        $("#tab_2").click(function(){
            $(".ftsnm_td").hide();          
            $(".dong_td").show();
            $(".bothPrint_td").hide();
            $(".sordOrder_td").hide();
            $("#holder").hide();
         
        });
        
        $("#tab_3").click(function(){
            $(".ftsnm_td").hide();          
            $(".dong_td").hide();
            $("#holder").hide();
           
        });
        
        $("#tab_4").click(function(){
            $(".ftsnm_td").hide();          
            $(".dong_td").hide();
            $(".no_goat").hide();
            $("#holder").show();
            $( "#prto_tpc_2" ).attr('checked','checked');
        });
        
        $("#tab_1").trigger('click');

 	});

  
     
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        $("#grd_MhSogCow1").jqGrid("clearGridData", true);
        $("#grd_MhSogCow3").jqGrid("clearGridData", true);
        $("#grd_MhSogCow2").jqGrid("clearGridData", true);
        $("#grd_MhSogCow4").jqGrid("clearGridData", true);
        

        fn_InitFrm('frm_Search');         
        //폼 초기화               
        $( "#auc_dt" ).datepicker().datepicker("setDate", fn_getToday());
        $( "#prto_tpc_1" ).attr('checked','checked');
       
    }
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search() {     
    	
 		if(fn_isNull($( "#auc_dt" ).val())){
 			MessagePopup('OK','경매시작일자를 선택하세요.',function(){
 				$( "#auc_st_dt" ).focus();
 			});
 			return;
 		}      
 		if(!fn_isDate($( "#auc_dt" ).val())){
 			MessagePopup('OK','경매시작일자가 날짜형식에 맞지 않습니다.',function(){
 				$( "#auc_dt" ).focus();
 			});
 			return;
 		}
 		 
     	if(fn_isNull($( "#auc_obj_dsc" ).val())) {
         	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
         		$( "#auc_obj_dsc" ).focus();
         	});
            return;
     	}

        
        var results_6 = null; 
   	    results_6 = sendAjaxFrm("frm_Search", "/Common_selAucQcn", "POST");
   	  
        if(results_6.status != RETURN_SUCCESS){
            showErrorMessage(results_6);
            return;
        }else{     
            result_6 = setDecrypt(results_6);
           	$("#qcn").val(result_6[0].QCN)	
        }	
     	
        	
        	
     	if($("#tab_1").hasClass("on")){
     		var results = sendAjaxFrm("frm_Search", "/LALM1010_selList", "POST");
            
            var result;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            }else{
                result = setDecrypt(results);
            }  
            result = fn_CreateGrid(result);
     	}else if($("#tab_2").hasClass("on")){
     		var results = sendAjaxFrm("frm_Search", "/LALM1010_selList_2", "POST"); 
            
            var result;
            
            if(results.status != RETURN_SUCCESS){
            	showErrorMessage(results);
            	return;
            }else{
            	result = setDecrypt(results);
            }        
            fn_CreateGrid_2(result);
        }else if($("#tab_3").hasClass("on")){
        	var results = sendAjaxFrm("frm_Search", "/LALM1010_selList_3", "POST"); 
            
            var result;
            
            if(results.status != RETURN_SUCCESS){
            	showErrorMessage(results);
            	return;
            }else{
            	result = setDecrypt(results);
            }
          
            fn_CreateGrid_3(result);
            	
     	}else if($("#tab_4").hasClass("on")){
     		var results = sendAjaxFrm("frm_Search", "/LALM1010_selList_4", "POST"); 
            
            var result;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            }else{
                result = setDecrypt(results);
            }
            
            fn_CreateGrid_4(result);
     		
     	}else {
     		MessagePopup('OK','텝을 선택하세요.');
     		return;
     	}       
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
    	
    	if($("#tab_1").hasClass("on")) {
    		fn_ExcelDownlad('grd_MhSogCow1', '경매전(응찰자용)');
       		
        } else if($("#tab_2").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow3', '경매전(게시판용)');
        	
        } else if($("#tab_3").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow2', '경매후(관리자용)');
        	
        } else if($("#tab_4").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow4', '경매전(거치대용)');
        }
    	
    }
    /*------------------------
	  obj_dsc [ ],숫자 제거  
	-------------------------*/
	function fn_deleteNumber(dsc){
		var obj_dsc = dsc.substr(4,3);
		

		return  obj_dsc; 

	}

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 인쇄 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	 
    	 var results = sendAjaxFrm("frm_Search", "/Common_selAucQcn", "POST");
    	 var result = null;
    	 var aucQcn = "";
    	 
         if(results.status == RETURN_SUCCESS) {
         	result = setDecrypt(results);
         	aucQcn = result[0]["QCN"];
         	
         }
         
    	 var TitleData = new Object();
    	 var tmp_title = "";
    	 var tmp_condition = '[경매일자 : ' + $('#auc_dt').val() + ']'
						+  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
			    	 
    	 if(fn_isNull($("#st_auc_no").val())) {
    		 tmp_condition = tmp_condition + '/ [경매번호 : 0 ~ ';
    	 } else {
    		 tmp_condition = tmp_condition + '/ [경매번호 : ' + $("#st_auc_no").val()  + ' ~ ';
    	 }
    	 
    	 if(fn_isNull($("#ed_auc_no").val())) {
    		 tmp_condition = tmp_condition + '0 ]';
    	 } else {
    		 tmp_condition = tmp_condition + $("#ed_auc_no").val()  + ']';
    	 }
    	 
    	 tmp_condition = tmp_condition + '/ [성별 : ' + $( "#indv_sex_c option:selected").text()  + ']';
    	 tmp_condition = tmp_condition + '/ [진행상태 : ' + $( "#sel_sts_dsc option:selected").text()  + ']';
    	 
    	 /* 1번 (경매전 응찰자용) */
         if($("#tab_1").hasClass("on")) {
        	 tmp_title = "염소경매(응찰자용)" + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR");
        	 
        	 TitleData.title = tmp_title;
        	 TitleData.sub_title = "";
             TitleData.unit = "";
             TitleData.srch_condition =  tmp_condition;
             
             ReportPopup('LALM1010G0',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그

		 /* 경매전(게시판용) */
		 /*
         } else if($("#tab_2").hasClass("on")) {
        	 if(parent.envList[0] == null) {
     			MessagePopup("OK", "응찰단위금액이 입력되지 않았습니다.",function(res){
     				fn_OpenMenu('LALM0912','');
     				return;
     			});
     			return;
     		 }

        	 tmp_title = fn_deleteNumber($( "#auc_obj_dsc option:selected").text()) + " 출품내역 제" +  $("#qcn").val() + "차";

        	 TitleData.title = tmp_title;
        	 TitleData.sub_title = "(" + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR") + ")";
             TitleData.srch_condition = tmp_condition;
        	 
    		 if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "1000") {
    			 TitleData.unit = "천원";
    			 TitleData.am = "1000";
    		 } else if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "10000") {
    			 TitleData.unit = "만원";
    			 TitleData.am = "10000";
    		 } else {
    			 TitleData.unit = "원";
    			 TitleData.am = "1";
    		 }

    		 TitleData.am_dsc = parent.envList[0]["NBFCT_AUC_ATDR_UNT_AMC"];

			 ReportPopup('LALM1010G1',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그        	 
			
		 */
         /* 경매후(관리자용) */
         } else if($("#tab_3").hasClass("on")) {
        	 tmp_title = "염소경매(관리자용)" + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR");
        	 
        	 TitleData.title = tmp_title;
        	 TitleData.sub_title = "";
             TitleData.unit = "";
             TitleData.srch_condition = tmp_condition;

             ReportPopup('LALM1010G2',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그

         // 경매전(거치대용)
         } else if($("#tab_4").hasClass("on")) {
        	 TitleData.title = "";
        	 TitleData.sub_title = "";
             TitleData.srch_condition = tmp_condition;

    		 if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "1000") {
    			 TitleData.unit = "천원";
    			 TitleData.am = "1000";
    		 } else if(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"] == "10000") {
    			 TitleData.unit = "만원";
    			 TitleData.am = "10000";
    		 } else {
    			 TitleData.unit = "원";
    			 TitleData.am = "1";
    		 }
    		 TitleData.am_dsc = parent.envList[0]["NBFCT_AUC_ATDR_UNT_AMC"];

             var grid4 = fnSetGridData('grd_MhSogCow4');        	
             
        	 if($("#prto_tpc_1").is(":checked")) {
        	 	ReportPopup('LALM1010G4_V1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
        	 } else if($("#prto_tpc_2").is(":checked")) {
        		ReportPopup('LALM1010G4_V2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
         	 }
         }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    function fn_CreateGrid(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        
        
        var searchResultColNames = ["H낙찰자","H인공수정표","H부KPN","H임신일수","H큰소구분","H수송자","H동이상주소","H낙찰가","H수송자","H낙찰자","H낙찰번호","H귀표번호","H월령일수","H읍면"
        						  ,"경매<br>번호", "경매대상"
        						  , "H귀표번호", "H생년월일" , "H월령"
        						  , "성별"
        						  , "H계대", "H등록번호", "H등록구분", "H제각여부", "HKPN번호", "H어미귀표번호","H산차"
        						  ,"중량","주소","성명","휴대폰","예정가","브루셀라<br>검사일자","예방접종일자"
        						  ,"H우결핵<br>검사일자","H임신감정<br>여부","H임신여부","H인공수정일자","H임신<br>개월수","H수정KPN","H(송)귀표번호","H(송)생년월일","H(송)성별","H(송)월령"
                                  ,"비고"
                                  ,"H친자검사여부","H송아지구분","H친자검사결과","H어미등록구분"
                                  , "", "", ""
                                  ];        
        var searchResultColModel = [
        	                         {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:55, align:'center'   ,hidden:true},
        	                         {name:"AFISM_MOD_CTFW_SMT_YN",     index:"AFISM_MOD_CTFW_SMT_YN",    width:55, align:'center'   ,hidden:true},
        	                         {name:"CALF_KPN_NO",               index:"CALF_KPN_NO",              width:55, align:'center'   ,hidden:true},
        	                         {name:"AFISM_MOD",                 index:"AFISM_MOD",                width:55, align:'center'   ,hidden:true},
        	                         {name:"PPGCOW_FEE_DSC",            index:"PPGCOW_FEE_DSC",           width:55, align:'center'   ,hidden:true},
        	                         {name:"TRPCS_PY_YN",               index:"TRPCS_PY_YN",              width:55, align:'center'   ,hidden:true},
        	                         {name:"DONGUP",                    index:"DONGUP",                   width:55, align:'center'   ,hidden:true},
        	                         {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:55, align:'center'   ,hidden:true},
        	                         {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:55, align:'center'   ,hidden:true},
        	                         {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:55, align:'center'   ,hidden:true},
        	                         {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:55, align:'center'   ,hidden:true}, 
        	                         {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:55, align:'center'   ,hidden:true}, 
        	                         {name:"MTCN_DAYS",      	        index:"MTCN_DAYS",           	  width:55, align:'center'   ,hidden:true},
        	                         {name:"DONGUP_EUP",      	        index:"DONGUP_EUP",           	  width:55, align:'center'   ,hidden:true},
                                    
        	                         {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:55, align:'center', sorttype: "number"  },
                                     {name:"AUC_OBJ_DSC",               index:"AUC_OBJ_DSC",              width:65, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"SRA_INDV_AMNNO12",          index:"SRA_INDV_AMNNO12",         width:120, align:'center' ,hidden:true},
                                     {name:"BIRTH",                     index:"BIRTH",                    width:70, align:'center'  ,hidden:true},
                                     {name:"MTCN",                      index:"MTCN",                     width:40, align:'center', sorttype: "number", formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','},hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:55, align:'center'   ,edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:40, align:'center', sorttype: "number",hidden:true},
                                     {name:"SRA_INDV_BRDSRA_RG_NO",     index:"SRA_INDV_BRDSRA_RG_NO",    width:70, align:'center', sorttype: "number",hidden:true},
                                     {name:"RG_DSC",                    index:"RG_DSC",                   width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)},hidden:true},
                                     {name:"RMHN_YN",                   index:"RMHN_YN",                  width:60, align:'center'    , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:60, align:'center'  ,hidden:true},
                                     {name:"MCOW_SRA_INDV_AMNNO",       index:"MCOW_SRA_INDV_AMNNO",      width:140, align:'center' ,hidden:true},
                                     {name:"MATIME",                    index:"MATIME",                   width:35, align:'center'  ,hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:70, align:'right', sorttype: "number", formatter:'interger', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"DONG",                      index:"DONG",                     width:200, align:'left'   },
                                     {name:"FTSNM",                     index:"FTSNM",                    width:60, align:'center'  },
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:75, align:'center'  },
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:85, align:'right'    , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"BRCL_ISP_DT",               index:"BRCL_ISP_DT",              width:85, align:'center'  }, 
                                     {name:"VACN_DT",                   index:"VACN_DT",                  width:85, align:'center'  }, 
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"BOVINE_DT",                 index:"BOVINE_DT",                width:80, align:'center'  ,hidden:true}, 
                                     {name:"PRNY_JUG_YN",               index:"PRNY_JUG_YN",              width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"PRNY_YN",                   index:"PRNY_YN",                  width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"AFISM_MOD_DT",              index:"AFISM_MOD_DT",             width:60, align:'center'   ,hidden:true},
                                     {name:"PRNY_MTCN",                 index:"PRNY_MTCN",                width:60, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','},hidden:true},
                                     {name:"MOD_KPN_NO",                index:"MOD_KPN_NO",               width:60, align:'center'  ,hidden:true},
                                     {name:"CALF_SRA_INDV_AMNNO",       index:"CALF_SRA_INDV_AMNNO",      width:120, align:'center'  ,formatter:'gridIndvFormat',hidden:true}, 
                                     {name:"CALF_BIRTH",                index:"CALF_BIRTH",               width:100, align:'center'  ,hidden:true},
                                     {name:"CALF_INDV_SEX_C",           index:"CALF_INDV_SEX_C",          width:80, align:'center'   ,edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)},hidden:true},
                                     {name:"CALF_MTCN",                 index:"CALF_MTCN",                width:80, align:'center', sorttype: "number",align:'right', formatter:function(cellValue , options, rowData){ if(rowData.CALF_MTCN != null){ return rowData.CALF_MTCN;}} ,hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     
                                     {name:"RMK_CNTN",                  index:"RMK_CNTN",                 width:190, align:'left'   }, 
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"DNA_YN_CHK",                index:"DNA_YN_CHK",               width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"CASE_COW",                  index:"CASE_COW",                 width:100, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)},hidden:true},
                                     {name:"DNA_YN",                    index:"DNA_YN",                   width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA},hidden:true},
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:80, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)},hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     
                                     {name:"TEMP1",                  index:"TEMP1",                 width:40, align:'center'   }, 
                                     {name:"TEMP2",                  index:"TEMP2",                 width:40, align:'center'   }, 
                                     {name:"TEMP3",                  index:"TEMP3",                 width:40, align:'center'   }, 
                                     ];
            
        $("#grd_MhSogCow1").jqGrid("GridUnload");
                
        $("#grd_MhSogCow1").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 40,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
            onSelectRow:function(rowid,status, e){
            },
        });
		
      //행번호
        $("#grd_MhSogCow1").jqGrid("setLabel", "rn","No"); 
        
      //합계행에 가로스크롤이 있을경우 추가
      	var $obj = document.getElementById('grd_MhSogCow1');
        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

        $bDiv.css({'overflow-x':'hidden'});
        $sDiv.css({'overflow-x':'scroll'});
        $sDiv.scroll(function(){
            $bDiv.scrollLeft($sDiv.scrollLeft());
        });
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow1 .jqgfirstrow td:last-child").width($("#grd_MhSogCow1 .jqgfirstrow td:last-child").width() - 17);     
        
      
        //footer        
        var gridDatatemp = $('#grd_MhSogCow1').getRowData();
        
        //합 
        var tot_sra_indv_amnno	         = parseInt(0);
        var tot_lows_sbid_lmt_am         = parseInt(0); 
        var tot_cow_sog_wt               = parseInt(0); 
        var am_sra_indv_amnno            = parseInt(0); 
        var su_sra_indv_amnno            = parseInt(0);      
        var gu_sra_indv_amnno            = parseInt(0);      
        var sa_sra_indv_amnno            = parseInt(0);      
        
        $.each(gridDatatemp,function(i){
        	//총두수        	
        	if(gridDatatemp[i].SRA_INDV_AMNNO != 0){
        		tot_sra_indv_amnno++;
        	}
        	//예정가등록두수        	
        	if(gridDatatemp[i].LOWS_SBID_LMT_AM != 0){
        		tot_lows_sbid_lmt_am++;
        	} 
        	//중량등록두수        	
        	if(gridDatatemp[i].COW_SOG_WT != 0){
        		tot_cow_sog_wt++;
        	}
        	// 두수, 수두수
        	if(gridDatatemp[i].INDV_SEX_C  == '1' || gridDatatemp[i].INDV_SEX_C  == '4' || gridDatatemp[i].INDV_SEX_C  == '6'){
        		am_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '2') {
            	su_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '3') {
            	gu_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '7') {
            	sa_sra_indv_amnno++;
            }else {
            	su_sra_indv_amnno++;
            }
        
        }); 
        
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                       ["AUC_PRG_SQ"           ,"총두수" ,1 ,"String" ]
                      ,["AUC_OBJ_DSC"	   ,tot_sra_indv_amnno	  ,1 ,"Integer"] 
                      ,["INDV_SEX_C"                ,"예정가등록두수"          ,1 ,"String"] 
                      ,["COW_SOG_WT"           ,tot_lows_sbid_lmt_am  ,1 ,"Integer"] 
                      ,["DONG"    ,"중량등록두수"            ,1 ,"String"] 
                      ,["FTSNM"              ,tot_cow_sog_wt         ,1 ,"Integer"] 
                      ,["CUS_MPNO"               ,"암두수"                 ,1 ,"String"] 
                      ,["LOWS_SBID_LMT_AM"               ,am_sra_indv_amnno      ,1 ,"Integer"] 
                      ,["BRCL_ISP_DT"           ,"수두수"                 ,1 ,"String"] 
                      ,["VACN_DT"                ,su_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["RMK_CNTN"           ,"거세두수"                 ,1 ,"String"] 
                      ,["TEMP1"                ,gu_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["TEMP2"           ,"새끼두수"                 ,1 ,"String"] 
                      ,["TEMP3"                ,sa_sra_indv_amnno       ,1 ,"Integer"] 
		           ] 
         ];
  
         fn_setGridFooter('grd_MhSogCow1', arr);  
        
    } 
     
    // 두번째 그리드 생성
    /*
    function fn_CreateGrid_2(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["비고","임신개월수","수정kpn번호","운송비지급여부","큰소구분","축산낙찰금액","참가번호","낙찰자명","운송기사명","예정가","예정가 단위 ","동이상주소"
        						  ,"경매<br>번호", "경매대상", "주소", "성명"
                                  , "전화번호", "귀표번호", "생년월일", "산차", "어미구분", "계대"
                                  , "제각여부", "KPN번호","성별","중량","예정가","월령","친자검사여부"
                                  ,"친자검사결과","송아지구분","난소적출여부","송아지축산개체관리번호","송아지개체성별코드","송아지출하중량","송아지생년월일","등록구분코드"];        
        var searchResultColModel = [
        							  
                                     {name:"RMK_CNTN",                  index:"RMK_CNTN",                 width:55, align:'center'  ,hidden:true},
                                     {name:"PRNY_MTCN",                 index:"PRNY_MTCN",                width:55, align:'center'  ,hidden:true},
                                     {name:"MOD_KPN_NO",                index:"MOD_KPN_NO",               width:55, align:'center'  ,hidden:true},
                                     {name:"TRPCS_PY_YN",               index:"TRPCS_PY_YN",              width:55, align:'center'  ,hidden:true},
                                     {name:"PPGCOW_FEE_DSC",            index:"PPGCOW_FEE_DSC",           width:55, align:'center'  ,hidden:true},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:55, align:'center'  ,hidden:true},
                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:55, align:'center'  ,hidden:true},
                                     {name:"SRA_MWMNNM",       	        index:"SRA_MWMNNM",               width:55, align:'center'  ,hidden:true},
                                     {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:55, align:'center'  ,hidden:true},
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:55, align:'center'  ,hidden:true},
                                     {name:"LOWS_SBID_LMT_UNIT",        index:"LOWS_SBID_LMT_UNIT",       width:55, align:'center'  ,hidden:true},
                                     {name:"DONGUP",        			index:"DONGUP",         		  width:55, align:'center'  ,hidden:true},
                                     
                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:50, align:'center' },
                                     {name:"AUC_OBJ_DSC",               index:"AUC_OBJ_DSC",              width:40, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"DONG",                      index:"DONG",                     width:300, align:'left'},
                                     {name:"FTSNM",                     index:"FTSNM",                    width:55, align:'center' },
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:90, align:'center' },
                                     {name:"SRA_INDV_AMNNO12",          index:"SRA_INDV_AMNNO12",         width:180, align:'center'},
                                     {name:"BIRTH",                     index:"BIRTH",                    width:70, align:'center'  },
                                     {name:"MATIME",                    index:"MATIME",                   width:40, align:'right'  },
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:75, align:'center' , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:40, align:'right'   },
                                     {name:"RMHN_YN",                   index:"RMHN_YN",                  width:40, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:70, align:'center' },
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:60, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:70,  align:'right' , formatter:'interger', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"LOWS_SBID_LMT_UPR",         index:"LOWS_SBID_LMT_UPR",        width:85,align:'right'  ,  formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"MTCN",                      index:"MTCN",                     width:40, align:'right'   , formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"DNA_YN_CHK",                index:"DNA_YN_CHK",               width:80, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}}, 
                                     {name:"DNA_YN",                    index:"DNA_YN",                   width:60, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA}},
                                     {name:"CASE_COW",                  index:"CASE_COW",                 width:100, align:'center' , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)}}, 
                                     {name:"SPAY_YN",                   index:"SPAY_YN",                  width:90, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"CALF_SRA_INDV_AMNNO",       index:"CALF_SRA_INDV_AMNNO",      width:90, align:'center'  ,hidden:true},
                                     {name:"CALF_INDV_SEX_C",           index:"CALF_INDV_SEX_C",          width:90, align:'center'  ,hidden:true},
                                     {name:"CALF_COW_SOG_WT",           index:"CALF_COW_SOG_WT",          width:90, align:'center'  ,hidden:true},
                                     {name:"CALF_BIRTH",                index:"CALF_BIRTH",               width:90, align:'center'  ,hidden:true},
                                     {name:"RG_DSC",                    index:"RG_DSC",                   width:60,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}}
                                     ];
            
        
        
        $("#grd_MhSogCow3").jqGrid("GridUnload");
                
        $("#grd_MhSogCow3").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 40,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
            onSelectRow:function(rowid,status, e){
            	$("#auc_prg_sq");
            },
        });
		
      //행번호
        $("#grd_MhSogCow3").jqGrid("setLabel", "rn","No"); 
        
      //합계행에 가로스크롤이 있을경우 추가
      	var $obj = document.getElementById('grd_MhSogCow3');
        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

        $bDiv.css({'overflow-x':'hidden'});
        $sDiv.css({'overflow-x':'scroll'});
        $sDiv.scroll(function(){
            $bDiv.scrollLeft($sDiv.scrollLeft());
        });
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow3 .jqgfirstrow td:last-child").width($("#grd_MhSogCow3 .jqgfirstrow td:last-child").width() - 17);     
        
      
        //footer        
        var gridDatatemp = $('#grd_MhSogCow3').getRowData();
        
        //합 
        var tot_sra_indv_amnno	   = parseInt(0);
        var tot_lows_sbid_lmt_am   = parseInt(0); 
        var tot_cow_sog_wt         = parseInt(0); 
        var am_sra_indv_amnno      = parseInt(0); 
        var su_sra_indv_amnno      = parseInt(0);      
        
        $.each(gridDatatemp,function(i){
        	//총두수
        	
        	if(gridDatatemp[i].SRA_INDV_AMNNO != 0){
        		tot_sra_indv_amnno++;
        	}
        	//예정가등록두수
        	
        	if(gridDatatemp[i].LOWS_SBID_LMT_AM != 0){
        		tot_lows_sbid_lmt_am++;
        	}
        	//중량등록두수
        	
        	if(gridDatatemp[i].COW_SOG_WT != 0){
        		tot_cow_sog_wt++;
        	}
        	//암두수, 수두수
        	if(gridDatatemp[i].INDV_SEX_C  == '1' || gridDatatemp[i].INDV_SEX_C  == '4' || gridDatatemp[i].INDV_SEX_C  == '6'){
        		am_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '2') {
            	su_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '3') {
            	gu_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '7') {
            	sa_sra_indv_amnno++;
            }else {
            	su_sra_indv_amnno++;
            }    	
        	
        
        }); 
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}

		             ["AUC_PRG_SQ"           ,"총두수"                 ,2 ,"String"]
		  	        ,["DONG"	               ,tot_sra_indv_amnno	   ,1 ,"Integer"] 
		  	        ,["FTSNM"                  ,"예정가등록두수"           ,2 ,"String"] 
		  	        ,["SRA_INDV_AMNNO12"       ,tot_lows_sbid_lmt_am   ,1 ,"Integer"] 
		  	        ,["BIRTH"                  ,"중량등록두수"            ,3 ,"String"] 
		  	        ,["SRA_INDV_PASG_QCN"      ,tot_cow_sog_wt         ,1 ,"Integer"] 
		  	        ,["RMHN_YN"                ,"암두수"                 ,2 ,"String"] 
		  	        ,["INDV_SEX_C"             ,am_sra_indv_amnno      ,1 ,"Integer"] 
		  	        ,["COW_SOG_WT"             ,"수두수"                 ,2 ,"String"] 
		  	        ,["MTCN"                   ,su_sra_indv_amnno      ,1 ,"Integer"] 
		  	        ,["COW_SOG_WT"             ,"거세두수"                 ,2 ,"String"] 
		  	        ,["MTCN"                   ,gu_sra_indv_amnno      ,1 ,"Integer"] 
		  	        ,["COW_SOG_WT"             ,"새끼두수"                 ,2 ,"String"] 
		  	        ,["MTCN"                   ,sa_sra_indv_amnno      ,1 ,"Integer"] 
		  	     ] 
		  	        
         ];
  
         fn_setGridFooter('grd_MhSogCow3', arr);  
		
        
    }
    */
    
   //세번째 그리드 생성
    function fn_CreateGrid_3(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["송아지축산개체관리번호","송아지개체성별코드","송아지출하중량","송아지생년월일","h비고내용","h임신개월수","h수정kpn번호","월령","휴대폰번호","H큰소구분","H수송자","H귀표번호"
        							,"경매<br>번호", "경매대상", "주소", "성명"
                                  , "H귀표번호", "H생년월일", "H산차", "H어미구분", "H계대", "H제각여부", "HKPN번호"
                                  , "성별", "중량", "예정가", "낙찰단가", "낙찰가"
                                  , "H수송자"
                                  ,"낙찰자","낙찰자<br>전화번호","참가<br>번호"
                                  ,"H어미귀표번호","H친자검사여부","H송아지구분","H친자검사결과","H등록구분코드"
                                  ,"",""
                                  ];        
        var searchResultColModel = [
      		
      							  	 {name:"CALF_SRA_INDV_AMNNO",       index:"CALF_SRA_INDV_AMNNO",      width:55,  align:'center'  ,hidden:true},
      							  	 {name:"CALF_INDV_SEX_C",           index:"CALF_INDV_SEX_C",          width:55,  align:'center'  ,hidden:true},
      							  	 {name:"CALF_COW_SOG_WT",           index:"CALF_COW_SOG_WT",          width:55,  align:'center'  ,hidden:true},
      							  	 {name:"CALF_BIRTH",                index:"CALF_BIRTH",               width:55,  align:'center'  ,hidden:true},
      							  	 {name:"RMK_CNTN",                  index:"RMK_CNTN",                 width:55,  align:'center'  ,hidden:true},
      							  	 {name:"PRNY_MTCN",                 index:"PRNY_MTCN",                width:55,  align:'center'  ,hidden:true},
      							  	 {name:"MOD_KPN_NO",                index:"MOD_KPN_NO",               width:55,  align:'center'  ,hidden:true},
      							  	 {name:"MTCN",                      index:"MTCN",                     width:55,  align:'center'  ,hidden:true},
      							  	 {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:55,  align:'center'  ,hidden:true},
        	                         {name:"PPGCOW_FEE_DSC",            index:"PPGCOW_FEE_DSC",           width:55,  align:'center'  ,hidden:true},
        	                         {name:"TRPCS_PY_YN",               index:"TRPCS_PY_YN",              width:55,  align:'center'  ,hidden:true},
        	                         {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:55,  align:'center'  ,hidden:true},
                                     
                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:55,  align:'center' },
                                     {name:"AUC_OBJ_DSC",               index:"AUC_OBJ_DSC",              width:65,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"DONG",                      index:"DONG",                     width:300, align:'left'   },
                                     {name:"FTSNM",                     index:"FTSNM",                    width:60,  align:'center' },
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:120, align:'center' ,hidden:true},
                                     {name:"BIRTH",                     index:"BIRTH",                    width:70,  align:'center'  ,hidden:true},
                                     {name:"MATIME",                    index:"MATIME",                   width:35,  align:'center' ,hidden:true},
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:60,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)},hidden:true},
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:40,  align:'right'  ,hidden:true},
                                     {name:"RMHN_YN",                   index:"RMHN_YN",                  width:60,  align:'right'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:60,  align:'center' ,hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:40,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:70,  align:'right'   , sorttype: "number", formatter:'interger', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:85,  align:'right'   , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:85,  align:'right'   , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:85,  align:'right'   , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:85,  align:'center' ,hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     
                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:80,  align:'center' },
                                     {name:"E_CUS_MPNO",                index:"E_CUS_MPNO",               width:80,  align:'center' },
                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:40,  align:'center' },
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"MCOW_SRA_INDV_AMNNO",       index:"MCOW_SRA_INDV_AMNNO",      width:120, align:'center' ,hidden:true},
                                     {name:"DNA_YN_CHK",                index:"DNA_YN_CHK",               width:80,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true}, 
                                     {name:"CASE_COW",                  index:"CASE_COW",                 width:100, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)},hidden:true}, 
                                     {name:"DNA_YN",                    index:"DNA_YN",                   width:80,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA},hidden:true}, 
                                     {name:"RG_DSC",                    index:"RG_DSC",                   width:60,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)},hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"TEMP1",        index:"TEMP1",       width:40,  align:'center' },
                                     {name:"TEMP2",        index:"TEMP2",       width:40,  align:'center' },
                                     ];
            
        $("#grd_MhSogCow2").jqGrid("GridUnload");
                
        $("#grd_MhSogCow2").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 40,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
            onSelectRow:function(rowid,status, e){
            	$("#auc_prg_sq");
            },
        });
		
      //행번호
        $("#grd_MhSogCow2").jqGrid("setLabel", "rn","No"); 
        
      //합계행에 가로스크롤이 있을경우 추가
      	var $obj = document.getElementById('grd_MhSogCow2');
        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

        $bDiv.css({'overflow-x':'hidden'});
        $sDiv.css({'overflow-x':'scroll'});
        $sDiv.scroll(function(){
            $bDiv.scrollLeft($sDiv.scrollLeft());
        });
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow2 .jqgfirstrow td:last-child").width($("#grd_MhSogCow2 .jqgfirstrow td:last-child").width() - 17);     
        
      
        //footer        
        var gridDatatemp = $('#grd_MhSogCow2').getRowData();
        
        //합 
        var tot_sra_indv_amnno	    = parseInt(0);
        var tot_lows_sbid_lmt_am    = parseInt(0); 
        var tot_cow_sog_wt          = parseInt(0); 
        var am_sra_indv_amnno       = parseInt(0); 
        var su_sra_indv_amnno       = parseInt(0);      
        var gu_sra_indv_amnno       = parseInt(0);      
        var sa_sra_indv_amnno       = parseInt(0);      
        
        $.each(gridDatatemp,function(i){
        	//총두수
        	
        	if(gridDatatemp[i].SRA_INDV_AMNNO != 0){
        		tot_sra_indv_amnno++;
        	}
        	if(gridDatatemp[i].LOWS_SBID_LMT_AM != 0){
        		tot_lows_sbid_lmt_am++;
        	} 
        	//중량등록두수
        	if(gridDatatemp[i].COW_SOG_WT != 0){
        		tot_cow_sog_wt++;
        	}
        	//암두수, 수두수
        	if(gridDatatemp[i].INDV_SEX_C  == '1' || gridDatatemp[i].INDV_SEX_C  == '4' || gridDatatemp[i].INDV_SEX_C  == '6'){
        		am_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '2') {
            	su_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '3') {
            	gu_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '7') {
            	sa_sra_indv_amnno++;
            }else {
            	su_sra_indv_amnno++;
            }      	
        
        }); 
        
         var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                       ["AUC_PRG_SQ"            ,"총두수"                 ,1 ,"String" ]
                      ,["AUC_OBJ_DSC"           ,tot_sra_indv_amnno	    ,1 ,"Integer"] 
                      ,["DONG"                  ,"예정가등록두수"            ,1 ,"String"] 
                      ,["FTSNM"                 ,tot_lows_sbid_lmt_am    ,1 ,"Integer"] 
                      ,["INDV_SEX_C"        ,"중량등록두수"             ,1 ,"String"] 
                      ,["COW_SOG_WT"                 ,tot_cow_sog_wt          ,1 ,"Integer"]  
                      ,["LOWS_SBID_LMT_AM"                ,"암두수"                  ,1 ,"String"] 
                      ,["SRA_SBID_UPR"              ,am_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["SRA_SBID_AM"     ,"수두수"                  ,1 ,"String"] 
                      ,["SRA_MWMNNM"               ,su_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["E_CUS_MPNO"     ,"거세두수"                  ,1 ,"String"] 
                      ,["LVST_AUC_PTC_MN_NO"               ,su_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["TEMP1"     ,"새끼두수"                  ,1 ,"String"] 
                      ,["TEMP2"               ,su_sra_indv_amnno       ,1 ,"Integer"] 
		            ] 
         ]; 
  
         fn_setGridFooter('grd_MhSogCow2', arr); 
		
        
    }  
   
    //네번째 그리드 생성
    function fn_CreateGrid_4(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["일수(월령)","H사업장코드","H브랜드","H낙찰가격","H경매일자","H낙찰자","H낙찰가격","H인공수정일","H송아지축산개체관리번호","H송아지개체성별코드","H송아지출하중량","H송아지생년월일","H송아지KPN번호","H송아지월령","H구제역예방접종일","H임신개월수","H브루셀라검사일","H낙찰가","H예정가","H단가단위"
        	 					   ,"H농가명마스킹","H동이상"
								   ,"H유전능력 냉도체중","H유전능력 냉도체중 등급","H유전능력 배최장근단면적","H유전능력 배최장근단면적 등급","H등지방두께","H등지방두께 등급","H유전능력 근내지방도","H유전능력 근내지방도 등급"
								   ,"H유전능력 냉도체중-모개체","H유전능력 냉도체중등급-모개체","H유전능력 배최장근단면적-모개체","H유전능력 배최장근단면적 등급-모개체","H유전능력 등지방두께-모개체","H유전능력 등지방두께 등급-모개체","H유전능력 근내지방도-모개체","H유전능력 근내지방도 등급-모개체"
								   
								   ,"H유전능력 냉도체중","H유전능력 냉도체중 등급","H유전능력 배최장근단면적","H유전능력 배최장근단면적 등급","H등지방두께","H등지방두께 등급","H유전능력 근내지방도","H유전능력 근내지방도 등급"
								   ,"H유전능력 냉도체중-모개체","H유전능력 냉도체중등급-모개체","H유전능력 배최장근단면적-모개체","H유전능력 배최장근단면적 등급-모개체","H유전능력 등지방두께-모개체","H유전능력 등지방두께 등급-모개체","H유전능력 근내지방도-모개체","H유전능력 근내지방도 등급-모개체"
								   ,"H송아지만월령","H송아지월령일수","H임신개월(만)","H임신일수","H참가번호"
         		 				   ,"경매<br>번호", "경매대상", "성명"
         		 				   , "H귀표번호" , "H생년월일", "H산차", "H어미구분", "H계대", "H제각여부", "HKPN번호"
                                   , "성별", "중량","예정가","주소","전화번호","휴대폰","비고"
                                   ,"H어미귀표번호","H등록구분","H월령","H월령","H수정KPN","H친자검사여부","H친자검사결과","H우결핵검사일자","H고능력여부","H송아지구분","H전이용사료여부","H임신구분"
                                   ];        
        var searchResultColModel = [
 
        							 {name:"MTCN4",                     index:"MTCN4",                    width:55, align:'center'  ,hidden:true},
        							 {name:"NA_BZPLC",                  index:"NA_BZPLC",                 width:55, align:'center'  ,hidden:true},
        							 {name:"BRANDNM",                   index:"BRANDNM",                  width:55, align:'center'  ,hidden:true},
        							 {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:55, align:'center'  ,hidden:true},
        							 {name:"AUC_DT",                    index:"AUC_DT",                   width:55, align:'center'  ,hidden:true},
        							 {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:55, align:'center'  ,hidden:true},
        							 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:55, align:'center'  ,hidden:true},
        							 {name:"AFISM_MOD_DT",              index:"AFISM_MOD_DT",             width:55, align:'center'  ,hidden:true},
        							 {name:"CALF_SRA_INDV_AMNNO",       index:"CALF_SRA_INDV_AMNNO",      width:55, align:'center'  ,hidden:true},
        							 {name:"CALF_INDV_SEX_C",           index:"CALF_INDV_SEX_C",          width:55, align:'center'  ,hidden:true},
        							 {name:"CALF_COW_SOG_WT",           index:"CALF_COW_SOG_WT",          width:70, align:'center'  ,hidden:true},
        							 {name:"CALF_BIRTH",                index:"CALF_BIRTH",               width:55, align:'center'  ,hidden:true},
        							 {name:"CALF_KPN_NO",               index:"CALF_KPN_NO",              width:55, align:'center'  ,hidden:true},
        							 {name:"CALF_MTCN",                 index:"CALF_MTCN",                width:55, align:'center'  ,hidden:true},
        							 {name:"VACN_DT",                   index:"VACN_DT",                  width:55, align:'center'  ,hidden:true},
        							 {name:"PRNY_MTCN",                 index:"PRNY_MTCN",                width:55, align:'center'  ,hidden:true},
        							 {name:"BRCL_ISP_DT",               index:"BRCL_ISP_DT",              width:55, align:'center'  ,hidden:true},
        							 {name:"SRA_INDV_AM",               index:"SRA_INDV_AM",              width:55, align:'center'  ,hidden:true},
        							 {name:"LOWS_SBID_LMT_UPR",         index:"LOWS_SBID_LMT_UPR",		  width:55, align:'center'  ,hidden:true},
        							 {name:"LOWS_SBID_LMT_UNIT",        index:"LOWS_SBID_LMT_UNIT", 	  width:55, align:'center'  ,hidden:true},
        							 {name:"FTSNM_MASKING",        		index:"FTSNM_MASKING", 	  		  width:55, align:'center'  ,hidden:true},
        							 {name:"DONGUP",        			index:"DONGUP", 	  			  width:55, align:'center'  ,hidden:true},
                                     
        							 {name:"RE_PRODUCT_1",              index:"RE_PRODUCT_1",              width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_1_1",            index:"RE_PRODUCT_1_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_2",              index:"RE_PRODUCT_2",              width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_2_1",            index:"RE_PRODUCT_2_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_3",              index:"RE_PRODUCT_3",              width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_3_1",            index:"RE_PRODUCT_3_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_4",              index:"RE_PRODUCT_4",              width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_4_1",            index:"RE_PRODUCT_4_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_11",             index:"RE_PRODUCT_11",             width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_11_1",           index:"RE_PRODUCT_11_1",           width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_12",             index:"RE_PRODUCT_12",             width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_12_1",           index:"RE_PRODUCT_12_1",           width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_13",             index:"RE_PRODUCT_13",             width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_13_1",           index:"RE_PRODUCT_13-1",           width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_14",             index:"RE_PRODUCT_14",             width:55, align:'center'  ,hidden:true},
        							 {name:"RE_PRODUCT_14_1",           index:"RE_PRODUCT_14_1",           width:55, align:'center'  ,hidden:true},
        							 
								     /* s: 리포트 데이터 백지 방지용 컬럼  */
        							 {name:"re_product_1",              index:"re_product_1",              width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_1_1",            index:"re_product_1_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_2",              index:"re_product_2",              width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_2_1",            index:"re_product_2_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_3",              index:"re_product_3",              width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_3_1",            index:"re_product_3_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_4",              index:"re_product_4",              width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_4_1",            index:"re_product_4_1",            width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_11",             index:"re_product_11",             width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_11_1",           index:"re_product_11_1",           width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_12",             index:"re_product_12",             width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_12_1",           index:"re_product_12_1",           width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_13",             index:"re_product_13",             width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_13_1",           index:"re_product_13-1",           width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_14",             index:"re_product_14",             width:55, align:'center'  ,hidden:true},
        							 {name:"re_product_14_1",           index:"re_product_14_1",           width:55, align:'center'  ,hidden:true},        							 
        							 /* e: 리포트 데이터 백지 방지용 컬럼  */        							 
        							 {name:"CALF_MTCN_A",            	index:"CALF_MTCN_A"				  ,hidden:true},    
        							 {name:"CALF_MTCN4",            	index:"CALF_MTCN4"				  ,hidden:true},    
        							 {name:"MOD_MONTHS",            	index:"MOD_MONTHS"				  ,hidden:true},    
        							 {name:"MOD_DAYS",            		index:"MOD_DAYS"				  ,hidden:true},    
        							 {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO"		  ,hidden:true},    
        							  
        							 {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:50, align:'center'  },
                                     {name:"AUC_OBJ_DSC",               index:"AUC_OBJ_DSC",              width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"FTSNM",                     index:"FTSNM",                    width:60, align:'center'  },
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"SRA_INDV_AMNNO12",          index:"SRA_INDV_AMNNO12",         width:160, align:'center' ,hidden:true},
                                     {name:"BIRTH",                     index:"BIRTH",                    width:70, align:'center'   ,hidden:true},
                                     {name:"MATIME",                    index:"MATIME",                   width:35, align:'right'   ,hidden:true},
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:70, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)},hidden:true},
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:40,  align:'right'  ,hidden:true},
                                     {name:"RMHN_YN",                   index:"RMHN_YN",                  width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:60, align:'center'  ,hidden:true},
                                     /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:40, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:70, align:'right'    , formatter:'interger', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:90, align:'right'    , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"DONG",                      index:"DONG",                     width:250, align:'left' },
                                     {name:"OHSE_TELNO",                index:"OHSE_TELNO",               width:80, align:'center'},
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:85, align:'center'},
                                     {name:"RMK_CNTN",                  index:"RMK_CNTN",                 width:190, align:'left' }, 
                                     
                                     /* s: 리포트 데이터 백지 방지용 컬럼  */
                                     {name:"MCOW_SRA_INDV_AMNNO",       index:"MCOW_SRA_INDV_AMNNO",      width:120, align:'center' ,hidden:true},
                                     {name:"RG_DSC",                    index:"RG_DSC",                   width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)},hidden:true},
                                     {name:"MTCN",                      index:"MTCN",                     width:40, align:'right'    , formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','},hidden:true},
                                     {name:"MTCN1",                     index:"MTCN1",                    width:70, align:'right'    , formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','},hidden:true},
                                     {name:"MOD_KPN_NO",                index:"MOD_KPN_NO",               width:60, align:'center'  ,hidden:true},
                                     {name:"DNA_YN_CHK",                index:"DNA_YN_CHK",               width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"DNA_YN",                    index:"DNA_YN",                   width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA},hidden:true},
                                     {name:"BOVINE_DT",                 index:"BOVINE_DT",                width:100, align:'center'  ,hidden:true}, 
                                     {name:"EPD_YN",                    index:"EPD_YN",                   width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true},
                                     {name:"CASE_COW",                  index:"CASE_COW",                 width:100, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)},hidden:true}, 
                                     {name:"FED_SPY_YN",                index:"FED_SPY_YN",               width:100, align:'center' , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA},hidden:true} ,
        							 {name:"PPGCOW_FEE_DSC",       		index:"PPGCOW_FEE_DSC",       	  width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)},hidden:true}
        							 /* e: 리포트 데이터 백지 방지용 컬럼  */
                                     ];
            
        $("#grd_MhSogCow4").jqGrid("GridUnload");
                
        $("#grd_MhSogCow4").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 40,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
            onSelectRow:function(rowid,status, e){
            	$("#auc_prg_sq");
            },
        });
		
      //행번호
        $("#grd_MhSogCow4").jqGrid("setLabel", "rn","No"); 
        
      //합계행에 가로스크롤이 있을경우 추가
      	var $obj = document.getElementById('grd_MhSogCow4');
        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

        $bDiv.css({'overflow-x':'hidden'});
        $sDiv.css({'overflow-x':'scroll'});
        $sDiv.scroll(function(){
            $bDiv.scrollLeft($sDiv.scrollLeft());
        });
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow4 .jqgfirstrow td:last-child").width($("#grd_MhSogCow4 .jqgfirstrow td:last-child").width() - 17);     
        
      
        //footer        
        var gridDatatemp = $('#grd_MhSogCow4').getRowData();
        
        //합 
        var tot_sra_indv_amnno	    = parseInt(0);
        var tot_lows_sbid_lmt_am    = parseInt(0); 
        var tot_cow_sog_wt          = parseInt(0); 
        var am_sra_indv_amnno       = parseInt(0); 
        var su_sra_indv_amnno       = parseInt(0); 
        var gu_sra_indv_amnno       = parseInt(0); 
        var sa_sra_indv_amnno       = parseInt(0); 
        $.each(gridDatatemp,function(i){
        	//총두수
        	
        	if(gridDatatemp[i].SRA_INDV_AMNNO != 0){
        		tot_sra_indv_amnno++;
        	}
        	
        	if(gridDatatemp[i].LOWS_SBID_LMT_AM != 0){
        		tot_lows_sbid_lmt_am++;
        	} 
        	//중량등록두수
        	
        	if(gridDatatemp[i].COW_SOG_WT != 0){
        		tot_cow_sog_wt++;
        	}
        	//암두수, 수두수
        	if(gridDatatemp[i].INDV_SEX_C  == '1' || gridDatatemp[i].INDV_SEX_C  == '4' || gridDatatemp[i].INDV_SEX_C  == '6'){
        		am_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '2') {
            	su_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '3') {
            	gu_sra_indv_amnno++;
            }else if(gridDatatemp[i].INDV_SEX_C  == '7') {
            	sa_sra_indv_amnno++;
            }else {
            	su_sra_indv_amnno++;
            }       		
        	
        }); 
     
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                       ["AUC_PRG_SQ"              ,"총두수"                  ,1 ,"String" ]
                      ,["AUC_OBJ_DSC"             ,tot_sra_indv_amnno 	   ,1 ,"Integer"] 
                      ,["FTSNM"                   ,"예정가등록두수"            ,1 ,"String"] 
                      ,["INDV_SEX_C"              ,tot_lows_sbid_lmt_am    ,1 ,"Integer"] 
                      ,["COW_SOG_WT"                  ,"중량등록두수"          ,1 ,"String"] 
                      ,["LOWS_SBID_LMT_AM"       ,tot_cow_sog_wt          ,1 ,"Integer"] 
                      ,["DONG"                 ,"암두수"                  ,1 ,"String"] 
                      ,["OHSE_TELNO"           ,am_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["CUS_MPNO"              ,"수두수"                  ,1 ,"String"] 
                      ,["RMK_CNTN"              ,su_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["CUS_MPNO"              ,"거세두수"                  ,1 ,"String"] 
                      ,["RMK_CNTN"              ,gu_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["CUS_MPNO"              ,"새끼두수"                  ,1 ,"String"] 
                      ,["RMK_CNTN"              ,sa_sra_indv_amnno       ,1 ,"Integer"] 
		           ] 
         ];
  
         fn_setGridFooter('grd_MhSogCow4', arr); 
		
        
    }
    function fnSetGridData(frmId){
    
        gridSaveRow(frmId);
        var colModel    = $('#'+frmId).jqGrid('getGridParam', 'colModel');
        var gridData    = $('#'+frmId).jqGrid('getGridParam', 'data');        
		var result = new Array();        
        if (gridData.length == 0) {
           MessagePopup("OK", '조회된 데이터가 없습니다.');
           return result;
        }
		for (var i = 0, len = colModel.length; i < len; i++) {
		   if (colModel[i].hidden === true) {
		       continue;
		   }
		   
		   if (colModel[i].formatter == 'select') {
		       $('#'+frmId).jqGrid('setColProp', colModel[i].name, {
		           unformat: gridUnfmt
		       });
		   }
		}
		var index = 0;

		$('#'+frmId).getRowData().forEach((o,i)=>{
			
			if(o.SRA_INDV_PASG_QCN == '0'){
				o.SRA_INDV_PASG_QCN = '';
			}
			if(o.MATIME == '0'){
				o.MATIME = '';
			}
			if(o.PRNY_MTCN == '0'){
				o.PRNY_MTCN = '';
			}
			if(o.COW_SOG_WT == '0'){
				o.COW_SOG_WT = '';
			}
			if(o.LOWS_SBID_LMT_AM == '0'){
				o.LOWS_SBID_LMT_AM = '';
			}else{
				o.LOWS_SBID_LMT_AM = o.LOWS_SBID_LMT_UPR;
			}
			if(o.SRA_SBID_UPR == '0'){
				o.SRA_SBID_UPR = '';
			}
			o.SRA_SBID_AM = o.SRA_SBID_UPR;
			
			//주소 설정 평택 : 8808990795874 | 해남진도 : 8808990656106 | 고흥 : 8808990779546
			if(na_bzplc == '8808990795874' || na_bzplc == '8808990656106' || na_bzplc == '8808990779546'){
				var tempAddr = [];
				o.DONGUP.split(" ").forEach((o,i)=>{
				    if(o.endsWith('시') || o.endsWith('군') || o.endsWith('구')
			    		|| o.endsWith('읍') || o.endsWith('면') || o.endsWith('동')
		    		){
				        tempAddr.push(o);
				    }
				});
				o.DONG = tempAddr.join(" ");
			}
			
			if(o.CALF_INDV_SEX_C == '0' ){
				o.CALF_INDV_SEX_C ="없음";
			}else if(o.CALF_INDV_SEX_C == '1' ){
				o.CALF_INDV_SEX_C ="암";
			}else if(o.CALF_INDV_SEX_C == '2' ){
				o.CALF_INDV_SEX_C ="수";
			}else if(o.CALF_INDV_SEX_C == '3' ){
				o.CALF_INDV_SEX_C ="거세";
			}else if(o.CALF_INDV_SEX_C == '4' ){
				o.CALF_INDV_SEX_C ="미경산";
			}else if(o.CALF_INDV_SEX_C == '5' ){
				o.CALF_INDV_SEX_C ="비거세";
			}else if(o.CALF_INDV_SEX_C == '6' ){
				o.CALF_INDV_SEX_C ="프리마틴";
			}else if(o.CALF_INDV_SEX_C == '9' ){
				o.CALF_INDV_SEX_C ="공통";
			}
			result.push(o);
			if($('#bothPrint:checked').val() == 'Y'){
				result.push(cloneObj(o));
			}
			
			function cloneObj(source) {
			  var target = {};
			  for (let i in source) {			    
			      target[i] = source[i];
			  }
			  return target;
			}
		}); 
		
		return result;
    }
    
	//응찰자용
    function fnSetGridData1(frmId){
    
        gridSaveRow(frmId);
        var colModel    = $('#'+frmId).jqGrid('getGridParam', 'colModel');
        var gridData    = $('#'+frmId).jqGrid('getGridParam', 'data');        
		var result = new Array();        
        if (gridData.length == 0) {
           MessagePopup("OK", '조회된 데이터가 없습니다.');
           return result;
        }
		for (var i = 0, len = colModel.length; i < len; i++) {
		   if (colModel[i].hidden === true) {
		       continue;
		   }
		   
		   if (colModel[i].formatter == 'select') {
		       $('#'+frmId).jqGrid('setColProp', colModel[i].name, {
		           unformat: gridUnfmt
		       });
		   }
		}
		var index = 0;
		$('#'+frmId).getRowData().forEach((o,i)=>{		
			o.DONG = (o.DONG||'').split(' ').filter(function(e,i){if(i<3) return e;}).join(' ');
			o.MTCN4 = (o.MTCN-1)+'개월 '+o.MTCN_DAYS+'일';
			result.push(cloneObj(o));			
			function cloneObj(source) {
			  var target = {};
			  for (let i in source) {			    
			      target[i] = source[i];
			  }
			  return target;
			}
		}); 
		
		return result;
    }

    
	//포항
    function fnSetGridDataEx(frmId){
    
        gridSaveRow(frmId);
        var colModel    = $('#'+frmId).jqGrid('getGridParam', 'colModel');
        var gridData    = $('#'+frmId).jqGrid('getGridParam', 'data');        
		var result = new Array();        
        if (gridData.length == 0) {
           MessagePopup("OK", '조회된 데이터가 없습니다.');
           return result;
        }
		for (var i = 0, len = colModel.length; i < len; i++) {
		   if (colModel[i].hidden === true) {
		       continue;
		   }
		   
		   if (colModel[i].formatter == 'select') {
		       $('#'+frmId).jqGrid('setColProp', colModel[i].name, {
		           unformat: gridUnfmt
		       });
		   }
		}
		var index = 0;
		$('#'+frmId).getRowData().forEach((o,i)=>{
			if(o.PRNY_MTCN == '0'){
				o.PRNY_MTCN = '';
			}
			if(o.COW_SOG_WT == '0'){
				o.COW_SOG_WT = '';
			}
			if(o.LOWS_SBID_LMT_AM == '0'){
				o.LOWS_SBID_LMT_AM = '';
			}
			
			result.push(cloneObj(o));			
			function cloneObj(source) {
			  var target = {};
			  for (let i in source) {			    
			      target[i] = source[i];
			  }
			  return target;
			}
		}); 
		
		return result;
    }
    </script>

<body>
	<div class="contents">

		<%@ include file="/WEB-INF/common/menuBtn.jsp"%>
		
		<section class="content">
			<div class="tab_box clearfix">
				<ul class="tab_list">
					<li><p class="dot_allow">검색조건</p></li>
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
								<col width="80">
								<col width="*">
								<col width="80">
								<col width="*">
								<col width="80">
								<col width="*">
								<!-- 버튼 있는 테이블은 width 94 고정 -->
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><span class="tb_dot">경매일자</span></th>
									<td>
										<div class="cell">
											<input type="text" class="date" id="auc_dt">
										</div>
									</td>
									<th scope="row"><span class="tb_dot">경매대상</span></th>
									<td><select id="auc_obj_dsc"></select></td>
									<th scope="row"><span class="tb_dot">성별</span></th>
									<td><select id="indv_sex_c"></select></td>
									<th scope="row"><span class="tb_dot">진행상태</span></th>
									<td><select id="sel_sts_dsc"></select></td>
								</tr>
								<tr>
									<th scope="row"><span class="tb_dot">경매번호</span></th>
									<td>
										<div class="cellBox">
											<div class="cell">
												<input type="text" id="st_auc_no">
											</div>
											<div class="cell ta_c">~</div>
											<div class="cell">
												<input type="text" id="ed_auc_no">
											</div>
										</div>
									</td>
									<th class="ftsnm_td" scope="row"><span class="tb_dot">출하자명</span></th>
									<td class="ftsnm_td">
										<div class="cellbox">
											<div class="cell">
												<input type="text" id="ftsnm">
											</div>
										</div>
									</td>
									<th class="dong_td" scope="row"><span class="tb_dot">지역</span></th>
									<td class="dong_td">
										<div class="cellbox">
											<div class="cell">
												<input type="text" id="dongup">
												<input type="hidden" id="qcn"/>
											</div>
										</div>
									</td>
									<th class="bothPrint_td" scope="row"><span class="tb_dot">양면인쇄</span></th>
									<td class="bothPrint_td">
										<div class="cellbox">
											<div class="cell">
												<input type="checkbox" id="bothPrint" class="noEvent" value="Y">
											</div>
										</div>
									</td>																		
	                                <th scope="row" class="sordOrder_td">정렬구분</th>
	                                <td class="sordOrder_td">
	                                    <select id="sel_order">
	                                    	<option value=""> 경매번호</option>
	                                    	<option value="1"> 경매대상 + 출하자명 + 경매번호</option>
	                                    </select>
	                                </td> 
								<tr>
							</tbody>
						</table>
						<table id="holder">
							<colgroup>
								<col width="150">
								<col width="*">
								<!-- 버튼 있는 테이블은 width 94 고정 -->
							</colgroup>
							<tbody>
								<tr>
									<th class="tb_dot" rowspan="2" width="150px">인쇄형식(거치대)</th>
									<td id="radio" class="radio" colspan='12'>
									    <input type="radio" name="radio" id="prto_tpc_1" value="1" disabled><label>케이지&nbsp;</label>
										<input type="radio" name="radio" id="prto_tpc_2" value="2"><label>거치대&nbsp;</label>
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
				<ul class="tab_list">
					<li><a href="#tab1" id="tab_1" class="on">경매전(응찰자용)A4</a></li>
					<!-- <li><a href="#tab2" id="tab_2">경매전(게시판용)</a></li> -->
					<li><a href="#tab3" id="tab_3">경매후(관리자용)A4</a></li>
					<li><a href="#tab4" id="tab_4">경매전(거치대용)</a></li>

				</ul>
			</div>

			<!-- 1.경매전 (응찰자용)  -->		

			<div id="tab1" class="tab_content">

				<div class="listTable rsp_v">
					<table id="grd_MhSogCow1">
					</table>
				</div>


			</div>
			
			<!-- 2.경매전(게시판용) -->
			<!-- 염소 내역 컬럼 부실로 인한 삭제
			<div id="tab2" class="tab_content">


				<div class="listTable rsp_v">
					<table id="grd_MhSogCow3" >
					</table>
				</div>


			</div>
			-->
			
			<!-- 3.경매후(관리자용)A4 -->
			<div id="tab3" class="tab_content">


				<div class="listTable rsp_v">
					<table id="grd_MhSogCow2" >
					</table>
				</div>

			</div>
			
			<!-- 4.경매전(거치대용) -->
			<div id="tab4" class="tab_content">

				<div class="listTable rsp_v">
					<table id="grd_MhSogCow4" >
					</table>
				</div>
			</div>
		</section>
	</div>

</body>

</html>