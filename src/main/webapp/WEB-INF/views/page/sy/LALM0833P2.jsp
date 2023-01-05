
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
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="blueTable rsp_v">
                <form id="frm_Search" name="frm_Search">
                <table>
                    <colgroup>
                        <col width="85">
                        <col width="*">
                        <col width="85">
                        <col width="*">                         
                    </colgroup>
                    <tbody>
	                    <tr>
	                        <th scope="row">사용자 ID</th>
	                        <td>
	                            <input type="text" id="usrid"/>
	                        </td>
	                        <th scope="row">사용자 명</th>
	                        <td>
	                            <input type="text" id="usrnm"/>
	                        </td>  
	                    </tr>
                    </tbody>
                </table>
                </form>
            </div>
        </div>
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">검색내용</p></li>
            </ul>
        </div>
        <div class="listTable">           
            <table id="grd_usrList">
            </table>
        </div>
    </div>
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
    	//그리드 초기화
        fn_CreateGrid();            	
    });
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
     	//그리드 초기화
     	$("#grd_usrList").jqGrid("clearGridData", true);
         //폼 초기화
        fn_InitFrm('frm_Search');
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){    	    	      
        //그리드 초기화
        $("#grd_usrList").jqGrid("clearGridData", true);        
        var results = sendAjaxFrm("frm_Search", "/LALM0833_selUsrList", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        
        //폼 초기화
        fn_InitFrm('frm_Search');
        fn_CreateGrid(result);
    } 
    function fn_Select(){     
        var sel_rowid = $("#grd_usrList").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_usrList").jqGrid("getRowData", sel_rowid);
        
        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
        parentInput.val(true).trigger('change');
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
        
        var searchResultColNames = ["아이디", "사용자 명"];        
        var searchResultColModel = [
						             {name:"USRID", index:"USRID", width:30,  align:'center'},
                                     {name:"USRNM", index:"USRNM", width:120, align:'left'}                                     
                                     ];
            
        $("#grd_usrList").jqGrid("GridUnload");
                
        $("#grd_usrList").jqGrid({
            datatype:    "local",
            data:        data,
            height:      280,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, iRow, iCol){
                pageInfo.returnValue = $("#grd_usrList").jqGrid("getRowData", rowid);                
                var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
                parentInput.val(true).trigger('change');
           },
        });         
        //행번호
        $("#grd_usrList").jqGrid("setLabel", "rn","No");
    }
</script>
</html>