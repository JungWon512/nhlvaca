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
	 var wkGrpNm="";
    $(document).ready(function(){  
        fn_CreateGrid();
    	$( "#st_dt" ).datepicker().datepicker("setDate", fn_getDay(-7));
        $( "#ed_dt" ).datepicker().datepicker("setDate", fn_getToday());
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
        $("#grd_MmGrpAuthLog").jqGrid("clearGridData", true);
        
        var results = sendAjaxFrm("frm_Search", "/LALM0837_selUsrList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);            
            fn_CreateGrid(result);
        }
                        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
		fn_ExcelDownlad('grd_MmGrpAuthLog', '권한변경이력 조회');
    } 

    function fn_CreateGrid(data){    	
        var rowNoValue = 0;
        if(data != null){
            rowNoValue = data.length;
        }
        var searchResultColNames = ["번호","그룹코드","사용자","적용상태","적용시작일자","적용종료일자","등록일자","등록자","수정일자","수정자","변경사유","변경일시"];        
        var searchResultColModel = [
            						{name:"GRP_USR_LOG_SQ",		index:"GRP_USR_LOG_SQ",	width:90,  sortable:false, align:'center'},
            						{name:"GRP_C",           	index:"GRP_C",          width:90,  sortable:false, align:'center'},                                    
                                    {name:"USRID",         		index:"USRID",         	width:120, sortable:false, align:'center'},
                                    {name:"APL_STS_DSC",        index:"APL_STS_DSC",    width:120, sortable:false, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:사용;2:미사용;3:기간만료;"}},
                                    {name:"APL_ST_DT",         	index:"APL_ST_DT",      width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                    {name:"APL_ED_DT",         	index:"APL_ED_DT",      width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},
                                    {name:"FSRG_DTM",           index:"FSRG_DTM",           width:70,  sortable:false, align:'center'},
                                    {name:"FSRGMN_ENO",         index:"FSRGMN_ENO",         width:70,  sortable:false, align:'center'},
                                    {name:"LSCHG_DTM",          index:"LSCHG_DTM",          width:70,  sortable:false, align:'center'},
                                    {name:"LS_CMENO",           index:"LS_CMENO",           width:70,  sortable:false, align:'center'},                                     
                                    {name:"CHG_RMK_CNTN",       index:"CHG_RMK_CNTN",   width:70,  sortable:false, align:'center'},
                                    {name:"CHG_DTM",            index:"CHG_DTM",        width:70,  sortable:false, align:'center'},                                     
		];
            
        $("#grd_MmGrpAuthLog").jqGrid("GridUnload");
                
        $("#grd_MmGrpAuthLog").jqGrid({
            datatype:    "local",
            data:        data,
            height:      550,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
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
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">사용자</th>
                                <td>
                                    <input type="text" id="usrid" style="width:80%;">
                                </td>
                                <th scope="row">조회일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="st_dt"></div>
                                        <div class="cell ta_c"> ~ </div>
                                        <div class="cell"><input type="text" class="date" id="ed_dt"></div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul> 
            </div>
            <div class="listTable mb5">
                <table id="grd_MmGrpAuthLog">
                </table>
            </div>
        </section>
        
    </div>
<!-- ./wrapper -->
</body>
</html>