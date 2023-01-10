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
 * 2. 파  일  명   : LALM0321
 * 3. 파일명(한글) : 산정가 처리
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.10.06   신명진   최초작성
 ------------------------------------------------------------------------------*/
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
    	
        fn_Init(); 
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#mainGrid");          
        
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
        fn_InitFrm('srchFrm_list');
        $("#auc_dt").datepicker().datepicker("setDate", fn_getToday());
        
        mv_RunMode = 1;
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){    	 
    	
    	var results = sendAjaxFrm("frm_Search", "/LALM0321_selList", "POST");        
        var result;
        
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
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){     
    	 
		MessagePopup('YESNO',"저장하시겠습니까?",function(res){
			if(res){
		        var srchData = new Object();
		        
		        srchData["calf_auc_atdr_unt_am"]   = parseInt(parent.envList[0]["CALF_AUC_ATDR_UNT_AM"]);
		        srchData["nbfct_auc_atdr_unt_am"]  = parseInt(parent.envList[0]["NBFCT_AUC_ATDR_UNT_AM"]);
		        srchData["ppgcow_auc_atdr_unt_am"] = parseInt(parent.envList[0]["PPGCOW_AUC_ATDR_UNT_AM"]);
		        srchData["auc_dt"]                 = $("#auc_dt").val();
		        srchData["auc_obj_dsc"]            = $("#auc_obj_dsc").val();
		        
				var result = sendAjax(srchData, "/LALM0321_updSogCowSjamr", "POST");            
	            if(result.status == RETURN_SUCCESS){
	            	MessagePopup("OK", "저장되었습니다.");
	            	mv_RunMode = 3;
	            	fn_Init();
	                fn_Search();
	            } else {
	            	showErrorMessage(result);
	                return;
	            }
    		}else{    			
    			MessagePopup('OK','취소되었습니다.');
    			return;
    		}
		});
        
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
        
        /*                                1        2         3         4         5         6            7             8         9 */
        var searchResultColNames = ["경매번호", "경매대상", "PAD번호", "산정위원", "산정금액", "원표번호", "계산전산정금액", "거래처관리번호", "입력일시"];        
        var searchResultColModel = [
        							 {name:"AUC_PRG_SQ",   		 	 index:"AUC_PRG_SQ",    		 width:100, align:'center'},						 
        							 {name:"AUC_OBJ_DSC",   	 	 index:"AUC_OBJ_DSC",     		 width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},        	
        							 {name:"PDA_ID",			     index:"PDA_ID",				 width:100, align:'center'},
        							 {name:"BRKR_NAME",			 	 index:"BRKR_NAME",				 width:150, align:'center'},                                     
                                     {name:"RKON_AMA",        	 	 index:"RKON_AMA",        		 width:150, align:'right', formatter:'integer', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                     {name:"OSLP_NO",      		     index:"OSLP_NO",       	   	 width:40, align:'center', hidden:true},
                                     {name:"RKON_AM",			     index:"RKON_AM",				 width:40, align:'center', hidden:true},
                                     {name:"LVST_MKT_TRPL_AMNNO",    index:"LVST_MKT_TRPL_AMNNO",	 width:40, align:'center', hidden:true},
                                     {name:"CHG_DTM",   		 	 index:"CHG_DTM",    			 width:150, align:'center'}
                                    ];
        
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,  
        });
        //행번호
        $("#mainGrid").jqGrid("setLabel", "rn","No"); 
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
                    <form id="frm_Search">
                    <table>
                        <colgroup>
                            <col width="80">
                            <col width="200">
                            <col width="80">
                            <col width="200">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
                                    <select id="auc_obj_dsc" class="popup"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_dt" maxlength="10"></div>                                        
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
                <table id="mainGrid" style="width:100%;">
                </table>
            </div>
            
        </section>       
    </div>    
</body>
</html>