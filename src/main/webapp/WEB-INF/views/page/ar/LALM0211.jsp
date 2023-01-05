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
    	fn_CreateGrid(); 
        fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 1, true); 
        fn_Init();
        
        $(window).on('resize.jqGrid',function(){
        	$('#grd_MhFee').setGridWidth($('.content').width() - 17,true);
        })
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        $("#grd_MhFee").jqGrid("clearGridData", true);
        //폼 초기화
        fn_InitFrm('frm_Search');
        $( "#auc_obj_dsc" ).val($( "#auc_obj_dsc option:first").val());
        $( "#apl_dt" ).datepicker().datepicker("setDate", fn_getToday());
        $( "#auc_obj_dsc" ).focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
        //정합성체크
        if(fn_isNull($( "#auc_obj_dsc" ).val()) == true) {
        	MessagePopup('OK','경매대상구분을 선택하세요.',function(){
        		$( "#auc_obj_dsc" ).focus();
        	});
            return;
        }
        if(fn_isNull($( "#apl_dt" ).val()) == true){
        	MessagePopup('OK','적용일자를 선택하세요.',function(){
        		$( "#apl_dt" ).focus();
            });
            return;
        }
        
        if(fn_isDate($( "#apl_dt" ).val()) == false){
        	MessagePopup('OK','적용일자가 날짜형식에 맞지 않습니다.',function(){
                $( "#apl_dt" ).focus();
            });
            return;
        }
        $("#grd_MhFee").jqGrid("clearGridData", true);
        var results = sendAjaxFrm("frm_Search", "/LALM0211_selList", "POST");        
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
         fn_ExcelDownlad('grd_MhFee', '수수료조회');
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
        
        var searchResultColNames = ["경매대상구분", "적용일자", "적용대상", "번식우수수료구분", "수수료코드"
                                  , "수수료명", "단수처리", "금액/비율", "조합원수수료", "비조합원수수료"
                                  , "공제/지급", "낙찰구분",];        
        var searchResultColModel = [
                                     {name:"AUC_OBJ_DSC",    index:"AUC_OBJ_DSC",    width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AUC_OBJ_DSC", 1)}},
                                     {name:"APL_DT",         index:"APL_DT",         width:100, align:'center', formatter:'gridDateFormat'},
                                     {name:"FEE_APL_OBJ_C",  index:"FEE_APL_OBJ_C",  width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("FEE_APL_OBJ_C", 1)}},
                                     {name:"PPGCOW_FEE_DSC", index:"PPGCOW_FEE_DSC", width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("PPGCOW_FEE_DSC", 1)}},
                                     {name:"NA_FEE_C",       index:"NA_FEE_C",       width:100, align:'center'},
                                     {name:"SRA_FEENM",      index:"SRA_FEENM",      width:100, align:'center'},
                                     {name:"SGNO_PRC_DSC",   index:"SGNO_PRC_DSC",   width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SGNO_PRC_DSC", 1)}},
                                     {name:"AM_RTO_DSC",     index:"AM_RTO_DSC",     width:100, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("AM_RTO_DSC", 1)}},
                                     {name:"MACO_FEE_UPR",   index:"MACO_FEE_UPR",   width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"NMACO_FEE_UPR",  index:"NMACO_FEE_UPR",  width:100, align:'right', formatter:'currency', formatoptions:{decimalPlaces:0,thousandsSeparator:','}},
                                     {name:"AMN_HCNT",       index:"AMN_HCNT",       width:60, align:'center'},
                                     {name:"SBID_YN",        index:"SBID_YN",        width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                    ];
            
        $("#grd_MhFee").jqGrid("GridUnload");
                
        $("#grd_MhFee").jqGrid({
            datatype:    "local",
            data:        data,
            height:      520,
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
	      $("#grd_MhFee").jqGrid("setLabel", "rn","No");         
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
                    <form id="frm_Search" name="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상구분<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="auc_obj_dsc" class="popup"></select>
                                </td>
                                <th scope="row">적용일자<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="apl_dt"></div>
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
            <div class="listTable mb0">
                <table id="grd_MhFee">
                </table>
            </div>
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>