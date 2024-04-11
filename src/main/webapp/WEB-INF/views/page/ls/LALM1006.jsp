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
 * 2. 파  일  명   : LALM1006
 * 3. 파일명(한글) : 경매참가번호 관리
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2024.04.09   전용민   최초작성
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
    var ot_auc_obj_dsc = "";
    //mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
    var mv_RunMode = 0;
    var mv_CheckQcnMsg = 0;
    var setRowStatus = "";
    const lmt_lvst_auc_ptc_mn_no = 500;
    
	$(document).ready(function(){
		
		fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 5);
	    fn_setCodeRadio("auc_obj_dsc","hd_auc_obj_dsc","AUC_OBJ_DSC", 5);
	    
	    fn_Init();
	    
	    fn_setClearFromFrm("frm_Search","#mainGrid");
	    fn_setClearFromFrm("frm_Search","#mhBadTrmnGrid");
	    fn_setClearFrom("frm_Search","frm_MhAucEntr");
	    
	 	/******************************
         * 입력초기화 버튼클릭 이벤트
         ******************************/
    	$(document).on("click", "button[name='pb_Init']", function() {   
    		event.preventDefault();
    		mv_CheckQcnMsg = 1;
    		fn_setMhucEntr();
        });
    	
        /******************************
         * 불량거래 checkbox 이벤트
         ******************************/
        $("#cb_grd_MhBadTrmnShow").change(function() {
    		if($("#cb_grd_MhBadTrmnShow").is(":checked")) {
    			$("#grd_MhBadTrmnShow").text("여");
    			$("#grd_MhBadTrmn_Text").css("display","block");
    			$("#grd_MhBadTrmn_Grid").css("display","block");
    		} else {
    			$("#grd_MhBadTrmnShow").text("부");
    			$("#grd_MhBadTrmn_Text").css("display","none");
    			$("#grd_MhBadTrmn_Grid").css("display","none");
    		}    		
    	});
        
        /******************************
         * 엔터키 입력 시 자동차수 확인
         ******************************/
         $("#auc_date").keypress(function(e){        	
             if(e.keyCode == 13){
            	 var tmpLength = $("#auc_date").val().length;
            	 if(tmpLength == 10) {
            		 fn_SelAucQcn();
            	 }            	 
             }
         });
         
         /******************************
          * 경매일자 변경 이벤트
          ******************************/
     	$("#auc_date").on("change keyup paste", function(e){        	
             if(e.keyCode != 13) {
            	 var tmpLength = $("#auc_date").val().length;
            	 if(tmpLength == 10) {
            		 fn_SelAucQcn();
            	 }
 			}
         });
        
     	/******************************
         * 경매대상 라디오 버튼클릭 이벤트
         ******************************/
        $(document).on("change", "input[name='hd_auc_obj_dsc_radio']", function() {
        	var tmp_check_val = $("#hd_auc_obj_dsc").val();
        	
        	fn_DisableCbAuc(tmp_check_val);
        });
     	
        /******************************
         * 참가번호 엔터 이벤트
         ******************************/
    	$("#lvst_auc_ptc_mn_no").on("keydown", function(e){
    		if(e.keyCode == 13) {
    			if(!fn_isNull($("#lvst_auc_ptc_mn_no").val())) {
    				$("#sra_mwmnnm").focus();
    			}
			}
        });
     	
     	/******************************
         * 응찰기반납 라디오 버튼클릭 이벤트
         ******************************/
        $(document).on("click", "input[name='rd_rtrn_yn']", function() {        	 
        	fn_setChgRadio("hd_rtrn_yn", $("input[name='rd_rtrn_yn']:checked").val());
        });
     	
     	/******************************
         * 거래확정 라디오 버튼클릭 이벤트
         ******************************/
        $(document).on("change", "input[name='rd_tr_dfn_yn']", function() {        	 
        	fn_setChgRadio("hd_tr_dfn_yn", $("input[name='rd_tr_dfn_yn']:checked").val());
        });
     	
     	/******************************
         * 참가번호 검색(돋보기) 팝업 호출 이벤트
         ******************************/
    	$("#pb_sra_mwmnnm1").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            fn_CallMwmnPopup1(false);
        });
     	
     	/******************************
         * 참가번호 팝업 이벤트
         ******************************/
    	$("#sra_mwmnnm1").keydown(function(e) {
             if(e.keyCode == 13) {
            	 if(fn_isNull($("#sra_mwmnnm1").val())) {
            		 MessagePopup('OK','참가번호를 입력하세요.');
            		 $("#sra_mwmnnm1").focus();
            		 return;
            		 
            	 } else {
            		 fn_CallMwmnPopup1(true);
            	 }
              }
        });
     	
    	/******************************
         * 중도매인 검색(돋보기) 팝업 호출 이벤트
         ******************************/
    	$("#pb_sra_mwmnnm").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            fn_CallMwmnPopup(false);
        });
     	
     	/******************************
         * 중도매인 팝업 이벤트
         ******************************/
    	$("#sra_mwmnnm").keydown(function(e) {
             if(e.keyCode == 13) {
            	 if(fn_isNull($("#sra_mwmnnm").val())) {
            		 MessagePopup('OK','중도매인을 입력하세요.');
            		 $("#sra_mwmnnm").focus();
            		 return;
            		 
            	 } else {
            		 fn_CallMwmnPopup(true);
            	 }
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
        fn_CreateSubGrid();
        $("#mainGrid").jqGrid("clearGridData", true);
        $("#mhBadTrmnGrid").jqGrid("clearGridData", true);
         
        //폼 초기화
        if(mv_RunMode == 0 || mv_RunMode == 1) {
         	fn_InitFrm('frm_Search');
         	$("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        }
        fn_InitFrm('frm_MhAucEntr');
         
        setRowStatus = "";
        
        // 불량중도매인 기본 display none
        $("#grd_MhBadTrmn_Text").css("display","none");
		$("#grd_MhBadTrmn_Grid").css("display","none");		 
		 
		// 경매대상 초기화면 설정(세종공주: 8808990656588 경주: 8808990659008)
		if(na_bzplc == "8808990656588" || na_bzplc == "8808990659008") {
			 $("#cb_auc_obj_dsc").val("0"); 
		} else {
			 $("#cb_auc_obj_dsc").val("5");
		}
		 
		fn_DisableFrm('frm_MhAucEntr', true);
		
	    if(mv_RunMode != 3) {
	    	mv_RunMode = 1;
	    }
	    
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){    	 
    	
    	var results = sendAjaxFrm("frm_Search", "/LALM1006_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
        	showErrorMessage(results);
            return;
        }else{
        	result = setDecrypt(results);
            $("#mainGrid").jqGrid("clearGridData", true);
            fn_CreateGrid(result); 
            mv_RunMode = 2;
            
            //불량등록이력 체크 시, 이력있는 사람은 목록 가져오기
            if($("#cb_grd_MhBadTrmnShow").is(":checked")){
            	fn_SearchBadTrmn();
            }
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 불량 중도매인 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchBadTrmn(){    	 
    	
    	mv_RunMode = 2;
    	$("#mhBadTrmnGrid").jqGrid("clearGridData", true);
    	
    	var results = sendAjaxFrm("frm_Search", "/LALM1006_selBadTrmn", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            return;
        }else{      
        	result = setDecrypt(results);
        	fn_CreateSubGrid(result); 
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 불량 중도매인 체크 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchBadCheck(result){    	 

    	var param      = new Object();
        param["trmn_amnno"] = result.TRMN_AMNNO;
        param["mb_intg_no"] = result.MB_INTG_NO;
    	
    	var results = sendAjax(param, "/LALM1006_selBadCheck", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            return "99";
        }else{      
            result = setDecrypt(results);
            return result;
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save() {
        
    	if(fn_isNull($( "#hd_auc_obj_dsc" ).val())) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#hd_auc_obj_dsc" ).focus();
        	});
            return;
        }
    	if(fn_isNull($("#trmn_amnno").val())) {
            MessagePopup('OK','중도매인을 입력하세요.',function(){
                $("#trmn_amnno").focus();
            });
            return;
        }
    	if(fn_isNull($("#lvst_auc_ptc_mn_no").val())) {
        	MessagePopup('OK','참가번호를 입력하세요.',function(){
        		$("#lvst_auc_ptc_mn_no").focus();
        	});
            return;
        }else if(!/^[0-9]+$/.test($("#lvst_auc_ptc_mn_no").val())){
        	MessagePopup('OK','참가번호는 숫자만 입력하세요.',function(){
        		$("#lvst_auc_ptc_mn_no").focus();
        	});
            return;
    	}
        else if(!$('#lvst_auc_ptc_mn_no').prop('disabled') && Number($("#lvst_auc_ptc_mn_no").val()) > lmt_lvst_auc_ptc_mn_no) {
        	MessagePopup('OK','참가번호는 ' + lmt_lvst_auc_ptc_mn_no + '이하 숫자만 입력하세요.',function(){
        		$("#lvst_auc_ptc_mn_no").focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_date" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_date" ).focus();
            });
            return;
        }
        if(!fn_isDate($( "#auc_date" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_date" ).focus();
            });
            return;
        }
        
		MessagePopup('YESNO',"저장하시겠습니까?",function(res){
			if(res){
				if(setRowStatus == "I") {
					
					var result = sendAjaxFrm("frm_MhAucEntr", "/LALM1006_insPgm", "POST");
					if(result.status == RETURN_SUCCESS){
		            	
		            	MessagePopup("OK", "저장되었습니다.",function(res){
		            		fn_Search();
			                mv_RunMode = 3;
			                mv_CheckQcnMsg = 3;
			                fn_setMhucEntr();
		            	});
		            	
		                
		            } else {
		            	showErrorMessage(result);
		                return;
		            }
		            
				} else if(setRowStatus == "U") {
					var result = sendAjaxFrm("frm_MhAucEntr", "/LALM1006_updPgm", "POST");
		            if(result.status == RETURN_SUCCESS){
		            	MessagePopup("OK", "저장되었습니다.",function(res){
		            		fn_Search();
			                mv_RunMode = 3;
			                mv_CheckQcnMsg = 3;
			                
			                fn_InitFrm('frm_MhAucEntr');
			                fn_DisableAuc(true);
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
    		}else{    			
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
    	if(fn_isNull($( "#lvst_auc_ptc_mn_no" ).val())) {
        	MessagePopup('OK','참가번호를 입력하세요.',function(){
        		$("#lvst_auc_ptc_mn_no").focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_date" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_date" ).focus();
            });
            return;
        }
        if(!fn_isDate($( "#auc_date" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_date" ).focus();
            });
            return;
        }
    	
        MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
			if(res){									
				var result = sendAjaxFrm('frm_MhAucEntr', "/LALM1006_delPgm", "POST");            
	            if(result.status == RETURN_SUCCESS) {
	            	MessagePopup("OK", "삭제되었습니다.");
	            	fn_Search();
	                mv_RunMode = 3;
	                mv_CheckQcnMsg = 3;
	                
	                fn_InitFrm('frm_MhAucEntr');
	                fn_DisableAuc(true);
	            }else {
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
    	fn_ExcelDownlad('mainGrid', '경매참가번호관리');
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "경매참가번호 관리";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[경매대상 : ' + $('#cb_auc_obj_dsc option:selected').text()  + ' / 경매일자 : '+$('#auc_dt').val()+ ' / 참가번호 : ' + $('#lvst_auc_ptc_mn_no').val() + ']';
    	
    	ReportPopup('LALM1006R',TitleData, 'mainGrid', 'V');
    		
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
        
        /*                                1        2         3         4         5           6         7         8        9        10     11       12        13             14          15        16       17     18 */
        var searchResultColNames = ["경매일자", "경매대상", "참가번호", "중도매인", "중도매인명", "중도매인명", "생년월일", "인증번호", "전화번호", "전화번호", "주소", "상세주소", "상세주소", "경매참가보증금액", "응찰기반납", "거래확정", "삭제여부", "차수", "비고"];        
        var searchResultColModel = [						 
        							 {name:"AUC_DT",       			index:"AUC_DT",       		width:50,  align:'center', formatter:'gridDateFormat'},
                                     {name:"AUC_OBJ_DSC",			index:"AUC_OBJ_DSC",		width:50,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},                                     
                                     {name:"LVST_AUC_PTC_MN_NO",	index:"LVST_AUC_PTC_MN_NO",	width:50,  align:'center', sorttype: "number"},
                                     {name:"TRMN_AMNNO",        	index:"TRMN_AMNNO",        	width:50,  align:'center'},
                                     {name:"SRA_MWMNNM",        	index:"SRA_MWMNNM",        	width:50,  align:'center', hidden:true},
                                     {name:"HD_SRA_MWMNNM",        	index:"HD_SRA_MWMNNM",     	width:50,  align:'center'},
                                     {name:"FRLNO",        			index:"FRLNO",        		width:70,  align:'center', formatter:'gridDateFormat'},
                                     {name:"SMS_NO",        		index:"SMS_NO",     		width:50,  align:'center'},
                                     {name:"CUS_MPNO",        		index:"CUS_MPNO",        	width:70,  align:'center', hidden:true},
                                     {name:"HD_CUS_MPNO",        	index:"HD_CUS_MPNO",        width:70,  align:'center'},
                                     {name:"DONGUP",        		index:"DONGUP",        		width:100, align:'left'  },
                                     {name:"DONGBW",        		index:"DONGBW",        		width:100, align:'left', hidden:true},
                                     {name:"HD_DONGBW",        		index:"HD_DONGBW",        	width:100, align:'left'  },
                                     {name:"AUC_ENTR_GRN_AM",   	index:"AUC_ENTR_GRN_AM",    width:70,  align:'right' , formatter:'integer', formatoptions:{thousandsSeparator:','}},
                                     {name:"RTRN_YN",        		index:"RTRN_YN",        	width:50,  align:'center', edittype:"select", formatter : "select", editoptions:{value:"0:미반납;1:반납"}},
                                     {name:"TR_DFN_YN",        		index:"TR_DFN_YN",        	width:50,  align:'center', edittype:"select", formatter : "select", editoptions:{value:"0:미확정;1:확정"}},
                                     {name:"DEL_YN",        		index:"DEL_YN",        		width:150, align:'center', hidden:true},
                                     {name:"QCN",        		    index:"QCN",        		width:50,  align:'center'},
                                     {name:"RMK_CNTN",        		index:"RMK_CNTN",        	width:150, align:'left'  }                                     
                                    ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      365,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 15,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                var sel_data = $("#mainGrid").getRowData(rowid);
                var aucDat = fn_toDate(sel_data.AUC_DT);
                setRowStatus = "U";
                
                fn_DisableFrm('frm_MhAucEntr', false);
                fn_setChgRadio("hd_auc_obj_dsc", sel_data.AUC_OBJ_DSC);
                fn_setRadioChecked("hd_auc_obj_dsc");
                fn_DisableCbAuc(sel_data.AUC_OBJ_DSC);
                
                var frmObj = new Object();
       		 
                frmObj = $('#mainGrid').jqGrid('getRowData', rowid);
	        		 
	           	var results = sendAjax(frmObj, "/LALM1006_selSraList", "POST");
	           	var result = null;
	               
	            if(results.status == RETURN_SUCCESS) {
	            	result = setDecrypt(results);
	                
	            	$("#auc_date").val(aucDat);
	                $("#ddl_qcn").val(result[0].QCN)
	                $("#lvst_auc_ptc_mn_no").val(result[0].LVST_AUC_PTC_MN_NO);
	                $("#trmn_amnno").val(result[0].TRMN_AMNNO);
	                $("#sra_mwmnnm").val(result[0].SRA_MWMNNM);
	                $("#dongup").val(fn_xxsDecode(result[0].DONGUP + " " + result[0].DONGBW));
	                
	                fn_setChgRadio("hd_rtrn_yn", result[0].RTRN_YN);
	                $("input[name='rd_rtrn_yn']:radio[value='" + result[0].RTRN_YN + "']").prop("checked", true);
	                
	                fn_setChgRadio("hd_tr_dfn_yn", result[0].TR_DFN_YN);
	        		$("input[name='rd_tr_dfn_yn']:radio[value='" + result[0].TR_DFN_YN + "']").prop("checked", true);
	                
	                
	                $("#auc_entr_grn_am").val(fn_toComma(result[0].AUC_ENTR_GRN_AM));
	                $("#cus_mpno").val(result[0].CUS_MPNO);
	                $("#rmk_cntn").val(result[0].RMK_CNTN);
	                
	                $("#frlno").val(result[0].FRLNO);
	                $("#smsNo").val(result[0].SMS_NO);
	                $("#del_yn").val(result[0].DEL_YN);
	                
	                fn_DisableAuc(true);
	                //검색결과의 선택한 ROW 중도매인에 대한 불량중도매인 이력 검색
	                fn_SearchBadTrmn();
	            }
           },
        });
        $("#mainGrid").jqGrid("setLabel", "rn","No");
        
    }
    
  	//불량중도매인 그리드 생성
    function fn_CreateSubGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["등록조합","중도매인코드", "중도매인명", "블랙등록일자", "거래제한일자", "전화번호","사고등록사유내용", "경매참여제한여부", "등록자", "등록자연락처"];        
        var searchResultColModel = [ 						 
                                     {name:"CLNTNM",		index:"CLNTNM",		width:15, align:'center'},                                     
        							 {name:"TRMN_AMNNO",       	index:"TRMN_AMNNO",       	width:15, align:'center'},
                                     {name:"SRA_MWMNNM",    index:"SRA_MWMNNM",     width:15, align:'center'},
        							 {name:"REG_DATE",       	index:"REG_DATE",       	width:15, align:'center', formatter:'gridDateFormat'},
        							 {name:"LIMIT_DATE",       	index:"LIMIT_DATE",       	width:15, align:'center', formatter:'gridDateFormat'},
                                     {name:"TELNO",        	index:"TELNO",        	width:15, align:'center'},
                                     {name:"REG_REASON",	index:"REG_REASON", 	width:20, align:'center'},
                                     {name:"AUC_PART_LIMIT_YN",    index:"AUC_PART_LIMIT_YN", width:20, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"USRNM",			index:"USRNM",			width:15, align:'center'},
                                     {name:"MPNO",	index:"MPNO",		width:15, align:'center'}
                                    ];
            
        $("#mhBadTrmnGrid").jqGrid("GridUnload");
                
        $("#mhBadTrmnGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      60,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 1,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                var sel_data = $("#mhBadTrmnGrid").getRowData(rowid);
                setRowStatus = "U";
           },
        });
        
        $("#mhBadTrmnGrid").jqGrid("setLabel", "rn","No");
        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //**************************************
 	//function  : fn_rand(난수발생) 
 	//paramater : min(최소값), max(최대값) 
 	// result   : 랜덤숫자
 	//**************************************
    function fn_rand(min,max){
    	var randomVal = (window.crypto || window.msCrypto).getRandomValues(new Uint32Array(1))[0]/4294967296;
    	return Math.floor(randomVal * (max - min + 1)) + min;
    }
 	
    //**************************************
 	//function  : fn_SmsReq(SMS발송 인터페이스) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_SmsReq(){
    	var srchData = new Object();
        
        srchData["ctgrm_cd"]  = '3000';
        srchData["NA_BZPLC"]  = na_bzplc;
        srchData["MPNO"]      = $("#cus_mpno").val().replace(/-/gi,"");
        srchData["USRNM"]     = $("#sra_mwmnnm").val();
        srchData["PW"]        = $("#attc_no").val();
                
        var results = sendAjax(srchData, "/LALM1006_selSmSSend", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return false;
        }else{      
            result = setDecrypt(results);
            MessagePopup('OK','인증번호를 발송하였습니다');
            return true;
        }
    }
    
    //**************************************
 	//function  : fn_SelAucQcn(경매차수내역 조회) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
    function fn_SelAucQcn() {
		 var frmObj = new Object();
		 
		 frmObj['auc_dt'] = fn_dateToData($("#auc_date").val());
		 frmObj['auc_obj_dsc'] = $("#hd_auc_obj_dsc").val();
 		 
    	 var results = sendAjax(frmObj, "/Common_selAucQcn", "POST");
    	 var result = null;
        
         if(results.status == RETURN_SUCCESS) {
         	result = setDecrypt(results);
         	$("#ddl_qcn").val(result[0]["QCN"]);
         	$("#lvst_auc_ptc_mn_no").focus();
         	ot_auc_obj_dsc = result[0]["AUC_OBJ_DSC"].concat(",", result[0]["OT_AUC_OBJ_DSC"]).split(",");
         	var arrOtAucObjDsc = result[0]["OT_AUC_OBJ_DSC"].split(",");
         	for (var aucObjDsc of arrOtAucObjDsc) {
         		if(!aucObjDsc) continue;
         		fn_contrChBox(true, "cb_auc_obj_dsc" + aucObjDsc, "");
         	}
         } else {
        	if(mv_CheckQcnMsg == 1) {
        		MessagePopup('OK',"경매차수가 등록되지 않았습니다.");
            	$("#ddl_qcn").val("");
            	$("#auc_date").focus();
        	}
         }
         
         return;
    }
    
	//**************************************
	//function  : fn_DisableCbAuc(추가경매대상 체크박스 Disable) 
	//paramater : p_boolean(Disable시킬 체크박스 순번) ex) 1 
	// result   : N/A
	//**************************************
	function fn_DisableCbAuc(p_param){
		if (p_param != 0) {
			for (var auc_obj_dsc of ot_auc_obj_dsc) {
				if(!auc_obj_dsc) continue;
				fn_contrChBox(true, "cb_auc_obj_dsc" + auc_obj_dsc, "");
			}
		}
		if(p_param == 1) {
			fn_contrChBox(false, "cb_auc_obj_dsc1", "");
			$("#cb_auc_obj_dsc1").attr("disabled", true);
    		$("#cb_auc_obj_dsc2").attr("disabled", false);
    		$("#cb_auc_obj_dsc3").attr("disabled", false);
		} else if(p_param == 2) {
			fn_contrChBox(false, "cb_auc_obj_dsc2", "");
			$("#cb_auc_obj_dsc1").attr("disabled", false);
    		$("#cb_auc_obj_dsc2").attr("disabled", true);
    		$("#cb_auc_obj_dsc3").attr("disabled", false);
		} else if(p_param == 3) {
			fn_contrChBox(false, "cb_auc_obj_dsc3", "");
			$("#cb_auc_obj_dsc1").attr("disabled", false);
    		$("#cb_auc_obj_dsc2").attr("disabled", false);
    		$("#cb_auc_obj_dsc3").attr("disabled", true);
		} else {
			fn_contrChBox(false, "cb_auc_obj_dsc1", "");
			fn_contrChBox(false, "cb_auc_obj_dsc2", "");
			fn_contrChBox(false, "cb_auc_obj_dsc3", "");
       		$("#cb_auc_obj_dsc1").attr("disabled", true);
       		$("#cb_auc_obj_dsc2").attr("disabled", true);
       		$("#cb_auc_obj_dsc3").attr("disabled", true);
		}
	}
	
	//**************************************
	//function  : fn_DisableCut(경매대상, 경매일자, 참가번호 초기화 및 Disable) 
	//paramater : p_boolean(disable) ex) true 
	// result   : N/A
	//**************************************
	function fn_DisableAuc(p_boolean){		
			var rd_length = $("input[name='hd_auc_obj_dsc_radio']").length;
			var disableItem = $("input[name='hd_auc_obj_dsc_radio']");
			
			if(p_boolean) {
				$("#auc_date").attr("disabled", true);				
				$("#lvst_auc_ptc_mn_no").attr("disabled", true);
				$("#trmn_amnno").attr("disabled", true);
	    		$("#dongup").attr("disabled", true);
	    		$("#cus_mpno").attr("disabled", true);
	    		$("#rmk_cntn").attr("disabled", true);
	    		$("#ddl_qcn").attr("disabled", true);
	    		$("#frlno").attr("disabled", true);
	    		$("#smsNo").attr("disabled", true);
	    		fn_DisableCbAuc("0");
			} else {
				$("#auc_date").attr("disabled", false);
				$("#lvst_auc_ptc_mn_no").attr("disabled", false);
				$("#trmn_amnno").attr("disabled", true);
        		$("#dongup").attr("disabled", true);
        		$("#cus_mpno").attr("disabled", true);
        		$("#rmk_cntn").attr("disabled", true);
        		$("#ddl_qcn").attr("disabled", true);
        		$("#frlno").attr("disabled", true);
        		$("#smsNo").attr("disabled", true);
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
	//function  : fn_setMhucEntr(입력초기화 함수) 
	//paramater : p_boolean(disable) ex) true 
	// result   : N/A
	//**************************************
	function fn_setMhucEntr(){		
		setRowStatus = "I";
		
		fn_InitFrm('frm_MhAucEntr');    		
		fn_DisableFrm('frm_MhAucEntr', false);
		fn_DisableAuc(false);
		fn_DisableCbAuc($("#cb_auc_obj_dsc").val());
		$("#ddl_qcn").attr("disabled", true);
		$("#frlno").attr("disabled", true);
		$("#smsNo").attr("disabled", true);
		
		$("#auc_date").datepicker().datepicker("setDate", $("#auc_dt").val());
		$("input[name='hd_auc_obj_dsc_radio']:radio[value='" + $("#cb_auc_obj_dsc").val() + "']").prop("checked", true);
		$("input[name='rd_rtrn_yn']:radio[value='1']").prop("checked", true);
		$("input[name='rd_tr_dfn_yn']:radio[value='0']").prop("checked", true);
		$("#hd_auc_obj_dsc").val($("#cb_auc_obj_dsc").val());
		$("#hd_rtrn_yn").val("1");
		$("#hd_tr_dfn_yn").val("0");
		
		mv_RunMode = 1;
		
		// 경매차수 조회
		fn_SelAucQcn();
		
		$("#lvst_auc_ptc_mn_no").focus();
	}
	
	//**************************************
	//function  : fn_setClearFrom
	//paramater : p_FrmId ex) 'p_FrmId'
	//	          , p_GridIDs ex) '#Grid1 , #Grid2' 
	//result    : N/A
	//**************************************
	function fn_setClearFrom(p_FrmId,p_FromId){
	   
		$("#"+ p_FrmId).find('input[type=hidden], input[type=text], input[type=password], textarea, select, input[type=checkbox]').bind('change input',function(event){
	        //From 초기화
	        fn_InitFrm(p_FromId);
	        fn_DisableFrm(p_FromId, true);
	    });  
	}
	
	////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //**************************************
 	//function  : fn_CallMwmnPopup1(참가번호 팝업 호출) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_CallMwmnPopup1(p_param) {
 		var checkBoolean = p_param;
 		var data = new Object();
 		
 		data['sra_mwmnnm'] = $("#sra_mwmnnm1").val();
 		data['auc_obj_dsc'] = $("#cb_auc_obj_dsc").val();
 		data['auc_dt'] = fn_dateToData($("#auc_dt").val());
        
 		fn_CallMwmnnmNoPopup(data,checkBoolean,function(result) {
 			if(result){
 				$("#trmn_amnno1").val(result.TRMN_AMNNO);
 				$("#lvst_auc_ptc_mn_no1").val(result.LVST_AUC_PTC_MN_NO);
 				$("#sra_mwmnnm1").val(result.SRA_MWMNNM);
 			} else {
 				$("#trmn_amnno1").val("");
 				$("#lvst_auc_ptc_mn_no1").val("");
 				$("#sra_mwmnnm1").val("");
 			}
 		});
 	}
	
 	//**************************************
 	//function  : fn_CallMwmnPopup(중도매인 팝업 호출) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_CallMwmnPopup(p_param) {
 		var checkBoolean = p_param;
 		var data = new Object();
 		
 		data['sra_mwmnnm'] = $("#sra_mwmnnm").val();
        
 		fn_CallMwmnnmPopup(data,checkBoolean,function(result) {
 			if(result){
 				// 불량중도매인 체크
 				var rVal = fn_SearchBadCheck(result);
 				var blackFlag = rVal[0].AUC_PART_LIMIT_YN ?? '99';
 				
 				if(blackFlag != '99'){
 					switch(blackFlag){
 					case "1" :
 						let msg = "";
 						if (rVal[0].BLACK_CNT > 0) {
 							msg = rVal[0].CLNTNM + " 외 " + rVal[0].BLACK_CNT + "건 불량회원(B/L)으로 등록된 중도매인 입니다.<br/>확인 바랍니다.<br/>(불량회원 해지는 '기준정보 > 불량회원[B/L] 관리')";
 						} else {
 							msg = rVal[0].CLNTNM + "에서 불량회원(B/L)으로 등록된 중도매인 입니다.<br/>확인 바랍니다.<br/>(불량회원 해지는 '기준정보 > 불량회원[B/L] 관리')"
 						}
 						
 						//경매참여 가능하긴 하지만 불량회원 등록되어 있는 상태이다. 알럿 띄우고 정보 셋팅
 						MessagePopup('OK', msg, function(){
	 						$("#trmn_amnno").val(result.TRMN_AMNNO);
	 		 				$("#sra_mwmnnm").val(result.SRA_MWMNNM);
	 		 				$("#frlno").val(result.FRLNO);
	 		 				$("#smsNo").val(result.SMS_NO);
	 		 				$("#cus_mpno").val(result.CUS_MPNO);
	 		 				$("#dongup").val(fn_xxsDecode(result.DONGUP + ' ' + result.DONGBW));
	 		 				$("#rmk_cntn").val(result.RMK_CNTN);
 			            });
 						break;
 					case "0" : 
 						//경매참여도 불가능한 상태라 알럿만 띄우고 참가번호 등록 안됨
 						MessagePopup('OK','경매참여 불가 회원입니다. 기준정보 > 불량회원[B/L] 관리에서 참여제한을 해제하세요', function(){
 							$("#trmn_amnno").val("");
 			 				$("#sra_mwmnnm").val("");
 			 				$("#frlno").val("");
 			 				$("#smsNo").val("");
 			 				$("#cus_mpno").val("");
 			 				$("#dongup").val("");
 			 				$("#rmk_cntn").val("");
 						});
 						break;
 					}
 				}
 				//불량회원 아닌 경우 정상 정보 셋팅
 				else{
	 				$("#trmn_amnno").val(result.TRMN_AMNNO);
	 				$("#sra_mwmnnm").val(result.SRA_MWMNNM);
	 				$("#frlno").val(result.FRLNO);
	 				$("#smsNo").val(result.SMS_NO);
	 				$("#cus_mpno").val(result.CUS_MPNO);
	 				$("#dongup").val(fn_xxsDecode(result.DONGUP + ' ' + result.DONGBW));
	 				$("#rmk_cntn").val(result.RMK_CNTN);
 				}
 						
 			} else {
 				$("#trmn_amnno").val("");
 				$("#sra_mwmnnm").val("");
 				$("#frlno").val("");
 				$("#smsNo").val("");
 				$("#cus_mpno").val("");
 				$("#dongup").val("");
 				$("#rmk_cntn").val("");
 			}
 		});
 	}
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
                            <col width="80">
                            <col width="180">
                            <col width="80">
                            <col width="180">
                            <col width="80">
                            <col width="*">                            
                            <col width="150">
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
                                    <div class="cell"><input type="text" class="popup date" id="auc_dt" maxlength="10"></div>                                    
                                </td>
                                <th scope="row"><span class="tb_dot">참가번호</span></th>
                                <td>                                    
                                    <input disabled="disabled" type="text" style="width:100px" id="trmn_amnno1">
                                	<input disabled="disabled" type="text" style="width:100px" id="lvst_auc_ptc_mn_no1">                                
                                	<input type="text" style="ime-mode:active;width:100px" id="sra_mwmnnm1">
                                	<button id="pb_sra_mwmnnm1" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                </td>
<!--                                 <th scope="row"><span class="tb_dot">불량등록이력표시여부</span></th> -->
<!--                                 <td>                                     -->
<!--                                     <input type="checkbox" id="cb_grd_MhBadTrmnShow" name="cb_grd_MhBadTrmnShow" value="0"> -->
<!--                                     <h id="grd_MhBadTrmnShow">부</h>                                                                       -->
<!--                                 </td> -->
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">경매참가 정보</p></li>
                </ul> 
                <div class="pl2 fl_L">
					<label id="msg_Sbid" style="font-size: 15px; color: blue; font: message-box;">※참가번호는 500번 이하의 숫자만 입력 가능합니다.</label>
				</div>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                    <button class="tb_btn" name="pb_Init" value="입력초기화">입력초기화</button>
                </div>  
            </div>
            
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="grayTable rsp_v">
                	<form id="frm_MhAucEntr">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>                                
                                <th scope="row"><span>경매일자</span></th>
                                <td>                                    
                                    <div class="cell"><input type="text" class="date" id="auc_date" maxlength="10"></div>
                                </td>                                
                                <th scope="row"><span>경매대상</span></th>
                                <td  colspan=3>
                                    <div class="cellBox" id="auc_obj_dsc">
                                    </div>
                                    <input type="hidden" id="hd_auc_obj_dsc" name="hd_auc_obj_dsc">
                                </td>
                                <!-- <th scope="row"><span>추가경매대상</span></th>
                                <td>
                                    <input type="checkbox" id="cb_auc_obj_dsc1" name="cb_auc_obj_dsc1" class="auc_obj_dsc" value="1"> 송아지
                                    <input type="checkbox" id="cb_auc_obj_dsc2" name="cb_auc_obj_dsc2" class="auc_obj_dsc" value="2"> 비육우
                                    <input type="checkbox" id="cb_auc_obj_dsc3" name="cb_auc_obj_dsc3" class="auc_obj_dsc" value="3"> 번식우                   
                                </td> -->
                                <th scope="row"><span>경매차수</span></th>
                                <td colspan="3">
                                    <input type="text" disabled="disabled" id="ddl_qcn">
                                </td>                                
                            </tr>
                            <tr>
                            	<th scope="row"><span>참가번호</span></th>
                            	<td>
                            		<input type="text" id="lvst_auc_ptc_mn_no" maxlength="3" class="digit">                            		
                            	</td>
                            	<th scope="row"><span>중도매인</span></th>
                            	<td colspan=3>
                            		<input disabled="disabled" type="text" id="trmn_amnno" style="width:100px">
                            		<input type="text" id="sra_mwmnnm" style="ime-mode:active;width:200px;" maxlength="20" />
                            		<button id="pb_sra_mwmnnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                            	</td>                            	
                            	<th scope="row"><span>주소</span></th>
                            	<td colspan=3>
                            		<input disabled="disabled" type="text" id="dongup">
                            	</td>
                            </tr>
                            <tr>
                            	<th scope="row"><span>응찰기반납</span></th>
                            	<td>
                            		<input type="radio" id="rd_rtrn_yn_y"  name="rd_rtrn_yn" value="0" checked> 미반납
                                    <input type="radio" id="rd_rtrn_yn_n"  name="rd_rtrn_yn" value="1"> 반납
                                    <input type="hidden" id="hd_rtrn_yn" name="hd_rtrn_yn">
                            	</td>
                            	<th scope="row"><span>거래확정</span></th>
                            	<td>                            		
                            		<input type="radio" id="rd_tr_dfn_yn_y"  name="rd_tr_dfn_yn" value="0" checked> 미확정
                                    <input type="radio" id="rd_tr_dfn_yn_n"  name="rd_tr_dfn_yn" value="1"> 확정
                                    <input type="hidden" id="hd_tr_dfn_yn" name="hd_tr_dfn_yn">
                            	</td>
                            	<th scope="row"><span>참가보증금</span></th>
                            	<td>
                            		<input type="text" class="number" id="auc_entr_grn_am" maxlength="8">
                            	</td>
                            	<th scope="row"><span>전화번호</span></th>
                            	<td colspan=3>
                            		<input disabled="disabled" type="text" id="cus_mpno">
                            	</td>
                            </tr>
                            <tr>
                            	<th scope="row"><span>생년월일</span></th>
                                <td>
                                    <input type="text" disabled="disabled" id="frlno">
                                </td>
                                <th scope="row"><span>인증번호</span></th>
                                <td>
                                    <input type="text" disabled="disabled" id="smsNo">
                                </td>                                
                            	<th scope="row"><span>비고</span></th>
                            	<td colspan=5 id="td_rmk_cntn">
                            		<input disabled="disabled" type="text" id="rmk_cntn">
                            		<input type="hidden" id="del_yn">
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
            
            <div class="tab_box clearfix" id="grd_MhBadTrmn_Text">
                <ul class="tab_list">
                    <li><p class="dot_allow">불량중도매인 등록이력</p></li>
                </ul>
            </div>
            <div class="listTable rsp_v" id="grd_MhBadTrmn_Grid">
                <table id="mhBadTrmnGrid" style="width:100%;">
                </table>
            </div>
            
        </section>       
    </div>
</body>
</html>