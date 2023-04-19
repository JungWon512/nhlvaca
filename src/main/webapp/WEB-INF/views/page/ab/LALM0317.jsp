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
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
var mv_cut_am = 0;
var mv_sqno_prc_dsc = "";

    $(document).ready(function(){
    	fn_CreateGrid(); 
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true); 
        fn_setCodeBox("sel_sts_dsc", "SEL_STS_DSC", 1, true, '전체');
        fn_Init();
        
      	/******************************
         * 예정가 낮추기
         ******************************/
        $("#pb_BatPrice").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            var tmpObject = $.grep($("#grd_MhSogCow").jqGrid('getRowData'), function(obj){
                return obj.SEL_STS_DSC != "22";
            });
            if(tmpObject.length == 0){
            	MessagePopup('OK','예정가를 낮출 건이 없습니다.');
                return;
            }
            
            if($("#sbt_am").val() == 0) {
            	MessagePopup('YESNO',"예정가를 최초 예정가로 변경합니다. 변경하시겠습니까?",function(res){
                    if(res){
                        var result        = null;
                                             
                        var insDataObj = new Object();     
                        insDataObj['frm'] = setFrmToData('frm_input'); 
                        insDataObj['list'] = tmpObject;
                                
                        result = sendAjax(insDataObj, "/LALM0317_updFirstBatPrice", "POST");
                        
                        if(result.status == RETURN_SUCCESS){
                            MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                                fn_Search();
                            });
                        }else{      
                            result = setDecrypt(results);
                        } 
                           
                    }else{
                        MessagePopup('OK','취소되었습니다.');
                    }
                });
            } else if(parseInt($("#sbt_am").val()) > 0) {
            	MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
                    if(res){
                        var result        = null;
                                             
                        var insDataObj = new Object();
                        
                        insDataObj['frm'] = setFrmToData('frm_input'); 
                        insDataObj['list'] = tmpObject;
                                
                        result = sendAjax(insDataObj, "/LALM0317_updBatPrice", "POST");
                        
                        if(result.status == RETURN_SUCCESS){
                            MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                                fn_Search();
                            });
                        }else{      
                            result = setDecrypt(results);
                        } 
                           
                    }else{
                        MessagePopup('OK','취소되었습니다.');
                    }
                });
            }
            
        });
        
        /******************************
         * 중도매인검색 팝업
         ******************************/
        $("#sra_mwmnnm").keypress(function(e){        	
            if(e.keyCode == 13){
            	if(fn_isNull($("#sra_mwmnnm").val())){
            		MessagePopup('OK','응찰자 명을 입력하세요.');
                }else {
                	var data = new Object();
					data['auc_dt']           = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
					data['auc_obj_dsc']      = $("#auc_obj_dsc").val();
					data['sra_mwmnnm']       = $("#sra_mwmnnm").val();
					fn_CallMwmnnmNoPopup(data,true,function(result){
						if(result){
						     $("#trmn_amnno").val(result.TRMN_AMNNO);
						     $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
						     $("#sra_mwmnnm").val(result.SRA_MWMNNM);	                             
						}
					}); 
                }
             }else {
            	 $("#v_trmn_amnno").val('');
             }
        }); 
        
        $("#pb_searchMwmn").on('click',function(e){
            e.preventDefault();
            this.blur();
         	    var data = new Object();          	    
               data['auc_dt']           = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
               data['auc_obj_dsc']      = $("#auc_obj_dsc").val();                  
        	    fn_CallMwmnnmNoPopup(data,false,function(result){
	            	if(result){
	                    $("#trmn_amnno").val(result.TRMN_AMNNO);
	                    $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
	                    $("#sra_mwmnnm").val(result.SRA_MWMNNM);
	            	}
	            });
        });        
        
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
        
        //폼 초기화
        fn_InitFrm('frm_Search');
        fn_InitFrm('frm_input');
        
        $( "#auc_obj_dsc" ).val($( "#auc_obj_dsc option:first").val());
        $( "#auc_dt" ).datepicker().datepicker("setDate", fn_getToday());
        $('#am_rto_dsc').val('1');
        fn_setChgRadioAmRtoDsc('1');
        fn_setRadioChecked('am_rto_dsc');
        $( "#auc_obj_dsc" ).focus();
        $( "#am_rto_dsc_radio_2_text" ).hide();
        $( "#sbt_pmr_text" ).hide();
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
        //정합성체크
        if(fn_isNull($( "#auc_obj_dsc" ).val()) == true) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#auc_dt" ).val()) == true){
        	MessagePopup('OK','경매일자를 선택하세요.',function(){
        		$( "#auc_dt" ).focus();
            });
            return;
        }
        
        if(fn_isDate($( "#auc_dt" ).val()) == false){
        	MessagePopup('OK','경매일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#auc_dt" ).focus();
            });
            return;
        }
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
        mv_cut_am = 0;
        mv_sqno_prc_dsc = "";
        
        var resultAucQcnList;
        var resultsAucQcnList = sendAjaxFrm("frm_Search", "/LALM0314_selAucQcnList", "POST");
        
        if(resultsAucQcnList.status != RETURN_SUCCESS) {
            showErrorMessage(resultsAucQcnList);
            return;
        } else {      
        	resultAucQcnList = setDecrypt(resultsAucQcnList);
            if(resultAucQcnList[0]["DDL_YN"] == "1") {
            	MessagePopup('OK','마감된 내역 입니다.');
                return;
            } else {
            	mv_cut_am = resultAucQcnList[0]["CUT_AM"];
            	mv_sqno_prc_dsc = resultAucQcnList[0]["SGNO_PRC_DSC"];
            	
            	var results = sendAjaxFrm("frm_Search", "/LALM0317_selList", "POST");        
                var result;
                
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{      
                    result = setDecrypt(results);
                    fn_CreateGrid(result);
                }
            }
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
         
    	 var tmpObject = $.grep($("#grd_MhSogCow").jqGrid('getRowData'), function(obj){
             return obj._STATUS_ == "*" ;
         });
         if(tmpObject.length == 0){
             MessagePopup('OK','저장 건이 없습니다.');
             return;
         }
         
         var chkVaild = 0;
         tmpObject.forEach((e,i)=>{
        	 if(e.HDN_SEL_STS_DSC == '22' && e.CHG_RMK_CNTN == ''){
            	 MessagePopup('OK','기낙찰된건의 변경사유를 입력해주시기 바랍니다.<br/>[경매번호 : '+e.AUC_PRG_SQ+']');
        		 chkVaild++;
            	 return;
        	 }
         });
         if(chkVaild){
        	 return;
         }
         MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
             if(res){
                 var result        = null;
                                      
                 var insDataObj = new Object();     
                 insDataObj['list'] = tmpObject;
                         
                 result = sendAjax(insDataObj, "/LALM0317_updConti", "POST");
                 
                 if(result.status == RETURN_SUCCESS){
                     MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                         fn_Search();
                     });
                 }else{      
                     result = setDecrypt(results);
                 } 
                    
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });
         
    }
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    //경매 정보 그리드
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["","H사업장코드","H경매일자","H원표번호","H판매상태구분","H거래인","H참여자번호","H혈통금액","H출하수수료수기적용여부","H출하수수료수기등록","H판매수수료수기적용여부","H판매수수료수기등록"
						            ,"H12개월이상여부","H12개월이상수수료","H번식우수수료구분코드","H사료미사용여부","H친자검사여부","H친자검사결과","H출하자조합원여부","H중도매인조합원여부"
						            ,"H임신감정여부","H임신여부","H괴사감정여부","H괴사여부","H운송비지급여부","H제각여부","H축산생산자명"
						        	,"경매번호", "경매대상구분", "출하주", "접수일", "수송자", "귀표번호","성별", "최소 예정가", "예정가", "예정가<br>변경횟수", "중량", "경매참가번호", "", "낙찰단가", "낙찰금액","진행상태","변경사유", "응찰하안가ex", "마감차수", "구분", "낮출금액", ""];        
        var searchResultColModel = [
            						{name:"_STATUS_",               index:"_STATUS_"              , width:15,  align:'center'},
            						
            						{name:"NA_BZPLC",            index:"NA_BZPLC",            width:100, align:'center', hidden:true},
       	                         	{name:"OSLP_NO",             index:"OSLP_NO",             width:100, align:'center', hidden:true},
                                    {name:"AUC_DT",              index:"AUC_DT",              width:100, align:'center', hidden:true},
                                    {name:"HDN_SEL_STS_DSC",     index:"HDN_SEL_STS_DSC",         width:100, align:'center', hidden:true},
                                    {name:"TRMN_AMNNO",          index:"TRMN_AMNNO",          width:100, align:'center', hidden:true},
                                    {name:"LVST_AUC_PTC_MN_NO",  index:"LVST_AUC_PTC_MN_NO",  width:100, align:'center', hidden:true},
                                    {name:"BLOOD_AM",            index:"BLOOD_AM",            width:100, align:'center', hidden:true},
                                    {name:"FEE_CHK_YN",          index:"FEE_CHK_YN",          width:100, align:'center', hidden:true},
                                    {name:"FEE_CHK_YN_FEE",      index:"FEE_CHK_YN_FEE",      width:100, align:'center', hidden:true},
                                    {name:"SELFEE_CHK_YN",       index:"SELFEE_CHK_YN",       width:100, align:'center', hidden:true},
                                    {name:"SELFEE_CHK_YN_FEE",   index:"SELFEE_CHK_YN_FEE",   width:100, align:'center', hidden:true},
                                    {name:"MT12_OVR_YN",         index:"MT12_OVR_YN",         width:100, align:'center', hidden:true},
                                    {name:"MT12_OVR_FEE",        index:"MT12_OVR_FEE",        width:100, align:'center', hidden:true},
                                    {name:"PPGCOW_FEE_DSC",      index:"PPGCOW_FEE_DSC",      width:100, align:'center', hidden:true},
                                    {name:"SRA_FED_SPY_YN",      index:"SRA_FED_SPY_YN",      width:100, align:'center', hidden:true},
                                    {name:"DNA_YN_CHK",          index:"DNA_YN_CHK",          width:100, align:'center', hidden:true},
                                    {name:"DNA_YN",              index:"DNA_YN",              width:100, align:'center', hidden:true},
                                    {name:"IO_SOGMN_MACO_YN",    index:"IO_SOGMN_MACO_YN",    width:100, align:'center', hidden:true},
                                    {name:"IO_MWMN_MACO_YN",     index:"IO_MWMN_MACO_YN",     width:100, align:'center', hidden:true},
                                    {name:"PRNY_JUG_YN",         index:"PRNY_JUG_YN",         width:100, align:'center', hidden:true},
                                    {name:"PRNY_YN",             index:"PRNY_YN",             width:100, align:'center', hidden:true},
                                    {name:"NCSS_JUG_YN",         index:"NCSS_JUG_YN",         width:100, align:'center', hidden:true},
                                    {name:"NCSS_YN",             index:"NCSS_YN",             width:100, align:'center', hidden:true},
                                    {name:"TRPCS_PY_YN",         index:"TRPCS_PY_YN",         width:100, align:'center', hidden:true},
                                    {name:"RMHN_YN",             index:"RMHN_YN",             width:100, align:'center', hidden:true},
                                    {name:"SRA_PDMNM",           index:"SRA_PDMNM",           width:100, align:'center', hidden:true},
            						
						            {name:"AUC_PRG_SQ"            , index:"AUC_PRG_SQ"            , width:80,  align:'center'},
						            {name:"AUC_OBJ_DSC"           , index:"AUC_OBJ_DSC"           , width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						            {name:"FTSNM"                 , index:"FTSNM"                 , width:100, align:'center'},
						            {name:"RC_DT"                 , index:"RC_DT"                 , width:100, align:'center', formatter:'gridDateFormat'},
						            {name:"VHC_DRV_CAFFNM"        , index:"VHC_DRV_CAFFNM"        , width:100, align:'center'},
						            {name:"SRA_INDV_AMNNO"        , index:"SRA_INDV_AMNNO"        , width:150, align:'center'},						            
						            {name:"INDV_SEX_C"			  , index:"INDV_SEX_C"			  , width:40 , sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						            {name:"FIR_LOWS_SBID_LMT_AM"  , index:"FIR_LOWS_SBID_LMT_AM"  , width:100, align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						            {name:"LOWS_SBID_LMT_AM"      , index:"LOWS_SBID_LMT_AM"      , width:100, align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						            {name:"LWPR_CHG_NT"           , index:"LWPR_CHG_NT"           , width:100, align:'right'},
						            {name:"COW_SOG_WT"  		  , index:"COW_SOG_WT"            ,	width:70,  align:'right' , editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                   	 editoptions:{
                                            dataInit:function(e){$(e).addClass('grid_number');},
                                            maxlength:"5"
                                            
                                         }
                                    },
						            {name:"SRA_MWMNNM"            , index:"SRA_MWMNNM"            , width:100, align:'center', editable:true},
						            {name:"MWMNNMPBTN"            , index:"MWMNNMPBTN"            , width:30,  align:'center', sortable: false, formatter :gridSchboxFormat },
						            {name:"SRA_SBID_UPR"          , index:"SRA_SBID_UPR"          , width:100, align:'right' , editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
	                                   	 editoptions:{
	                                            dataInit:function(e){$(e).addClass('grid_number');},
	                                            maxlength:"8"
	                                            
	                                     }
	                                },
						            {name:"SRA_SBID_AM"           , index:"SRA_SBID_AM"           , width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:','}},
						            {name:"SEL_STS_DSC"           , index:"SEL_STS_DSC"           , width:100, align:'center', editable:true, edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}},
						            {name:"CHG_RMK_CNTN"          , index:"CHG_RMK_CNTN"          , width:100, align:'center', editable:true,
										editoptions:{
											maxlength:"30"                                         
										}
						            },

						            {name:"LOWS_SBID_LMT_AM_EX"   , index:"LOWS_SBID_LMT_AM_EX"   , width:100, align:'center', hidden:true},
						            {name:"DDL_QCN"               , index:"DDL_QCN"               , width:100, align:'center', hidden:true},
						            {name:"CHG_GBN"               , index:"CHG_GBN"               , width:100, align:'center', editable:true, edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AM_RTO_DSC", 1)}},
						            {name:"CHG_LOWS_SBID_LMT_AM"  , index:"CHG_LOWS_SBID_LMT_AM"  ,	width:70,  align:'right' , editable:true, formatter:'integer', formatoptions:{thousandsSeparator:','},
                                    	 editoptions:{
                                             dataInit:function(e){$(e).addClass('grid_number');},
                                             maxlength:"5"
                                             
                                          }
                                     },
						            {name:"SBID_LMT_AMBTN"        , index:"SBID_LMT_AMBTN"        , width:130, align:'center', sortable: false, formatter :gridChgAmboxFormat },
                                    ];
            
        $("#grd_MhSogCow").jqGrid("GridUnload");
                
        $("#grd_MhSogCow").jqGrid({
            datatype:    "local",
            data:        data,
            height:      480,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            cellEdit:    true,
            cellsubmit:  "clientArray",
			afterEditCell: function(rowid, cellname, value, iRow, iCol) {
               	$("#"+rowid+"_"+cellname).on('blur',function(e){
					$("#grd_MhSogCow").jqGrid("saveCell", iRow, iCol);
					
					if($("#grd_MhSogCow").jqGrid('getCell', rowid, '_STATUS_') == '+') {
						return;
					} else {
						if($(this).val() != value){
							$("#grd_MhSogCow").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);	
						}
					}
               	}).on('keydown',function(e) {
               		var code = e.keyCode || e.which;
                       if(code == 13) {
                    	   e.preventDefault();
                    	   
                    	   if(cellname == 'SRA_MWMNNM') {
                    		   fn_popSearch(rowid, cellname,true);
                    		   
                    	   } else if(cellname == 'COW_SOG_WT' || cellname == 'SRA_SBID_UPR'|| cellname == 'CHG_LOWS_SBID_LMT_AM') {
                    		   $("#grd_MhSogCow").jqGrid("saveCell", iRow, iCol);
                    		   
                    		   if($("#grd_MhSogCow").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                    			   return;
                    		   } else {
                    			   if($(this).val() != value){
                    				   $("#grd_MhSogCow").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                    			   }
                               }
                    		   var reccnt = $("#grd_MhSogCow").getGridParam("reccount");
                    		   if(reccnt > iRow){
                    			   setTimeout("$('#grd_MhSogCow').editCell(" + (iRow + 1) + "," + iCol + ", true);", 100);
                    		   }
                    		   
                    	  } else {
                    		   $("#grd_MhSogCow").jqGrid("saveCell", iRow, iCol);
                               
                               if($("#grd_MhSogCow").jqGrid('getCell', rowid, '_STATUS_') == '+') {
                                   return;
                               } else {
                            	   if($(this).val() != value){
                            		   $("#grd_MhSogCow").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
                                   }
                               }
                       	   }
                       }
                });
            },
            afterSaveCell: function(rowid, cellname, value, iRow, iCol) {
            	// 그리드 중량, 낙찰금액 변경 이벤트 
         	    if(cellname == 'COW_SOG_WT' || cellname == 'SRA_SBID_UPR') {
         		   var v_sra_sbid_am = 0;
         		   
         		   // 송아지
         		   if($("#grd_MhSogCow").jqGrid("getCell", iRow, 'AUC_OBJ_DSC') == "1") {
         			   v_sra_sbid_am = parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'SRA_SBID_UPR')) * parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
         			   $("#grd_MhSogCow").jqGrid("setCell", iRow, 'SRA_SBID_AM', v_sra_sbid_am);
         		   
         		   // 비육우   
         		   } else if($("#grd_MhSogCow").jqGrid("getCell", iRow, 'AUC_OBJ_DSC') == "2") {
         			   // kg별
         			   if(parent.envList[0]["NBFCT_AUC_UPR_DSC"] == "1") {
         				   v_sra_sbid_am = parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'SRA_SBID_UPR')) * parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'COW_SOG_WT')) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
             			   
             			   if(mv_sqno_prc_dsc == "1") {
             				   v_sra_sbid_am = Math.floor(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
             			   } else if(mv_sqno_prc_dsc == "2") {
             				   v_sra_sbid_am = Math.ceil(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
             			   } else {
             				   v_sra_sbid_am = Math.round(parseInt(v_sra_sbid_am) / parseInt(mv_cut_am)) * parseInt(mv_cut_am);
             			   }
             			   
             			   $("#grd_MhSogCow").jqGrid("setCell", iRow, 'SRA_SBID_AM', v_sra_sbid_am);
         			   } else {
         				   v_sra_sbid_am = v_sra_sbid_am = parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'SRA_SBID_UPR')) * parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
         				   $("#grd_MhSogCow").jqGrid("setCell", iRow, 'SRA_SBID_AM', v_sra_sbid_am);
         			   }
         		   // 번식우
         		   } else if($("#grd_MhSogCow").jqGrid("getCell", iRow, 'AUC_OBJ_DSC') == "3") {
         			   v_sra_sbid_am = v_sra_sbid_am = parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'SRA_SBID_UPR')) * parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);
     				   $("#grd_MhSogCow").jqGrid("setCell", iRow, 'SRA_SBID_AM', v_sra_sbid_am);
         		   }
         	    } else if(cellname == 'SRA_SBID_UPR') {
            		if(parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'SRA_SBID_UPR')) > 0 
            		&& parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'SRA_SBID_UPR')) < parseInt($("#grd_MhSogCow").jqGrid("getCell", iRow, 'LOWS_SBID_LMT_AM_EX'))) {
            			MessagePopup('OK','낙찰가가 예정가보다 작습니다.');
            		}
            		
            	}
            	
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
        });
        //행번호
	    $("#grd_MhSogCow").jqGrid("setLabel", "rn","No");  
        
	    $("#grd_MhSogCow").jqGrid("setGroupHeaders", {
	    	useColSpanStyle:true,
		    groupHeaders:[{startColumnName:"CHG_GBN", numberOfColumns: 3, titleText: '예정가 낮출금액'}]
	    });
	    
	  	//가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
	    $("#grd_MhSogCow .jqgfirstrow td:last-child").width($("#grd_MhSogCow .jqgfirstrow td:last-child").width() - 17);
	      
    }
     
    function fn_setChgRadioAmRtoDsc(p_value){
    	if(p_value == "1"){
            $('#sbt_am').removeAttr('disabled');
            $('#sbt_pmr').attr('disabled',true);
            $('#sbt_pmr').val(0);
            $('#sbt_am').focus();
    	}else {
            $('#sbt_pmr').removeAttr('disabled');
            $('#sbt_am').attr('disabled',true);
            $('#sbt_am').val(0);
            $('#sbt_pmr').focus();
    	}
    }
        
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
	function gridSchboxFormat(val, options, rowdata) {
	    var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<input style="margin-left:1px;" type="button" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_popSearch(\'' + rowid + '\',\'' + colkey + '\',false)" value="찾기" />';
	} 

    /******************************
     * 중도매인검색 팝업
     ******************************/
    function fn_popSearch(rowid, colkey,flag){
   	    var data = new Object();      	    
        data['auc_obj_dsc']      = $("#auc_obj_dsc").val();        
        data['auc_dt']           = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');     
        data['sra_mwmnnm']       = $("#grd_MhSogCow").jqGrid("getCell", rowid, 38);
  	    fn_CallMwmnnmNoPopup(data,flag,function(result){
         	if(result){
  	            $("#grd_MhSogCow").jqGrid("setCell", rowid, 'SRA_MWMNNM', result.SRA_MWMNNM);  
         		$("#grd_MhSogCow").jqGrid("setCell", rowid, 'TRMN_AMNNO', result.TRMN_AMNNO);
  	            $("#grd_MhSogCow").jqGrid("setCell", rowid, 'LVST_AUC_PTC_MN_NO', result.LVST_AUC_PTC_MN_NO); 

          		$("#grd_MhSogCow").jqGrid('setCell', rowid, '_STATUS_', '*', GRID_MOD_BACKGROUND_COLOR);
         	}
         });
	}     
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
	function gridChgAmboxFormat(val, options, rowdata) {
	    var gid = options.gid;
	    var rowid = options.rowId;
	    var colkey = options.colModel.name;
	    return '<input style="margin-left:1px;" type="button" id="' + gid + '_' + rowid + '_' + colkey + '" ' + 'onclick="fn_chgAm(\'' + gid + '\',\'' + rowid + '\',\'' + colkey + '\')" value="예정가낮추기" />';
	} 
    
    /******************************
     * 예정가 낮추기
     ******************************/
    function fn_chgAm(gid, rowid, colkey){
   	 	
    	var rowData = $('#grd_MhSogCow').jqGrid('getRowData', rowid);        
   	 	if(rowData.CHG_LOWS_SBID_LMT_AM == "0") {
	   	 	MessagePopup('YESNO',"예정가를 최초 예정가로 변경합니다. 변경하시겠습니까?",function(res){
				if(res){
					if(rowData.SEL_STS_DSC == "22") {
						MessagePopup('OK','진행상태가 낙찰입니다. 낙찰상태에서는 예정가 낮추기가 불가능 합니다.');
		                return;
					}
					// 최소예정가
					var v_lows_sbid_lmt_am = rowData.FIR_LOWS_SBID_LMT_AM;
					// 예정가
					rowData.LOWS_SBID_LMT_AM = v_lows_sbid_lmt_am;
					
					// 예정가 변경횟수
					if(!fn_isNull(rowData.LWPR_CHG_NT)) {
						rowData.LWPR_CHG_NT = parseInt(rowData.LWPR_CHG_NT) + 1;
					} else {
						rowData.LWPR_CHG_NT = 1;
					}
					
					// 낮출금액
					rowData.CHG_LOWS_SBID_LMT_AM = 0;
					
					var lows_sbid_lmt_am_ex = 0;
					
            		if($("#grd_MhSogCow").jqGrid("getCell", rowid, 'AUC_OBJ_DSC') == "1") {
            			lows_sbid_lmt_am_ex = parseInt($("#grd_MhSogCow").jqGrid("getCell", rowid, 'LOWS_SBID_LMT_AM')) / parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
            		} else if($("#grd_MhSogCow").jqGrid("getCell", rowid, 'AUC_OBJ_DSC') == "2") {
            			lows_sbid_lmt_am_ex = parseInt($("#grd_MhSogCow").jqGrid("getCell", rowid, 'LOWS_SBID_LMT_AM')) / parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
            		} else if($("#grd_MhSogCow").jqGrid("getCell", rowid, 'AUC_OBJ_DSC') == "3") {
            			lows_sbid_lmt_am_ex = parseInt($("#grd_MhSogCow").jqGrid("getCell", rowid, 'LOWS_SBID_LMT_AM')) / parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);
            		}
            		
            		rowData.LOWS_SBID_LMT_AM_EX = lows_sbid_lmt_am_ex;
            		
					$('#grd_MhSogCow').jqGrid('setRowData', rowid, rowData);
					$("#grd_MhSogCow").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
					
	    		} else {
	    			MessagePopup('OK','취소되었습니다.');
	    			return;
	    		}
			});
   	 	} else if(parseInt(rowData.CHG_LOWS_SBID_LMT_AM) > 0) {
   	 		if(parseInt(rowData.CHG_LOWS_SBID_LMT_AM) > 99990000) {
	   	 		MessagePopup('OK','예정가는 0 - 99990000 사이의 값을 입력하십시오.');
	            return;
   	 		}
	   	 	if(rowData.SEL_STS_DSC == "22") {
				MessagePopup('OK','진행상태가 낙찰입니다. 낙찰상태에서는 예정가 낮추기가 불가능 합니다.');
	            return;
			}
	   		// 최소예정가
			var v_lows_sbid_lmt_am = rowData.FIR_LOWS_SBID_LMT_AM;
	   		
	   		if(rowData.CHG_GBN == "1") {
	   			v_lows_sbid_lmt_am = parseInt(rowData.LOWS_SBID_LMT_AM) - parseInt(rowData.CHG_LOWS_SBID_LMT_AM);
	   		} else {
	   			v_lows_sbid_lmt_am = parseInt(rowData.FIR_LOWS_SBID_LMT_AM) - (parseInt(rowData.FIR_LOWS_SBID_LMT_AM) * parseInt(rowData.CHG_LOWS_SBID_LMT_AM) / 100);
	   		}
	   		
			// 예정가
			rowData.LOWS_SBID_LMT_AM = v_lows_sbid_lmt_am;
			// 예정가 변경횟수
			if(!fn_isNull(rowData.LWPR_CHG_NT)) {
				rowData.LWPR_CHG_NT = parseInt(rowData.LWPR_CHG_NT) + 1;
			} else {
				rowData.LWPR_CHG_NT = 1;
			}
			// 낮출금액
			rowData.CHG_LOWS_SBID_LMT_AM = 0;
			
			var lows_sbid_lmt_am_ex = 0;
			
    		if($("#grd_MhSogCow").jqGrid("getCell", rowid, 'AUC_OBJ_DSC') == "1") {
    			lows_sbid_lmt_am_ex = parseInt($("#grd_MhSogCow").jqGrid("getCell", rowid, 'LOWS_SBID_LMT_AM')) / parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
    		} else if($("#grd_MhSogCow").jqGrid("getCell", rowid, 'AUC_OBJ_DSC') == "2") {
    			lows_sbid_lmt_am_ex = parseInt($("#grd_MhSogCow").jqGrid("getCell", rowid, 'LOWS_SBID_LMT_AM')) / parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
    		} else if($("#grd_MhSogCow").jqGrid("getCell", rowid, 'AUC_OBJ_DSC') == "3") {
    			lows_sbid_lmt_am_ex = parseInt($("#grd_MhSogCow").jqGrid("getCell", rowid, 'LOWS_SBID_LMT_AM')) / parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);
    		}
    		
    		rowData.LOWS_SBID_LMT_AM_EX = lows_sbid_lmt_am_ex;
    		
			$('#grd_MhSogCow').jqGrid('setRowData', rowid, rowData);
			$("#grd_MhSogCow").jqGrid('setCell', rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
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
                                <th scope="row">경매대상구분<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="auc_obj_dsc" class="popup"></select>
                                </td>
                                <th scope="row">경매일자<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_dt" maxlength="10"></div>
                                    </div>
                                </td>
                                <th scope="row">경매상태</th>
                                <td>
                                    <select id="sel_sts_dsc"></select>
                                </td>  
                                <th scope="row">경매참가번호</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:60px;">
                                             <input disabled="disabled" type="text" id="trmn_amnno">                                             
                                         </div>
                                         <div class="cell pl3" style="width:100px;">
                                             <input disabled="disabled" type="text" id="lvst_auc_ptc_mn_no">                                             
                                         </div>    
                                         <div class="cell pl3" style="width:100px;">
                                             <input enabled="enabled" type="text" id="sra_mwmnnm">                                             
                                         </div>                                                                              
                                         <div class="cell pl3">
                                             <button id="pb_searchMwmn" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>
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
                    <li><p class="dot_allow">응찰예정가 낮추기</p></li>
                </ul>
            </div>
            
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_input" name="frm_input">
                    <input type="hidden" id="am_rto_dsc"/>
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="300">
                            <col width="125">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">
                                    <input type="radio" id="am_rto_dsc_1" name="am_rto_dsc_radio" value="1" onclick="javascript:fn_setChgRadio('am_rto_dsc','1');fn_setChgRadioAmRtoDsc('1');"/> 금액
                                </th>
                                <td>
                                    <input type="text" id="sbt_am" class="number" maxlength="8">
                                </td>
                                <th scope="row" id="am_rto_dsc_radio_2_text" >
                                    <input type="radio" id="am_rto_dsc_2" name="am_rto_dsc_radio" value="2" onclick="javascript:fn_setChgRadio('am_rto_dsc','2');fn_setChgRadioAmRtoDsc('2');"/> 율
                                </th>
                                <td id="sbt_pmr_text" >
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" id="sbt_pmr" class="number" maxlength="3"></div>
                                    </div>
                                </td>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell pl2" >
                                            <button id="pb_BatPrice" class="tb_btn">예정가 낮추기</button>
                                        </div>
                                    </div>
                                </td>
                                <th style="text-align:right;" scope="row"><span>※일괄 낮추기는 보류상태에서만 가능</span></th>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul> 
                
                <div class="fl_R">   
                    <label id="msg_Sbid" style="font-size:15px;color:blue;font: message-box;">※낮추기금액 입력시 '0'을 입력하면 최소 예정가로 돌아갑니다.</label>
                </div>  
            </div>
            
            <div class="listTable mb0">
                <table id="grd_MhSogCow">
                </table>
            </div>
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>