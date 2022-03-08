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
 * 2. 파  일  명   : LALM0312
 * 3. 파일명(한글) : 산정가 입력
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.05   신명진   최초작성
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
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);	
        fn_Init();      
        
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
        //그리드 초기화
        fn_CreateGrid();
        
        //폼 초기화
        fn_InitFrm('srchFrm_list');   
        $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());    
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){    	 
        
    	var results = sendAjaxFrm("frm_Search", "/LALM0312_selList", "POST");        
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
    	 var ids = $('#mainGrid').jqGrid('getDataIDs');
         for (var i = 0, len = ids.length; i < len; i++) {
        	 
             var rowData = $('#mainGrid').jqGrid('getRowData', ids[i]);
             if(rowData._STATUS_ != "*" && rowData._STATUS_ != "+")continue;
             if(rowData.SANJUNG1 == 0){
                 var _index = fn_GridColByName('mainGrid', 'SANJUNG1');
                 MessagePopup("OK", "수정할 행의 모든 산정가를 입력하세요.",function(res){
                     setTimeout("$('#mainGrid').editCell(" + ids[i] + "," + _index + ", true);", 100);                     
                 });
                 return;                 
             }
             if(rowData.SANJUNG2 == 0){
                 var _index = fn_GridColByName('mainGrid', 'SANJUNG2');
                 MessagePopup("OK", "수정할 행의 모든 산정가를 입력하세요.",function(res){
                     setTimeout("$('#mainGrid').editCell(" + ids[i] + "," + _index + ", true);", 100);                     
                 });
                 return;                 
             }
             if(rowData.SANJUNG3 == 0){
                 var _index = fn_GridColByName('mainGrid', 'SANJUNG3');
                 MessagePopup("OK", "수정할 행의 모든 산정가를 입력하세요.",function(res){
                     setTimeout("$('#mainGrid').editCell(" + ids[i] + "," + _index + ", true);", 100);                     
                 });
                 return;                 
             }
             if(rowData.SANJUNG4 == 0){
                 var _index = fn_GridColByName('mainGrid', 'SANJUNG4');
                 MessagePopup("OK", "수정할 행의 모든 산정가를 입력하세요.",function(res){
                     setTimeout("$('#mainGrid').editCell(" + ids[i] + "," + _index + ", true);", 100);                     
                 });
                 return;                 
             }
             
             
         }
         
    	 
	   	 MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
	         if(res){
	        	 var tmpSaveObject = $.grep($("#mainGrid").jqGrid('getRowData'), function(obj){
	        		return obj._STATUS_ == "*" || obj._STATUS_ == "+" ;
	        	 });
	             
	             if(tmpSaveObject.length > 0) {
	            	 var result        = null;
	                    
	                 var insDataObj = new Object();     
	                 insDataObj['data'] = tmpSaveObject;
	                         
	                 result = sendAjax(insDataObj, "/LALM0312_updSogCowSjam", "POST");
	                 
	                 if(result.status == RETURN_SUCCESS){
	                     MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
	                    	 fn_Search();
	                     });
	                 }else {
	                     showErrorMessage(result);
	                     return;
	                 } 
	             } else {
	                 MessagePopup("OK", "변경된 내역이 없습니다.");
	                 return;
	             }
	             
	                
	         }else{
	             MessagePopup('OK','취소되었습니다.');
	         }
	     });
     }
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
        
    
    
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        /*                                1         2       3        4      5      6         7      8      9       10        11         12         13         14       15 */
        var searchResultColNames = ["", "경매번호", "경매대상", "출하주", "귀표번호", "산차", "계대", "생년월일", "성별", "중량", "어미구분", "산정가격1", "산정가격2", "산정가격3", "산정가격4", "평균가",
        	                        "경매일자", "원장일련번호", "농가식별번호", "농장관리번호", "최초최저낙찰한도금액", "판매상태구분코드", "송아지응찰단위금액", "비육우응찰단위금액", "번식우응찰단위금액", "원표번호"];        
        var searchResultColModel = [						 
						            {name:"_STATUS_",             index:"_STATUS_",             width:5,  align:'center'},
						            {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:30, align:'center'},
						            {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						            {name:"FTSNM",                index:"FTSNM",                width:30, align:'center'},
						            {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:50, align:'center'},
						            {name:"MATIME",               index:"MATIME",               width:30, align:'center'},
						            {name:"SRA_INDV_PASG_QCN",    index:"SRA_INDV_PASG_QCN",    width:30, align:'center'},
						            {name:"BIRTH",                index:"BIRTH",                width:30, align:'center'},
						            {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						            {name:"COW_SOG_WT",           index:"COW_SOG_WT",           width:30, align:'center'},
						            {name:"MCOW_DSC",             index:"MCOW_DSC",             width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
						            {name:"SANJUNG1",             index:"SANJUNG1",             width:30, align:'right', editable:true , formatter:'integer', formatoptions:{thousandsSeparator:','},
                                	 editoptions:{
                                          dataInit:function(e){$(e).addClass('grid_number');},
                                          maxlength:"5"                                          
                                       }						           
						            },
						            {name:"SANJUNG2",             index:"SANJUNG2",             width:30, align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
	                                	 editoptions:{
	                                          dataInit:function(e){$(e).addClass('grid_number');},
	                                          maxlength:"5"	                                          
	                                       }						            
						            },
						            {name:"SANJUNG3",             index:"SANJUNG3",             width:30, align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
	                                	 editoptions:{
	                                          dataInit:function(e){$(e).addClass('grid_number');},
	                                          maxlength:"5"	                                          
	                                       }						            
						            },
						            {name:"SANJUNG4",             index:"SANJUNG4",             width:30, align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
	                                	 editoptions:{
	                                          dataInit:function(e){$(e).addClass('grid_number');},
	                                          maxlength:"5"	                                          
	                                       }						            
						            },
						            {name:"LOWS_SBID_LMT_AM",       index:"LOWS_SBID_LMT_AM",       width:30, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:','}},
						            {name:"AUC_DT",                 index:"AUC_DT",                 width:30, align:'center', hidden:true},						            
						            {name:"LED_SQNO",               index:"LED_SQNO",               width:30, align:'center', hidden:true},
						            {name:"FHS_ID_NO",              index:"FHS_ID_NO",              width:30, align:'center', hidden:true},
						            {name:"FARM_AMNNO",             index:"FARM_AMNNO",             width:30, align:'center', hidden:true},
						            {name:"FIR_LOWS_SBID_LMT_AM",   index:"FIR_LOWS_SBID_LMT_AM",   width:30, align:'center', hidden:true},
						            {name:"SEL_STS_DSC",            index:"SEL_STS_DSC",            width:30, align:'center', hidden:true},                                     
						            {name:"CALF_AUC_ATDR_UNT_AM",   index:"CALF_AUC_ATDR_UNT_AM",   width:30, align:'center', hidden:true},                                     
						            {name:"NBFCT_AUC_ATDR_UNT_AM",  index:"NBFCT_AUC_ATDR_UNT_AM",  width:30, align:'center', hidden:true},                                     
						            {name:"PPGCOW_AUC_ATDR_UNT_AM", index:"PPGCOW_AUC_ATDR_UNT_AM", width:30, align:'center', hidden:true},
						            {name:"OSLP_NO", 				index:"OSLP_NO", 				width:30, align:'center', hidden:true}
						            
                                    ];
        
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
			datatype:    "local",
			data:        data,
			height:      520,
			rowNum:      rowNoValue,
            cellEdit:    true,				
			resizeing:   true,
			autowidth:   true,
			shrinkToFit: false,
			rownumbers:  true,
			rownumWidth: 10,
            cellsubmit:  "clientArray",    
            afterEditCell: function(rowid, cellname, value, iRow, iCol) {  

            	$("#"+rowid+"_"+cellname).on('blur',function(e){
            		$("#mainGrid").jqGrid("saveCell", iRow, iCol);
            		
            		if($("#mainGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                        return;
                    }else {
            	        if($(this).val() < 1){
            	        	$(this).val('0') ;
            	        };
                        if($(this).val() != value){                      	
                        	var v_cnt = 0;
                        	var v_avg = 0;
                        	var v_sum = 0;
                        	var v_sanjung1 = 0;
                        	var v_sanjung2 = 0;
                        	var v_sanjung3 = 0;
                        	var v_sanjung4 = 0;                  	
                        	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG1 > 0 ){
                        		v_sanjung1 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG1)
                        	}
                        	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG2 > 0 ){
                        		v_sanjung2 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG2)
                        	}
                        	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG3 > 0 ){
                        		v_sanjung3 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG3)
                        	}
                        	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG4 > 0 ){
                        		v_sanjung4 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG4)
                        	}                        	

                        	if( v_sanjung1 > 0) { v_cnt = v_cnt +1;	}
                        	if( v_sanjung2 > 0) { v_cnt = v_cnt +1;	}
                        	if( v_sanjung3 > 0) { v_cnt = v_cnt +1;	}
                        	if( v_sanjung4 > 0) { v_cnt = v_cnt +1;	}

                        	if( v_cnt > 0 ){
                        		v_sum = parseInt((v_sanjung1 + v_sanjung2 +v_sanjung3+v_sanjung4) / v_cnt);
                        	}
                        	$("#mainGrid").jqGrid("setCell", rowid, 'LOWS_SBID_LMT_AM', v_sum);
                        	$("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);

                        }
                    }
            	}).on('keydown',function(e){
            		var code = e.keyCode || e.which;
                    if(code == 13){
                    	e.preventDefault();
                    	$("#mainGrid").jqGrid("saveCell", iRow, iCol);
                        
                        if($("#mainGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                            return;
                        }else {
                            if($(this).val() != value){
                            	var v_cnt = 0;
                            	var v_avg = 0;
                            	var v_sum = 0;
                            	var v_sanjung1 = 0;
                            	var v_sanjung2 = 0;
                            	var v_sanjung3 = 0;
                            	var v_sanjung4 = 0;                  	
                            	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG1 > 0 ){
                            		v_sanjung1 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG1)
                            	}
                            	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG2 > 0 ){
                            		v_sanjung2 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG2)
                            	}
                            	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG3 > 0 ){
                            		v_sanjung3 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG3)
                            	}
                            	if( $("#mainGrid").jqGrid("getRowData", rowid).SANJUNG4 > 0 ){
                            		v_sanjung4 = parseInt($("#mainGrid").jqGrid("getRowData", rowid).SANJUNG4)
                            	}                        	

                            	if( v_sanjung1 > 0) { v_cnt = v_cnt +1;	}
                            	if( v_sanjung2 > 0) { v_cnt = v_cnt +1;	}
                            	if( v_sanjung3 > 0) { v_cnt = v_cnt +1;	}
                            	if( v_sanjung4 > 0) { v_cnt = v_cnt +1;	}

                            	if( v_cnt > 0 ){
                            		v_sum = parseInt((v_sanjung1 + v_sanjung2 +v_sanjung3+v_sanjung4) / v_cnt);
                            	}
                            	$("#mainGrid").jqGrid("setCell", rowid, 'LOWS_SBID_LMT_AM', v_sum);                            	
                                $("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                            }
                        }
                    }                       
                });                  
                                 
            },            
            colNames: searchResultColNames,
            colModel: searchResultColModel,	
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
                	<form id="frm_Search">
                    <table>
                        <colgroup>
                            <col width="10">
                            <col width="30">
                            <col width="10">
                            <col width="30">
                            <col width="100">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <select id="auc_obj_dsc" class="popup"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_dt" maxlength="10"></div>
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
                <table id="mainGrid" style="width:100%;">
                </table>
            </div>
            
        </section>       
    </div>
</body>
</html>