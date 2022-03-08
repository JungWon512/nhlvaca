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
 * 2. 파  일  명   : LALM0511
 * 3. 파일명(한글) : 경매응찰내역 조회
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.12   이지호   최초작성
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
         
         fn_Init();   
         
         /******************************
          * 폼변경시 클리어 이벤트
          ******************************/   
         fn_setClearFromFrm("frm_Search","#mainGrid");    
         /******************************
          * 중도매인검색 팝업
          ******************************/       
      	$("#sra_mwmnnm").on("keydown", function(e){      	
            if(e.keyCode != 13) {
	           	 $("#trmn_amnno").val('');
	        	 $("#lvst_auc_ptc_mn_no").val(''); 
	        	 $("#v_trmn_amnno").val('');
			} else  if(e.keyCode == 13) {
                if(fn_isNull($("#sra_mwmnnm").val())){
                    MessagePopup('OK','응찰자 명을 입력하세요.');
                    return;
                }else {
                	 var data = new Object();
                     data['auc_obj_dsc']      = $("#cb_auc_obj_dsc").val();
                     data['auc_dt']           = fn_dateToData($("#auc_dt").val());
                     data['sra_mwmnnm']       = $("#sra_mwmnnm").val();
                     fn_CallMwmnnmNoPopup(data,true,function(result){
                         if(result){
                             $("#trmn_amnno").val(result.TRMN_AMNNO);
                             $("#lvst_auc_ptc_mn_no").val(result.LVST_AUC_PTC_MN_NO);
                             $("#sra_mwmnnm").val(result.SRA_MWMNNM);
                         }
                     });
                }
			}
        });         
         
         $("#pb_searchMwmn").on('click',function(e){
             e.preventDefault();
             this.blur();
          	    var data = new Object();          	    
                data['auc_dt']           = fn_dateToData($("#auc_dt").val());   
                data['auc_obj_dsc']      = $("#cb_auc_obj_dsc").val();                  
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
        fn_CreateGrid();
        
        //폼 초기화
        if(mv_RunMode == 0 || mv_RunMode == 1) {
        	fn_InitFrm('frm_Search');
        }     
        
        setRowStatus = "";
        
        $( "#auc_dt"   ).datepicker().datepicker("setDate", fn_getToday());
        
        $("#calf_auc_atdr_unt_am").val(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
        $("#nbfct_auc_atdr_unt_am").val(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
        $("#ppgcow_auc_atdr_unt_am").val(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);
        
        mv_RunMode = 1;
        
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
        var results = sendAjaxFrm("frm_Search", "/LALM0511_selList", "POST");        
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
   		fn_ExcelDownlad('mainGrid', '경매응찰내역조회');

    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "경매 응찰내역 조회";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[경매대상 : ' + $('#cb_auc_obj_dsc option:selected").text()  + ' / 경매일자 : '+ $('#auc_dt').val() + ' / 응찰자 : '+ $('#sra_mwmnnm').val()+']';
    	
    	ReportPopup('LALM0511R',TitleData, 'mainGrid', 'V');
    		
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
        
        	/*                            1         2         3        4       5           6           7          8         9        10   */
        	var searchResultColNames = ["경매번호", "경매대상", "귀표번호", "중량", "응찰하한가", "응찰자코드", "경매참가번호", "응찰자명", "응찰금액", "응찰시간"];        
	        var searchResultColModel = [						 
						                {name:"AUC_PRG_SQ",      	index:"AUC_PRG_SQ",         width:10, align:'center'},
						                {name:"AUC_OBJ_DSC",     	index:"AUC_OBJ_DSC",        width:10, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						                {name:"SRA_INDV_AMNNO",  	index:"SRA_INDV_AMNNO",     width:20, align:'center'},
	        							{name:"COW_SOG_WT",      	index:"COW_SOG_WT",    		width:10, align:'right'},
						                {name:"LOWS_SBID_LMT_AM",	index:"LOWS_SBID_LMT_AM",   width:15, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"TRMN_AMNNO",      	index:"TRMN_AMNNO",         width:15, align:'center'},
						                {name:"LVST_AUC_PTC_MN_NO", index:"LVST_AUC_PTC_MN_NO", width:15, align:'center'},
						                {name:"SRA_MWMNNM",         index:"SRA_MWMNNM",         width:15, align:'center'},
						                {name:"ATDR_AM",            index:"ATDR_AM",            width:15, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
						                {name:"ATDR_DTM",           index:"ATDR_DTM",           width:25, align:'center'}						                
						                ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      500,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            rownumWidth: 1,    
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
	      //행번호
	      $("#mainGrid").jqGrid("setLabel", "rn","No"); 	  
 		      
        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
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
                    <input type="hidden" id="calf_auc_atdr_unt_am">
                    <input type="hidden" id="nbfct_auc_atdr_unt_am">
                    <input type="hidden" id="ppgcow_auc_atdr_unt_am">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
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
                                        <div class="cell"><input type="text" class="date" id="auc_dt"></div>
                                    </div>
                                </td>
                                <th scope="row">응찰자코드/참가번호/응찰자</th>
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