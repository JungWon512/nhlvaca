<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

<%@ include file="../../../common/serviceCall.jsp" %>
<%@ include file="../../../common/head.jsp" %> 

</head>
<script type="text/javascript">
	var na_bzplc = App_na_bzplc;
	
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
        fn_setCodeBox("auc_dt", "AUC_DT", 1, true); 
        fn_setCodeBox("sel_sts_dsc", "SEL_STS_DSC", 1, true,"전체");
        fn_setCodeBox("st_auc_num", "ST_AUC_NUM", 1, true); 
        fn_setCodeBox("ed_auc_num", "ED_AUC_NUM", 1, true); 
        //fn_setCodeBox("ddl_qcn", "DDL_QCN", 1, true); 
        fn_Init();
        /******************************
         * 폼변경시 클리어 이벤트
         *****************************/   
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
        fn_InitFrm('frm_Search');
        $( "#auc_dt" ).datepicker().datepicker("setDate", fn_getToday());
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
        //프로그램 리스트              
         
        var results = sendAjaxFrm("frm_Search", "/LALM0318_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        fn_CreateGrid(result);                 
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
    	fn_ExcelDownlad('grd_MhSogCow', '낙유찰 라벨발행');
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
        
        var searchResultColNames = ["경매대상", "경매번호", "귀표번호<br>(4자리)", "귀표번호"
                                  , "성별", "응찰하한가","낙찰가","낙찰단위", "낙찰가", "낙찰번호<br>(참가번호)", "낙찰자", "농가명"
                                  , "농가주소", "농가핸드폰번호"];        
        var searchResultColModel = [
                                     {name:"AUC_OBJ_DSC",               index:"AUC_OBJ_DSC",              width:70, align:'center',edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"AUC_PRG_SQ",                index:"AUC_PRG_SQ",               width:70, align:'center'},
                                     {name:"SRA_INDV_AMNNO_BARCODE",    index:"SRA_INDV_AMNNO_BARCODE",   width:80, align:'center'},
                                     {name:"SRA_INDV_AMNNO",            index:"SRA_INDV_AMNNO",           width:100, align:'center'},
                                     {name:"INDV_SEX_C",                index:"INDV_SEX_C",               width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"FIR_LOWS_SBID_LMT_AM",      index:"FIR_LOWS_SBID_LMT_AM",     width:80, align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                     {name:"SRA_SBID_UPR",              index:"SRA_SBID_UPR",             width:0,  align:'right',hidden:true},
                                     {name:"PRICE_UNIT",              	index:"PRICE_UNIT",               width:0,  align:'right',hidden:true},
                                     {name:"SRA_SBID_AM",               index:"SRA_SBID_AM",              width:80, align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                     {name:"LVST_AUC_PTC_MN_NO",        index:"LVST_AUC_PTC_MN_NO",       width:70, align:'center'},
                                     {name:"SRA_MWMNNM",                index:"SRA_MWMNNM",               width:70, align:'center'},
                                     {name:"FTSNM",                     index:"FTSNM",                    width:70, align:'center'},
                                     {name:"DONG",                      index:"DONG",                     width:150, align:'left'},
                                     {name:"CUS_MPNO",                  index:"CUS_MPNO",                 width:100, align:'center'}
                                     ];
        
        $("#grd_MhSogCow").jqGrid("GridUnload");
                
        $("#grd_MhSogCow").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel, 
        });
		
        
    }
    

    
   
      
    
    function fn_Print(){
        
        //메뉴리스트 가져오기
    	 
        var TitleData = new Object();
       
       
       TitleData.title = "";
       
        
       if(na_bzplc == '8808990687094'){    // 영주:8808990687094  테스트: 8808990643625
    	   ReportPopup('LALM0318R0',TitleData, 'grd_MhSogCow', 'V');
    	
       }else{
    	   ReportPopup('LALM0318R0_1',TitleData, 'grd_MhSogCow', 'V');
           
       }
      
       
    } 
    
    
    
  
    
    

    </script>
 <body>
	<div class="contents">
		 <%@ include file="/WEB-INF/common/menuBtn.jsp" %>
	
	
	<div class="container">
	
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
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                           
                            <!-- 버튼 있는 테이블은 width 94 고정 -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                	<select id ="auc_obj_dsc">
                                   		
                                    </select>
                                </td>
                                <th scope="row"><span class="tb_dot">경매일자</span></th>
                               		 <td>
                                     	<div class="cell"><input type="text" class="date" id="auc_dt"></div>
                               		 </td>
                                <th scope="row">구분</th>
                                <td>
                                    <select id = "sel_sts_dsc">
                                   		
                                    </select>
                                </td>                            
                                <th scope="row"><span class="tb_dot">경매번호</span></th>
                                <td>
                                    <div class="cellBox">
                                    
                                        <div class="cell"><input type="text" id="st_auc_no"></div>
                                        <div class="cell ta_c"> ~ </div>
                                        <div class="cell"><input type="text" id="ed_auc_no"></div>
                                    
                                    </div>
                                </td>
                                
                                <th scope="row"><span class="tb_dot">마감차수</span></th>
                                <td>
                                	<select id = "ddl_qcn">
                                   			<option value="">전체</option>
                                   			<option value="1">1차</option>
	                                    	<option value="2">2차</option>
	                                    	<option value="3">3차</option>		
	                                    	<option value="4">4차</option>	   			
                                    </select>
                                	
                                   <!-- <div class="cell"><input type="text" id="ddl_qcn"></div> -->
                                </td>
                                </tr>
                              
                        </tbody>
                    </table>
                    </form>
                </div>
                <div class="radio_btns">
                <table>
               
                            </table>
                </div> 
            </div>
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
         
            
            <div class="listTable rsp_v">
                <table id="grd_MhSogCow" style="width:1807px;">
                </table>
            </div>
        </section>
        
        
        </div>
       
        </div>	
 </body>   
    
</html>