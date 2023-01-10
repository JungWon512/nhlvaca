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
        fn_Init();
        
        $("#grd_MhSogCow").jqGrid("hideCol","AUC_DT");
        $("#grd_MhSogCow").jqGrid("hideCol","OSLP_NO");
        $("#grd_MhSogCow").jqGrid("hideCol","LED_SQNO");
        $("#grd_MhSogCow").jqGrid("hideCol","TRMN_AMNNO");
        $("#grd_MhSogCow").jqGrid("hideCol","LVST_AUC_PTC_MN_NO");        
        $("#grd_MhSogCow").jqGrid("hideCol","SEL_STS_DSC");
        $("#grd_MhSogCow").jqGrid("hideCol","DEL_YN");
        $("#grd_MhSogCow").jqGrid("hideCol","FIR_LOWS_SBID_LMT_AM");    
        $("#grd_MhSogCow").jqGrid("hideCol","SRA_SBID_AM");    
        $("#grd_MhSogCow").jqGrid("hideCol","SRA_SRS_DSC");        
        
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
       
        
        var results = sendAjaxFrm("frm_Search", "/LALM0319_selList", "POST");        
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
    	
    	
    		fn_ExcelDownlad('grd_MhSogCow', '입찰서출력');
       		
    
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
        
        var searchResultColNames = ["경매대상", "경매번호", "귀표번호", "생년월일", "성별", "KPN번호", "산차", "계대", "중량", "어미구분",
        						    "경매일자", "원표번호", "원장일련번호", "거래인관리번호", "경매참여자번호", "판매상태구분코드", "삭제여부", "최초최저낙찰한도금액", "축산낙찰금액", "축산축종구분", "예정가"];        
        var searchResultColModel = [
						            {name:"AUC_OBJ_DSC"           ,index:"AUC_OBJ_DSC"           ,width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						            {name:"AUC_PRG_SQ"            ,index:"AUC_PRG_SQ"            ,width:50, align:'center'},
						            {name:"SRA_INDV_AMNNO"        ,index:"SRA_INDV_AMNNO"        ,width:60, align:'center', formatter:'gridIndvFormat'},
						            {name:"BIRTH"                 ,index:"BIRTH"                 ,width:50, align:'center', formatter:'gridDateFormat'},
						            {name:"INDV_SEX_C"            ,index:"INDV_SEX_C"            ,width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						            {name:"KPN_NO"                ,index:"KPN_NO"                ,width:50, align:'center'},
						            {name:"MATIME"                ,index:"MATIME"                ,width:40, align:'center'},
						            {name:"SRA_INDV_PASG_QCN"     ,index:"SRA_INDV_PASG_QCN"     ,width:40, align:'center'},
						            {name:"COW_SOG_WT"            ,index:"COW_SOG_WT"            ,width:40, align:'right'},
						            {name:"MCOW_DSC"              ,index:"MCOW_DSC"              ,width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},

								    {name:"AUC_DT"                ,index:"AUC_DT"                ,width:65, align:'center'},
						            {name:"OSLP_NO"               ,index:"OSLP_NO"               ,width:65, align:'center'},
						            {name:"LED_SQNO"              ,index:"LED_SQNO"              ,width:100, align:'center'},
						            {name:"TRMN_AMNNO"            ,index:"TRMN_AMNNO"            ,width:60, align:'center'},
						            {name:"LVST_AUC_PTC_MN_NO"    ,index:"LVST_AUC_PTC_MN_NO"    ,width:60, align:'center'},
						            {name:"SEL_STS_DSC"           ,index:"SEL_STS_DSC"           ,width:120, align:'center'},
						            {name:"DEL_YN"                ,index:"DEL_YN"                ,width:85, align:'center'},
						            {name:"FIR_LOWS_SBID_LMT_AM"  ,index:"FIR_LOWS_SBID_LMT_AM"  ,width:120, align:'center'},
						            {name:"SRA_SBID_AM"           ,index:"SRA_SBID_AM"           ,width:100, align:'center'},
						            {name:"SRA_SRS_DSC"           ,index:"SRA_SRS_DSC"           ,width:100, align:'center'},
						            {name:"LOWS_SBID_LMT_AM"      ,index:"LOWS_SBID_LMT_AM"      ,width:60, align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                   ];
            
        $("#grd_MhSogCow").jqGrid("GridUnload");
                
        $("#grd_MhSogCow").jqGrid({
            datatype:    "local",
            data:        data,
            height:      520,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: true,
            rownumbers:  true,
            rownumWidth: 30, // 30 공통
            colNames: searchResultColNames,
            colModel: searchResultColModel,          
            onSelectRow:function(rowid,status, e){
            	$("#auc_prg_sq");
            }
        });

        $("#grd_MhSogCow").jqGrid("hideCol","AUC_DT");
        $("#grd_MhSogCow").jqGrid("hideCol","OSLP_NO");
        $("#grd_MhSogCow").jqGrid("hideCol","LED_SQNO");
        $("#grd_MhSogCow").jqGrid("hideCol","TRMN_AMNNO");
        $("#grd_MhSogCow").jqGrid("hideCol","LVST_AUC_PTC_MN_NO");        
        $("#grd_MhSogCow").jqGrid("hideCol","SEL_STS_DSC");
        $("#grd_MhSogCow").jqGrid("hideCol","DEL_YN");
        $("#grd_MhSogCow").jqGrid("hideCol","FIR_LOWS_SBID_LMT_AM");    
        $("#grd_MhSogCow").jqGrid("hideCol","SRA_SBID_AM");    
        $("#grd_MhSogCow").jqGrid("hideCol","SRA_SRS_DSC");   
        
    }
    

    
   
      
    
    function fn_Print(){
    	
    	 var result2;
         var results_2 = null;
         results_2 = sendAjaxFrm("frm_Search", "/LALM0319_sel_entr", "POST");        
         
         
         if(results_2.status != RETURN_SUCCESS){
        	 
             if(results_2.status == NO_DATA_FOUND){
            	 MessagePopup('OK','경매 참가자가 없습니다.',function(res){
                 });
             }else {
            	 showErrorMessage(results_2,'NOTFOUND');
             }
             return;
         }else{      
             result2 = setDecrypt(results_2);
         }  
        
    	 
        var TitleData = new Object();
       
       
       TitleData.title = "출장우(중도매인 입찰서용)내역";
       TitleData.subtitle = "";
       TitleData.unit="";
       TitleData.frlno=result2[0].FRLNO+"- *******";
       TitleData.dong=result2[0].DONGUP + " " + result2[0].DONGBW;
       TitleData.cus_mpno=result2[0].CUS_MPNO;
       TitleData.sra_mwmnnm=result2[0].SRA_MWMNNM;
       TitleData.lvst_auc_ptc_mn_no=result2[0].LVST_AUC_PTC_MN_NO;
       
       
       ReportPopup('LALM0319R0',TitleData, 'grd_MhSogCow', 'V');
      
      
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
                                     	<div>
                                     	<input hidden="ture"  id="frlno">
                                     	<input hidden="ture"  id="dongup">
                                     	<input hidden="ture"  id="dongbw">
                                     	<input hidden="ture"  id="cus_mpno">
                                     	<input hidden="ture"  id="lvst_auc_ptc_mn_no">
                                     	<input hidden="ture"  id="sra_mwmnnm">
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
                <table id="grd_MhSogCow" style="width:1807px;">
                </table>
            </div>
        </section>
        
        
        </div>
       
        </div>	
 </body>   
    
</html>