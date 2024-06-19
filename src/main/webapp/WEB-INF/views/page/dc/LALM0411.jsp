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
    $(document).ready(function(){

        /******************************
        * 초기값 설정
        ******************************/             
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
//         fn_CreateGrid();
        
        $("#auc_dt").on('change input',function(event){
        	fn_InitFrm('frm_BasDsc');
            $("#Mwmn_cnt").html("0 건");
            $("#Mwmn_msg").html("");
            $("#AucQcn_cnt").html("0 건");
            $("#AucQcn_msg").html("");
            $("#SogCow_cnt").html("0 건");
            $("#SogCow_msg").html("");
            $("#AtdrLog_cnt").html("0 건");
            $("#AtdrLog_msg").html("");
            $("#MwmnAdj_cnt").html("0 건");
            $("#MwmnAdj_msg").html("");
            $("#MwmnEntr_cnt").html("0 건");
            $("#MwmnEntr_msg").html("");
            $("#RkonCm_cnt").html("0 건");
            $("#RkonCm_msg").html("");
            
            $("#pb_SogCowSend").attr('disabled', true);
            $("#pb_AtdrLogSend").attr('disabled', true);
        });  
        
        /******************************
        * 기존농가정보 축경통생성 전송
        ******************************/
//         $("#pb_fhsinfo").on('click',function(e){
//             e.preventDefault();
//             this.blur();
//             fn_Fhsinfo();
//         });
        
        /******************************
        * 일괄 전송
        ******************************/
        $("#pb_SendAll").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_AllSend();
        });
        
        /******************************
         * 중도매인정보 전체 전송
         ******************************/
         $("#pb_SendAllMwmn").on('click',function(e){
             e.preventDefault();
             this.blur();
             fn_AllMwmnSend();
         });
         
        /******************************
        * 중도매인정보 전송
        ******************************/
        $("#pb_MwmnSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_MwmnSend();
        });
        
        /******************************
         * 출장우내역 전송
         
         ******************************/
         $("#pb_SogCowSend").on('click',function(e){
             e.preventDefault();
             this.blur();
             fn_SogCowSend();
         });
        
        /******************************
         * 응찰내역 전송
         ******************************/
         $("#pb_AtdrLogSend").on('click',function(e){
             e.preventDefault();
             this.blur();
             fn_AtdrLogSend();
         });
        
        /******************************
        * 경매차수정보 전송
        ******************************/
        $("#pb_AucQcnSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_AucQcnSend();
        });
        
        /******************************
        * 입금내역 전송
        ******************************/
        $("#pb_MwmnAdjSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_MwmnAdjSend();
        });
                
        /******************************
        * 경매참가내역 전송
        ******************************/
        $("#pb_MwmnEntrSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_MwmnEntrSend();
        });
        
        /******************************
        * 참여산정위원 전송
        ******************************/
        $("#pb_RkonCmSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_RkonCmSend();
        });
        
        fn_Init();
         
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     function fn_Init(){
    	 
         fn_InitFrm('frm_Search');
         $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
         $("#auc_obj_dsc").val($("#auc_obj_dsc option:last").val()).prop("selected",true);
         $("#auc_obj_dsc").attr('disabled', true);
         
         fn_InitFrm('frm_BasDsc');
         $("#Mwmn_cnt").html("0 건");
         $("#Mwmn_msg").html("");
         $("#AucQcn_cnt").html("0 건");
         $("#AucQcn_msg").html("");
         $("#SogCow_cnt").html("0 건");
         $("#SogCow_msg").html("");
         $("#AtdrLog_cnt").html("0 건");
         $("#AtdrLog_msg").html("");
         $("#MwmnAdj_cnt").html("0 건");
         $("#MwmnAdj_msg").html("");
         $("#MwmnEntr_cnt").html("0 건");
         $("#MwmnEntr_msg").html("");
         $("#RkonCm_cnt").html("0 건");
         $("#RkonCm_msg").html("");
         
    	 $("#pb_SogCowSend").attr('disabled', true);
    	 $("#pb_AtdrLogSend").attr('disabled', true);
    	 
     }
     ////////////////////////////////////////////////////////////////////////////////
     //  공통버튼 클릭함수 종료
     ////////////////////////////////////////////////////////////////////////////////
     
     
    //일괄전송
    function fn_AllSend(){
    	 
    	 var mwmn_all     = fn_MwmnSend();
    	 var aucqcn_all   = fn_AucQcnSend();
    	 var sogcow_all   = fn_SogCowSend();
    	 var atdrlog_all  = fn_AtdrLogSend();
    	 var mwmnadj_all  = fn_MwmnAdjSend();
    	 var mwmnentr_all = fn_MwmnEntrSend();
    	 var rkoncm_all   = fn_RkonCmSend();
    	 
    }
     
    //중도매인정보 일괄 전송
    function fn_AllMwmnSend(){
 
    	var srchData = new Object();
        srchData["ctgrm_cd"]    = "1300";
        srchData["auc_dt"]      = "A";
        
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        var mwmn_results;
        var mwmn_result;
                
        var tot_cnt = result.totCnt;
        var fix_pos = 50;
        var st_pos = 1;
        var ed_pos = fix_pos;
        
        if(tot_cnt > 0){
            while(true){
                if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                srchData["st_pos"]  = st_pos;
                srchData["ed_pos"]  = ed_pos;
                mwmn_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                if(mwmn_results.status != RETURN_SUCCESS){
                    showErrorMessage(mwmn_results,'NOTFOUND');
                    MessagePopup('OK','전송중 오류가 발생하였습니다.');
                    return;
                }else{
                    mwmn_result = setDecrypt(mwmn_results);
                    if(mwmn_result.RZTC != '1'){
                    	MessagePopup('OK','전송중 오류가 발생하였습니다.');
                        return;
                    }
                }
                
                //종료포지션이 전체카운트보다 
                if(ed_pos == tot_cnt){
                    //중도매인이력 insert
                    srchData["st_pos"]  = 1;
                    mwmn_results = sendAjax(srchData, "/LALM0411_updMwmn", "POST");
                    if(mwmn_results.status != RETURN_SUCCESS){
                        showErrorMessage(mwmn_results);
                        return;
                    }else{
                        mwmn_result = setDecrypt(mwmn_results);
                    }
                    MessagePopup('OK','전송이 완료되었습니다.');
                    return;
                }                
                st_pos += fix_pos;
                ed_pos += fix_pos;
            }
        }else{
        	MessagePopup('OK','전송할 내역이 없습니다.');
            return;
        }
        
        return;
    }
     
    
    //중도매인정보 전송
    function fn_MwmnSend(){
    	
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
    	 
    	$("#Mwmn_msg").html("전송중 입니다.");

    	var srchData = new Object();
        srchData["ctgrm_cd"]    = "1300";
        srchData["auc_obj_dsc"] = $("#auc_obj_dsc").val();
        srchData["auc_dt"]      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
    	var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
    	var result;
    	
    	if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
    	
    	var mwmn_results;
    	var mwmn_result;
    	    	
    	var tot_cnt = result.totCnt;
    	var fix_pos = 50;
    	var st_pos = 1;
    	var ed_pos = fix_pos;
    	
    	if(tot_cnt > 0){
    		while(true){
    			if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                srchData["st_pos"]  = st_pos;
                srchData["ed_pos"]  = ed_pos;
                mwmn_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                if(mwmn_results.status != RETURN_SUCCESS){
                    showErrorMessage(mwmn_results,'NOTFOUND');
                    $("#Mwmn_msg").html("전송중 오류가 발생하였습니다.");
                    return;
                }else{
                    mwmn_result = setDecrypt(mwmn_results);
                    if(mwmn_result.RZTC != '1'){
                    	$("#Mwmn_msg").html("전송중 오류가 발생하였습니다.");
                    	return;
                    }
                }
                
                //종료포지션이 전체카운트보다 
                if(ed_pos == tot_cnt){
                	//중도매인이력 insert
                	srchData["st_pos"]  = 1;
                    mwmn_results = sendAjax(srchData, "/LALM0411_updMwmn", "POST");
                	if(mwmn_results.status != RETURN_SUCCESS){
                        showErrorMessage(mwmn_results);
                        return;
                    }else{
                        mwmn_result = setDecrypt(mwmn_results);
                    }
                	
                    $("#Mwmn_cnt").html(tot_cnt + " 건");
                    $("#Mwmn_msg").html("전송 완료하였습니다.");
                    return;
                }                
                st_pos += fix_pos;
                ed_pos += fix_pos;
    		}
    	}else{
            $("#Mwmn_msg").html("전송 할 내역이 없습니다.");
    	}
    	
    	return;
    }
    
    //경매차수정보 전송
    function fn_AucQcnSend(){
    	
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
    	
        $("#AucQcn_msg").html("전송중 입니다.");
    	
    	var srchData = new Object();
        srchData["ctgrm_cd"]  = "1900";
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"] = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        var AucQcn_results;
        var AucQcn_result;
                
        var tot_cnt = result.totCnt;
        var fix_pos = 100;
        var st_pos = 1;
        var ed_pos = fix_pos;
        
        if(tot_cnt > 0){            
            while(true){
                if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                
                srchData["st_pos"]  = st_pos;
                srchData["ed_pos"]  = ed_pos;
                
                AucQcn_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                
                if(AucQcn_results.status != RETURN_SUCCESS){
                    showErrorMessage(AucQcn_results,'NOTFOUND');
                    $("#AucQcn_msg").html("전송중 오류가 발생하였습니다.");
                    return;
                }else{
                    AucQcn_result = setDecrypt(AucQcn_results);
                    if(AucQcn_result.RZTC != '1'){
                        $("#AucQcn_msg").html("전송중 오류가 발생하였습니다.");
                        return;
                    }
                }                
                //종료포지션이 전체카운트보다 
                if(ed_pos == tot_cnt){
                    
                    //경매차수정보 update
                    srchData["st_pos"]  = 1;
                    AucQcn_results = sendAjax(srchData, "/LALM0411_updAucQcn", "POST");
                    if(AucQcn_results.status != RETURN_SUCCESS){
                        showErrorMessage(AucQcn_results);
                        return;
                    }else{
                    	AucQcn_result = setDecrypt(AucQcn_results);
                    }

                    $("#AucQcn_cnt").html(tot_cnt + " 건");
                    $("#AucQcn_msg").html("전송 완료하였습니다.");
                    $("#pb_SogCowSend").attr('disabled', false);
                    return;
                }                
                st_pos += fix_pos;
                ed_pos += fix_pos;
            }
        }else{
        	$("#AucQcn_msg").html("전송 할 내역이 없습니다.");
            $("#pb_SogCowSend").attr('disabled', false);
        }
        
        return;
    }
    
    //출장우내역 전송
    function fn_SogCowSend(){
    	
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
        
        /****************************************************************/
        /* 불량 데이터 강제 수정(원표번호 재설정)                       */
        /* 대상테이블 : tb_la_is_mh_sog_cow, tb_la_is_mh_fee_imps       */
        /* tb_la_is_mh_calf, tb_la_is_mh_atdr_log, tb_la_is_mh_pla_pr   */
        /* 대상 데이터 : oslp_no                                        */
        /****************************************************************/
        var srchData = new Object();
        srchData["ctgrm_cd"]    = "1600";
        srchData["auc_dt"]      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var results = sendAjax(srchData, "/LALM0411_selChkSogCow", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        $("#SogCow_msg").html("전송중 입니다.");
        
        //출장우 내역 건수 조회
        results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        var tot_cnt = result.totCnt;
        var fix_pos = 20;
        var st_pos = 1;
        var ed_pos = fix_pos;
        
        var start_yn          = "1";
        srchData["start"]     = start_yn;
        
        var sog_results;
        var sog_result;
        
        //출장우 전송 내역
        if(tot_cnt > 0){
            while(true){   
                //첫 전송
                if(start_yn == "1"){
                    sog_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                    if(sog_results.status != RETURN_SUCCESS){
                        showErrorMessage(sog_results,'NOTFOUND');
                        $("#SogCow_msg").html("전송중 오류가 발생하였습니다.");
                        return;
                    }else{
                        sog_result = setDecrypt(sog_results);
                        if(sog_result.RZTC != '1'){
                            $("#SogCow_msg").html("전송중 오류가 발생하였습니다.");
                            return;
                        }
                        start_yn = "0";
                    }
                //데이터 전송
                }else{
                    srchData["start"] = start_yn;                   
                    if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                    srchData["st_pos"]  = st_pos;
                    srchData["ed_pos"]  = ed_pos;
                    
                    sog_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                    if(sog_results.status != RETURN_SUCCESS){
                        showErrorMessage(sog_results,'NOTFOUND');
                        $("#SogCow_msg").html("전송중 오류가 발생하였습니다.");
                        return;
                    }else{
                        sog_result = setDecrypt(sog_results);
                        if(sog_result.RZTC != '1'){
                            $("#SogCow_msg").html("전송중 오류가 발생하였습니다.");
                            return;
                        }
                    }
                    
                    //종료포지션이 전체카운트보다 
                    if(ed_pos == tot_cnt){
                    	
                    	//출장우 전송건 업데이트
                        srchData["st_pos"]  = 1;
                        sog_results = sendAjax(srchData, "/LALM0411_updSogCow", "POST");
                        if(sog_results.status != RETURN_SUCCESS){
                            showErrorMessage(sog_results);
                            return;
                        }else{
                        	sog_result = setDecrypt(sog_results);
                        }
                        
                    	//수수료
                    	var feeIns = fn_FeeSend();
                    	//송아지
                    	var calfIns = fn_CalfSend();
                        //농가
                        var fhsIns  = fn_FhsSend();
                        //개체
                        var IndvIns = fn_IndvSend();
                    	
                        $("#SogCow_cnt").html(tot_cnt + " 건");
                        $("#SogCow_msg").html("전송 완료하였습니다.");

                        $("#pb_AtdrLogSend").attr('disabled', false);
                        return;
                    }
                    
                    st_pos += fix_pos;
                    ed_pos += fix_pos;
                }
            }
        }else{
            $("#SogCow_msg").html("전송 할 내역이 없습니다.");
            $("#pb_AtdrLogSend").attr('disabled', false);
        }
        
        return;
    }
    
    //수수료 전송
    function fn_FeeSend(){
    	
    	var reStr = "0";
    	
        var srchData = new Object();
        srchData["ctgrm_cd"]    = "3900";
        srchData["auc_dt"]      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }

        var tot_cnt = result.totCnt;
        var fix_pos = 100;
        var st_pos = 1;
        var ed_pos = fix_pos;
        
        var start_yn          = "1";
        srchData["start"]     = start_yn;
        
        var fee_results;
        var fee_result;
                
        if(tot_cnt > 0){
            while(true){
            	//첫 전송
                if(start_yn == "1"){
                	fee_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                    if(fee_results.status != RETURN_SUCCESS){
                        showErrorMessage(fee_results,'NOTFOUND');
                        return reStr;
                    }else{
                    	fee_result = setDecrypt(fee_results);
                        if(fee_result.RZTC != '1'){
                            return reStr;
                        }
                        start_yn = "0";
                    }
                }else{
                	
                	srchData["start"] = start_yn;                   
                    if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                    srchData["st_pos"]  = st_pos;
                    srchData["ed_pos"]  = ed_pos;
                	
                    fee_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                    if(fee_results.status != RETURN_SUCCESS){
                        showErrorMessage(fee_results,'NOTFOUND');
                        return reStr;
                    }else{
                    	fee_result = setDecrypt(fee_results);
                        if(fee_result.RZTC != '1'){
                            return reStr;
                        }
                    }
                	
                    //종료포지션이 전체카운트보다 
                    if(ed_pos == tot_cnt){
                    	
                    	//출장우 수수료 업데이트
                        srchData["st_pos"]  = 1;
                        fee_results = sendAjax(srchData, "/LALM0411_updSogCowFee", "POST");
                        if(fee_results.status != RETURN_SUCCESS){
                            showErrorMessage(fee_results);
                            return;
                        }else{
                        	fee_result = setDecrypt(fee_results);
                        }
                    	
                    	reStr = "1";
                        return reStr;
                    }
                    
                    st_pos += fix_pos;
                    ed_pos += fix_pos;   
                	
                }
            }	
        }
        
        return reStr;
    }
    
    //송아지정보 전송
    function fn_CalfSend(){
    	
        var reStr = "0";
        
        var srchData = new Object();
        srchData["ctgrm_cd"]    = "3700";
        srchData["auc_dt"]      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
    	
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
    	
        var tot_cnt = result.totCnt;
        var fix_pos = 100;
        var st_pos = 1;
        var ed_pos = fix_pos;
        
        var start_yn          = "1";
        srchData["start"]     = start_yn;
        
        var calf_results;
        var calf_result;
        
        if(tot_cnt > 0){
        	 while(true){
                 //첫 전송
                 if(start_yn == "1"){
                	 calf_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                     if(calf_results.status != RETURN_SUCCESS){
                         showErrorMessage(calf_results,'NOTFOUND');
                         return reStr;
                     }else{
                    	 calf_result = setDecrypt(calf_results);
                         if(calf_result.RZTC != '1'){
                             return reStr;
                         }
                         start_yn = "0";
                     }
                 }else{
                	 srchData["start"] = start_yn;                   
                     if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                     srchData["st_pos"]  = st_pos;
                     srchData["ed_pos"]  = ed_pos;
                     
                     calf_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                     if(calf_results.status != RETURN_SUCCESS){
                         showErrorMessage(calf_results,'NOTFOUND');
                         return reStr;
                     }else{
                    	 calf_result = setDecrypt(calf_results);
                         if(calf_result.RZTC != '1'){
                             return reStr;
                         }
                     }
                     
                     //종료포지션이 전체카운트보다 
                     if(ed_pos == tot_cnt){
                    	 
                    	//출장우 송아지 업데이트
                         srchData["st_pos"]  = 1;
                         calf_results = sendAjax(srchData, "/LALM0411_updSogCowCalf", "POST");
                         if(calf_results.status != RETURN_SUCCESS){
                             showErrorMessage(calf_results);
                             return;
                         }else{
                        	 calf_result = setDecrypt(calf_results);
                         }
                    	 
                         reStr = "1";
                         return reStr;
                     }
                     
                     st_pos += fix_pos;
                     ed_pos += fix_pos; 
                 }
        	 }
        }

        return reStr;
    }
    
    //농가정보 전송
    function fn_FhsSend(){
    	//축경 전자경매 농가채번 issue: 농가번호가 T이후로 숫자만 입력이 되어야하는데 TYJ,T영축,영축으로 등록되는 데이터로인하여 문제
    	    	
        var srchData = new Object();
        srchData["ctgrm_cd"]    = "3800";
        srchData["auc_dt"]      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
    	
	    var mmfhs_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
	    if(mmfhs_results.status != RETURN_SUCCESS){
	        showErrorMessage(mmfhs_results,'NOTFOUND');
	        return;
	    }else{      
	        var mmfhs_result = setDecrypt(mmfhs_results);
	    }
    }
    
    //개체정보 전송
    function fn_IndvSend(){
    	
    	var srchData = new Object();
        srchData["ctgrm_cd"]    = "4000";
        srchData["auc_dt"]      = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var indv_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                
        if(indv_results.status != RETURN_SUCCESS){
            showErrorMessage(indv_results,'NOTFOUND');
            return;
        }else{      
            var indv_result = setDecrypt(indv_results);
        }
    	
    }
    
    //응찰내역전송
    function fn_AtdrLogSend(){
    	
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
    	
        $("#AtdrLog_msg").html("전송중 입니다.");
        
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "2100";
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"] = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        var tot_cnt = result.totCnt;
        var fix_pos = 50;
        var st_pos = 1;
        var ed_pos = fix_pos;
        var start_yn          = "1";
        srchData["start"]     = start_yn;
        
        var atdrLog_results;
        var atdrLog_result;
        
        if(tot_cnt > 0){
            while(true){
            
            	 srchData["start"] = start_yn;                   
                 if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                 srchData["st_pos"]  = st_pos;
                 srchData["ed_pos"]  = ed_pos;
                 
                 atdrLog_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                 if(atdrLog_results.status != RETURN_SUCCESS){
                     showErrorMessage(atdrLog_results,'NOTFOUND');
                     $("#AtdrLog_msg").html("전송중 오류가 발생하였습니다.");
                     return;
                 }else{
                	 atdrLog_result = setDecrypt(atdrLog_results);
                     if(atdrLog_result.RZTC != '1'){
                    	 $("#AtdrLog_msg").html("전송중 오류가 발생하였습니다.");
                         return;    
                     }
                 }
                 
                 //종료포지션이 전체카운트보다 
                 if(ed_pos == tot_cnt){
                     //응찰로그 update
                     srchData["st_pos"]  = 1;
                     atdrLog_results = sendAjax(srchData, "/LALM0411_updAtdrLog", "POST");
                     if(atdrLog_results.status != RETURN_SUCCESS){
                         showErrorMessage(atdrLog_results);
                         break;
                     }else{
                    	 atdrLog_result = setDecrypt(atdrLog_results);
                     }

                     $("#AtdrLog_cnt").html(tot_cnt + " 건");
                     $("#AtdrLog_msg").html("전송 완료하였습니다.");
                     return;
                 }

                 st_pos += fix_pos;
                 ed_pos += fix_pos;
            }
        }else{
            $("#AtdrLog_msg").html("전송 할 내역이 없습니다.");
        }
        
        return;
    }
        
    //입금내역 전송
    function fn_MwmnAdjSend(){
    	
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
        
    	$("#MwmnAdj_msg").html("전송중 입니다.");
    	
    	var srchData = new Object();
        srchData["ctgrm_cd"]  = "2000";
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"] = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    	
        var MwmnAdj_results;
        var MwmnAdj_result;
                
        var tot_cnt = result.totCnt;
        var fix_pos = 150;
        var st_pos = 1;
        var ed_pos = fix_pos;
    	
        if(tot_cnt > 0){
            
            while(true){
                if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                
                srchData["st_pos"]  = st_pos;
                srchData["ed_pos"]  = ed_pos;
                
                MwmnAdj_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                
                if(MwmnAdj_results.status != RETURN_SUCCESS){
                    showErrorMessage(MwmnAdj_results,'NOTFOUND');
                    $("#MwmnAdj_msg").html("전송중 오류가 발생하였습니다.");
                    return;
                }else{;
                    MwmnAdj_result = setDecrypt(MwmnAdj_results);
                    if(MwmnAdj_result.RZTC != '1'){
                        $("#MwmnAdj_msg").html("전송중 오류가 발생하였습니다.");
                        break;
                    }
                }                
                //종료포지션이 전체카운트보다 
                if(ed_pos == tot_cnt){
                    //입금내역 update
                    srchData["st_pos"]  = 1;
                    MwmnAdj_results = sendAjax(srchData, "/LALM0411_updMwmnAdj", "POST");
                    if(MwmnAdj_results.status != RETURN_SUCCESS){
                        showErrorMessage(MwmnAdj_results);
                        break;
                    }else{
                    	MwmnAdj_result = setDecrypt(MwmnAdj_results);
                    }

                    $("#MwmnAdj_cnt").html(tot_cnt + " 건");
                    $("#MwmnAdj_msg").html("전송 완료하였습니다.");
                    return;
                }
                st_pos += fix_pos;
                ed_pos += fix_pos;
            }
        }else{
            $("#MwmnAdj_msg").html("전송 할 내역이 없습니다.");
        }
    }
    
    
    //경매참가내역 전송
    function fn_MwmnEntrSend(){
    	
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
    	
        $("#MwmnEntr_msg").html("전송중 입니다.");
    	
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "2700";
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"] = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        var MwmnEntr_results;
        var MwmnEntr_result;
                
        var tot_cnt = result.totCnt;
        var fix_pos = 100;
        var st_pos = 1;
        var ed_pos = fix_pos;
    	
        if(tot_cnt > 0){
            
            while(true){
                if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                
                srchData["st_pos"]  = st_pos;
                srchData["ed_pos"]  = ed_pos;
                
                MwmnEntr_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                
                if(MwmnEntr_results.status != RETURN_SUCCESS){
                    showErrorMessage(MwmnEntr_results,'NOTFOUND');
                    $("#MwmnEntr_msg").html("전송중 오류가 발생하였습니다.");
                    return;
                }else{;
                    MwmnEntr_result = setDecrypt(MwmnEntr_results);
                    if(MwmnEntr_result.RZTC != '1'){
                        $("#MwmnEntr_msg").html("전송중 오류가 발생하였습니다.");
                        break;
                    }
                }                
                //종료포지션이 전체카운트보다 
                if(ed_pos == tot_cnt){
                	//경매참가내역 update
                    srchData["st_pos"]  = 1;
                    MwmnEntr_results = sendAjax(srchData, "/LALM0411_updMwmnEntr", "POST");
                    if(MwmnEntr_results.status != RETURN_SUCCESS){
                        showErrorMessage(MwmnEntr_results);
                        break;
                    }else{
                    	MwmnEntr_result = setDecrypt(MwmnEntr_results);
                    }
                	
                    $("#MwmnEntr_cnt").html(tot_cnt + " 건");
                    $("#MwmnEntr_msg").html("전송 완료하였습니다.");
                    return;
                }                
                st_pos += fix_pos;
                ed_pos += fix_pos;
            }
        }else{
            $("#MwmnEntr_msg").html("전송 할 내역이 없습니다.");
        }
    }
    
    //참여산정위원 전송
    function fn_RkonCmSend(){
    	
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
    	
    	$("#RkonCm_msg").html("전송중 입니다.");

        var srchData = new Object();
        srchData["ctgrm_cd"]  = "3500";
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"] = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        
        var results = sendAjax(srchData, "/LALM0899_selIfTotCnt", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        var RkonCm_results;
        var RkonCm_result;
                
        var tot_cnt = result.totCnt;
        var fix_pos = 50;
        var st_pos = 1;
        var ed_pos = fix_pos;
        
        if(tot_cnt > 0){
            while(true){
                if(tot_cnt < ed_pos) ed_pos = tot_cnt;
                
                srchData["st_pos"]  = st_pos;
                srchData["ed_pos"]  = ed_pos;
                
                RkonCm_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                
                if(RkonCm_results.status != RETURN_SUCCESS){
                    showErrorMessage(RkonCm_results,'NOTFOUND');
                    $("#RkonCm_msg").html("전송중 오류가 발생하였습니다.");
                    return;
                }else{
                    RkonCm_result = setDecrypt(RkonCm_results);
                    if(RkonCm_result.RZTC != '1'){
                        $("#RkonCm_msg").html("전송중 오류가 발생하였습니다.");
                        break;
                    }
                }                
                //종료포지션이 전체카운트보다 
                if(ed_pos == tot_cnt){
                	//참여산정위원 update
                    srchData["st_pos"]  = 1;
                    RkonCm_results = sendAjax(srchData, "/LALM0411_updRkonCm", "POST");
                    if(RkonCm_results.status != RETURN_SUCCESS){
                        showErrorMessage(RkonCm_results);
                        break;
                    }else{
                    	RkonCm_result = setDecrypt(RkonCm_results);
                    }
                    $("#RkonCm_cnt").html(tot_cnt + " 건");
                    $("#RkonCm_msg").html("전송 완료하였습니다.");
                    return;
                }                
                st_pos += fix_pos;
                ed_pos += fix_pos;
            }
        }else{
            $("#RkonCm_msg").html("전송 할 내역이 없습니다.");
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
                    <li><p class="dot_allow">송신조건</p></li>
                </ul>    
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search">
                    <table>
                        <colgroup>
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="250">
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
                                    <div class="cellBox pl2">
                                        <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                    </div>
                                </td>
                                <td></td>                    
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">송신대상</p></li>
                </ul>  
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->
                    <button class="tb_btn" id="pb_SendAllMwmn">중도매인 전체송신</button>
                    <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 일괄송신이 아닌 선택송신시 경매차수를 먼저 송신하세요.</label>   
                    <button class="tb_btn" id="pb_SendAll">일괄송신</button>
                </div>  
            </div>
            <div class="grayTable rsp_v">
                <table id="frm_BasDsc">
                    <colgroup>
                        <col width="200">
                        <col width="70">
                        <col width="*">
                        <col width="100">
                    </colgroup>
                    <tbody>
                       <tr>
                           <th class="ta_c">중도매인정보</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_MwmnSend">송신</button>
                               </div>
                           </td>
                           <td><div id="Mwmn_msg"></div></td>
                           <td class="ta_r"><div id="Mwmn_cnt">0 건</div></td>
                       </tr>
                       <tr>
                           <th class="ta_c">경매차수</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_AucQcnSend">송신</button>
                               </div>
                           </td>
                           <td><div id="AucQcn_msg"></div></td>
                           <td class="ta_r"><div id="AucQcn_cnt">0 건</div></td>
                       </tr>
                       <tr>
                           <th class="ta_c">출장우내역</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn" id="pb_SogCowSend">송신</button>
                               </div>
                           </td>
                           <td><div id="SogCow_msg"></div></td>
                           <td class="ta_r"><div id="SogCow_cnt">0 건</div></td>
                       </tr>
                       <tr>
                           <th class="ta_c">응찰로그</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_AtdrLogSend">송신</button>
                               </div>
                           </td>
                           <td><div id="AtdrLog_msg"></div></td>
                           <td class="ta_r"><div id="AtdrLog_cnt">0 건</div></td>
                       </tr>
                       <tr>
                           <th class="ta_c">입금내역</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_MwmnAdjSend">송신</button>
                               </div>
                           </td>
                           <td><div id="MwmnAdj_msg"></div></td>
                           <td class="ta_r"><div id="MwmnAdj_cnt">0 건</div></td>
                       </tr>
                       <tr>
                           <th class="ta_c">경매참가내역</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_MwmnEntrSend">송신</button>
                               </div>
                           </td>
                           <td><div id="MwmnEntr_msg"></div></td>
                           <td class="ta_r"><div id="MwmnEntr_cnt">0 건</div></td>
                       </tr>
                       <tr>
                           <th class="ta_c">참여산정위원</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_RkonCmSend">송신</button>
                               </div>
                           </td>
                           <td><div id="RkonCm_msg"></div></td>
                           <td class="ta_r"><div id="RkonCm_cnt">0 건</div></td>
                       </tr>
                    </tbody>
                </table>
            </div>
            
<!--             <div class="tab_box clearfix m5"> -->
<!--                 <ul class="tab_list fl_L"> -->
<!--                     <li><p class="dot_allow">기존농가정보 축경통 생성</p><li> -->
<!--                 </ul> -->
<!--             </div> -->
<!--             <div class="sec_table"> -->
<!--                 <div class="blueTable rsp_v"> -->
<!--                     <form id="frm_SreachFha" name="frm_SreachFha"> -->
<!--                     <table> -->
<%--                         <colgroup> --%>
<%--                             <col width="150"> --%>
<%--                             <col width="*"> --%>
<%--                             <col width="150"> --%>
<%--                             <col width="250"> --%>
<%--                             <col width="*"> --%>
<%--                         </colgroup> --%>
<!--                         <tbody> -->
<!--                             <tr> -->
<!--                                <th scope="row">MAX 농가코드</th> -->
<!--                                 <td> -->
<!--                                     <input type="text" id="max_fha_id_no"/> -->
<!--                                 </td> -->
<!--                                 <td><button class="button" id="pb_fhsinfo">조회(저장)</button></td> -->
<!--                                 <td></td> -->
<!--                                 <td></td> -->
<!--                             </tr> -->
<!--                         </tbody> -->
<!--                     </table> -->
<!--                     </form> -->
<!--                 </div> -->
<!--             </div> -->
<!--             <div class="listTable rsp_v"> -->
<!--                 <table id="grd_FhsInfo"> -->
<!--                 </table> -->
<!--             </div> -->
            
        </section>
        
    </div>
<!-- ./wrapper -->
</body>
</html>