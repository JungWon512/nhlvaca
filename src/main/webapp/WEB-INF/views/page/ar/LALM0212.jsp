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
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0212
 * 3. 파일명(한글) : 경매차수 관리
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.01   신명진   최초작성
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
     var userId = App_userId;
     //mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
     var mv_RunMode = 0;
     var setRowStatus = "";
     
     $(document).ready(function(){
    	 
         fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2, true, "전체");
         fn_setCodeRadio("auc_obj_dsc","hd_auc_obj_dsc","AUC_OBJ_DSC", 2);
         fn_setCodeRadio("sgno_prc_dsc", "hd_sgno_prc_dsc", "SGNO_PRC_DSC", 1);
         
         fn_Init();
         
         fn_setClearFromFrm("frm_Search","#mainGrid");
         
         /******************************
         * 엔터키 입력 시 자동차수 확인
         ******************************/
         $("#auc_dt").keypress(function(e){        	
             if(e.keyCode == 13){
            	 var tmpLength = $("#auc_dt").val().length;
            	 // 등록된 내역이 있나 체크 있으면 알림 메시지 및 auc_dt 초기화
            	 // 등록된 내역이 없으면 차수 자동등록(Max+1)
            	 if(tmpLength == 10) {
            		 fn_selMaxQcn();
            	 }            	 
             }
         });
         
         /******************************
          * 경매일자 변경 이벤트
          ******************************/
     	$("#auc_dt").on("change keyup paste", function(e){        	
             if(e.keyCode != 13) {
            	 var tmpLength = $("#auc_dt").val().length;
            	 // 등록된 내역이 있나 체크 있으면 알림 메시지 및 auc_dt 초기화
            	 // 등록된 내역이 없으면 차수 자동등록(Max+1)
            	 if(tmpLength == 10) {
            		 fn_selMaxQcn();
            	 }
 			}
         });
         
      	/******************************
         * 입력초기화 버튼클릭 이벤트
         ******************************/
     	$(document).on("click", "button[name='btn_Init']", function() {   
     		event.preventDefault();
     		mv_RunMode = 1;
     		setRowStatus = "I";
     		fn_InitFrm('frm_MhAucQcn');
     		fn_DisableFrm('frm_MhAucQcn', false);
     		fn_DisableCut(true, true);
     		$("#hd_auc_obj_dsc").val("1");
     		$("#hd_sgno_prc_dsc").val("1");
     		
         });
     	
     	/******************************
         * 경매마감 버튼클릭 이벤트
         ******************************/
     	$(document).on("click", "button[name='btn_Ddl']", function() {
     		event.preventDefault();
     		fn_SaveDdl();
         });
     	
     	/******************************
         * 마감취소 버튼클릭 이벤트
         ******************************/
     	$(document).on("click", "button[name='btn_Can']", function() {
     		event.preventDefault();
     		fn_SaveCan();
         });
     	
     	/******************************
         * 경매대상 라디오 버튼클릭 이벤트
         ******************************/
        $(document).on("click", "input[name='hd_auc_obj_dsc_radio']", function() {
         	var tmp_check_val = $("#hd_auc_obj_dsc").val();
         	
         	if(tmp_check_val == 0 || tmp_check_val == 2) {    			
     			fn_DisableCut(true, false);    			
     		} else {    			
     			fn_DisableCut(true, true);    			
     		}
        });
        
        /******************************
         * 프로그램ID 대문자 변환
         ******************************/
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
        //그리드 초기화
        fn_CreateGrid();
        
        //폼 초기화
        if(mv_RunMode == 0 || mv_RunMode == 1) {
        	fn_InitFrm('frm_Search');
        	$( "#auc_st_dt" ).datepicker().datepicker("setDate", fn_getDay(-7));
            $( "#auc_ed_dt" ).datepicker().datepicker("setDate", fn_getToday());
            $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        }
        fn_InitFrm('frm_MhAucQcn');        
        
        setRowStatus = "";
        
        // 울산축협일 경우에만 단가 표시
        if(na_bzplc != "8808990656632") {
        	// 단가 display none
			$("#lastLine").css("display","none");
        	
        }
        
        fn_DisableFrm('frm_MhAucQcn', true);
        mv_RunMode = 1;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
		if(fn_isNull($( "#auc_st_dt" ).val())){
			MessagePopup('OK','경매시작일자를 선택하세요.',function(){
				$( "#auc_st_dt" ).focus();
			});
			return;
		}      
		if(!fn_isDate($( "#auc_st_dt" ).val())){
			MessagePopup('OK','경매시작일자가 날짜형식에 맞지 않습니다.',function(){
				$( "#auc_st_dt" ).focus();
			});
			return;
		}
		if(fn_isNull($( "#auc_ed_dt" ).val())){
			MessagePopup('OK','경매종료일자를 선택하세요.',function(){
				$( "#auc_ed_dt" ).focus();
			});
			return;
		}      
		if(!fn_isDate($( "#auc_ed_dt" ).val())){
			MessagePopup('OK','경매종료일자가 날짜형식에 맞지 않습니다.',function(){
				$( "#auc_ed_dt" ).focus();
			});
			return;
		}
        
        var results = sendAjaxFrm("frm_Search", "/LALM0212_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        mv_RunMode = 2;
        fn_CreateGrid(result); 
                
    }
    

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	 
    	if(fn_isNull($( "#hd_auc_obj_dsc" ).val())) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#hd_auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_dt" ).focus();
            });
            return;
        }
        if(!fn_isDate($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_dt" ).focus();
            });
            return;
        }
		if($("#base_lmt_am").val() > 99999999) {
			MessagePopup('OK','한도금액을 99999999원 이하로 입력하세요.',function(){
				$( "#base_lmt_am" ).focus();
			});        	
			return;
		}
		
		MessagePopup('YESNO',"저장하시겠습니까?",function(res){
			if(res){
				if(setRowStatus == "I") {
					var result = sendAjaxFrm("frm_MhAucQcn", "/LALM0212_insPgm", "POST");            
		            if(result.status == RETURN_SUCCESS){
		            	MessagePopup("OK", "저장되었습니다.");
		            	mv_RunMode = 3;
		            	fn_Init();
		                fn_Search();
		            } else {
		            	showErrorMessage(result);
		                return;
		            }
		            
				} else if(setRowStatus == "U") {					
					var result = sendAjaxFrm("frm_MhAucQcn", "/LALM0212_updPgm", "POST");            
		            if(result.status == RETURN_SUCCESS){
		            	MessagePopup("OK", "저장되었습니다.",function(res){
		            		mv_RunMode = 3;
			            	fn_Init();
			                fn_Search();
		            	});
		            	
		            } else {
		            	showErrorMessage(result);
		                return;
		            }
		            
				} else {
					MessagePopup("OK", "오류가 발생했습니다 처음부터다시 시도해주세요.",function(res){
						fn_Init();
						return;
					});
				}
    		} else {    			
    			MessagePopup('OK','취소되었습니다.');
    			return;
    		}
		});		
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Delete (){
    	 
    	//프로그램삭제 validation check     
        if(setRowStatus != "U") {
        	MessagePopup("OK", "삭제할 대상을 선택하세요.");
            return;
             
        }    	
        if(fn_isNull($( "#hd_auc_obj_dsc" ).val())) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#hd_auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_dt" ).focus();
            });
            return;
        }
        if(!fn_isDate($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_dt" ).focus();
            });
            return;
        }
    	
        MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
			if(res){									
				var result = sendAjaxFrm('frm_MhAucQcn', "/LALM0212_delPgm", "POST");            
	            if(result.status == RETURN_SUCCESS){
	            	MessagePopup("OK", "삭제되었습니다.");
	            	mv_RunMode = 3;
	            	fn_Init();
	                fn_Search();
	            } else {
	            	showErrorMessage(result);
	                return;
	            }
    		}else{    			
    			MessagePopup('OK','취소되었습니다.');
    			return;
    		}
		}); 
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
    	fn_ExcelDownlad('mainGrid', '경매차수관리');
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 마감 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SaveDdl(){
    	
    	 if(fn_isNull($( "#hd_auc_obj_dsc" ).val())) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#hd_auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_dt" ).focus();
            });
            return;
        }
        if(!fn_isDate($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_dt" ).focus();
            });
            return;
        }
        
        var result = sendAjaxFrm("frm_MhAucQcn", "/LALM0212_updDdl", "POST");
        
        if(result.status == RETURN_SUCCESS){
        	MessagePopup('OK','정상적으로 처리되었습니다.');
        	// 저장 후 재조회
        	mv_RunMode = 3;
        	fn_Init();
            fn_Search();
        } else {
        	showErrorMessage(result);
            return;
        }
                
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 마감취소 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SaveCan(){        
    	 
    	if(fn_isNull($( "#hd_auc_obj_dsc" ).val())) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#hd_auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_dt" ).focus();
            });
            return;
        }
        if(!fn_isDate($( "#auc_dt" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_dt" ).focus();
            });
            return;
        }
        
        var result = sendAjaxFrm("frm_MhAucQcn", "/LALM0212_updCan", "POST");
        
        if(result.status == RETURN_SUCCESS){
        	MessagePopup('OK','정상적으로 처리되었습니다.');
        	// 저장 후 재조회        	
        	fn_Init();
            fn_Search();
            mv_RunMode = 3;
        } else {
        	showErrorMessage(result);
            return;
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
        if(data != null){
            rowNoValue = data.length;
        }
        
        if(na_bzplc != "8808990656632") {
        	/*                               1         2      3            4                 5               6         7      8 */
        	var searchResultColNames = ["경매일자", "경매대상", "차수", "응찰한도금액", "절사단위금액(비육우)", "절사구분(비육우)", "마감여부", "전송"];        
	        var searchResultColModel = [						 
	        							 {name:"AUC_DT",       	index:"AUC_DT",       	width:150, align:'center', formatter:'gridDateFormat'},
	                                     {name:"AUC_OBJ_DSC",   index:"AUC_OBJ_DSC",    width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
	                                     {name:"QCN",        	index:"QCN",        	width:150, align:'center'},
	                                     {name:"BASE_LMT_AM",   index:"BASE_LMT_AM",    width:150, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:','}},                                     
	                                     {name:"CUT_AM",        index:"CUT_AM",       	width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_AM_DATA}},
	                                     {name:"SGNO_PRC_DSC",  index:"SGNO_PRC_DSC",   width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SGNO_PRC_DSC", 1)}},
	                                     {name:"DDL_YN",       	index:"DDL_YN",       	width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
	                                     {name:"TMS_YN",        index:"TMS_YN",        	width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}}
	                                    ];
        } else {
        	/*                               1         2      3           4                  5               6         7      8                9              10 */
        	var searchResultColNames = ["경매일자", "경매대상", "차수", "응찰한도금액", "절사단위금액(비육우)", "절사구분(비육우)", "마감여부", "전송", "암송아지(KG)단가", "수송아지(KG)단가"];        
	        var searchResultColModel = [						 
	        							 {name:"AUC_DT",       	index:"AUC_DT",       	width:150, align:'center', formatter:'gridDateFormat'},
	                                     {name:"AUC_OBJ_DSC",   index:"AUC_OBJ_DSC",    width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
	                                     {name:"QCN",        	index:"QCN",        	width:150, align:'center'},
	                                     {name:"BASE_LMT_AM",   index:"BASE_LMT_AM",    width:150, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:','}},                                     
	                                     {name:"CUT_AM",        index:"CUT_AM",       	width:150, align:'right', edittype:"select", formatter : "select", editoptions:{value:GRID_AM_DATA}},
	                                     {name:"SGNO_PRC_DSC",  index:"SGNO_PRC_DSC",   width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SGNO_PRC_DSC", 1)}},
	                                     {name:"DDL_YN",       	index:"DDL_YN",       	width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
	                                     {name:"TMS_YN",        index:"TMS_YN",        	width:150, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
	                                     {name:"MALE_KG",   	index:"MALE_KG",   		width:150, align:'center'},
	                                     {name:"FEMALE_KG",   	index:"FEMALE_KG",    	width:150, align:'center'}
	                                    ];
        }
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
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
            onSelectRow: function(rowid, status, e){
                var sel_data = $("#mainGrid").getRowData(rowid);
                var aucDat = fn_toDate(sel_data.AUC_DT);
                setRowStatus = "U";
                
                fn_setChgRadio("hd_auc_obj_dsc", sel_data.AUC_OBJ_DSC);
                fn_setRadioChecked("hd_auc_obj_dsc");
                
                fn_setChgRadio("hd_sgno_prc_dsc", sel_data.SGNO_PRC_DSC);
                fn_setRadioChecked("hd_sgno_prc_dsc");
                
                $("#auc_dt").val(aucDat);                
                $("#qcn").val(sel_data.QCN);
                $("#base_lmt_am").val(fn_toComma(sel_data.BASE_LMT_AM));
                $("#cut_am").val(sel_data.CUT_AM);
                $("#female_kg").val(sel_data.FEMALE_KG);
                $("#male_kg").val(sel_data.MALE_KG);                
                
                fn_DisableFrm('frm_MhAucQcn', false);
                
                if(sel_data.AUC_OBJ_DSC == "1" || sel_data.AUC_OBJ_DSC == "3") {
                	fn_DisableCut(false, true);
                }
                
                fn_DisableAuc(true);
           },
        });
        
        $("#mainGrid").jqGrid("setLabel", "rn","No");
        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
	//**************************************
	//function  : fn_DisableCut(절사단위, 절사구분 초기화 및 Disable) 
	//paramater : init_boolean(초기화), p_boolean(disable) ex) true, true 
	// result   : N/A
	//**************************************
	function fn_DisableCut(init_boolean, p_boolean){		
		var rd_length = $("input[name='hd_sgno_prc_dsc_radio']").length;
		var disableItem = $("input[name='hd_sgno_prc_dsc_radio']");
		
		if(init_boolean) {
			$("#cut_am").val("1");
			$("input[name='hd_sgno_prc_dsc_radio']:radio[value='1']").prop("checked", true);			
		}
		
		if(p_boolean) {
			$("#cut_am").attr("disabled", true);    	  	
		} else {
			$("#cut_am").attr("disabled", false);      		
		}
		
		for(var i=0; i<rd_length; i++){
			itemNames = $(disableItem[i]).attr("id");
			
			if(p_boolean) {
				$("#"+itemNames).attr("disabled", true);    	  	
			} else {
				$("#"+itemNames).attr("disabled", false);      		
			}
		}
		
	}
	
	//**************************************
	//function  : fn_DisableCut(경매대상, 경매일자 초기화 및 Disable) 
	//paramater : p_boolean(disable) ex) true 
	// result   : N/A
	//**************************************
	function fn_DisableAuc(p_boolean){		
			var rd_length = $("input[name='hd_auc_obj_dsc_radio']").length;
			var disableItem = $("input[name='hd_auc_obj_dsc_radio']");
			
			if(p_boolean) {
				$("#auc_dt").attr("disabled", true);
			} else {
				$("#auc_dt").attr("disabled", false);
			}
            
			for(var i=0; i<rd_length; i++){
				itemNames = $(disableItem[i]).attr("id");
				
				if(p_boolean) {
					$("#"+itemNames).attr("disabled", true);    	  	
				} else {
					$("#"+itemNames).attr("disabled", false);      		
				}
			}   
	}
	
	//**************************************
	//function  : fn_DisableCut(경매차수 조회) 
	//paramater : p_boolean(disable) ex) true 
	// result   : N/A
	//**************************************
	function fn_selMaxQcn(){		
		var results = sendAjaxFrm("frm_MhAucQcn", "/LALM0212_selMaxQcn", "POST");
		var result;
		
		if(results.status != RETURN_SUCCESS){
			 showErrorMessage(results);
			 $("#auc_dt").val("");
			 $("#auc_dt").focus();
			 return;
		} else {
            result = setDecrypt(results);
            
         	$("#qcn").val(result[0]["MAXCNT"]);
         	$("#base_lmt_am").focus();
         	
         	var tmpAucObjDsc = $("#hd_auc_obj_dsc").val();
         	
         	// 논산: 8808990659268 / 테스트: 8808990643625
         	if(na_bzplc == '8808990643625') {
         		if(tmpAucObjDsc == '2' || tmpAucObjDsc == '3' || tmpAucObjDsc == '0') {
         			fn_DisableCut(false, false);
         		} else {
         			fn_DisableCut(true, true);
         		}           	         		
         	} else {
         		if(tmpAucObjDsc == '2' || tmpAucObjDsc == '0') {
         			fn_DisableCut(false, false);
         		} else {
         			fn_DisableCut(true, true);
         		}
         	}
		}
	}
	////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
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
                                <th scope="row">경매대상<strong class="req_dot">*</strong></th>
                                <td>
                                    <select class="popup" id="cb_auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_st_dt" maxlength="10"></div>
                                        <div class="cell ta_c"> ~ </div>
                                        <div class="cell"><input type="text" class="popup date" id="auc_ed_dt" maxlength="10"></div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">경매차수 정보</p></li>
                </ul> 
                
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                    <button class="tb_btn" name="btn_Init" value="입력초기화">입력초기화</button>
                    <button class="tb_btn" name="btn_Ddl"  value="경매마감">경매마감</button>
                    <button class="tb_btn" name="btn_Can"  value="마감취소">마감취소</button>
                </div>  
            </div>
            
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="grayTable rsp_v">
                	<form id="frm_MhAucQcn" name="frm_MhAucQcn">
                    <table>
                        <colgroup>
                            <col width="150">
                            <col width="*">
                            <col width="150">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><span>경매대상</span></th>
                                <td>
                                    <div class="cellBox" id="auc_obj_dsc">
                                    </div>
                                    <input type="hidden" id="hd_auc_obj_dsc" name="hd_auc_obj_dsc">
                                </td>
                                <th scope="row"><span>경매일자</span></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><span>차수</span></th>
                                <td>
                                    <input type="text" id="qcn" maxlength="5">
                                </td>
                                <th scope="row"><span>응찰한도금액</span></th>
                                <td>
                                    <input type="text" class="number" id="base_lmt_am" maxlength="8">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><span>비육우절사단위미만</span></th>
                                <td>
                                    <select id="cut_am">
                                    	<option value="1">원</option>
                                    	<option value="10">십원</option>
                                    	<option value="100">백원</option>
                                    	<option value="1000">천원</option>
                                    	<option value="10000">만원</option>
                                    </select>
                                </td>
                                
                                <th scope="row"><span>절사구분(비육우)</span></th>
                                <td>
                                    <div class="cellBox" id="sgno_prc_dsc">
                                    </div>
                                    <input type="hidden" id="hd_sgno_prc_dsc" name="hd_sgno_prc_dsc">
                                </td>
                            </tr>
                            <tr id="lastLine">
                                <th scope="row" id="female_kg_text"><span>암송아지(KG) 단가</span></th>
                                <td>
                                    <input type="text" id="female_kg">
                                </td>
                                <th scope="row"  id="male_kg_text"><span>수송아지(KG) 단가</span></th>
                                <td>
                                    <input type="text" id="male_kg">
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
                <table id="mainGrid" style="width:100%;">
                </table>
            </div>
            
        </section>       
    </div>
</body>
</html>