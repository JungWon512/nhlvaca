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
    	
        $("#inq_st_dt, #inq_ed_dt").on('change input',function(event){
        	  $("#fhm_msg").html("");
              $("#fhm_cnt").html("0 건");
              $("#indv_msg").html("");
              $("#indv_cnt").html("0 건");
              $("#vhc_msg").html("");
              $("#vhc_cnt").html("0 건");
              $("#kpn_msg").html("");
              $("#kpn_cnt").html("0 건");
              $("#fee_msg").html("");
              $("#fee_cnt").html("0 건");
              $("#bad_msg").html("");
              $("#bad_cnt").html("0 건");
              $("#trpl_msg").html("");   
              $("#trpl_cnt").html("0 건");
              $("#comn_msg").html("");
              $("#comn_cnt").html("0 건");
        });
    	
        
         /******************************
         * 수신기준
         ******************************/
         $("input[name='io_all_yn_radio']").on('change',function(e){
        	 e.preventDefault();
             this.blur();
             fn_OiAllYn();
             $("#fhm_msg").html("");
             $("#fhm_cnt").html("0 건");
             $("#indv_msg").html("");
             $("#indv_cnt").html("0 건");
             $("#vhc_msg").html("");
             $("#vhc_cnt").html("0 건");
             $("#kpn_msg").html("");
             $("#kpn_cnt").html("0 건");
             $("#fee_msg").html("");
             $("#fee_cnt").html("0 건");
             $("#bad_msg").html("");
             $("#bad_cnt").html("0 건");
             $("#trpl_msg").html("");   
             $("#trpl_cnt").html("0 건");
             $("#comn_msg").html("");
             $("#comn_cnt").html("0 건");
             $("#inq_st_dt").datepicker().datepicker("setDate", fn_getDay(-365));
             $("#inq_ed_dt").datepicker().datepicker("setDate", fn_getToday());
         });
         
        /******************************
        * 일괄수신 수신
        ******************************/
        $("#pb_SendAll").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_AllSend();
        });
        
        /******************************
        * 농가정보 수신
        ******************************/
        $("#pb_fhmSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_FhmSend();
        });
        
        /******************************
        * 개체정보 수신
        ******************************/
        $("#pb_indvSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_IndvSend();
        });
        
        /******************************
        * 수송자정보 수신
        ******************************/
        $("#pb_vhcSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_VhcSend();
        });
        
        /******************************
        * KPN정보 수신
        ******************************/
        $("#pb_kpnSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_KpnSend();
        });
        
        /******************************
        * 수수료정보 수신
        ******************************/
        $("#pb_feeSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_FeeSend();
        });
         
        /******************************
        * 불량거래인정보 수신
        ******************************/
        $("#pb_badSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_BadSend();
        });
        
        /******************************
        * 거래처정보 수신
        ******************************/
        $("#pb_trplSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_TrplSend();
        });
        
        /******************************
        * 공통코드정보 수신
        ******************************/
        $("#pb_comnSend").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_ComnSend();
        });
        
        fn_Init();
        
    });
    
    /*------------------------------------------------------------------------------
    * 1. 함 수 명    : 초기화 함수
    * 2. 입 력 변 수 : N/A
    * 3. 출 력 변 수 : N/A
    ------------------------------------------------------------------------------*/
    function fn_Init(){   

        //폼 초기화
        fn_InitFrm('frm_Search');
        fn_InitFrm('frm_BasDsc');
        
        $("#inq_st_dt").attr('disabled', true);
        $("#inq_ed_dt").attr('disabled', true); 
                
        $("#inq_st_dt").datepicker().datepicker("setDate", fn_getDay(-365));
        $("#inq_ed_dt").datepicker().datepicker("setDate", fn_getToday());
        
        $("#fhm_msg").html("");
        $("#fhm_cnt").html("0 건");
        $("#indv_msg").html("");
        $("#indv_cnt").html("0 건");
        $("#vhc_msg").html("");
        $("#vhc_cnt").html("0 건");
        $("#kpn_msg").html("");
        $("#kpn_cnt").html("0 건");
        $("#fee_msg").html("");
        $("#fee_cnt").html("0 건");
        $("#bad_msg").html("");
        $("#bad_cnt").html("0 건");
        $("#trpl_msg").html("");
        $("#trpl_cnt").html("0 건");
        $("#comn_msg").html("");
        $("#comn_cnt").html("0 건");
        
    }
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
     
    //수신기준 변경
    function fn_OiAllYn(){
    	
    	//전체
    	if($("input[name='io_all_yn_radio']:checked").val() == '1'){
    		$("#inq_st_dt").attr('disabled', true);
    		$("#inq_ed_dt").attr('disabled', true);    		
    	}else{    		
            $("#inq_st_dt").attr('disabled', false);
            $("#inq_ed_dt").attr('disabled', false);
    	}
    	
    }
    
    //날짜 기간 체크
    function fn_ChkYear(){
    	var vSValue_Num = $( "#inq_st_dt" ).val().replace(/[^0-9]/g,"");
        var vEValue_Num = $( "#inq_ed_dt" ).val().replace(/[^0-9]/g,"");
        
        var rxDatePattern = /^(\d{4})(\d{1,2})(\d{1,2})$/;
        var sDtArray = vSValue_Num.match(rxDatePattern);
        var eDtArray = vEValue_Num.match(rxDatePattern);

        var v_sdate    = new Date(sDtArray[1], sDtArray[2] - 1, sDtArray[3]);
        var v_edate    = new Date(eDtArray[1], eDtArray[2] - 1, eDtArray[3]);
        
        var inteval = v_edate - v_sdate;
        var day = inteval / (1000*60*60*24);
        
        if(day > 180){
            MessagePopup('OK','개체정보는 최대 180일 수신 가능합니다.',function(){
                $( "#inq_st_dt" ).focus();
            });
        	return true;
        }
        
        return false;
    }
    
    //날짜 체크
    function fn_ChkDate(){
    	
    	if(fn_isNull($( "#inq_st_dt" ).val()) == true){
            MessagePopup('OK','시작일자를 선택하세요.',function(){
                $( "#inq_st_dt" ).focus();
            });
            return true;
        }
        
        if(fn_isDate($( "#inq_st_dt" ).val()) == false){
            MessagePopup('OK','시작일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#inq_st_dt" ).focus();
            });
            return true;
        }
        
        if(fn_isNull($( "#inq_ed_dt" ).val()) == true){
            MessagePopup('OK','종료일자를 선택하세요.',function(){
                $( "#inq_ed_dt" ).focus();
            });
            return true;
        }
        
        if(fn_isDate($( "#inq_ed_dt" ).val()) == false){
            MessagePopup('OK','종료일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#inq_ed_dt" ).focus();
            });
            return true;
        }
                
        return false;
    	
    }
    
    //일괄수신
    function fn_AllSend(){
    	
    	if(fn_ChkDate()) return;
    	if(fn_ChkYear()) return;
    	
    	fn_FhmSend();
    	fn_IndvSend();
    	fn_VhcSend();
    	fn_KpnSend();
    	fn_FeeSend();
    	fn_BadSend();
    	fn_TrplSend();
    	fn_ComnSend();
    }
    
    //농가정보
    function fn_FhmSend(){
    	
    	if(fn_ChkDate()) return;
//     	if(fn_ChkYear()) return;
    	
    	$("#fhm_msg").html("수신중입니다....");
    	
        var results;        
        var result;
        
    	var srchData = new Object();
        srchData["ctgrm_cd"]  = "1200";
                
    	srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["in_rec_cn"] = "30";
        var fix_pos = 30;
        var st_pos  = 1;
        var dataCnt = 0;
        
        while(true){
        	      	
        	srchData["in_sqno"]   = st_pos;
        	results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
        	st_pos += fix_pos;
        	
        	if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                $("#fhm_msg").html("수신중 오류.");
                fn_setChgRadio('fhm_result','0');
                fn_setRadioChecked("fhm_result");
                return; 
            }else{
                result = setDecrypt(results);
                dataCnt = result.dataCnt;
                if(dataCnt == 0){
                	$("#fhm_msg").html("수신내역 없음.");
                	fn_setChgRadio('fhm_result','1');
                	fn_setRadioChecked("fhm_result");
                    return;	
                }
            }        	
        	if(dataCnt < st_pos){               
                $("#fhm_cnt").html(dataCnt + " 건");
                $("#fhm_msg").html("수신이 완료 되었습니다.");
                fn_setChgRadio('fhm_result','1');
                fn_setRadioChecked("fhm_result");
                return;
            }        	
        }        
    }
    
    function fn_IndvSend(){    	
    	
    	if(fn_ChkDate()) return;
    	if(fn_ChkYear()) return;
    	    	
        $("#indv_msg").html("수신중입니다....");
    	
        var results;        
        var result;
        
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "1400";
        srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["in_rec_cn"] = "100";
        
        var fix_pos = 100;
        var st_pos  = 1;
        var dataCnt = 0;
        
        while(true){
        	
            srchData["in_sqno"]   = st_pos;
            
            results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
            
            st_pos += fix_pos;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                $("#indv_msg").html("수신중 오류.");
                fn_setChgRadio('indv_result','0');
                fn_setRadioChecked("indv_result");
                return;
            }else{
                result = setDecrypt(results);
                dataCnt = result.dataCnt;
                if(dataCnt == 0){
                    $("#indv_msg").html("수신내역 없음.");
                    fn_setChgRadio('indv_result','1');
                    fn_setRadioChecked("indv_result");
                    return; 
                }
            }
            
            if(dataCnt < st_pos){               
                $("#indv_cnt").html(dataCnt + " 건");
                $("#indv_msg").html("수신이 완료 되었습니다.");
                fn_setChgRadio('indv_result','1');
                fn_setRadioChecked("indv_result");
                return;
            }            
        }
    }
    
    function fn_VhcSend(){
    	
    	if(fn_ChkDate()) return;
//     	if(fn_ChkYear()) return;
    	
        $("#vhc_msg").html("수신중입니다....");
        
        var results;        
        var result;
        
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "1500";
        srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["in_rec_cn"] = "50";
        var fix_pos = 50;
        var st_pos  = 1;
        var dataCnt = 0;
        
        while(true){
            srchData["in_sqno"]   = st_pos;
            results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
            
            st_pos += fix_pos;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                $("#vhc_msg").html("수신중 오류.");
                fn_setChgRadio('vhc_result','0');
                fn_setRadioChecked("vhc_result");
                return;
            }else{;
                result = setDecrypt(results);
                dataCnt = result.dataCnt;
                if(dataCnt == 0){
                    $("#vhc_msg").html("수신내역 없음.");
                    fn_setChgRadio('vhc_result','1');
                    fn_setRadioChecked("vhc_result");
                    return; 
                }
            }
            if(dataCnt < st_pos){               
                $("#vhc_cnt").html(dataCnt + " 건");
                $("#vhc_msg").html("수신이 완료 되었습니다.");
                fn_setChgRadio('vhc_result','1');
                fn_setRadioChecked("vhc_result");
                return;
            }
        }
    }
    
    function fn_KpnSend(){
    	    	
    	if(fn_ChkDate()) return;
//     	if(fn_ChkYear()) return;
    	
        $("#kpn_msg").html("수신중입니다....");
        
        var results;        
        var result;
        
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "3300";
        srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["in_rec_cn"] = "50";
        var fix_pos = 50;
        var st_pos  = 1;
        var dataCnt = 0;
        
        while(true){
            srchData["in_sqno"]   = st_pos;
            results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
            
            st_pos += fix_pos;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                $("#kpn_msg").html("수신중 오류.");
                fn_setChgRadio('kpn_result','0');
                fn_setRadioChecked("kpn_result");
                return;
            }else{;
                result = setDecrypt(results);
                dataCnt = result.dataCnt;
                if(dataCnt == 0){
                    $("#kpn_msg").html("수신내역 없음.");
                    fn_setChgRadio('kpn_result','1');
                    fn_setRadioChecked("kpn_result");
                    return; 
                }
            }
            if(dataCnt < st_pos){               
                $("#kpn_cnt").html(dataCnt + " 건");
                $("#kpn_msg").html("수신이 완료 되었습니다.");
                fn_setChgRadio('kpn_result','1');
                fn_setRadioChecked("kpn_result");
                return;
            }
        }
    }
    
    function fn_FeeSend(){
    	
    	if(fn_ChkDate()) return;
//     	if(fn_ChkYear()) return;
    	
        $("#fee_msg").html("수신중입니다....");
        
        var results;        
        var result;
        
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "1700";
        srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["in_rec_cn"] = "100";
        var fix_pos = 100;
        var st_pos  = 1;
        var dataCnt = 0;
        
        while(true){
            srchData["in_sqno"]   = st_pos;
            results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
            
            st_pos += fix_pos;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                $("#fee_msg").html("수신중 오류.");
                fn_setChgRadio('fee_result','0');
                fn_setRadioChecked("fee_result");
                return;
            }else{
                result = setDecrypt(results);
                dataCnt = result.dataCnt;
                if(dataCnt == 0){
                    $("#fee_msg").html("수신내역 없음.");
                    fn_setChgRadio('fee_result','1');
                    fn_setRadioChecked("fee_result");
                    return; 
                }
            }
            if(dataCnt < st_pos){               
                $("#fee_cnt").html(dataCnt + " 건");
                $("#fee_msg").html("수신이 완료 되었습니다.");
                fn_setChgRadio('fee_result','1');
                fn_setRadioChecked("fee_result");
                return;
            }
        }
    }
    
    function fn_BadSend(){
    	
    	if(fn_ChkDate()) return;
//     	if(fn_ChkYear()) return;
    	
        $("#bad_msg").html("수신중입니다....");
        
        var results;        
        var result;
        
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "1800";
        srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["in_rec_cn"] = "30";
        var fix_pos = 30;
        var st_pos  = 1;
        var dataCnt = 0;
        
        while(true){
            srchData["in_sqno"]   = st_pos;
            results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
            
            st_pos += fix_pos;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                $("#bad_msg").html("수신중 오류.");
                fn_setChgRadio('bad_result','0');
                fn_setRadioChecked("bad_result");
                return;
            }else{
                result = setDecrypt(results);
                
                dataCnt = result.INQ_CN;
                
                if(dataCnt == 0){
                    $("#bad_msg").html("수신내역 없음.");
                    fn_setChgRadio('bad_result','1');
                    fn_setRadioChecked("bad_result");
                    return; 
                }
            }
            if(dataCnt < st_pos){               
                $("#bad_cnt").html(dataCnt + " 건");
                $("#bad_msg").html("수신이 완료 되었습니다.");
                fn_setChgRadio('bad_result','1');
                fn_setRadioChecked("bad_result");
                return;
            }
        }
    }
    
    function fn_TrplSend(){
    	
    	if(fn_ChkDate()) return;
//     	if(fn_ChkYear()) return;
    	
        $("#trpl_msg").html("수신중입니다....");
        
        var results;        
        var result;
        
        var srchData = new Object();
        srchData["ctgrm_cd"]  = "3400";
        srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
        srchData["na_bzplc"]  = App_na_bzplc;
        srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
        srchData["in_rec_cn"] = "50";
        var fix_pos = 50;
        var st_pos  = 1;
        var dataCnt = 0;
        
        while(true){
            srchData["in_sqno"]   = st_pos;
            results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
            
            st_pos += fix_pos;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
                $("#trpl_msg").html("수신중 오류.");
                fn_setChgRadio('trpl_result','0');
                fn_setRadioChecked("trpl_result");
                return;
            }else{;
                result = setDecrypt(results);
                
                dataCnt = result.dataCnt;
                if(dataCnt == 0){
                    $("#trpl_msg").html("수신내역 없음.");
                    fn_setChgRadio('trpl_result','1');
                    fn_setRadioChecked("trpl_result");
                    return; 
                }
            }
            if(dataCnt < st_pos){               
                $("#trpl_cnt").html(dataCnt + " 건");
                $("#trpl_msg").html("수신이 완료 되었습니다.");
                fn_setChgRadio('trpl_result','1');
                fn_setRadioChecked("trpl_result");
                return;
            }
        }
    }
    
    function fn_ComnSend(){
    	
    	 if(fn_ChkDate()) return;
//     	 if(fn_ChkYear()) return;
    	
    	 $("#comn_msg").html("전송중입니다....");
         
         var results;        
         var result;
         
         var srchData = new Object();
         srchData["ctgrm_cd"]  = "2500";
         srchData["io_all_yn"] = $("input[name='io_all_yn_radio']:checked").val();
         srchData["na_bzplc"]  = App_na_bzplc;
         srchData["inq_st_dt"] = $("#inq_st_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
         srchData["inq_ed_dt"] = $("#inq_ed_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
         srchData["in_rec_cn"] = "20";
         var fix_pos = 20;
         var st_pos  = 1;
         var dataCnt = 0;
         
         while(true){
             srchData["in_sqno"]   = st_pos;
             results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
             
             st_pos += fix_pos;
             
             if(results.status != RETURN_SUCCESS){
                 showErrorMessage(results,'NOTFOUND');
                 $("#comn_msg").html("수신중 오류.");
                 fn_setChgRadio('comn_result','0');
                 fn_setRadioChecked("comn_result");
                 return;
             }else{;
                 result = setDecrypt(results);
                 dataCnt = result.dataCnt;
                 if(dataCnt == 0){
                     $("#comn_msg").html("수신내역 없음.");
                     fn_setChgRadio('comn_result','1');
                     fn_setRadioChecked("comn_result");
                     return; 
                 }
             }
             if(dataCnt < st_pos){               
                 $("#comn_cnt").html(dataCnt + " 건");
                 $("#comn_msg").html("수신이 완료 되었습니다.");
                 fn_setChgRadio('comn_result','1');
                 fn_setRadioChecked("comn_result");
                 return;
             }
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
                    <li><p class="dot_allow">수신조건</p></li>
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
                               <th scope="row">수신기준</th>
                                <td>
                                    <div class="cellBox" id="rd_io_all_yn">
                                        <div class="cell">
                                            <input type="radio" id="io_all_yn_1" name="io_all_yn_radio" value="1" 
                                            onclick="javascript:fn_setChgRadio('io_all_yn','1');"/>
                                            <label for="io_all_yn_1">전체</label>
                                            <input type="radio" id="io_all_yn_0" name="io_all_yn_radio" value="0" 
                                            onclick="javascript:fn_setChgRadio('io_all_yn','0');"/>
                                            <label for="io_all_yn_0">등록일자범위</label>
                                        </div>
                                    </div>
                                    <input type="hidden" id="io_all_yn"/>
                                </td>
                                <th scope="row">등록일자</th>
                                <td>
                                    <div class="cellBox pl2">
                                        <div class="cell"><input type="text" class="date" id="inq_st_dt" maxlength="10"></div>
                                        <label class="pl2"> ~ </label>
                                        <div class="cell pl2"><input type="text" class="date" id="inq_ed_dt" maxlength="10"></div>
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
                    <li><p class="dot_allow">수신대상</p></li>
                </ul>
                <div class="fl_L"><!--  //버튼 모두 우측정렬 -->
                <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 최대 1년 수신 가능합니다.</label>   
                </div>   
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->
                    <button class="tb_btn" id="pb_SendAll">일괄수신</button>
                </div>  
            </div>
            <div class="grayTable rsp_h">
                <table id="frm_BasDsc">
                    <colgroup>
	                    <col width="200">
	                    <col width="70">
                        <col width="*">
                        <col width="100">
	                    <col width="100">
	                </colgroup>
	                <tbody>
	                   <tr>
	                       <th class="ta_c">농가정보</th>
	                       <td class="ta_c">
		                       <div>
		                           <button class="tb_btn " id="pb_fhmSend">수신</button>
		                       </div>
	                       </td>
	                       <td><div id="fhm_msg"></div></td>
	                       <td class="ta_r"><div id="fhm_cnt">0 건</div></td>
	                       <td class="ta_c">
	                           <div class="cellBox" id="rd_fhm_result">
	                               <div class="cell">
	                                   <input type="radio" id="fhm_result_1" name="fhm_result_radio" value="1" 
	                                   onclick="javascript:fn_setChgRadio('fhm_result','1');"/>
	                                   <label>성공</label>
	                                   <input type="radio" id="fhm_result_0" name="fhm_result_radio" value="0" 
	                                   onclick="javascript:fn_setChgRadio('fhm_result','0');"/>
	                                   <label>실패</label>
	                               </div>
	                           </div>
	                           <input type="hidden" id="fhm_result"/>
	                       </td>
	                   </tr>
	                   <tr>
	                       <th class="ta_c">개체정보</th>
	                       <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_indvSend">수신</button>
                               </div>
                           </td>
                           <td><div id="indv_msg"></div></td>
                           <td class="ta_r"><div id="indv_cnt">0 건</div></td>
                           <td class="ta_c">
                               <div class="cellBox" id="rd_indv_result">
                                   <div class="cell">
                                       <input type="radio" id="indv_result_1" name="indv_result_radio" value="1" 
                                       onclick="javascript:fn_setChgRadio('indv_result','1');"/>
                                       <label>성공</label>
                                       <input type="radio" id="indv_result_0" name="indv_result_radio" value="0" 
                                       onclick="javascript:fn_setChgRadio('indv_result','0');"/>
                                       <label>실패</label>
                                   </div>
                               </div>
                               <input type="hidden" id="indv_result"/>
                           </td>
	                   </tr>
	                   <tr>
                           <th class="ta_c">수송자정보</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_vhcSend">수신</button>
                               </div>
                           </td>
                           <td><div id="vhc_msg"></div></td>
                           <td class="ta_r"><div id="vhc_cnt">0 건</div></td>
                           <td class="ta_c">
                               <div class="cellBox" id="rd_vhc_result">
                                   <div class="cell">
                                       <input type="radio" id="vhc_result_1" name="vhc_result_radio" value="1" 
                                       onclick="javascript:fn_setChgRadio('vhc_result','1');"/>
                                       <label>성공</label>
                                       <input type="radio" id="vhc_result_0" name="vhc_result_radio" value="0" 
                                       onclick="javascript:fn_setChgRadio('vhc_result','0');"/>
                                       <label>실패</label>
                                   </div>
                               </div>
                               <input type="hidden" id="vhc_result"/>
                           </td>
                       </tr>
                       <tr>
                           <th class="ta_c">KPN정보</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_kpnSend">수신</button>
                               </div>
                           </td>
                           <td><div id="kpn_msg"></div></td>
                           <td class="ta_r"><div id="kpn_cnt">0 건</div></td>
                           <td class="ta_c">
                               <div class="cellBox" id="rd_kpn_result">
                                   <div class="cell">
                                       <input type="radio" id="kpn_result_1" name="kpn_result_radio" value="1" 
                                       onclick="javascript:fn_setChgRadio('kpn_result','1');"/>
                                       <label>성공</label>
                                       <input type="radio" id="kpn_result_0" name="kpn_result_radio" value="0" 
                                       onclick="javascript:fn_setChgRadio('kpn_result','0');"/>
                                       <label>실패</label>
                                   </div>
                               </div>
                               <input type="hidden" id="kpn_result"/>
                           </td>
                       </tr>
                       <tr>
                           <th class="ta_c">수수료정보</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_feeSend">수신</button>
                               </div>
                           </td>
                           <td><div id="fee_msg"></div></td>
                           <td class="ta_r"><div id="fee_cnt">0 건</div></td>
                           <td class="ta_c">
                               <div class="cellBox" id="rd_fee_result">
                                   <div class="cell">
                                       <input type="radio" id="fee_result_1" name="fee_result_radio" value="1" 
                                       onclick="javascript:fn_setChgRadio('fee_result','1');"/>
                                       <label>성공</label>
                                       <input type="radio" id="fee_result_0" name="fee_result_radio" value="0" 
                                       onclick="javascript:fn_setChgRadio('fee_result','0');"/>
                                       <label>실패</label>
                                   </div>
                               </div>
                               <input type="hidden" id="fee_result"/>
                           </td>
                       </tr>
                       <tr>
                           <th class="ta_c">불량거래인</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_badSend">수신</button>
                               </div>
                           </td>
                           <td><div id="bad_msg"></div></td>
                           <td class="ta_r"><div id="bad_cnt">0 건</div></td>
                           <td class="ta_c">
                               <div class="cellBox" id="rd_bad_result">
                                   <div class="cell">
                                       <input type="radio" id="bad_result_1" name="bad_result_radio" value="1" 
                                       onclick="javascript:fn_setChgRadio('bad_result','1');"/>
                                       <label>성공</label>
                                       <input type="radio" id="bad_result_0" name="bad_result_radio" value="0" 
                                       onclick="javascript:fn_setChgRadio('bad_result','0');"/>
                                       <label>실패</label>
                                   </div>
                               </div>
                               <input type="hidden" id="bad_result"/>
                           </td>
                       </tr>
                       <tr>
                           <th class="ta_c">거래처정보(산정위원/수의사)</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_trplSend">수신</button>
                               </div>
                           </td>
                           <td><div id="trpl_msg"></div></td>
                           <td class="ta_r"><div id="trpl_cnt">0 건</div></td>
                           <td class="ta_c">
                               <div class="cellBox" id="rd_trpl_result">
                                   <div class="cell">
                                       <input type="radio" id="trpl_result_1" name="trpl_result_radio" value="1" 
                                       onclick="javascript:fn_setChgRadio('trpl_result','1');"/>
                                       <label>성공</label>
                                       <input type="radio" id="trpl_result_0" name="trpl_result_radio" value="0" 
                                       onclick="javascript:fn_setChgRadio('trpl_result','0');"/>
                                       <label>실패</label>
                                   </div>
                               </div>
                               <input type="hidden" id="trpl_result"/>
                           </td>
                       </tr>
                       <tr>
                           <th class="ta_c">공통코드</th>
                           <td class="ta_c">
                               <div>
                                   <button class="tb_btn " id="pb_comnSend">수신</button>
                               </div>
                           </td>
                           <td><div id="comn_msg"></div></td>
                           <td class="ta_r"><div id="comn_cnt">0 건</div></td>
                           <td class="ta_c">
                               <div class="cellBox" id="rd_comn_result">
                                   <div class="cell">
                                       <input type="radio" id="comn_result_1" name="comn_result_radio" value="1" 
                                       onclick="javascript:fn_setChgRadio('comn_result','1');"/>
                                       <label>성공</label>
                                       <input type="radio" id="comn_result_0" name="comn_result_radio" value="0" 
                                       onclick="javascript:fn_setChgRadio('comn_result','0');"/>
                                       <label>실패</label>
                                   </div>
                               </div>
                               <input type="hidden" id="comn_result"/>
                           </td>
                       </tr>
	                </tbody>
                </table>
            </div>
            <div class="tab_box clearfix">  
            </div>            
        </section>
        
    </div>
<!-- ./wrapper -->
</body>
</html>