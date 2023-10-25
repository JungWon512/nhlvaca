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
var pageInfo = setDecryptData('${pageInfo}');
var na_bzplc = App_na_bzplc;
var LALM0412_isFrmOrgData = null;
var fCnt = 0;
var mCnt = 0;

	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 시작
	////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : onload 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/    
	$(document).ready(function(){

        fn_CreateGrd_MhSogCow();
        fn_CreateGrd_MdMwmnAdj();
		
	    /******************************
	     * 초기값 설정
	     ******************************/             
	    fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
	    fn_setCodeBox("sra_rv_tpc",  "SRA_RV_TPC", 1, true);
	    fn_setCodeRadio();
	
	    fn_setCodeRadio("rd_sra_rv_tpc","de_sra_rv_tpc","SRA_RV_TPC", 1);
	    fn_setRadioChecked("rd_sra_rv_tpc");
	    
	    $(window).on('resize.jqGrid',function(){
	        $('#grd_MhSogCow').setGridWidth($('.content').width() - 17,true);
	    });
	    
	    fn_DisableFrm('frm_Farm', true); 
	    
	    $("#sra_mwmnnm").css('background-color', 'white');
	    $("#pb_Give").attr('disabled', true);
	    $("#pb_Take").attr('disabled', true);
	    $("#pb_RvWrite").attr('disabled', true);
	    $("#pb_RvDelete").attr('disabled', true);

        $("#de_rv_dt").datepicker();
        
        
        $("#auc_obj_dsc").on("change", function(e){
            //그리드 초기화
            $("#grd_MhSogCow").jqGrid("clearGridData", true);
//             $("#grd_HdnMhSogCow").jqGrid("clearGridData", true);
            $("#grd_MdMwmnAdj").jqGrid("clearGridData", true);
            
            //폼초기화
            fn_InitFrm('srchFrm_detail');
            fn_InitFrm('frm_Farm');
        });
        
        $("#auc_dt").on("change", function(e){
            //그리드 초기화
            $("#grd_MhSogCow").jqGrid("clearGridData", true);
//             $("#grd_HdnMhSogCow").jqGrid("clearGridData", true);
            $("#grd_MdMwmnAdj").jqGrid("clearGridData", true);
            
            //폼초기화
            fn_InitFrm('srchFrm_detail');
            fn_InitFrm('frm_Farm');
        });
        
        $("#sra_mwmnnm").on("keyup", function(e){
        	
        	//그리드 초기화
            $("#grd_MhSogCow").jqGrid("clearGridData", true);
//             $("#grd_HdnMhSogCow").jqGrid("clearGridData", true);
            $("#grd_MdMwmnAdj").jqGrid("clearGridData", true);
            
            //폼초기화
            fn_InitFrm('srchFrm_detail');
            fn_InitFrm('frm_Farm');
        });
        
	    
	    /******************************
         * 참가번호 팝업
         ******************************/    
     	$("#sra_mwmnnm").on("keyup", function(e){        	
            if(e.keyCode == 13) {
                if(fn_isNull($("#sra_mwmnnm").val())){
                    MessagePopup('OK','중도매인 명을 입력하세요.');
                    return;
                }else {
                	 var data = new Object();
                     data['auc_obj_dsc']      = $("#auc_obj_dsc").val();
                     data['auc_dt']           = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
                     data['sra_mwmnnm']       = $("#sra_mwmnnm").val();
                     fn_CallMwmnnmNoPopup(data,true,function(result){
                         if(result){
                             $("#trmn_amnno").val(result.TRMN_AMNNO);
                             $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
                             $("#sra_mwmnnm").val(result.SRA_MWMNNM);
                             fn_Search();
                         }
                     });
                }
			}else if(e.keyCode != 13) {
	           	 $("#trmn_amnno").val('');
	        	 $("#lvst_auc_ptc_mn_no").val(''); 
			}   
        });	    
	    
	    $("#pb_searchFhs").on('click',function(e){
            e.preventDefault();
            this.blur();
            var data = new Object();
            data['auc_obj_dsc'] 	 = $("#auc_obj_dsc").val();
            data['auc_dt'] 			 = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
            data['sra_mwmnnm']       = $("#sra_mwmnnm").val();
            fn_CallMwmnnmNoPopup(data,false,function(result){
                if(result){
                    $("#trmn_amnno").val(result.TRMN_AMNNO);
                    $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
                    $("#sra_mwmnnm").val(result.SRA_MWMNNM);
                    fn_Search();
                }
            });
        });
	    
	    /******************************
	    * 응찰기지급
	    ******************************/
	    $("#pb_Give").bind('click',function(e){
	        e.preventDefault();
	        this.blur();
	        fn_BtnGive();
	    });
	
	    /******************************
	    * 응찰기반납
	    ******************************/
	    $("#pb_Take").bind('click',function(e){
	        e.preventDefault();
	        this.blur();
	        fn_BtnTake();
	    });
	     
	    /******************************
	    * 입금 입력초기화
	    ******************************/
	    $("#pb_InputInit").on('click',function(e){
	        e.preventDefault();
	        this.blur();
	        fn_BtnInit();
	    }); 
	    
	    /******************************
	    * 입금 입금등록
	    ******************************/
	    $("#pb_RvWrite").bind('click',function(e){
	        e.preventDefault();
	        this.blur();
	        fn_BtnWrite();
	    }); 
	    
	    /******************************
	    * 입금 입금삭제
	    ******************************/
	    $("#pb_RvDelete").bind('click',function(e){
	        e.preventDefault();
	        this.blur();
	        fn_BtnDelete();
	    }); 
	
	    /******************************
	    * 입금 보증금입금
	    ******************************/
	    $("#pb_RvGrmy").bind('click',function(e){
	        e.preventDefault();
	        this.blur();
	        fn_BtnGrmy();
	    }); 
	    
	    
	    /******************************
		 * 낙찰 정산서
		 ******************************/
		$("#pb_Adj").bind('click',function(e){
		    e.preventDefault();
		    this.blur();
	        fn_BtnAdj();
	    });
	    
		/******************************
		 * 낙찰 정산서(암)
		 ******************************/
		$("#pb_Adj_f").bind('click',function(e){
		    e.preventDefault();
		    this.blur();
		    fn_BtnAdj_fm("f");
	    });
		
		/******************************
		 * 낙찰 정산서(수)
		 ******************************/
		$("#pb_Adj_m").bind('click',function(e){
		    e.preventDefault();
		    this.blur();
		    fn_BtnAdj_fm("m");
	    });
		    
	   
        /******************************
	    * 낙찰 채무확인서
	    ******************************/
	    $("#pb_DbtCnf").bind('click',function(e){
	        e.preventDefault();
	        this.blur();
	        fn_BtnDbtCnf();
	    }); 
	    
    	/******************************
 	    * 낙찰 양수/양도
 	    ******************************/
 	   	 $("#pb_AtfCvn").bind('click',function(e){
       		e.preventDefault();
       		this.blur();
       		fn_BtnAtfCvn();
   		}); 
   
  	 	/******************************
  	    * 수수료영수증
  	    ******************************/
  	     $("#pb_FeeRctw").bind('click',function(e){
  	    	 e.preventDefault();
       		this.blur();
       		fn_BtnFeeRctw();
    	}); 
    
   	 	fn_Init();
	     
	});
	/*------------------------
	  obj_dsc [],숫자 제거  
	-------------------------*/
	function fn_deleteNumber(dsc){
		var obj_dsc = dsc.substr(4,3);
		return  obj_dsc; 
	}

	/*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){

        //그리드 초기화
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
//         $("#grd_HdnMhSogCow").jqGrid("clearGridData", true);
        $("#grd_MdMwmnAdj").jqGrid("clearGridData", true);
        
        //폼초기화
        fn_InitFrm('frm_Search');
        fn_InitFrm('srchFrm_detail');
        fn_InitFrm('frm_Farm');

        $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        LALM0412_isFrmOrgData = null;
        
        if(pageInfo.param != null) {
        	$("#auc_dt").val(pageInfo.param.auc_dt);
        	$("#auc_obj_dsc").val(pageInfo.param.auc_obj_dsc);
        	$("#trmn_amnno").val(pageInfo.param.trmn_amnno);
        	$("#lvst_auc_ptc_mn_no").val(pageInfo.param.lvst_auc_ptc_mn_no);
        	$("#sra_mwmnnm").val(pageInfo.param.sra_mwmnnm);
        	
        	fn_Search();
        }
         
    }
	
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 조회 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Search(){
      	if(fn_isNull($("#trmn_amnno").val()) || fn_isNull($("#lvst_auc_ptc_mn_no").val()) || fn_isNull($("#sra_mwmnnm").val()) ){
  			MessagePopup('OK','참가자를 입력하세요.');
            return;
        }	    	
		 
		//그리드 초기화
        $("#grd_MhSogCow").jqGrid("clearGridData", true);
		//$("#grd_HdnMhSogCow").jqGrid("clearGridData", true);
        $("#grd_MdMwmnAdj").jqGrid("clearGridData", true);
        
        fn_InitFrm('srchFrm_detail');
        
        LALM0412_isFrmOrgData = null;
        
        fn_setChgRadio("de_sra_rv_tpc", '1');
        fn_setRadioChecked("de_sra_rv_tpc");
	
	    var result_1;
	    var result_2;
	    var result_3;
	    var result_4;
	    var result_5;
	    var result_6;
	    var result_7;
	    
	    //출하자 주민번호
	    var results_5 = null; 
	    results_5 = sendAjaxFrm("frm_Search", "/LALM0412_selListTbl_Mmmwmn", "POST");
	  
        if(results_5.status != RETURN_SUCCESS){
            showErrorMessage(results_5);
             return;
        }else{     
            result_5 = setDecrypt(results_5);
        }
           $("#frlno").val(result_5[0].FRLNO);
           $("#ohse_telno").val(result_5[0].OHSE_TELNO);
           $("#cus_mpno").val(result_5[0].CUS_MPNO);
           $("#mdongup").val(result_5[0].DONGUP);
           $("#mdongbw").val(result_5[0].DONGBW);
           $("#sra_mwmnnm").val(result_5[0].SRA_MWMNNM);
        	
        //차수
        var results_6 = null; 
   	    results_6 = sendAjaxFrm("frm_Search", "/Lalm0412_selList_MhAucQcn", "POST");

   	    if(results_6.status != RETURN_SUCCESS){
            showErrorMessage(results_6);
            return;
        }else{     
            result_6 = setDecrypt(results_6);
               
              
        }	
        	$("#qcn").val(result_6[0].QCN)	
        
 	    //정산금액
         var results = sendAjaxFrm("frm_Search", "/LALM0412_selListFrm_MdMwmnAdj", "POST");    
        	
         if(results.status != RETURN_SUCCESS){
             showErrorMessage(results);
              return;
         }else{     
             result_3 = setDecrypt(results);
         }
         
         $("#sra_sbid_am").val(fn_toComma(result_3[0].SRA_SBID_AM));
         $("#sra_sel_fee").val(fn_toComma(result_3[0].SRA_SEL_FEE));
         $("#etc_cst").val(fn_toComma(result_3[0].ETC_CST));
         $("#sra_auc_sbid_hdcn").val(fn_toComma(result_3[0].SRA_AUC_SBID_HDCN));
         $("#tot_csh_rv_am").val(fn_toComma(result_3[0].TOT_CSH_RV_AM));
         $("#tot_ck_rv_am").val(fn_toComma(result_3[0].TOT_CK_RV_AM));
         $("#tot_bb_rv_am").val(fn_toComma(result_3[0].TOT_BB_RV_AM));
         $("#tot_etc_rv_am").val(fn_toComma(result_3[0].TOT_ETC_RV_AM));
         $("#auc_entr_grn_am").val(fn_toComma(result_3[0].AUC_ENTR_GRN_AM));
         $("#tot_pym_am").val(fn_toComma(result_3[0].TOT_PYM_AM));
         $("#sra_rv_am").val(fn_toComma(result_3[0].SRA_RV_AM));
         $("#tot_pym_am").val(fn_toComma(result_3[0].TOT_PYM_AM));
         $("#tot_npym_am").val(fn_toComma(result_3[0].TOT_NPYM_AM));
         $("#tot_sra_mwmnnm").val(result_3[0].SRA_MWMNNM);
 
         $("#sra_020").val(result_3[0].SRA_020);
         $("#sra_030").val(result_3[0].SRA_030);
         $("#sra_040").val(result_3[0].SRA_040);
         $("#sra_050").val(result_3[0].SRA_050);
         $("#sra_060").val(result_3[0].SRA_060);
         $("#sra_070").val(result_3[0].SRA_070);
         $("#sra_080").val(result_3[0].SRA_080);
         $("#sra_100").val(result_3[0].SRA_100);
         $("#sra_110").val(result_3[0].SRA_110);
         $("#sra_120").val(result_3[0].SRA_120);
         $("#sra_fee").val(result_3[0].SRA_FEE);
         
 	    //낙찰내역
 	    results = null;
 		results = sendAjaxFrm("frm_Search", "/LALM0412_selListGrd_MhSogCow", "POST");
 		
 	    if(results.status != RETURN_SUCCESS){
 	        showErrorMessage(results,"NOTFOUND");
 	    } else {     
 	    	result_1 = setDecrypt(results);
 	    	fn_CreateGrd_MhSogCow(result_1);
 	    }
 	    
 	   
 	    //입금등록
 	    results = null;
 	    results = sendAjaxFrm("frm_Search", "/LALM0412_selListGrd_MdMwmnAdj", "POST");    
 	    
 	    if(results.status == RETURN_SUCCESS){
 	    	result_2 = setDecrypt(results);
 	    	fn_CreateGrd_MdMwmnAdj(result_2);
 	    }
 	    	    
 	    //경매참가내역
 	    results = null;
 	    results = sendAjaxFrm("frm_Search", "/LALM0412_selAucEntr", "POST");    
 	    
 	    if(results.status == RETURN_SUCCESS){
 	        result_4 = setDecrypt(results);
 	        if(result_4.RTRN_YN == '0'){
 	            $("#sra_mwmnnm").css('background-color', 'white');
 	            $("#pb_Give").attr('disabled', true);
 	            $("#pb_Take").attr('disabled', false);
 	        } else {
 	            $("#sra_mwmnnm").css('background-color', 'yellow');
 	            $("#pb_Give").attr('disabled', false);
	            $("#pb_Take").attr('disabled', true);
 	        }
 	    }
 	    
	 }
	 
	
	////////////////////////////////////////////////////////////////////////////////
	//  공통버튼 클릭함수 종료
	////////////////////////////////////////////////////////////////////////////////
	
	function fn_CreateGrd_MhSogCow(data){
		var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    var searchResultColNames = [
	                                "동이상주소","동이하주소","경제통합사업장코드","경매일자","원표번호"
	    	                       ,"원장일련번호","농가식별번호","농장관리번호","출하경제통합거래처코드","차량단축코드"
	    	                       ,"접수일자","거래인관리번호","가축경매참여자번호","축산축종구분코드"
	    	                       ,"최초최저낙찰한도금액","최저낙찰한도금액","축산낙찰단가"
	    	                       ,"판매상태구분코드","브루셀라검사증명서제출여부","브루셀라검사일자","예정가변경횟수","예방접종일자"
	    	                       ,"가축시장거래처관리번호(수의사)","12개월이상여부","임신감정여부","임신여부"
	    	                       ,"괴사감정여부","괴사여부","운송비지급여부","축산운송비","축산납입출자금"
	    	                       ,"축산가료공급금액","당일접수비용","인공수정일자","인공수정증명서제출여부"
	    	                       ,"제각여부","축산생산자명","출산생산지역명","비고내용"
	    	                       ,"전송여부","삭제여부","최초등록일시","최초등록자개인번호","최종변경일시"
	    	                       ,"최종변경자개인번호","친자검사결과","개체기본경제통합사업장코드", "개체기본출산축종구분코드"
	                               ,"개체기본출산개채관리번호","개체기본농가식별번호","개체기본농장관리번호","생년월일"
	                               ,"KPN번호","산체","계대"
	                               ,"개체식별번호","축산개체종축등록번호", "중도매인명"
	                               ,"출하자동이상주소", "출하자동이상주소","송아지경제통합사업장코드","송아지경매대상구분"
	                               ,"송아지경매일자", "송아지원표번호","송아지등록번호","송아지축산축종구분코드"
	                               ,"송아지우출하중량","송아지KPN번호"
	                               ,"자조금","수수료2","수수료3","수수료4", "수수료5", "정산자명", "정산자번호", "출하주번호",
	                               
	                               "출하주","경매대상","경매번호","귀표번호","성별","등록구분","중량","낙찰가","수수료"
	                               ,"송아지귀표번호","송아지성별","임신개월수","송아지생년월일","출하주생년","어미소축산개체관리번호","어미구분코드","번식우수수료구분코드"
	                              ,"H월령"
	                               
	                              ];        
	    var searchResultColModel = [
	    	
	                                 {name:"dongup",              index:"dongup",              width:90, align:'center', hidden:true},                                 
	                                 {name:"dongbw",              index:"dongbw",              width:90, align:'center', hidden:true},                                 
	                                 {name:"NA_BZPLC",              index:"NA_BZPLC",              width:90, align:'center', hidden:true},                                 
	                                 {name:"AUC_DT",                index:"AUC_DT",                width:40, align:'center', hidden:true},
	                                 {name:"OSLP_NO",               index:"OSLP_NO",               width:40, align:'center', hidden:true},
	                                 {name:"LED_SQNO",              index:"LED_SQNO",              width:40, align:'center', hidden:true},
	                                 {name:"FHS_ID_NO",             index:"FHS_ID_NO",             width:40, align:'center', hidden:true},
	                                 {name:"FARM_AMNNO",            index:"FARM_AMNNO",            width:40, align:'center', hidden:true},
	                                 {name:"SOG_NA_TRPL_C",         index:"SOG_NA_TRPL_C",         width:40, align:'center', hidden:true},
	                                 {name:"VHC_SHRT_C",            index:"VHC_SHRT_C",            width:40, align:'center', hidden:true},
	                                 {name:"RC_DT",                 index:"RC_DT",                 width:40, align:'center', hidden:true},
	                                 {name:"TRMN_AMNNO",            index:"TRMN_AMNNO",            width:40, align:'center', hidden:true},
	                                 {name:"LVST_AUC_PTC_MN_NO",    index:"LVST_AUC_PTC_MN_NO",    width:40, align:'center', hidden:true},
	                                 {name:"SRA_SRS_DSC",           index:"SRA_SRS_DSC",           width:40, align:'center', hidden:true},
	                                 {name:"FIR_LOWS_SBID_LMT_AM",  index:"FIR_LOWS_SBID_LMT_AM",  width:40, align:'center', hidden:true},
	                                 {name:"LOWS_SBID_LMT_AM",      index:"LOWS_SBID_LMT_AM",      width:40, align:'center', hidden:true},
	                                 {name:"SRA_SBID_UPR",          index:"SRA_SBID_UPR",          width:40, align:'center', hidden:true},
	                                 {name:"SEL_STS_DSC",           index:"SEL_STS_DSC",           width:40, align:'center', hidden:true},
	                                 {name:"BRCL_ISP_CTFW_SMT_YN",  index:"BRCL_ISP_CTFW_SMT_YN",  width:40, align:'center', hidden:true},
	                                 {name:"BRCL_ISP_DT",           index:"BRCL_ISP_DT",           width:40, align:'center', hidden:true},
	                                 {name:"LWPR_CHG_NT",           index:"LWPR_CHG_NT",           width:40, align:'center', hidden:true},
	                                 {name:"VACN_DT",               index:"VACN_DT",               width:40, align:'center', hidden:true},
	                                 {name:"LVST_MKT_TRPL_AMNNO",   index:"LVST_MKT_TRPL_AMNNO",   width:40, align:'center', hidden:true},
	                                 {name:"MT12_OVR_YN",           index:"MT12_OVR_YN",           width:40, align:'center', hidden:true},
	                                 //{name:"PPGCOW_FEE_DSC",        index:"PPGCOW_FEE_DSC",        width:40, align:'center', hidden:true},
	                                 {name:"PRNY_JUG_YN",           index:"PRNY_JUG_YN",           width:40, align:'center', hidden:true},
	                                 {name:"PRNY_YN",               index:"PRNY_YN",               width:40, align:'center', hidden:true},
	                                 {name:"NCSS_JUG_YN",           index:"NCSS_JUG_YN",           width:40, align:'center', hidden:true},
	                                 {name:"NCSS_YN",               index:"NCSS_YN",               width:40, align:'center', hidden:true},
	                                 {name:"TRPCS_PY_YN",           index:"TRPCS_PY_YN",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TRPCS",             index:"SRA_TRPCS",             width:40, align:'center', hidden:true},
	                                 {name:"SRA_PYIVA",             index:"SRA_PYIVA",             width:40, align:'center', hidden:true},
	                                 {name:"SRA_FED_SPY_AM",        index:"SRA_FED_SPY_AM",        width:40, align:'center', hidden:true},
	                                 {name:"TD_RC_CST",             index:"TD_RC_CST",             width:40, align:'center', hidden:true},
	                                 {name:"AFISM_MOD_DT",          index:"AFISM_MOD_DT",          width:40, align:'center', hidden:true},
	                                 {name:"AFISM_MOD_CTFW_SMT_YN", index:"AFISM_MOD_CTFW_SMT_YN", width:40, align:'center', hidden:true},
	                                 {name:"RMHN_YN",               index:"RMHN_YN",               width:40, align:'center', hidden:true},
	                                 {name:"SRA_PDMNM",             index:"SRA_PDMNM",             width:40, align:'center', hidden:true},
	                                 {name:"SRA_PD_RGNNM",          index:"SRA_PD_RGNNM",          width:40, align:'center', hidden:true},
	                                 {name:"RMK_CNTN",              index:"RMK_CNTN",              width:40, align:'center', hidden:true},
	                                 {name:"TMS_YN",                index:"TMS_YN",                width:40, align:'center', hidden:true},
	                                 {name:"DEL_YN",                index:"DEL_YN",                width:40, align:'center', hidden:true},
	                                 {name:"FSRG_DTM",              index:"FSRG_DTM",              width:40, align:'center', hidden:true},
	                                 {name:"FSRGMN_ENO",            index:"FSRGMN_ENO",            width:40, align:'center', hidden:true},
	                                 {name:"LSCHG_DTM",             index:"LSCHG_DTM",             width:40, align:'center', hidden:true},
	                                 {name:"LS_CMENO",              index:"LS_CMENO",              width:40, align:'center', hidden:true},
	                                 {name:"DNA_YN",                index:"DNA_YN",                width:40, align:'center', hidden:true},
	                                 {name:"INDV_NA_BZPLC",         index:"INDV_NA_BZPLC",         width:40, align:'center', hidden:true},
	                                 {name:"INDV_SRA_SRS_DSC",      index:"INDV_SRA_SRS_DSC",      width:40, align:'center', hidden:true},
	                                 {name:"INDV_SRA_INDV_AMNNO",   index:"INDV_SRA_INDV_AMNNO",   width:40, align:'center', hidden:true},
	                                 {name:"INDV_FHS_ID_NO",        index:"INDV_FHS_ID_NO",        width:40, align:'center', hidden:true},
	                                 {name:"INDV_FARM_AMNNO",       index:"INDV_FARM_AMNNO",       width:40, align:'center', hidden:true},
	                                 {name:"BIRTH",                 index:"BIRTH",                 width:40, align:'center', hidden:true},
	                                 {name:"KPN_NO",                index:"KPN_NO",                width:40, align:'center', hidden:true},
	                                 {name:"MATIME",                index:"MATIME",                width:40, align:'center', hidden:true},
	                                 {name:"SRA_INDV_PASG_QCN",     index:"SRA_INDV_PASG_QCN",     width:40, align:'center', hidden:true},
	                                 {name:"INDV_ID_NO",            index:"INDV_ID_NO",            width:40, align:'center', hidden:true},
	                                 {name:"SRA_INDV_BRDSRA_RG_NO", index:"SRA_INDV_BRDSRA_RG_NO", width:40, align:'center', hidden:true},
	                                 {name:"SRA_MWMNNM",            index:"SRA_MWMNNM",            width:40, align:'center', hidden:true},
	                                 {name:"DONGUP",                index:"DONGUP",                width:40, align:'center', hidden:true},
	                                 {name:"DONGBW",                index:"DONGBW",                width:40, align:'center', hidden:true},
	                                 {name:"CALF_NA_BZPLC",         index:"CALF_NA_BZPLC",         width:40, align:'center', hidden:true},
	                                 {name:"CALF_AUC_OBJ_DSC",      index:"CALF_AUC_OBJ_DSC",      width:40, align:'center', hidden:true},
	                                 {name:"CALF_AUC_DT",           index:"CALF_AUC_DT",           width:40, align:'center', hidden:true},
	                                 {name:"CALF_OSLP_NO",          index:"CALF_OSLP_NO",          width:40, align:'center', hidden:true},
	                                 {name:"CALF_RG_SQNO",          index:"CALF_RG_SQNO",          width:40, align:'center', hidden:true},
	                                 {name:"CALF_SRA_SRS_DSC",      index:"CALF_SRA_SRS_DSC",      width:40, align:'center', hidden:true},
	                                 {name:"CALF_COW_SOG_WT",       index:"CALF_COW_SOG_WT",       width:40, align:'center', hidden:true},
	                                 {name:"CALF_KPN_NO",           index:"CALF_KPN_NO",           width:40, align:'center', hidden:true},
	                                 {name:"JAJOKUM",               index:"JAJOKUM",               width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE2",           index:"SRA_TR_FEE2",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE3",           index:"SRA_TR_FEE3",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE4",           index:"SRA_TR_FEE4",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE5",           index:"SRA_TR_FEE5",           width:40, align:'center', hidden:true},
	                                 {name:"AMNNM",           		index:"AMNNM",           	   width:40, align:'center', hidden:true},
	                                 {name:"AMNNO",           		index:"AMNNO",           	   width:40, align:'center', hidden:true},
	                                 {name:"TRMN_AMNNO",           	index:"TRMN_AMNNO",            width:40, align:'center', hidden:true},
	
	                                 {name:"FTSNM",                 index:"FTSNM",                 width:40, align:'center'},
	                                 {name:"AUC_OBJ_DSC",           index:"AUC_OBJ_DSC",           width:40, align:'center', edittype:"select", formatter : "select",editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
	                                 {name:"AUC_PRG_SQ",            index:"AUC_PRG_SQ",            width:40, align:'center', sorttype: "number", formatter:'integer'},
	                                 {name:"COW_SRA_INDV_AMNNO",    index:"COW_SRA_INDV_AMNNO",    width:60, align:'center', formatter:'gridIndvFormat'},
	                                 {name:"INDV_SEX_C",            index:"INDV_SEX_C",            width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},

	                                 {name:"RG_DSC",                index:"RG_DSC",                width:40, align:'center', align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}, hidden:true},
	                                 {name:"COW_SOG_WT",            index:"COW_SOG_WT",            width:40, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SBID_AM",           index:"SRA_SBID_AM",           width:40, align:'right', sorttype: "number", formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
	                                 {name:"SRA_TR_FEE",            index:"SRA_TR_FEE",            width:40, align:'center', sorttype: "number", formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
	                                 {name:"CALF_SRA_INDV_AMNNO",   index:"CALF_SRA_INDV_AMNNO",   width:40, align:'center'},
	                                 {name:"CALF_INDV_SEX_C",       index:"CALF_INDV_SEX_C",       width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"PRNY_MTCN",             index:"PRNY_MTCN",             width:40, align:'center'},
	                                 {name:"CALF_BIRTH",            index:"CALF_BIRTH",            width:40, align:'center', formatter:'gridDateFormat'},
	                                 {name:"RMK_CNTN_BIRTH",        index:"RMK_CNTN_BIRTH",        width:40, align:'center', formatter:'gridDateFormat'},
	                                 {name:"MCOW_SRA_INDV_AMNNO",   index:"MCOW_SRA_INDV_AMNNO",   width:60, align:'center', formatter:'gridIndvFormat', hidden:true},
	                                 {name:"MCOW_DSC",              index:"MCOW_DSC",              width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}, hidden:true},
	                                 {name:"PPGCOW_FEE_DSC",        index:"PPGCOW_FEE_DSC",        width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
	                                 {name:"MTCN",             		index:"MTCN",             	   width:40, align:'center'},
	                                ];
	        
	    $("#grd_MhSogCow").jqGrid("GridUnload");
	            
	    $("#grd_MhSogCow").jqGrid({
	        datatype:    "local",
	        data:        data,
	        height:      200,
	        rowNum:      rowNoValue,
	        resizeing:   true,
	        autowidth:   true,
	        shrinkToFit: false, 
	        rownumbers:true,
	        rownumWidth:30,
	        colNames: searchResultColNames,
	        colModel: searchResultColModel,
	    });    
	
	    //행번호
	    $("#grd_MhSogCow").jqGrid("setLabel", "rn","No");
	    
	    var gridDatatemp = $('#grd_MhSogCow').getRowData();
	    fCnt = 0;
	    mCnt = 0;
	    
		$.each(gridDatatemp, function(i){
			if(gridDatatemp[i].INDV_SEX_C == "1" || gridDatatemp[i].INDV_SEX_C == "4" || gridDatatemp[i].INDV_SEX_C == "6") {
				fCnt++;
			} else {
				mCnt++;
			}
        });
	}
	
	// 정산서(암,수 구분)출력 그리드
	function fn_CreateGrd_HdnMhSogCow(data, TitleData) {
		var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    var searchResultColNames = [
	                                "동이상주소","동이하주소","경제통합사업장코드","경매일자","원표번호"
	    	                       ,"원장일련번호","농가식별번호","농장관리번호","출하경제통합거래처코드","차량단축코드"
	    	                       ,"접수일자","거래인관리번호","가축경매참여자번호","축산축종구분코드"
	    	                       ,"최초최저낙찰한도금액","최저낙찰한도금액","축산낙찰단가"
	    	                       ,"판매상태구분코드","브루셀라검사증명서제출여부","브루셀라검사일자","예정가변경횟수","예방접종일자"
	    	                       ,"가축시장거래처관리번호(수의사)","12개월이상여부","임신감정여부","임신여부"
	    	                       ,"괴사감정여부","괴사여부","운송비지급여부","축산운송비","축산납입출자금"
	    	                       ,"축산가료공급금액","당일접수비용","인공수정일자","인공수정증명서제출여부"
	    	                       ,"제각여부","축산생산자명","출산생산지역명","비고내용"
	    	                       ,"전송여부","삭제여부","최초등록일시","최초등록자개인번호","최종변경일시"
	    	                       ,"최종변경자개인번호","친자검사결과","개체기본경제통합사업장코드", "개체기본출산축종구분코드"
	                               ,"개체기본출산개채관리번호","개체기본농가식별번호","개체기본농장관리번호","생년월일"
	                               ,"KPN번호","산체","계대"
	                               ,"개체식별번호","축산개체종축등록번호", "중도매인명"
	                               ,"출하자동이상주소", "출하자동이상주소","송아지경제통합사업장코드","송아지경매대상구분"
	                               ,"송아지경매일자", "송아지원표번호","송아지등록번호","송아지축산축종구분코드"
	                               ,"송아지우출하중량","송아지KPN번호"
	                               ,"자조금","수수료2","수수료3","수수료4", "수수료5", "정산자명", "정산자번호", "출하주번호",
	                               "출하주","경매대상","경매번호","귀표번호","성별","등록구분","중량","낙찰가","수수료"
	                               ,"송아지귀표번호","송아지성별","임신개월수","송아지생년월일","출하주생년","어미소축산개체관리번호","어미구분코드","번식우수수료구분코드"
	                              
	                              ];        
	    var searchResultColModel = [
	    	
	                                 {name:"dongup",              index:"dongup",              width:90, align:'center', hidden:true},                                 
	                                 {name:"dongbw",              index:"dongbw",              width:90, align:'center', hidden:true},                                 
	                                 {name:"NA_BZPLC",              index:"NA_BZPLC",              width:90, align:'center', hidden:true},                                 
	                                 {name:"AUC_DT",                index:"AUC_DT",                width:40, align:'center', hidden:true},
	                                 {name:"OSLP_NO",               index:"OSLP_NO",               width:40, align:'center', hidden:true},
	                                 {name:"LED_SQNO",              index:"LED_SQNO",              width:40, align:'center', hidden:true},
	                                 {name:"FHS_ID_NO",             index:"FHS_ID_NO",             width:40, align:'center', hidden:true},
	                                 {name:"FARM_AMNNO",            index:"FARM_AMNNO",            width:40, align:'center', hidden:true},
	                                 {name:"SOG_NA_TRPL_C",         index:"SOG_NA_TRPL_C",         width:40, align:'center', hidden:true},
	                                 {name:"VHC_SHRT_C",            index:"VHC_SHRT_C",            width:40, align:'center', hidden:true},
	                                 {name:"RC_DT",                 index:"RC_DT",                 width:40, align:'center', hidden:true},
	                                 {name:"TRMN_AMNNO",            index:"TRMN_AMNNO",            width:40, align:'center', hidden:true},
	                                 {name:"LVST_AUC_PTC_MN_NO",    index:"LVST_AUC_PTC_MN_NO",    width:40, align:'center', hidden:true},
	                                 {name:"SRA_SRS_DSC",           index:"SRA_SRS_DSC",           width:40, align:'center', hidden:true},
	                                 {name:"FIR_LOWS_SBID_LMT_AM",  index:"FIR_LOWS_SBID_LMT_AM",  width:40, align:'center', hidden:true},
	                                 {name:"LOWS_SBID_LMT_AM",      index:"LOWS_SBID_LMT_AM",      width:40, align:'center', hidden:true},
	                                 {name:"SRA_SBID_UPR",          index:"SRA_SBID_UPR",          width:40, align:'center', hidden:true},
	                                 {name:"SEL_STS_DSC",           index:"SEL_STS_DSC",           width:40, align:'center', hidden:true},
	                                 {name:"BRCL_ISP_CTFW_SMT_YN",  index:"BRCL_ISP_CTFW_SMT_YN",  width:40, align:'center', hidden:true},
	                                 {name:"BRCL_ISP_DT",           index:"BRCL_ISP_DT",           width:40, align:'center', hidden:true},
	                                 {name:"LWPR_CHG_NT",           index:"LWPR_CHG_NT",           width:40, align:'center', hidden:true},
	                                 {name:"VACN_DT",               index:"VACN_DT",               width:40, align:'center', hidden:true},
	                                 {name:"LVST_MKT_TRPL_AMNNO",   index:"LVST_MKT_TRPL_AMNNO",   width:40, align:'center', hidden:true},
	                                 {name:"MT12_OVR_YN",           index:"MT12_OVR_YN",           width:40, align:'center', hidden:true},
	                                 //{name:"PPGCOW_FEE_DSC",        index:"PPGCOW_FEE_DSC",        width:40, align:'center', hidden:true},
	                                 {name:"PRNY_JUG_YN",           index:"PRNY_JUG_YN",           width:40, align:'center', hidden:true},
	                                 {name:"PRNY_YN",               index:"PRNY_YN",               width:40, align:'center', hidden:true},
	                                 {name:"NCSS_JUG_YN",           index:"NCSS_JUG_YN",           width:40, align:'center', hidden:true},
	                                 {name:"NCSS_YN",               index:"NCSS_YN",               width:40, align:'center', hidden:true},
	                                 {name:"TRPCS_PY_YN",           index:"TRPCS_PY_YN",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TRPCS",             index:"SRA_TRPCS",             width:40, align:'center', hidden:true},
	                                 {name:"SRA_PYIVA",             index:"SRA_PYIVA",             width:40, align:'center', hidden:true},
	                                 {name:"SRA_FED_SPY_AM",        index:"SRA_FED_SPY_AM",        width:40, align:'center', hidden:true},
	                                 {name:"TD_RC_CST",             index:"TD_RC_CST",             width:40, align:'center', hidden:true},
	                                 {name:"AFISM_MOD_DT",          index:"AFISM_MOD_DT",          width:40, align:'center', hidden:true},
	                                 {name:"AFISM_MOD_CTFW_SMT_YN", index:"AFISM_MOD_CTFW_SMT_YN", width:40, align:'center', hidden:true},
	                                 {name:"RMHN_YN",               index:"RMHN_YN",               width:40, align:'center', hidden:true},
	                                 {name:"SRA_PDMNM",             index:"SRA_PDMNM",             width:40, align:'center', hidden:true},
	                                 {name:"SRA_PD_RGNNM",          index:"SRA_PD_RGNNM",          width:40, align:'center', hidden:true},
	                                 {name:"RMK_CNTN",              index:"RMK_CNTN",              width:40, align:'center', hidden:true},
	                                 {name:"TMS_YN",                index:"TMS_YN",                width:40, align:'center', hidden:true},
	                                 {name:"DEL_YN",                index:"DEL_YN",                width:40, align:'center', hidden:true},
	                                 {name:"FSRG_DTM",              index:"FSRG_DTM",              width:40, align:'center', hidden:true},
	                                 {name:"FSRGMN_ENO",            index:"FSRGMN_ENO",            width:40, align:'center', hidden:true},
	                                 {name:"LSCHG_DTM",             index:"LSCHG_DTM",             width:40, align:'center', hidden:true},
	                                 {name:"LS_CMENO",              index:"LS_CMENO",              width:40, align:'center', hidden:true},
	                                 {name:"DNA_YN",                index:"DNA_YN",                width:40, align:'center', hidden:true},
	                                 {name:"INDV_NA_BZPLC",         index:"INDV_NA_BZPLC",         width:40, align:'center', hidden:true},
	                                 {name:"INDV_SRA_SRS_DSC",      index:"INDV_SRA_SRS_DSC",      width:40, align:'center', hidden:true},
	                                 {name:"INDV_SRA_INDV_AMNNO",   index:"INDV_SRA_INDV_AMNNO",   width:40, align:'center', hidden:true},
	                                 {name:"INDV_FHS_ID_NO",        index:"INDV_FHS_ID_NO",        width:40, align:'center', hidden:true},
	                                 {name:"INDV_FARM_AMNNO",       index:"INDV_FARM_AMNNO",       width:40, align:'center', hidden:true},
	                                 {name:"BIRTH",                 index:"BIRTH",                 width:40, align:'center', hidden:true},
	                                 {name:"KPN_NO",                index:"KPN_NO",                width:40, align:'center', hidden:true},
	                                 {name:"MATIME",                index:"MATIME",                width:40, align:'center', hidden:true},
	                                 {name:"SRA_INDV_PASG_QCN",     index:"SRA_INDV_PASG_QCN",     width:40, align:'center', hidden:true},
	                                 {name:"INDV_ID_NO",            index:"INDV_ID_NO",            width:40, align:'center', hidden:true},
	                                 {name:"SRA_INDV_BRDSRA_RG_NO", index:"SRA_INDV_BRDSRA_RG_NO", width:40, align:'center', hidden:true},
	                                 {name:"SRA_MWMNNM",            index:"SRA_MWMNNM",            width:40, align:'center', hidden:true},
	                                 {name:"DONGUP",                index:"DONGUP",                width:40, align:'center', hidden:true},
	                                 {name:"DONGBW",                index:"DONGBW",                width:40, align:'center', hidden:true},
	                                 {name:"CALF_NA_BZPLC",         index:"CALF_NA_BZPLC",         width:40, align:'center', hidden:true},
	                                 {name:"CALF_AUC_OBJ_DSC",      index:"CALF_AUC_OBJ_DSC",      width:40, align:'center', hidden:true},
	                                 {name:"CALF_AUC_DT",           index:"CALF_AUC_DT",           width:40, align:'center', hidden:true},
	                                 {name:"CALF_OSLP_NO",          index:"CALF_OSLP_NO",          width:40, align:'center', hidden:true},
	                                 {name:"CALF_RG_SQNO",          index:"CALF_RG_SQNO",          width:40, align:'center', hidden:true},
	                                 {name:"CALF_SRA_SRS_DSC",      index:"CALF_SRA_SRS_DSC",      width:40, align:'center', hidden:true},
	                                 {name:"CALF_COW_SOG_WT",       index:"CALF_COW_SOG_WT",       width:40, align:'center', hidden:true},
	                                 {name:"CALF_KPN_NO",           index:"CALF_KPN_NO",           width:40, align:'center', hidden:true},
	                                 {name:"JAJOKUM",               index:"JAJOKUM",               width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE2",           index:"SRA_TR_FEE2",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE3",           index:"SRA_TR_FEE3",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE4",           index:"SRA_TR_FEE4",           width:40, align:'center', hidden:true},
	                                 {name:"SRA_TR_FEE5",           index:"SRA_TR_FEE5",           width:40, align:'center', hidden:true},
	                                 {name:"AMNNM",           		index:"AMNNM",           	   width:40, align:'center', hidden:true},
	                                 {name:"AMNNO",           		index:"AMNNO",           	   width:40, align:'center', hidden:true},
	                                 {name:"TRMN_AMNNO",           	index:"TRMN_AMNNO",            width:40, align:'center', hidden:true},
	                                 {name:"FTSNM",                 index:"FTSNM",                 width:40, align:'center'},
	                                 {name:"AUC_OBJ_DSC",           index:"AUC_OBJ_DSC",           width:40, align:'center', edittype:"select", formatter : "select",editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
	                                 {name:"AUC_PRG_SQ",            index:"AUC_PRG_SQ",            width:40, align:'center', sorttype: "number", formatter:'integer'},
	                                 {name:"COW_SRA_INDV_AMNNO",    index:"COW_SRA_INDV_AMNNO",    width:60, align:'center', formatter:'gridIndvFormat'},
	                                 {name:"INDV_SEX_C",            index:"INDV_SEX_C",            width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"RG_DSC",                index:"RG_DSC",                width:40, align:'center', align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	                                 {name:"COW_SOG_WT",            index:"COW_SOG_WT",            width:40, align:'right', formatter:'integer', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
	                                 {name:"SRA_SBID_AM",           index:"SRA_SBID_AM",           width:40, align:'right', sorttype: "number", formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
	                                 {name:"SRA_TR_FEE",            index:"SRA_TR_FEE",            width:40, align:'center', sorttype: "number", formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
	                                 {name:"CALF_SRA_INDV_AMNNO",   index:"CALF_SRA_INDV_AMNNO",   width:40, align:'center'},
	                                 {name:"CALF_INDV_SEX_C",       index:"CALF_INDV_SEX_C",       width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
	                                 {name:"PRNY_MTCN",             index:"PRNY_MTCN",             width:40, align:'center'},
	                                 {name:"RMK_CNTN_BIRTH",        index:"RMK_CNTN_BIRTH",        width:40, align:'center', formatter:'gridDateFormat'},
	                                 {name:"CALF_BIRTH",            index:"CALF_BIRTH",            width:40, align:'center', formatter:'gridDateFormat'},
	                                 {name:"MCOW_SRA_INDV_AMNNO",   index:"MCOW_SRA_INDV_AMNNO",   width:60, align:'center', formatter:'gridIndvFormat'},
	                                 {name:"MCOW_DSC",              index:"MCOW_DSC",              width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
	                                 {name:"PPGCOW_FEE_DSC",        index:"PPGCOW_FEE_DSC",        width:30, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
	                                 ];
	        
	    $("#grd_HdnMhSogCow").jqGrid("GridUnload");
	            
	    $("#grd_HdnMhSogCow").jqGrid({
	        datatype:    "local",
	        data:        data,
	        height:      200,
	        rowNum:      rowNoValue,
	        resizeing:   true,
	        autowidth:   true,
	        shrinkToFit: false, 
	        rownumbers:true,
	        rownumWidth:30,
			gridComplete: function(rowid, status, e) {
				fn_BtnAdj_fm_print(TitleData, "grd_HdnMhSogCow");
	        },
	        colNames: searchResultColNames,
	        colModel: searchResultColModel,
	    });    
	
	    //행번호
	    $("#grd_HdnMhSogCow").jqGrid("setLabel", "rn","No");
	}
	
	
	function fn_CreateGrd_MdMwmnAdj(data){
		var rowNoValue = 0;     
	    if(data != null){
	        rowNoValue = data.length;
	    }
	    var searchResultColNames = [
	    							"H조합출자금","H사고적립금","H운송비","H괴사감정료","H임신감정료","H검진비","H주사료","H혈통접수비","H제각수수료","H위탁수수료"
	    	                       ,"H현금입금액","H수표입금액","H통장입금액","H기타입금액","H축산낙찰금액","H축산판매수수료","H총납입할금액","H미납입금액"
	    	                       ,"경제통합사업장코드","거래인관리번호","경매대상구분","경매일자","입금일련번호"
	    	                       ,"전송여부","삭제여부","최초등록일시","최초등록자개인번호","최종변경일시","최종변경자개인번호"
	    	                       ,"입금일자","입금종류","입금액","비고"
	                              
	                              ];        
	    var searchResultColModel = [
	                                                                
	                                 {name:"SRA_020",       index:"SRA_020",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_030",       index:"SRA_030",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_040",       index:"SRA_040",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_050",       index:"SRA_050",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_060",       index:"SRA_060",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_070",       index:"SRA_070",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_080",       index:"SRA_080",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_100",       index:"SRA_100",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_110",       index:"SRA_110",           width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_120",       index:"SRA_120",           width:90, align:'center', hidden:true},                                 
	                                 {name:"TOT_CSH_RV_AM", index:"TOT_CSH_RV_AM",     width:90, align:'center', hidden:true},                                 
	                                 {name:"TOT_CK_RV_AM",  index:"TOT_CK_RV_AM",      width:90, align:'center', hidden:true},                                 
	                                 {name:"TOT_BB_RV_AM",  index:"TOT_BB_RV_AM",      width:90, align:'center', hidden:true},                                 
	                                 {name:"TOT_ETC_RV_AM", index:"TOT_ETC_RV_AM",     width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_SBID_AM",   index:"SRA_SBID_AM",       width:90, align:'center', hidden:true},                                 
	                                 {name:"SRA_SEL_FEE",   index:"SRA_SEL_FEE",       width:90, align:'center', hidden:true},                                 
	                                 {name:"TOT_PYM_AM",    index:"TOT_PYM_AM",        width:90, align:'center', hidden:true},                                 
	                                 {name:"TOT_NPYM_AM",   index:"TOT_NPYM_AM",       width:90, align:'center', hidden:true},                                 
	                                 {name:"NA_BZPLC",      index:"NA_BZPLC",          width:90, align:'center', hidden:true},                                 
	                                 {name:"TRMN_AMNNO",    index:"TRMN_AMNNO",        width:40, align:'center', hidden:true},
	                                 {name:"AUC_OBJ_DSC",   index:"AUC_OBJ_DSC",       width:40, align:'center', hidden:true},
	                                 {name:"AUC_DT",        index:"AUC_DT",            width:40, align:'center', hidden:true},
	                                 {name:"RV_SQNO",       index:"RV_SQNO",           width:40, align:'center', hidden:true}, 
	                                 {name:"TMS_YN",        index:"TMS_YN",            width:40, align:'center', hidden:true},
	                                 {name:"DEL_YN",        index:"DEL_YN",            width:40, align:'center', hidden:true},
	                                 {name:"FSRG_DTM",      index:"FSRG_DTM",          width:40, align:'center', hidden:true},
	                                 {name:"FSRGMN_ENO",    index:"FSRGMN_ENO",        width:40, align:'center', hidden:true},
	                                 {name:"LSCHG_DTM",     index:"LSCHG_DTM",         width:40, align:'center', hidden:true},
	                                 {name:"LS_CMENO",      index:"LS_CMENO",          width:40, align:'center', hidden:true},
	                                                                            
	                                 {name:"RV_DT",         index:"RV_DT",             width:40, align:'center', formatter:'gridDateFormat'},
	                                 {name:"SRA_RV_TPC",    index:"SRA_RV_TPC",        width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_RV_TPC", 1)}},
	                                 {name:"SRA_RV_AM",     index:"SRA_RV_AM",         width:40, align:'center', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
	                                 {name:"RMK_CNTN",      index:"RMK_CNTN",          width:40, align:'center'},
	                                 
	                                 
	                                ];
	
	    
	    $("#grd_MdMwmnAdj").jqGrid("GridUnload");
	            
	    $("#grd_MdMwmnAdj").jqGrid({
	        datatype:    "local",
	        data:        data,
	        height:      120,
	        rowNum:      rowNoValue,
	        resizeing:   true,
	        autowidth:   true,
	        shrinkToFit: false, 
	        rownumbers:true,
	        rownumWidth:30,
	        colNames: searchResultColNames,
	        colModel: searchResultColModel,
	        onSelectRow: function(rowid, status, e){
                var sel_data = $("#grd_MdMwmnAdj").getRowData(rowid);
                if(LALM0412_isFrmOrgData != null && fn_IsChangeFrm()){
                    MessagePopup('YESNO',"변경중이 내용이 있습니다. 선택하시겠습니까?",function(res){                          
                        if(res){
                        	fn_SetFrm_Rv(sel_data);             
                        }                            
                    });
                }else{
                	fn_SetFrm_Rv(sel_data);
                }
                $("#de_chg_yn").val("1");
            },	        
	    });    
	
	    //행번호
	    $("#grd_MdMwmnAdj").jqGrid("setLabel", "rn","No");
	}
	
	
	//폼 오리진 데이터 생성
    function fn_orgFormValue(){
    	LALM0412_isFrmOrgData = $("#srchFrm_detail").serialize();
    }
    
    //폼 변경 체크
    function fn_IsChangeFrm(){
        var isFrmData = $("#srchFrm_detail").serialize();
        if(LALM0412_isFrmOrgData != isFrmData){
            return true;
        }
        return false;
    }
    
    function fn_SetFrm_Rv(sel_data){
    	
    	 $("#de_rv_dt").datepicker().datepicker("setDate", fn_toDate(sel_data.RV_DT));
         fn_setChgRadio("de_sra_rv_tpc", sel_data.SRA_RV_TPC);
         fn_setRadioChecked("de_sra_rv_tpc");
         $("#de_sra_rv_am").val(fn_toComma(sel_data.SRA_RV_AM));
         $("#de_rmk_cntn").val(sel_data.RMK_CNTN);
         $("#de_trmn_amnno").val(sel_data.TRMN_AMNNO);
         $("#de_auc_obj_dsc").val(sel_data.AUC_OBJ_DSC);
         $("#de_auc_dt").val(sel_data.AUC_DT);
         $("#de_lvst_auc_ptc_mn_no").val($("#de_lvst_auc_ptc_mn_no").val());
         $("#de_rv_sqno").val(sel_data.RV_SQNO);
         
         $("#pb_RvWrite").attr('disabled', false);
         $("#pb_RvDelete").attr('disabled', false);
         
         fn_orgFormValue();
    	
    }
	
	
	function fn_BtnGive(){
		MessagePopup('YESNO',"응찰기를 지급하시겠습니까?",function(res){
	        if(res){
	            var results = sendAjaxFrm('frm_Search', "/LALM0412_updEntrGive", "POST");  
	            if(results.status != RETURN_SUCCESS){
	                showErrorMessage(results);
	                return;
	            }else{          
	                MessagePopup("OK", "응찰기가 지급되었습니다.", function(res){
	                	fn_Search();
	                	$("#pb_Give").attr('disabled', true);
	                });
	            }      
	        }else{
	            MessagePopup('OK','취소되었습니다.');
	        }
	    });
	}
	
	function fn_BtnTake(){
		MessagePopup('YESNO',"응찰기를 반납하시겠습니까?",function(res){
	        if(res){
	            var results = sendAjaxFrm('frm_Search', "/LALM0412_updEntrTake", "POST");  
	            if(results.status != RETURN_SUCCESS){
	                showErrorMessage(results);
	                return;
	            }else{          
	                MessagePopup("OK", "응찰기가 반납되었습니다.", function(res){
	                	fn_Search();
	                    $("#pb_Take").attr('disabled', true);
	                });
	            }      
	        }else{
	            MessagePopup('OK','취소되었습니다.');
	        }
	    });
	}
	
	function fn_BtnInit(){
		fn_InitFrm('srchFrm_detail');
		$("#de_rv_dt").val(fn_getToday());
		$("#de_auc_obj_dsc").val($("#auc_obj_dsc").val());
		$("#de_auc_dt").val($("#auc_dt").val());
		fn_setChgRadio("de_sra_rv_tpc", '1');
        fn_setRadioChecked("de_sra_rv_tpc");
		$("#de_trmn_amnno").val($("#trmn_amnno").val());
		$("#de_lvst_auc_ptc_mn_no").val($("#lvst_auc_ptc_mn_no").val());
        $("#de_chg_yn").val("0");
        
		$("#pb_RvWrite").attr('disabled', false);
		$("#pb_RvDelete").attr('disabled', true);
	}
	
	function fn_BtnWrite(){	
		
       	if(fn_isDate($("#de_rv_dt").val()) == false){
               MessagePopup('OK','입금일자가 날짜형식에 맞지 않습니다.',null,function(){
                   $("#de_rv_dt").focus();
               });
               return;
           }            
           if($("#de_sra_rv_am").val() == 0){
               MessagePopup('OK','입금액을 입력하세요.',null,function(){
                   $("#de_sra_rv_am").focus();
               });
               return;
           }        	
       	MessagePopup('YESNO',"저장하시겠습니까?",function(res){
               if(res){                	
               	var insUrl = "";
               	//수정
               	if($("#de_chg_yn").val() == '1'){
               		insUrl = "/LALM0412_updRv";
               	//신규	
               	}else{
               		insUrl = "/LALM0412_insRv";
               	}
                   var results = sendAjaxFrm('srchFrm_detail', insUrl, "POST");
                   
                   if(results.status != RETURN_SUCCESS){
                       showErrorMessage(results);
                       return;
                   }else{          
                       MessagePopup("OK", "저장되었습니다.", function(res){
                       	fn_Search();
                       	$("#pb_RvWrite").attr('disabled', true);
                       });
                   }
               }else{
                   MessagePopup('OK','취소되었습니다.');
               }
           });
        
	}
	
	function fn_BtnDelete(){
		if(fn_isNull($( "#de_rv_sqno" ).val()) == true) {
			MessagePopup('OK','삭제할 내역을 선택해주세요.');
			return;
		}
		MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
            if(res){                    
                var results = sendAjaxFrm('srchFrm_detail', "/LALM0412_delRv", "POST");
                
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.", function(res){
                        fn_Search();
                        $("#pb_RvWrite").attr('disabled', true);
                    });
                }
            }else{
                MessagePopup('OK','취소되었습니다.');
            }
        });
    }
	
	function fn_BtnGrmy(){
		var chk_am = $("#auc_entr_grn_am").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
		
		if(chk_am > 0){
			if(fn_isNull($( "#de_sra_rv_tpc" ).val()) == true) {
				MessagePopup('OK','보증입금액 입금종류를 선택하세요.');
	            return;
			}
			
			var tot_am = $("#tot_pym_am").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
			var auc_am = $("#auc_entr_grn_am").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');

	        var grd_data = $("#grd_MdMwmnAdj").getRowData();
	        var sum_sra_am = 0;
	        $.each(grd_data, function(i){
	        	sum_sra_am += grd_data[i].SRA_RV_AM;
	        });
            
	       
	        
			if(parseInt(tot_am) < (parseInt(sum_sra_am) + parseInt(auc_am))){
                MessagePopup('OK','총입금액이 총납입금액보다 큽니다.');
                return;
			}
			
			var results = sendAjaxFrm('frm_Search', "/LALM0412_selRmkcntn", "POST");
			var result_cntn;
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            }else{
            	result_cntn = setDecrypt(results);
            }
            
            if(parseInt(result_cntn.RMK_CNTN_CNT) > 0){
            	MessagePopup('OK','이미 보증금입금 처리를 하셨습니다.');
                return;
            }
            
			MessagePopup('YESNO',"보증금을 입금하시겠습니까?",function(res){
	            if(res){                    
	            	
	            	var data = new Object();
	            	data["trmn_amnno"]      = $("#trmn_amnno").val();
	            	data["auc_obj_dsc"]     = $("#auc_obj_dsc").val();
	            	data["auc_dt"]          = $("#auc_dt").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
	            	data["sra_rv_tpc"]      = $("#de_sra_rv_tpc").val();
	            	data["auc_entr_grn_am"] = $("#de_sra_rv_am").val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
	            	
	                var results = sendAjax(data, "/LALM0412_insAdj", "POST");
	                if(results.status != RETURN_SUCCESS){
	                    showErrorMessage(results);
	                    return;
	                }else{          
	                    MessagePopup("OK", "입금되었습니다.", function(res){
	                        fn_Search();
	                    });
	                }
	            }else{
	                MessagePopup('OK','취소되었습니다.')
	            }
	        });
		}else{
			MessagePopup('OK','경매참가보증금이 없습니다.');
			return;
		}
	}
	
	
	
	function fn_BtnAdj(){
			
		   acno = parent.wmcList.ACNO;
		   var TitleData = new Object();
	       TitleData.title = "응찰자 개별정산서 제 "+ $("#qcn").val() +" 차 "+ fn_deleteNumber($( "#auc_obj_dsc option:selected").text()) + " (" +fn_toDate(fn_dateToData($('#auc_dt').val()), "KR") + ")" ;
	       TitleData.sub_title = "(기준일자 : "+$('#auc_dt').val()+ ")";
	       TitleData.unit = "";
	       TitleData.tot_pym_am = $("#tot_pym_am").val();
	       TitleData.tot_npym_am = $("#tot_npym_am").val();
	       TitleData.sra_sel_fee = $("#sra_sel_fee").val();
	       TitleData.sra_sbid_am = $("#sra_sbid_am").val();
	       TitleData.sra_rv_am = $("#sra_rv_am").val();
	       TitleData.tot_etc_rv_am = $("#tot_etc_rv_am").val();
	       TitleData.tot_csh_rv_am = $("#tot_csh_rv_am").val();
	       TitleData.tot_ck_rv_am = $("#tot_ck_rv_am").val();
	       TitleData.tot_bb_rv_am = $("#tot_bb_rv_am").val();
	       TitleData.sra_020 = $("#sra_020").val();
	       TitleData.sra_030 = $("#sra_030").val();
	       TitleData.sra_040 = $("#sra_040").val();
	       TitleData.sra_050 = $("#sra_050").val();
	       TitleData.sra_060 = $("#sra_060").val();
	       TitleData.sra_070 = $("#sra_070").val();
	       TitleData.sra_080 = $("#sra_080").val();
	       TitleData.sra_100 = $("#sra_100").val();
	       TitleData.sra_110 = $("#sra_110").val();
	       TitleData.sra_120 = $("#sra_120").val();
	       TitleData.etc_cst = $("#etc_cst").val();
	       TitleData.sra_fee = $("#sra_fee").val();
	       TitleData.sra_shnm = $("#sra_shnm").val();
	       TitleData.dong     = fn_xxsDecode($("#mdongup").val()+" "+$("#mdongbw").val()); 

	       TitleData.sra_mwmnnm = $("#tot_sra_mwmnnm").val();
	     
	       TitleData.acno = parent.wmcList[0].ACNO;
	       TitleData.clntnm = parent.wmcList[0].NA_BZPLNM;
	       TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM + " 조합장 ";
	       TitleData.sealImg = parent.wmcList[0].SEAL_IMG_CNTN;
	       TitleData.rmk_cntn = parent.wmcList[0].RMK_CNTN;
	       TitleData.tel_no = parent.wmcList[0].TELNO;
	       
	       TitleData.srch_condition =  '[경매일자 : ' + $('#auc_dt').val() + ']'
	                                +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
	       TitleData.tmp_text = '';
	       //양평축협일시 그리드 하단에 문구 추가
	       if(na_bzplc == '8808990643625'){
		       TitleData.tmp_text = '금번 접종한 주사는 대사촉진제 및 구충제입니다.';	    	   
	       }
	       
	       fn_BtnAdj_fm_print(TitleData, "grd_MhSogCow");
	
		}
	
	//**************************************
	//function  : fn_BtnAdj_f(정산서(암수 구분) 출력) 
	//paramater : N/A
	// result   : N/A
	//**************************************	
	function fn_BtnAdj_fm(p_param) {
		
		if(fn_isNull($("#trmn_amnno").val())) {
			MessagePopup('OK','참가번호를 확인하세요.');
			return;
		}
		
		if(fCnt == 0 && p_param == "f") {
			MessagePopup('OK','출력할 내용이 없습니다.');
			return;
		} else if(mCnt == 0 && p_param == "m") {
			MessagePopup('OK','출력할 내용이 없습니다.');
			return;
		}
		
        var results;
        var results_1;
        var result;
        var result_1;
        
      	//정산금액 조회
        if(p_param == "f") {
			results = sendAjaxFrm("frm_Search", "/LALM0412_selListFrm_MdMwmnAdj_f", "POST");			
		} else if(p_param == "m") {
			results = sendAjaxFrm("frm_Search", "/LALM0412_selListFrm_MdMwmnAdj_m", "POST");			
		} else {
			MessagePopup('OK','암수 구분이 입력되지 않았습니다.');
			return;
		}
      	
        if(results.status != RETURN_SUCCESS) {
            showErrorMessage(results);
             return;
        } else {
        	result = setDecrypt(results);
        	
        	acno = parent.wmcList.ACNO;
    		var TitleData = new Object();
    		
    		TitleData.title = "응찰자 개별정산서 제 "+ $("#qcn").val() +" 차 "+ fn_deleteNumber($( "#auc_obj_dsc option:selected").text()) + " (" +fn_toDate(fn_dateToData($('#auc_dt').val()), "KR") + ")" ;
    		TitleData.sub_title = "(기준일자 : "+$('#auc_dt').val()+ ")";
     		TitleData.unit = "";
     		
     		
  	       	TitleData.tot_pym_am 	= result[0]["TOT_PYM_AM"];     		
     		TitleData.sra_sel_fee	= result[0]["SRA_SEL_FEE"];
     		TitleData.sra_sbid_am	= result[0]["SRA_SBID_AM"];
     		
     		
     		if(p_param == "f") {
     			TitleData.sra_rv_am		= result[0]["SRA_RV_AM"];
     			TitleData.tot_npym_am   = result[0]["TOT_NPYM_AM"];
         		TitleData.tot_csh_rv_am	= result[0]["TOT_CSH_RV_AM"];
         		TitleData.tot_ck_rv_am	= result[0]["TOT_CK_RV_AM"];
         		TitleData.tot_bb_rv_am	= result[0]["TOT_BB_RV_AM"];
         		TitleData.tot_etc_rv_am	= result[0]["TOT_ETC_RV_AM"];
         		
     		} else if(p_param == "m") {
     			if(fCnt == 0) {
     				TitleData.sra_rv_am		= result[0]["SRA_RV_AM"];
     				TitleData.tot_npym_am   = result[0]["TOT_NPYM_AM"];
             		TitleData.tot_csh_rv_am	= result[0]["TOT_CSH_RV_AM"];
             		TitleData.tot_ck_rv_am	= result[0]["TOT_CK_RV_AM"];
             		TitleData.tot_bb_rv_am	= result[0]["TOT_BB_RV_AM"];
             		TitleData.tot_etc_rv_am	= result[0]["TOT_ETC_RV_AM"];
     			} else {
     				TitleData.sra_rv_am		= "0";
                    TitleData.tot_npym_am   = result[0]["TOT_PYM_AM"];
             		TitleData.tot_csh_rv_am	= "0";
             		TitleData.tot_ck_rv_am	= "0";
             		TitleData.tot_bb_rv_am	= "0";
             		TitleData.tot_etc_rv_am	= "0";
     			}
     			
     		}
     		
     		TitleData.sra_020		= result[0]["SRA_020"];
     		TitleData.sra_030		= result[0]["SRA_030"];
     		TitleData.sra_040		= result[0]["SRA_040"];
     		TitleData.sra_050		= result[0]["SRA_050"];
     		TitleData.sra_060		= result[0]["SRA_060"];
     		TitleData.sra_070		= result[0]["SRA_070"];
     		TitleData.sra_080		= result[0]["SRA_080"];
     		TitleData.sra_100		= result[0]["SRA_100"];
     		TitleData.sra_110		= result[0]["SRA_110"];
     		TitleData.sra_120		= result[0]["SRA_120"];
     		TitleData.etc_cst		= result[0]["ETC_CST"];
     		TitleData.sra_fee		= result[0]["SRA_FEE"];
     		TitleData.sra_shnm		= result[0]["SRA_SHNM"];
     		TitleData.sra_mwmnnm	= result[0]["SRA_MWMNNM"];
     		TitleData.dong			= fn_xxsDecode($("#mdongup").val()+" "+$("#mdongbw").val()); 

    		TitleData.acno = parent.wmcList[0].ACNO;
    		TitleData.clntnm = parent.wmcList[0].NA_BZPLNM 
    		TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM + " 조합장 ";
    		TitleData.sealImg = parent.wmcList[0].SEAL_IMG_CNTN;
    		TitleData.rmk_cntn = parent.wmcList[0].RMK_CNTN;
    		TitleData.tel_no = parent.wmcList[0].TELNO;
    		
       
    		TitleData.srch_condition =  '[경매일자 : ' + $('#auc_dt').val() + ']'
    							   +  '/ [경매대상 : ' + $( "#auc_obj_dsc option:selected").text()  + ']';
    		TitleData.tmp_text = '';          	       
    		//양평축협일시 그리드 하단에 문구 추가
    		if(na_bzplc == '8808990643625'){
    			TitleData.tmp_text = '금번 접종한 주사는 대사촉진제 및 구충제입니다.';	    	   
    		}
    		// 낙찰내역 조회
    		if(p_param == "f") {
    			results_1 = sendAjaxFrm("frm_Search", "/LALM0412_selListGrd_MhSogCowF", "POST");
    			
    		} else if(p_param == "m") {
    			results_1 = sendAjaxFrm("frm_Search", "/LALM0412_selListGrd_MhSogCowM", "POST");
    			
    		} else {
    			MessagePopup('OK','암수 구분이 입력되지 않았습니다.');
    			return;
    		}
     		    
     	    if(results_1.status != RETURN_SUCCESS){
     	        showErrorMessage(results_1,"NOTFOUND");
     	    } else {     
     	    	result_1 = setDecrypt(results_1);
     	    	fn_CreateGrd_HdnMhSogCow(result_1, TitleData);
     	    }
        }
	}
		
	//**************************************
	//function  : fn_BtnAdj_f(정산서(암수구분) 리포트출력) 
	//paramater : N/A
	// result   : N/A
	//**************************************	
	function fn_BtnAdj_fm_print(p_param, p_grid) {
		// 1형식
		if (($("#prto_tpc_1").is(":checked"))) {

			
			// 영주:8808990687094
			if (na_bzplc == '8808990687094') {   
				p_param.title = "일반가축경매(" + $('#auc_obj_dsc option:checked').text().replace(/[^가-힣]/g,'') +")개별정산서 제"+$('#auc_dt').val() +"차";
				ReportPopup('LALM0412R0_8',p_param, p_grid, 'V');	
			}else if(na_bzplc == '8808990659008') { //경주
   				ReportPopup('LALM0412R0_0_4_2',p_param, p_grid, 'V');
   			} else if(na_bzplc == '8808990656649') { //의성
				ReportPopup('LALM0412R0_0_4',p_param, p_grid, 'T');//원본
			/*** 중도매인정산서 1형식 공통약식(딸송정보없X)
			* 전주김제완주 보은옥천 옥천지점:8808990671086 , 파주연천:8808990659787
			* , 고창부안:8808990657189, 횡성: 8808990656885, 강진완도 :  8808990657103, 양평 :  8808990643625 
			* , 장흥 :  8808990656533, 영광 :  8808990811710, 동해삼척태백축협 :  8808990652825, 고령성주 : 8808990659695, 강릉 : 8808990656878
			* 영천 : 8808990656687 , 나주 : 8808990659275  , 서산 : 8808990656694 , 진천 : 8808990656502
			* 홍천 : 8808990674605 , 충주 : 8808990656465 , 의령 : 8808990656199, 함평 : 8808990656601, 청양 : 8808990657646
			* 제주 : 8808990656618 , 수원 : 8808990656496 , 고성 : 8808990812007, 화순 : 8808990661315, 세종공주 : 8808990656588
			* 번식우 제외: 영암:8808990659701, 거창:8808990659701 , 영덕울진 : 8808990785431
			*/
			} else if(na_bzplc == '8808990656441' || na_bzplc == '8808990766485' || na_bzplc == '8808990671086' || na_bzplc == '8808990659787'  
				|| na_bzplc == '8808990657189' || na_bzplc == '8808990656885' || na_bzplc == '8808990657103'|| na_bzplc == '8808990643625'
				|| na_bzplc == '8808990656533' || na_bzplc == '8808990811710' || na_bzplc =='8808990652825'  || na_bzplc =='8808990659695' || na_bzplc =='8808990656878'
				|| na_bzplc =='8808990656687' || na_bzplc =='8808990659275' || na_bzplc =='8808990656694' || na_bzplc =='8808990656502'
				|| na_bzplc =='8808990674605' || na_bzplc =='8808990656465' || na_bzplc =='8808990656199' || na_bzplc =='8808990656601' || na_bzplc =='8808990657646'
				|| na_bzplc =='8808990656618' || na_bzplc =='8808990656496' || na_bzplc =='8808990812007' || na_bzplc =='8808990661315' || na_bzplc == '8808990656588'
				|| ((na_bzplc == '8808990689760' || na_bzplc == '8808990659701' || na_bzplc =='8808990785431') && $("#auc_obj_dsc").val() != '3' )
			){
				ReportPopup('LALM0412R0_9',p_param, p_grid, 'T');//원본
				//ReportPopup('LALM0412R0_1_3',p_param, p_grid, 'V');
			}else if(na_bzplc == '8808990656519' && $("#auc_obj_dsc").val() != '3') { //사천
   				ReportPopup('LALM0412R0_10',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656557') { //예천
   				ReportPopup('LALM0412R0_0_5_2',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990806426') { //속초양양 : 8808990806426
   				ReportPopup('LALM0412R0_9_1',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656540' && $("#auc_obj_dsc").val() == '1' ) { //담양 : 8808990656540
   				ReportPopup('LALM0412R0_9_2',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656540' && $("#auc_obj_dsc").val() == '2' ) { //담양 : 8808990656540
   				ReportPopup('LALM0412R0_9_2_1',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656540') { //담양
   				ReportPopup('LALM0412R0_9_2_2',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990689180') { //안동
   				ReportPopup('LALM0412R0_0_5_7',p_param, p_grid, 'V');
   			} else if(na_bzplc == '8808990660783'){ //임실
				ReportPopup('LALM0412R0_T_0',p_param, p_grid, 'T');//원본
			} else if(na_bzplc == '8808990659565'){ //김천
				ReportPopup('LALM0412R0_9_3',p_param, p_grid, 'T');//원본
			} else if(na_bzplc == '8808990679549'){ //포항 : 8808990679549
				ReportPopup('LALM0412R0_9_J_0',p_param, p_grid, 'T');//원본
			} else if(na_bzplc =='8808990656571'){ //청도 : 8808990656571
				ReportPopup('LALM0412R0_9_J_1',p_param, p_grid, 'T');
			} else if(na_bzplc =='8808990656670'){	//괴산증평 : 8808990656670
				ReportPopup('LALM0412R0_9_4',p_param, p_grid, 'T');
			} else{
				ReportPopup('LALM0412R0_0',p_param, p_grid, 'T');//원본
			}
		// 2형식
		} else {
   			//거창:8808990659701
   			if (na_bzplc ==  '8808990659701') {
   				ReportPopup('LALM0412R0_5_1',p_param, p_grid, 'V');
   			// 무진장:8808990657202
   			} else if (na_bzplc == '8808990657202') {
   				ReportPopup('LALM0412R0_5_5',p_param, p_grid, 'V');    	
			}else if(na_bzplc == '8808990227207') { //남원
   				ReportPopup('LALM0412R0_5_6',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990661315') { //화순
   				ReportPopup('LALM0412R0_1_8',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656557') { //예천
   				ReportPopup('LALM0412R0_0_5',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656687') { //영천 : 8808990656687
   				ReportPopup('LALM0412R0_0_1_1',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656434') { //원주
   				ReportPopup('LALM0412R0_0_6',p_param, p_grid, 'V');
   			//고령성주  ,나주, 구미칠곡, 김천, 충주, 의령, 화순
   			}else if(na_bzplc == '8808990659695' || na_bzplc == '8808990659275' || na_bzplc == '8808990657615' || na_bzplc == '8808990659565' || na_bzplc == '8808990679549' || na_bzplc =='8808990656465' || na_bzplc =='8808990656199' || na_bzplc =='8808990661315') {    			
   				ReportPopup('LALM0412R0_0_7',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990656540') { //담양
   				ReportPopup('LALM0412R0_9_2_2',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990689180') { //안동
   				ReportPopup('LALM0412R0_0_5_7',p_param, p_grid, 'V');
   			}else if(na_bzplc == '8808990660783') { //임실
   				ReportPopup('LALM0412R0_T_1',p_param, p_grid, 'V');
   			}else if (na_bzplc == '8808990806426') { //속초양양
				ReportPopup('LALM0412R0_J_0',p_param, p_grid, 'T');//원본
			} else {	
   				//ReportPopup('LALM0412R0_5_3',p_param, p_grid, 'V');
   				if((na_bzplc == '8808990656236' || na_bzplc == '8808990656519') && $("#auc_obj_dsc").val()=='3'){
   					ReportPopup('LALM0412R0_0_3',p_param, p_grid, 'V');
   				}else{
   					ReportPopup('LALM0412R0_0_1',p_param, p_grid, 'V');
   				}
   				
   			}
			
   			//} else if(na_bzplc == '8808990661315' || na_bzplc == '8808990656960' || na_bzplc == '8808990656953') { //화순,정읍,순창
			//	ReportPopup('LALM0412R0_1_8',p_param, p_grid, 'T');//원본	
		}
		fn_chgAucEntrDdl();
	}
	
	
		function fn_BtnDbtCnf(){
		
			
			acno = parent.wmcList.ACNO;
			var TitleData = new Object();
		    TitleData.title = "채  무  확  인  서";
		    TitleData.sub_title = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") +" 낙찰자 입금내역";
		    TitleData.unit = "";
	        TitleData.frlno = $("#frlno").val()+"- *******";
	        TitleData.tot_pym_am = $("#tot_pym_am").val();
	        TitleData.tot_npym_am = $("#tot_npym_am").val();
	   	    TitleData.sra_sel_fee = $("#sra_sel_fee").val();
	   	    TitleData.sra_sbid_am = $("#sra_sbid_am").val();
	   	    TitleData.sra_rv_am = $("#sra_rv_am").val();
	   	    TitleData.sra_auc_sbid_hdcn = $("#sra_auc_sbid_hdcn").val();
	   	    TitleData.etc_cst = $("#etc_cst").val();
	        TitleData.acno = parent.wmcList[0].ACNO;
	   	    TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM + " 조합장";
	   	    TitleData.clntnm = parent.wmcList[0].NA_BZPLNM + " 가축시장"||"조합장";
	   	    TitleData.bzno = parent.wmcList[0].BZNO;
	   		TitleData.text1 = ""; 
	     	TitleData.Text2 = $("#tot_npym_am").val()+"원정 (￦)";
	   		TitleData.Text3 = $("#sra_auc_sbid_hdcn").val()+"두";
	   		TitleData.sealImg = parent.wmcList[0].SEAL_IMG_CNTN;
	   		TitleData.auc_dt = fn_toDate(fn_dateToData($('#auc_dt').val()), "KR");
	   		TitleData.dong = fn_xxsDecode($("#mdongup").val()+" "+$("#mdongbw").val()); //매수인주소
	   		TitleData.sra_mwmnnm = $("#sra_mwmnnm").val(); //축산중도매인명
	   		var kNumber = fn_getKNumber(TitleData.tot_npym_am?.replaceAll(',',''));
   			TitleData.tot_npym_am_k = kNumber;
   			var aucObjDscNm = fn_deleteNumber($( "#auc_obj_dsc option:selected").text());
   			if(na_bzplc != '8808990656694' && aucObjDscNm =='일괄') aucObjDscNm = '송아지, 큰소';
   			
	   		if(na_bzplc == '8808990687094') {  // 영주: 8808990687094
				TitleData.text1 = $("#sra_mwmnnm").val()+" 님은\n"+fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 경매시장에 응찰하여\n구입한 우 매입대금 중 아래 금액에 대하여 채무를 확인하고 \n경매일 익일 오전 12시까지 완납 할것을 확인합니다.";
			}else if (na_bzplc ==  '8808990656663') {  // 밀양: 8808990656663
				TitleData.text1 = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 매입대금 중 일부 금액이 부족하여 그 금액을 아래와 같이 \n채무 확인하고 당일(은행마감 시간)내에 납입 할 것을 확인 합니다.\n 단 부득이한 경우 사전에 조합으로 요청시 1일에 한해 연장할수 있으며 \n3일 초과시 즉시 법적 절차가 진행됨을 유의 하시기 바랍니다.";
			}else if (na_bzplc ==  '8808990656502') {  // 진천: 8808990656502
				TitleData.text1 = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 경매시장에 응찰하여 구입한 \n"+ aucObjDscNm + " 매입대금 중 전부(일부)금액이 부족하여 그 금액을 아래와 같이 \n채무 확인하고 익영업일(은행시간 마감)내에 납입 하겠으며, 미입금시 \n민,형사상 조치를 하여도 전혀 이의를 제기하지 않을 것을 확약합니다.";
		 	}else if (na_bzplc ==  '8808990656557') {  // 예천: 8808990656557
				TitleData.text1 = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 경매시장에 응찰하여 구입한 \n"+aucObjDscNm + " 매입대금 중 일부 금액이 부족하여 그 금액을 아래와 같이 \n채무 확인하고 당일(은행마감 시간)내에 납입 할 것을 확인 합니다.";
		 	}else if (na_bzplc ==  '8808990657615') {  // 구미: 8808990657615
				TitleData.text1 = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 경매시장에 응찰하여 구입한 \n"+aucObjDscNm + " 매입대금 중 일부 금액이 부족하여 그 금액을 아래와 같이 \n채무 확인하고 익영업일(오후 12시)내에 납입 할 것을 확인 합니다.";
		 	}else if(na_bzplc ==  '8808990657240') {  // 진주 : 8808990657240
				TitleData.text1 = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 경매시장에 응찰하여\n구입한 "+ aucObjDscNm + " 매입대금 중 일부 금액이 부족하여 그 금액을 아래와 같이 \n채무 확인하고 당일(은행마감 시간)내에 납입 할 것을 확인 합니다.\n낙찰 후 양도에 있어 발생 되는 대금 미납의 책임은\n응찰자(양도자)에게 있음을 확인합니다.";
		 	}else if(na_bzplc ==  '8808990806426') {  //속초양양 : 8808990806426
				TitleData.text1 = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 경매시장에 응찰하여\n구입한 "+ aucObjDscNm + " 매입대금 중 일부 금액이 부족하여 그 금액을 아래와 같이 \n채무 확인하고 당일 오후3시까지 납입 할 것을 확인 합니다.";
		 	}else{
				TitleData.text1 = fn_toDate(fn_dateToData($("#auc_dt").val()), "KR") + " " + parent.wmcList[0].NA_BZPLNM + " 경매시장에 응찰하여\n구입한 "+ aucObjDscNm + " 매입대금 중 일부 금액이 부족하여 그 금액을 아래와 같이 \n채무 확인하고 당일(은행마감 시간)내에 납입 할 것을 확인 합니다.";
		 	}
	   		 
			if (na_bzplc == '8808990687094') {  // 영주:              8808990687094
				ReportPopup('LALM0412R1_4',TitleData, 'grd_MhSogCow', 'T');
			}else if(na_bzplc == '8808990656557') { //예천
   				ReportPopup('LALM0412R1_0',TitleData, 'grd_MhSogCow', 'T');
   			}else{
				ReportPopup('LALM0412R1_9',TitleData, 'grd_MhSogCow', 'T');
				//ReportPopup('LALM0412R1_1',TitleData, 'grd_MhSogCow', 'T');
			}
			//fn_chgAucEntrDdl();
			
		}
		function fn_BtnAtfCvn(){
			
			Wdongup = parent.wmcList.DONGUP;
			Wdongbw = parent.wmcList.DONGBW;
			acno = parent.wmcList.ACNO;
			var TitleData = new Object();
		    TitleData.title = "가축시장용 양도·양수신고서(보관용)";
		  	//춘천철원 : 8808990656229
		    if(na_bzplc == '8808990656229'){
			    TitleData.title1 = "가축시장용 양도·양수신고서";
		    }else{
			    TitleData.title1 = "가축시장용 양도·양수신고서(교부용)";
		    }
		    TitleData.sub_title = "가축매매수수료 영수증 겸용";
		    TitleData.unit = "";
	        TitleData.frlno = $("#frlno").val() + " - *******";
	        TitleData.ohse_telno = $("#ohse_telno").val();
	        TitleData.cus_mpno = $("#cus_mpno").val();
	        TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM;
	        TitleData.bzno = parent.wmcList[0].BZNO;
	        TitleData.telno = parent.wmcList[0].TELNO;
	        TitleData.adr = $("#mdongup").val()+" "+$("#mdongbw").val(); //매수인주소
	        TitleData.sra_mwmnnm = $("#sra_mwmnnm").val(); //축산중도매인명
	        TitleData.text3 = parent.wmcList[0].NA_BZPLNM +" 조합장";
	        TitleData.text1 = $("#sra_sel_fee").val();
			TitleData.dong = fn_xxsDecode(parent.wmcList[0].DONGUP + parent.wmcList[0].DONGBW); //사업장주소 
			
			TitleData.sealImg = parent.wmcList[0].SEAL_IMG_CNTN;
			TitleData.auc_dt = fn_toDate(fn_dateToData($('#auc_dt').val()), "KR");
			TitleData.acno = parent.wmcList[0].ACNO;
			
			//춘천철원 : 8808990656229
			if(na_bzplc == '8808990656229'){
				ReportPopup('LALM0412R2_1',TitleData, 'grd_MhSogCow', 'T');
			}else{
				ReportPopup('LALM0412R2',TitleData, 'grd_MhSogCow', 'T');
			}
		}
		
		function fn_BtnFeeRctw(){
			  var temp1 = $("#sra_sel_fee").val().replace(",", "");
		      var temp2 = $("#etc_cst").val().replace(",", "");
		      var temp3 = parseInt(temp1) + parseInt(temp2); 
			
			Wdongup = parent.wmcList.DONGUP;
			Wdongbw = parent.wmcList.DONGBW;
			
			var TitleData = new Object();
		    TitleData.title = "가축매매 수수료 영수증 제 " + $("#qcn").val() + " 차";
		    TitleData.sub_title = "";
		    TitleData.unit = "";
	        TitleData.frlno = $("#frlno").val()+" - *******";
	        TitleData.ohse_telno = $("#ohse_telno").val();
	        TitleData.cus_mpno = $("#cus_mpno").val();
	       // TitleData.qcn = $("#qcn").val();
	        TitleData.bzno = parent.wmcList[0].BZNO;
	        TitleData.na_bzplnm = parent.wmcList[0].NA_BZPLNM + " 조합장 "+ parent.wmcList[0].REPMNM;
	        TitleData.auc_dt = fn_toDate(fn_dateToData($('#auc_dt').val()), "KR");
	        TitleData.txt = temp3;
	        TitleData.sra_sel_fee = $("#sra_sel_fee").val();
	        TitleData.sra_etc_cst = $("#etc_cst").val();
	        TitleData.dong = fn_xxsDecode($("#mdongup").val()+" "+$("#mdongbw").val()); //매수인주소
	        TitleData.Wdong = parent.wmcList[0].DONGUP + parent.wmcList[0].DONGBW; //사업장주소
 	        TitleData.Wdongup = parent.wmcList[0].DONGUP; //사업장주소 
			TitleData.Wdongbw = parent.wmcList[0].DONGBW; //사업장주소 
 			TitleData.sealImg = parent.wmcList[0].SEAL_IMG_CNTN;
 			TitleData.sra_mwmnnm = $("#sra_mwmnnm").val(); //축산중도매인명
			//$("#qcn").val(result_6[0].QCN)
	        ReportPopup('LALM0412R3',TitleData, 'grd_MhSogCow', 'T');
		}
		
		function fn_getKNumber(number){
			var kNumber = ['','일','이','삼','사','오','육','칠','팔','구'];
			var tenThousandUnit = ['','만','억','조'];
			var tenUnit = ['','십','백','천'];
			let index=0,unit=10000;
			let division = Math.pow(unit,index);
			let answer = '';
	
			while(Math.floor(number/division) > 0 ){
				var mod = Math.floor(number % (division * unit) / division);
				if(mod){
					const modToArr = mod.toString().split('');
					const modLen = modToArr.length - 1;
					const toKorean = modToArr.reduce((a, v , i) =>{
						a+= kNumber[v*1]+tenUnit[modLen -i];
						return a;
					},'');
					answer = toKorean+tenThousandUnit[index] +answer; 
				}
				division = Math.pow(unit,++index);
			}
			return answer;
		}
		
		//정산서,채무확인서 출력시 경매 참가번호 거래 확정으로 수정
		function fn_chgAucEntrDdl(){
			if($('#grd_MhSogCow').getGridParam("reccount") == 0) return; 
			
			var srchData = {};
			srchData["auc_dt"] 	= $('#auc_dt').val().replace(/[^0-9]/g,'');
			srchData["auc_obj_dsc"] 	= $('#auc_obj_dsc').val();
			srchData["lvst_auc_ptc_mn_no"] 	= $('#lvst_auc_ptc_mn_no').val();
			srchData["trmn_amnno"] 	= $('#trmn_amnno').val();
			
			
			result = sendAjax(srchData, "/LALM0412_updAucEntrDdl", "POST");
			
			if(result.status == RETURN_SUCCESS){
             	var decMap = setDecrypt(result);
            }			
		}
</script>
<body>
<div class="contents">
    <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
                    
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색조건</p></li>
                </ul>
                <!-- 
                 <div class="fl_R">   
		             <button class="tb_btn" id="pb_Give">응찰기지급</button>
		             <button class="tb_btn" id="pb_Take">응찰기반납</button>
		        </div>
		         -->
            </div> 
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search">
                    <table>
                        <colgroup>
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
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
                                        <div class="cell"><input type="text" class="date" id="auc_dt" maxlength="10"></div>
                                    </div>
                                </td>
                                <th scope="row">참가번호</th>
                                <td>
                                   <div class="cellBox v_addr">
                                       <div class="cell" style="width:80px;">
                                           <input type="text" id="trmn_amnno" disabled/>
                                       </div>
                                       <div class="cell pl2" style="width:80px;">
                                           <input type="text" id="lvst_auc_ptc_mn_no" disabled/>
                                       </div>
                                       <div class="cell pl2" style="width:120px;">
                                           <input type="text" id="sra_mwmnnm"/>
                                       </div>
                                       <div class="cell pl2" style="width:26px;">
                                             <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>
                                   </div>
                                </td>
                                <th scope="row">정산서양식</th>
                                <td>
                                    <div class="cellBox" id="rd_prto_tpc">
                                        <div class="cell">
	                                        <input type="radio" id="prto_tpc_1" name="prto_tpc_radio" value="1" 
	                                        onclick="javascript:fn_setChgRadio('prto_tpc','1');"/>
	                                        <label>1형식</label>
	                                        <input type="radio" id="prto_tpc_2" name="prto_tpc_radio" value="2" 
	                                        onclick="javascript:fn_setChgRadio('prto_tpc','2');"/>
	                                        <label>2형식</label>
                                        </div>
                                    </div>
                                    <input type="hidden" id="prto_tpc"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <!-- 관리농가정보 -->
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">정산금액</p></li>
                </ul>
            </div>
            <!-- 정산금액 폼 -->
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_Farm">
                    		<input type="hidden" id="sra_020"/>
                            <input type="hidden" id="sra_030"/>
                            <input type="hidden" id="sra_040"/>
                            <input type="hidden" id="sra_050"/>
                            <input type="hidden" id="sra_060"/>
                            <input type="hidden" id="sra_070"/>
                            <input type="hidden" id="sra_080"/>
                            <input type="hidden" id="sra_100"/>
                            <input type="hidden" id="sra_110"/>
                            <input type="hidden" id="sra_120"/>
                            <input type="hidden" id="sra_fee"/>
                            
                          
                    <table>
                        <colgroup>
                            <col width="12%">
                            <col width="12%">
                            <col width="12%">
                            <col width="12%">
                            <col width="12%">
                            <col width="12%">
                            <col width="12%">
                            <col width="12%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">총낙찰금액</th>
                                <td>
                                    <input type="text" id="sra_sbid_am" class='number'/>
                                </td>
                                <th scope="row">총수수료</th>
                                <td>
                                    <input type="text" id="sra_sel_fee" class='number'/>
                                </td> 
                                <th scope="row">기타비용</th>
                                <td>
                                    <input type="text" id="etc_cst" class='number'/>
                                </td> 
                                <th scope="row">총낙찰두수</th>
                                <td>
                                    <input type="text" id="sra_auc_sbid_hdcn" class='number'/>
                                </td>    
                            </tr>
                            <tr>
                                <th scope="row">현금입금액</th>
                                <td>
                                    <input type="text" id="tot_csh_rv_am" class='number'/>
                                </td>
                                <th scope="row">수표입금액</th>
                                <td>
                                    <input type="text" id="tot_ck_rv_am" class='number'/>
                                </td>
                                <th scope="row">통장입금액</th>
                                <td>
                                    <input type="text" id="tot_bb_rv_am" class='number'/>
                                </td>
                                <th scope="row">기타입금액</th>
                                <td>
                                    <input type="text" id="tot_etc_rv_am" class='number'/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">보증금</th>
                                <td>
                                    <input type="text" id="auc_entr_grn_am" class='number'/>
                                </td>
                                <th scope="row">총납입할금액</th>
                                <td>
                                    <input type="text" id="tot_pym_am" class='number'/>
                                </td>
                                <th scope="row">총입금액</th>
                                <td>
                                    <input type="text" id="sra_rv_am" class='number'/>
                                </td>
                                <th scope="row">정산금액</th>
                                <td>
                                    <input type="text" id="tot_npym_am" class='number'/>
                                    <input type="hidden" id="tot_sra_mwmnnm"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <!-- 낙찰내역 -->
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">낙찰내역</p></li>
                </ul>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                    <button class="tb_btn" id="pb_Adj">정산서</button>
                    <button class="tb_btn" id="pb_Adj_f">정산서(암)</button>
                    <button class="tb_btn" id="pb_Adj_m">정산서(수)</button>
                    <button class="tb_btn" id="pb_DbtCnf">채무확인서</button>
                    <button class="tb_btn" id="pb_AtfCvn">양수/양도</button>
                    <button class="tb_btn" id="pb_FeeRctw">수수료영수증</button>
               </div>
            </div>
            <div class="listTable rsp_v">
                <table id="grd_MhSogCow">
                </table>
            </div>
            <ul class="clearfix">
                <li class="fl_L allow_R m_full" style="width:50%;"><!-- //좌측 화살표 추가 할때 allow_R 클래스 추가 -->
                    <div class="tab_box clearfix">
                        <ul class="tab_list fl_L">
                            <li><p class="dot_allow">입금등록</p></li>
                        </ul>
		                 <div class="fl_R"><!--  //버튼 모두 우측정렬 -->
		                     <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 구입하신 소는 5일이내에 축협으로 이동신고바랍니다.</label>   
		                     <button class="tb_btn" id="pb_RvGrmy">보증금입금</button>
		                </div>
                    </div>                        
                    <div class="grayTable rsp_h">
                        <form id="srchFrm_detail">
                            <input type="hidden" id="de_auc_obj_dsc" name="de_auc_obj_dsc"/>
                            <input type="hidden" id="de_trmn_amnno"  name="de_trmn_amnno"/>
                            <input type="hidden" id="de_rv_sqno"     name="de_rv_sqno"/>
                            <input type="hidden" id="de_lvst_auc_ptc_mn_no"  name="de_lvst_auc_ptc_mn_no"/>
                            <input type="hidden" id="de_auc_dt"      name="de_auc_dt" class="date"/>
                            <input type="hidden" id="de_chg_yn"/>
                           
                            
                            <table> 
                                <colgroup>
                                    <col width="120">
                                    <col width="*">
                                    <col width="80">
                                    <col width="80">
                                    <col width="80">
                                </colgroup>
                                <tbody>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">입금일자</span></th>
                                 <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="de_rv_dt" name="de_rv_dt" maxlength="10"></div>
                                    </div>
                                 </td>
                                   </tr>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">입금종류</span></th>
                                       <td>
		                                   <div class="cellBox" id="rd_sra_rv_tpc">
		                                   </div>
                                           <input type="hidden" id="de_sra_rv_tpc" name="de_sra_rv_tpc"/>
                                       </td>
                                   </tr>
                                   <tr>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">입금액</span></th>
                                       <td>
                                           <input type="text" id="de_sra_rv_am" name="de_sra_rv_am" class="number"/>
                                       </td>
                                   </tr>
                                   <tr>
                                       <th scope="row"><span class="tb_dot">비고</span></th>
                                       <td>
                                          <input type="text" id="de_rmk_cntn" name="de_rmk_cntn">
                                          <input hidden="ture"  id="frlno">
                                          <input hidden="ture"  id="ohse_telno">
                                          <input hidden="ture"  id="cus_mpno">
                                          <input hidden="ture"  id="mdongup">
                                          <input hidden="ture"  id="mdongbw">
                                          <input hidden="ture"  id="qcn">
                                          <input hidden="ture"  id="temp3">
                                          <input hidden="ture"  id="sra_mwmnnm">
                                          
                                          
                                       </td>
                                   </tr>            
                                </tbody>
                            </table>
                        </form>
                    </div>
               </li>            
               <!-- //좌 e -->
                <li class="fl_R allow_R m_full" style="width:48%;">
                   <div class="tab_box clearfix">
                        <ul class="tab_list fl_L">
                            <li><p class="dot_allow">입금내역</p></li>
                        </ul>
                       <div class="fl_R"><!--  //버튼 모두 우측정렬 -->  
	                       <button class="tb_btn" id="pb_InputInit">입력초기화</button>
	                       <button class="tb_btn" id="pb_RvWrite">입금등록</button>
	                       <button class="tb_btn" id="pb_RvDelete">입금삭제</button>
	                   </div>
	               </div>
                   <div class="listTable">
                       <table id="grd_MdMwmnAdj" style="width:100%;">
                       </table>
                   </div>
                   <div class="listTable rsp_v" style="display:none">
		               <table id="grd_HdnMhSogCow" style="width:100%;">
		               </table>
		           </div>
               </li>
            </ul>
            
        </section>        
    </div>
<!-- ./wrapper -->
</body>
</html>