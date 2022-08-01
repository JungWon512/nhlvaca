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
 * 2. 파  일  명   : LALM0514
 * 3. 파일명(한글) : 기간별 경매집계표 조회
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.13   이지호   최초작성
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
     
     $(document).ready(function(){
    	 
         fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
 //        fn_setCodeBox("maco_yn", "MACO_YN", 1, true);
         fn_Init();    
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
        }     
        
        setRowStatus = "";
                       
//        $( "#auc_dt"   ).datepicker().datepicker("setDate", fn_getToday());
    	$( "#auc_st_dt" ).datepicker().datepicker("setDate", fn_getDay(-7));
        $( "#auc_ed_dt" ).datepicker().datepicker("setDate", fn_getToday());        
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
		
        var results = sendAjaxFrm("frm_Search", "/LALM0514_selList", "POST");        
        var result;
        
        $("#mainGrid").jqGrid("clearGridData", true);
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
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "기간별 경매집계표";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[경매대상 : ' + $('#cb_auc_obj_dsc option:selected').text() +' / 경매일자 : ' + $('#auc_st_dt').val() +' ~ ' + $('#auc_ed_dt').val() + ']';

    	var tot_lows_sbid_lmt_am = 0;
    	var tot_sra_sbid_am = 0;
    	var tot_wt = 0;
    	var tot_cnt = 0;
    	var tot_w_lows_sbid_lmt_am = 0;
    	var tot_w_sra_sbid_am = 0;
    	var tot_w_wt = 0;
    	var tot_w_cnt = 0;
    	var tot_m_lows_sbid_lmt_am = 0;
    	var tot_m_sra_sbid_am = 0;
    	var tot_m_wt = 0;
    	var tot_m_cnt = 0;
    	   
    	$('#mainGrid').getRowData().forEach((o,i)=>{
    		if(o.AUC_DT != '일계'){
    			tot_lows_sbid_lmt_am += new Number(o.LOWS_SBID_LMT_AM_SEL_22);
    			tot_sra_sbid_am += new Number(o.SRA_SBID_AM); 
    			tot_wt += new Number(o.TOT_WT_22);
    			tot_cnt += new Number(o.TOT_HDCN); 
    			if(o.INDV_SEX_C == 1){ //암컷
        			tot_w_lows_sbid_lmt_am += new Number(o.LOWS_SBID_LMT_AM_SEL_22);
        			tot_w_sra_sbid_am += new Number(o.SRA_SBID_AM); 
        			tot_w_wt += new Number(o.TOT_WT_22);
        			tot_w_cnt += new Number(o.TOT_HDCN);
    			}else{	//수컷
        			tot_m_lows_sbid_lmt_am += new Number(o.LOWS_SBID_LMT_AM_SEL_22);
        			tot_m_sra_sbid_am += new Number(o.SRA_SBID_AM); 
        			tot_m_wt += new Number(o.TOT_WT_22);
        			tot_m_cnt += new Number(o.TOT_HDCN);     				
    			}
    		}
    	});
    	TitleData.tot_avg_lows_sbid_lmt_am = Math.round(tot_lows_sbid_lmt_am / tot_cnt);
    	TitleData.tot_avg_sra_sbid_am = Math.round(tot_sra_sbid_am / tot_cnt);
    	TitleData.tot_avg_wt = Math.round(tot_wt / tot_cnt);
    	TitleData.tot_bigo = TitleData.tot_avg_sra_sbid_am - TitleData.tot_avg_lows_sbid_lmt_am;
        
    	TitleData.tot_w_avg_lows_sbid_lmt_am = Math.round(tot_w_lows_sbid_lmt_am / tot_w_cnt);
    	TitleData.tot_w_avg_sra_sbid_am = Math.round(tot_w_sra_sbid_am / tot_w_cnt);
    	TitleData.tot_w_avg_wt = Math.round(tot_w_wt / tot_cnt);
    	TitleData.tot_w_bigo = TitleData.tot_w_avg_sra_sbid_am - TitleData.tot_w_avg_lows_sbid_lmt_am;
        
    	TitleData.tot_m_avg_lows_sbid_lmt_am = Math.round(tot_m_lows_sbid_lmt_am / tot_m_cnt);
    	TitleData.tot_m_avg_sra_sbid_am = Math.round(tot_m_sra_sbid_am / tot_m_cnt);
    	TitleData.tot_m_avg_wt = Math.round(tot_m_wt / tot_cnt);
    	TitleData.tot_m_bigo = TitleData.tot_m_avg_sra_sbid_am - TitleData.tot_m_avg_lows_sbid_lmt_am;

		TitleData.unit = Math.round(tot_lows_sbid_lmt_am / tot_cnt);
    	
    	ReportPopup('LALM0514R',TitleData, 'mainGrid', 'V');
    		
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
    	if (App_na_bzplc == '8808990659701') {  // 홍성: 8808990657622
    		fn_ExcelDownlad('mainGrid', '출장우내역조회');
    	}else{
            fn_ExcelDownlad('mainGrid', '기간별 경매집계표');
    	}
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
        
        	/*                            1          2         3        4      5        6       7        8            			9          10     		  				11	   			   12	  			 13 	                14               15        16  */
        	var searchResultColNames = ["경매일자", "경매대상", "등록구분", "성별", "출장두수", "두수", "유찰두수", "전체(kg)", "낙찰(kg)", "평균(kg)", "총 응찰하한가", "총 낙찰하한가", "응찰하한가<br>평균금액(A)", "총 낙찰가<br>금액", "낙찰가<br>평균금액(B)", "비고(평균차액)<br>(B-A)", "최고가", "최저가"
        								];        
	        var searchResultColModel = [						 
						                {name:"AUC_DT",     		    index:"AUC_DT",     		    width:70, align:'center'},
						                {name:"AUC_OBJ_DSC",         	index:"AUC_OBJ_DSC",         	width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						                {name:"RG_DSC",      			index:"RG_DSC",      			width:40, align:'center'},
						                {name:"INDV_SEX_C",  			index:"INDV_SEX_C", 	    	width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						                {name:"TOT_HDCN3",              index:"TOT_HDCN3",              width:40, align:'right'},
						                {name:"TOT_HDCN",               index:"TOT_HDCN",               width:40, align:'right'},
						                {name:"TOT_HDCN2",              index:"TOT_HDCN2",              width:40, align:'right'},
						                {name:"TOT_WT",                 index:"TOT_WT",  				width:40, align:'right'},
						                {name:"TOT_WT_22",              index:"TOT_WT_22",  			width:40, align:'right', hidden:true},
						                {name:"AVG_WT",        		    index:"AVG_WT",        	        width:40, align:'right'},
						                {name:"LOWS_SBID_LMT_AM",       index:"LOWS_SBID_LMT_AM",       width:70, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"LOWS_SBID_LMT_AM_SEL_22",index:"LOWS_SBID_LMT_AM_SEL_22",width:70, align:'right', hidden:true, formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"AVG_PR",                 index:"AVG_PR",      			width:70, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_SBID_AM",            index:"SRA_SBID_AM",            width:60, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_AVG_SBID_UPR",       index:"SRA_AVG_SBID_UPR",       width:50, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"BIGO",       			index:"BIGO",       			width:70, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"MAX_SRA_SBID_AM",        index:"MAX_SRA_SBID_AM",        width:60, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"MIN_SRA_SBID_AM",        index:"MIN_SRA_SBID_AM",        width:60, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}}
						               
						                ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            footerrow: true,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel, 
            loadComplete : function(data){            	
            	var idArry = $("#mainGrid").jqGrid("getDataIDs");
            	for(var i = 0; i < idArry.length; i++){   
            		var ret = $("#mainGrid").getRowData(idArry[i]);            		
            		if("일계" == ret.AUC_DT){
            			$("#mainGrid").setRowData(i+1, false, {background:"#FFD400"});
            		}
            	}
            },            
        });
        
        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No");  
        
        //footer        
        var gridDatatemp = $('#mainGrid').getRowData();
        //암 합                                                 
        var ftot_tot_hdcn3 		  = 0; //출장두수                
        var ftot_tot_hdcn         = 0; //두수                    
        var ftot_tot_hdcn2        = 0; //유찰두수                
        var ftot_tot_wt           = 0; //전체(kg)                
        var ftot_avg_wt           = 0; //평균(kg)                
        var ftot_lows_sbid_lmt_am = 0; //총 응찰하한가(A)
        var ftot_avg_pr           = 0; //응찰하한가<br>평균금액( 
        var ftot_sra_sbid_am      = 0; //총 낙찰가<br>금액       
        var ftot_sra_avg_sbid_upr = 0; //낙찰가<br>평균금액(B)   
        var ftot_bigo             = 0; //비고(평균차액)<br>(B-A) 	     
        //수 합                                                 	     
        var mtot_tot_hdcn3 		  = 0; //출장두수                
        var mtot_tot_hdcn         = 0; //두수                    
        var mtot_tot_hdcn2        = 0; //유찰두수                
        var mtot_tot_wt           = 0; //전체(kg)                
        var mtot_avg_wt           = 0; //평균(kg)                
        var mtot_lows_sbid_lmt_am = 0; //총 응찰하한가           
        var mtot_avg_pr           = 0; //응찰하한가<br>평균금액(A)
        var mtot_sra_sbid_am      = 0; //총 낙찰가<br>금액       
        var mtot_sra_avg_sbid_upr = 0; //낙찰가<br>평균금액(B)   
        var mtot_bigo             = 0; //비고(평균차액)<br>(B-A)   
        //총 합                                                 	     
        var tot_tot_hdcn3 		  = 0; //출장두수                
        var tot_tot_hdcn         = 0; //두수                    
        var tot_tot_hdcn2        = 0; //유찰두수                
        var tot_tot_wt           = 0; //전체(kg)                
        var tot_avg_wt           = 0; //평균(kg)                
        var tot_lows_sbid_lmt_am = 0; //총 응찰하한가           
        var tot_avg_pr           = 0; //응찰하한가<br>평균금액(A)
        var tot_sra_sbid_am      = 0; //총 낙찰가<br>금액       
        var tot_sra_avg_sbid_upr = 0; //낙찰가<br>평균금액(B)   
        var tot_bigo             = 0; //비고(평균차액)<br>(B-A)
        
        var tot_bigo_lows_sbid_lmt_am = 0;
        var ftot_bigo_lows_sbid_lmt_am = 0;
        var mtot_bigo_lows_sbid_lmt_am = 0;   
        var ftot_tot_wt_22 = 0;   
        var mtot_tot_wt_22 = 0;   
        var tot_tot_wt_22 = 0;    
        
        var fCnt = 0;
        var mCnt = 0;

        $.each(gridDatatemp,function(i){
        	
        	
        	//암 합
        	if(gridDatatemp[i].INDV_SEX_C == '1' || gridDatatemp[i].INDV_SEX_C == '4' || gridDatatemp[i].INDV_SEX_C == '6' ){
	        	ftot_tot_hdcn3        += parseInt(gridDatatemp[i].TOT_HDCN3);	      
	        	ftot_tot_hdcn         += parseInt(gridDatatemp[i].TOT_HDCN);	  
	        	ftot_tot_hdcn2        += parseInt(gridDatatemp[i].TOT_HDCN2);	  
	        	ftot_tot_wt           += parseInt(gridDatatemp[i].TOT_WT);	  
	        	ftot_tot_wt_22        += parseInt(gridDatatemp[i].TOT_WT_22);	  
	        	ftot_avg_wt           += parseInt(gridDatatemp[i].AVG_WT);	  
	        	ftot_lows_sbid_lmt_am += parseInt(gridDatatemp[i].LOWS_SBID_LMT_AM);	  
	        	ftot_avg_pr           += parseInt(gridDatatemp[i].AVG_PR);	  
	        	ftot_sra_sbid_am      += parseInt(gridDatatemp[i].SRA_SBID_AM);	  
	        	ftot_sra_avg_sbid_upr += parseInt(gridDatatemp[i].SRA_AVG_SBID_UPR);	  
	        	ftot_bigo             += parseInt(gridDatatemp[i].BIGO);	
	        	ftot_bigo_lows_sbid_lmt_am += parseInt(gridDatatemp[i].LOWS_SBID_LMT_AM_SEL_22);
	        	fCnt++;
        	}
			//수 합
        	if(gridDatatemp[i].INDV_SEX_C == '2' || gridDatatemp[i].INDV_SEX_C == '3' || gridDatatemp[i].INDV_SEX_C == '5'  ){
	        	mtot_tot_hdcn3        += parseInt(gridDatatemp[i].TOT_HDCN3);	      
	        	mtot_tot_hdcn         += parseInt(gridDatatemp[i].TOT_HDCN);	  
	        	mtot_tot_hdcn2        += parseInt(gridDatatemp[i].TOT_HDCN2);	  
	        	mtot_tot_wt           += parseInt(gridDatatemp[i].TOT_WT); 
	        	mtot_tot_wt_22        += parseInt(gridDatatemp[i].TOT_WT_22);	  
	        	mtot_avg_wt           += parseInt(gridDatatemp[i].AVG_WT);	  
	        	mtot_lows_sbid_lmt_am += parseInt(gridDatatemp[i].LOWS_SBID_LMT_AM);	  
	        	mtot_avg_pr           += parseInt(gridDatatemp[i].AVG_PR);	  
	        	mtot_sra_sbid_am      += parseInt(gridDatatemp[i].SRA_SBID_AM);	  
	        	mtot_sra_avg_sbid_upr += parseInt(gridDatatemp[i].SRA_AVG_SBID_UPR);	  
	        	mtot_bigo             += parseInt(gridDatatemp[i].BIGO);	  
	        	mtot_bigo_lows_sbid_lmt_am += parseInt(gridDatatemp[i].LOWS_SBID_LMT_AM_SEL_22);
	        	mCnt++;
        	}  
        	//총합
        	if(gridDatatemp[i].AUC_DT != '일계'){
	        	tot_tot_hdcn3        += parseInt(gridDatatemp[i].TOT_HDCN3);	      
	        	tot_tot_hdcn         += parseInt(gridDatatemp[i].TOT_HDCN);	  
	        	tot_tot_hdcn2        += parseInt(gridDatatemp[i].TOT_HDCN2);	  
	        	tot_tot_wt           += parseInt(gridDatatemp[i].TOT_WT);
	        	tot_tot_wt_22        += parseInt(gridDatatemp[i].TOT_WT_22);	  
	        	tot_avg_wt           += parseInt(gridDatatemp[i].AVG_WT);	  
	        	tot_lows_sbid_lmt_am += parseInt(gridDatatemp[i].LOWS_SBID_LMT_AM);	  
	        	tot_avg_pr           += parseInt(gridDatatemp[i].AVG_PR);	  
	        	tot_sra_sbid_am      += parseInt(gridDatatemp[i].SRA_SBID_AM);	  
	        	tot_sra_avg_sbid_upr += parseInt(gridDatatemp[i].SRA_AVG_SBID_UPR);	  
	        	tot_bigo             += parseInt(gridDatatemp[i].BIGO);	  
	        	tot_bigo_lows_sbid_lmt_am += parseInt(gridDatatemp[i].LOWS_SBID_LMT_AM_SEL_22);
        	}         	

        });        
                
        var arr = [
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                ["AUC_DT"                 ,"합 계"                 ,1 ,"String" ]             
               ,["INDV_SEX_C"             ,"암"            		   ,1 ,"String" ]               
               ,["TOT_HDCN3"              ,ftot_tot_hdcn3  		   ,1 ,"Integer"]               
               ,["TOT_HDCN"               ,ftot_tot_hdcn           ,1 ,"Integer"]               
               ,["TOT_HDCN2"              ,ftot_tot_hdcn2          ,1 ,"Integer"]               
               ,["TOT_WT"                 ,ftot_tot_wt             ,1 ,"Integer"]               
               ,["AVG_WT"                 ,isNaN(Math.round(ftot_tot_wt_22/ftot_tot_hdcn)) ? 0 : Math.round(ftot_tot_wt_22/ftot_tot_hdcn)  ,1 ,"Integer"]               
               ,["LOWS_SBID_LMT_AM"       ,ftot_lows_sbid_lmt_am   ,1 ,"Integer"]               
               ,["AVG_PR"                 ,isNaN(Math.round(ftot_bigo_lows_sbid_lmt_am/ftot_tot_hdcn)) ? 0 : Math.round(ftot_bigo_lows_sbid_lmt_am/ftot_tot_hdcn)  ,1 ,"Integer"]               
               ,["SRA_SBID_AM"            ,ftot_sra_sbid_am        ,1 ,"Integer"]               
               ,["SRA_AVG_SBID_UPR"       ,isNaN(Math.round(ftot_sra_sbid_am/ftot_tot_hdcn)) ? 0 : Math.round(ftot_sra_sbid_am/ftot_tot_hdcn)   ,1 ,"Integer"]               
               ,["BIGO"                   ,isNaN(Math.round((ftot_sra_sbid_am-ftot_bigo_lows_sbid_lmt_am)/ftot_tot_hdcn)) ? 0 : Math.round((ftot_sra_sbid_am-ftot_bigo_lows_sbid_lmt_am)/ftot_tot_hdcn)                ,1 ,"Integer"]                   
           ]
 	       ,
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
               ["AUC_DT"                 ,"합 계"           	  ,1 ,"String" ]             
              ,["INDV_SEX_C"             ,"수"            		  ,1 ,"String" ]               
              ,["TOT_HDCN3"              ,mtot_tot_hdcn3  		  ,1 ,"Integer"]               
              ,["TOT_HDCN"               ,mtot_tot_hdcn           ,1 ,"Integer"]               
              ,["TOT_HDCN2"              ,mtot_tot_hdcn2          ,1 ,"Integer"]               
              ,["TOT_WT"                 ,mtot_tot_wt             ,1 ,"Integer"]               
              ,["AVG_WT"                 ,isNaN(Math.round(mtot_tot_wt_22/mtot_tot_hdcn)) ? 0 : Math.round(mtot_tot_wt_22/mtot_tot_hdcn)             ,1 ,"Integer"]               
              ,["LOWS_SBID_LMT_AM"       ,mtot_lows_sbid_lmt_am   ,1 ,"Integer"]               
              ,["AVG_PR"                 ,isNaN(Math.round(mtot_bigo_lows_sbid_lmt_am/mtot_tot_hdcn)) ? 0 : Math.round(mtot_bigo_lows_sbid_lmt_am/mtot_tot_hdcn)             ,1 ,"Integer"]               
              ,["SRA_SBID_AM"            ,mtot_sra_sbid_am        ,1 ,"Integer"]               
              ,["SRA_AVG_SBID_UPR"       ,isNaN(Math.round(mtot_sra_sbid_am/mtot_tot_hdcn)) ? 0 : Math.round(mtot_sra_sbid_am/mtot_tot_hdcn)   ,1 ,"Integer"]               
              ,["BIGO"                   ,isNaN(Math.round((mtot_sra_sbid_am-mtot_bigo_lows_sbid_lmt_am)/mtot_tot_hdcn)) ? 0 : Math.round((mtot_sra_sbid_am-mtot_bigo_lows_sbid_lmt_am)/mtot_tot_hdcn)               ,1 ,"Integer"]                   
          ] 	
 	       ,
 	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
               ["AUC_DT"                 ,"총 합 계"           	 ,1 ,"String" ]             
              ,["INDV_SEX_C"             ,""            		 ,1 ,"String" ]               
              ,["TOT_HDCN3"              ,tot_tot_hdcn3  		 ,1 ,"Integer"]               
              ,["TOT_HDCN"               ,tot_tot_hdcn           ,1 ,"Integer"]               
              ,["TOT_HDCN2"              ,tot_tot_hdcn2          ,1 ,"Integer"]               
              ,["TOT_WT"                 ,tot_tot_wt             ,1 ,"Integer"]               
              ,["AVG_WT"                 ,isNaN(Math.round(tot_tot_wt_22/tot_tot_hdcn)) ? 0 : Math.round(tot_tot_wt_22/tot_tot_hdcn)             ,1 ,"Integer"]               
              ,["LOWS_SBID_LMT_AM"       ,tot_lows_sbid_lmt_am   ,1 ,"Integer"]               
              ,["AVG_PR"                 ,isNaN(Math.round(tot_bigo_lows_sbid_lmt_am/tot_tot_hdcn)) ? 0 : Math.round(tot_bigo_lows_sbid_lmt_am/tot_tot_hdcn)             ,1 ,"Integer"]               
              ,["SRA_SBID_AM"            ,tot_sra_sbid_am        ,1 ,"Integer"]               
              ,["SRA_AVG_SBID_UPR"       ,isNaN(Math.round(tot_sra_sbid_am/tot_tot_hdcn)) ? 0 : Math.round(tot_sra_sbid_am/tot_tot_hdcn)   ,1 ,"Integer"]               
              ,["BIGO"                   ,isNaN(Math.round((tot_sra_sbid_am-tot_bigo_lows_sbid_lmt_am)/tot_tot_hdcn)) ? 0 : Math.round((tot_sra_sbid_am-tot_bigo_lows_sbid_lmt_am)/tot_tot_hdcn)               ,1 ,"Integer"]                   
          ]  	       
 	       
        ];
 
        fn_setGridFooter('mainGrid', arr);     
      
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    // 버튼클릭 이벤트
    $(document).ready(function() {
    	
    	//경매마감 버튼클릭 이벤트
    	$(document).on("click", "button[name='btn_Ddl']", function() {
    		event.preventDefault();
    		fn_SaveDdl();
        });
    	   	
    });
    
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 종료
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
                            <col width="30">
                            <col width="50">
                            <col width="30">
                            <col width="100">                          
                            <col width="30">
                            <col width="100">
                            <col width="300">                        
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <select id="cb_auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="auc_st_dt"></div>
                                        <div class="cell ta_c"> ~ </div>
                                        <div class="cell"><input type="text" class="date" id="auc_ed_dt"></div>
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