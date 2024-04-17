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
    * 2. 파  일  명   : LALM0216
    * 3. 파일명(한글) : 출장우내역 출력
    *----------------------------------------------------------------------------* 
    *  작성일자      작성자     내용
    *----------------------------------------------------------------------------*
    * 2021.10.07   김태헌   최초작성
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
         fn_CreateGrid_2();
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
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true); 
        fn_setCodeBox("indv_sex_c", "INDV_SEX_C", 1, true, "전체"); 
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
          
        });
        
        
        $("#tab_2").click(function(){
            $(".ftsnm_td").hide();          
            $(".dong_td").show();
            $(".bothPrint_td").hide();
            $(".sordOrder_td").hide();
         
        });
        
        $("#tab_3").click(function(){
            $(".ftsnm_td").hide();          
            $(".dong_td").hide();
            $(".bothPrint_td").hide();
            $(".sordOrder_td").hide();
           
        });
        
        $("#tab_4").click(function(){
            $(".ftsnm_td").hide();          
            $(".dong_td").hide();
            $(".bothPrint_td").show();
            $(".sordOrder_td").hide();           
            
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
        $( "#prto_tpc_3" ).attr('checked','checked');
       
    
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
     		var results = sendAjaxFrm("frm_Search", "/LALM0216_selList", "POST");
            
            var result;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            }else{
                result = setDecrypt(results);
            }  
            result = fn_CreateGrid(result);
     	}else if($("#tab_2").hasClass("on")){
     		var results = sendAjaxFrm("frm_Search", "/LALM0216_selList_2", "POST"); 
            
            var result;
            
            if(results.status != RETURN_SUCCESS){
            	showErrorMessage(results);
            	return;
            }else{
            	result = setDecrypt(results);
            }        
            fn_CreateGrid_2(result);
        }else if($("#tab_3").hasClass("on")){
        	var results = sendAjaxFrm("frm_Search", "/LALM0216_selList_3", "POST"); 
            
            var result;
            
            if(results.status != RETURN_SUCCESS){
            	showErrorMessage(results);
            	return;
            }else{
            	result = setDecrypt(results);
            }
          
            fn_CreateGrid_3(result);
            	
     	}else if($("#tab_4").hasClass("on")){
     		var results = sendAjaxFrm("frm_Search", "/LALM0216_selList_4", "POST"); 
            
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
        	 // ★합천: 8808990656236 테스트: 8808990643625
        	 if(na_bzplc == '8808990656236') {
        		if($("#auc_obj_dsc").val() == "1") {
        			//tmp_title = "출장우 내역 조회";
        			tmp_title = "혈통송아지";
        		} else if($("#auc_obj_dsc").val() == "2") {
        			tmp_title = "일반송아지";
        		} else {
        			tmp_title = "큰소";
        		}
        		tmp_title = tmp_title + "출장우내역 " + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR");
        	
        	 // ★영주: 8808990687094 테스트: 8808990643625
        	 } else if(na_bzplc == '8808990687094') {
        		 tmp_title = $( "#auc_obj_dsc option:selected").text() + "출품내역 제" +  $("#qcn").val() + "차";
        	 
        	 } else {
        		 tmp_title = "가축경매(응찰자용)" + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR");
        	 }
        	 
        	 TitleData.title = tmp_title;
        	 TitleData.sub_title = "";
             TitleData.unit = "";
             TitleData.srch_condition =  tmp_condition;
             
             //거창 : sub title 변경
             if(na_bzplc == "8808990659701") {
                 TitleData.sub_title = $("#auc_obj_dsc :checked").text().replaceAll(/[^ㄱ-ㅎ가-힣]/g,'');            	 
             }
          	 // ★합천: 8808990656236             
          	   if(na_bzplc == "8808990656236") {          		 
            	 if($("#auc_obj_dsc").val() == "3") {
            		 ReportPopup('LALM0216R1_3',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그            		 
            	 } else {
            		/** 
            		* 23.05.22 jjw
            		* 송아지, 비육우 리포트 비육우(LALM0216R1_2)로 통일
            		**/            		
            	 	//ReportPopup('LALM0216R1_2_1',TitleData, 'grd_MhSogCow1', 'V');               //V:세로 , H:가로  , T :콘솔로그
           		 	ReportPopup('LALM0216R1_2',TitleData, 'grd_MhSogCow1', 'V');               //V:세로 , H:가로  , T :콘솔로그
            	 }
             
             // ★청도: 8808990656571
             } else if(na_bzplc == "8808990656571") {
            	 if($("#auc_obj_dsc").val() == "3" || $("#auc_obj_dsc").val() == "0") {
            		 ReportPopup('LALM0216R0',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else {
            		 ReportPopup('LALM0216R1_4',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 }
             
             // ★포항: 8808990679549 테스트: 8808990643625
             } else if(na_bzplc == "8808990679549") {
            	 var grid1 = fnSetGridDataEx('grd_MhSogCow1');
            	 if($("#auc_obj_dsc").val() == "1") {
            		 ReportPopup('LALM0216R0_6',TitleData, grid1, 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else {
            		 ReportPopup('LALM0216R0_7',TitleData, grid1, 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 }
             
             // ★영주: 8808990687094
             } else if(na_bzplc == "8808990687094") {   
            	 if($("#auc_obj_dsc").val() == "1") {
            		 ReportPopup('LALM0216R0_8',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else if($("#auc_obj_dsc").val() == "2") {
            		 ReportPopup('LALM0216R0_11',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else if($("#auc_obj_dsc").val() == "3") {
            		 ReportPopup('LALM0216R0_9',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else {
            		 ReportPopup('LALM0216R0_12',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 }
             
             // ★사천: 8808990656519 테스트: 8808990643625
             } else if(na_bzplc == "8808990656519") {
            	 if($("#auc_obj_dsc").val() == "1") {
            		 ReportPopup('LALM0216R0_13',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else {
            		 ReportPopup('LALM0216R0',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 }
             
             // ★순정 정읍: 8808990656953 테스트: 8808990643625
             } else if(na_bzplc == "8808990656953") {
            	 ReportPopup('LALM0216R0_16',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
             
             // 가로(1형식)
             } else if($("#prto_tpc_1").is(":checked")) {
            	 if($("#auc_obj_dsc").val() == "1") {
            		 ReportPopup('LALM0216R0_3',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else {
            		 ReportPopup('LALM0216R0_2',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 }
             
             // 가로(3형식) - 경주
             } else if($("#prto_tpc_5").is(":checked")) {
            	 if($("#auc_obj_dsc").val() == "3") {
            		 ReportPopup('LALM0216R0_4',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
       			//구미칠곡 : 8808990657615
    		 	}else if(na_bzplc == '8808990657615'){
    		 		var gridData = fnSetGridData1('grd_MhSogCow1');
    				ReportPopup('LALM0216R0_0',TitleData, gridData, 'V');              //V:세로 , H:가로  , T :콘솔로그
    		 	} else {
    		 		var gridData = fnSetGridData1('grd_MhSogCow1');
            		 ReportPopup('LALM0216R0_1',TitleData, gridData, 'V');              //V:세로 , H:가로  , T :콘솔로그
            	}
             
             // 가로(4형식) - 거창
             } else if($("#prto_tpc_7").is(":checked")) {
             	if($("#auc_obj_dsc").val() == "3") {
            		 ReportPopup('LALM0216R0_5',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else if(na_bzplc == "8808990657103"){
               		 ReportPopup('LALM0216R0_10_1',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
               	 } else {
            		 ReportPopup('LALM0216R0_10',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 }
             
             } else {
            	 // 송아지
            	 if($("#auc_obj_dsc").val() == "1") {
            		 // ★김해: 8808990670737 테스트: 8808990643625
            		 if(na_bzplc == "8808990670737") {
            			 ReportPopup('LALM0216R0_1_1',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            		 // ★고창: 8808990657189 테스트: 8808990643625
            		 } else if(na_bzplc == "8808990657189") {
            			 ReportPopup('LALM0216R0_14',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            		 // ★고창: 8808990762654 테스트: 8808990643625
            		 } else if(na_bzplc == "8808990762654") {
            			 ReportPopup('LALM0216R0_18',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그            		 
            		 } else if(na_bzplc == "8808990657240"){ //진주 : 8808990657240
            			 var gridData = fnSetGridData1('grd_MhSogCow1');
            			 ReportPopup('LALM0216R0_1_0',TitleData, gridData, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }else {
            			 var gridData = fnSetGridData1('grd_MhSogCow1');
            			 ReportPopup('LALM0216R0_1',TitleData, gridData, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }
				 // 비육우, 번식우
            	 } else {
            		 // ★고창: 8808990657189 테스트: 8808990643625
            		 if(na_bzplc == "8808990657189") {
            			 ReportPopup('LALM0216R0_15',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	     // 당진 : 8808990762654  테스트 : 8808990643625
            		 } else if(na_bzplc == "8808990762654") {
            			 ReportPopup('LALM0216R0_18',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
              		// 양평 : 8808990643625
                 	}else if(na_bzplc == "8808990643625") {
                 		var gridData = fnSetGridData1('grd_MhSogCow1');
                 		ReportPopup('LALM0216R0',TitleData, gridData, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }else {
            			 ReportPopup('LALM0216R0',TitleData, 'grd_MhSogCow1', 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }
            	 }
             }
         
         // 경매후(관리자용)
         } else if($("#tab_3").hasClass("on")) {
        	 // ★합천: 8808990656236 테스트: 8808990643625
        	 if(na_bzplc == '8808990656236') {                                  
        		if($("#auc_obj_dsc").val() == "1") {
        			tmp_title = "혈통송아지";
        		} else if($("#auc_obj_dsc").val() == "2") {
        			tmp_title = "일반송아지";
        		} else {
        			tmp_title = "큰소";
        		}
        		tmp_title = tmp_title + "(관리자용)" + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR");
        	
        	 // ★영주: 8808990687094 테스트: 8808990643625
        	 } else if(na_bzplc == '8808990687094') {                      
        		 tmp_title = fn_deleteNumber($( "#auc_obj_dsc option:selected").text()) + "출품내역 제" +  $("#qcn").val() + "차";
        	 
        	 } else {
        		 tmp_title = "일반가축경매(관리자용)" + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR");
        	 }
        	 
        	 TitleData.title = tmp_title;
        	 TitleData.sub_title = "";
             TitleData.unit = "";
             TitleData.srch_condition = tmp_condition;
             
             // 세로(1형식) - 해남진도
             if($("#prto_tpc_2").is(":checked")) {
            	 ReportPopup('LALM0216R1_1',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
             } else {
            	 // ★합천: 8808990656236 테스트: 8808990643625
            	 if(na_bzplc == '8808990656236') {
            		 if($("#auc_obj_dsc").val() == "3") {
                		 ReportPopup('LALM0216R1_6',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
                	 } else {
                		 ReportPopup('LALM0216R1_5',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
                	 }
            	 
            	 // ★영주: 8808990687094  테스트:8808990643625
            	 } else if(na_bzplc == '8808990687094') {
            		 if($("#auc_obj_dsc").val() == "3") {
                		 ReportPopup('LALM0216R1_8',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
                	 } else {
                		 ReportPopup('LALM0216R1',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
                	 }
            	 
            	 // ★김해: 8808990670737
            	 } else if(na_bzplc == '8808990670737') {
            		 ReportPopup('LALM0216R1_7',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 
            	 // ★예천: 8808990656557
            	 } else if(na_bzplc == '8808990656557') {
            		 ReportPopup('LALM0216R1_9',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 
            	 } else {
            		 ReportPopup('LALM0216R1',TitleData, 'grd_MhSogCow2', 'V');              //V:세로 , H:가로  , T :콘솔로그
            		
            	 }
             }
             
       	 // 경매전(게시판용)	 
         } else if($("#tab_2").hasClass("on")) {
        	 if(parent.envList[0] == null) {
     			MessagePopup("OK", "응찰단위금액이 입력되지 않았습니다.",function(res){
     				fn_OpenMenu('LALM0912','');
     				return;
     			});
     			
     			return;
     		 }
        	 
        	 // ★합천: 8808990656236 테스트: 8808990643625
        	 if(na_bzplc == '8808990656236') {                                      
        		if($("#auc_obj_dsc").val() == "1") {
        			tmp_title = "혈통송아지";
        		} else if($("#auc_obj_dsc").val() == "2") {
        			tmp_title = "일반송아지";
        		} else {
        			tmp_title = "큰소";
        		}
        		tmp_title = tmp_title + " 출품내역 제" +  $("#qcn").val() + "차";
        	
        	 } else {
        		 tmp_title = fn_deleteNumber($( "#auc_obj_dsc option:selected").text()) + " 출품내역 제" +  $("#qcn").val() + "차";
        	 }
        	 
        	 TitleData.title = tmp_title;
        	 TitleData.sub_title = "(" + fn_toDate(fn_dateToData($('#auc_dt').val()),"KR") + ")";
             TitleData.srch_condition = tmp_condition;
        	 
        	 if($("#auc_obj_dsc").val() == "1") {
        		 if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "1000") {
        			 TitleData.unit = "천원";
        			 TitleData.am = "1000";
        		 } else if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "10000") {
        			 TitleData.unit = "만원";
        			 TitleData.am = "10000";
        		 } else {
        			 TitleData.unit = "원";
        			 TitleData.am = "1";
        		 }
        		 
        	 } else if($("#auc_obj_dsc").val() == "3") {
        		 if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "1000") {
        			 TitleData.unit = "천원";
        			 TitleData.am = "1000";
        		 } else if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "10000") {
        			 TitleData.unit = "만원";
        			 TitleData.am = "10000";
        		 } else {
        			 TitleData.unit = "원";
        			 TitleData.am = "1";
        		 }
        		 
        	 } else {
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
        	 }
        	 
        	 // 합천 경매후(관리자용) 가로 요청
        	 if($("#prto_tpc_1").is(":checked")) {
        		 // ★합천: 8808990656236 테스트: 8808990643625
        		 if(na_bzplc == '8808990656236') {
            		 ReportPopup('LALM0216R2_3',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        		 } else {
        			 ReportPopup('LALM0216R2_1',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        		 }
        		 
        	 } else {
        		 // ★합천: 8808990656236 , 진천 : 8808990656502
        		 if(na_bzplc == '8808990656236' || na_bzplc == '8808990656502') {
        			 ReportPopup('LALM0216R2_2',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        		 
        		 // ★김해: 8808990670737  테스트: 8808990643625
        		 } else if(na_bzplc == '8808990670737') {
        			 ReportPopup('LALM0216R2_4',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        		 
        		 // ★포항: 8808990679549
        		 } else if(na_bzplc == '8808990679549') {
        			 ReportPopup('LALM0216R2_5',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        		 
        		 // ★영주: 8808990687094
        		 } else if(na_bzplc == '8808990687094') {
        			 if($("#auc_obj_dsc").val() == "1") {
        				 ReportPopup('LALM0216R2_8',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        				 
             		} else if($("#auc_obj_dsc").val() == "2") {
             			ReportPopup('LALM0216R2_7',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		} else if($("#auc_obj_dsc").val() == "3") {
             			ReportPopup('LALM0216R2_6',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
             		}
        			 
        		 // ★괴산: 8808990656670
        		 } else if(na_bzplc == '8808990656670') {
        			 ReportPopup('LALM0216R2_9',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        		 
        		 } else {
        			 ReportPopup('LALM0216R2',TitleData, 'grd_MhSogCow3', 'V');              //V:세로 , H:가로  , T :콘솔로그
        			 
        		 }
        	 }
        	 
        	 
         // 경매전(거치대용)
         } else if($("#tab_4").hasClass("on")) {
        	 TitleData.title = "";
        	 TitleData.sub_title = "";
             TitleData.srch_condition = tmp_condition;
             
             if($("#auc_obj_dsc").val() == "1") {
        		 if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "1000") {
        			 TitleData.unit = "천원";
        			 TitleData.am = "1000";
        		 } else if(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"] == "10000") {
        			 TitleData.unit = "만원";
        			 TitleData.am = "10000";
        		 } else {
        			 TitleData.unit = "원";
        			 TitleData.am = "1";
        		 }
        		 
        	 } else if($("#auc_obj_dsc").val() == "3") {
        		 if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "1000") {
        			 TitleData.unit = "천원";
        			 TitleData.am = "1000";
        		 } else if(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"] == "10000") {
        			 TitleData.unit = "만원";
        			 TitleData.am = "10000";
        		 } else {
        			 TitleData.unit = "원";
        			 TitleData.am = "1";
        		 }
        		 
        	 } else {
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
        	 }
            
            var grid4 = fnSetGridData('grd_MhSogCow4');        	
             
             // 번식우
             if($("#auc_obj_dsc").val() == "3") {
            	 if($("#prto_tpc_1").is(":checked")) { //가로
            		 // ★의성: 8808990656649 테스트: 8808990643625
            		 if(na_bzplc == '8808990656649') {
            			 ReportPopup('LALM0216R3_1_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }else if(na_bzplc == '8808990656878' || na_bzplc == '8808990689180' || na_bzplc == '8808990785431') { //강릉, 안동봉화, 영덕울진
            			 ReportPopup('LALM0216R3_1_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 } else if(na_bzplc == '8808990656236'){ //합천 EPD : 8808990656236
            			 grid4 = grid4.map((o,i)=>{
         						var tempAddr = [];
         						o.DONGUP.split(" ").forEach((o,i)=>{
         						    if(o.endsWith('읍') || o.endsWith('면') || o.endsWith('동')){
         						        tempAddr.push(o);
         						    }
         						});
         						o.DONG = tempAddr.join(" ");
            				 return o;
            			 });
            			 ReportPopup('LALM0216R3_E_0',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 } else {
            			 ReportPopup('LALM0216R3_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }
            	 
            	 } else if($("#prto_tpc_2").is(":checked")) { //세로
            		 if(na_bzplc == '8808990656274') {
             			 ReportPopup('LALM0216R3_43',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             			
             			
            		 }else {
                		 ReportPopup('LALM0216R3_3',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }            	 
            	 } else if($("#prto_tpc_3").is(":checked")) { //가로2형식
            		 // ★동해삼척태백: 8808990652825 테스트: 8808990643625
            		 if(na_bzplc == '8808990652825') {
            			 ReportPopup('LALM0216R3_51',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★안동봉화: 8808990689180 영덕울진: 8808990785431
            		 } else if(na_bzplc == '8808990689180' || na_bzplc == '8808990785431') {
            			 ReportPopup('LALM0216R3_1_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★영주: 8808990687094
            		 } else if(na_bzplc == '8808990687094') {
            			 ReportPopup('LALM0216R3_89',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★전주김제: 8808990656441 전주김제 김제지점: 8808990766485
            		 } else if(na_bzplc == '8808990656441' || na_bzplc == '8808990766485') {
   	            		 grid4 = grid4.map((o,i)=>{	
   							if(o.CALF_SRA_INDV_AMNNO){
   								var tempSraNo = o.CALF_SRA_INDV_AMNNO.substr(3);
   								o.CALF_SRA_INDV_AMNNO = tempSraNo.substr(0,3)+'-'+tempSraNo.substr(3);									
   							}
   							if(o.RG_DSC == '미등록우'){
   								o.RG_DSC = '';
   							}
   							if(o.MCOW_DSC == '미등록우'){
   								o.MCOW_DSC = '';
   							}
   							return o;
   						}); 
						ReportPopup('LALM0216R3_63',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★진천: 8808990656502
            		 } else if(na_bzplc == '8808990656502') {
            			 ReportPopup('LALM0216R3_65',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★함안: 8808990656946 의령 : 8808990656199 테스트: 8808990643625
            		 } else if(na_bzplc == '8808990656199') {
            			 ReportPopup('LALM0216R3_85',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            		 // ★포항: 8808990679549
            		 } else if(na_bzplc == '8808990679549') {
            			 ReportPopup('LALM0216R3_110',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 // ★남원 : 8808990227207
            		 } else if(na_bzplc == '8808990227207'){
	            		 grid4 = grid4.map((o,i)=>{	
							if(o.CALF_SRA_INDV_AMNNO){
								var tempSraNo = o.CALF_SRA_INDV_AMNNO.substr(3);
								o.CALF_SRA_INDV_AMNNO = tempSraNo.substr(0,3)+'-'+tempSraNo.substr(3);									
							}
							if(o.RG_DSC == '미등록우'){
								o.RG_DSC = '';
							}
							if(o.MCOW_DSC == '미등록우'){
								o.MCOW_DSC = '';
							}
							return o;
						}); 
            			 ReportPopup('LALM0216R3_5_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		// ★양평 : 8808990643625	 , ★원주 : 8808990656434	 
            		 } else if(na_bzplc == '8808990643625' || na_bzplc == '8808990656434') {
						ReportPopup('LALM0216R3_5_0',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
	                 // 영천축협 : 8808990656687
	     	         } else if(na_bzplc == '8808990656687') {
	     	        	ReportPopup('LALM0216R3_5_2',TitleData, grid4, 'V');
            		 // 고성축협 : 8808990812007
	     	         } else if(na_bzplc == '8808990812007'){
	     	        	ReportPopup('LALM0216R3_18_4',TitleData, grid4, 'V');
	     	         // 수원축협 : 8808990656496	
            		 } else if(na_bzplc == '8808990656496'){
            			 ReportPopup('LALM0216R3_6_4',TitleData, grid4, 'V');
            		 // 평택축협 : 8808990795874	 
            		 } else if(na_bzplc == '8808990795874'){
            			 ReportPopup('LALM0216R3_115',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 } else if(na_bzplc == '8808990656571'){//청도축협
						ReportPopup('LALM0216R3_5_J_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }else if(na_bzplc == '8808990656694'){ //서산태안
						 ReportPopup('LALM0216R3_6_J_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
						 
					 } else if(na_bzplc == '8808990657639'){ //상주축협
						ReportPopup('LALM0216R3_18_5',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 } else if(na_bzplc == '8808990658995'){
            			 ReportPopup('LALM0216R3_5_3',TitleData, grid4, 'V'); 
            		 }else {
						ReportPopup('LALM0216R3_5',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 }
            	 } else if($("#prto_tpc_4").is(":checked")) { //세로2형식
            		 // ★함평: 8808990656601 영암: 8808990689760 테스트: 8808990643625
            		 if(na_bzplc == '8808990656601' || na_bzplc == '8808990689760') {
            			 ReportPopup('LALM0216R3_50',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★거창: 8808990659701
            		 } else if(na_bzplc == '8808990659701') {
            			 ReportPopup('LALM0216R3_61',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★함양산청: 8808990656410 산청지점: 8808990674506, 진주 : 8808990657240
            		 } else if(na_bzplc == '8808990656410' || na_bzplc == '8808990674506') {
            			 ReportPopup('LALM0216R3_78',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★영광축협: 8808990811710 
            		 } else if(na_bzplc == '8808990811710') {
            			 ReportPopup('LALM0216R3_82',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 // ★하동축협: 8808990656656 테스트: 8808990643625
            		 } else if(na_bzplc == '8808990656656') { 
            			 ReportPopup('LALM0216R3_95',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★고령성주: 8808990659695 테스트: 8808990643625
            		 } else if(na_bzplc == '8808990659695') {
            			 ReportPopup('LALM0216R3_99',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 // 밀양축협 : 8808990656663
             		 } else if(na_bzplc == '8808990656663') {
             			ReportPopup('LALM0216R3_8_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             			
             		 // ★순정축협(순창): 8808990656960
             		 }  else if(na_bzplc == '8808990656960') {
             			ReportPopup('LALM0216R3_8_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             			
             		 } else if(na_bzplc == '8808990817675'){
            			 ReportPopup('LALM0216R3_7_J_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }else {
            			 ReportPopup('LALM0216R3_7',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }
            		 
            	 } else if($("#prto_tpc_5").is(":checked")) {//가로3형식
            		 // ★해남: 8808990656106 의령 : 8808990656199 테스트: 8808990643625
            		 if(na_bzplc == '8808990656106' || na_bzplc == '8808990656199') {
            			 ReportPopup('LALM0216R3_56',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else {
            			 ReportPopup('LALM0216R3_11',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }
            	 
            	 } else if($("#prto_tpc_6").is(":checked")) { //세로3형식
            		 // ★해남: 8808990656106
            		 if(na_bzplc == '8808990656106') {
            			 ReportPopup('LALM0216R3_86',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else {
            			 ReportPopup('LALM0216R3_13',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }
            	 
            	 } else if($("#prto_tpc_7").is(":checked")) { //가로4형식
            		 if(na_bzplc == '8808990658995'){ //청주축협 : 8808990658995
            			 ReportPopup('LALM0216R3_5_3',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else{
                		 ReportPopup('LALM0216R3_14',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }
            		 
            	 } else if($("#prto_tpc_8").is(":checked")) { //세로4형식
            		 ReportPopup('LALM0216R3_10',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_9").is(":checked")) { //가로 5형식
            		 ReportPopup('LALM0216R3_17',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_10").is(":checked")) { //세로5형식
            		 ReportPopup('LALM0216R3_16',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_11").is(":checked")) { //가로6형식
            		 // 음성: 8808990683973
            		 if(na_bzplc == '8808990683973') {
            			 ReportPopup('LALM0216R3_73',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // 상주 8808990657639
            		 } else if(na_bzplc == '8808990657639') {
            			 ReportPopup('LALM0216R3_103',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else if(na_bzplc == '8808990660783') { //임실
            			 ReportPopup('LALM0216R3_114',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else if(na_bzplc == '8808990656557'){ //예천 :8808990656557 
            			 ReportPopup('LALM0216R3_18_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else if(na_bzplc == '8808990656540'){ //담양 : 8808990656540 
            			 ReportPopup('LALM0216R3_18_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else if(na_bzplc == '8808990656465'){ //충주 : 8808990656465 
            			 ReportPopup('LALM0216R3_18_3',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else if(na_bzplc == '8808990656229'){	//춘천철원 : 8808990656229
            			 ReportPopup('LALM0216R3_18_4_1',TitleData, grid4, 'V');
            	 
            		 }else if(na_bzplc == '8808990659275') { //나주축협
               			 ReportPopup('LALM0216R3_83_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그               			 
               		 } else {
            			 ReportPopup('LALM0216R3_18',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }
            	 
            	 } else if($("#prto_tpc_12").is(":checked")) { //세로6형식
            		 ReportPopup('LALM0216R3_20',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_13").is(":checked")) { //가로7형식
            		 // ★나주: 8808990659275  테스트: 8808990643625
            		 if(na_bzplc == '8808990659275') {
            			 ReportPopup('LALM0216R3_83',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else if(na_bzplc == '8808990656694'){ //서산태안 : 8808990656694
            			 ReportPopup('LALM0216R3_22_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else {
            			 ReportPopup('LALM0216R3_22',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }
            		 
            	 } else if($("#prto_tpc_14").is(":checked")) { //세로7형식
            		 // ★합천: 8808990656236
            		 if(na_bzplc == '8808990656236') {
            			 ReportPopup('LALM0216R3_28_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else {
            			 ReportPopup('LALM0216R3_28',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }
            		 
            	 } else if($("#prto_tpc_15").is(":checked")) {
            		 ReportPopup('LALM0216R3_27_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 //ReportPopup('LALM0216R3_27_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_17").is(":checked")) {
            		 ReportPopup('LALM0216R3_29',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_19").is(":checked")) {
            		 ReportPopup('LALM0216R3_32',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_21").is(":checked")) {
            		 if(na_bzplc == '8808990656687'){ //영천
                		 ReportPopup('LALM0216R3_5_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else if(na_bzplc == '8808990656229'){	//춘천철원 : 8808990656229
            			 ReportPopup('LALM0216R3_18_4',TitleData, grid4, 'V');
            	 
            		 }else{
                		 ReportPopup('LALM0216R3_35',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }
            		 
            	 } else if($("#prto_tpc_22").is(":checked")) {
            		 // ★합천: 8808990656236 
            		 if(na_bzplc == '8808990656236') {
            			 ReportPopup('LALM0216R3_76',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else {
            			 ReportPopup('LALM0216R3_37',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }
           		 
            	 } else if($("#prto_tpc_23").is(":checked")) {
            		 // ★익산: 8808990227283 테스트:8808990643625
            		 if(na_bzplc == '8808990227283') {
            			 ReportPopup('LALM0216R3_69',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★평택: 8808990795874
            		 } else if(na_bzplc == '8808990795874') {
            			 ReportPopup('LALM0216R3_105',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // 세종공주축협 8808990656588
            		 } else if(na_bzplc == '8808990656588'){
            			 ReportPopup('LALM0216R3_41',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else {
            			 ReportPopup('LALM0216R3_39',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }
            		 
            	 }
           
             // 비육우
             } else if($("#auc_obj_dsc").val() == "2") {
            	 if($("#prto_tpc_1").is(":checked")) {
            		 // 의성 : 8808990656649
            		 if(na_bzplc == '8808990656649') {
            			 ReportPopup('LALM0216R3_2_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그 
             		 // 강릉 : 8808990656878 ,안동봉화 : 8808990689180 , 영덕울진: 8808990785431
             		 } else if(na_bzplc == '8808990656878' || na_bzplc == '8808990689180' || na_bzplc == '8808990785431') {
            			 ReportPopup('LALM0216R3_6_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else if(na_bzplc == '8808990656236'){ //합천 EPD : 8808990656236
						grid4 = grid4.map((o,i)=>{
      						var tempAddr = [];
      						o.DONGUP.split(" ").forEach((o,i)=>{
      						    if(o.endsWith('읍') || o.endsWith('면') || o.endsWith('동')){
      						        tempAddr.push(o);
      						    }
      						});
      						o.DONG = tempAddr.join(" ");
	         				 return o;
         			 	});
         			 	ReportPopup('LALM0216R3_E_0',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
         		 	}  else{
                		 ReportPopup('LALM0216R3_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		}
            	 
            	 } else if($("#prto_tpc_2").is(":checked")) {
            		// ★의령: 8808990656199 테스트: 8808990643625
            		 if(na_bzplc == '8808990656199') {
            			 ReportPopup('LALM0216R3_68',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★하동축협: 8808990656656
            		 } else if(na_bzplc == '8808990656656') {
            			 ReportPopup('LALM0216R3_97',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else if(na_bzplc == '8808990656274') {
               			 ReportPopup('LALM0216R3_43',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
               		 } else {
            			 ReportPopup('LALM0216R3_4',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			              
            			 
            		 }
            	 
            	 } else if($("#prto_tpc_3").is(":checked")) {
             		 // ★임실: 8808990660783 테스트: 8808990643625
             		 if(na_bzplc == '8808990660783') {
             			 ReportPopup('LALM0216R3_42',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★안동봉화: 8808990689180 영덕울진: 8808990785431 상주 : 8808990657639
             		 } else if(na_bzplc == '8808990689180' || na_bzplc == '8808990785431' || na_bzplc == '8808990657639') {
             			 ReportPopup('LALM0216R3_6_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★영주: 8808990687094
             		 } else if(na_bzplc == '8808990687094') {
            			 ReportPopup('LALM0216R3_88',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★음성: 8808990683973
             		 } else if(na_bzplc == '8808990683973') {
            			 ReportPopup('LALM0216R3_72',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 // ★예천축협 : 8808990656557
             		 } else if(na_bzplc == '8808990656557') {
            			 ReportPopup('LALM0216R3_98',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            		 // ★포항축협 : 8808990679549
             		 } else if(na_bzplc == '8808990679549') {
            			 ReportPopup('LALM0216R3_109',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		
            	 	 // ★양평축협 : 8808990643625
             		 } else if(na_bzplc == '8808990643625') {
            			 ReportPopup('LALM0216R3_112',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            		 // 영천축협 : 8808990656687
	         		 } else if(na_bzplc == '8808990656687') {
	        			 ReportPopup('LALM0216R3_6_3',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
	        		 
	        		 } else if(na_bzplc == '8808990227207'){
	            		 grid4 = grid4.map((o,i)=>{	
							if(o.RG_DSC == '미등록우'){
								o.RG_DSC = '';
							}
							if(o.MCOW_DSC == '미등록우'){
								o.MCOW_DSC = '';
							}
							return o;
						 }); 
             			 ReportPopup('LALM0216R3_6_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // 수원축협 : 8808990656496
             		 } else if(na_bzplc == '8808990656496'){
            			 ReportPopup('LALM0216R3_6_4',TitleData, grid4, 'V');
            			 
            		 // 평택축협 : 8808990795874	 
            		 } else if(na_bzplc == '8808990795874'){
            			 ReportPopup('LALM0216R3_115',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else if(na_bzplc == '8808990656694'){ //서산태안
             			 ReportPopup('LALM0216R3_6_J_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 } else if(na_bzplc == '8808990659268'){ //논산계룡
             			 ReportPopup('LALM0216R3_6_6',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 } else {
             			 ReportPopup('LALM0216R3_6',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 }
            	 
            	 } else if($("#prto_tpc_4").is(":checked")) {
            		 // ★함평: 8808990656601 영암: 8808990689760
            		 //|| na_bzplc == '8808990689760'
              		 if(na_bzplc == '8808990656601' ) {
              			 ReportPopup('LALM0216R3_48',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
                	 // ★영암축협: 8808990689760
            		 }else if(na_bzplc == '8808990689760'){
             			ReportPopup('LALM0216R3_20',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              		 // ★영광축협: 8808990811710 장성: 8808990817675
              		 } else if(na_bzplc == '8808990811710') {
              			 ReportPopup('LALM0216R3_81',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그              			 
              		 // ★하동축협: 8808990656656
              		 } else if(na_bzplc == '8808990656656') {
             			 ReportPopup('LALM0216R3_94',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             			 
             		 // ★순정축협(순창): 8808990656960
             		 }  else if(na_bzplc == '8808990656960') {
             			ReportPopup('LALM0216R3_8_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		// 밀양축협 : 8808990656663
             		 } else if(na_bzplc == '8808990656663') {
             			ReportPopup('LALM0216R3_8_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그                        	
             		// 의령축협 : 8808990656199
             		 } else if(na_bzplc == '8808990656199'){
             			ReportPopup('LALM0216R3_8_3',TitleData, grid4, 'V');				//V:세로 , H:가로  , T :콘솔로그
             		//	고흥축협 : 8808990779546
             		 } else if(na_bzplc == '8808990779546'){
             			ReportPopup('LALM0216R3_8_4',TitleData, grid4, 'V');				//V:세로 , H:가로  , T :콘솔로그 
             		 // 보성축협 : 8808990656267
             		 } else if(na_bzplc == '8808990656267'){
             			ReportPopup('LALM0216R3_8_5',TitleData, grid4, 'V');				//V:세로 , H:가로  , T :콘솔로그
             		// 진주축협 : 8808990657240
             		 }else if(na_bzplc == '8808990657240'){
             			ReportPopup('LALM0216R3_77_1',TitleData, grid4, 'V');				//V:세로 , H:가로  , T :콘솔로그 
             		 } else {
              			 ReportPopup('LALM0216R3_8',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그              			 
              		 }
            		 
            	 } else if($("#prto_tpc_5").is(":checked")) {
            		// ★해남: 8808990656106
              		 if(na_bzplc == '8808990656106') {
              			 ReportPopup('LALM0216R3_57',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 } else {
              			 ReportPopup('LALM0216R3_12',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              			 
              		 }
            	 
            	 } else if($("#prto_tpc_6").is(":checked")) {
             		 // ★해남: 8808990656106
               		 if(na_bzplc == '8808990656106') {
               			 ReportPopup('LALM0216R3_90',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              			 
              		 } else {
               			 ReportPopup('LALM0216R3_13',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
               			 
               		 }
               	 
            	 } else if($("#prto_tpc_7").is(":checked")) {
            		 ReportPopup('LALM0216R3_14',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_8").is(":checked")) {
            		 ReportPopup('LALM0216R3_9',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_9").is(":checked")) {
            		 ReportPopup('LALM0216R3_17',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_10").is(":checked")) {
            		 // ★부여: 8808990660127
               		 if(na_bzplc == '8808990660127') {
               			 ReportPopup('LALM0216R3_46',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              			 
              		 } else {
               			 ReportPopup('LALM0216R3_15',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
               			 
               		 }
            		 
            	 } else if($("#prto_tpc_11").is(":checked")) {
            		 if(na_bzplc=='8808990659275'){
                		 ReportPopup('LALM0216R3_83_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }           		  
            		 
            	 }else if($("#prto_tpc_12").is(":checked")) {
            		 if(na_bzplc=='8808990657646'){
                		 ReportPopup('LALM0216R3_23',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }else{
                		 ReportPopup('LALM0216R3_20',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그            			 
            		 }            		  
            		 
            	 } else if($("#prto_tpc_13").is(":checked")) {
            		 // ★나주: 8808990659275 테스트: 8808990643625
               		 if(na_bzplc == '8808990659275') {
               			 ReportPopup('LALM0216R3_83',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              			 
              		 } else if(na_bzplc == '8808990656694'){ //서산태안 : 8808990656694
            			 ReportPopup('LALM0216R3_22_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else {
               			 ReportPopup('LALM0216R3_22',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
               			 
               		 }
            		 
            	 } else if($("#prto_tpc_14").is(":checked")) {
            		 // ★합천: 8808990656236
               		 if(na_bzplc == '8808990656236') {
               			 ReportPopup('LALM0216R3_28_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              			 
              		 } else {
               			 ReportPopup('LALM0216R3_28',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
               			 
               		 }
            		 
            	 } else if($("#prto_tpc_15").is(":checked")) {
        			 //경주 비육우
               		 ReportPopup('LALM0216R3_26_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_17").is(":checked")) {
            		 ReportPopup('LALM0216R3_30',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_19").is(":checked")) {
            		 ReportPopup('LALM0216R3_33',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_21").is(":checked")) {
            		 ReportPopup('LALM0216R3_36',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_22").is(":checked")) {
            		 ReportPopup('LALM0216R3_38',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_23").is(":checked")) {
            		 // ★익산: 8808990227283 테스트: 8808990643625
               		 if(na_bzplc == '8808990227283') {
               			 ReportPopup('LALM0216R3_70',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              			 
               		 // 세종공주축협 8808990656588
              		 } else if(na_bzplc == '8808990656588'){
              			ReportPopup('LALM0216R3_41',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
              			
              		 } else {
               			 ReportPopup('LALM0216R3_40',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
               			 
               		 }
            		 
            	 }
             
             // 송아지
             } else {
            	 if($("#prto_tpc_1").is(":checked")) {
            		 // ★의성: 8808990656649 테스트: 8808990643625
             		 if(na_bzplc == '8808990656649') {
             			 ReportPopup('LALM0216R3_2_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★포항: 8808990679549
             		 } else if(na_bzplc == '8808990679549') {
             			 ReportPopup('LALM0216R3_45',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★순정 정읍: 8808990656953
             		 } else if(na_bzplc == '8808990656953') {
             			 ReportPopup('LALM0216R3_92',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 //강릉 : 8808990656878 안동봉화 : 8808990689180 , 영덕울진: 8808990785431
             		 } else if(na_bzplc == '8808990656878' || na_bzplc == '8808990689180' || na_bzplc == '8808990785431') {
            			 ReportPopup('LALM0216R3_6_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else if(na_bzplc == '8808990656236'){ //합천 EPD : 8808990656236
					 	grid4 = grid4.map((o,i)=>{
      						var tempAddr = [];
      						o.DONGUP.split(" ").forEach((o,i)=>{
      						    if(o.endsWith('읍') || o.endsWith('면') || o.endsWith('동')){
      						        tempAddr.push(o);
      						    }
      						});
      						o.DONG = tempAddr.join(" ");
	         				return o;
         			 	});
         			 	ReportPopup('LALM0216R3_E_0',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
         		 	 }else {
             			 ReportPopup('LALM0216R3_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 }
            	 
            	 } else if($("#prto_tpc_2").is(":checked")) {
            		 // ★의령: 8808990656199 테스트: 8808990643625
             		 if(na_bzplc == '8808990656199') {
             			 ReportPopup('LALM0216R3_68',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★하동축협: 8808990656656
             		 } else if(na_bzplc == '8808990656656') {
             			 ReportPopup('LALM0216R3_97',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             			
             			
            		 } else if(na_bzplc == '8808990656274') {
             			 ReportPopup('LALM0216R3_43',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             			
             			
            		 } else {
             			 ReportPopup('LALM0216R3_4',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }
            	 
            	 } else if($("#prto_tpc_3").is(":checked")) {
            		 // ★임실: 8808990660783 테스트: 8808990643625
             		 if(na_bzplc == '8808990660783') {
             			 ReportPopup('LALM0216R3_42',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★김해: 8808990670737
             		 } else if(na_bzplc == '8808990670737') {
             			 ReportPopup('LALM0216R3_44',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★동해삼척태백: 8808990652825
             		 } else if(na_bzplc == '8808990652825') {
            			 ReportPopup('LALM0216R3_52',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★안동봉화: 8808990689180 영덕울진: 8808990785431, 상주 : 8808990657639
             		 } else if(na_bzplc == '8808990689180' || na_bzplc == '8808990785431' || na_bzplc == '8808990657639') {
             			 ReportPopup('LALM0216R3_6_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★영주: 8808990687094
             		 } else if(na_bzplc == '8808990687094') {
             			 ReportPopup('LALM0216R3_87',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★전주김제: 8808990656441 전주김제 김제지점: 8808990766485 
             		 } else if(na_bzplc == '8808990656441' || na_bzplc == '8808990766485') {
	   	            		 grid4 = grid4.map((o,i)=>{	
	   							if(o.CALF_SRA_INDV_AMNNO){
	   								var tempSraNo = o.CALF_SRA_INDV_AMNNO.substr(3);
	   								o.CALF_SRA_INDV_AMNNO = tempSraNo.substr(0,3)+'-'+tempSraNo.substr(3);									
	   							}
	   							if(o.RG_DSC == '미등록우'){
	   								o.RG_DSC = '';
	   							}
	   							if(o.MCOW_DSC == '미등록우'){
	   								o.MCOW_DSC = '';
	   							}
	   							return o;
	   						}); 
	   	            		ReportPopup('LALM0216R3_58',TitleData, grid4, 'V');               //V:세로 , H:가로  , T :콘솔로그
	               			 
	               		 
             		 // ★익산: 8808990227283
             		 } else if(na_bzplc == '8808990227283') {
             			 ReportPopup('LALM0216R3_59',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★순정 정읍: 8808990656953 양평 : 8808990643625
              		 } else if(na_bzplc == '8808990656953'){
            			 ReportPopup('LALM0216R3_62',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★진천: 8808990656502 테스트:8808990643625
             		 } else if(na_bzplc == '8808990656502') {
             			 ReportPopup('LALM0216R3_64',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★세종공주: 8808990656588
             		 } else if(na_bzplc == '8808990656588') {
             			 ReportPopup('LALM0216R3_6_5',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★홍천: 8808990674605
             		 } else if(na_bzplc == '8808990674605') {
             			 ReportPopup('LALM0216R3_67',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★음성: 8808990683973
             		 } else if(na_bzplc == '8808990683973') {
             			 ReportPopup('LALM0216R3_71',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★괴산: 8808990656670
             		 } else if(na_bzplc == '8808990656670') {
             			 ReportPopup('LALM0216R3_75',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // 의령 8808990656199 테스트: 8808990643625
             		 } else if(na_bzplc == '8808990656199' ) {
             			 ReportPopup('LALM0216R3_84',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★남원: 8808990227207
             		 } else if(na_bzplc == '8808990227207') {
	            		 grid4 = grid4.map((o,i)=>{	
							if(o.RG_DSC == '미등록우'){
								o.RG_DSC = '';
							}
							if(o.MCOW_DSC == '미등록우'){
								o.MCOW_DSC = '';
							}
							return o;
						}); 
             			 ReportPopup('LALM0216R3_93',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★예천축협 : 8808990656557
             		 } else if(na_bzplc == '8808990656557') {
             			 ReportPopup('LALM0216R3_98',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★ 홍성축협 : 8808990657622 (개월령삭제버전)
             		 } else if(na_bzplc == '8808990657622') {
             			 ReportPopup('LALM0216R3_6_7',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 // ★ 담양 : 8808990656540
             		 } else if(na_bzplc == '8808990656540') {
             			 ReportPopup('LALM0216R3_6_0',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 // ★ 포항 : 8808990679549
             		 } else if(na_bzplc == '8808990679549') {
             			 ReportPopup('LALM0216R3_108',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 // ★ 양평 : 8808990643625
             		 } else if(na_bzplc == '8808990643625') {
             			 ReportPopup('LALM0216R3_112',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 //ReportPopup('LALM0216R3_113',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그

	                 // 영천축협 : 8808990656687
	     	         } else if(na_bzplc == '8808990656687') {
	     	         	ReportPopup('LALM0216R3_6_3',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
	     	        
	     	         // 수원축협 : 8808990656496
					 } else if(na_bzplc == '8808990656496'){
						 ReportPopup('LALM0216R3_6_4',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
						
					 // 평택축협 : 8808990795874	 
					 } else if(na_bzplc == '8808990795874'){
						 ReportPopup('LALM0216R3_115',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
						 
					 }else if(na_bzplc == '8808990656694'){ //서산태안
						 ReportPopup('LALM0216R3_6_J_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
						 
					 } else if(na_bzplc == '8808990659268'){ //논산계룡
             			 ReportPopup('LALM0216R3_6_6',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 } else {
             			 ReportPopup('LALM0216R3_6',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			 
             		 }
            	 
            	 } else if($("#prto_tpc_4").is(":checked")) {
            		 // ★부여: 8808990660127
             		 if(na_bzplc == '8808990660127') {
             			 ReportPopup('LALM0216R3_43',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 
             		 // ★함평: 8808990656601 영암: 8808990689760 테스트: 8808990643625
             		 } else if(na_bzplc == '8808990656601' || na_bzplc == '8808990689760') {
             			ReportPopup('LALM0216R3_48',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 // ★사천: 8808990656519 테스트: 8808990643625
             		 } else if(na_bzplc == '8808990656519') {
             			ReportPopup('LALM0216R3_74',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 
             		 // ★함양산청: 8808990656410 산청지점: 8808990674506
             		 } else if(na_bzplc == '8808990656410' || na_bzplc == '8808990674506') {
              			ReportPopup('LALM0216R3_77',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 } else if(na_bzplc == '8808990657240') { //진주축협 : 8808990657240
              			ReportPopup('LALM0216R3_77_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 // ★영광축협: 8808990811710 , 장성축협 : 8808990817675
             		 } else if(na_bzplc == '8808990811710' || na_bzplc == '8808990817675') {
             			ReportPopup('LALM0216R3_80',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 // ★하동축협: 8808990656656
             		 } else if(na_bzplc == '8808990656656') {
             			ReportPopup('LALM0216R3_94',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 // ★고성축협: 8808990656458
             		 } else if(na_bzplc == '8808990656458') {
             			ReportPopup('LALM0216R3_107',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 // ★순정축협(순창): 8808990656960
             		 }  else if(na_bzplc == '8808990656960') {
             			ReportPopup('LALM0216R3_8_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		// 밀양축협 : 8808990656663, 문경축협 : 8808990656427
             		 } else if(na_bzplc == '8808990656663' || na_bzplc == '8808990656427') {
             			ReportPopup('LALM0216R3_8_2',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             	
             		// 의령축협 : 8808990656199
             		 } else if(na_bzplc == '8808990656199'){
             			ReportPopup('LALM0216R3_8_3',TitleData, grid4, 'V');				//V:세로 , H:가로  , T :콘솔로그
             		// 보성축협 : 8808990656267
             		 } else if(na_bzplc == '8808990656267'){
              			ReportPopup('LALM0216R3_8_5',TitleData, grid4, 'V');				//V:세로 , H:가로  , T :콘솔로그 
             		 }else  {
             			ReportPopup('LALM0216R3_8',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 }

            	 } else if($("#prto_tpc_5").is(":checked")) {
            		 // ★해남: 8808990656106
             		 if(na_bzplc == '8808990656106') {
             			 ReportPopup('LALM0216R3_56',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 
             		 // ★장성 8808990817675
             		 } else if(na_bzplc == '8808990817675') {
             			ReportPopup('LALM0216R3_104',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 // 고흥축협 : 8808990779546	
             		 } else if(na_bzplc == '8808990779546'){
             			ReportPopup('LALM0216R3_6',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 } else {
             			ReportPopup('LALM0216R3_11',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }

            	 } else if($("#prto_tpc_6").is(":checked")) {
            		 // ★함평: 8808990656601 테스트: 8808990643625
             		 if(na_bzplc == '8808990656601') {
             			 ReportPopup('LALM0216R3_79',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 
             		 // ★해남: 8808990656106
             		 } else if(na_bzplc == '8808990656106') {
             			ReportPopup('LALM0216R3_86',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 } else {
             			ReportPopup('LALM0216R3_13',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }

            	 } else if($("#prto_tpc_7").is(":checked")) {
            		 //평택축협 : 8808990795874 테스트 8808990687094
            		 if(na_bzplc == '8808990795874'){
            			 ReportPopup('LALM0216R3_115_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 }else if(na_bzplc == '8808990658995'){ //청주
	            		 ReportPopup('LALM0216R3_14_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
	            		 
            		 }else{
	            		 ReportPopup('LALM0216R3_14',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
	            		 
            		 }
            	 
            	 } else if($("#prto_tpc_8").is(":checked")) {
            		 ReportPopup('LALM0216R3_9',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 
            	 } else if($("#prto_tpc_9").is(":checked")) {
            		 ReportPopup('LALM0216R3_17',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 
            	 } else if($("#prto_tpc_10").is(":checked")) {
            		 ReportPopup('LALM0216R3_15',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 
            	 }else if($("#prto_tpc_11").is(":checked")) {
	           		 if(na_bzplc == '8808990659275') {
	           			 ReportPopup('LALM0216R3_83_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             		 
	           		 } 
            	 
            	 } else if($("#prto_tpc_12").is(":checked")) {
            		 // ★거창: 8808990659701 테스트:8808990643625
            		 if(na_bzplc == '8808990659701') {
             			 ReportPopup('LALM0216R3_60',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 
             		 // ★창녕 8808990656274
             		 } else if(na_bzplc == '8808990656274') {
             			ReportPopup('LALM0216R3_102',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 // ★청양 8808990657646	테스트 8808990687094
             		 } else if(na_bzplc == '8808990657646'){
             			ReportPopup('LALM0216R3_23',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }else {
             			ReportPopup('LALM0216R3_20',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }
            	 
            	 } else if($("#prto_tpc_13").is(":checked")) {
            		 // ★나주: 8808990659275
            		 if(na_bzplc == '8808990659275') {
             			 ReportPopup('LALM0216R3_83',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그             		 
             		 } else if(na_bzplc == '8808990656694'){ //서산태안 : 8808990656694
            			 ReportPopup('LALM0216R3_22_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            			 
            		 } else {
             			ReportPopup('LALM0216R3_22',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }
            	 
            	 } else if($("#prto_tpc_14").is(":checked")) {
            		 // ★합천: 8808990656236
            		 if(na_bzplc == '8808990656236') {
            			 ReportPopup('LALM0216R3_28_1',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 
             		 } else {
             			ReportPopup('LALM0216R3_28',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }
            	 
            	 } else if($("#prto_tpc_15").is(":checked")) {
            		//경주 송아지					
               		 ReportPopup('LALM0216R3_25',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            	 } else if($("#prto_tpc_17").is(":checked")) {
            		 ReportPopup('LALM0216R3_31',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_19").is(":checked")) {
            		 ReportPopup('LALM0216R3_34',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_21").is(":checked")) {
            		 ReportPopup('LALM0216R3_36',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_22").is(":checked")) {
            		 ReportPopup('LALM0216R3_38',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
            		 
            	 } else if($("#prto_tpc_23").is(":checked")) {
            		 // ★익산: 8808990227283
            		 if(na_bzplc == '8808990227283') {
             			 ReportPopup('LALM0216R3_70',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             		 
             		 // ★평택 8808990795874 번식우
             		 } else if(na_bzplc == '8808990795874') {
             			ReportPopup('LALM0216R3_105',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 // 세종공주축협 8808990656588
             		 } else if(na_bzplc == '8808990656588'){
             			ReportPopup('LALM0216R3_41',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 } else {
             			ReportPopup('LALM0216R3_40',TitleData, grid4, 'V');              //V:세로 , H:가로  , T :콘솔로그
             			
             		 }
            	 }
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
        	,"경매<br>번호", "경매대상", "귀표번호", "생년월일"
                                  , "월령", "성별", "계대", "등록번호", "등록구분", "제각여부"
                                  , "KPN번호", "어미귀표번호","산차","중량","주소","성명","휴대폰"
                                  ,"예정가","브루셀라<br>검사일자","예방접종일자","우결핵<br>검사일자"
                                  ,"임신감정<br>여부","임신여부","인공수정일자","임신<br>개월수"
                                  ,"수정KPN","(송)귀표번호","(송)생년월일","(송)성별","(송)월령"
                                  ,"비고","친자검사여부","송아지구분","친자검사결과","어미등록구분"];        
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
                                     {name:"SRA_INDV_AMNNO12",          index:"SRA_INDV_AMNNO12",         width:120, align:'center' },
                                     {name:"BIRTH",                     index:"BIRTH",                    width:70, align:'center'  },
                                     {name:"MTCN",                      index:"MTCN",                     width:40, align:'center', sorttype: "number", formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:55, align:'center'   ,edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:40, align:'center', sorttype: "number"},
                                     {name:"SRA_INDV_BRDSRA_RG_NO",     index:"SRA_INDV_BRDSRA_RG_NO",    width:70, align:'center', sorttype: "number"},
                                     {name:"RG_DSC",                    index:"RG_DSC",                   width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"RMHN_YN",                   index:"RMHN_YN",                  width:60, align:'center'    , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:60, align:'center'  },
                                     {name:"MCOW_SRA_INDV_AMNNO",       index:"MCOW_SRA_INDV_AMNNO",      width:140, align:'center' },
                                     {name:"MATIME",                    index:"MATIME",                   width:35, align:'center'  },
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:70, align:'right', sorttype: "number", formatter:'interger', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"DONG",                      index:"DONG",                     width:200, align:'left'   },
                                     {name:"FTSNM",                     index:"FTSNM",                    width:60, align:'center'  },
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:75, align:'center'  },
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:85, align:'right'    , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"BRCL_ISP_DT",               index:"BRCL_ISP_DT",              width:85, align:'center'  }, 
                                     {name:"VACN_DT",                   index:"VACN_DT",                  width:85, align:'center'  }, 
                                     {name:"BOVINE_DT",                 index:"BOVINE_DT",                width:80, align:'center'  }, 
                                     {name:"PRNY_JUG_YN",               index:"PRNY_JUG_YN",              width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PRNY_YN",                   index:"PRNY_YN",                  width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"AFISM_MOD_DT",              index:"AFISM_MOD_DT",             width:60, align:'center'   },
                                     {name:"PRNY_MTCN",                 index:"PRNY_MTCN",                width:60, align:'right', sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"MOD_KPN_NO",                index:"MOD_KPN_NO",               width:60, align:'center'  },
                                     {name:"CALF_SRA_INDV_AMNNO",       index:"CALF_SRA_INDV_AMNNO",      width:120, align:'center'  ,formatter:'gridIndvFormat'}, 
                                     {name:"CALF_BIRTH",                index:"CALF_BIRTH",               width:100, align:'center'  },
                                     {name:"CALF_INDV_SEX_C",           index:"CALF_INDV_SEX_C",          width:80, align:'center'   ,edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"CALF_MTCN",                 index:"CALF_MTCN",                width:80, align:'center', sorttype: "number",align:'right', formatter:function(cellValue , options, rowData){ if(rowData.CALF_MTCN != null){ return rowData.CALF_MTCN;}}},
                                     {name:"RMK_CNTN",                  index:"RMK_CNTN",                 width:190, align:'left'   }, 
                                     {name:"DNA_YN_CHK",                index:"DNA_YN_CHK",               width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"CASE_COW",                  index:"CASE_COW",                 width:100, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)}},
                                     {name:"DNA_YN",                    index:"DNA_YN",                   width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA}},
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:80, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
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
            }else {
            	su_sra_indv_amnno++;
            }        	
        	
        
        }); 
        
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                       ["AUC_PRG_SQ"           ,"총두수"                ,2 ,"String" ]
                      ,["SRA_INDV_AMNNO12"	   ,tot_sra_indv_amnno	  ,1 ,"Integer"] 
                      ,["BIRTH"                ,"예정가등록두수"          ,2 ,"String"] 
                      ,["INDV_SEX_C"           ,tot_lows_sbid_lmt_am  ,1 ,"Integer"] 
                      ,["SRA_INDV_PASG_QCN"    ,"중량등록두수"            ,3 ,"String"] 
                      ,["RMHN_YN"              ,tot_cow_sog_wt         ,1 ,"Integer"] 
                      ,["KPN_NO"               ,"암두수"                 ,2 ,"String"] 
                      ,["MATIME"               ,am_sra_indv_amnno      ,1 ,"Integer"] 
                      ,["COW_SOG_WT"           ,"수두수"                 ,2 ,"String"] 
                      ,["FTSNM"                ,su_sra_indv_amnno       ,1 ,"Integer"] 
		           ] 
         ];
  
         fn_setGridFooter('grd_MhSogCow1', arr);  
        
    } 
     
    // 두번째 그리드 생성
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
		  	     ] 
		  	        
         ];
  
         fn_setGridFooter('grd_MhSogCow3', arr);  
		
        
    }   
    
   //세번째 그리드 생성
    function fn_CreateGrid_3(data){
    	
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["송아지축산개체관리번호","송아지개체성별코드","송아지출하중량","송아지생년월일","h비고내용","h임신개월수","h수정kpn번호","월령","휴대폰번호","H큰소구분","H수송자","H귀표번호","경매<br>번호", "경매대상", "주소", "성명"
                                  , "귀표번호", "생년월일", "산차", "어미구분", "계대", "제각여부"
                                  , "KPN번호", "성별","중량","예정가","낙찰단가","낙찰가","수송자","낙찰자"
                                  ,"낙찰자<br>전화번호","참가<br>번호","어미귀표번호","친자검사여부"
                                  ,"송아지구분","친자검사결과","등록구분코드"];        
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
//       							  	 {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:55,  align:'center'  ,hidden:true},
        	                         {name:"PPGCOW_FEE_DSC",            index:"PPGCOW_FEE_DSC",           width:55,  align:'center'  ,hidden:true},
        	                         {name:"TRPCS_PY_YN",               index:"TRPCS_PY_YN",              width:55,  align:'center'  ,hidden:true},
        	                         {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:55,  align:'center'  ,hidden:true},
                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:55,  align:'center' },
                                     {name:"AUC_OBJ_DSC",               index:"AUC_OBJ_DSC",              width:65,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"DONG",                      index:"DONG",                     width:300, align:'left'   },
                                     {name:"FTSNM",                     index:"FTSNM",                    width:60,  align:'center' },
                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:120, align:'center' },
                                     {name:"BIRTH",                     index:"BIRTH",                    width:70,  align:'center'  },
                                     {name:"MATIME",                    index:"MATIME",                   width:35,  align:'center' },
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:60,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:40,  align:'right'  },
                                     {name:"RMHN_YN",                   index:"RMHN_YN",                  width:60,  align:'right'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:60,  align:'center' },
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:40,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:70,  align:'right'   , sorttype: "number", formatter:'interger', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:85,  align:'right'   , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:85,  align:'right'   , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:85,  align:'right'   , sorttype: "number", formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"VHC_DRV_CAFFNM",            index:"VHC_DRV_CAFFNM",           width:85,  align:'center' },
                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:80,  align:'center' },
                                     {name:"E_CUS_MPNO",                index:"E_CUS_MPNO",               width:80,  align:'center' },
                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:40,  align:'center' },
                                     {name:"MCOW_SRA_INDV_AMNNO",       index:"MCOW_SRA_INDV_AMNNO",      width:120, align:'center' },
                                     {name:"DNA_YN_CHK",                index:"DNA_YN_CHK",               width:80,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}}, 
                                     {name:"CASE_COW",                  index:"CASE_COW",                 width:100, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)}}, 
                                     {name:"DNA_YN",                    index:"DNA_YN",                   width:80,  align:'center'  , edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA}}, 
                                     {name:"RG_DSC",                    index:"RG_DSC",                   width:60,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}}
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
                      ,["SRA_INDV_AMNNO"        ,"중량등록두수"             ,1 ,"String"] 
                      ,["BIRTH"                 ,tot_cow_sog_wt          ,1 ,"Integer"]  
                      ,["MATIME"                ,"암두수"                  ,1 ,"String"] 
                      ,["MCOW_DSC"              ,am_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["SRA_INDV_PASG_QCN"     ,"수두수"                  ,1 ,"String"] 
                      ,["RMHN_YN"               ,su_sra_indv_amnno       ,1 ,"Integer"] 
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
         		 				   ,"경매<br>번호", "경매대상", "성명", "귀표번호"
                                   , "생년월일", "산차", "어미구분", "계대", "제각여부", "KPN번호"
                                   , "성별", "중량","예정가","주소","전화번호","휴대폰","비고"
                                   ,"어미귀표번호","등록구분","월령","월령"
                                   ,"수정KPN","친자검사여부","친자검사결과","우결핵<br>검사일자"
                                   ,"고능력여부","송아지구분","전이용사료여부"
                                   ,"임신구분"];        
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
                                     {name:"SRA_INDV_AMNNO12",          index:"SRA_INDV_AMNNO12",         width:160, align:'center' },
                                     {name:"BIRTH",                     index:"BIRTH",                    width:70, align:'center'   },
                                     {name:"MATIME",                    index:"MATIME",                   width:35, align:'right'   },
                                     {name:"MCOW_DSC",                  index:"MCOW_DSC",                 width:70, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"SRA_INDV_PASG_QCN",         index:"SRA_INDV_PASG_QCN",        width:40,  align:'right'  },
                                     {name:"RMHN_YN",                   index:"RMHN_YN",                  width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"KPN_NO",                    index:"KPN_NO",                   width:60, align:'center'  },
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:40, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"COW_SOG_WT",                index:"COW_SOG_WT",               width:70, align:'right'    , formatter:'interger', formatoptions:{decimalPlaces:2,thousandsSeparator:','}},
                                     {name:"LOWS_SBID_LMT_AM",          index:"LOWS_SBID_LMT_AM",         width:90, align:'right'    , formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"DONG",                      index:"DONG",                     width:250, align:'left' },
                                     {name:"OHSE_TELNO",                index:"OHSE_TELNO",               width:80, align:'center' },
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:85, align:'center' },
                                     {name:"RMK_CNTN",                  index:"RMK_CNTN",                 width:190, align:'left' }, 
                                     {name:"MCOW_SRA_INDV_AMNNO",       index:"MCOW_SRA_INDV_AMNNO",      width:120, align:'center' },
                                     {name:"RG_DSC",                    index:"RG_DSC",                   width:60, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"MTCN",                      index:"MTCN",                     width:40, align:'right'    , formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"MTCN1",                     index:"MTCN1",                    width:70, align:'right'    , formatter:'number', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"MOD_KPN_NO",                index:"MOD_KPN_NO",               width:60, align:'center'  },
                                     {name:"DNA_YN_CHK",                index:"DNA_YN_CHK",               width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"DNA_YN",                    index:"DNA_YN",                   width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_DNA_YN_DATA}},
                                     {name:"BOVINE_DT",                 index:"BOVINE_DT",                width:100, align:'center'  }, 
                                     {name:"EPD_YN",                    index:"EPD_YN",                   width:80, align:'center'   , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"CASE_COW",                  index:"CASE_COW",                 width:100, align:'center'  , edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_SOG_COW_DSC", 1)}}, 
                                     {name:"FED_SPY_YN",                index:"FED_SPY_YN",               width:100, align:'center' , edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}} ,
        							 {name:"PPGCOW_FEE_DSC",       		index:"PPGCOW_FEE_DSC",       	  width:100, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}}
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
            }else {
            	su_sra_indv_amnno++;
            }        		
        	
        
        }); 
     
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                       ["AUC_PRG_SQ"              ,"총두수"                  ,1 ,"String" ]
                      ,["AUC_OBJ_DSC"             ,tot_sra_indv_amnno 	   ,1 ,"Integer"] 
                      ,["FTSNM"                   ,"예정가등록두수"            ,2 ,"String"] 
                      ,["BIRTH"                   ,tot_lows_sbid_lmt_am    ,1 ,"Integer"] 
                      ,["MATIME"                  ,"중량등록두수"              ,2 ,"String"] 
                      ,["SRA_INDV_PASG_QCN"       ,tot_cow_sog_wt          ,1 ,"Integer"] 
                      ,["RMHN_YN"                 ,"암두수"                  ,1 ,"String"] 
                      ,["KPN_NO"                  ,am_sra_indv_amnno       ,1 ,"Integer"] 
                      ,["INDV_SEX_C"              ,"수두수"                  ,1 ,"String"] 
                      ,["COW_SOG_WT"              ,su_sra_indv_amnno       ,1 ,"Integer"] 
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

		//일시 이력제월령 표기
		//영암:8808990689760 | 익산:8808990227283 | 밀양 : 8808990656663 | 임실 : 8808990660783 | 영광 : 8808990811710 | 예천 : 8808990656557 
		//동삼태 : 8808990652825 | 양평 : 8808990643625 | 사천 : 8808990656519 | 함평 : 8808990656601 | 장성 : 8808990817675 
		//해남 : 8808990656106 | 보성 : 8808990656267 | 서산 : 8808990656694 | 진천 : 8808990656502
		var arrMtcnNaBzplc = ['8808990689760','8808990227283' , '8808990656663' , '8808990660783' , '8808990811710' , '8808990656557'
			, '8808990652825' , '8808990643625' , '8808990656519' , '8808990656601','8808990817675'
			, '8808990656106' , '8808990656267' , '8808990656694' , '8808990656502' ];
		$('#'+frmId).getRowData().forEach((o,i)=>{
			
			if(na_bzplc == '8808990656267'){
				o.MTCN4 = (o.MTCN-1)+'개월 '+o.MTCN4+'일';
			}

			if((arrMtcnNaBzplc.includes(na_bzplc))){
				o.MTCN = o.MTCN+'개월';
			}else if(na_bzplc =='8808990812021'){ //  인천 : 8808990812021
				o.MTCN = (o.MTCN-1)+'개월 '+o.MTCN4+'일 ('+o.MTCN1+'일)';
			}else{
				o.MTCN = (o.MTCN-1)+'개월 '+o.MTCN4+'일';
			}
		
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
			
			if(o.DNA_YN_CHK == '부'){
				o.DNA_YN_CHK = '';
			}
			if(o.DNA_YN == '일치'){
				if(na_bzplc=='8808990656199'){
					o.DNA_YN = '친자'+o.DNA_YN;				
				}				
			}
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
						<table>
							<colgroup>
								<col width="150">
								<col width="*">
								<!-- 버튼 있는 테이블은 width 94 고정 -->
							</colgroup>
							<tbody>
								<tr>
									<th class="tb_dot" rowspan="2" width="150px">인쇄형식(거치대)</th>
									<td id="radio" class="radio" colspan='12'>
									    <input type="radio" name="radio" id="prto_tpc_1" value="1"><span>가로&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_2" value="2"><span>세로&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_3" value="3"><span>가로(2형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_4" value="4"><span>세로(2형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_5" value="5"><span>가로(3형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_6" value="6"><span>세로(3형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_7" value="7"><span>가로(4형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_8" value="8"><span>세로(4형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_9" value="9"><span>가로(5형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_10" value="10"><span>세로(5형식)&nbsp;</span>
									</td>
								</tr>
								<tr>
									<td id="radio" class="radio" colspan='12'>
										<input type="radio" name="radio" id="prto_tpc_11" value="11"><span>가로(6형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_12" value="12"><span>세로(6형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_13" value="13"><span>가로(7형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_14" value="14"><span>세로(7형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_15" value="15"><span>가로(8형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_17" value="17"><span>가로(9형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_19" value="19"><span>가로(10형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_21" value="21"><span>가로(11형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_22" value="22"><span>세로(11형식)&nbsp;</span>
										<input type="radio" name="radio" id="prto_tpc_23" value="23"><span>가로(12형식)&nbsp;</span>
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
					<li><a href="#tab2" id="tab_2">경매전(게시판용)</a></li>
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
			<div id="tab2" class="tab_content">


				<div class="listTable rsp_v">
					<table id="grd_MhSogCow3" >
					</table>
				</div>


			</div>
			
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