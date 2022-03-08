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
 * 2. 파  일  명   : LALM0320
 * 3. 파일명(한글) : 실시간 조회
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.10   이지호   최초작성
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
     var timeCnt = 0;
     var timer = null;
     var setRowStatus = "";
     
     $(document).ready(function(){
    	 
         fn_setCodeBox("cb_auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
         fn_setCodeRadio("auc_obj_dsc","hd_auc_obj_dsc","AUC_OBJ_DSC", 2);
         fn_setCodeRadio("sgno_prc_dsc", "hd_sgno_prc_dsc", "SGNO_PRC_DSC", 1);
         
         fn_Init();
         
         /******************************
          * 폼변경시 클리어 이벤트
          ******************************/   
         fn_setClearFromFrm("frm_Search","#mainGrid");
         
         /******************************
          * 재조회 버튼클릭 이벤트
          ******************************/
     	$(document).on("click", "button[name='pb_btnReSearch']", function() {   
     		event.preventDefault();
     		var tmpReSearchSec = $("#reSearchSec").val();
     		if(timeCnt == 0) {
     			if(!fn_isNull(tmpReSearchSec) && tmpReSearchSec > 0) {
         			$("#pb_btnReSearch").html("중지");
     				timer = setInterval(function() {
         				timeCnt++;
         				fn_Search();
             		}, parseInt(tmpReSearchSec)*1000);
     			} else {
     				MessagePopup('OK','초를 입력해주세요.');
     				return;
     			}
     			
     		} else {
     			$("#pb_btnReSearch").html("적용");
     			clearInterval(timer);
     			timeCnt = 0;
     			timer = null;
     		}
     		
        });
        
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
        if(mv_RunMode == 0 || mv_RunMode == 1) {
        	fn_InitFrm('frm_Search');
        }
        fn_InitFrm('frm_MhAucQcn');        
        
        setRowStatus = "";
        
        $( "#auc_dt"   ).datepicker().datepicker("setDate", fn_getToday());       
        
        mv_RunMode = 1;
        
        $("#pb_btnReSearch").html("적용");
    	clearInterval(timer);
		timeCnt = 0;
		timer = null;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
		if(!fn_isDate($( "#auc_dt" ).val())){
			MessagePopup('OK','경매시작일자가 날짜형식에 맞지 않습니다.',function(){
				$( "#auc_st_dt" ).focus();
			});
			return;
		}        
        var results = sendAjaxFrm("frm_Search", "/LALM0320_selList", "POST");        
        var result;
        
        $("#mainGrid").jqGrid("clearGridData", true);
        if(results.status != RETURN_SUCCESS){
        	$("#pb_btnReSearch").html("적용");
        	clearInterval(timer);
 			timeCnt = 0;
 			timer = null;
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        mv_RunMode = 2;
        fn_CreateGrid(result); 
        fn_AucIngSearch();
                
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_AucIngSearch(){
    	 
        var results = sendAjaxFrm("frm_Search", "/LALM0320_selAucIngList", "POST");        
        var result;
			 
		 if(results.status != RETURN_SUCCESS){
			 showErrorMessage(results);
			 return;
		 }else{      
             result = setDecrypt(results);           	            
         	 $("#am_eve_lmt_am").val(add_comma(result[0]["AM_EVE_LMT_AM"]));
	         $("#am_eve_sbid_am").val(add_comma(result[0]["AM_EVE_SBID_AM"]));
	         $("#su_eve_lmt_am").val(add_comma(result[0]["SU_EVE_LMT_AM"]));
         	 $("#su_eve_sbid_am").val(add_comma(result[0]["SU_EVE_SBID_AM"]));
		 }
        
        mv_RunMode = 2;
                
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
        
        	/*                               1       2        3        4         5       6       7       8       9     10     11      12        13       14        15      16*/
        	var searchResultColNames = ["경매대상", "경매번호", "출하자", "귀표번호", "생년월일", "성별", "어미구분", "KPN", "계대", "산차", "중량", "응찰하한가", "낙찰가", "낙찰가차액", "낙찰자", "진행상태"];        
	        var searchResultColModel = [						 
						                {name:"AUC_OBJ_DSC",       index:"AUC_OBJ_DSC",          width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 2)}},
						                {name:"AUC_PRG_SQ",        index:"AUC_PRG_SQ",           width:80,  align:'center'},
						                {name:"FTSNM",             index:"FTSNM",                width:80,  align:'center'},
						                {name:"SRA_INDV_AMNNO",    index:"SRA_INDV_AMNNO",       width:150, align:'center'},
						                {name:"BIRTH",             index:"BIRTH",                width:80,  align:'center'},
						                {name:"INDV_SEX_C",        index:"INDV_SEX_C",           width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						                {name:"MCOW_DSC",          index:"MCOW_DSC",             width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
						                {name:"KPN_NO",            index:"KPN_NO",               width:80,  align:'center'},
						                {name:"SRA_INDV_PASG_QCN", index:"SRA_INDV_PASG_QCN",    width:80,  align:'center'},
						                {name:"MATIME",            index:"MATIME",               width:80,  align:'center'},
						                {name:"COW_SOG_WT",        index:"COW_SOG_WT",           width:80,  align:'right' , formatter:'integer', formatoptions:{thousandsSeparator:','}},
						                {name:"LOWS_SBID_LMT_AM",  index:"LOWS_SBID_LMT_AM",     width:100, align:'right' , formatter:'integer', formatoptions:{thousandsSeparator:','}},
						                {name:"SRA_SBID_AM",       index:"SRA_SBID_AM",          width:100, align:'right' , formatter:'integer', formatoptions:{thousandsSeparator:','}},
						                {name:"DIF_SBID_AM",       index:"DIF_SBID_AM",          width:100, align:'right' , formatter:'integer', formatoptions:{thousandsSeparator:','}},
						                {name:"SRA_MWMNNM",        index:"SRA_MWMNNM",           width:80,  align:'center'},
						                {name:"SEL_STS_DSC",       index:"SEL_STS_DSC",          width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SEL_STS_DSC", 1)}}
	                                    ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
               
                
           },
        });
        
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
    
	////////////////////////////////////////////////////////////////////////////////
    //  내장 함수 종료
    ///////////////////////////////////////////////////////////////////////////////    
    function add_comma(data){
		data = String(data);
		return data.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		
	}
  
	////////////////////////////////////////////////////////////////////////////////
    //  내장 함수 종료
    ///////////////////////////////////////////////////////////////////////////////	
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
                            <col width="80">
                            <col width="*">
                            <col width="80">
                            <col width="*">
                            <col width="30">
                            <col width="80">
                            <col width="250">
                            <col width="10">
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
                                        <div class="cell"><input type="text" class="date" id="auc_dt"></div>
                                    </div>
                                </td>
                                <td></td>
                                <th scope="row">조회옵션</th>
                                <td>
                                    <input type="text" id="reSearchSec" style="width:50px"> 초 마다 재조회
                                    <button class="tb_btn" id="pb_btnReSearch" name="pb_btnReSearch" value="적용" style="width:50px">적용</button>
                                </td>    
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">진행상태</p></li>
                </ul>
                
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                	<form id="frm_MhAucQcn" name="frm_MhAucQcn">
                    <table>
                        <colgroup>
                            <col width="10">
                            <col width="30">
                            <col width="34">
                            <col width="10">
                            <col width="30">
                            <col width="30">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><p style="text-align:center; font-size:300%;">암</p></th>
                                <th scope="row" ><p style="text-align:center; font-size:150%;">응찰하한가 평균(원)</p>
                                    <input disabled="disabled" type="text" id="am_eve_lmt_am" style="text-align:right;">                               
                                </th>                               
                                <th scope="row"><p style="text-align:center; font-size:150%;">낙찰가 평균(원)</p>
                                	<input disabled="disabled" type="text" id="am_eve_sbid_am" style="text-align:right;">  
                                </th>                               
                                <th scope="row"><p style="text-align:center; font-size:300%;">수</p></th>
                                <th scope="row"><p style="text-align:center; font-size:150%;">응찰하한가 평균(원)</p>
                                	<input disabled="disabled" type="text" id="su_eve_lmt_am" style="text-align:right;">                                
                                </th>
                                <th scope="row"><p style="text-align:center; font-size:150%;">낙찰가 평균(원)</p>
                                	<input disabled="disabled" type="text" id="su_eve_sbid_am" style="text-align:right;">                                
                                </th>
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