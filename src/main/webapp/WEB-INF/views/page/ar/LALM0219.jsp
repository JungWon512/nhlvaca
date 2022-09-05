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
</head>
<style>
#context-menu {
  position:fixed;
  z-index:20000;
  width:180px;
  background:#1b1a1a;
  border-radius:5px;
  transform:scale(0);
  transform-origin:top left;
}
#context-menu.active {
  transform:scale(1);
  transition:transform 300ms ease-in-out;
}
#context-menu .item {
  padding:8px 10px;
  font-size:15px;
  color:#eee;
}
#context-menu .item:hover {
  cursor:pointer;
  background:#555;
  -ms-user-select: none; 
  -moz-user-select: -moz-none;
  -khtml-user-select: none;
  -webkit-user-select: none;
  user-select: none;
}
#context-menu .item i {
  display:inline-block;
  margin-right:5px;
}
#context-menu hr {
  margin:2px 0px;
  border-color:#555;
}
</style>
<script type="text/javascript">
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0219
 * 3. 파일명(한글) : 경매순번 설정
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.27   신명진   최초작성
 ------------------------------------------------------------------------------*/
//컨텍스트 메뉴  
window.addEventListener("contextmenu",function(event){
	if(event.target.tagName != "INPUT" && document.getSelection() == ""){
		event.preventDefault();
		if($("#broker").is(":checked") && event.target.tagName == 'TD' && event.target.offsetParent.id == 'mainGrid'){
			
			var contextElement = document.getElementById("context-menu");
	        contextElement.style.top = event.clientY + document.body.scrollLeft + "px";
	        contextElement.style.left = event.clientX  + document.body.scrollTop   + "px";
	        
	        contextElement.classList.add("active");
		}
	     
    }
     
 });
 window.addEventListener("click",function(){
     document.getElementById("context-menu").classList.remove("active");
 });
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
    	//그리드 초기화
        fn_CreateGrid();
         
      	/******************************
         * 경매번호 재설정 버튼클릭 이벤트
         ******************************/
     	$(document).on("click", "button[id='pb_btnAucNoChg']", function() {   
     		var ids = $('#mainGrid').jqGrid('getDataIDs');
 	       	var rowcount = 0;
 	        for (var i = 0, len = ids.length; i < len; i++) {
 	        	rowcount++;
 	            var rowData = $('#mainGrid').jqGrid('getRowData', ids[i]);
 	            $("#mainGrid").jqGrid("setCell", ids[i], 'AUC_PRG_SQ', rowcount);
 	            $("#mainGrid").jqGrid('setCell', ids[i], '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
 	        }    		
     		
        });
     	
     	/******************************
         * 경매번호 초기화 버튼클릭 이벤트
         ******************************/
     	$(document).on("click", "button[id='pb_btnAucNoRe']", function() {   
     	   	var ids = $('#mainGrid').jqGrid('getDataIDs');
 	       	var rowcount = 0;
 	        for (var i = 0, len = ids.length; i < len; i++) {
 	            var rowData = $('#mainGrid').jqGrid('getRowData', ids[i]);
 	            $("#mainGrid").jqGrid("setCell", ids[i], 'AUC_PRG_SQ', rowData.OSLP_NO);
 	            $("#mainGrid").jqGrid('setCell', ids[i], '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
 	        }    		
     		
        });
     	
        /******************************
         * 경매번호 수동변경 체크
         ******************************/
        $("#broker").change(function() {
     		if($("#broker").is(":checked")) {
     			$("#pb_btnTop").attr("disabled", true);
                $("#pb_btnUp").attr("disabled", true);
                $("#pb_btnDown").attr("disabled", true);
                $("#pb_btnBottm").attr("disabled", true);
                
                $("#mainGrid").jqGrid("setGridParam",{multiboxonly:false});
                $("#mainGrid").on("selectstart",function(event){return false;});
                $("#mainGrid").on("dragstart",function(event){return false;});
                document.getSelection().removeAllRanges();
                 
                var rowCount = $("#mainGrid").jqGrid("getGridParam", "reccount");
                 
                for(var i = 0; i < rowCount; i++) {
                	var colIndex = fn_GridColByName('mainGrid','AUC_PRG_SQ');
                 	$('#mainGrid tr').eq(i+1).children("td:eq("+colIndex+")").removeClass('not-editable-cell');
                }
     		} else {
     			$("#pb_btnTop").attr("disabled", false);
                $("#pb_btnUp").attr("disabled", false);
                $("#pb_btnDown").attr("disabled", false);
                $("#pb_btnBottm").attr("disabled", false);
                $("#mainGrid").jqGrid("setGridParam",{multiboxonly:true});
                $("#mainGrid").unbind("selectstart");
                $("#mainGrid").unbind("dragstart");
                                 
 				var rowCount = $("#mainGrid").jqGrid("getGridParam", "reccount");
                 
                for(var i = 0; i < rowCount; i++) {
                	$("#mainGrid").jqGrid("setCell", i+1, "AUC_PRG_SQ", "", "not-editable-cell");
                }
                $("#mainGrid").jqGrid("resetSelection");
     		}
     	});
     	
         /******************************
         * 맨위 버튼 이벤트
         ******************************/
     	 $("#pb_btnTop").on("click", function(e) {
     		e.preventDefault();
     		
     		var selRowIds = $("#mainGrid").jqGrid("getGridParam", "selrow");
     		var getData = $("#mainGrid").jqGrid('getRowData');
     		
     		$("#mainGrid").jqGrid("clearGridData", true);
     		
             var rowid = 1;
             
             $("#mainGrid").jqGrid("addRowData", rowid, getData[selRowIds-1], 'last');
             
     		for (var i = 0, len = getData.length; i < len; i++) {
     			if(i != selRowIds-1) {
     				rowid++
     				$("#mainGrid").jqGrid("addRowData", rowid, getData[i], 'last');
     			}
     			$("#mainGrid").jqGrid("setCell", i+1, "AUC_PRG_SQ", "", "not-editable-cell");
     		}
     		$("#mainGrid").jqGrid("resetSelection");
             
     	 });
         
     	 /******************************
         * 위 버튼 이벤트
         ******************************/
     	 $("#pb_btnUp").on("click", function(e) {
     		e.preventDefault();
     		
     		var selRowIds = $("#mainGrid").jqGrid("getGridParam", "selrow");
     		var getData = $("#mainGrid").jqGrid('getRowData');
     		var rowid = 1;
     		
     		if(parseInt(selRowIds) > 1) {
     			$("#mainGrid").jqGrid("clearGridData", true);
         		
         		for (var i = 0, len = getData.length; i < len; i++) {
         			
         			if(selRowIds-2 == i) {
         				$("#mainGrid").jqGrid("addRowData", rowid, getData[selRowIds-1], 'last');
         			} else if(selRowIds-1 == i) {
         				$("#mainGrid").jqGrid("addRowData", rowid, getData[selRowIds-2], 'last');
         			} else {
         				$("#mainGrid").jqGrid("addRowData", rowid, getData[i], 'last');
         			}
         			
         			rowid++;
         			$("#mainGrid").jqGrid("setCell", i+1, "AUC_PRG_SQ", "", "not-editable-cell");
         		}
     		}
     		
     		$("#mainGrid").jqGrid("setSelection", selRowIds-1, true);
     	 });
     	
     	 /******************************
         * 아래 버튼 이벤트
         ******************************/
     	 $("#pb_btnDown").on("click", function(e) {
     		e.preventDefault();
     		
     		var selRowIds = $("#mainGrid").jqGrid("getGridParam", "selrow");
     		var getData = $("#mainGrid").jqGrid('getRowData');
     		var rowid = 1;
     		
     		if(parseInt(selRowIds) > 0 && parseInt(getData.length)+1 > parseInt(selRowIds)) {
     			$("#mainGrid").jqGrid("clearGridData", true);
         		
         		for (var i = 0, len = getData.length; i < len; i++) {
         			
         			if(selRowIds == i) {
         				$("#mainGrid").jqGrid("addRowData", rowid, getData[selRowIds-1], 'last');
         			} else if(selRowIds-1 == i) {
         				$("#mainGrid").jqGrid("addRowData", rowid, getData[selRowIds], 'last');
         			} else {
         				$("#mainGrid").jqGrid("addRowData", rowid, getData[i], 'last');
         			}
         			
         			rowid++;
         			$("#mainGrid").jqGrid("setCell", i+1, "AUC_PRG_SQ", "", "not-editable-cell");
         		}
     		}
     		
     		$("#mainGrid").jqGrid("setSelection", parseInt(selRowIds)+1, true);
     	 });
     	
     	 /******************************
         * 맨아래 버튼 이벤트
         ******************************/
     	 $("#pb_btnBottm").on("click", function(e) {
     		e.preventDefault();
     		
     		var selRowIds = $("#mainGrid").jqGrid("getGridParam", "selrow");
     		var getData = $("#mainGrid").jqGrid('getRowData');
     		
             
             if(parseInt(selRowIds) > 0 && parseInt(selRowIds) < getData.length) {
             	$("#mainGrid").jqGrid("clearGridData", true);
             	var rowid = 1;
             	for (var i = 0, len = getData.length; i < len; i++) {
         			if(selRowIds != i+1) {
         				$("#mainGrid").jqGrid("addRowData", rowid, getData[i], 'last');
         				$("#mainGrid").jqGrid("setCell", rowid, "AUC_PRG_SQ", "", "not-editable-cell");
         				rowid++;
         			}
         		}
         		
         		$("#mainGrid").jqGrid("addRowData", rowid, getData[selRowIds-1], 'last');
         		$("#mainGrid").jqGrid("setCell", i+1, "AUC_PRG_SQ", "", "not-editable-cell");
         		$("#mainGrid").jqGrid("resetSelection");
             }
             
     	 });
        
         /******************************
         * 프로그램ID 대문자 변환
         ******************************/
         $("#de_pgid").bind("keyup", function(){
            $(this).val($(this).val().toUpperCase());
         });
         
         /******************************
          * 경매번호 제설정
          ******************************/
         $("#auc_prg_sq_1").on("click", function(e) {
        	 e.preventDefault();
        	 fn_aucPrgSq(1);
         });
         $("#auc_prg_sq_2").on("click", function(e) {
             e.preventDefault();
             fn_aucPrgSq(2);
         });
         $("#auc_prg_sq_4").on("click", function(e) {
             e.preventDefault();
             fn_aucPrgSq(4);
         });
         

         fn_Init();
        
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        
    	 $("#mainGrid").jqGrid("clearGridData", true);
      	fn_InitFrm('frm_Search');
        $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        fn_InitFrm('frm_MhAucStn');
        
        setRowStatus = "";
        
        mv_RunMode = 1;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
     	if(fn_isNull($( "#st_auc_no" ).val())) {
     		$( "#st_auc_no" ).val('0')
        }
     	if(fn_isNull($( "#ed_auc_no" ).val())) {
     		$( "#ed_auc_no" ).val('0')
        }
     	$("#mainGrid").jqGrid("clearGridData", true);
     	
        var results = sendAjaxFrm("frm_Search", "/LALM0219_selList", "POST");        
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

    	 var temp1 = 0;
    	 var temp2 = 0;
    	 
    	 var getData = $("#mainGrid").jqGrid('getRowData');
         
         for (var i = 1, len = getData.length; i <= len; i++) {
        	 temp1 = $("#mainGrid").jqGrid('getCell', i, 'AUC_PRG_SQ');
        	 for (var t = 1, len2 = getData.length; t <= len2; t++) {
        		 if(i != t) {
        			 temp2 = $("#mainGrid").jqGrid('getCell', t, 'AUC_PRG_SQ');
        			 if(temp1 == temp2) {
        				 MessagePopup("OK", "중복된 경매번호가 있습니다. 확인하세요.");
        				 return;
            		 }
        		 }
        	 }
         }
    	 
	   	 MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
	         if(res){
	        	 if (App_na_bzplc == '8808990659008') {
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
	        	 } else {
		        	 var tmpSaveObject = $.grep($("#mainGrid").jqGrid('getRowData'), function(obj){
			        		return obj._STATUS_ == "*" || obj._STATUS_ == "+" ;
			        	 });
			             
			             if(tmpSaveObject.length > 0) {
			            	 var result        = null;
			                    
			                 var insDataObj = new Object();     
			                 insDataObj['data'] = tmpSaveObject;
			                         
			                 result = sendAjax(insDataObj, "/LALM0219_updSogCowSq", "POST");
			                 
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
	        		 
	        	 }
	                
	         }else{
	             MessagePopup('OK','취소되었습니다.');
	         }
	     });		
    }

    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
        
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //그리드 생성
    function fn_CreateGrid(data) {
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        	/*                               1         2      3        4       5           6         7        8     9      10     11      12          13         14        15    16          17        18       19         20   */
        	var searchResultColNames = [ "", "경매번호", "경매대상", "출하주", "생산자", "귀표번호", "등록우 구분", "생년월일","월령", "성별", "KPN", "계대", "산차", "어미귀표번호", "어미구분", "번식우구분", "주소", "고능력여부", "비고내용", "접수일자", "등록일시"
						        		, "경매일자", "원장일련번호(경매=1)", "하한가", "중량", "원표번호"
						        		];        
	        var searchResultColModel = [	
	        	                        {name:"_STATUS_"      ,             index:"_STATUS_",                       width:10,  align:'center'},
						                {name:"AUC_PRG_SQ"          ,   	index:"AUC_PRG_SQ"          ,   		width:70,  align:'center', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
 	                                    	 editoptions:{
 	                                             dataInit:function(e){$(e).addClass('grid_number');},
 	                                             maxlength:"5"
 	                                             
 	                                          }
 	                                     },
						                {name:"AUC_OBJ_DSC"         ,   	index:"AUC_OBJ_DSC"         ,   		width:70, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
						                {name:"FTSNM"               ,   	index:"FTSNM"               ,   		width:70, align:'center' },
						                {name:"SRA_PDMNM"           ,   	index:"SRA_PDMNM"           ,   		width:70, align:'center' },
						                {name:"SRA_INDV_AMNNO"      ,   	index:"SRA_INDV_AMNNO"      ,   		width:150, align:'center' },
						                {name:"RG_DSC"              ,   	index:"RG_DSC"              ,   		width:70, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)} },
						                {name:"BIRTH"               ,   	index:"BIRTH"               ,   		width:70, align:'center' },
						                {name:"MTCN"             	,   	index:"MTCN"	            ,   		width:70, align:'center' },
						                {name:"INDV_SEX_C"          ,   	index:"INDV_SEX_C"          ,   		width:70, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						                {name:"KPN_NO"              ,   	index:"KPN_NO"              ,   		width:70, align:'center' },
						                {name:"SRA_INDV_PASG_QCN"   ,   	index:"SRA_INDV_PASG_QCN"   ,   		width:70, align:'center' },
						                {name:"MATIME"              ,   	index:"MATIME"              ,   		width:70, align:'center' },
						                {name:"MCOW_SRA_INDV_AMNNO" ,   	index:"MCOW_SRA_INDV_AMNNO" ,   		width:150, align:'center' },
						                {name:"MCOW_DSC"            ,   	index:"MCOW_DSC"            ,   		width:70, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
						                {name:"PPGCOW_FEE_DSC"      ,   	index:"PPGCOW_FEE_DSC"      ,   		width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
						                {name:"ADDR"                ,   	index:"ADDR"                ,   		width:200,align:'left' },
						                {name:"EPD_YN"              ,   	index:"EPD_YN"              ,   		width:70, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
						                {name:"RMK_CNTN"            ,   	index:"RMK_CNTN"            ,   		width:200, align:'left' },
						                {name:"RC_DT"               ,   	index:"RC_DT"               ,   		width:70, align:'center' },
						                {name:"LSCHG_DTM"           ,   	index:"LSCHG_DTM"           ,   		width:70, align:'center' },
						                {name:"AUC_DT"              ,   	index:"AUC_DT"              ,   		width:50, align:'center', hidden:true},
						                {name:"LED_SQNO"            ,   	index:"LED_SQNO"            ,   		width:50, align:'center', hidden:true},
						                {name:"LOWS_SBID_LMT_AM"    ,   	index:"LOWS_SBID_LMT_AM"    ,   		width:50, align:'center', hidden:true},
						                {name:"COW_SOG_WT"          ,   	index:"COW_SOG_WT"          ,   		width:50, align:'center', hidden:true},
						                {name:"OSLP_NO"             ,   	index:"OSLP_NO"             ,   		width:70, align:'center' }
	                                    ];

            
        $("#mainGrid").jqGrid("GridUnload");

        
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth:30,
            cellEdit:    true,
            cellsubmit:  "clientArray", 
            multiselect:true,
            multiboxonly:true,
            footerrow: true,
            userDataOnFooter: true,
            onSelectRow: function(rowid, status, e){
//             	if($("#broker").is(":checked") && e.shiftKey){
//             		document.getSelection().removeAllRanges();
//             	}
            },
//             onRightClickRow: function(rowid, iRow, iCol, e){
//             	if(!$("#broker").is(":checked")) {
//             		$("#mainGrid").jqGrid("resetSelection");
//             	}
            	
//             },
            beforeSelectRow: function(rowid, e) {
            	if($("#broker").is(":checked")) {
            		var initalRowSelect = $("#mainGrid").jqGrid('getGridParam','selrow');
            		if(!e.ctrlKey && !e.shiftKey){
            			if(initalRowSelect != null && initalRowSelect != rowid){
            				$("#mainGrid").jqGrid("resetSelection");
            			}
            		}else if(e.shiftKey){
            			
            			$("#mainGrid").jqGrid("resetSelection");
            			
            			var CurrentSelectIndex = $("#mainGrid").jqGrid('getInd', rowid);
            			var InitialSelectIndex = $("#mainGrid").jqGrid('getInd', initalRowSelect);
            			var startID = "";
            			var endID = "";
            			if(CurrentSelectIndex > InitialSelectIndex){
            				startID = initalRowSelect;
            				endID = rowid;
            			}else {
            				startID = rowid;
            				endID = initalRowSelect;
            			}
            			var shouldSelectRow = false;
            			$.each($("#mainGrid").getDataIDs(), function(_,id){
            				if((shouldSelectRow = id == startID || shouldSelectRow) && (id != rowid)){
            					$("#mainGrid").jqGrid('setSelection',id,false);
            				}
            				return id != endID;
            			});
            		}
            		return true;
            	}
            },
            afterEditCell: function(rowid, cellname, value, iRow, iCol) {  

            	$("#mainGrid").jqGrid("setCell", rowid, 'AUC_PRG_SQ', '');
            	
            	$("#"+rowid+"_"+cellname).on('blur',function(e){
            		$("#mainGrid").jqGrid("saveCell", iRow, iCol);
            		
            		if($("#mainGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                        return;
                    }else {
                        if($(this).val() != value){
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
                	        if($(this).val() < 1){
                	        	$(this).val('0') ;
                	        };                            	
                            if($(this).val() != value){
                                $("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                            }
                        }
                        var reccnt = $("#mainGrid").getGridParam("reccount");
                        if(reccnt > iRow){
                            setTimeout("$('#mainGrid').editCell(" + (iRow + 1) + "," + iCol + ", true);", 100);
                        }
                    }                        
                });
            }, 
            colNames: searchResultColNames,
            colModel: searchResultColModel, 
        });
        
        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No");
        //체크박스 삭제
        $("#mainGrid").jqGrid('hideCol','cb');
        //드래그 로우 순서 변경
//         $("#mainGrid").jqGrid('sortableRows',{update: function(e, html){
        	
//         	var getData = $("#mainGrid").jqGrid('getRowData');
//             $("#mainGrid").jqGrid("clearGridData", true);
//             var rowid = 1;
//             for (var i = 0, len = getData.length; i < len; i++) {
//             	$("#mainGrid").jqGrid("addRowData", rowid, getData[i], 'last');
             	
//              	if(getData[i]["_STATUS_"] == '+') {
//              		$("#calfGrid").jqGrid('setCell', rowid, '_STATUS_', '+');
//              	} else if(getData[i]["_STATUS_"] == '*') {
//              		$("#calfGrid").jqGrid('setCell', rowid, '_STATUS_', '*', GRID_MOD_BACKGROUND_COLOR);
//              	}
             	
//              	if($("#broker").is(":checked")) {
//              		var colIndex = fn_GridColByName('mainGrid','AUC_PRG_SQ');
//                 	$('#mainGrid tr').eq(i).children("td:eq("+colIndex+")").removeClass('not-editable-cell');
//              	} else {
//              		$("#mainGrid").jqGrid("setCell", i+1, "AUC_PRG_SQ", "", "not-editable-cell");
//              	}
             	
//              	rowid++;
//             }
//         }});
        //$(".ui-jqgrid tr.jqgrow td").css("height","30px");
        //합계행에 가로스크롤이 있을경우 추가
        var $obj = document.getElementById('mainGrid');
        var $bDiv = $($obj.grid.bDiv), $sDiv = $($obj.grid.sDiv);

        $bDiv.css({'overflow-x':'hidden'});
        $sDiv.css({'overflow-x':'scroll'});
        $sDiv.scroll(function(){
            $bDiv.scrollLeft($sDiv.scrollLeft());
        });
        
        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        $("#mainGrid .jqgfirstrow td:last-child").width($("#mainGrid .jqgfirstrow td:last-child").width() - 17);
        
        //footer        
        var gridDatatemp = $('#mainGrid').getRowData();

        var tot_sra_indv_amnno        = 0; //총두수
        var tot_lows_sbid_lmt_am 	  = 0; //하한가등록두수       
        var tot_cow_sog_wt 		      = 0; //중량등록두수        
        var am_sra_indv_amnno 		  = 0; //암두수            	                                                    	     
        var su_sra_indv_amnno 		  = 0; //수 두수   
        
        $.each(gridDatatemp,function(i){
        	//총두수
            tot_sra_indv_amnno++; 
        	//하한가등록두수
        	if(gridDatatemp[i].LOWS_SBID_LMT_AM > 0 ){
        		tot_lows_sbid_lmt_am++;
        	}
			//중량등록두수
        	if(gridDatatemp[i].COW_SOG_WT > 0 ){
        		tot_cow_sog_wt++;	  
        	}  
        	//암두수
        	if(gridDatatemp[i].INDV_SEX_C == '1' || gridDatatemp[i].INDV_SEX_C == '4' || gridDatatemp[i].INDV_SEX_C == '6' ){
        		am_sra_indv_amnno++;  
        	}   
        	//수 두수   
        	if(gridDatatemp[i].INDV_SEX_C == '2' || gridDatatemp[i].INDV_SEX_C == '3' || gridDatatemp[i].INDV_SEX_C == '5' ){
        		su_sra_indv_amnno++;	  
        	}         	

        });        
      
        
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_PRG_SQ"             ,"총 두 수"           	   ,1 ,"String" ]             
               ,["AUC_OBJ_DSC"            ,tot_sra_indv_amnno      ,1 ,"Integer"]               
               ,["FTSNM"                  ,"하한가등록두수"  		   ,2 ,"String" ]               
               ,["SRA_INDV_AMNNO"         ,tot_lows_sbid_lmt_am    ,1 ,"Integer"]               
               ,["RG_DSC"                 ,"중량등록두수"			   ,1 ,"String"]               
               ,["BIRTH"                  ,tot_cow_sog_wt          ,1 ,"Integer"]               
               ,["INDV_SEX_C"             ,"암두수"                  ,1 ,"String"]               
               ,["KPN_NO"                 ,am_sra_indv_amnno       ,1 ,"Integer"]               
               ,["SRA_INDV_PASG_QCN"      ,"수두수"                  ,1 ,"String"]               
               ,["MATIME"                 ,su_sra_indv_amnno       ,1 ,"Integer"]                              
           ] 	       
 	       
        ];
 
        fn_setGridFooter('mainGrid', arr);
        
        $("#broker").trigger('change');
        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    function fn_aucPrgSq(step){
		console.log(step);
		var idx = $('#mainGrid').jqGrid('getGridParam', 'selarrrow');
		if(idx.length < 2){
			MessagePopup("OK", "2건 이상 선택하여야 합니다.");
			return
		}
		idx.sort(function(a,b){return a-b});
		
		var value = parseInt($('#mainGrid').jqGrid('getCell',idx[0],'AUC_PRG_SQ'));
		for(var i=1; i< idx.length;i++){
			value = value + step;
			$('#mainGrid').jqGrid('setCell',idx[i],'AUC_PRG_SQ', value);
			$("#mainGrid").jqGrid('setCell',idx[i], '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
		}
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
                    <table>
                        <colgroup>
                            <col width="80">
                            <col width="*">
                            <col width="80">
                            <col width="*">
                            <col width="80">
                            <col width="*">
                            <col width="80">
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
                                </td>
                                <th scope="row">정렬구분</th>
                                <td>
                                    <select id="sel_order">
                                    	<option value="1"> 경매번호</option>
                                    	<option value="2"> 수/암 + 생년월일↓(어린순) + 바코드↑</option>
                                    	<option value="3"> 수/암 + 생년월일↑ + 바코드↑</option>
                                    	<option value="4"> 수/암 + 경매번호</option>
                                    	<option value="5"> 수/암 + 경매번호 + 등록우</option>
                                    	<option value="6"> 수/암 + 지역↓ + 생년월일↓(어린순) + 바코드</option>
                                    	<option value="7"> 암/수 + 지역↓ + 생년월일↓(어린순) + 바코드</option>
                                    	<option value="8"> 경매대상 + 생산자↑ + 암/수 + 조합원여부</option>
                                    	<option value="9"> 암/수 + 지역↓ + 생년월일↓(어린순) + 등록우↑</option>
                                    	<option value="10">암/수 + 지역↓</option>
                                    	<option value="11">등록우↑ + 수/암 + 생년월일↑</option>
                                    	<option value="12">암/수 + 생년월일↓(어린순)</option>
                                    	<option value="13">수/암 + 생년월일↓(어린순) + 등록구분(고등-혈통-기초-없음)</option>
                                    	<option value="14">등록우↑ + 수/암 + 생년월일↓(어린순)</option>
                                    	<option value="15">암/수 + 생년월일↑</option>
                                    	<option value="16">암/수 + 등록구분(등록우/미등록우) + 생년월일↓(어린순)</option>
                                    	<option value="17">암송아지-고능력암송아지-고능력수송아지-수송아지 + 생년월일↓(어린순)</option>
                                    	<option value="18">접수일자 + 수/암 + 생년월일↓(어린순)</option>
                                    	<option value="19">'접수일자 + 수/암 + 생년월일↑</option>
                                    </select>
                                </td> 
                                <th scope="row">귀표번호</th>
                                <td>
                                    <input type="text" id="sra_indv_amnno" style="text-align:right;">
                                </td>                                                     
                            </tr>
                            <tr>
                                <th scope="row">경매번호</th>
                                <td>                                       
                                    <div class="cellBox">
	                                    <div class="cell"><input type="text" id="st_auc_no" style="text-align:right;"></div>
	                                    <div class="cell ta_c"> ~ </div>
	                                    <div class="cell"><input type="text" id="ed_auc_no" style="text-align:right;"></div>    
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
                    <li><p class="dot_allow">경매번호 설정</p></li>
                </ul>
            </div>  
            
            <div class="tab_box clearfix">
                <div class="fl_L"><!--  //버튼 모두 좌측정렬 -->   
                     
                    <button class="tb_btn" id="pb_btnTop">맨 위</button>
                    <button class="tb_btn" id="pb_btnUp">위</button>
                    <button class="tb_btn" id="pb_btnDown">아래</button>
                    <button class="tb_btn" id="pb_btnBottm">맨 아래</button>
                    <input type="checkbox" id="broker"/>경매번호 수동변경
                </div>                     
            </div>     
            
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul> 
                
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                    <button class="tb_btn" id="pb_btnAucNoRe">경매번호 초기화</button>
                    <button class="tb_btn" id="pb_btnAucNoChg">경매번호 재설정</button>
                </div> 
            </div>
            <div class="listTable rsp_v">
                <table id="mainGrid" style="width:100%;">
                </table>
            </div>            
        </section>       
    </div>
    <div id="context-menu">
    <div id="auc_prg_sq_1" class="item">
        <i class="fa fa-wrench"></i> 경매번호 재설정+1
    </div>
    <div id="auc_prg_sq_2" class="item">
        <i class="fa fa-wrench"></i> 경매번호 재설정+2
    </div>
    <div id="auc_prg_sq_4" class="item">
        <i class="fa fa-wrench"></i> 경매번호 재설정+4
    </div>
</div>
</body>
</html>