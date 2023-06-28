<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

<%@ include file="../../../common/serviceCall.jsp" %>
<%@ include file="../../../common/head.jsp" %> 
<style>
.grayTable th {
	padding-left:1px !important;
}
</style>

</head>
<script type="text/javascript">
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0513
 * 3. 파일명(한글) : 경매보고자료
 *----------------------------------------------------------------------------* 
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.11.01   신명진   최초 작성
 ------------------------------------------------------------------------------*/
 ////////////////////////////////////////////////////////////////////////////////
 //  공통버튼 클릭함수 시작
 ////////////////////////////////////////////////////////////////////////////////
 /*------------------------------------------------------------------------------
  * 1. 함 수 명    : onload 함수
  * 2. 입 력 변 수 : N/A
  * 3. 출 력 변 수 : N/A
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
 	var mv_RunMode = 0;
 	
 	// 엑셀 출력을 위한 임시 Object
 	var tmpGrdMhSogCow13 = new Object();
 	var tmpGrdMhSogCow14 = new Object();
 	var tmpSubMhSogCow   = new Object();
 	
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
 		
 		$(document).on("click", "input[name='fee_apl_obj_cyn']", function(e) {
    		fn_setChgRadio("fee_apl_obj_c", $("input[name='fee_apl_obj_cyn']:checked").val());
        });
    	
		// 검색(돋보기) 팝업 호출 이벤트
		$(document).on("click", "#pb_ftsnm", function(e) {
            e.preventDefault();
            this.blur();
            
            if($("#io_sel").text() == "출하자") {
            	fn_CallFhsPopup(false);
            } else if($("#io_sel").text() == "낙찰자") {
            	fn_CallMwmnPopup(false);
            } else if($("#io_sel").text() == "수의사") {
            	fn_CallNaTrplCPopup(false);
            }
        });
    	
    	// 검색 팝업 호출 이벤트
    	$(document).on("keydown", "#ftsnm", function(e) {
    		if(e.keyCode == 13) {
             	if(fn_isNull($("#ftsnm").val())) {
             		MessagePopup('OK','검색할 내용을 입력하세요.');
             		return;
             	} else {
             		if($("#io_sel").text() == "출하자") {
             			fn_CallFhsPopup(true);
                    } else if($("#io_sel").text() == "낙찰자") {
                    	fn_CallMwmnPopup(true);
                    } else if($("#io_sel").text() == "수의사") {
                    	fn_CallNaTrplCPopup(true);
                    }
                }
             }else{
            	 $('#fhs_id_no').val('');
             }
        });
    	
    	// 이름 검색(돋보기) 팝업 호출 이벤트
		$(document).on("click", "#pb_name", function(e) {
            e.preventDefault();
            this.blur();
            fn_CallSraSrchPopup(true);
        });
    	
    	// 이름 검색 팝업 호출 이벤트
    	$(document).on("keydown", "#name", function(e) {
    		if(e.keyCode == 13) {
             	if(fn_isNull($("#name").val())) {
             		MessagePopup('OK','이름을 입력하세요.');
             		return;
             	} else {
             		fn_CallSraSrchPopup(true);
                }
             }
        });
    	
	    $("#pb_tab1").click(function(){
	    	fn_tabCheck("1");
        });
	    
	    $("#pb_tab2").click(function(){
	    	fn_tabCheck("2");
        });
	    
	    $("#pb_tab3").click(function(){
	    	fn_tabCheck("3");
        });
	    
	    $("#pb_tab4").click(function(){
	    	fn_tabCheck("4");
        });
	    
	    $("#pb_tab5").click(function(){
	    	fn_tabCheck("5");
        });
	    
	    $("#pb_tab6").click(function(){
	    	fn_tabCheck("6");
        });
	    
	    $("#pb_tab7").click(function(){
	    	fn_tabCheck("7");
        });
	    
	    $("#pb_tab8").click(function(){
	    	fn_tabCheck("8");
        });
	    
	    $("#pb_tab9").click(function(){
	    	fn_tabCheck("9");
        });
	    
	    $("#pb_tab10").click(function(){
	    	fn_tabCheck("10");
        });
	    
	    $("#pb_tab11").click(function(){
	    	fn_tabCheck("11");
        });
	    
	    $("#pb_tab12").click(function(){
	    	fn_tabCheck("12");
        });
	    
	    $("#pb_tab13").click(function(){
	    	fn_tabCheck("13");
        });
	    
	    $("#pb_tab14").click(function(){
	    	fn_tabCheck("14");
        });
	    
	    $("#pb_tab15").click(function(){
	    	fn_tabCheck("15");
        });
	    
	    $(document).on("click", "#MhSogCow9_Chk", function(e) {
	    	if($("#MhSogCow9_Chk").is(":checked")) {
	    		fn_contrChBox(true, "MhSogCow9_Chk", "");
			} else {
				fn_contrChBox(false, "MhSogCow9_Chk", "");
			}
        });
	    
	    $(document).on("click", "#MhSogCow11_Chk", function(e) {
	    	if($("#MhSogCow11_Chk").is(":checked")) {
	    		fn_contrChBox(true, "MhSogCow11_Chk", "");
			} else {
				fn_contrChBox(false, "MhSogCow11_Chk", "");
			}
        });
	    
	    $(document).on("click", "#chk_no_bid", function(e) {
	    	if($("#chk_no_bid").is(":checked")) {
	    		fn_contrChBox(true, "chk_no_bid", "");
			} else {
				fn_contrChBox(false, "chk_no_bid", "");
			}
        });
	    $(document).on("click", "#chk_calf_cow", function(e) {
	    	if($("#chk_calf_cow").is(":checked")) {
	    		fn_contrChBox(true, "chk_calf_cow", "");
			} else {
				fn_contrChBox(false, "chk_calf_cow", "");
			}
        });
        
 		fn_Init();
 		
 	});
 	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
    	 // 그리드 초기화
    	 fn_clearGrid();
    	 mv_RunMode = "0";
    	 // 탭 체크
    	 fn_tabCheck();
    	 if($('#pb_tab8').hasClass('on')){
        	 $("#tab8_sub").show();
        	 $("div#tab8_sub input").val('');    		 
    	 }else{
        	 $("#tab8_sub").hide();    		 
    	 }
    	 
    	 if(na_bzplc == "8808990656274" || na_bzplc == "8808990643625") {
    		 $("#pb_tab15").show();
    	 } else {
    		 $("#pb_tab15").hide();
    	 }
    	 
    	 // ★고창: 8808990657189 테스트: 8808990643625
         if(na_bzplc == "8808990657189" || na_bzplc == "8808990643625") {
         	$("#grd_MhSogCow5").jqGrid("hideCol", "BIRTH").trigger('reloadGrid');
         } else {
         	$("#grd_MhSogCow5").jqGrid("showCol", "BIRTH").trigger('reloadGrid');
         }
      	 // ★음성: 8808990683973 테스트: 8808990643625
         if(na_bzplc == "8808990683973" || na_bzplc == "8808990643625") {
         	$("#grd_MhSogCow5").jqGrid("hideCol", "SRA_TR_FEE2").trigger('reloadGrid');
         } else {
         	$("#grd_MhSogCow5").jqGrid("showCol", "SRA_TR_FEE2").trigger('reloadGrid');
         }
         //pb_tab8
         mv_RunMode = "1";
    }
    
    /*------------------------
	  obj_dsc [ ],숫자 제거  
	-------------------------*/
	function fn_deleteNumber(dsc){
		var obj_dsc = dsc.substr(4,3);
		

		return  obj_dsc; 


	}
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
    	 fn_clearGrid();
    	 mv_RunMode = "2";
    	 
    	 if(fn_isNull($("#auc_dt").val())) {
      		MessagePopup('OK','경매일자를 선택하세요.');
      		return;
    	 }
    	 
    	 if($("#pb_tab8").hasClass("on")) {
    		 if($("#auc_obj_dsc").val() == "0") {
   	      		MessagePopup('OK','경매집계표는 경매대상별로만 조회 가능합니다.');
   	      		return;
   	    	 }
    	 }
    	 
    	 if(!$("#pb_tab13").hasClass("on")) {
    		 if(fn_isNull($("#auc_obj_dsc").val())) {
   	      		MessagePopup('OK','경매대상을 선택하세요.');
   	      		return;
   	    	 }
    	 }
    	 
    	 var results;
         var result;
         
    	 
         if($("#pb_tab1").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList", "POST");
        	 
         } else if($("#pb_tab2").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_2", "POST");
        	 
         } else if($("#pb_tab3").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_3", "POST");
        	 
         } else if($("#pb_tab4").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_4", "POST");
        	 
         } else if($("#pb_tab5").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_5", "POST");
        	 
         } else if($("#pb_tab6").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_6", "POST");
        	 
         } else if($("#pb_tab7").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_7", "POST");
        	 
         } else if($("#pb_tab8").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_8", "POST");
        	 
         } else if($("#pb_tab9").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_9", "POST");
        	 
         } else if($("#pb_tab10").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_10", "POST");
        	 
         } else if($("#pb_tab11").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_11", "POST");
        	 
         } else if($("#pb_tab12").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_12", "POST");
        	 
         } else if($("#pb_tab13").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_13", "POST");
        	 
         } else if($("#pb_tab14").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_14", "POST");
        	 
         } else if($("#pb_tab15").hasClass("on")) {
        	 results = sendAjaxFrm("frm_Search", "/LALM0513_selList_15", "POST");
         }
        
         if(results.status != RETURN_SUCCESS) {
        	showErrorMessage(results);
            return;
            
         } else {
        	result = setDecrypt(results);
        	
        	if($("#pb_tab1").hasClass("on")) {
        		var result_1;
                var results_1 = null;
                results_1 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             	  
                if(results_1.status != RETURN_SUCCESS){
                    showErrorMessage(results_1);
                    return;
                } else {
                    result_1 = setDecrypt(results_1);
                    $("#qcn").val(result_1[0].QCN);
                    $("#grd_MhSogCow1").jqGrid("clearGridData", true);
                    $("#grd_ViewMhSogCow1").jqGrid("clearGridData", true);
                    
                    fn_CreateGrid(result);
                    
                }	
                
            } else if($("#pb_tab2").hasClass("on")) {
            	
            	var result_2;
                var results_2 = null;
                results_2 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             	  
                if(results_2.status != RETURN_SUCCESS){
                    showErrorMessage(results_2);
                    return;
                } else {
                    result_2 = setDecrypt(results_2);
                    $("#na_bzplc").val(result_2[0].NA_BZPLC);
                    $("#grd_MhSogCow2").jqGrid("clearGridData", true);
                    $("#grd_MhSogCow2_1").jqGrid("clearGridData", true);
                    $("#grd_ViewMhSogCow2").jqGrid("clearGridData", true);
                   
	                fn_CreateGrid_2(result);
                }
            	
            	
                
            } else if($("#pb_tab3").hasClass("on")) {
            	var result_3;
                var results_3 = null;
                results_3 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             	  
                if(results_3.status != RETURN_SUCCESS){
                    showErrorMessage(results_3);
                    return;
                } else {
                    result_3 = setDecrypt(results_3);
                    $("#qcn").val(result_3[0].QCN);
                    $("#grd_MhSogCow3").jqGrid("clearGridData", true);
                    $("#grd_ViewMhSogCow3").jqGrid("clearGridData", true);
                    fn_CreateGrid_3(result);
                }
                
            } else if($("#pb_tab4").hasClass("on")) {
            	var result_4;
                var results_4 = null;
                results_4 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             	  
                if(results_4.status != RETURN_SUCCESS){
                    showErrorMessage(results_4);
                    return;
                } else {
                    result_4 = setDecrypt(results_4);
                    $("#qcn").val(result_4[0].QCN);
                    $("#grd_MhSogCow4").jqGrid("clearGridData", true);
                    fn_CreateGrid_4(result);
                }
            } else if($("#pb_tab5").hasClass("on")) {
            	var result_5;
                var results_5 = null;
                results_5 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             	  
                if(results_5.status != RETURN_SUCCESS){
                    showErrorMessage(results_5);
                    return;
                } else {
                    result_5 = setDecrypt(results_5);
                    $("#qcn").val(result_5[0].QCN);
                    $("#grd_MhSogCow5").jqGrid("clearGridData", true);
                    fn_CreateGrid_5(result);
                    
                    var result_sub_5;
                    var results_sub_5 = null;
                    results_sub_5 = sendAjaxFrm("frm_Search", "/LALM0513_selSubList_5", "POST");
                 	  
                    if(results_sub_5.status == RETURN_SUCCESS){
                        result_sub_5 = setDecrypt(results_sub_5);
                        fn_CreateSubGrid_5(result_sub_5);
                	}
                }
             	
             	// ★고창: 8808990657189 테스트: 8808990643625
                if(na_bzplc == "8808990657189" || na_bzplc == "8808990643625") {
                	$("#grd_MhSogCow5").jqGrid("hideCol", "BIRTH").trigger('reloadGrid');
                } else {
                	$("#grd_MhSogCow5").jqGrid("showCol", "BIRTH").trigger('reloadGrid');
                }
             	// ★음성: 8808990683973 테스트: 8808990643625
                if(na_bzplc == "8808990683973" || na_bzplc == "8808990643625") {
                	$("#grd_MhSogCow5").jqGrid("hideCol", "SRA_TR_FEE2").trigger('reloadGrid');
                } else {
                	$("#grd_MhSogCow5").jqGrid("showCol", "SRA_TR_FEE2").trigger('reloadGrid');
                }
            
            } else if($("#pb_tab6").hasClass("on")) {
            	$("#grd_MhSogCow6").jqGrid("clearGridData", true);
                fn_CreateGrid_6(result); 
                
            } else if($("#pb_tab7").hasClass("on")) {
            	var result_7;
                var results_7 = null;
                results_7 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             
                if(results_7.status != RETURN_SUCCESS){
                    showErrorMessage(results_7);
                    return;
                } else {
                    result_7 = setDecrypt(results_7);
                    $("#qcn").val(result_7[0].QCN);
            	    $("#grd_MhSogCow7").jqGrid("clearGridData", true);
                    fn_CreateGrid_7(result); 
                }
      
             
            
            } else if($("#pb_tab8").hasClass("on")) {
            	$("#grd_MhSogCow8").jqGrid("clearGridData", true);
                fn_CreateGrid_8(result); 
                
                var results_8  	= results_8 = sendAjaxFrm("frm_Search", "/LALM0513_selSubList_8", "POST");
                var result_8   	= null;
                
                var am_tot_su  	= 0;
                var su_tot_su  	= 0;
                var no_tot_su  	= 0;
                var etc_tot_su 	= 0;
                
                var sum7 		= 0;
                var sum8 		= 0;
                var sum9 		= 0;
                var sum10 		= 0;
                var sum11 		= 0;
                var sum12 		= 0;
                var sum13 		= 0;
                var sum14 		= 0;
                
                var am_lows_sra_sbid_am	= 0;
                var am_max_sra_sbid_am 	= 0;
                var am_avg_sra_sbid_am 	= 0;
                var su_lows_sra_sbid_am = 0;
                var su_max_sra_sbid_am 	= 0;
                var su_avg_sra_sbid_am 	= 0;
                var no_lows_sra_sbid_am = 0;
                var no_max_sra_sbid_am 	= 0;
                var no_avg_sra_sbid_am 	= 0;
                var etc_lows_sra_sbid_am = 0;
                var etc_max_sra_sbid_am	= 0;
                var etc_avg_sra_sbid_am = 0;
                
                var am_lows_sra_mwmnnm 	= "";
                var am_max_sra_mwmnnm 	= "";
                var su_lows_sra_mwmnnm 	= "";
                var su_max_sra_mwmnnm 	= "";
                var no_lows_sra_mwmnnm 	= "";
                var no_max_sra_mwmnnm 	= "";
                var etc_lows_sra_mwmnnm = "";
                var etc_max_sra_mwmnnm 	= "";
             	  
                if(results_8.status == RETURN_SUCCESS){
                	
                	result_8 = setDecrypt(results_8);
                	
                	for(var i = 0; i < result_8.length; i++) {
                		
                		if(result_8[i]["INDV_SEX_C"] == "1") {
                			am_tot_su = parseInt(am_tot_su) + parseInt(result_8[i]["TOT_TOT_SU"]);
                			sum7 = parseInt(sum7) + parseInt(result_8[i]["TOT_SU"]);
                			sum9 = parseInt(sum9) + parseInt(result_8[i]["COW_SOG_WT"]);
                			am_lows_sra_sbid_am = result_8[i]["MIN_SRA_SBID_AM"];
                			am_max_sra_sbid_am = result_8[i]["MAX_SRA_SBID_AM"];
                			am_avg_sra_sbid_am = result_8[i]["AVG_SRA_SBID_AM"];
                			am_lows_sra_mwmnnm = result_8[i]["LOWS_SRA_MWMNNM"];
                			am_max_sra_mwmnnm = result_8[i]["MAX_SRA_MWMNNM"];
                			
                		} else if(result_8[i]["INDV_SEX_C"] == "2") {
                			su_tot_su = parseInt(su_tot_su) + parseInt(result_8[i]["TOT_TOT_SU"]);
                			sum8 = parseInt(sum8) + parseInt(result_8[i]["TOT_SU"]);
                			sum10 = parseInt(sum10) + parseInt(result_8[i]["COW_SOG_WT"]);
                			su_lows_sra_sbid_am = result_8[i]["MIN_SRA_SBID_AM"];
                			su_max_sra_sbid_am = result_8[i]["MAX_SRA_SBID_AM"];
                			su_avg_sra_sbid_am = result_8[i]["AVG_SRA_SBID_AM"];
                			su_lows_sra_mwmnnm = result_8[i]["LOWS_SRA_MWMNNM"];
                			su_max_sra_mwmnnm = result_8[i]["MAX_SRA_MWMNNM"];
                			
                		} else if(result_8[i]["INDV_SEX_C"] == "3") {
                			no_tot_su = parseInt(no_tot_su) + parseInt(result_8[i]["TOT_TOT_SU"]);
                			sum11 = parseInt(sum11) + parseInt(result_8[i]["TOT_SU"]);
                			sum13 = parseInt(sum13) + parseInt(result_8[i]["COW_SOG_WT"]);
                			no_lows_sra_sbid_am = result_8[i]["MIN_SRA_SBID_AM"];
                			no_max_sra_sbid_am = result_8[i]["MAX_SRA_SBID_AM"];
                			no_avg_sra_sbid_am = result_8[i]["AVG_SRA_SBID_AM"];
                			no_lows_sra_mwmnnm = result_8[i]["LOWS_SRA_MWMNNM"];
                			no_max_sra_mwmnnm = result_8[i]["MAX_SRA_MWMNNM"];
                			
                		} else if(result_8[i]["INDV_SEX_C"] == "4") {
                			etc_tot_su = parseInt(etc_tot_su) + parseInt(result_8[i]["TOT_TOT_SU"]);
                			sum12 = parseInt(sum12) + parseInt(result_8[i]["TOT_SU"]);
                			sum14 = parseInt(sum14) + parseInt(result_8[i]["COW_SOG_WT"]);
                			etc_lows_sra_sbid_am = result_8[i]["MIN_SRA_SBID_AM"];
                			etc_max_sra_sbid_am = result_8[i]["MAX_SRA_SBID_AM"];
                			etc_avg_sra_sbid_am = result_8[i]["AVG_SRA_SBID_AM"];
                			etc_lows_sra_mwmnnm = result_8[i]["LOWS_SRA_MWMNNM"];
                			etc_max_sra_mwmnnm = result_8[i]["MAX_SRA_MWMNNM"];
                			
                		}
                	}
                	
                	$("#am_tot_su").val(fn_toComma(am_tot_su));
                	$("#su_tot_su").val(fn_toComma(su_tot_su));
                	$("#no_tot_su").val(fn_toComma(no_tot_su));
                	$("#etc_tot_su").val(fn_toComma(etc_tot_su));
                	
                	$("#sum7").val(fn_toComma(sum7));
                	$("#sum8").val(fn_toComma(sum8));
                	$("#sum9").val(fn_toComma(sum9));
                	$("#sum10").val(fn_toComma(sum10));
                	$("#sum11").val(fn_toComma(sum11));
                	$("#sum12").val(fn_toComma(sum12));
                	$("#sum13").val(fn_toComma(sum13));
                	$("#sum14").val(fn_toComma(sum14));
                	
                	$("#am_lows_sra_sbid_am").val(fn_toComma(am_lows_sra_sbid_am));
                	$("#am_max_sra_sbid_am").val(fn_toComma(am_max_sra_sbid_am));
                	$("#am_avg_sra_sbid_am").val(fn_toComma(am_avg_sra_sbid_am));
                	$("#am_lows_sra_mwmnnm").val(am_lows_sra_mwmnnm);
                	$("#am_max_sra_mwmnnm").val(am_max_sra_mwmnnm);
                	
                	$("#su_lows_sra_sbid_am").val(fn_toComma(su_lows_sra_sbid_am));
                	$("#su_max_sra_sbid_am").val(fn_toComma(su_max_sra_sbid_am));
                	$("#su_avg_sra_sbid_am").val(fn_toComma(su_avg_sra_sbid_am));
                	$("#su_lows_sra_mwmnnm").val(su_lows_sra_mwmnnm);
                	$("#su_max_sra_mwmnnm").val(su_max_sra_mwmnnm);
                	
                	$("#no_lows_sra_sbid_am").val(fn_toComma(no_lows_sra_sbid_am));
                	$("#no_max_sra_sbid_am").val(fn_toComma(no_max_sra_sbid_am));
                	$("#no_avg_sra_sbid_am").val(fn_toComma(no_avg_sra_sbid_am));
                	$("#no_lows_sra_mwmnnm").val(no_lows_sra_mwmnnm);
                	$("#no_max_sra_mwmnnm").val(no_max_sra_mwmnnm);
                	
                	$("#etc_lows_sra_sbid_am").val(fn_toComma(etc_lows_sra_sbid_am));
                	$("#etc_max_sra_sbid_am").val(fn_toComma(etc_max_sra_sbid_am));
                	$("#etc_avg_sra_sbid_am").val(fn_toComma(etc_avg_sra_sbid_am));
                	$("#etc_lows_sra_mwmnnm").val(etc_lows_sra_mwmnnm);
                	$("#etc_max_sra_mwmnnm").val(etc_max_sra_mwmnnm);
                	
                	$("#sum_am_yu").val(fn_toComma(parseInt(am_tot_su) - parseInt(sum7)));
                	$("#sum_su_yu").val(fn_toComma(parseInt(su_tot_su) - parseInt(sum8)));
                	$("#sum_no_yu").val(fn_toComma(parseInt(no_tot_su) - parseInt(sum11)));
                	$("#sum_etc_yu").val(fn_toComma(parseInt(etc_tot_su) - parseInt(sum12)));
                	
                }else {
                	result_8 = setDecrypt(results_8);
                	fn_CreateGrid_8(result);
                }
                
                var result_8_1;
                var results_8_1 = null;
                results_8_1 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             	  
                if(results_8_1.status != RETURN_SUCCESS){
                    showErrorMessage(results_8_1);
                    return;
                } else {
                    result_8_1 = setDecrypt(results_8_1);
                    $("#qcn").val(result_8_1[0].QCN);
                }  
                
            } else if($("#pb_tab9").hasClass("on")) {
            	 var result_9;
                var results_9 = null;
                results_9 = sendAjaxFrm("frm_Search", "/LALM0513_selMhFeeImps", "POST");
             	  
                if(results_9.status != RETURN_SUCCESS){
                    //showErrorMessage(results_9);
                    //return;
                    $("#fhs_sra_ubd_fee").val(0);
                    $("#sel_sra_ubd_fee").val(0);
                    $("#am_ubd_hdcn").val(0);
                    $("#su_ubd_hdcn").val(0);
                } else {
                    result_9 = setDecrypt(results_9);
                    $("#fhs_sra_ubd_fee").val(result_9[0].FHS_SRA_UBD_FEE);
                    $("#sel_sra_ubd_fee").val(result_9[0].SEL_SRA_UBD_FEE);
                    $("#am_ubd_hdcn").val(result_9[0].AM_UBD_HDCN);
                    $("#su_ubd_hdcn").val(result_9[0].SU_UBD_HDCN);
                } 
                    
                var result_9_1;
                var results_9_1 = null;
                results_9_1 = sendAjaxFrm("frm_Search", "/LALM0513_selMhAucQcn", "POST");
             	  
                if(results_9_1.status != RETURN_SUCCESS){
                    //showErrorMessage(results_9_1);
                } else {
                    result_9_1 = setDecrypt(results_9_1);
                    $("#qcn").val(result_9_1[0].QCN);
                }
                $("#grd_MhSogCow9").jqGrid("clearGridData", true);
                fn_CreateGrid_9(result);
            	
            
            } else if($("#pb_tab10").hasClass("on")) {
            	$("#grd_MhSogCow10").jqGrid("clearGridData", true);
            	$("#grd_ViewMhSogCow10").jqGrid("clearGridData", true);
                fn_CreateGrid_10(result); 
            
            } else if($("#pb_tab11").hasClass("on")) {
            	$("#grd_MhSogCow11").jqGrid("clearGridData", true);
            	$("#grd_MhSogCow11_1").jqGrid("clearGridData", true);
                fn_CreateGrid_11(result); 
            
            } else if($("#pb_tab12").hasClass("on")) {
            	$("#grd_MhSogCow12").jqGrid("clearGridData", true);
                fn_CreateGrid_12(result); 
            
            } else if($("#pb_tab13").hasClass("on")) {
            	$("#grd_MhSogCow13").jqGrid("clearGridData", true);
                fn_CreateGrid_13(result);
                fn_CreateHdnGrid_13(result);
            
            } else if($("#pb_tab14").hasClass("on")) {
            	$("#grd_MhSogCow14").jqGrid("clearGridData", true);
                fn_CreateGrid_14(result); 
            
            } else if($("#pb_tab15").hasClass("on")) {
            	$("#grd_MhSogCow15").jqGrid("clearGridData", true);
                fn_CreateGrid_15(result); 
            
            }
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
    	
    	if($("#pb_tab1").hasClass("on")) {
    		fn_ExcelDownlad('grd_ViewMhSogCow1', '낙찰자정산서');
       		
        } else if($("#pb_tab2").hasClass("on")) {
        	fn_ExcelDownlad('grd_ViewMhSogCow2', '매매대금영수증');
        	
        } else if($("#pb_tab3").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow3', '경매후 내역');
        	
        } else if($("#pb_tab4").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow4', '미수금현황');
        	
        } else if($("#pb_tab5").hasClass("on")) {
        	fn_ExcelDownlad('hdn_grd_MhSogCow5', '정산내역(농가)');
        	
        } else if($("#pb_tab6").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow6', '등록우 입금내역');
        	
        } else if($("#pb_tab7").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow7', '운송비내역');
        	
        } else if($("#pb_tab8").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow8', '경매집계표');
        	
        } else if($("#pb_tab9").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow9', '총판매집계표');
        	
        } else if($("#pb_tab10").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow10', '중도매인 정산내역');
        	
        } else if($("#pb_tab11").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow11', '출하자 정산내역');
        	
        } else if($("#pb_tab12").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow12', '수의사 지급내역');
        	
        } else if($("#pb_tab13").hasClass("on")) {

        	
        	var gridDatatemp = $('#hdn_grd_MhSogCow13').getRowData();
        	var checkCnt = 0;

	        $.each(gridDatatemp, function(i){
	        	if(fn_isNull(gridDatatemp[i].SOG_DONG)        || fn_isNull(gridDatatemp[i].SLPL_NA_CLNTNM) || fn_isNull(gridDatatemp[i].SRA_INDV_EART_NO)
	        	|| fn_isNull(gridDatatemp[i].SRA_INDV_BIRTH)  || fn_isNull(gridDatatemp[i].INDV_SEX_C)     || fn_isNull(gridDatatemp[i].MWMN_DONG)
	        	|| fn_isNull(gridDatatemp[i].SRA_MWMNNM)      || fn_isNull(gridDatatemp[i].CUS_MPNO)       || fn_isNull(gridDatatemp[i].CUS_RLNO)
	        	|| fn_isNull(gridDatatemp[i].SRA_FARM_CUS_MPNO)) {
	        			MessagePopup('OK','필수입력사항이 비어있습니다.');
	        			checkCnt++;
	        			return;
	        	}
	            
	        });

	        if(checkCnt == 0) {
	        	fn_ExcelDownlad('hdn_grd_MhSogCow13', '경매정보_연계');
	        }
	        
       		
        } else if($("#pb_tab14").hasClass("on")) {
        	fn_ExcelDownlad('grd_MhSogCow14', '구제역 예방접종 확인서');
        	
        } else if($("#pb_tab15").hasClass("on")) {
       		
        }
    	
    }
    /*------------------------
	  obj_dsc [],숫자 제거  
	-------------------------*/
	function fn_deleteNumber(dsc){
		var obj_dsc = dsc.substr(4,3);
		

		return  obj_dsc; 
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[경매일자 : ' + fn_toDate(fn_dateToData($('#auc_dt').val()), "KR") + ']'
       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
    	//TitleData.qcn = $("#qcn").val();
        
    	
    	if($("#pb_tab1").hasClass("on")){
    		
    		NA_BZPLNM = parent.wmcList.NA_BZPLNM;
    		ACNO = parent.wmcList.ACNO;
    		TitleData.title = "응찰자 개별 정산서 제"+ $("#qcn").val() + "차 "+fn_toDate(fn_dateToData($('#auc_dt').val()), "KR");
    		TitleData.sub_title = "입금 기준 일자 : "+fn_toDate(fn_dateToData($('#auc_dt').val()), "KR");
    		TitleData.unit = "";
    		TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM;
    		TitleData.acno = parent.wmcList[0].ACNO;
    		 
    		ReportPopup('LALM0513R0',TitleData, 'grd_MhSogCow1', 'V'); 
    		
    	}
    	
    	if($("#pb_tab2").hasClass("on")){
    		            
    		TitleData.title ="가축매매대금 영수증"+  fn_deleteNumber($( "#auc_obj_dsc option:selected").text()); 
    		TitleData.sub_title ="기준일 : "+ fn_toDate(fn_dateToData($('#auc_dt').val()), "KR"); 
    		TitleData.na_bzplc = $("#na_bzplc").val(); 
    		TitleData.bzno = parent.wmcList[0].BZNO;
    		TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM + " 조합장";
    		TitleData.wdong = parent.wmcList[0].DONGUP + " "+parent.wmcList[0].DONGBW;
    		TitleData.sealImg = parent.wmcList[0].SEAL_IMG_CNTN;
    		
    		ReportPopup('LALM0513R1',TitleData, 'grd_MhSogCow2,grd_MhSogCow2_1', 'V'); 
    	}

    	if($("#pb_tab3").hasClass("on")){
    		TitleData.title = fn_deleteNumber($( "#auc_obj_dsc option:selected").text())+ "출장우 내역(관리자용) 제"+  $("#qcn").val() + "차";
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
    	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + '] / [진행상태 : ' + $("#sel_sts_dsc option:selected").text() +']';
    		
    		ReportPopup('LALM0513R2',TitleData, 'grd_MhSogCow3', 'V'); 
    		
    	}
    	if($("#pb_tab4").hasClass("on")){
    		TitleData.title = "응찰자 미수금 현황 제"+ $("#qcn").val() + "차 /"+  fn_deleteNumber($( "#auc_obj_dsc option:selected").text());
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		
    		ReportPopup('LALM0513R3',TitleData, 'grd_MhSogCow4', 'V'); 
    		
    	}
    	
    	if($("#pb_tab5").hasClass("on")){
    		TitleData.title = fn_deleteNumber($( "#auc_obj_dsc option:selected").text()) +" 출장우 정산내역 제"+ $("#qcn").val() + "차 ( "+ fn_toDate(fn_dateToData($('#auc_dt').val()), "KR")+" )";
    		TitleData.sub_title = "(경매일자:"+$("#auc_dt").val()+")";
    		TitleData.unit = "";
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
    	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
    		
    		if (na_bzplc == '8808990656915') {                                         // 목포무안신안: 8808990656915 테스트: 8808990643625
	    		ReportPopup('LALM0513R13',TitleData, 'grd_MhSogCow5', 'V'); 
    		}else if(na_bzplc == "8808990656601"){      									// 함평: 8808990656601 테스트: 8808990643625
            	if($("#auc_obj_dsc").val() == '1'){
            		ReportPopup('LALM0513R4',TitleData, 'grd_MhSogCow5', 'V'); 
            	}else if($("#auc_obj_dsc").val() == '2'){
            		ReportPopup('LALM0513R14',TitleData, 'grd_MhSogCow5', 'V');	
            	}else if($("#auc_obj_dsc").val() == '3'){
         			ReportPopup('LALM0513R15',TitleData, 'grd_MhSogCow5', 'V');	
         		}
            }else if (na_bzplc == '8808990657103'){ //강진완도
            	 ReportPopup('LALM0513R15_1',TitleData, 'grd_MhSogCow5', 'V');         	
            }else{
            	 ReportPopup('LALM0513R15',TitleData, 'grd_MhSogCow5', 'V');         	
            }
    	}
    	
    	if($("#pb_tab6").hasClass("on")){
    		TitleData.title = fn_toDate(fn_dateToData($('#auc_dt').val()), "KR") +" 매도 농가 등록우 입금내역";
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
    	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + '] / [출하자 : ]';
    		
    		ReportPopup('LALM0513R5',TitleData, 'grd_MhSogCow6', 'V'); 
    		
    	}
    	
    	if($("#pb_tab7").hasClass("on")){
    		TitleData.title ="경매우 운송비 정산내역 제"+$("#qcn").val()+"차 ( "+fn_toDate(fn_dateToData($('#auc_dt').val()), "KR")+" )" ;
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		
    		ReportPopup('LALM0513R6',TitleData, 'grd_MhSogCow7', 'V'); 
    		
    	}
    	
    	if($("#pb_tab8").hasClass("on")){
    		TitleData.title ="경매 집계 표 제 "+ $("#qcn").val()+" 차";
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
 	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
    		TitleData.am_tot_su = $("#am_tot_su").val();
    		TitleData.su_tot_su = $("#su_tot_su").val();
    		TitleData.no_tot_su = $("#no_tot_su").val();
    		TitleData.etc_tot_su = $("#etc_tot_su").val();
    		
    		TitleData.sum7 = $("#sum7").val();
    		TitleData.sum8 = $("#sum8").val();
    		TitleData.sum9 = $("#sum9").val();
    		TitleData.sum10 = $("#sum10").val();
    		TitleData.sum11 = $("#sum11").val();
    		TitleData.sum12 = $("#sum12").val();
    		TitleData.sum13 = $("#sum13").val();
    		TitleData.sum14 = $("#sum14").val();
    	
    		TitleData.am_lows_sra_sbid_am = $("#am_lows_sra_sbid_am").val();
    		TitleData.am_max_sra_sbid_am = $("#am_max_sra_sbid_am").val();
    		TitleData.am_avg_sra_sbid_am = $("#am_avg_sra_sbid_am").val();
    		TitleData.am_lows_sra_mwmnnm = $("#am_lows_sra_mwmnnm").val();
    		TitleData.am_max_sra_mwmnnm = $("#am_max_sra_mwmnnm").val();

    		TitleData.su_lows_sra_sbid_am = $("#su_lows_sra_sbid_am").val();
    		TitleData.su_max_sra_sbid_am = $("#su_max_sra_sbid_am").val();
    		TitleData.su_avg_sra_sbid_am = $("#su_avg_sra_sbid_am").val();
    		TitleData.su_lows_sra_mwmnnm = $("#su_lows_sra_mwmnnm").val();
    		TitleData.su_max_sra_mwmnnm = $("#su_max_sra_mwmnnm").val();
    		
    		TitleData.no_lows_sra_sbid_am = $("#no_lows_sra_sbid_am").val();
    		TitleData.no_max_sra_sbid_am = $("#no_max_sra_sbid_am").val();
    		TitleData.no_avg_sra_sbid_am = $("#no_avg_sra_sbid_am").val();
    		TitleData.no_lows_sra_mwmnnm = $("#no_lows_sra_mwmnnm").val();
    		TitleData.no_max_sra_mwmnnm = $("#no_max_sra_mwmnnm").val();
    		
    		TitleData.etc_lows_sra_sbid_am = $("#etc_lows_sra_sbid_am").val();
    		TitleData.etc_max_sra_sbid_am = $("#etc_max_sra_sbid_am").val();
    		TitleData.etc_avg_sra_sbid_am = $("#etc_avg_sra_sbid_am").val();
    		TitleData.etc_lows_sra_mwmnnm = $("#etc_lows_sra_mwmnnm").val();
    		TitleData.etc_max_sra_mwmnnm = $("#etc_max_sra_mwmnnm").val();
    		
    		TitleData.sum_am_yu = $("#sum_am_yu").val();
    		TitleData.sum_su_yu = $("#sum_su_yu").val();
    		TitleData.sum_no_yu = $("#sum_no_yu").val();
    		TitleData.sum_etc_yu = $("#sum_etc_yu").val();
    		
    		ReportPopup('LALM0513R7',TitleData, 'grd_MhSogCow8', 'V');  
    		
    	}
    	
    	if($("#pb_tab9").hasClass("on")){
    		TitleData.title ="총 집계표 제" + $("#qcn").val()+"차 ( "+fn_toDate(fn_dateToData($('#auc_dt').val()), "KR")+" ) / "+  fn_deleteNumber($( "#auc_obj_dsc option:selected").text());
    		TitleData.sub_title = "("+ $('#auc_dt').val() +")";
    		TitleData.unit = "";
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
 	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
    		TitleData.FHS_SRA_UBD_FEE = $('#fhs_sra_ubd_fee').val();
    		TitleData.SEL_SRA_UBD_FEE = $('#sel_sra_ubd_fee').val();
    		TitleData.AM_UBD_HDCN = $('#am_ubd_hdcn').val();
    		TitleData.SU_UBD_HDCN = $('#su_ubd_hdcn').val();
    		
    		
    		
    		if (na_bzplc == '8808990659565'){ // 김천: 8808990659565(210720 김천 축협 요청에 의한 원복)
            	ReportPopup('LALM0513R8',TitleData, 'grd_MhSogCow9', 'V'); 
    		}else{
    			ReportPopup('LALM0513R8',TitleData, 'grd_MhSogCow9', 'V'); 
    		}
    	}
    	
    	if($("#pb_tab10").hasClass("on")){
    		TitleData.title ="중도매인 정산내역";
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
 	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
    		
    		ReportPopup('LALM0513R',TitleData, 'grd_ViewMhSogCow10', 'V'); 
    		
    	}
    	
    	if($("#pb_tab11").hasClass("on")){
    		
    		var tab11_results = sendAjaxFrm("frm_Search", "/LALM0513_selList_11_print", "POST");
    		var tab11_result;
    		if(tab11_results.status != RETURN_SUCCESS) {
            	showErrorMessage(tab11_results);
                return;                
             } else {
            	 tab11_result = setDecrypt(tab11_results);
             }
    	   
	       // 합계 그리드 
	       var searchResultColNames1 = ["경매날짜","경매대상","출하자코드","출하자명", "주소"];        
	       
	       var searchResultColModel1 = [
	        							 {name:"AUC_DT",      index:"AUC_DT",      width:80, align:'center', },
	        							 {name:"AUC_OBJ_DSC", index:"AUC_OBJ_DSC", width:65,  align:'center' , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
	        							 {name:"FHS_ID_NO",   index:"FHS_ID_NO",   width:80, align:'center', },
	        							 {name:"FTSNM",       index:"FTSNM",       width:80, align:'center'},
	                                     {name:"ADR",         index:"ADR",         width:100, align:'center'},
	                                    ];
	           
	       $("#grd_MhSogCow11_1").jqGrid("GridUnload");
	               
	       $("#grd_MhSogCow11_1").jqGrid({
	       	    datatype:    "local",
	            data:        tab11_result,
	            height:      400,
	            resizeing:   true,
	            autowidth:   false,
	            shrinkToFit: false,
	            rownumbers:  true,
	            hi :     true,
	            rownumWidth: 40,
	            colNames: searchResultColNames1,
	            colModel: searchResultColModel1, 
	        });
    		
    		TitleData.title ="출하자 정산내역";
    		TitleData.sub_title = " "+"님의" +  fn_deleteNumber($( "#auc_obj_dsc option:selected").text()) + " 매매가 이루어졌습니다.";
    		TitleData.unit = "";
    		
    		ReportPopup('LALM0513R9',TitleData, 'grd_MhSogCow11,grd_MhSogCow11_1', 'V'); 
    		
    	}
    	
    	if($("#pb_tab12").hasClass("on")){
    		TitleData.title ="수의사 지급내역";
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
 	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']'+' / [수의사명 : ]';
    		
            	ReportPopup('LALM0513R10',TitleData, 'grd_MhSogCow12', 'V'); 
    		
    	}

    	if($("#pb_tab14").hasClass("on")){
    		TitleData.title ="출생신고서";
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM;
    		TitleData.srch_condition=  '[경매일자 : ' + $('#auc_dt').val() + ']'
 	       +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
            	ReportPopup('LALM0513R11',TitleData, 'grd_MhSogCow14', 'V'); 
    		
    	}
    
    	if($("#pb_tab15").hasClass("on")){
    		TitleData.title ="수의사 지급내역";
    		TitleData.sub_title = "";
    		TitleData.unit = "";
    		
    		ReportPopup('LALM0513R12',TitleData, 'grd_MhSogCow15', 'V'); 
    		
    	}
    }
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    // 낙찰자 정산서 뷰그리드 생성
    function fn_CreateViewGrid(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["성별","참가번호", "성명", "경매번호", "주소", "낙찰금액", "판매 수수료", "기타 수수료", "참가 보증금", "정산금액", "입금액", "미납입금액"];        
		var searchResultColModel = [
                                    {name:"INDV_SEX_C",                index:"INDV_SEX_C",                width:50, align:'center', hidden:true},
                                    {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",        width:50, align:'center'},
                                    {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",                width:60, align:'center'},
                                    {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",                width:40, align:'center', sorttype: "number"},
                                    {name:"ADR",                       index:"ADR",                       width:200,align:'left'},
                                    {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",               width:65, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"SRA_SEL_FEE",               index:"SRA_SEL_FEE",               width:65, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"SRA_ETC_CST",               index:"SRA_ETC_CST",               width:65, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"AUC_ENTR_GRN_AM",           index:"AUC_ENTR_GRN_AM",           width:65, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"IO_AM_15",                  index:"IO_AM_15",                  width:65, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"SRA_RV_AM",                 index:"SRA_RV_AM",                 width:65, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"NOTPAY",                    index:"NOTPAY",                    width:65, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
                                    ];

            
        $("#grd_ViewMhSogCow1").jqGrid("GridUnload");
                
        $("#grd_ViewMhSogCow1").jqGrid({
        	datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            gridComplete:function(rowid,status, e){
            	var rows = $("#grd_ViewMhSogCow1").getDataIDs();
            	for(var i = 0; i < rows.length; i++) {
            		var status = $("#grd_ViewMhSogCow1").getCell(rows[i], "LVST_AUC_PTC_MN_NO");
            		if(status == "소계") {
            			$("#grd_ViewMhSogCow1").jqGrid("setRowData", rows[i], false, {background:"skyblue"});
            		}
            	}
            },
            onSelectRow:function(rowid,status, e){
            }
        });
        //행번호
        $("#grd_ViewMhSogCow1").jqGrid("setLabel", "rn","No"); 
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        
    }
    
    // 낙찰자 정산서 그리드 생성
    function fn_CreateGrid(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["성별","참가번호", "성명", "경매번호", "주소", "낙찰금액", "판매 수수료", "기타 수수료", "참가 보증금", "정산금액", "입금액", "미납입금액"];        
		var searchResultColModel = [
                                    {name:"INDV_SEX_C",                index:"INDV_SEX_C",                width:50, align:'center', hidden:true},
                                    {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",        width:50, align:'center'},
                                    {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",                width:60, align:'center'},
                                    {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",                width:40, align:'center'},
                                    {name:"ADR",                       index:"ADR",                       width:200,align:'left'},
                                    {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",               width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"SRA_SEL_FEE",               index:"SRA_SEL_FEE",               width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"SRA_ETC_CST",               index:"SRA_ETC_CST",               width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                    {name:"AUC_ENTR_GRN_AM",           index:"AUC_ENTR_GRN_AM",           width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
        /*정산금액*/                {name:"IO_AM_15",                  index:"IO_AM_15",                  width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
        /*입금액*/                  {name:"SRA_RV_AM",                 index:"SRA_RV_AM",                 width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
        /*미납입*/                  {name:"NOTPAY",                    index:"NOTPAY",                    width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
                                    ];

            
        $("#grd_MhSogCow1").jqGrid("GridUnload");
                
        $("#grd_MhSogCow1").jqGrid({
        	 datatype:    "local",
             data:        data,
             height:      500,
             rowNum:      rowNoValue,
             resizeing:   true,
             autowidth:   false,
             shrinkToFit: false,
             rownumbers:  true,
             rownumWidth: 40,
             colNames: searchResultColNames,
             colModel: searchResultColModel,          
             onSelectRow:function(rowid,status, e){
             }
        });
        //행번호
        $("#grd_MhSogCow1").jqGrid("setLabel", "rn","No"); 
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        
        if(data != null) {
        	var data2 = new Array();
        	var dataItem = new Object();
        	var l_LVST_AUC_PTC_MN_NO 	= "";
        	var l_SRA_SBID_AM 			= 0;
        	var l_SRA_SEL_FEE 			= 0;
        	var l_SRA_ETC_CST 			= 0;
        	var l_AUC_ENTR_GRN_AM 		= 0;
//         	var l_IO_AM_15 				= 0;
//         	var l_SRA_RV_AM 			= 0;
//         	var l_NOTPAY 				= 0;
        	
        	$.each(data, function(i){
        		if(i != 0 && l_LVST_AUC_PTC_MN_NO != data[i].LVST_AUC_PTC_MN_NO) {
        			dataItem = new Object();
        			dataItem['LVST_AUC_PTC_MN_NO'] = "소계";
                	dataItem['SRA_SBID_AM'] 	= l_SRA_SBID_AM;
                	dataItem['SRA_SEL_FEE'] 	= l_SRA_SEL_FEE;
                	dataItem['SRA_ETC_CST'] 	= l_SRA_ETC_CST;
                	dataItem['AUC_ENTR_GRN_AM'] = l_AUC_ENTR_GRN_AM;
//                 	dataItem['IO_AM_15'] 		= l_IO_AM_15;
//                 	dataItem['SRA_RV_AM'] 		= l_SRA_RV_AM;
//                 	dataItem['NOTPAY'] 			= l_NOTPAY;
                	
                	l_LVST_AUC_PTC_MN_NO 	= "";
                	l_SRA_SBID_AM 			= 0;
                	l_SRA_SEL_FEE 			= 0;
                	l_SRA_ETC_CST 			= 0;
                	l_AUC_ENTR_GRN_AM 		= 0;
//                 	l_IO_AM_15 				= 0;
//                 	l_SRA_RV_AM 			= 0;
//                 	l_NOTPAY 				= 0;
        			
        			data2.push(dataItem);
        		}
        		
        		data2.push(data[i]);
        		l_LVST_AUC_PTC_MN_NO = data[i].LVST_AUC_PTC_MN_NO;
        		l_SRA_SBID_AM = parseInt(l_SRA_SBID_AM) + parseInt(data[i].SRA_SBID_AM);
        		l_SRA_SEL_FEE = parseInt(l_SRA_SEL_FEE) + parseInt(data[i].SRA_SEL_FEE);
        		l_SRA_ETC_CST = parseInt(l_SRA_ETC_CST) + parseInt(data[i].SRA_ETC_CST);
        		l_AUC_ENTR_GRN_AM = parseInt(l_AUC_ENTR_GRN_AM) + parseInt(data[i].AUC_ENTR_GRN_AM);
//         		l_IO_AM_15 = parseInt(l_IO_AM_15) + parseInt(data[i].IO_AM_15);
//         		l_SRA_RV_AM = parseInt(l_SRA_RV_AM) + parseInt(data[i].SRA_RV_AM);
//         		l_NOTPAY = parseInt(l_NOTPAY) + parseInt(data[i].NOTPAY);
        		
        	});
        	dataItem = new Object();
			dataItem['LVST_AUC_PTC_MN_NO'] = "소계";
			dataItem['SRA_SBID_AM'] 	= l_SRA_SBID_AM;
        	dataItem['SRA_SEL_FEE'] 	= l_SRA_SEL_FEE;
        	dataItem['SRA_ETC_CST'] 	= l_SRA_ETC_CST;
        	dataItem['AUC_ENTR_GRN_AM'] = l_AUC_ENTR_GRN_AM;
//         	dataItem['IO_AM_15'] 		= l_IO_AM_15;
//         	dataItem['SRA_RV_AM'] 		= l_SRA_RV_AM;
//         	dataItem['NOTPAY'] 			= l_NOTPAY;
			data2.push(dataItem);
			
			fn_CreateViewGrid(data2);
        }
        
    }
    
    // 매매대금영수증 그리드 생성
	function fn_CreateGrid_2(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["H총매매수수료","H낙찰가격","H동이상주소","H동이하주소","H산차","경매일자","참가번호", "낙찰자", "경매번호", "주소", "출하자코드", "출하자명", "전화번호", "귀표번호", "생년월일", 
        							"중량(Kg)", "어미구분", "아비KPN", "성별", "낙찰가격", "총 매매 수수료"];        
        
        var searchResultColModel = [
         							 {name:"FEE_AM",                    index:"FEE_AM",                   width:80, align:'center', hidden: true },
         							 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:80, align:'center', hidden: true },
         							 {name:"FHS_DONGUP",                index:"FHS_DONGUP",               width:80, align:'center', hidden: true },
         							 {name:"FHS_DONGBW",                index:"FHS_DONGBW",               width:80, align:'center', hidden: true },
         							 {name:"MATIME",                    index:"MATIME",                   width:80, align:'center', hidden: true },
         							 {name:"AUC_DT",                    index:"AUC_DT",                   width:80, align:'center',formatter:'gridDateFormat'},
                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:80, align:'center'},
                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:100, align:'center'},
                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:100, align:'center'},
                                     {name:"ADR",                       index:"ADR",                      width:250, align:'left'},
                                     {name:"FHS_ID_NO",                 index:"FHS_ID_NO",                width:120, align:'center'},
                                     {name:"FTSNM",                     index:"FTSNM",                    width:100, align:'center'},
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:100, align:'center'},
                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:150, align:'center'},
                                     {name:"BIRTH",                     index:"BIRTH",                    width:100, align:'center',formatter:'gridDateFormat'},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:100, align:'center'},
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:80, align:'center' , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"FEE_AM",                    index:"FEE_AM",                   width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
                                     ];
            
        $("#grd_MhSogCow2").jqGrid("GridUnload");
                
        $("#grd_MhSogCow2").jqGrid({
        	 datatype:    "local",
             data:        data,
             height:      500,
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

        var tot_sra_sbid_am = 0; //총 낙찰가격
        var tot_fee_am 	    = 0; //총 매매 수수료       
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_sbid_am = parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
        	tot_fee_am      = parseInt(tot_fee_am) + parseInt(gridDatatemp[i].FEE_AM);
      
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_DT"         ,"합  계"           	   ,6 ,"String"]
               ,["SRA_SBID_AM"    ,tot_sra_sbid_am  	   ,1 ,"Integer"]               
               ,["FEE_AM"         ,tot_fee_am              ,1 ,"Integer"]               
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow2', arr);
        
        if(data != null) {
        	var data2 = new Array();
        	var dataItem = new Object();
        	var l_LVST_AUC_PTC_MN_NO = '';
        	$.each(data, function(i){
        		if(i == 0 || l_LVST_AUC_PTC_MN_NO != data[i].LVST_AUC_PTC_MN_NO ){
        			if(i != 0) data2.push(dataItem);
        			dataItem = new Object();
        			dataItem['SRA_MWMNNM'] = data[i].SRA_MWMNNM;
        			dataItem['ADR'] = data[i].ADR;
        			dataItem['LVST_AUC_PTC_MN_NO'] = data[i].LVST_AUC_PTC_MN_NO;
        			dataItem['FEE_AM'] = 0;
        			dataItem['SRA_SBID_AM'] = 0;
        			l_LVST_AUC_PTC_MN_NO = data[i].LVST_AUC_PTC_MN_NO;
        		}         		
        		dataItem['FEE_AM'] = dataItem['FEE_AM'] + data[i].FEE_AM;
    			dataItem['SRA_SBID_AM'] = dataItem['SRA_SBID_AM'] + data[i].SRA_SBID_AM;  
        	});
        	data2.push(dataItem);
            
        
	        var rowNoValue2 = 0;     
	        if(data2 != null){
	            rowNoValue2 = data2.length;
	        }
	        
	        
	        // 합계 그리드 
	        var searchResultColNames1 = ["H총매매수수료","H낙찰가격","H동이상이하주소","참가번호", "낙찰자"];        
	        
	        var searchResultColModel1 = [
	         							 {name:"FEE_AM",                    index:"FEE_AM",                   width:80, align:'center', },
	         							 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:80, align:'center', },
	         							 {name:"ADR",                       index:"ADR",                      width:80, align:'center', },
	         							 {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:80, align:'center'},
	                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:100, align:'center'},
	                                     ];
	            
	        $("#grd_MhSogCow2_1").jqGrid("GridUnload");
	                
	        $("#grd_MhSogCow2_1").jqGrid({
	        	 datatype:    "local",
	             data:        data2,
	             height:      500,
	             rowNum:      rowNoValue2,
	             resizeing:   true,
	             autowidth:   false,
	             shrinkToFit: false,
	             rownumbers:  true,
	             hi :     true,
	             rownumWidth: 40,
	             colNames: searchResultColNames1,
	             colModel: searchResultColModel1, 
	         });
	        
	        
	        // View Grid
	        var data3 = new Array();
        	var dataItem = new Object();
        	var l_LVST_AUC_PTC_MN_NO 	= "";
        	var l_AUC_DT 				= "";
        	var l_BIRTH  				= "";
        	var l_SRA_SBID_AM 			= 0;
        	var l_FEE_AM 			   	= 0;
        	var l_COW_SOG_WT			= 0;
        	
        	$.each(data, function(i){
        		if(i != 0 && l_LVST_AUC_PTC_MN_NO != data[i].LVST_AUC_PTC_MN_NO) {
        			dataItem = new Object();
        			dataItem['AUC_DT'] = l_AUC_DT;
        			dataItem['LVST_AUC_PTC_MN_NO'] = "소계";
        			dataItem['BIRTH'] 			= l_BIRTH;
                	dataItem['SRA_SBID_AM'] 	= l_SRA_SBID_AM;
                	dataItem['FEE_AM'] 			= l_FEE_AM;
                	dataItem['COW_SOG_WT'] 		= l_COW_SOG_WT;
                	
                	l_LVST_AUC_PTC_MN_NO 	= "";
                	l_AUC_DT 				= "";
                	l_SRA_SBID_AM 			= 0;
                	l_FEE_AM 				= 0;
                	l_COW_SOG_WT			= 0;
        			
        			data3.push(dataItem);
        		}
        		
        		data3.push(data[i]);
        		l_LVST_AUC_PTC_MN_NO = data[i].LVST_AUC_PTC_MN_NO;
        		l_AUC_DT 		= data[i].AUC_DT;
        		l_SRA_SBID_AM 	= parseInt(l_SRA_SBID_AM) + parseInt(data[i].SRA_SBID_AM);
        		l_FEE_AM 		= parseInt(l_FEE_AM) + parseInt(data[i].FEE_AM);
        		l_COW_SOG_WT	= parseInt(l_COW_SOG_WT) + parseInt(data[i].COW_SOG_WT);
        		
        	});
        	dataItem = new Object();
        	dataItem['AUC_DT'] = l_AUC_DT;
        	dataItem['LVST_AUC_PTC_MN_NO'] = "소계";
        	dataItem['BIRTH'] 			= l_BIRTH;
        	dataItem['SRA_SBID_AM'] 	= l_SRA_SBID_AM;
        	dataItem['FEE_AM'] 			= l_FEE_AM;
        	dataItem['COW_SOG_WT'] 		= l_COW_SOG_WT;
			data3.push(dataItem);
			
			var rowNoValue3 = 0;     
	        if(data3 != null){
	            rowNoValue3 = data3.length;
	        }
	        
	        var searchResultColNames = ["H총매매수수료","H낙찰가격","H동이상주소","H동이하주소","H산차","경매일자","참가번호", "낙찰자", "경매번호", "주소", "출하자코드", "출하자명", "전화번호", "귀표번호", "생년월일", 
	        							"중량(Kg)", "어미구분", "아비KPN", "성별", "낙찰가격", "총 매매 수수료"];        
	        
	        var searchResultColModel = [
	         							 {name:"FEE_AM",                    index:"FEE_AM",                   width:80, align:'center', hidden: true },
	         							 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:80, align:'center', hidden: true },
	         							 {name:"FHS_DONGUP",                index:"FHS_DONGUP",               width:80, align:'center', hidden: true },
	         							 {name:"FHS_DONGBW",                index:"FHS_DONGBW",               width:80, align:'center', hidden: true },
	         							 {name:"MATIME",                    index:"MATIME",                   width:80, align:'center', hidden: true },
	         							 {name:"AUC_DT",                    index:"AUC_DT",                   width:80, align:'center',formatter:'gridDateFormat'},
	                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:80, align:'center'},
	                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:100, align:'center'},
	                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:100, align:'center', sorttype: "number"},
	                                     {name:"ADR",                       index:"ADR",                      width:250, align:'left'},
	                                     {name:"FHS_ID_NO",                 index:"FHS_ID_NO",                width:120, align:'center'},
	                                     {name:"FTSNM",                     index:"FTSNM",                    width:100, align:'center'},
	                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:100, align:'center'},
	                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:150, align:'center'},
	                                     {name:"BIRTH",                     index:"BIRTH",                    width:100, align:'center',formatter:'gridDateFormat'},
	                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:100, align:'center'},
	                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:80, align:'center' , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                     {name:"FEE_AM",                    index:"FEE_AM",                   width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
	                                     ];
	            
	        $("#grd_ViewMhSogCow2").jqGrid("GridUnload");
	                
	        $("#grd_ViewMhSogCow2").jqGrid({
	        	 datatype:    "local",
	             data:        data3,
	             height:      500,
	             rowNum:      rowNoValue3,
	             resizeing:   true,
	             autowidth:   false,
	             shrinkToFit: false,
	             rownumbers:  true,
	             rownumWidth: 40,
	             footerrow: true,
	             userDataOnFooter: true,
	             colNames: searchResultColNames,
	             colModel: searchResultColModel,
	             gridComplete:function(rowid,status, e){
	             	var rows = $("#grd_ViewMhSogCow2").getDataIDs();
	             	for(var i = 0; i < rows.length; i++) {
	             		var status = $("#grd_ViewMhSogCow2").getCell(rows[i], "LVST_AUC_PTC_MN_NO");
	             		if(status == "소계") {
	             			$("#grd_ViewMhSogCow2").jqGrid("setRowData", rows[i], false, {background:"skyblue"});
	             		}
	             	}
	             },
	             onSelectRow:function(rowid,status, e){
	             },
	         });
	        //행번호
	        $("#grd_ViewMhSogCow2").jqGrid("setLabel", "rn","No"); 
	    	
	       //합계행에 가로스크롤이 있을경우 추가
	        var $obj = document.getElementById('grd_ViewMhSogCow2');
	        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

	        $bDiv.css({'overflow-x':'hidden'});
	        $sDiv.css({'overflow-x':'scroll'});
	        $sDiv.scroll(function(){
	            $bDiv.scrollLeft($sDiv.scrollLeft());
	        });
	        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
	        $("#grd_ViewMhSogCow2 .jqgfirstrow td:last-child").width($("#grd_ViewMhSogCow2 .jqgfirstrow td:last-child").width() - 17);     
	        
	      
	        //footer        
	        var gridDatatemp = $('#grd_ViewMhSogCow2').getRowData();

	        var tot_sra_sbid_am = 0; //총 낙찰가격
	        var tot_fee_am 	    = 0; //총 매매 수수료       
	        
	        $.each(gridDatatemp, function(i){
	        	if(gridDatatemp[i].LVST_AUC_PTC_MN_NO != "소계") {
	        		tot_sra_sbid_am = parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
		        	tot_fee_am      = parseInt(tot_fee_am) + parseInt(gridDatatemp[i].FEE_AM);
	        	}
	        });        
	        
	        var arr = [
	 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
	                ["AUC_DT"         ,"합  계"           	   ,6 ,"String"]
	               ,["SRA_SBID_AM"    ,tot_sra_sbid_am  	   ,1 ,"Integer"]               
	               ,["FEE_AM"         ,tot_fee_am              ,1 ,"Integer"]               
	           ] 	       
	 	       
	        ];
	 
	        fn_setGridFooter('grd_ViewMhSogCow2', arr);
        }
    }
    
    
	function fn_CreateGrid_3(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자", "경매번호", "주소", "출하자코드", "출하자명", "귀표번호", "생년월일", "산차", "어미구분", "계대", "전화번호", "아비KPN", "성별", "중량(Kg)", 
        							"예정가", "낙찰단가", "낙찰가", "수송자", "진행상태", "낙찰자", "응찰번호"];        
        
        var searchResultColModel = [
         							 {name:"AUC_DT",                    index:"AUC_DT",                   width:80,  align:'center',formatter:'gridDateFormat'},
                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:80,  align:'center', sorttype: "number"},
                                     {name:"ADR",                       index:"ADR",                      width:250, align:'left'},
                                     {name:"FHS_ID_NO",                 index:"FHS_ID_NO",                width:100, align:'center'},
                                     {name:"FTSNM",                     index:"FTSNM",                    width:80,  align:'center'},
                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:120, align:'center'},
                                     {name:"BIRTH",                     index:"BIRTH",                    width:80,  align:'center', formatter:'gridDateFormat'},
                                     {name:"MATIME",                    index:"MATIME",                   width:50,  align:'center'},
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:50,  align:'center'},
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:100, align:'center'},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:80,  align:'center'},
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:120, align:'right'},
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:80,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:100, align:'center'},
                                     {name:"SEL_STS_DSC",               index:"SEL_STS_DSC",              width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:100, align:'center'},
                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:80,  align:'center'}
                                   ];
            
        $("#grd_MhSogCow3").jqGrid("GridUnload");
                
        $("#grd_MhSogCow3").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: true,
            rownumbers:  true,
            rownumWidth: 30,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
            onSelectRow:function(rowid,status, e){
            }
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

        var tot_sra_sbid_am = 0; //총 낙찰가격
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_sbid_am = parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
      
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_DT"         ,"합  계"           	   ,6 ,"String"]
               ,["SRA_SBID_AM"    ,tot_sra_sbid_am  	   ,1 ,"Integer"]               
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow3', arr);
        
        if(data != null) {
	        // View Grid
	        var data2 = new Array();
        	var dataItem = new Object();
        	var l_AUC_DT 				= "";
        	var l_FHS_ID_NO				= "";
        	var l_FTSNM  				= "";
        	var l_SRA_SBID_AM 			= 0;
        	//AUC_DT, FHS_ID_NO, FTSNM
        	//SRA_SBID_AM
        	
        	$.each(data, function(i){
        		if(i != 0 && (l_AUC_DT != data[i].AUC_DT || l_FHS_ID_NO != data[i].FHS_ID_NO || l_FTSNM != data[i].FTSNM)) {
        			dataItem = new Object();
        			dataItem['AUC_DT'] = "";
                	dataItem['AUC_PRG_SQ'] = "소계";
                	dataItem['BIRTH'] = "";
                	dataItem['SRA_SBID_AM']	= l_SRA_SBID_AM;
                	
                	l_AUC_DT 		= "";
                	l_FHS_ID_NO 	= "";
                	l_FTSNM 		= "";
                	l_SRA_SBID_AM 	= 0;
        			
        			data2.push(dataItem);
        		}
        		
        		data2.push(data[i]);
        		
        		l_AUC_DT 		= data[i].AUC_DT;
        		l_FHS_ID_NO 	= data[i].FHS_ID_NO;
        		l_FTSNM 		= data[i].FTSNM;
        		
        		l_SRA_SBID_AM 	= parseInt(l_SRA_SBID_AM) + parseInt(data[i].SRA_SBID_AM);
        		
        	});
        	dataItem = new Object();
        	dataItem['AUC_DT'] = "";
        	dataItem['AUC_PRG_SQ'] = "소계";
        	dataItem['BIRTH'] = "";
        	dataItem['SRA_SBID_AM'] 		= l_SRA_SBID_AM;
			data2.push(dataItem);
			
			var rowNoValue = 0;     
	        if(data2 != null){
	            rowNoValue2 = data2.length;
	        }
	        
	        var searchResultColNames = ["경매일자", "경매번호", "주소", "출하자코드", "출하자명", "귀표번호", "생년월일", "산차", "어미구분", "계대", "전화번호", "아비KPN", "성별", "중량(Kg)", 
	        							"예정가", "낙찰단가", "낙찰가", "수송자", "진행상태", "낙찰자", "응찰번호"];        
	        
	        var searchResultColModel = [
	         							 {name:"AUC_DT",                    index:"AUC_DT",                   width:80,  align:'center',formatter:'gridDateFormat'},
	                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:80,  align:'center', sorttype: "number"},
	                                     {name:"ADR",                       index:"ADR",                      width:250, align:'left'},
	                                     {name:"FHS_ID_NO",                 index:"FHS_ID_NO",                width:100, align:'center'},
	                                     {name:"FTSNM",                     index:"FTSNM",                    width:80,  align:'center'},
	                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:120, align:'center'},
	                                     {name:"BIRTH",                     index:"BIRTH",                    width:80,  align:'center', formatter:'gridDateFormat'},
	                                     {name:"MATIME",                    index:"MATIME",                   width:50,  align:'center'},
	                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:50,  align:'center'},
	                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:100, align:'center'},
	                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:80,  align:'center'},
	                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:120, align:'right'},
	                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:80,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                     {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                     {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:100, align:'center'},
	                                     {name:"SEL_STS_DSC",               index:"SEL_STS_DSC",              width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
	                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:100, align:'center'},
	                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:80,  align:'center'}
	                                   ];
	            
	        $("#grd_ViewMhSogCow3").jqGrid("GridUnload");
	                
	        $("#grd_ViewMhSogCow3").jqGrid({
	            datatype:    "local",
	            data:        data2,
	            height:      500,
	            rowNum:      rowNoValue2,
	            resizeing:   true,
	            autowidth:   false,
	            shrinkToFit: true,
	            rownumbers:  true,
	            rownumWidth: 30,
	            footerrow: true,
	            userDataOnFooter: true,
	            colNames: searchResultColNames,
	            colModel: searchResultColModel,
	            gridComplete:function(rowid,status, e){
	             	var rows = $("#grd_ViewMhSogCow3").getDataIDs();
	             	for(var i = 0; i < rows.length; i++) {
	             		var status = $("#grd_ViewMhSogCow3").getCell(rows[i], "AUC_PRG_SQ");
	             		if(status == "소계") {
	             			$("#grd_ViewMhSogCow3").jqGrid("setRowData", rows[i], false, {background:"skyblue"});
	             		}
	             	}
	             },
	            onSelectRow:function(rowid,status, e){
	            }
	        });
	        //행번호
	        $("#grd_ViewMhSogCow3").jqGrid("setLabel", "rn","No"); 
	        
	      	//합계행에 가로스크롤이 있을경우 추가
	      	var $obj = document.getElementById('grd_ViewMhSogCow3');
	        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

	        $bDiv.css({'overflow-x':'hidden'});
	        $sDiv.css({'overflow-x':'scroll'});
	        $sDiv.scroll(function(){
	            $bDiv.scrollLeft($sDiv.scrollLeft());
	        });
	        
	        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
	        $("#grd_ViewMhSogCow3 .jqgfirstrow td:last-child").width($("#grd_ViewMhSogCow3 .jqgfirstrow td:last-child").width() - 17);
	        
	      	//footer        
	        var gridDatatemp = $('#grd_ViewMhSogCow3').getRowData();

	        var tot_sra_sbid_am = 0; //총 낙찰가격
	        
	        $.each(gridDatatemp, function(i){
	        	if(gridDatatemp[i].AUC_PRG_SQ != "소계") {
	        		tot_sra_sbid_am = parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
	        	}
	        });        
	        
	        var arr = [
	 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
	                ["AUC_DT"         ,"합  계"           	   ,6 ,"String"]
	               ,["SRA_SBID_AM"    ,tot_sra_sbid_am  	   ,1 ,"Integer"]               
	           ] 	       
	 	       
	        ];
	 
	        fn_setGridFooter('grd_ViewMhSogCow3', arr);
	       
        }
        
    }
	
	
	function fn_CreateGrid_4(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["경매일자", "참가번호", "응찰자코드", "응찰자명", "두수", "낙찰금액", "수수료", "총금액", "입찰보증금", "현금입금", "수표입금", 
        							"통장입금", "기타입금", "입금총액", "미수금", "고객휴대폰", "전화번호"];        
        
        var searchResultColModel = [
         							 {name:"AUC_DT",                    index:"AUC_DT",                   width:85, align:'center',formatter:'gridDateFormat'},
                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:65, align:'center'},
         							 {name:"TRMN_AMNNO",                index:"TRMN_AMNNO",               width:65, align:'center'},
                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:65, align:'center'},
                                     {name:"SRA_AUC_SBID_HDCN",         index:"SRA_AUC_SBID_HDCN",        width:65, align:'center', sorttype: "number"},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"TOT_FEE",                   index:"TOT_FEE",                  width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"TOT_AM",                    index:"TOT_AM",                   width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"AUC_ENTR_GRN_AM",           index:"AUC_ENTR_GRN_AM",          width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
         							 {name:"CSH_RV_AM",                 index:"CSH_RV_AM",                width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
         							 {name:"CK_RV_AM",                  index:"CK_RV_AM",                 width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"FTR_AM",                    index:"FTR_AM",                   width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"ETC_RV_AM",                 index:"ETC_RV_AM",                width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_RV_AM",                 index:"SRA_RV_AM",                width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"NPAY_AM",                   index:"NPAY_AM",                  width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:90, align:'center'},
                                     {name:"OHSE_TELNO",                index:"OHSE_TELNO",               width:90, align:'center'}
                                    ];
            
        $("#grd_MhSogCow4").jqGrid("GridUnload");
                
        $("#grd_MhSogCow4").jqGrid({
        	datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 40,
            sortable: true,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
            ondblClickRow: function(rowid, iRow, iCol){
                var sel_data = $("#grd_MhSogCow4").getRowData(rowid);
                
                var data = new Object();                
                data["na_bzplc"] = na_bzplc;
                data["auc_obj_dsc"] = $("#auc_obj_dsc").val();
                data["auc_dt"] = sel_data.AUC_DT;           
                data["trmn_amnno"] = sel_data.TRMN_AMNNO;
                data["lvst_auc_ptc_mn_no"] = sel_data.LVST_AUC_PTC_MN_NO;
                data["sra_mwmnnm"] = sel_data.SRA_MWMNNM;
                
                fn_OpenMenu('LALM0412',data);

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
        
      	//footer        
        var gridDatatemp = $('#grd_MhSogCow4').getRowData();

        var tot_sra_auc_sbid_hdcn 	= 0; 	// 총 두수
        var tot_sra_sbid_am			= 0; 	// 총 낙찰 금액
        var tot_tot_fee 			= 0; 	// 총 수수료
        var tot_tot_am 				= 0; 	// 총 금액
        var tot_auc_entr_grn_am 	= 0; 	// 총 입찰 보증금
        var tot_csh_rv_am 			= 0; 	// 총 현금입금
        var tot_ck_rv_am 			= 0; 	// 총 수표입금
        var tot_ftr_am 				= 0; 	// 총 통장입금
        var tot_etc_rv_am 			= 0; 	// 총 기타입금
        var tot_sra_rv_am 			= 0; 	// 총 입금총액
        var tot_npay_am 			= 0; 	// 총 미수금
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_auc_sbid_hdcn 	= parseInt(tot_sra_auc_sbid_hdcn) + parseInt(gridDatatemp[i].SRA_AUC_SBID_HDCN);
            tot_sra_sbid_am			= parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
            tot_tot_fee 			= parseInt(tot_tot_fee) + parseInt(gridDatatemp[i].TOT_FEE);
            tot_tot_am 				= parseInt(tot_tot_am) + parseInt(gridDatatemp[i].TOT_AM);
            tot_auc_entr_grn_am 	= parseInt(tot_auc_entr_grn_am) + parseInt(gridDatatemp[i].AUC_ENTR_GRN_AM);
            tot_csh_rv_am 			= parseInt(tot_csh_rv_am) + parseInt(gridDatatemp[i].CSH_RV_AM);
            tot_ck_rv_am 			= parseInt(tot_ck_rv_am) + parseInt(gridDatatemp[i].CK_RV_AM);
            tot_ftr_am 				= parseInt(tot_ftr_am) + parseInt(gridDatatemp[i].FTR_AM);
            tot_etc_rv_am 			= parseInt(tot_etc_rv_am) + parseInt(gridDatatemp[i].ETC_RV_AM);
            tot_sra_rv_am 			= parseInt(tot_sra_rv_am) + parseInt(gridDatatemp[i].SRA_RV_AM);
            tot_npay_am 			= parseInt(tot_npay_am) + parseInt(gridDatatemp[i].NPAY_AM);
            
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_DT"         		,"합  계"           	   	,4 ,"String"]
               ,["SRA_AUC_SBID_HDCN"	,tot_sra_auc_sbid_hdcn	,1 ,"Integer"]
               ,["SRA_SBID_AM"    		,tot_sra_sbid_am  	   	,1 ,"Integer"]
               ,["TOT_FEE"    			,tot_tot_fee  	   		,1 ,"Integer"]
               ,["TOT_AM"    			,tot_tot_am  	   		,1 ,"Integer"]
               ,["AUC_ENTR_GRN_AM"    	,tot_auc_entr_grn_am  	,1 ,"Integer"]
               ,["CSH_RV_AM"    		,tot_csh_rv_am  	   	,1 ,"Integer"]
               ,["CK_RV_AM"    			,tot_ck_rv_am  	   		,1 ,"Integer"]
               ,["FTR_AM"    			,tot_ftr_am  	   		,1 ,"Integer"]
               ,["ETC_RV_AM"    		,tot_etc_rv_am  	   	,1 ,"Integer"]
               ,["SRA_RV_AM"    		,tot_sra_rv_am  	   	,1 ,"Integer"]
               ,["NPAY_AM"    			,tot_npay_am  	   		,1 ,"Integer"]
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow4', arr);
        
    }
	
	
function fn_CreateGrid_5(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["H기타수수료","h운송비","H출하수수료","H사고적립금","H계좌번호마스킹"
        							,"경매대상", "경매번호", "출하자코드", "경제통합 거래처코드", "출하자명", "출하자 생년월일", "주소", "핸드폰", "귀표번호", "진행상태", "성별", 
        							"생년월일", "월령", "중량(Kg)", "예정가", "낙찰단가", "낙찰가격", "수수료", "정산금액", "예금주", "계좌번호", "수송자", "낙찰자수수료", "낙찰자"];        
        
        var searchResultColModel = [
         							 {name:"SRA_ETC_CST",               index:"SRA_ETC_CST",              width:65,  align:'center', hidden: true},
         							 {name:"SRA_TRPCS",                 index:"SRA_TRPCS",                width:65,  align:'center', hidden: true},
         							 {name:"SRA_SOG_FEE",               index:"SRA_SOG_FEE",              width:65,  align:'center', hidden: true},
         							 {name:"ACD_RVG_AM",                index:"ACD_RVG_AM",               width:65,  align:'center', hidden: true},
         							 {name:"SRA_FARM_ACNO_MASKING",     index:"SRA_FARM_ACNO_MASKING",    width:65,  align:'center', hidden: true},
         							 {name:"AUC_OBJ_DSC",               index:"AUC_OBJ_DSC",              width:65,  align:'center' , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:65,  align:'center', sorttype: "number"},
                                     {name:"FHS_ID_NO",                 index:"FHS_ID_NO",                width:85,  align:'center'},
                                     {name:"NA_TRPL_C",                 index:"NA_TRPL_C",                width:120, align:'center'},
                                     {name:"FTSNM",                     index:"FTSNM",                    width:75,  align:'center'},
                                     {name:"FNBIRTH",                   index:"FNBIRTH",                  width:120, align:'center',formatter:'gridDateFormat'},
                                     {name:"ADR",                       index:"ADR",                      width:250, align:'left'},
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:90,  align:'center'},
                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:100, align:'center'},
                                     {name:"SEL_STS_DSC",               index:"SEL_STS_DSC",              width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:65,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"BIRTH",                     index:"BIRTH",                    width:65,  align:'center',formatter:'gridDateFormat'},
                                     {name:"MTCN",                      index:"MTCN",                     width:65,  align:'center'},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:65,  align:'right', formatter:'integer', sorttype: "number"},
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:75,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:65,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:65,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"FHS_TOT_AM",                index:"FHS_TOT_AM",               width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"TOT_AM",                    index:"TOT_AM",                   width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"ACNO_OWNER",                index:"ACNO_OWNER",               width:100, align:'center'},
                                     {name:"SRA_FARM_ACNO",             index:"SRA_FARM_ACNO",            width:100, align:'center'},
                                     {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:100, align:'center'},
                                     {name:"SRA_TR_FEE2",               index:"SRA_TR_FEE2",              width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:100, align:'center'}
                                     
                                  ];
            
        $("#grd_MhSogCow5").jqGrid("GridUnload");
                
        $("#grd_MhSogCow5").jqGrid({
        	datatype:    "local",
            data:        data,
            height:      500,
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
            }
        });
        //행번호
        $("#grd_MhSogCow5").jqGrid("setLabel", "rn","No"); 
        
        //합계행에 가로스크롤이 있을경우 추가
      	var $obj = document.getElementById('grd_MhSogCow5');
        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

        $bDiv.css({'overflow-x':'hidden'});
        $sDiv.css({'overflow-x':'scroll'});
        $sDiv.scroll(function(){
            $bDiv.scrollLeft($sDiv.scrollLeft());
        });
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow5 .jqgfirstrow td:last-child").width($("#grd_MhSogCow5 .jqgfirstrow td:last-child").width() - 17);
        
      	//footer        
        var gridDatatemp = $('#grd_MhSogCow5').getRowData();

        var tot_sra_sbid_am	= 0; 	// 총 낙찰가격
        var tot_fhs_tot_am	= 0; 	// 총 수수료
        var tot_fhs_am		= 0; 	// 총 정산금액
        
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_sbid_am 	= parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
        	tot_fhs_tot_am		= parseInt(tot_fhs_tot_am) + parseInt(gridDatatemp[i].FHS_TOT_AM);
        	tot_fhs_am 			= parseInt(tot_fhs_am) + parseInt(gridDatatemp[i].TOT_AM);
            
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_OBJ_DSC"     		,"합  계"           	   	,7 ,"String"]
               ,["SRA_SBID_AM"			,tot_sra_sbid_am		,1 ,"Integer"]
               ,["FHS_TOT_AM"    		,tot_fhs_tot_am  	   	,1 ,"Integer"]
               ,["TOT_AM"    			,tot_fhs_am  	   		,1 ,"Integer"]
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow5', arr);
        
    }
    
function fn_CreateSubGrid_5(data){
	
    var rowNoValue = 0;     
    if(data != null){
        rowNoValue = data.length;
    }
    
    var searchResultColNames = ["경매대상","경매번호","출하자코드","경제통합 거래처코드","출하자명", "주소", "핸드폰", "귀표번호", "진행상태", "성별", "생년월일", "월령", "중량(Kg)", "예정가", "낙찰단가", 
    							"낙찰가격", "수수료", "정산금액", "예금주", "계좌번호", "수송사", "낙찰자"];        
    
    var searchResultColModel = [
     							 {name:"AUC_OBJ_DSC",       index:"AUC_OBJ_DSC",        width:50,   align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
     							 {name:"AUC_PRG_SQ",        index:"AUC_PRG_SQ",         width:50,   align:'center', sorttype: "number"},
     							 {name:"FHS_ID_NO",         index:"FHS_ID_NO",          width:120,  align:'center'},
     							 {name:"NA_TRPL_C",         index:"NA_TRPL_C",          width:120,  align:'center'},
     							 {name:"FTSNM",             index:"FTSNM",              width:100,  align:'center'},
                                 {name:"ADR",               index:"ADR",                width:350,  align:'left'},
                                 {name:"CUS_MPNO",          index:"CUS_MPNO",           width:120,  align:'center'},
                                 {name:"SRA_INDV_AMNNO",	index:"SRA_INDV_AMNNO",     width:120,  align:'center'},
                                 {name:"SEL_STS_DSC",       index:"SEL_STS_DSC",        width:80,   align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
                                 {name:"INDV_SEX_C",        index:"INDV_SEX_C",         width:50,   align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                 {name:"BIRTH",             index:"BIRTH",              width:100,  align:'center',formatter:'gridDateFormat'},
                                 {name:"MTCN",              index:"MTCN",               width:50,   align:'center'},
                                 {name:"COW_SOG_WT",        index:"COW_SOG_WT",         width:50,   align:'right'},
                                 {name:"LOWS_SBID_LMT_AM",  index:"LOWS_SBID_LMT_AM",   width:120,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                 {name:"SRA_SBID_UPR",      index:"SRA_SBID_UPR",       width:120,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                 {name:"SRA_SBID_AM",       index:"SRA_SBID_AM",        width:120,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                 {name:"FHS_TOT_AM",        index:"FHS_TOT_AM",         width:120,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                 {name:"TOT_AM",            index:"TOT_AM",             width:120,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                 {name:"ACNO_OWNER",        index:"ACNO_OWNER",         width:100,  align:'center'},
                                 {name:"SRA_FARM_ACNO",     index:"SRA_FARM_ACNO",      width:120,  align:'center'},
                                 {name:"VHC_DRV_CAFFNM",    index:"VHC_DRV_CAFFNM",     width:100,  align:'center'},
                                 {name:"SRA_MWMNNM",        index:"SRA_MWMNNM",         width:100,  align:'center'}
                              ];
        
    $("#hdn_grd_MhSogCow5").jqGrid("GridUnload");
            
    $("#hdn_grd_MhSogCow5").jqGrid({
    	datatype:    "local",
        data:        data,
        height:      500,
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
        }
    });
    //행번호
    $("#hdn_grd_MhSogCow5").jqGrid("setLabel", "rn","No"); 
    
    //합계행에 가로스크롤이 있을경우 추가
  	var $obj = document.getElementById('hdn_grd_MhSogCow5');
    var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

    $bDiv.css({'overflow-x':'hidden'});
    $sDiv.css({'overflow-x':'scroll'});
    $sDiv.scroll(function(){
        $bDiv.scrollLeft($sDiv.scrollLeft());
    });
    
    //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
    $("#hdn_grd_MhSogCow5 .jqgfirstrow td:last-child").width($("#hdn_grd_MhSogCow5 .jqgfirstrow td:last-child").width() - 17);
    
  	//footer        
    var gridDatatemp = $('#hdn_grd_MhSogCow5').getRowData();

    var tot_sra_sbid_am	= 0; 	// 총 낙찰가격
    var tot_fhs_tot_am	= 0; 	// 총 수수료
    var tot_fhs_am		= 0; 	// 총 정산금액
    
    
    $.each(gridDatatemp, function(i){
    	
    	tot_sra_sbid_am 	= parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
    	tot_fhs_tot_am		= parseInt(tot_fhs_tot_am) + parseInt(gridDatatemp[i].FHS_TOT_AM);
    	tot_fhs_am 			= parseInt(tot_fhs_am) + parseInt(gridDatatemp[i].TOT_AM);
        
    });        
    
    var arr = [
	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
            ["AUC_OBJ_DSC"     		,"합  계"           	   	,6 ,"String"]
           ,["SRA_SBID_AM"			,tot_sra_sbid_am		,1 ,"Integer"]
           ,["FHS_TOT_AM"    		,tot_fhs_tot_am  	   	,1 ,"Integer"]
           ,["TOT_AM"    			,tot_fhs_am  	   		,1 ,"Integer"]
       ] 	       
	       
    ];

    fn_setGridFooter('hdn_grd_MhSogCow5', arr);
    
}
    
	function fn_CreateGrid_6(data){
		
	    var rowNoValue = 0;
	    
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["경매번호", "출하자코드", "출하자명", "주소", "낙찰자", "중량(Kg)", "낙찰단가", "낙찰가격", "총 수수료", "정산금액", "비고"];        
	    
	    var searchResultColModel = [
	     							 {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:60,  align:'center', sorttype: "number"},
	                                 {name:"FHS_ID_NO",                 index:"FHS_ID_NO",                width:80,  align:'center'},
	                                 {name:"FTSNM",                     index:"FTSNM",                    width:80,  align:'center'},
	                                 {name:"ADR",                       index:"ADR",                      width:250, align:'left'},
	                                 {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:80,  align:'center'},
	                                 {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:80,  align:'right'},
	                                 {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"TOT_FEE",                   index:"TOT_FEE",                  width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SBT_PY_AM",                 index:"SBT_PY_AM",                width:100, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"RMK_CNTN",                  index:"RMK_CNTN",                 width:250, align:'left'}
	                              ];
	        
	    $("#grd_MhSogCow6").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow6").jqGrid({
	    	datatype:    "local",
	        data:        data,
	        height:      500,
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
	        }
	    });
	    //행번호
	    $("#grd_MhSogCow6").jqGrid("setLabel", "rn","No"); 
	    
	    //합계행에 가로스크롤이 있을경우 추가
	  	var $obj = document.getElementById('grd_MhSogCow6');
	    var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);
	
	    $bDiv.css({'overflow-x':'hidden'});
	    $sDiv.css({'overflow-x':'scroll'});
	    $sDiv.scroll(function(){
	        $bDiv.scrollLeft($sDiv.scrollLeft());
	    });
	    
	  	//footer        
        var gridDatatemp = $('#grd_MhSogCow6').getRowData();

        var tot_sra_sbid_am	= 0; 	// 총 낙찰가격
        var tot_tot_fee		= 0; 	// 총 수수료
        var tot_sbt_py_am	= 0; 	// 총 정산금액
        
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_sbid_am = parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
        	tot_tot_fee		= parseInt(tot_tot_fee) 	+ parseInt(gridDatatemp[i].TOT_FEE);
        	tot_sbt_py_am 	= parseInt(tot_sbt_py_am) 	+ parseInt(gridDatatemp[i].SBT_PY_AM);
            
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_PRG_SQ"     		,"합  계"           	   	,4 ,"String"]
               ,["SRA_SBID_AM"			,tot_sra_sbid_am		,1 ,"Integer"]
               ,["TOT_FEE"    			,tot_tot_fee  	   		,1 ,"Integer"]
               ,["SBT_PY_AM"    		,tot_sbt_py_am  	   	,1 ,"Integer"]
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow6', arr);
	    
	}
	
	
	function fn_CreateGrid_7(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["수송자명", "차량번호", "수송자 전화번호", "총 두수", "운송비"];        
	    
	    var searchResultColModel = [
	     							 {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:200, align:'center'},
	                                 {name:"VHCNO",                     index:"VHCNO",                    width:200, align:'center'},
	                                 {name:"BRWR_MPNO",                 index:"BRWR_MPNO",                width:200, align:'center'},
	                                 {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:200, align:'right'},
	                                 {name:"TRPCS",                     index:"TRPCS",                    width:200, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
	                                 ];
	        
	    $("#grd_MhSogCow7").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow7").jqGrid({
	    	 datatype:    "local",
	         data:        data,
	         height:      500,
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
	        }
	    });
		
	    //행번호
	    $("#grd_MhSogCow7").jqGrid("setLabel", "rn","No"); 

	    //footer        
        var gridDatatemp = $('#grd_MhSogCow7').getRowData();

        var tot_sra_indv_amnno	= 0; 	// 총 낙찰가격
        var tot_trpcs			= 0; 	// 총 수수료
        
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_indv_amnno 	= parseInt(tot_sra_indv_amnno) + parseInt(gridDatatemp[i].SRA_INDV_AMNNO);
        	tot_trpcs			= parseInt(tot_trpcs) 	+ parseInt(gridDatatemp[i].TRPCS);
            
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["VHC_DRV_CAFFNM"  		,"합  계"           	   	,1 ,"String"]
               ,["SRA_INDV_AMNNO"		,tot_sra_indv_amnno		,1 ,"Integer"]
               ,["TRPCS"    			,tot_trpcs  	   		,1 ,"Integer"]
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow7', arr);
	    
	}
	
	
	function fn_CreateGrid_8(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["등록구분", "성별", "두수", "전체(Kg)", "평균(Kg)", "총 예정가", "예정가 평균금액(A)",
	                              	"총 낙찰가 금액","낙찰가 평균금액(B)","비고(평균차액) (B-A)"];        
	    
	    var searchResultColModel = [
	     							 {name:"RG_DSC",                    index:"RG_DSC",                   width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	                                 {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"TOT_HDCN",                  index:"TOT_HDCN",                 width:60,  align:'center', sorttype: "number"},
	                                 {name:"TOT_WT",                    index:"TOT_WT",                   width:80,  align:'right', sorttype: "number"},
	                                 {name:"AVG_WT",                    index:"AVG_WT",                   width:80,  align:'right', sorttype: "number"},
	                                 {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:150, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"AVG_PR",                    index:"AVG_PR",                   width:150, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:150, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_AVG_SBID_UPR",          index:"SRA_AVG_SBID_UPR",         width:150, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"BIGO",                      index:"BIGO",                     width:150, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
	                               ];
	        
	    $("#grd_MhSogCow8").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow8").jqGrid({
	    	 datatype:    "local",
	         data:        data,
	         height:      300,
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
	        }
	    });
	    //행번호
	    $("#grd_MhSogCow8").jqGrid("setLabel", "rn","No"); 
	    
	  	//footer        
        var gridDatatemp = $('#grd_MhSogCow8').getRowData();

        var tot_tot_hdcn 			= 0;
        var tot_tot_wt				= 0;
        var tot_avg_wt 				= 0;
        var tot_lows_sbid_lmt_am	= 0;
        var tot_sra_sbid_am			= 0;
        
        
        $.each(gridDatatemp, function(i){
        	
        	tot_tot_hdcn 			= parseInt(tot_tot_hdcn) + parseInt(gridDatatemp[i].TOT_HDCN);
        	tot_tot_wt				= parseInt(tot_tot_wt) 	+ parseInt(gridDatatemp[i].TOT_WT);
        	tot_lows_sbid_lmt_am	= parseInt(tot_lows_sbid_lmt_am) 	+ parseInt(gridDatatemp[i].LOWS_SBID_LMT_AM);
        	tot_sra_sbid_am			= parseInt(tot_sra_sbid_am) 	+ parseInt(gridDatatemp[i].SRA_SBID_AM);
        });
        tot_avg_wt 				= parseInt(tot_tot_wt) / parseInt(tot_tot_hdcn);
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["RG_DSC"	     	,"합  계"           	   	,1 ,"String"]
               ,["TOT_HDCN"			,tot_tot_hdcn			,1 ,"Integer"]
               ,["TOT_WT"			,tot_tot_wt				,1 ,"Integer"]
               ,["AVG_WT"			,Math.floor(parseInt(tot_avg_wt)),1 ,"Integer"]
               ,["LOWS_SBID_LMT_AM"	,tot_lows_sbid_lmt_am	,1 ,"Integer"]
               ,["SRA_SBID_AM"    	,tot_sra_sbid_am  	   	,1 ,"Integer"]
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow8', arr);
	    
	}
	
	
	function fn_CreateGrid_9(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["H총출하수수료","총판매수수료","임신감정료","임신감정료","괴사감정료","괴사감정료","운송비","운송비","출자금","출자금",
	    							"H주사료","주사료","사료대금","사료대금","사고적립금액","사료적립금액","자조금","자조금","당일접수비용","당일접수비용","12개월이상 수수료","12개월이상수수료",
	    							"H검진비","검진비","혈통접수비","혈통접수비","제각수수료","제각수수료","위탁수수료","위탁수수료","경매대상",
	    							
	    							"총두수", "총 낙찰두수", "총 낙찰금액", "총 수수료", "입찰 보증금", "총 납입할 금액", "낙찰자 입금액", "낙찰 정산금액", 
	    							"농가 정산금액", "농가 정산금액(유찰분미포함)", "암", "수", "암", "수", "암", "수", "암", "수", "암", "수", "암", "수"];        
	    
	    var searchResultColModel = [
	     							 {name:"SRA_SOG_FEE",              	index:"SRA_SOG_FEE",            width:90, align:'center' , hidden : true}, //총출하수수료
	     							 {name:"SRA_SEL_FEE",              	index:"SRA_SEL_FEE",            width:90, align:'center' , hidden : true}, //총판매수수료
	     							 {name:"FHS_FEE_PRNY_JUG_AM",      	index:"FHS_FEE_PRNY_JUG_AM",    width:90, align:'center' , hidden : true}, //임신감정료
	     							 {name:"SEL_FEE_PRNY_JUG_AM",      	index:"SEL_FEE_PRNY_JUG_AM",    width:90, align:'center' , hidden : true}, //임신감정료
	     							 {name:"FHS_FEE_NCSS_JUG_AM",      	index:"SEL_FEE_PRNY_JUG_AM",    width:90, align:'center' , hidden : true}, //괴사감정료
	     							 {name:"SEL_FEE_NCSS_JUG_AM",      	index:"SEL_FEE_PRNY_JUG_AM",    width:90, align:'center' , hidden : true}, //괴사감정료
	     							 {name:"FHS_FEE_SRA_TRPCS",        	index:"FHS_FEE_SRA_TRPCS",      width:90, align:'center' , hidden : true}, //운송비
	     							 {name:"SEL_FEE_SRA_TRPCS",        	index:"SEL_FEE_SRA_TRPCS",      width:90, align:'center' , hidden : true}, //운송비
	     							 {name:"FHS_FEE_SRA_PYIVA",        	index:"FHS_FEE_SRA_PYIVA",      width:90, align:'center' , hidden : true}, //출자금
	     							 {name:"SEL_FEE_SRA_PYIVA",        	index:"SEL_FEE_SRA_PYIVA",      width:90, align:'center' , hidden : true}, //출자금
	     							 {name:"FHS_FEE_INJT_AM",          	index:"FHS_FEE_INJT_AM",        width:90, align:'center' , hidden : true}, //주사료
	     							 {name:"SEL_FEE_INJT_AM",          	index:"SEL_FEE_INJT_AM",        width:90, align:'center' , hidden : true}, //주사료
	     							 {name:"FHS_FEE_SRA_FED_SPY_AM",   	index:"FHS_FEE_SRA_FED_SPY_AM", width:90, align:'center' , hidden : true}, //사료대금
	     							 {name:"SEL_FEE_SRA_FED_SPY_AM",   	index:"SEL_FEE_SRA_FED_SPY_AM", width:90, align:'center' , hidden : true}, //사료대금
	     							 {name:"FHS_FEE_ACD_RVG_AM",   		index:"FHS_FEE_ACD_RVG_AM",  	width:90, align:'center' , hidden : true}, //사고적립금액
	     							 {name:"SEL_FEE_ACD_RVG_AM",   		index:"SEL_FEE_ACD_RVG_AM",  	width:90, align:'center' , hidden : true}, //사고적립금액
	     							 {name:"FHS_FEE_SRA_SHNM",   		index:"FHS_FEE_SRA_SHNM",  		width:90, align:'center' , hidden : true}, //자조금
	     							 {name:"SEL_FEE_SRA_SHNM",   		index:"SEL_FEE_SRA_SHNM",  		width:90, align:'center' , hidden : true}, //자조금
	     							 {name:"FHS_FEE_TD_RC_CST",   		index:"FHS_FEE_TD_RC_CST",  	width:90, align:'center' , hidden : true}, //당일접수비용
	     							 {name:"SEL_FEE_TD_RC_CST",   		index:"SEL_FEE_TD_RC_CST",  	width:90, align:'center' , hidden : true}, //당일접수비용
	     							 {name:"FHS_FEE_MT12_OVR_FEE",   	index:"FHS_FEE_MT12_OVR_FEE",  	width:90, align:'center' , hidden : true}, //12개월이상 수수료
	     							 {name:"SEL_FEE_MT12_OVR_FEE",   	index:"SEL_FEE_MT12_OVR_FEE",  	width:90, align:'center' , hidden : true}, //12개월이상 수수료
	     							 {name:"FHS_FEE_IO_SRA_FEE1",   	index:"FHS_FEE_IO_SRA_FEE1",  	width:90, align:'center' , hidden : true}, //검진비
	     							 {name:"SEL_FEE_IO_SRA_FEE1",   	index:"SEL_FEE_IO_SRA_FEE1",  	width:90, align:'center' , hidden : true}, //검진비
	     							 {name:"FHS_FEE_IO_SRA_FEE2",   	index:"FHS_FEE_IO_SRA_FEE2",  	width:90, align:'center' , hidden : true}, //혈통접수비
	     							 {name:"SEL_FEE_IO_SRA_FEE2",   	index:"SEL_FEE_IO_SRA_FEE2",  	width:90, align:'center' , hidden : true}, //혈통접수비
	     							 {name:"FHS_FEE_IO_SRA_FEE3",   	index:"FHS_FEE_IO_SRA_FEE3",  	width:90, align:'center' , hidden : true}, //제각수수료
	     							 {name:"SEL_FEE_IO_SRA_FEE3",   	index:"SEL_FEE_IO_SRA_FEE3",  	width:90, align:'center' , hidden : true}, //제각수수료
	     							 {name:"FHS_FEE_TRU_FEE",   		index:"FHS_FEE_TRU_FEE",  		width:90, align:'center' , hidden : true}, //위탁수수료
	     							 {name:"SEL_FEE_TRU_FEE",   		index:"SEL_FEE_TRU_FEE",  		width:90, align:'center' , hidden : true}, //위탁수수료
	     							 {name:"AUC_OBJ_DSC",   		index:"AUC_OBJ_DSC",  		width:90, align:'center' , hidden : true}, //위탁수수료
	     							 
	    							 {name:"SRA_SOG_HDCN",              index:"SRA_SOG_HDCN",             width:90, align:'right'},
	                                 {name:"SRA_AUC_SBID_HDCN",         index:"SRA_AUC_SBID_HDCN",        width:90, align:'right'},
	                                 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"TOT_FEE",                   index:"TOT_FEE",                  width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"AUC_ENTR_GRN_AM",           index:"AUC_ENTR_GRN_AM",          width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"ACRV_AM",                   index:"ACRV_AM",                  width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_RV_AM",                 index:"SRA_RV_AM",                width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"IO_NPAY_AM19",              index:"IO_NPAY_AM19",             width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"TOT_SOG_AM",                index:"TOT_SOG_AM",               width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"YU_FHS_TOT",                index:"YU_FHS_TOT",               width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"FEME_SOG_HDCNTT",           index:"FEME_SOG_HDCNTT",          width:90, align:'right'},
	                                 {name:"MALE_SOG_HDCNTT",           index:"MALE_SOG_HDCNTT",          width:90, align:'right'},
	                                 {name:"FEME_HDCN",                 index:"FEME_HDCN",                width:90, align:'right'},
	                                 {name:"MALE_HDCN",                 index:"MALE_HDCN",                width:90, align:'right'},
	                                 {name:"IO_FEME_SRA_SBID_AM",       index:"IO_FEME_SRA_SBID_AM",      width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"IO_MALE_SRA_SBID_AM",       index:"IO_MALE_SRA_SBID_AM",      width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_FEE",                   index:"SRA_FEE",                  width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"IO_SRA_FEE18",              index:"IO_SRA_FEE18",             width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_TR_FEE",                index:"SRA_TR_FEE",               width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"IO_SRA_FEE19",              index:"IO_SRA_FEE19",             width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_ETC_CST",               index:"SRA_ETC_CST",              width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"IO_SRA_FEE20",              index:"IO_SRA_FEE20",             width:90, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
	                               ];
	        
	    $("#grd_MhSogCow9").jqGrid("GridUnload");
	    
	    $("#grd_MhSogCow9").jqGrid({
	    	 datatype:    "local",
	         data:        data,
	         height:      500,
	         rowNum:      rowNoValue,
	         resizeing:   true,
	         autowidth:   false,
	         shrinkToFit: false,
	         rownumbers:  true,
	         rownumWidth: 40,
	         colNames: searchResultColNames,
	         colModel: searchResultColModel,          
	         onSelectRow:function(rowid,status, e){
	        },
	    });
	    
	    $("#grd_MhSogCow9").jqGrid("setGroupHeaders", {
	        useColSpanStyle:true,
	        groupHeaders:[
	      	{startColumnName:"FEME_SOG_HDCNTT", 	numberOfColumns: 2, titleText: '출장우'},
	      	{startColumnName:"FEME_HDCN", 			numberOfColumns: 2, titleText: '낙찰 두수'},
	      	{startColumnName:"IO_FEME_SRA_SBID_AM",	numberOfColumns: 2, titleText: '낙찰 금액'},
	      	{startColumnName:"SRA_FEE", 			numberOfColumns: 2, titleText: '출하수수료'},
	      	{startColumnName:"SRA_TR_FEE", 			numberOfColumns: 2, titleText: '판매수수료'},
	      	{startColumnName:"SRA_ETC_CST", 		numberOfColumns: 2, titleText: '기타수수료'}]
	       }); 
	    //행번호
	    $("#grd_MhSogCow9").jqGrid("setLabel", "rn","No");
	    
	  	//가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#grd_MhSogCow9 .jqgfirstrow td:last-child").width($("#grd_MhSogCow9 .jqgfirstrow td:last-child").width() - 17);
	    
	}
	
	
	function fn_CreateGrid_10(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["참가번호", "성명", "경매번호", "귀표번호", "(송)귀표번호", "참가 보증금", "성별", "낙찰금액", "출하수수료", "판매수수료", "조합출자금", "사고적립금", "운송비", 
	    							"괴사감정료", "임신감정료", "검진비", "주사료", "자조금", "혈통접수비", "제각수수료", "위탁수수료", "총 금액", "입금금액", "정산금액"];        
	    
	    var searchResultColModel = [
	     							 {name:"LVST_AUC_PTC_MN_NO",		index:"LVST_AUC_PTC_MN_NO",     width:85, align:'center'},
	                                 {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",             width:85, align:'center'},
	                                 {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",             width:85, align:'center', sorttype: "number"},
	                                 {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",         width:85, align:'center'},
	                                 {name:"CALF_SRA_INDV_AMNNO",       index:"CALF_SRA_INDV_AMNNO",	width:85, align:'center', hidden:true},
	                                 {name:"AUC_ENTR_GRN_AM",           index:"AUC_ENTR_GRN_AM",        width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"INDV_SEX_C",                index:"INDV_SEX_C",             width:85, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SOG_FEE",               index:"SRA_SOG_FEE",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SEL_FEE",               index:"SRA_SEL_FEE",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_ACO_IVSAM",             index:"SRA_ACO_IVSAM",          width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_ACD_RVGAM",             index:"SRA_ACD_RVGAM",          width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_TRPCS",                 index:"SRA_TRPCS",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_NCSS_JUG_FEE",          index:"SRA_NCSS_JUG_FEE",       width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_PRNY_JUG_FEE",          index:"SRA_PRNY_JUG_FEE",       width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_MDCCS",                 index:"SRA_MDCCS",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_INJT_FEE",              index:"SRA_INJT_FEE",           width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SHNM",                  index:"SRA_SHNM",               width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_PDG_RC_FEE",            index:"SRA_PDG_RC_FEE",         width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_RMHN_FEE",              index:"SRA_RMHN_FEE",           width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_TRU_FEE",               index:"SRA_TRU_FEE",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"IO_AM_15",                  index:"IO_AM_15",               width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_RV_AM",                 index:"SRA_RV_AM",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"IO_AM_151",                 index:"IO_AM_151",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
	                               ];
	        
	    $("#grd_MhSogCow10").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow10").jqGrid({
	    	 datatype:    "local",
	         data:        data,
	         height:      500,
	         rowNum:      rowNoValue,
	         resizeing:   true,
	         autowidth:   false,
	         shrinkToFit: false,
	         rownumbers:  true,
	         rownumWidth: 40,
	         colNames: searchResultColNames,
	         colModel: searchResultColModel,
	         onSelectRow:function(rowid,status, e){
	        	$("#rg_dsc");
	        }
	    });
	    //행번호
	    $("#grd_MhSogCow10").jqGrid("setLabel", "rn","No");
	    $("#grd_MhSogCow10").show();
	    if(data != null) {
			// View Grid
			var data2 = new Array();
			var dataItem = new Object();
			var l_LVST_AUC_PTC_MN_NO	= "";
			var l_AUC_ENTR_GRN_AM		= 0;			// 참가 보증금
			var l_SRA_SBID_AM			= 0;			// 낙찰 금액
			var l_SRA_SEL_FEE			= 0;			// 판매수수료
			var l_SRA_INJT_FEE			= 0;			// 주사료
			var l_SRA_SHNM				= 0;			// 자조금
			var l_SRA_TR_FEE			= 0;			// 판매수수료
			var l_IO_AM_15				= 0;
			var l_SRA_RV_AM				= 0;
			var l_IO_AM_151				= 0;
			
			$.each(data, function(i) {
				if((i != 0 && l_LVST_AUC_PTC_MN_NO != data[i].LVST_AUC_PTC_MN_NO)) {
					dataItem = new Object();
					dataItem['LVST_AUC_PTC_MN_NO'] = "소계";
					dataItem['AUC_ENTR_GRN_AM']	= l_AUC_ENTR_GRN_AM;
					dataItem['SRA_SBID_AM']		= l_SRA_SBID_AM;
					dataItem['SRA_SEL_FEE']		= l_SRA_SEL_FEE;
					dataItem['SRA_INJT_FEE']	= l_SRA_INJT_FEE;
					dataItem['SRA_SHNM']		= l_SRA_SHNM;
					dataItem['SRA_TR_FEE']		= l_SRA_TR_FEE;
					dataItem['IO_AM_15']		= l_IO_AM_15;
					dataItem['SRA_RV_AM']		= l_SRA_RV_AM;
					dataItem['IO_AM_151']		= l_IO_AM_151;

					l_LVST_AUC_PTC_MN_NO	= "";
					l_AUC_ENTR_GRN_AM		= 0;
					l_SRA_SBID_AM			= 0;
					l_SRA_SEL_FEE			= 0;
					l_SRA_INJT_FEE			= 0;
					l_SRA_SHNM				= 0;
					l_SRA_TR_FEE			= 0;
					l_IO_AM_15				= 0;
					l_SRA_RV_AM				= 0;
					l_IO_AM_151				= 0;
					
					data2.push(dataItem);
				}
				
				data2.push(data[i]);
				
				l_LVST_AUC_PTC_MN_NO	= data[i].LVST_AUC_PTC_MN_NO;
				l_AUC_ENTR_GRN_AM		= Number(data[i].AUC_ENTR_GRN_AM);
				l_SRA_SBID_AM			= Number(l_SRA_SBID_AM) + Number(data[i].SRA_SBID_AM);
				l_SRA_SEL_FEE			= Number(l_SRA_SEL_FEE) + Number(data[i].SRA_SEL_FEE);
				l_SRA_INJT_FEE			= Number(l_SRA_INJT_FEE) + Number(data[i].SRA_INJT_FEE);
				l_SRA_SHNM				= Number(l_SRA_SHNM) + Number(data[i].SRA_SHNM);
				l_SRA_TR_FEE 			= Number(l_SRA_TR_FEE) + Number(data[i].SRA_TR_FEE);
				l_IO_AM_15 				= Number(data[i].IO_AM_15);
				l_SRA_RV_AM 			= Number(data[i].SRA_RV_AM);
				l_IO_AM_151 			= Number(data[i].IO_AM_151)
			});
			
			dataItem = new Object();
			dataItem['LVST_AUC_PTC_MN_NO'] = "소계";
			dataItem['AUC_ENTR_GRN_AM']	= l_AUC_ENTR_GRN_AM;
			dataItem['SRA_SBID_AM']		= l_SRA_SBID_AM;
			dataItem['SRA_SEL_FEE']		= l_SRA_SEL_FEE;
			dataItem['SRA_INJT_FEE']	= l_SRA_INJT_FEE;
			dataItem['SRA_SHNM']		= l_SRA_SHNM;
			dataItem['SRA_TR_FEE']		= l_SRA_TR_FEE;
			dataItem['IO_AM_15']		= l_IO_AM_15;
			dataItem['SRA_RV_AM']		= l_SRA_RV_AM;
			dataItem['IO_AM_151']		= l_IO_AM_151;
			data2.push(dataItem);
			
			var rowNoValue = 0;
			if(data2 != null){
				rowNoValue2 = data2.length;
			}

			var searchResultColNames = ["참가번호", "성명", "경매번호", "귀표번호", "(송)귀표번호", "참가 보증금", "성별", "낙찰금액", "출하수수료", "판매수수료", "조합출자금", "사고적립금", "운송비", 
										"괴사감정료", "임신감정료", "검진비", "주사료", "자조금", "혈통접수비", "제각수수료", "위탁수수료", "총 금액", "입금금액", "정산금액"];        

			var searchResultColModel = [
								 {name:"LVST_AUC_PTC_MN_NO",		index:"LVST_AUC_PTC_MN_NO",     width:85, align:'center'},
				                 {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",             width:85, align:'center'},
				                 {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",             width:85, align:'center', sorttype: "number"},
				                 {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",         width:85, align:'center'},
				                 {name:"CALF_SRA_INDV_AMNNO",       index:"CALF_SRA_INDV_AMNNO",	width:85, align:'center', hidden:true},
				                 {name:"AUC_ENTR_GRN_AM",           index:"AUC_ENTR_GRN_AM",        width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"INDV_SEX_C",                index:"INDV_SEX_C",             width:85, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
				                 {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_SOG_FEE",               index:"SRA_SOG_FEE",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_SEL_FEE",               index:"SRA_SEL_FEE",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_ACO_IVSAM",             index:"SRA_ACO_IVSAM",          width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_ACD_RVGAM",             index:"SRA_ACD_RVGAM",          width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_TRPCS",                 index:"SRA_TRPCS",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_NCSS_JUG_FEE",          index:"SRA_NCSS_JUG_FEE",       width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_PRNY_JUG_FEE",          index:"SRA_PRNY_JUG_FEE",       width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_MDCCS",                 index:"SRA_MDCCS",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_INJT_FEE",              index:"SRA_INJT_FEE",           width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_SHNM",                  index:"SRA_SHNM",               width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_PDG_RC_FEE",            index:"SRA_PDG_RC_FEE",         width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_RMHN_FEE",              index:"SRA_RMHN_FEE",           width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_TRU_FEE",               index:"SRA_TRU_FEE",            width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"IO_AM_15",                  index:"IO_AM_15",               width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"SRA_RV_AM",                 index:"SRA_RV_AM",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
				                 {name:"IO_AM_151",                 index:"IO_AM_151",              width:85, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
				               ];
		        
		    $("#grd_ViewMhSogCow10").jqGrid("GridUnload");
		            
		    $("#grd_ViewMhSogCow10").jqGrid({
		    	 datatype:    "local",
		         data:        data2,
		         height:      500,
		         rowNum:      rowNoValue2,
		         resizeing:   true,
		         autowidth:   false,
		         shrinkToFit: false,
		         rownumbers:  true,
		         rownumWidth: 40,
		         colNames: searchResultColNames,
		         colModel: searchResultColModel,
		         gridComplete:function(rowid,status, e){
		             	var rows = $("#grd_ViewMhSogCow10").getDataIDs();
		             	for(var i = 0; i < rows.length; i++) {
		             		var status = $("#grd_ViewMhSogCow10").getCell(rows[i], "LVST_AUC_PTC_MN_NO");
		             		if(status == "소계") {
		             			$("#grd_ViewMhSogCow10").jqGrid("setRowData", rows[i], false, {background:"skyblue"});
		             		}
		             	}
		             },
		         onSelectRow:function(rowid,status, e){
		        	$("#rg_dsc");
		        }
		    });
		    //행번호
		    $("#grd_ViewMhSogCow10").jqGrid("setLabel", "rn","No");
		    
	      	//footer        
	        var gridDatatemp = $('#grd_ViewMhSogCow10').getRowData();
	      	
	        var tot_sra_sog_fee       = 0;
	        var tot_sra_sel_fee       = 0;
	        var tot_sra_aco_ivsam     = 0;
	        var tot_sra_acd_rvgam     = 0;
	        var tot_sra_trpcs         = 0;
	        var tot_sra_ncss_jug_fee  = 0;
	        var tot_sra_prny_jug_fee  = 0;
	        var tot_sra_mdccs         = 0;
	        var tot_sra_injt_fee      = 0;
	        var tot_sra_shnm          = 0;
	        var tot_sra_pdg_rc_fee    = 0;
	        var tot_sra_rmhn_fee      = 0;
	        var tot_sra_tru_fee       = 0;
	        
	        $.each(gridDatatemp, function(i){
	        	tot_sra_sog_fee       = parseInt(tot_sra_sog_fee) + parseInt(gridDatatemp[i].SRA_SOG_FEE);
	        	tot_sra_sel_fee       = parseInt(tot_sra_sel_fee) + parseInt(gridDatatemp[i].SRA_SEL_FEE);
	        	tot_sra_aco_ivsam     = parseInt(tot_sra_aco_ivsam) + parseInt(gridDatatemp[i].SRA_ACO_IVSAM);
	        	tot_sra_acd_rvgam     = parseInt(tot_sra_acd_rvgam) + parseInt(gridDatatemp[i].SRA_ACD_RVGAM);
	        	tot_sra_trpcs         = parseInt(tot_sra_trpcs) + parseInt(gridDatatemp[i].SRA_TRPCS);
	        	tot_sra_ncss_jug_fee  = parseInt(tot_sra_ncss_jug_fee) + parseInt(gridDatatemp[i].SRA_NCSS_JUG_FEE);
	        	tot_sra_prny_jug_fee  = parseInt(tot_sra_prny_jug_fee) + parseInt(gridDatatemp[i].SRA_PRNY_JUG_FEE);
	        	tot_sra_mdccs         = parseInt(tot_sra_mdccs) + parseInt(gridDatatemp[i].SRA_MDCCS);
	        	tot_sra_injt_fee      = parseInt(tot_sra_injt_fee) + parseInt(gridDatatemp[i].SRA_INJT_FEE);
	        	tot_sra_shnm          = parseInt(tot_sra_shnm) + parseInt(gridDatatemp[i].SRA_SHNM);
	        	tot_sra_pdg_rc_fee    = parseInt(tot_sra_pdg_rc_fee) + parseInt(gridDatatemp[i].SRA_PDG_RC_FEE);
	        	tot_sra_rmhn_fee      = parseInt(tot_sra_rmhn_fee) + parseInt(gridDatatemp[i].SRA_RMHN_FEE);
	        	tot_sra_tru_fee       = parseInt(tot_sra_tru_fee) + parseInt(gridDatatemp[i].SRA_TRU_FEE);
	            
	        });
	        
	        if(tot_sra_sog_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_SOG_FEE");
	        }
	        if(tot_sra_sel_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_SEL_FEE");
	        }
	        if(tot_sra_aco_ivsam == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_ACO_IVSAM");
	        }
	        if(tot_sra_acd_rvgam == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_ACD_RVGAM");
	        }
	        if(tot_sra_trpcs == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_TRPCS");
	        }
	        if(tot_sra_ncss_jug_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_NCSS_JUG_FEE");
	        }
	        if(tot_sra_prny_jug_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_PRNY_JUG_FEE");
	        }
	        if(tot_sra_mdccs == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_MDCCS");
	        }
	        if(tot_sra_injt_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_INJT_FEE");
	        }
	        if(tot_sra_shnm == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_SHNM");
	        }
	        if(tot_sra_pdg_rc_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_PDG_RC_FEE");
	        }
	        if(tot_sra_rmhn_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_RMHN_FEE");
	        }
	        if(tot_sra_tru_fee == 0) {
	        	$("#grd_ViewMhSogCow10").jqGrid("hideCol","SRA_TRU_FEE");
	        }
        }
	     
	}
	
	
	function fn_CreateGrid_11(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["H경매일자","H수수료",
	    							"경매번호", "출하자코드", "출하자명", "주소", "귀표번호", "(송)귀표번호", "성별","KPN", "예정가", "중량(Kg)", "낙찰단가", "낙찰가격", "출하수수료", "출자금", 
	    							"사고적립금", "운송비", "괴사감정료", "임신감정료", "검진비", "주사료", "자조금", "혈통접수비", "제각수수료", "위탁수수료", "사료공금금액", "당일접수비용", 
	    							"12개월이상수수료", "판매수수료", "정산금액", "낙찰자","경매대상"];
	    
	    var searchResultColModel = [
	     							 {name:"AUC_DT",		    	index:"AUC_DT",				    	width:80,  align:'center', hidden:true},
	     							 {name:"TOT_FEE",		        index:"TOT_FEE",					width:80,  align:'center', hidden:true},
	     							 
	     							 {name:"AUC_PRG_SQ",			index:"AUC_PRG_SQ",					width:80,  align:'center', sorttype: "number"},
	                                 {name:"FHS_ID_NO",				index:"FHS_ID_NO",					width:100, align:'center'},
	                                 {name:"FTSNM",					index:"FTSNM",						width:80,  align:'center'},
	                                 {name:"ADR",				    index:"ADR",						width:250, align:'left'},
	                                 {name:"SRA_INDV_AMNNO",		index:"SRA_INDV_AMNNO",				width:120, align:'center'},
	                                 {name:"CALF_SRA_INDV_AMNNO",	index:"CALF_SRA_INDV_AMNNO",		width:120, align:'center', hidden:true},
	                                 {name:"INDV_SEX_C",			index:"INDV_SEX_C",					width:65,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"KPN_NO",				index:"KPN_NO",						width:60,  align:'center'},	                                 
	                                 {name:"LOWS_SBID_LMT_AM",		index:"LOWS_SBID_LMT_AM",			width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"COW_SOG_WT",			index:"COW_SOG_WT",					width:65,  align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SBID_UPR",			index:"SRA_SBID_UPR",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SBID_AM",			index:"SRA_SBID_AM",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SOG_FEE",			index:"SRA_SOG_FEE",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_PYIVA",				index:"SRA_PYIVA",					width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_ACD_RVGAM",			index:"SRA_ACD_RVGAM",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_TRPCS",				index:"SRA_TRPCS",					width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_NCSS_JUG_FEE",		index:"SRA_NCSS_JUG_FEE",			width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_PRNY_JUG_FEE",		index:"SRA_PRNY_JUG_FEE",			width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_MDCCS",				index:"SRA_MDCCS",					width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_INJT_FEE",			index:"SRA_INJT_FEE",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SHNM",				index:"SRA_SHNM",					width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_PDG_RC_FEE",		index:"SRA_PDG_RC_FEE",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_RMHN_FEE",			index:"SRA_RMHN_FEE",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_TRU_FEE",			index:"SRA_TRU_FEE",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_FED_SPY_AM",		index:"SRA_FED_SPY_AM",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"TD_RC_CST",				index:"TD_RC_CST",					width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"MT12_OVR_FEE",			index:"MT12_OVR_FEE",				width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SEL_FEE",			index:"SRA_SEL_FEE",				width:120, align:'right', hidden:true, formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"TOT_AM",				index:"TOT_AM",						width:120, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_MWMNNM",			index:"SRA_MWMNNM",					width:120, align:'center'},
	                                 {name:"AUC_OBJ_DSC",           index:"AUC_OBJ_DSC",                width:65,  align:'center' , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
	                                 ];
	        
	    $("#grd_MhSogCow11").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow11").jqGrid({
	    	datatype:    "local",
	        data:        data,
	        height:      500,
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
	        }
	    });

	    //행번호
	    $("#grd_MhSogCow11").jqGrid("setLabel", "rn","No"); 
	      
	    //합계행에 가로스크롤이 있을경우 추가
	    var $obj = document.getElementById('grd_MhSogCow11');
	    var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

	    $bDiv.css({'overflow-x':'hidden'});
	    $sDiv.css({'overflow-x':'scroll'});
	    $sDiv.scroll(function(){
	    	$bDiv.scrollLeft($sDiv.scrollLeft());
	    });
	      
	    //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
	    $("#grd_MhSogCow11 .jqgfirstrow td:last-child").width($("#grd_MhSogCow11 .jqgfirstrow td:last-child").width() - 17);
	      
    	//footer        
        var gridDatatemp = $('#grd_MhSogCow11').getRowData();

        var tot_sra_sbid_am       = 0;
        var tot_sra_sog_fee       = 0;
        var tot_sra_pyiva         = 0;
        var tot_sra_acd_rvgam     = 0;
        var tot_sra_trpcs         = 0;
        var tot_sra_ncss_jug_fee  = 0;
        var tot_sra_prny_jug_fee  = 0;
        var tot_sra_mdccs         = 0;
        var tot_sra_injt_fee      = 0;
        var tot_sra_shnm          = 0;
        var tot_sra_pdg_rc_fee    = 0;
        var tot_sra_rmhn_fee      = 0;
        var tot_sra_tru_fee       = 0;
        var tot_sra_fed_spy_am    = 0;
        var tot_td_rc_cst         = 0;
        var tot_mt12_ovr_fee      = 0;
        var tot_sra_sel_fee       = 0;
        var tot_tot_am			  = 0;
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_sbid_am       = parseInt(tot_sra_sbid_am) + parseInt(gridDatatemp[i].SRA_SBID_AM);
        	tot_sra_sog_fee       = parseInt(tot_sra_sog_fee) + parseInt(gridDatatemp[i].SRA_SOG_FEE);
        	tot_sra_pyiva         = parseInt(tot_sra_pyiva) + parseInt(gridDatatemp[i].SRA_PYIVA);
        	tot_sra_acd_rvgam     = parseInt(tot_sra_acd_rvgam) + parseInt(gridDatatemp[i].SRA_ACD_RVGAM);
        	tot_sra_trpcs         = parseInt(tot_sra_trpcs) + parseInt(gridDatatemp[i].SRA_TRPCS);
        	tot_sra_ncss_jug_fee  = parseInt(tot_sra_ncss_jug_fee) + parseInt(gridDatatemp[i].SRA_NCSS_JUG_FEE);
        	tot_sra_prny_jug_fee  = parseInt(tot_sra_prny_jug_fee) + parseInt(gridDatatemp[i].SRA_PRNY_JUG_FEE);
        	tot_sra_mdccs         = parseInt(tot_sra_mdccs) + parseInt(gridDatatemp[i].SRA_MDCCS);
        	tot_sra_injt_fee      = parseInt(tot_sra_injt_fee) + parseInt(gridDatatemp[i].SRA_INJT_FEE);
        	tot_sra_shnm          = parseInt(tot_sra_shnm) + parseInt(gridDatatemp[i].SRA_SHNM);
        	tot_sra_pdg_rc_fee    = parseInt(tot_sra_pdg_rc_fee) + parseInt(gridDatatemp[i].SRA_PDG_RC_FEE);
        	tot_sra_rmhn_fee      = parseInt(tot_sra_rmhn_fee) + parseInt(gridDatatemp[i].SRA_RMHN_FEE);
        	tot_sra_tru_fee       = parseInt(tot_sra_tru_fee) + parseInt(gridDatatemp[i].SRA_TRU_FEE);
        	tot_sra_fed_spy_am    = parseInt(tot_sra_fed_spy_am) + parseInt(gridDatatemp[i].SRA_FED_SPY_AM);
        	tot_td_rc_cst         = parseInt(tot_td_rc_cst) + parseInt(gridDatatemp[i].TD_RC_CST);
        	tot_mt12_ovr_fee      = parseInt(tot_mt12_ovr_fee) + parseInt(gridDatatemp[i].MT12_OVR_FEE);
        	tot_sra_sel_fee       = parseInt(tot_sra_sel_fee) + parseInt(gridDatatemp[i].SRA_SEL_FEE);
        	tot_tot_am			  = parseInt(tot_tot_am) + parseInt(gridDatatemp[i].TOT_AM);
            
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_PRG_SQ"  			,"합  계"           	 , 8, "String"]
               ,["SRA_SBID_AM"			,tot_sra_sbid_am     , 1, "Integer"] 
               ,["SRA_SOG_FEE"         ,tot_sra_sog_fee      , 1, "Integer"] 
               ,["SRA_PYIVA"           ,tot_sra_pyiva        , 1, "Integer"] 
               ,["SRA_ACD_RVGAM"       ,tot_sra_acd_rvgam    , 1, "Integer"] 
               ,["SRA_TRPCS"           ,tot_sra_trpcs        , 1, "Integer"] 
               ,["SRA_NCSS_JUG_FEE"    ,tot_sra_ncss_jug_fee , 1, "Integer"] 
               ,["SRA_PRNY_JUG_FEE"    ,tot_sra_prny_jug_fee , 1, "Integer"] 
               ,["SRA_MDCCS"           ,tot_sra_mdccs        , 1, "Integer"] 
               ,["SRA_INJT_FEE"        ,tot_sra_injt_fee     , 1, "Integer"] 
               ,["SRA_SHNM"            ,tot_sra_shnm         , 1, "Integer"] 
               ,["SRA_PDG_RC_FEE"      ,tot_sra_pdg_rc_fee   , 1, "Integer"] 
               ,["SRA_RMHN_FEE"        ,tot_sra_rmhn_fee     , 1, "Integer"] 
               ,["SRA_TRU_FEE"         ,tot_sra_tru_fee      , 1, "Integer"] 
               ,["SRA_FED_SPY_AM"      ,tot_sra_fed_spy_am   , 1, "Integer"] 
               ,["TD_RC_CST"           ,tot_td_rc_cst        , 1, "Integer"] 
               ,["MT12_OVR_FEE"        ,tot_mt12_ovr_fee     , 1, "Integer"] 
               ,["SRA_SEL_FEE"         ,tot_sra_sel_fee      , 1, "Integer"] 
               ,["TOT_AM"              ,tot_tot_am			 , 1, "Integer"]
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow11', arr);
        
        if(tot_sra_sog_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_SOG_FEE");
        }
        
        if(tot_sra_pyiva == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_PYIVA");
        }
        
        if(tot_sra_acd_rvgam == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_ACD_RVGAM");
        }
        
        if(tot_sra_trpcs == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_TRPCS");
        }
        
        if(tot_sra_ncss_jug_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_NCSS_JUG_FEE");
        }
        
        if(tot_sra_prny_jug_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_PRNY_JUG_FEE");
        }
        
        if(tot_sra_mdccs == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_MDCCS");
        }
        
        if(tot_sra_injt_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_INJT_FEE");
        }
        
        if(tot_sra_shnm == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_SHNM");
        }
        
        if(tot_sra_pdg_rc_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_PDG_RC_FEE");
        }
        
        if(tot_sra_rmhn_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_RMHN_FEE");
        }
        
        if(tot_sra_tru_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_TRU_FEE");
        }
        
        if(tot_sra_fed_spy_am == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","SRA_FED_SPY_AM");
        }
        
        if(tot_td_rc_cst == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","TD_RC_CST");
        }
        
        if(tot_mt12_ovr_fee == 0) {
        	$("#grd_MhSogCow11").jqGrid("hideCol","MT12_OVR_FEE");
        }
	    
	}
	
	
	function fn_CreateGrid_12(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["거래처코드", "수의사명", "괴사감정료", "임신감정료", "검진비", "주사료", "합계"];        
	    
	    var searchResultColModel = [
	     							 {name:"LVST_MKT_TRPL_AMNNO",        index:"LVST_AUC_PTC_MN_NO",       width:65, align:'center'},
	                                 {name:"BRKR_NAME",                  index:"BRKR_NAME",                width:65, align:'center'},
	                                 {name:"SRA_NCSS_JUG_FEE",           index:"SRA_NCSS_JUG_FEE",         width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_PRNY_JUG_FEE",           index:"SRA_PRNY_JUG_FEE",         width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_MDCCS",                  index:"SRA_MDCCS",                width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_INJT_FEE",               index:"SRA_INJT_FEE",             width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"FEE_SAM",                    index:"FEE_SAM",                  width:65, align:'right', formatter:'integer', sorttype: "number", formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
	                               ];
	        
	    $("#grd_MhSogCow12").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow12").jqGrid({
	    	  datatype:    "local",
	          data:        data,
	          height:      500,
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
	        }
	    });
	   //행번호
	    $("#grd_MhSogCow12").jqGrid("setLabel", "rn","No"); 
	    
	  	//footer        
        var gridDatatemp = $('#grd_MhSogCow12').getRowData();

        var tot_sra_ncss_jug_fee	= 0;
        var tot_sra_prny_jug_fee	= 0;
        var tot_sra_mdccs         	= 0;
        var tot_sra_injt_fee     	= 0;
        var tot_fee_sam         	= 0;
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_ncss_jug_fee	= parseInt(tot_sra_ncss_jug_fee) 	+ parseInt(gridDatatemp[i].SRA_NCSS_JUG_FEE);
            tot_sra_prny_jug_fee	= parseInt(tot_sra_prny_jug_fee) 	+ parseInt(gridDatatemp[i].SRA_PRNY_JUG_FEE);
            tot_sra_mdccs         	= parseInt(tot_sra_mdccs) 			+ parseInt(gridDatatemp[i].SRA_MDCCS);
            tot_sra_injt_fee     	= parseInt(tot_sra_injt_fee) 		+ parseInt(gridDatatemp[i].SRA_INJT_FEE);
            tot_fee_sam         	= parseInt(tot_fee_sam) 			+ parseInt(gridDatatemp[i].FEE_SAM);
            
        });        
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["LVST_MKT_TRPL_AMNNO" 	,"합  계"           	  	, 1, "String"]
               ,["SRA_NCSS_JUG_FEE"		,tot_sra_ncss_jug_fee	, 1, "Integer"] 
               ,["SRA_PRNY_JUG_FEE"     ,tot_sra_prny_jug_fee	, 1, "Integer"] 
               ,["SRA_MDCCS"           	,tot_sra_mdccs        	, 1, "Integer"] 
               ,["SRA_INJT_FEE"       	,tot_sra_injt_fee    	, 1, "Integer"] 
               ,["FEE_SAM"           	,tot_fee_sam        	, 1, "Integer"]
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow12', arr);
	     
	}
	
	
	function fn_CreateGrid_13(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["가축시장 코드", "가축시장 농장식별번호", "거래유형", "개체식별번호", "종류", "성별", "생년월일", "농장식별번호", "가축사육시설 소재지(상세포함)", "판매자명", 
									"농장번호", "농장명", "연락처", "경매일자", "주소", "성명", "생년월일", "연락처"];
	    
	    var searchResultColModel = [
	     							 {name:"METRB_USR_C",                 index:"METRB_USR_C",           width:100, align:'center'},
	                                 {name:"LVST_MKT_FARM_ID_NO",         index:"LVST_MKT_FARM_ID_NO",   width:130, align:'center'},
	                                 {name:"IO_TR_TPC_NM",                index:"IO_TR_TPC_NM",          width:100, align:'center'},
	                                 {name:"SRA_INDV_EART_NO",            index:"SRA_INDV_EART_NO",      width:150, align:'center', formatter:'gridIndvFormat'},
	                                 {name:"SRA_INDV_DSC",                index:"SRA_INDV_DSC",          width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
	                                 {name:"INDV_SEX_C",                  index:"INDV_SEX_C",            width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"SRA_INDV_BIRTH",              index:"SRA_INDV_BIRTH",        width:100, align:'center', formatter:'gridDateFormat'},
	                                 {name:"FARM_ID_NO",                  index:"FARM_ID_NO",            width:100, align:'center'},
	                                 {name:"SOG_DONG",                    index:"SOG_DONG",              width:250, align:'left'},
	                                 {name:"SRA_FHSNM",                   index:"SRA_FHSNM",             width:100, align:'center'},
	                                 {name:"FHS_ID_NO",                   index:"FHS_ID_NO",             width:100, align:'center'},
	                                 {name:"SRA_FHSNM",                   index:"SRA_FHSNM",             width:100, align:'center'},
	                                 {name:"SRA_FARM_CUS_MPNO",           index:"SRA_FARM_CUS_MPNO",     width:100, align:'center'},
	                                 {name:"AUC_DT",                      index:"AUC_DT",                width:100, align:'center', formatter:'gridDateFormat'},
	                                 {name:"MWMN_DONG",                   index:"MWMN_DONG",             width:250, align:'left'},
	                                 {name:"SRA_MWMNNM",                  index:"SRA_MWMNNM",            width:100, align:'center'},
	                                 {name:"CUS_RLNO",                    index:"CUS_RLNO",              width:100, align:'center', formatter:'gridDateFormat'},
	                                 {name:"CUS_MPNO",                    index:"CUS_MPNO",              width:100, align:'center'}
	                                 ];
	        
	    $("#grd_MhSogCow13").jqGrid("GridUnload");
	    
	    $("#grd_MhSogCow13").jqGrid({
	        datatype:    "local",
	        data:        data,
	        height:      500,
	        rowNum:      rowNoValue,
	        resizeing:   true,
	        autowidth:   false,
	        shrinkToFit: false,
	        rownumbers:  true,
	        rownumWidth: 40,
	        colNames: searchResultColNames,
	        colModel: searchResultColModel,          
	        onSelectRow:function(rowid,status, e){
	        },
	    });
	    
	    $("#grd_MhSogCow13").jqGrid("setGroupHeaders", {
	        useColSpanStyle:true,
	        groupHeaders:[
	      	{startColumnName:"SRA_INDV_DSC", 	numberOfColumns: 3, titleText: '소 정보'},
	      	{startColumnName:"FARM_ID_NO", 		numberOfColumns: 6, titleText: '판매자 정보'},
	      	{startColumnName:"MWMN_DONG", 		numberOfColumns: 4, titleText: '낙찰자 또는 구매자 정보'}]
	    }); 
		
	    //행번호
	    $("#grd_MhSogCow13").jqGrid("setLabel", "rn","No"); 
	    
	    
	    $("#grd_MhSogCow13 .jqgfirstrow td:last-child").width($("#grd_MhSogCow13 .jqgfirstrow td:last-child").width() - 17);  
	    
	}
	
function fn_CreateHdnGrid_13(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["주소", "성명", "판매자농장 식별번호", "이력번호", "출생일자", "산차", "어미구분", "계대", "아비 KPN", "성별", 
									"중량", "예정가", "낙찰가", "수송자", "낙찰자", "구매농장 식별번호", "회원번호", "회원구분", "판매자연락처", "낙찰자연락처", "낙찰자생년월일", "낙찰자주소"];
	    
	    var searchResultColModel = [
	     							 {name:"SOG_DONG",						index:"SOG_DONG",						width:250, align:'left'},
	                                 {name:"SLPL_NA_CLNTNM",				index:"SLPL_NA_CLNTNM",					width:100, align:'center'},
	                                 {name:"FARM_ID_NO",					index:"FARM_ID_NO",						width:150, align:'center'},
	                                 {name:"SRA_INDV_EART_NO",				index:"SRA_INDV_EART_NO",				width:150, align:'center'},
	                                 {name:"SRA_INDV_BIRTH",				index:"SRA_INDV_BIRTH",					width:100, align:'center'},
	                                 {name:"SRA_INDV_MOTHR_MATIME",			index:"SRA_INDV_MOTHR_MATIME",			width:100, align:'center'},
	                                 {name:"SRA_INDV_MCOW_BRDSRA_RG_DSC",	index:"SRA_INDV_MCOW_BRDSRA_RG_DSC",	width:100, align:'center'},
	                                 {name:"SRA_INDV_PASG_QCN",				index:"SRA_INDV_PASG_QCN",				width:100, align:'center'},
	                                 {name:"SRA_INDV_KPN_NO",				index:"SRA_INDV_KPN_NO",				width:100, align:'center'},
	                                 {name:"INDV_SEX_C",					index:"INDV_SEX_C",						width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"COW_SOG_WT",					index:"COW_SOG_WT",						width:100, align:'center'},
	                                 {name:"LOWS_SBID_LMT_AM",				index:"LOWS_SBID_LMT_AM",				width:100, align:'center'},
	                                 {name:"SRA_SBID_AM",					index:"SRA_SBID_AM",					width:100, align:'center'},
	                                 {name:"VHC_DRV_CAFFNM",				index:"VHC_DRV_CAFFNM",					width:100, align:'center'},
	                                 {name:"SRA_MWMNNM",					index:"SRA_MWMNNM",						width:100, align:'center'},
	                                 {name:"NONE",							index:"NONE",							width:100, align:'center'},
	                                 {name:"NONE",							index:"NONE",							width:100, align:'center'},
	                                 {name:"MACO_YN",						index:"MACO_YN",						width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
	                                 {name:"SRA_FARM_CUS_MPNO",				index:"SRA_FARM_CUS_MPNO",				width:100, align:'center'},
	                                 {name:"CUS_MPNO",						index:"CUS_MPNO",						width:100, align:'center'},
	                                 {name:"CUS_RLNO",						index:"CUS_RLNO",						width:100, align:'center', formatter:'gridDateFormat'},
	                                 {name:"MWMN_DONG",						index:"MWMN_DONG",						width:250, align:'left'}
	                                 ];
	        
	    $("#hdn_grd_MhSogCow13").jqGrid("GridUnload");
	    
	    $("#hdn_grd_MhSogCow13").jqGrid({
	        datatype:    "local",
	        data:        data,
	        height:      500,
	        rowNum:      rowNoValue,
	        resizeing:   true,
	        autowidth:   false,
	        shrinkToFit: false,
	        rownumbers:  true,
	        rownumWidth: 40,
	        colNames: searchResultColNames,
	        colModel: searchResultColModel,          
	        onSelectRow:function(rowid,status, e){
	        },
	    });
	    
	    //행번호
	    $("#hdn_grd_MhSogCow13").jqGrid("setLabel", "rn","No"); 
	    
	}
	
	
	function fn_CreateGrid_14(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["경매일자", "경매대상", "출하주명/응찰자명", "귀표번호", "주소", "전화번호", "참고사항"];        
	    
	    var searchResultColModel = [
	     							 {name:"AUC_DT",              index:"AUC_DT",             width:80,  align:'center', formatter:'gridDateFormat'},
	                                 {name:"AUC_OBJ_DSC",         index:"AUC_OBJ_DSC",        width:80,  align:'center'},
	                                 {name:"SRA_FHSNM",           index:"SRA_FHSNM",          width:80,  align:'center'},
	                                 {name:"SRA_INDV_EART_NO",    index:"SRA_INDV_EART_NO",   width:120,  align:'center'},
	                                 {name:"ADR",                 index:"ADR",                width:200, align:'left'},
	                                 {name:"FARM_TELNO",          index:"FARM_TELNO",         width:80,  align:'center'},
	                                 {name:"RMK_CNTN",            index:"RMK_CNTN",           width:250, align:'left'}
	                               ];
	        
	    $("#grd_MhSogCow14").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow14").jqGrid({
	    	  datatype:    "local",
	          data:        data,
	          height:      500,
	          rowNum:      rowNoValue,
	          resizeing:   true,
	          autowidth:   false,
	          shrinkToFit: false,
	          rownumbers:  true,
	          rownumWidth: 40,
	          colNames: searchResultColNames,
	          colModel: searchResultColModel,          
	          onSelectRow:function(rowid,status, e){
	          },
	    });
	}
	
	
	function fn_CreateGrid_15(data){
		
	    var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    
	    var searchResultColNames = ["거래처코드", "수의사명", "검진횟수", "검진비", "합계"];        
	    
	    var searchResultColModel = [
	     							 {name:"LVST_MKT_TRPL_AMNNO", index:"LVST_MKT_TRPL_AMNNO",     width:150, align:'center'},
	                                 {name:"BRKR_NAME",           index:"BRKR_NAME",               width:150, align:'center'},
	                                 {name:"COUNT",               index:"COUNT",                   width:150, align:'center'},
	                                 {name:"SRA_PRNY_JUG_FEE",    index:"SRA_PRNY_JUG_FEE",        width:150, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_PRNY_JUG_FEE",    index:"SRA_PRNY_JUG_FEE",        width:150, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}}
	                               ];
	        
	    $("#grd_MhSogCow15").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow15").jqGrid({
	    	  datatype:    "local",
	          data:        data,
	          height:      500,
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
	    $("#grd_MhSogCow15").jqGrid("setLabel", "rn","No");
	  	
	  	//footer        
        var gridDatatemp = $('#grd_MhSogCow15').getRowData();

        var tot_sra_ncss_jug_fee	= 0;
        var tot_sra_prny_jug_fee	= 0;
        
        $.each(gridDatatemp, function(i){
        	
        	tot_sra_ncss_jug_fee	= parseInt(tot_sra_ncss_jug_fee) 	+ parseInt(gridDatatemp[i].COUNT);
            tot_sra_prny_jug_fee	= parseInt(tot_sra_prny_jug_fee) 	+ parseInt(gridDatatemp[i].SRA_PRNY_JUG_FEE);
            
        });
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["LVST_MKT_TRPL_AMNNO" 	,"합  계"           	  	, 1, "String"]
               ,["COUNT"				,tot_sra_ncss_jug_fee	, 1, "Integer"] 
               ,["SRA_PRNY_JUG_FEE"     ,tot_sra_prny_jug_fee	, 1, "Integer"] 
           ] 	       
 	       
        ];
 
        fn_setGridFooter('grd_MhSogCow15', arr);
	     
	}
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
	
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //**************************************
	//function  : fn_hideFrm(프레임단위 Disable)
	//paramater : p_FrmId, p_boolean ex) 'p_FrmId', true 
	//result   : N/A
	//**************************************
	function fn_hideFrm(p_FrmId, p_boolean){
	     
		var disableFrm = $("#" + p_FrmId).find("input,select,textarea,checkbox,button,tr,th,td,label,span");
		var itemNames = "";
		
		for(var i=0; i<disableFrm.length; i++){
		    itemNames = $(disableFrm[i]).attr("id");
		    
		    if(p_boolean) {
		        $("#"+itemNames).hide();
		        $("#"+itemNames).width("0px");
		    } else {
		        $("#"+itemNames).show();           
		    }
		}       
	}
	
	//**************************************
	//function  : fn_tabCheck(탭체크로 조회조건 변경)
	//paramater : p_param(활성화 시킬 탭 번호) 
	//result    : N/A
	//**************************************
	function fn_tabCheck(p_param){
		
		var temp_auc_dt_data = "";
		var temp_auc_obj_dsc_data = "";
		
		if(mv_RunMode == "2") {
			temp_auc_dt_data = $("#auc_dt").val(); 
			
			if(!$("#pb_tab13").hasClass("on") || p_param != "13") {
				temp_auc_obj_dsc_data = $("#auc_obj_dsc").val();
			}
		}
	
		var temp_auc_obj_dsc = 	'<th style="width:80px" scope="row"><span class="tb_dot">경매대상</span></th>' + 
								'<td style="width:220px">' +
									'<select style="width:150px" id="auc_obj_dsc"></select>' +
									'<input type="hidden" id="qcn"> '
									+'<input type="hidden" id="fhs_sra_ubd_fee">'+'<input type="hidden" id="sel_sra_ubd_fee">'
									+'<input type="hidden" id="am_ubd_hdcn">'+'<input type="hidden" id="su_ubd_hdcn">'
									+'<input type="hidden" id="lvst_auc_ptc_mn_no">'
									
									
								'</td>';
		var temp_auc_dt	 	 = 	'<th style="width:80px" scope="row"><span class="tb_dot">경매일자</span></th>' +
					            '<td style="width:220px">' +
						            '<div class="cellBox">' +
						            	'<div class="cell"><input style="width:150px" type="text" class="date" id="auc_dt" maxlength="10"></div>' +                                        
						            '</div>' +
					            '</td>';
		var temp_ftsnm	 	 = 	'<th style="width:50px" scope="row" id="io_sel"><span class="tb_dot"></span></th>' +
								'<td  style="width:120px">' +
									'<input disabled="disabled" type="text" id="fhs_id_no">' +
								'</td>' +
					            '<td style="width:220px">' +
                            		'<input style="width:150px" type="text" id="ftsnm" maxlength="50">' +
                            		'<button id="pb_ftsnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>' +
                            	'</td>';
                            	
		var temp_sel_sts_dsc = 	'<th style="width:80px" scope="row"><span class="tb_dot">진행상태</span></th>' +
                            	'<td style="width:220px">' +
					            	'<select style="width:150px" id="sel_sts_dsc"></select>' +
					            '</td>';                     	
                            	
		var temp_indv_sex_c	 = 	'<th style="width:50px" scope="row""><span class="tb_dot">성별</span></th>' + 
					            '<td style="width:220px">' + 
					            	'<select style="width:150px" id="indv_sex_c"></select>' + 
					            '</td>';
					            
		var temp_auc_prg_sq	 = 	'<th style="width:80px" scope="row" id="t_auc_prg_sq"><span class="tb_dot">경매번호</span></th>' +
                            	'<td style="width:220px">' +
                            		'<input style="width:100px" type="text" id="auc_prg_sq">' +
                            	'</td>';
                            	
		var temp_MhSogCow9	= '<th style="width:150px" scope="row"><span class="tb_dot">유찰운송비 미포함</span></th>' +
                              '<td style="width:80px">' +
                            		'<input type="checkbox" id="MhSogCow9_Chk" name="MhSogCow9_Chk" value="0">' +
                            		'<label id="MhSogCow9_Chk_text" for="ncss_yn">부</label>' +
                              '</td>';
                              
		var temp_MhSogCow11	= '<th style="width:100px" scope="row"><span class="tb_dot">그룹별소계</span></th>' +
                      		  '<td style="width:80px">' +
                          			'<input type="checkbox" id="MhSogCow11_Chk" name="MhSogCow11_Chk" value="0">' +
                          			'<label id="MhSogCow11_Chk_text" for="ncss_yn">부</label>' +
                          	  '</td>';
                          	  
		var temp_name	 	= '<th style="width:80px" scope="row"><span class="tb_dot">이름</span></th>' +
				              '<td style="width:220px">' +
				              		'<input hidden="true" style="width:0" type="text" id="id" maxlength="50">' +
                        			'<input style="width:150px" type="text" id="name">' +
                        			'<button id="pb_name" class="tb_btn white srch"><i class="fa fa-search"></i></button>' +
                        	  '</td>';
                        	  
		var temp_fee_apl_obj  =	'<td style="width:220px">' +
                          			'<input type="radio" id="fee_apl_obj_y"  name="fee_apl_obj_cyn" value="1" checked> 출하자' +
                          			'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + 
                                 	'<input type="radio" id="fee_apl_obj_n"  name="fee_apl_obj_cyn" value="2"> 중도매인' +
                                  	'<input type="hidden" id="fee_apl_obj_c" value="1">' +
                          	  	'</td>';
                        	  
		var temp_sra_indv_amnno	= '<th style="width:80px" scope="row"><span class="tb_dot">귀표번호</span></th>' +
	                          	  '<td style="width:220px">' +
	                          			'<input style="width:150px"  type="text" id="sra_indv_amnno" maxlength="15">' +
	                          	  '</td>';
	                          	  
	    var temp_count_fee		= '<th style="width:100px" scope="row"><span class="tb_dot">임신감정비</span></th>' +
                            	  '<td style="width:220px">' +
                            			'<input type="text" id="count_fee">' +
                            	  '</td>';

		var temp_noBidChk = '<th scope="row" id="t_MhSogCow8_Chk"><span class="tb_dot">결장우 미포함</span></th>';
		temp_noBidChk += '<td><input type="checkbox" id="chk_no_bid" name="chk_no_bid" value="0"><label id="chk_no_bid_text" for="chk_no_bid">부</label></td>';
	                          	  

		var temp_calfCowChk = '<th scope="row" id="t_MhSogCow8_Chk"><span class="tb_dot">딸린송아지 포함</span></th>';
		temp_calfCowChk += '<td><input type="checkbox" id="chk_calf_cow" name="chk_calf_cow" value="0"><label id="chk_calf_cow_text" for="chk_calf_cow">부</label></td>';

		fn_hideFrm("frm_Search", true);
		$("#tab8_sub").hide();
		
		if($("#pb_tab1").hasClass("on") || p_param == "1") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
	 		
		} else if($("#pb_tab2").hasClass("on") || p_param == "2") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_ftsnm + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            $("#io_sel").text("낙찰자");
	 		
		} else if($("#pb_tab3").hasClass("on") || p_param == "3") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_sel_sts_dsc + temp_indv_sex_c + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
	 		
		} else if($("#pb_tab4").hasClass("on") || p_param == "4") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
	 		
		} else if($("#pb_tab5").hasClass("on") || p_param == "5") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_ftsnm + temp_sel_sts_dsc + temp_auc_prg_sq + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            $("#io_sel").text("출하자");
            
            
         	// ★고창: 8808990657189 테스트: 8808990643625
            if(na_bzplc == "8808990657189" || na_bzplc == "8808990643625") {
            	$("#grd_MhSogCow5").jqGrid("hideCol", "BIRTH").trigger('reloadGrid');
            } else {
            	$("#grd_MhSogCow5").jqGrid("showCol", "BIRTH").trigger('reloadGrid');
            }
         	// ★음성: 8808990683973 테스트: 8808990643625
            if(na_bzplc == "8808990683973" || na_bzplc == "8808990643625") {
            	$("#grd_MhSogCow5").jqGrid("hideCol", "SRA_TR_FEE2").trigger('reloadGrid');
            } else {
            	$("#grd_MhSogCow5").jqGrid("showCol", "SRA_TR_FEE2").trigger('reloadGrid');
            }
			
		} else if($("#pb_tab6").hasClass("on") || p_param == "6") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_ftsnm + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            $("#io_sel").text("출하자");
			
		} else if($("#pb_tab7").hasClass("on") || p_param == "7") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_MhSogCow9 + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            
		} else if($("#pb_tab8").hasClass("on") || p_param == "8") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_noBidChk + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            $("#tab8_sub").show();
            
		} else if($("#pb_tab9").hasClass("on") || p_param == "9") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            
		} else if($("#pb_tab10").hasClass("on") || p_param == "10") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_ftsnm + temp_indv_sex_c + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            $("#io_sel").text("낙찰자");
            
		} else if($("#pb_tab11").hasClass("on") || p_param == "11") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_ftsnm + temp_MhSogCow11 + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            $("#io_sel").text("출하자");
            
		} else if($("#pb_tab12").hasClass("on") || p_param == "12") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_ftsnm + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            $("#io_sel").text("수의사");
            
		} else if($("#pb_tab13").hasClass("on") || p_param == "13") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_dt + temp_calfCowChk + '</tr>';
			
            $("#frm_Search_tbody").append(addSearchText);
            
		} else if($("#pb_tab14").hasClass("on") || p_param == "14") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_fee_apl_obj + temp_name + temp_sra_indv_amnno + '</tr>';
            $("#frm_Search_tbody").append(addSearchText);
            
		} else if($("#pb_tab15").hasClass("on") || p_param == "15") {
			$("#dynamicTr").remove();
			addSearchText = "";
			addSearchText = '<tr id = "dynamicTr">' + temp_auc_obj_dsc + temp_auc_dt + temp_ftsnm + temp_count_fee + '</tr>';
			$("#frm_Search_tbody").append(addSearchText);
            $("#io_sel").text("수의사");
			
		}
		
		fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
		fn_setCodeBox("sel_sts_dsc", "SEL_STS_DSC", 1, false, "전체");
		fn_setCodeBox("indv_sex_c", "INDV_SEX_C", 1, false, "전체");
		
		if(mv_RunMode != "2") {
			$("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
		
		} else if(mv_RunMode == "2") {
			 $("#auc_dt").datepicker().datepicker("setDate", temp_auc_dt_data);
			
			if(!$("#pb_tab13").hasClass("on") || p_param != "13") {
				if(!fn_isNull(temp_auc_obj_dsc_data)) {
					$("#auc_obj_dsc").val(temp_auc_obj_dsc_data);
				} 
			}
		}
		
		if(mv_RunMode != "0") {
			fn_Search();
		}
	}
	
	//**************************************
	//function  : fn_clearGrid(그리드 초기화)
	//paramater : N/A 
	//result    : N/A
	//**************************************
	function fn_clearGrid() {
		$("#grd_MhSogCow1").jqGrid("clearGridData", true);
		$("#grd_ViewMhSogCow1").jqGrid("clearGridData", true);
		$("#grd_MhSogCow2").jqGrid("clearGridData", true);
		$("#grd_MhSogCow2_1").jqGrid("clearGridData", true);
		$("#grd_ViewMhSogCow2").jqGrid("clearGridData", true);
		$("#grd_MhSogCow3").jqGrid("clearGridData", true);
		$("#grd_ViewMhSogCow3").jqGrid("clearGridData", true);
		$("#grd_MhSogCow4").jqGrid("clearGridData", true);
		$("#grd_MhSogCow5").jqGrid("clearGridData", true);
		$("#hdn_grd_MhSogCow5").jqGrid("clearGridData", true);
		$("#grd_MhSogCow6").jqGrid("clearGridData", true);
		$("#grd_MhSogCow7").jqGrid("clearGridData", true);
		$("#grd_MhSogCow8").jqGrid("clearGridData", true);
		$("#grd_MhSogCow9").jqGrid("clearGridData", true);
		$("#grd_MhSogCow10").jqGrid("clearGridData", true);
		$("#grd_ViewMhSogCow10").jqGrid("clearGridData", true);
		$("#grd_MhSogCow11").jqGrid("clearGridData", true);
		$("#grd_MhSogCow12").jqGrid("clearGridData", true);
		$("#grd_MhSogCow13").jqGrid("clearGridData", true);
		$("#hdn_grd_MhSogCow13").jqGrid("clearGridData", true);
		$("#grd_MhSogCow14").jqGrid("clearGridData", true);
 		$("#grd_MhSogCow15").jqGrid("clearGridData", true);
    	fn_CreateGrid();
    	fn_CreateViewGrid();
    	fn_CreateGrid_2();
    	fn_CreateGrid_3();
    	fn_CreateGrid_4();
    	fn_CreateGrid_5();
    	fn_CreateSubGrid_5();
    	fn_CreateGrid_6();
    	fn_CreateGrid_7();
    	fn_CreateGrid_8();
    	fn_CreateGrid_9();
    	fn_CreateGrid_10();
    	fn_CreateGrid_11();
    	fn_CreateGrid_12();
    	fn_CreateGrid_13();
    	fn_CreateHdnGrid_13();
    	fn_CreateGrid_14();
     	fn_CreateGrid_15();
	}
	
	////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
	////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //**************************************
 	//function  : fn_CallFhsPopup(출하자 팝업 호출) 
 	//paramater : p_param(엔터검색: true / 돋보기클릭검색 : false) 
 	// result   : N/A
 	//**************************************
    function fn_CallFhsPopup(p_param) {
    	var checkBoolean = p_param;
 		var data = new Object();
 		
 		data['ftsnm'] = $("#ftsnm").val();
 		
 		if(!p_param) {
 			data = null;
 		}
        
 		fn_CallFtsnmPopup(data, checkBoolean, function(result) {
        	if(result){
        		$("#fhs_id_no").val(result.FHS_ID_NO);
        		$("#ftsnm").val(result.FTSNM);
             } else {
            	$("#fhs_id_no").val("");
             	$("#ftsnm").val("");
             }
       	 	 $("#ftsnm").blur();
         });
	}
	
  	//**************************************
 	//function  : fn_CallFhsPopup(중도매인 팝업 호출) 
 	//paramater : p_param(엔터검색: true / 돋보기클릭검색 : false) 
 	// result   : N/A
 	//**************************************
	function fn_CallMwmnPopup(p_param) {
		var checkBoolean = p_param;
 		var data = new Object();
 		
 		data['sra_mwmnnm'] = $("#ftsnm").val();
 		
 		if(!p_param) {
 			data = null;
 		}
        
 		fn_CallMwmnnmPopup(data, checkBoolean, function(result) {
        	if(result){
        		$("#fhs_id_no").val(result.TRMN_AMNNO);
        		$("#ftsnm").val(result.SRA_MWMNNM);
             } else {
            	$("#fhs_id_no").val("");
            	$("#ftsnm").val("");
             }
        	 $("#ftsnm").blur();
         });
	}
	
	//**************************************
 	//function  : fn_CallFhsPopup(수의사 팝업 호출) 
 	//paramater : p_param(엔터검색: true / 돋보기클릭검색 : false) 
 	// result   : N/A
 	//**************************************
	function fn_CallNaTrplCPopup(p_param) {
		var checkBoolean = p_param;
 		var data = new Object();
 		
 		data['sra_mwmnnm'] 		  = $("#ftsnm").val();
 		data['brkr_name'] 		  = $("#ftsnm").val();
 		data['lvst_mkt_trpl_dsc'] = '1';
 		
 		if(!p_param) {
 			data = null;
 		}
        
 		fn_CallMmTrplPopup(data, checkBoolean, function(result) {
        	if(result){
        		$("#fhs_id_no").val(result.LVST_MKT_TRPL_AMNNO);
        		$("#ftsnm").val(result.BRKR_NAME);
             } else {
            	$("#fhs_id_no").val("");
             	$("#ftsnm").val("");
             }
			 $("#ftsnm").blur();
         });
	}
 	
	//**************************************
 	//function  : fn_CallFhsPopup(농가검색 팝업 호출) 
 	//paramater : p_param(엔터검색: true / 돋보기클릭검색 : false) 
 	// result   : N/A
 	//**************************************
	function fn_CallSraSrchPopup(p_param) {
		var checkBoolean = p_param;
 		var data = new Object();
 		if(!p_param) {
 			data = null;
 		}
 		
 		// 출하자
        if($("#fee_apl_obj_c").val() == "1") {
        	data['ftsnm'] = $("#name").val();
        	fn_CallFtsnm0127Popup(data, checkBoolean, function(result) {
            	if(result){
            		$("#id").val(result.FHS_ID_NO);
            		$("#name").val(result.FTSNM);
                 } else {
                	$("#id").val("");
                 	$("#name").val("");
                 }
            });
        	
       	// 중도매인
        } else if($("#fee_apl_obj_c").val() == "2") {
        	data['sra_mwmnnm'] = $("#name").val();
        	fn_CallMwmnnmPopup(data, checkBoolean, function(result) {
            	if(result){
            		$("#id").val(result.TRMN_AMNNO);
                 	$("#name").val(result.SRA_MWMNNM);
                 } else {
                	$("#id").val("");
                  	$("#name").val("");
                 }
            });
        }
	}
    ////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 종료
    ////////////////////////////////////////////////////////////////////////////////

</script>
<body>
	<div class="contents">
    	<%@ include file="/WEB-INF/common/menuBtn.jsp" %>
        <section class="content">
            
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">조회조건</p></li>
                </ul>
            </div>
            
            <div class="sec_table">
	            <div class="blueTable rsp_v">
		            <form id="frm_Search">
			            <table>
				            <colgroup>
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
							</colgroup>
				            <tbody id="frm_Search_tbody">
					            <tr id = "dynamicTr">
						            <th scope="row" id="t_auc_obj_dsc"><span class="tb_dot">경매대상</span></th>
						            <td colspan=2>
						            	<select id="auc_obj_dsc"></select>
						            </td>
						            <th scope="row" id="t_auc_dt"><span class="tb_dot">경매일자</span></th>
						            <td colspan=2>
							            <div class="cellBox">
							            	<div class="cell"><input type="text" class="popup date" id="auc_dt"></div>                                        
							            </div>
						            </td>
						            <th scope="row" id="io_sel"><span class="tb_dot"></span></th>
						            <td colspan=2>
	                            		<input disabled="disabled" type="text" id="fhs_id_no">
	                            	</td>
	                            	<td colspan=2>
	                            		<input type="text" id="ftsnm">
	                            	</td>
	                            	<td>
	                            		<button id="pb_ftsnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
	                            	</td>
	                            	<th scope="row" id="t_sel_sts_dsc"><span class="tb_dot">진행상태</span></th>
	                            	<td>
						            	<select class="popup" id="sel_sts_dsc"></select>
						            </td>
						            <th scope="row" id="t_indv_sex_c"><span class="tb_dot">성별</span></th>
						            <td>
						            	<select class="popup" id="indv_sex_c"></select>
						            </td>
						            <th scope="row" id="t_MhSogCow11_Chk"><span class="tb_dot">그룹별소계</span></th>
	                        		<td>
	                            		<input type="checkbox" id="MhSogCow11_Chk" name="MhSogCow11_Chk" value="0">
	                            		<label id="MhSogCow11_Chk_text" for="ncss_yn"> 부</label>
	                            	</td>
	                            	<th scope="row" id="t_MhSogCow9_Chk"><span class="tb_dot">유찰운송비 미포함</span></th>
	                            	<td>
	                            		<input type="checkbox" id="MhSogCow9_Chk" name="MhSogCow9_Chk" value="0">
	                            		<label id="MhSogCow9_Chk_text" for="ncss_yn"> 부</label>
	                            	</td>
	                            	<th scope="row" id="t_maco_yn"><span class="tb_dot">조합원</span></th>
	                            	<td>
						            	<select id="maco_yn">
	                                    	<option value="">전체</option>
	                                    	<option value="0">비조합원</option>
	                                    	<option value="1">조합원</option>		                                    	
	                            		</select>
						            </td>
						            <td>
						            	<input type="radio" id="rd_fee_apl_obj_c_y"  name="rd_fee_apl_obj_c_yn" value="1" checked><span id="fee_apl_obj_c_y">출하자</span>
	                                    <input type="radio" id="rd_fee_apl_obj_c_n"  name="rd_fee_apl_obj_c_yn" value="2"><span id="fee_apl_obj_c_n">중도매인</span>
	                                    <input type="hidden" id="fee_apl_obj_c" value="1">
	                                </td>
	                                <th scope="row" id="t_name"><span class="tb_dot">조합원</span></th>
	                                <td>
	                            		<input type="text" id="name" style="width:150px">
		                            	<button id="pb_name" class="tb_btn white srch"><i class="fa fa-search"></i></button>
	                            	</td>
	                            	<th scope="row" id="t_sra_indv_amnno"><span class="tb_dot">귀표번호</span></th>
	                            	<td>
	                            		<input type="text" id="sra_indv_amnno">
	                            	</td>
	                            	<th scope="row" id="t_auc_prg_sq"><span class="tb_dot">경매번호</span></th>
	                            	<td>
	                            		<input type="text" id="auc_prg_sq">
	                            	</td>
	                            	<th scope="row" id="t_count_fee"><span class="tb_dot">임신감정비</span></th>
	                            	<td>
	                            		<input type="text" id="count_fee">
	                            		
	                            	</td>
	                            	<th scope="row" id="t_MhSogCow9_Chk"><span class="tb_dot">결장우 미포함</span></th>
	                            	<td>
	                            		<input type="checkbox" id="chk_no_bid" name="chk_no_bid" value="0">
	                            		<label id="chk_no_bid_text" for="chk_no_bid"> 부</label>
	                            	</td>
	                            	<th scope="row" id="t_MhSogCow10_Chk"><span class="tb_dot">딸린송아지 포함</span></th>
	                            	<td>
	                            		<input type="checkbox" id="chk_calf_cow" name="chk_calf_cow" value="0">
	                            		<label id="chk_calf_cow_text" for="chk_calf_cow">부</label>
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
					<li><a href="#tab1" id="pb_tab1" class="on">낙찰자정산서</a></li>
					<li><a href="#tab2" id="pb_tab2">매매대금영수증</a></li>
					<li><a href="#tab3" id="pb_tab3">경매후내역</a></li>
					<li><a href="#tab4" id="pb_tab4">미수금현황</a></li>
					<li><a href="#tab5" id="pb_tab5">정산내역(농가)</a></li>
					<li><a href="#tab6" id="pb_tab6">등록우 입금내역</a></li>
					<li><a href="#tab7" id="pb_tab7">운송비내역</a></li>
					<li><a href="#tab8" id="pb_tab8">경매집게표</a></li>
					<li><a href="#tab9" id="pb_tab9">총판매집게표</a></li>
					<li><a href="#tab10" id="pb_tab10">중도매인 정산내역</a></li>
					<li><a href="#tab11" id="pb_tab11">출하자 정산내역</a></li>
					<li><a href="#tab12" id="pb_tab12">수의사 지급내역</a></li>
					<li><a href="#tab13" id="pb_tab13">경매정보 연계</a></li>
					<li><a href="#tab14" id="pb_tab14">출생신고서</a></li>
					<li><a href="#tab15" id="pb_tab15">수의사금액</a></li>
				</ul>
			</div>
			
			<div id="tab1" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_ViewMhSogCow1" style="width:100%;">
	                </table>
                </div>
				<div class="listTable rsp_v" style="display:none">
					<table id="grd_MhSogCow1" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab2" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_ViewMhSogCow2" style="width:100%;">
	                </table>
                </div>
				<div class="listTable rsp_v" style="display:none">
					<table id="grd_MhSogCow2" style="width:100%;">
	                </table>
                </div>
                <div class="listTable rsp_v" style="display:none">  
					<table id="grd_MhSogCow2_1" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab3" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_ViewMhSogCow3" style="width:100%;">
	                </table>
                </div>
				
				<div class="listTable rsp_v" style="display:none">
					<table id="grd_MhSogCow3" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab4" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow4" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab5" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow5" style="width:100%;">
	                </table>
                </div>
                <div class="listTable rsp_v" id="hdn_grd_MhSogCow_5" style="display:none">
                	<table id="hdn_grd_MhSogCow5" style="width:100%;">
                	</table>
            	</div>
			</div>
			
			<div id="tab6" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow6" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab7" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow7" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab8" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow8" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab9" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow9" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab10" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_ViewMhSogCow10" style="width:100%;">
	                </table>
                </div>
                <div class="listTable rsp_v" style="display:none">
					<table id="grd_MhSogCow10" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab11" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow11" style="width:100%;">
	                </table>
                </div>
                <div class="listTable rsp_v" style="display:none">  
					<table id="grd_MhSogCow11_1" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab12" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow12" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab13" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow13" style="width:100%;">
	                </table>
                </div>
                <div class="listTable rsp_v" id="hdn_grd_MhSogCow_13" style="display:none">
                	<table id="hdn_grd_MhSogCow13" style="width:100%;">
                	</table>
            	</div>
			</div>
			
			<div id="tab14" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow14" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab15" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MhSogCow15" style="width:100%;">
	                </table>
                </div>
			</div>
			
			<div id="tab8_sub" class="sec_table">
                <div class="grayTable rsp_v">
                	<form id="frm_MhAucEntr">
                    <table>
                        <colgroup>
                            <col width="50">
                            <col width="70">
                            <col width="70">
                            <col width="70">
                            <col width="70">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>                                
                                <th scope="row"><span></span></th>
                                <th style="text-align:center;" scope="row">출장우</th>
                                <th style="text-align:center;" scope="row"><span>결장/유찰</span></th>
                                <th style="text-align:center;" scope="row"><span>낙찰</span></th>
                                <th style="text-align:center;" scope="row"><span>중량(Kg)</span></th>
                                <th style="text-align:center;" scope="row" colspan=3><span>암</span></th>
                                <th style="text-align:center;" scope="row" colspan=3><span>수</span></th>
                                <th style="text-align:center;" scope="row" colspan=3><span>거세</span></th>
                                <th style="text-align:center;" scope="row" colspan=3><span>기타</span></th>
                            </tr>
                            <tr>                                
                                <th style="text-align:center;" scope="row"><span>암</span></th>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="am_tot_su">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum_am_yu">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum7">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum9">
                                </td>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최저 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최고 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>평균 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최저 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최고 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>평균 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최저 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최고 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>평균 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최저 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>최고 낙찰가(원)</span></th>
                                <th style="text-align:center;" scope="row" rowspan=2><span>평균 낙찰가(원)</span></th>
                            </tr>
                            <tr>                                
                                <th style="text-align:center;" scope="row"><span>수</span></th>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="su_tot_su">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum_su_yu">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum8">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum10">
                                </td>
                            </tr>
                            <tr>                                
                                <th style="text-align:center;" scope="row"><span>거세</span></th>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="no_tot_su">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum_no_yu">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum11">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum13">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="am_lows_sra_sbid_am">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="am_max_sra_sbid_am">
                                </td>
                                <td rowspan=2>
                                    <input disabled="disabled" type="text" class="number" id="am_avg_sra_sbid_am">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="su_lows_sra_sbid_am">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="su_max_sra_sbid_am">
                                </td>
                                <td rowspan=2>
                                    <input disabled="disabled" type="text" class="number" id="su_avg_sra_sbid_am">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="no_lows_sra_sbid_am">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="no_max_sra_sbid_am">
                                </td>
                                <td rowspan=2>
                                    <input disabled="disabled" type="text" class="number" id="no_avg_sra_sbid_am">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="etc_lows_sra_sbid_am">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="etc_max_sra_sbid_am">
                                </td>
                                <td rowspan=2>
                                    <input disabled="disabled" type="text" class="number" id="etc_avg_sra_sbid_am">
                                </td>
                            </tr>
                            <tr>                                
                                <th style="text-align:center;" scope="row"><span>기타</span></th>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="etc_tot_su">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum_etc_yu">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum12">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="sum14">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="am_lows_sra_mwmnnm">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="am_max_sra_mwmnnm">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="su_lows_sra_mwmnnm">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="su_max_sra_mwmnnm">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="no_lows_sra_mwmnnm">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="no_max_sra_mwmnnm">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="etc_lows_sra_mwmnnm">
                                </td>
                                <td>
                                    <input disabled="disabled" type="text" class="number" id="etc_max_sra_mwmnnm">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
        </section>       
    </div>
</body>


</html>