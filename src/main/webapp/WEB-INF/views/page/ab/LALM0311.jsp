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
.ui-jqgrid tr.jqgrow td, .ui-jqgrid tr.jqgroup td{
	    font-size: 13px;
	     height: 25px;
}
</style>

<script type="text/javascript">
(function($){
	"use strict";
	/*global $ */
	/*jslint plusplus: true */
	$.jgrid.extend({
		setColWidth: function(iCol,newWidth,adjustGridWidth){
			return this.each(function(){
				var $self = $(this), grid = this.grid, p=this.p, colName, colModel=p.colModel, i, nCol;
				if(typeof iCol === "string"){
					//the first parameter is column name instead of index
					colName = iCol;
					for(i=0,nCol=colModel.length;i<nCol;i++){
						if(colModel[i].name === colName){
							iCol = i;
							break;
						}
					}
					if(i>=nCol){
						return;// error:non-existing column name specified as the first parameter
					}
				}else if (typeof iCol !== "number"){
					return; //error:wrong paramters
				}
				grid.resizing = {idx:iCol};
				grid.headers[iCol].newWidth = newWidth;
				grid.newWidth = p.tblwidth + newWidth - grid.headers[iCol].width;
				grid.dragEnd();//adjust column width
				if(adjustGridWidth !== false){
					$self.jqGrid("setGridWidth",grid.newWidth,false);//adjust grid width too
				}
			});
		}
	});
}(jQuery));
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0311
 * 3. 파일명(한글) : 중량/예정가 입력
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.12   신명진   최초작성
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
     
     $(document).ready(function(){
        //그리드 초기화
        fn_CreateGrid();
        fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2);
        if(isMobile){
            $('#ch_rmk_cntn_title').hide();
            $('#ch_rmk_cntn').hide();
            $('#ch_cow_wt').hide();
            $('#ch_lows_sbid_am').hide();
             
        }
        
        fn_Init();
        
     	/******************************
         * 참가번호 검색(돋보기) 팝업 호출 이벤트
         ******************************/
        $("#pb_search_ftsnm").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            fn_CallSraFhsSrchPopup(false);
        });
        
        /******************************
         * 참가번호 팝업 이벤트
         ******************************/
        $("#ftsnm").keydown(function(e) {
             if(e.keyCode == 13) {
                 if(fn_isNull($("#ftsnm").val())) {
                     MessagePopup('OK','출하주를 입력하세요.');
                     $("#sra_mwmnnm1").focus();
                     return;
                     
                 } else {
                     fn_CallSraFhsSrchPopup(true);
                 }
              }
        });
        
        /******************************
         * 참가번호 이벤트
         ******************************/
        $("#ftsnm").on("change keyup paste", function(e){
            if(e.keyCode != 13) {
                $("#fhs_id_no").val("");
             }
        });
        
        /******************************
         * 비고저장 checkbox 이벤트
         ******************************/
        $("#ch_rmk_cntn").change(function() {
        	if($("#ch_rmk_cntn").is(":checked")) {
        		$("#ch_modl_no").prop("checked", false);
        		$("#ch_cow_wt").prop("checked", false);
        		$("#ch_lows_sbid_am").prop("checked", false);
    			$("#btn_allLowsSbidLmtAmMinus").attr("disabled", true);
        	}else{
        		$("#btn_allLowsSbidLmtAmMinus").attr("disabled", false);        		
        	}
    	});
        
        /******************************
         * 예정가저장 checkbox 이벤트
         ******************************/
        $("#ch_lows_sbid_am").change(function() {        
        	if($("#ch_lows_sbid_am").is(":checked")) {
        		$("#ch_rmk_cntn").prop("checked", false);
        		$("#ch_modl_no").prop("checked", false);
        		$("#ch_cow_wt").prop("checked", false);
    			$("#btn_allLowsSbidLmtAmMinus").attr("disabled", true);
        	}else{
        		$("#btn_allLowsSbidLmtAmMinus").attr("disabled", false);        		
        	}
    	});
        
        /******************************
         * 중량저장 checkbox 이벤트
         ******************************/
        $("#ch_cow_wt").change(function() {
        	if($("#ch_cow_wt").is(":checked")) {
        		$("#ch_rmk_cntn").prop("checked", false);
        		$("#ch_modl_no").prop("checked", false);
        		$("#ch_lows_sbid_am").prop("checked", false);
    			$("#btn_allLowsSbidLmtAmMinus").attr("disabled", true);
        	}else{
        		$("#btn_allLowsSbidLmtAmMinus").attr("disabled", false);        		
        	}
    	});
        
        /******************************
         * 거치대번호 checkbox 이벤트
         ******************************/
        $("#ch_modl_no").change(function() {
        	if($("#ch_modl_no").is(":checked")) {
        		$("#ch_rmk_cntn").prop("checked", false);
        		$("#ch_cow_wt").prop("checked", false);
        		$("#ch_lows_sbid_am").prop("checked", false);
    			$("#btn_allLowsSbidLmtAmMinus").attr("disabled", true);
        	}
        	else{
        		$("#btn_allLowsSbidLmtAmMinus").attr("disabled", false);        		
        	}
    	});
        
        $('#btn_allLowsSbidLmtAmMinus').click((e)=>{
            e.preventDefault();
            //this.blur();
            var data = $('#mainGrid').getRowData();
            if(data.length == 0){
				MessagePopup("OK", "조회된 데이터가 없습니다.");
            	return;
            }
            if($('#st_auc_no').val() ==''|| $('#ed_auc_no').val() ==''){
				MessagePopup("OK", "경매번호를 확인 하세요.");
            	return;
            }
            if($('#minus_am').val() ==''){
            	MessagePopup("OK", "차감 금액을 확인 하세요.");
            	return;
            }
            
            var stAucNo = new Number($('#st_auc_no').val());
            var edAucNo = new Number($('#ed_auc_no').val());
            var minusAm = new Number($('#minus_am').val());
            data.forEach((o,i)=>{
        		var lowAm = new Number(o.LOWS_SBID_LMT_AM);
            	if(stAucNo <= new Number(o.AUC_PRG_SQ) && edAucNo >= new Number(o.AUC_PRG_SQ) && lowAm > 0){
               		var result =  lowAm - minusAm;
       	            $("#mainGrid").jqGrid("setCell", i+1, 'LOWS_SBID_LMT_AM', (result<0?0:result));
       	            $("#mainGrid").jqGrid('setCell', i+1, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
               		return o;
           		};
            });
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
        fn_DisableFrm('frm_Search', false);
        $("#fhs_id_no").attr("disabled", true);
        $("#btn_allLowsSbidLmtAmMinus").attr("disabled", false);
        $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        $("#mainGrid").jqGrid("clearGridData", true);
        
        // 경매대상 초기화면 '송아지' 설정(세종공주: 8808990656588 경주: 8808990659008)
        if(na_bzplc == "8808990656588" || na_bzplc == "8808990659008") {
            $("#cb_auc_obj_dsc").val("0");        
        } else {
            $("#cb_auc_obj_dsc").val("1");
        }
        
        $("#calf_auc_atdr_unt_am").val(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
        $("#nbfct_auc_atdr_unt_am").val(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
        $("#ppgcow_auc_atdr_unt_am").val(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);
        if(isMobile){
        	$(".mobile_search").show();
        }
        	
                
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
        $("#mainGrid").jqGrid("clearGridData", true);
        
        var results;                
        var result;
        
        if(!$("#ch_rmk_cntn").is(":checked") && $("#ch_modl_no").is(":checked")) {
        	results = sendAjaxFrm("frm_Search", "/LALM0311_selModlList", "POST");
        } else {
        	results = sendAjaxFrm("frm_Search", "/LALM0311_selList", "POST");
        }
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGrid(result);
            fn_DisableFrm('frm_Search', true);
            if(isMobile){
                $(".mobile_search").hide();
            }
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
         
         //var tmpSaveObject = $("#mainGrid").getChangedCells("all");
         var tmpSaveObject = $.grep($("#mainGrid").jqGrid('getRowData'), function(obj){return obj._STATUS_ == "*" || obj._STATUS_ == "+" ;});
         
         if(tmpSaveObject.length > 0) {
             var srchData      = new Object();
             var result        = null;
             
             srchData["changedata"] = tmpSaveObject;
             srchData["calf_auc_atdr_unt_am"] = parent.envList[0]["CALF_AUC_ATDR_UNT_AM"];
             srchData["nbfct_auc_atdr_unt_am"] = parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"];
             srchData["ppgcow_auc_atdr_unt_am"] = parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"];
             // 기타 경매대상 축가
             srchData["etc_auc_obj_dsc"] = parent.envList[0]["ETC_AUC_OBJ_DSC"];
             srchData["gt_auc_atdr_unt_am"] = parent.envList[0]["GT_AUC_ATDR_UNT_AM"];
             srchData["hs_auc_atdr_unt_am"] = parent.envList[0]["HS_AUC_ATDR_UNT_AM"];
                     
             if($("#ch_rmk_cntn").is(":checked")) {
                 result = sendAjax(srchData, "/LALM0311_updRmkPgm", "POST");
                 
             } else if($("#ch_modl_no").is(":checked")) {
            	 result = sendAjax(srchData, "/LALM0311_updModlPgm", "POST");            	 
             }else if($("#ch_cow_wt").is(":checked") || $("#ch_lows_sbid_am").is(":checked")) {
            	 srchData["chk_save_type"] = $(".chk_save_type:checked").val(); 
            	 result = sendAjax(srchData, "/LALM0311_updPgmOnlySave", "POST");            	 
             } else {
                 result = sendAjax(srchData, "/LALM0311_updPgm", "POST");
             }
             
             if(result.status == RETURN_SUCCESS){
                 MessagePopup("OK", "저장되었습니다.");
                 fn_Search();
                 mv_RunMode = 3;
             }else {
                 showErrorMessage(result);
                 return;
             }
         } else {
             MessagePopup("OK", "변경된 내역이 없습니다.");
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
        
        if($("#ch_rmk_cntn").is(":checked") || $("#ch_cow_wt").is(":checked") || $("#ch_lows_sbid_am").is(":checked")) {
            $("#ch_rmk_cntn").val(($("#ch_rmk_cntn").is(":checked") ? "1" :"0"));
            //$("#ch_cow_wt").val(($("#ch_cow_wt").is(":checked") ? "1" :"0"));
            //$("#ch_lows_sbid_am").val(($("#ch_lows_sbid_am").is(":checked") ? "1" :"0"));
            /*                                    1          2        3         4         5       6         7         8           9                10        11     12         13 */
            var searchResultColNames = ["", "경매번호", "거치대번호", "경매대상", "대표코드", "귀표번호", "출하주", "경매일자", "원표번호", "원장일련번호", "최초최저낙찰한도금액", "비고(*)", "중량", "예정가"];        
            var searchResultColModel = [                         
                                         {name:"_STATUS_",              index:"_STATUS_",               width:10,  align:'center'},
                                         {name:"AUC_PRG_SQ",            index:"AUC_PRG_SQ",             width:50,  align:'center',formatter: "integer", sorttype: "number"},
                                         {name:"MODL_NO",               index:"MODL_NO",                width:50,  align:'center'},
                                         {name:"AUC_OBJ_DSC",           index:"AUC_OBJ_DSC",            width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},                                     
                                         {name:"SRA_INDV_AMNNO1",       index:"SRA_INDV_AMNNO1",        width:80,  align:'center'},
                                         {name:"SRA_INDV_AMNNO",        index:"SRA_INDV_AMNNO",         width:150, align:'center'},                                     
                                         {name:"FTSNM",                 index:"FTSNM",                  width:80,  align:'center'},
                                         {name:"AUC_DT",                index:"AUC_DT",                 width:10,  align:'center', hidden:true},
                                         {name:"OSLP_NO",               index:"OSLP_NO",                width:10,  align:'center', hidden:true},
                                         {name:"LED_SQNO",              index:"LED_SQNO",               width:10,  align:'center', hidden:true},
                                         {name:"FIR_LOWS_SBID_LMT_AM",  index:"FIR_LOWS_SBID_LMT_AM",   width:10,  align:'center', hidden:true},
                                         {name:"RMK_CNTN",              index:"RMK_CNTN",               width:200, align:'left' , editable:$("#ch_rmk_cntn").is(":checked")},
                                         {name:"COW_SOG_WT",            index:"COW_SOG_WT",             width:70,  align:'right', editable:$("#ch_cow_wt").is(":checked")
                                             , editoptions:{
                                                 dataInit:function(e){$(e).addClass('grid_number integer').attr("inputmode","decimal").attr("pattern","\d*");},
                                                 maxlength:"5"
                                                 
                                              }
                                       	 },
                                         {name:"LOWS_SBID_LMT_AM",      index:"LOWS_SBID_LMT_AM",       width:90,  align:'right', editable:$("#ch_lows_sbid_am").is(":checked")  ,formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}
	                                         , editoptions:{
	                                             dataInit:function(e){$(e).addClass('grid_number integer').attr("inputmode","decimal").attr("pattern","\d*");},
	                                             maxlength:"10"
	                                             
	                                          }
                                         },
                                         
                                        ];        
        
        } else if($("#ch_modl_no").is(":checked")) {
                $("#ch_modl_no").val("1");
                /*                                    1            2        3         4         5       6         7         8           9                10      11     12         13 */
                var searchResultColNames = ["", "경매번호", "거치대번호(*)", "경매대상", "대표코드", "귀표번호", "출하주", "경매일자", "원표번호", "원장일련번호", "최초최저낙찰한도금액", "비고", "중량", "예정가"];        
                var searchResultColModel = [                         
                                             {name:"_STATUS_",              index:"_STATUS_",               width:10,  align:'center'},
                                             {name:"AUC_PRG_SQ",            index:"AUC_PRG_SQ",             width:50,  align:'center',formatter: "integer", sorttype: "number"},
                                             {name:"MODL_NO",               index:"MODL_NO",                width:50,  align:'center', editable:true},
                                             {name:"AUC_OBJ_DSC",           index:"AUC_OBJ_DSC",            width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},                                     
                                             {name:"SRA_INDV_AMNNO1",       index:"SRA_INDV_AMNNO1",        width:80,  align:'center'},
                                             {name:"SRA_INDV_AMNNO",        index:"SRA_INDV_AMNNO",         width:150, align:'center'},                                     
                                             {name:"FTSNM",                 index:"FTSNM",                  width:80,  align:'center'},
                                             {name:"AUC_DT",                index:"AUC_DT",                 width:10,  align:'center', hidden:true},
                                             {name:"OSLP_NO",               index:"OSLP_NO",                width:10,  align:'center', hidden:true},
                                             {name:"LED_SQNO",              index:"LED_SQNO",               width:10,  align:'center', hidden:true},
                                             {name:"FIR_LOWS_SBID_LMT_AM",  index:"FIR_LOWS_SBID_LMT_AM",   width:10,  align:'center', hidden:true},
                                             {name:"RMK_CNTN",              index:"RMK_CNTN",               width:200, align:'left'},
                                             {name:"COW_SOG_WT",            index:"COW_SOG_WT",             width:70,  align:'right'
                                                 , editoptions:{
                                                     dataInit:function(e){$(e).addClass('grid_number integer').attr("inputmode","decimal").attr("pattern","\d*");},
                                                     maxlength:"5"
                                                     
                                                  }
                                           	 },
                                             {name:"LOWS_SBID_LMT_AM",      index:"LOWS_SBID_LMT_AM",       width:90,  align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}
	                                             , editoptions:{
	                                                 dataInit:function(e){$(e).addClass('grid_number integer').attr("inputmode","decimal").attr("pattern","\d*");},
	                                                 maxlength:"10"
	                                                 
	                                              }
                                             },
                                             
                                            ];        
            
        } else {
            $("#ch_rmk_cntn").val("0");
            $("#ch_modl_no").val("0");
            /*                                    1          2        3         4         5       6         7         8           9                10        11        12            13 */
            var searchResultColNames = ["", "경매번호", "거치대번호", "경매대상", "대표코드", "귀표번호", "출하주", "경매일자", "원표번호", "원장일련번호", "최초최저낙찰한도금액", "비고(*)", "중량(*)", "예정가(*)"];        
            var searchResultColModel = [                         
                                         {name:"_STATUS_",              index:"_STATUS_",               width:10,  align:'center'},                       
                                         {name:"AUC_PRG_SQ",            index:"AUC_PRG_SQ",             width:50,  align:'center',formatter: "integer", sorttype: "number"},
                                         {name:"MODL_NO",               index:"MODL_NO",                width:50,  align:'center'},
                                         {name:"AUC_OBJ_DSC",           index:"AUC_OBJ_DSC",            width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},                                     
                                         {name:"SRA_INDV_AMNNO1",       index:"SRA_INDV_AMNNO1",        width:80,  align:'center'},
                                         {name:"SRA_INDV_AMNNO",        index:"SRA_INDV_AMNNO",         width:150, align:'center'},                                     
                                         {name:"FTSNM",                 index:"FTSNM",                  width:80,  align:'center'},
                                         {name:"AUC_DT",                index:"AUC_DT",                 width:10,  align:'center', hidden:true},
                                         {name:"OSLP_NO",               index:"OSLP_NO",                width:10,  align:'center', hidden:true},
                                         {name:"LED_SQNO",              index:"LED_SQNO",               width:10,  align:'center', hidden:true},
                                         {name:"FIR_LOWS_SBID_LMT_AM",  index:"FIR_LOWS_SBID_LMT_AM",   width:10,  align:'center', hidden:true},
                                         {name:"RMK_CNTN",              index:"RMK_CNTN",               width:200, align:'left',  editable:true},
                                         {name:"COW_SOG_WT",            index:"COW_SOG_WT",             width:70,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                             editoptions:{
                                                 dataInit:function(e){$(e).addClass('grid_number integer').attr("inputmode","decimal").attr("pattern","\d*");console.log(e);},
                                                 maxlength:"5"
                                                 
                                              }
                                         },
                                        {name:"LOWS_SBID_LMT_AM",        index:"LOWS_SBID_LMT_AM",      width:90,  align:'right', editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                             editoptions:{
                                                 dataInit:function(e){$(e).addClass('grid_number integer').attr("inputmode","decimal").attr("pattern","\d*");},
                                                 maxlength:"10"
                                                 
                                              }
                                         }                                     
                                         
                                        ];  
        }
        $("#mainGrid").jqGrid("GridUnload");
        
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            cellEdit:    true,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 25,
            cellsubmit:  "clientArray",
            afterEditCell: function(rowid, cellname, value, iRow, iCol) {
                
                $("#"+rowid+"_"+cellname).on('blur',function(e){
                    $("#mainGrid").jqGrid("saveCell", iRow, iCol);
                    
                    if($("#mainGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                        return;
                    } else {
                        if($(this).val() != value){
                            $("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                        }
                    }
                }).on('keydown',function(e){
                    var code = e.keyCode || e.which;
                    if(code == 13){
                        if(cellname == 'COW_SOG_WT' || cellname == 'LOWS_SBID_LMT_AM' || cellname == 'RMK_CNTN' || cellname == 'MODL_NO') {
                            e.preventDefault();
                            
                            $("#mainGrid").jqGrid("saveCell", iRow, iCol);
                            
                            if($("#mainGrid").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                                return;
                            } else {
                                if($(this).val() != value){
                                    $("#mainGrid").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                                }
                            }
                            var reccnt = $("#mainGrid").getGridParam("reccount");
                            if(reccnt > iRow){
                                setTimeout("$('#mainGrid').editCell(" + (iRow + 1) + "," + iCol + ", true);", 100);
                            }
                        }
                    }
                });
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        if(isMobile){
            $("#mainGrid").jqGrid("hideCol", ["AUC_OBJ_DSC","SRA_INDV_AMNNO","RMK_CNTN"]);
            //$("#mainGrid").jqGrid("setColWidth", "AUC_PRG_SQ",60, false);
            //$("#mainGrid").jqGrid("setColWidth", "SRA_INDV_AMNNO1",60, false);
            //$("#mainGrid").jqGrid("setColWidth", "FTSNM",100, false);
            //$("#mainGrid").jqGrid("setColWidth", "COW_SOG_WT",70, false);
            //$("#mainGrid").jqGrid("setColWidth", "LOWS_SBID_LMT_AM",70, false);
            $('.ui-jqgrid .ui-jqgrid-hbox').attr("style","padding-right:0px !important");
            $(".ui-jqgrid tr.jqgrow td").css("height","30px");
            
        }
        $("#mainGrid").jqGrid("setLabel", "rn","No");
    }
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    //**************************************
    //function  : fn_CallSraFhsSrchPopup(출하주 팝업 호출) 
    //paramater : N/A 
    // result   : N/A
    //**************************************
    function fn_CallSraFhsSrchPopup(p_param) {
        var data = new Object();
        
        data['ftsnm'] = $("#ftsnm").val();
        
        fn_CallFtsnmPopup(data,p_param,function(result) {
            if(result){
                $("#fhs_id_no").val(result.FHS_ID_NO);
                $("#ftsnm").val(result.FTSNM);
            } else {
                $("#fhs_id_no").val("");
                $("#ftsnm").val("");
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
            <div class="tab_box clearfix mobile_search">
                <ul class="tab_list">
                    <li><p class="dot_allow">조회조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table mobile_search">
                <div class="blueTable rsp_v">
                    <form id="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="150">
                            <col width="100">
                            <col width="150">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><span class="tb_dot">경매대상</span></th>
                                <td>
                                    <select class="popup" id="cb_auc_obj_dsc"></select>
                                </td>
                                <th scope="row"><span class="tb_dot">경매일자</span></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_dt" maxlength="10"></div>                                        
                                    </div>
                                </td>
                                <th scope="row"><span class="tb_dot">출하주</span></th>
                                <td>
                                    <input disabled="disabled" type="text" id="fhs_id_no" style="width:150px;">
                                    <input type="text" id="ftsnm" style="width:150px;" maxlength="50">
                                    <button id="pb_search_ftsnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                    
                                    <label for="ch_rmk_cntn"><span id="ch_rmk_cntn_title">&nbsp;&nbsp;&nbsp;비고만저장</span></label>
                                    <input type="checkbox" class="chk_save_type" id="ch_rmk_cntn" name="ch_rmk_cntn" value="0">                                    
                                    <label for="ch_cow_wt"><span id="ch_cow_wt_title">&nbsp;&nbsp;&nbsp;중량만저장</span></label>
                                    <input type="checkbox" class="chk_save_type" id="ch_cow_wt" name="ch_cow_wt" value="W">
                                    <label for="ch_lows_sbid_am"><span id="ch_lows_sbid_am_title">&nbsp;&nbsp;&nbsp;예정가만저장</span></label>
                                    <input type="checkbox" class="chk_save_type" id="ch_lows_sbid_am" name="ch_lows_sbid_am" value="L">
                                    <label for="ch_modl_no"><span id="ch_rmk_cntn_title">&nbsp;&nbsp;&nbsp;거치대변경</span></label>
                                    <input type="checkbox" class="chk_save_type" id="ch_modl_no" name="ch_modl_no" value="0">
                                    
                                    <input type="hidden" id="calf_auc_atdr_unt_am">
                                    <input type="hidden" id="nbfct_auc_atdr_unt_am">
                                    <input type="hidden" id="ppgcow_auc_atdr_unt_am">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            
            <div class="tab_box clearfix mobile_search">
                <ul class="tab_list">
                    <li><p style="float: left;" class="dot_allow">예정가 일괄차감</p>
                    <p style="padding-top: 5px;padding-left: 13px;font-size: 14px;float: left;">*예정가에서 입력한 금액만큼 일괄로 차감합니다.</p>                    	
                    </li>
                </ul>
            </div>
            <div class="sec_table mobile_search">
                <div class="blueTable rsp_v">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="150">
                            <col width="100">
                            <col width="150">
                            <col width="100">
                            <col width="150">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
								<th scope="row"><span class="tb_dot">경매번호</span></th>
								<td colspan="3">
									<div class="cellBox">
										<div class="cell">
											<input type="text" id="st_auc_no" class="integer">
										</div>
										<div class="cell ta_c">~</div>
										<div class="cell">
											<input type="text" id="ed_auc_no" class="integer">
										</div>
									</div>
								</td>
                                <th scope="row"><span class="tb_dot">차감금액</span></th>
                                <td>
                                	<input type="text" id="minus_am" class="integer">
                                </td>
                                <td>
                                	<button class="tb_btn" id="btn_allLowsSbidLmtAmMinus">일괄차감</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
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