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
 * 2. 파  일  명   : LALM0217
 * 3. 파일명(한글) : 일괄경매구간 관리
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.20   유성제   최초작성
 ------------------------------------------------------------------------------*/
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     //var na_bzplc = App_na_bzplc;
     var userId = App_userId;
     //mv_RunMode = '1':최초로딩, '2':조회, '3':저장/삭제, '4':기타설정
     var mv_RunMode = 0;
     var setRowStatus = "";
     
     $(document).ready(function(){
    	 
         fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
         fn_setCodeRadio("cb_auc_obj_dsc","hd_auc_obj_dsc","AUC_OBJ_DSC", 2);
         fn_SetComboList();
         fn_DisableAuc(true);
         fn_Init();
                
        //프로그램ID 대문자 변환
        $("#de_pgid").bind("keyup", function(){
            $(this).val($(this).val().toUpperCase());
        });
        $("#rg_sqno").hide();   
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#mainGrid");           
        
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
            $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        }
        fn_InitFrm('frm_MhRkonCm');        
        $("#cb_auc_dt").datepicker().datepicker("setDate", fn_getToday());
        $("#btn_Save").attr('disabled', true);
        $("#btn_Delete").attr('disabled', true);
        setRowStatus = "";
        
//         // 울산축협일 경우에만 단가 표시
//         if(na_bzplc != "8808990656632") {
//         	// 단가 display none
//             $("#female_kg_text").css("display","none");
//     		$("#female_kg").css("display","none");
//     		$("#male_kg_text").css("display","none");
//     		$("#male_kg").css("display","none");
//         }
        
        mv_RunMode = 1;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
        
        var results = sendAjaxFrm("frm_Search", "/LALM0121_selList", "POST");        
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
        if(fn_isNull($( "#cb_auc_dt" ).val())){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#cb_auc_dt" ).focus();
            });
            return;
        }
        if(!fn_isDate($( "#cb_auc_dt" ).val())){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#cb_auc_dt" ).focus();
            });
            return;
        }
        if(fn_isNull($( "#pda_id" ).val()) ){
        	MessagePopup('OK','PDA 번호를 입력하세요.',function(){
                $( "#pda_id" ).focus();
            });
            return;
        }        
		MessagePopup('YESNO',"저장하시겠습니까?",function(res){
			if(res){
				if(setRowStatus == "I") {					
					var result = sendAjaxFrm("frm_MhRkonCm", "/LALM0121_insPgm", "POST");            
		            if(result.status == RETURN_SUCCESS){
		            	MessagePopup("OK", "저장되었습니다.");
		            	mv_RunMode = 3;
		            	fn_Init();
		            	fn_InitFrm('frm_MhRkonCm');
		                fn_Search();
		            } else {
		            	showErrorMessage(result);
		                return;
		            }
		            
				} else if(setRowStatus == "U") {					
					var result = sendAjaxFrm("frm_MhRkonCm", "/LALM0121_updPgm", "POST");            
		            if(result.status == RETURN_SUCCESS){
		            	MessagePopup("OK", "수정되었습니다.");
		            	mv_RunMode = 3;
		            	fn_Init();
		            	fn_InitFrm('frm_MhRkonCm');
		                fn_Search();
		            } else {
		            	showErrorMessage(result);
		                return;
		            }
		            
				} else {
					MessagePopup('OK','오류가 발생했습니다 처음부터다시 시도해주세요.');
					fn_Init();
					return;
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
    	
        MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
			if(res){									
				var result = sendAjaxFrm('frm_MhRkonCm', "/LALM0121_delPgm", "POST");            
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
    
//  /*------------------------------------------------------------------------------
//  * 1. 함 수 명    : 차수 존재여부 확인
//  * 2. 입 력 변 수 : N/A
//  * 3. 출 력 변 수 : N/A
//  ------------------------------------------------------------------------------*/    
    function fn_inSave(){
    	 
			MessagePopup('YESNO',"저장하시겠습니까?",function(res){
					if(res){
						if(setRowStatus == "I") {					
							var result = sendAjaxFrm("frm_MhRkonCm", "/LALM0217_insPgm", "POST");            
				            if(result.status == RETURN_SUCCESS){
				            	MessagePopup("OK", "저장되었습니다.");
				            	mv_RunMode = 3;
				            	fn_Init();
				            	fn_InitFrm('frm_MhRkonCm');
				                fn_Search();
				            } else {
				            	showErrorMessage(result);
				                return;
				            }
				            
						} else if(setRowStatus == "U") {					
							var result = sendAjaxFrm("frm_MhRkonCm", "/LALM0217_updPgm", "POST");            
				            if(result.status == RETURN_SUCCESS){
				            	MessagePopup("OK", "저장되었습니다.");
				            	mv_RunMode = 3;
				            	fn_Init();
				            	fn_InitFrm('frm_MhRkonCm');
				                fn_Search();
				            } else {
				            	showErrorMessage(result);
				                return;
				            }
				            
						} else {
							MessagePopup('OK','오류가 발생했습니다 처음부터다시 시도해주세요.');
							fn_Init();
							return;
						}
		    		}else{    			
		    			MessagePopup('OK','취소되었습니다.');
		    			return;
		    		}
				}); 
    }    
       
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
   		fn_ExcelDownlad('mainGrid', '산정위원관리');

    }   
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
       	/*                               1       2           3         4         5          6        7      */
       	var searchResultColNames = [ "경매대상", "경매일자",  "PDA번호", "산정위원", "산정위원명", "비고내용", "전송"];        
        var searchResultColModel = [						 
						            {name:"AUC_OBJ_DSC"    		, index:"AUC_OBJ_DSC"    		, width:15, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
						            {name:"AUC_DT"         		, index:"AUC_DT"         		, width:15, align:'center'},
						            {name:"PDA_ID"     		 	, index:"PDA_ID"      			, width:15, align:'center'},
						            {name:"LVST_MKT_TRPL_AMNNO" , index:"LVST_MKT_TRPL_AMNNO"   , width:15, align:'center'},                                     
						            {name:"BRKR_NAME"    		, index:"BRKR_NAME"    			, width:15, align:'center'},
						            {name:"RMK_CNTN"        	, index:"RMK_CNTN"        		, width:15, align:'left'},
						            {name:"TMS_YN"         		, index:"TMS_YN"         		, width:15, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                    ];

            
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
            rownumWidth: 1,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                var sel_data = $("#mainGrid").getRowData(rowid);
                var aucDat = fn_toDate(sel_data.AUC_DT);
                setRowStatus = "U";
                
                fn_setChgRadio("hd_auc_obj_dsc", sel_data.AUC_OBJ_DSC);
                fn_setRadioChecked("hd_auc_obj_dsc");
                $("#btn_Save").attr('disabled', false);
                $("#btn_Delete").attr('disabled', false);
                
                $("#cb_auc_obj_dsc").attr('disabled', false);
                $("#cb_auc_dt").attr('disabled', false);
                $("#pda_id").attr('disabled', false);
                
                $("#cb_auc_dt").val(aucDat);                
                $("#pda_id").val(sel_data.PDA_ID);
                $("#lvst_mkt_trpl_amnno").val(sel_data.LVST_MKT_TRPL_AMNNO);             
                $("#rmk_cntn").val(sel_data.RMK_CNTN);
                fn_DisableAuc(true);
           },
        });
        
        $("#mainGrid").jqGrid("setLabel", "rn","No");
        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    // 버튼클릭 이벤트
    $(document).ready(function() {
    	// 입력초기화 버튼클릭 이벤트
    	$(document).on("click", "button[name='btn_Init']", function() {   
    		event.preventDefault();
    		mv_RunMode = 1;
    		setRowStatus = "I";
    		fn_InitFrm('frm_MhRkonCm');
    		fn_DisableFrm('frm_MhRkonCm', false);
    		fn_DisableAuc(false);
            $("#btn_Save").attr('disabled', false);
            $("#btn_Delete").attr('disabled', true);   
            
    		$("#pda_id" ).focus();
    		
        });
    	   	
    });
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
	//**************************************
	//function  : fn_DisableAuc(경매대상, 경매일자 초기화 및 Disable) 
	//paramater : p_boolean(disable) ex) true 
	// result   : N/A
	//**************************************
	function fn_DisableAuc(p_boolean){		
			var rd_length = $("input[name='hd_auc_obj_dsc_radio']").length;
			var disableItem = $("input[name='hd_auc_obj_dsc_radio']");
			
			if(p_boolean) {
				$("#cb_auc_dt").attr("disabled", true);
				$("#pda_id").attr("disabled", true);				
			} else {
				$("#pda_id").attr("disabled", false);
				$("#cb_auc_dt").attr("disabled", false);
				$("#cb_auc_dt").datepicker().datepicker("setDate", fn_getToday());
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
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SetComboList(){
   	    var result_1;
	    var results_1 = null; 

 	    results_1 = sendAjaxFrm("frm_Search", "/LALM0121_selLmtaComboList", "POST");
        if(results_1.status != RETURN_SUCCESS){
            showErrorMessage(results_1);
             return;
        }else{     
        	result_1 = setDecrypt(results_1);           
        }    
        
    	$("#lvst_mkt_trpl_amnno").empty().data('options');
    	$("#lvst_mkt_trpl_amnno").append('<option value=' + "" + '>' + "전체" + '</option>');
    	$.each(result_1, function(i){
    	    var v_simp_nm = ('['+result_1[i].LVST_MKT_TRPL_AMNNO + '] ' + result_1[i].BRKR_NAME);
    	    $("#lvst_mkt_trpl_amnno").append('<option value=' + result_1[i].LVST_MKT_TRPL_AMNNO + '>' + v_simp_nm + '</option>');
    	});                
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
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">                            
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <select id="auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="auc_dt"></div>
                                    </div>
                                </td>
                                <th scope="row"><span >산정위원</span></th>
                                <td>
                                    <div class="cellBox">
	                                    <div class="cell"><input type="text" id="brkr_name" ></div> 
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
                    <li><p class="dot_allow">산정위원 정보</p> </li>	                                  
                </ul>
                <div class="fl_R">
                    <button class="tb_btn" name="btn_Init" value="입력초기화">입력초기화</button>
                </div>                 
            </div>            
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_MhRkonCm" name="frm_MhRkonCm">
                    <table>
                        <colgroup>
<%--                             <col width="40"> --%>
<%--                             <col width="10"> --%>
<%--                             <col width="100"> --%>
<%--                             <col width="40"> --%>
<%--                             <col width="50"> --%>
<%--                             <col width="40">  --%>
<%--                             <col width="100"> --%>
<%--                             <col width="100"> --%>
                            
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100"> 
                            <col width="*">     
                            <col width="100">                                                   
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <div class="cellBox" id="cb_auc_obj_dsc">
                                    </div>
                                    <input type="hidden" id="hd_auc_obj_dsc" name="hd_auc_obj_dsc">
                                </td>                                
<!--                                 <td id="radio" class="radio" colspan='2'> -->
<!--                                     <input type="radio" name="srch_con" id="cb_auc_obj_dsc1"  value="1"><label for="cb_auc_obj_dsc1">송아지</label> -->
<!--                                     <input type="radio" name="srch_con" id="cb_auc_obj_dsc2"  value="2"><label for="cb_auc_obj_dsc2">비육우</label> -->
<!--                                     <input type="radio" name="srch_con" id="cb_auc_obj_dsc3"  value="3"><label for="cb_auc_obj_dsc3">번식우</label> -->
<!--                                     <input type="radio" name="srch_con" id="cb_auc_obj_dsc0"  value="0"><label for="cb_auc_obj_dsc0">일괄</label> -->
<!--                                 </td>                                   -->
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="cb_auc_dt"></div>
                                    </div>
                                </td>
                                <th scope="row"><span >PDA번호</span></th>
                                <td>
                                    <div class="cellBox">
	                                    <div class="cell"><input type="text" id="pda_id" ></div>    
                                    </div>                                                               
                                </td>
                            </tr>
                            
                            <tr>
                                <th scope="row">산정위원</th>
                                <td>
                                    <select id="lvst_mkt_trpl_amnno"></select>
                                </td>                                
                                <th scope="row"><span >비고내용</span></th>
                                <td>
                                    <div class="cellBox">
	                                    <div class="cell"><input type="text" id="rmk_cntn" ></div>    
                                    </div>                                                               
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
                <table id="mainGrid" style="width:1807px;">
                </table>
            </div>
            
        </section>       
    </div>
</body>
</html>