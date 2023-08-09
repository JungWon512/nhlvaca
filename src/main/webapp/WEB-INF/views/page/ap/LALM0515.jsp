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
 * 2. 파  일  명   : LALM0515
 * 3. 파일명(한글) : 기간별 출하자 정산내역 조회
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
         fn_setCodeBox("v_jrdwo_dsc"   , "JRDWO_DSC"  , 1, true, "전체");
         
 //        fn_setCodeBox("maco_yn", "MACO_YN", 1, true);        
         fn_Init();      
 
          /******************************
           * 폼변경시 클리어 이벤트
           ******************************/   
          fn_setClearFromFrm("frm_Search","#mainGrid");
         
         /******************************
          * 농가검색 팝업
          ******************************/
         $("#ftsnm").on("keydown", function(e){
             if(e.keyCode == 13){
             	if(fn_isNull($("#ftsnm").val())){
             		MessagePopup('OK','출하주 명을 입력하세요.');
                     return;
                 }else {
                 	var data = new Object();
                     data['ftsnm'] = $("#ftsnm").val();
                     fn_CallFtsnmPopup(data,true,function(result){
                     	if(result){
                             $("#fhs_id_no").val(result.FHS_ID_NO);
                             $("#ftsnm").val(result.FTSNM);
                     	}
                     });
                 }
              }else {
             	 $("#fhs_id_no").val('');
              }
         }); 
         
         $("#pb_searchFhs").on('click',function(e){
             e.preventDefault();
             this.blur();

	            fn_CallFtsnmPopup(null,false,function(result){
	            	if(result){
	                    $("#fhs_id_no").val(result.FHS_ID_NO);
	                    $("#ftsnm").val(result.FTSNM);
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
        var results = sendAjaxFrm("frm_Search", "/LALM0515_selList", "POST");        
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

    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
   		fn_ExcelDownlad('mainGrid', '기간별 출하자 정산내역');

    }    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "기간별 출하자 정산내역";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[경매대상 : ' + $('#cb_auc_obj_dsc option:selected').text() +' / 경매일자 : '+ $('#auc_st_dt').val() + '~' + $('#auc_ed_dt').val() +' / 출하주 : ' + $('#ftsnm').val() + ' / 관내외구분 : ' + $('#v_jrdwo_dsc').val() +  ']';
    	if(App_na_bzplc == '8808990656557'){
        	ReportPopup('LALM0515R_1',TitleData, 'mainGrid', 'V');    		
    	}else{
        	ReportPopup('LALM0515R',TitleData, 'mainGrid', 'V');    		
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
        
        	/*                            1                     2               3               4               5           6            7          8           9       		 10    */
        	var searchResultColNames = [  "경매일자"     , "경매대상"           , "출하자코드"       , "출하자명"       , "출하자 생년월일"     , "조합원여부"  , "관내외구분" , "경매진행순서", "주소"     , "귀표번호", "성별","제각여부"
                                        , "생년월일"     , "어미귀표번호"        , "예정가"       , "중량(kg)"    , "낙찰단가"   , "낙찰금액"  , "출하수수료"  , "조합출자금" , "사고적립금"    , "운송비"
                                        , "괴사감정료"    , "임신감정료"         , "검진비"          , "주사료"      , "자조금"     , "혈통접수비" , "제각수수료" , "위탁수수료"  , "사료공급금액"  , "당일접수비용"
                                        , "12개월이상수수료", "정산금액"          , "수송자명"        , "친자검사여부"  , "친자검사결과" , "비고내용"  , "임신감정여부", "임신여부"   , "사료미사용여부"  , "예금주"
                                        , "계좌번호"      , "전화번호"          , "핸드폰번호"
                                        ];      
	        var searchResultColModel = [						 

						                {name:"AUC_DT",               index:"AUC_DT",               width:80, align:'center'},
						                {name:"AUC_OBJ_DSC",          index:"AUC_OBJ_DSC",          width:80, align:'center'},
						                {name:"FHS_ID_NO",            index:"FHS_ID_NO",          	width:80, align:'center'},
										{name:"FTSNM",                index:"FTSNM",              	width:80, align:'center'},
										{name:"FHS_BIRTH",            index:"FHS_BIRTH",            width:80, align:'center'},
						                {name:"MACO_YN",              index:"MACO_YN",              width:80, align:'center'},
						                {name:"JRDWO_DSC",            index:"JRDWO_DSC",          	width:80, align:'center'},
						                {name:"AUC_PRG_SQ",           index:"AUC_PRG_SQ",           width:80, align:'center'},
						                {name:"DONGUP",               index:"DONGUP",               width:250, align:'left'},
						                {name:"SRA_INDV_AMNNO",       index:"SRA_INDV_AMNNO",       width:150, align:'center'},
						                {name:"INDV_SEX_C",           index:"INDV_SEX_C",           width:80, align:'center'},
                                        {name:"RMHN_YN",              index:"RMHN_YN",              width:80, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                        {name:"BIRTH",                index:"BIRTH",                width:80, align:'center'},
						                {name:"MCOW_SRA_INDV_AMNNO",  index:"MCOW_SRA_INDV_AMNNO",  width:150, align:'center'},
						                {name:"LOWS_SBID_LMT_AM",     index:"LOWS_SBID_LMT_AM",     width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"COW_SOG_WT",           index:"COW_SOG_WT",           width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_SBID_UPR",         index:"SRA_SBID_UPR",         width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_SBID_AM",          index:"SRA_SBID_AM",          width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_SOG_FEE",          index:"SRA_SOG_FEE",          width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_PYIVA",            index:"SRA_PYIVA",            width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_ACD_RVGAM",        index:"SRA_ACD_RVGAM",        width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_TRPCS",            index:"SRA_TRPCS",            width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_NCSS_JUG_FEE",     index:"SRA_NCSS_JUG_FEE",     width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_PRNY_JUG_FEE",     index:"SRA_PRNY_JUG_FEE",     width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_MDCCS",            index:"SRA_MDCCS",            width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_INJT_FEE",         index:"SRA_INJT_FEE",         width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_SHNM",             index:"SRA_SHNM",             width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_PDG_RC_FEE",       index:"SRA_PDG_RC_FEE",       width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_RMHN_FEE",         index:"SRA_RMHN_FEE",         width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_TRU_FEE",          index:"SRA_TRU_FEE",          width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"SRA_FED_SPY_AM",       index:"SRA_FED_SPY_AM",       width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"TD_RC_CST",            index:"TD_RC_CST",            width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"MT12_OVR_FEE",         index:"MT12_OVR_FEE",         width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"TOT_AM",               index:"TOT_AM",               width:100, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"VHC_DRV_CAFFNM",       index:"VHC_DRV_CAFFNM",       width:100, align:'center'},
						                {name:"DNA_YN_CHK",           index:"DNA_YN_CHK",           width:100, align:'center'},
						                {name:"DNA_YN",               index:"DNA_YN",               width:100, align:'center'},
						                {name:"RMK_CNTN",             index:"RMK_CNTN",             width:150, align:'left'},
						                {name:"PRNY_JUG_YN",          index:"PRNY_JUG_YN",          width:100, align:'center'},
						                {name:"PRNY_YN",              index:"PRNY_YN",              width:100, align:'center'},
						                {name:"SRA_FED_SPY_YN",       index:"SRA_FED_SPY_YN",       width:100, align:'center'},
						                {name:"ACNO_OWNER",           index:"ACNO_OWNER",           width:100, align:'center'},
						                {name:"SRA_FARM_ACNO",        index:"SRA_FARM_ACNO",        width:100, align:'center'},
						                {name:"OHSE_TELNO",           index:"OHSE_TELNO",           width:100, align:'center'},
						                {name:"CUS_MPNO",             index:"CUS_MPNO",             width:100, align:'center'}
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
        });
        
        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No");  
        
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
        //암 합 
        var tot_sra_indv_amnno   = 0;
        var tot_sra_sbid_am      = 0; 
        var tot_sra_sog_fee      = 0; //출장두수                
        var tot_sra_pyiva        = 0; //두수                    
        var tot_sra_acd_rvgam    = 0; //유찰두수                
        var tot_sra_trpcs        = 0; //전체(kg)                
        var tot_sra_ncss_jug_fee = 0; //평균(kg)                
        var tot_sra_prny_jug_fee = 0; //총 예정가(A)
        var tot_sra_mdccs        = 0; //예정가<br>평균금액( 
        var tot_sra_injt_fee     = 0; //총 낙찰가<br>금액       
        var tot_sra_shnm         = 0; //낙찰가<br>평균금액(B)   
        var tot_sra_pdg_rc_fee   = 0; //비고(평균차액)<br>(B-A) 
        var tot_sra_rmhn_fee     = 0; //두수                    
        var tot_sra_tru_fee      = 0; //유찰두수                
        var tot_sra_fed_spy_am   = 0; //전체(kg)                
        var tot_td_rc_cst        = 0; //평균(kg)                
        var tot_mt12_ovr_fee     = 0; //총 예정가(A)
        var tot_tot_am           = 0; //예정가<br>평균금액( 
        
        $.each(gridDatatemp,function(i){
        	//합계
        	tot_sra_indv_amnno++;
 //       	if(gridDatatemp[i].INDV_SEX_C == '1' || gridDatatemp[i].INDV_SEX_C == '4' || gridDatatemp[i].INDV_SEX_C == '6' ){
            tot_sra_sbid_am      += parseInt(gridDatatemp[i].SRA_SBID_AM);      
            tot_sra_sog_fee      += parseInt(gridDatatemp[i].SRA_SOG_FEE);     
            tot_sra_pyiva        += parseInt(gridDatatemp[i].SRA_PYIVA);       
            tot_sra_acd_rvgam    += parseInt(gridDatatemp[i].SRA_ACD_RVGAM);   
            tot_sra_trpcs        += parseInt(gridDatatemp[i].SRA_TRPCS);       
            tot_sra_ncss_jug_fee += parseInt(gridDatatemp[i].SRA_NCSS_JUG_FEE);    
            tot_sra_prny_jug_fee += parseInt(gridDatatemp[i].SRA_PRNY_JUG_FEE);
            tot_sra_mdccs        += parseInt(gridDatatemp[i].SRA_MDCCS);       
            tot_sra_injt_fee     += parseInt(gridDatatemp[i].SRA_INJT_FEE);        
            tot_sra_shnm         += parseInt(gridDatatemp[i].SRA_SHNM);        
            tot_sra_pdg_rc_fee   += parseInt(gridDatatemp[i].SRA_PDG_RC_FEE);  
            tot_sra_rmhn_fee     += parseInt(gridDatatemp[i].SRA_RMHN_FEE);        
            tot_sra_tru_fee      += parseInt(gridDatatemp[i].SRA_TRU_FEE);     
            tot_sra_fed_spy_am   += parseInt(gridDatatemp[i].SRA_FED_SPY_AM);  
            tot_td_rc_cst        += parseInt(gridDatatemp[i].TD_RC_CST);           
            tot_mt12_ovr_fee     += parseInt(gridDatatemp[i].MT12_OVR_FEE);     
            tot_tot_am           += parseInt(gridDatatemp[i].TOT_AM);  	  
//        	}       	

        }); 
        
        var arr = [
		  	       [//입력 컬럼 , 입력값, COLSPAN, 타입{String/Integer/Number}
                        ["AUC_DT"                ,"합 계"                ,8 ,"String" ]             
                       ,["SRA_INDV_AMNNO"        ,"두 수"                ,1 ,"String" ]   
                       ,["INDV_SEX_C"            ,tot_sra_indv_amnno    ,1 ,"Integer"]                                      
                       ,["SRA_SBID_AM"           ,tot_sra_sbid_am       ,1 ,"Integer"]               
                       ,["SRA_SOG_FEE"           ,tot_sra_sog_fee       ,1 ,"Integer"]               
                       ,["SRA_PYIVA"             ,tot_sra_pyiva         ,1 ,"Integer"]               
                       ,["SRA_ACD_RVGAM"         ,tot_sra_acd_rvgam     ,1 ,"Integer"]               
                       ,["SRA_TRPCS"             ,tot_sra_trpcs         ,1 ,"Integer"]               
                       ,["SRA_NCSS_JUG_FEE"      ,tot_sra_ncss_jug_fee  ,1 ,"Integer"]               
                       ,["SRA_PRNY_JUG_FEE"      ,tot_sra_prny_jug_fee  ,1 ,"Integer"]               
                       ,["SRA_MDCCS"             ,tot_sra_mdccs         ,1 ,"Integer"]               
                       ,["SRA_INJT_FEE"          ,tot_sra_injt_fee      ,1 ,"Integer"]               
                       ,["SRA_SHNM"              ,tot_sra_shnm          ,1 ,"Integer"]   
                       ,["SRA_PDG_RC_FEE"        ,tot_sra_pdg_rc_fee    ,1 ,"Integer"]               
                       ,["SRA_RMHN_FEE"          ,tot_sra_rmhn_fee      ,1 ,"Integer"]               
                       ,["SRA_TRU_FEE"           ,tot_sra_tru_fee       ,1 ,"Integer"]               
                       ,["SRA_FED_SPY_AM"        ,tot_sra_fed_spy_am    ,1 ,"Integer"]               
                       ,["TD_RC_CST"             ,tot_td_rc_cst         ,1 ,"Integer"]               
                       ,["MT12_OVR_FEE"          ,tot_mt12_ovr_fee      ,1 ,"Integer"]               
                       ,["TOT_AM"                ,tot_tot_am            ,1 ,"Integer"]                  
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
                            <col width="70">
                            <col width="150">
                            <col width="70">
                            <col width="250">                          
                            <col width="50">     
                            <col width="250"> 
                            <col width="80">     
                            <col width="150">     
                            <col width="*">                                                                                                                                                                
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
                                <th scope="row">출하주</th>
                                <td>
                                    <div class="cellBox v_addr">
                                         <div class="cell" style="width:250px;">
                                             <input disabled="disabled" type="text" id="fhs_id_no">                                             
                                         </div>
                                         <div class="cell pl2" style="width:350px;">
                                             <input type="text" id="ftsnm">
                                         </div>
                                         <div class="cell pl2">
                                             <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                         </div>                                         
                                     </div>
                                </td>                                
                                 <th scope="row">관내외구분</th>
                                <td>
                                    <select id="v_jrdwo_dsc"></select>
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