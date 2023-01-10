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
<body>
    <div class="pop_warp">
        <div class="tab_box btn_area clearfix">
            <ul class="tab_list fl_L">
                <li><p class="dot_allow" >검색조건</p></li>
            </ul>
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="blueTable rsp_v">
                <form id="frm_Search" name="frm_Search">
                <table width="100%">
                    <colgroup>
                        <col width="85">
                        <col width="*">
                        <col width="85">
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
                                        <div class="cell"><input type="text" class="date" id="auc_dt"></div>
                                    </div>
                                </td>
                            </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">검색결과</p></li>
            </ul>
        </div>
        
        <div class="listTable">           
            <table id=grd_MhAtdrLog>
            </table>
        </div>
    </div>
    <!-- //pop_body e -->
</body>
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
    	fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
    	//그리드 초기화
        fn_CreateGrid();
        if(pageInfo.param){
        	//폼 초기화
            fn_InitFrm('frm_Search');        	
         	$("#auc_obj_dsc").val(pageInfo.param.auc_obj_dsc);    
        	$("#auc_dt").val(pageInfo.param.auc_dt);    
         	
        	if( pageInfo.result != null){
        		fn_CreateGrid(pageInfo.result);
        	}
            $("#auc_dt").focus();
        }else {
            fn_Init();
        }
    
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A  AtdrLog
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
//    	 fn_CreateGrid();
     	//그리드 초기화
      	$("#grd_MhAtdrLog").jqGrid("clearGridData", true);
         //폼 초기화
        fn_InitFrm('frm_Search');
 //       $("#auc_dt").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){   
     	//그리드 초기화
     	$("#grd_MhAtdrLog").jqGrid("clearGridData", true); 
    	  
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0323P_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        fn_CreateGrid(result);                 
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
        
         var searchResultColNames = ["경매번호", "경매대상", "귀표번호", "예정가", "응찰금액", "참여자번호", "중도매인명", "응찰시간"];        
        var searchResultColModel = [
						             {name:"AUC_PRG_SQ"			, index:"AUC_PRG_SQ"		, width:80,  align:'center'},
                                     {name:"AUC_OBJ_DSC"		, index:"AUC_OBJ_DSC"		, width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
						             {name:"SRA_INDV_AMNNO"	    , index:"SRA_INDV_AMNNO"    , width:80,  align:'center'},
                                     {name:"LOWS_SBID_LMT_AM"	, index:"LOWS_SBID_LMT_AM"	, width:90,  align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                     {name:"ATDR_AM"			, index:"ATDR_AM"			, width:90,  align:'right', formatter:'currency', formatoptions:{thousandsSeparator:',', decimalPlaces: 0}},
                                     {name:"LVST_AUC_PTC_MN_NO"	, index:"LVST_AUC_PTC_MN_NO", width:90,  align:'center'},
                                     {name:"SRA_MWMNNM"         , index:"SRA_MWMNNM"        , width:90,  align:'center'},
                                     {name:"ATDR_DTM" 	        , index:"ATDR_DTM"			, width:80,  align:'center'},  
                                     
                                     ];
            
        $("#grd_MhAtdrLog").jqGrid("GridUnload");
                
        $("#grd_MhAtdrLog").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
                 
    }
    
</script>
</html>