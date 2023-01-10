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
    	fn_getNaList();
//     	$( "#stD_dt" ).datepicker().datepicker("setDate", fn_getDay(-7));
//         $( "#ed_dt" ).datepicker().datepicker("setDate", fn_getToday());
        $( "#opr_dt" ).datepicker().datepicker("setDate", fn_getToday());
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     function fn_getNaList(){
         var results = sendAjaxFrm("frm_Search", "/LALM0838_selNaList", "POST");        
         var result;
         
         if(results.status != RETURN_SUCCESS){
             showErrorMessage(results);
             return;
         }else{      
             result = setDecrypt(results);
             var sel = $('#na_bzplc');
        	 sel.append("<option value=''>선택</option>")
             result.forEach((o)=>{
            	 console.log(o);
            	 sel.append("<option value='"+o.NA_BZPLC+"'>"+o.NA_BZPLNM+"</option>")
             });
         }
                                           
     }
    function fn_Search(){      
        $("#grd_BiPsnInf").jqGrid("clearGridData", true);
        
        var results = sendAjaxFrm("frm_Search", "/LALM0838_selList", "POST");        
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
		fn_ExcelDownlad('grd_BiPsnInf', '개인정보 열람이력 조회');
    } 

    function fn_CreateGrid(data){
        var rowNoValue = 0;
        if(data != null){
            rowNoValue = data.length;
        }
        var searchResultColNames = ["조합","조작일자","화면ID","검색조건","조회 건수","기능유형","IP 주소","조작 사유","등록일시","등록자"];        
        var searchResultColModel = [
									{name:"CLNTNM",				index:"CLNTNM",				width:60},
            						{name:"OPR_DT",				index:"OPR_DT",				width:60,  sortable:false, align:'center',formatter:'gridDateFormat'},
            						{name:"PGID",           	index:"WK_GRP_C",           width:50,  sortable:false, align:'center'},
                                    {name:"SRCH_CND_CNTRN",     index:"SRCH_CND_CNTRN",     width:70,  sortable:false, align:'left'},
                                    {name:"INQ_CN",         	index:"INQ_CN",         	width:50, sortable:false, align:'center'},
                                    {name:"BTN_TPC",         	index:"BTN_TPC",         	width:70,  sortable:false, align:'center',edittype:"select", formatter : "select", editoptions:{value:'S:조회;E:엑셀'}},
                                    {name:"IPADR",       		index:"IPADR",       		width:70,  sortable:false, align:'center'},
                                    {name:"APVRQR_RSNCTT",      index:"APVRQR_RSNCTT",      width:200,  sortable:false, align:'center'},
                                    {name:"FSRG_DTM",           index:"FSRG_DTM",           width:70,  sortable:false, align:'center'},
                                    {name:"FSRGMN_ENO",         index:"FSRGMN_ENO",         width:70,  sortable:false, align:'center'}                                     
		];
            
        $("#grd_BiPsnInf").jqGrid("GridUnload");
                
        $("#grd_BiPsnInf").jqGrid({
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
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">조합</th>
                                <td>
                                	<select id="na_bzplc">
                                	</select>
                                </td>
                                <th scope="row">프로그램 ID</th>
                                <td colspan="1">
                                	<input type="text" id="pgid">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">조회일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="opr_dt"></div>
<!--                                         <div class="cell"><input type="text" class="date" id="st_dt"></div> -->
<!--                                         <div class="cell ta_c"> ~ </div> -->
<!--                                         <div class="cell"><input type="text" class="date" id="ed_dt"></div> -->
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
                <table id="grd_BiPsnInf">
                </table>
            </div>
        </section>
        
    </div>
<!-- ./wrapper -->
</body>
</html>