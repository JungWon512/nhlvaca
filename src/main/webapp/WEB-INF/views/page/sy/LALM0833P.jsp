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
	                        <th scope="row">코드</th>
	                        <td>
	                            <input type="text" id="wk_grp_c" class="digit" maxlength="3"/>
	                        </td>
	                        <th scope="row">코드명</th>
	                        <td>
	                            <input type="text" id="wk_grpnm" maxlength="24"/>
	                        </td>  
	                    </tr>
	                    <tr>
                            <th scope="row">사용여부</th>
                            <td>
                                <select id="uyn">
	                                <option value="1">사용</option>
	                                <option value="0">미사용</option>
                                </select>
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
            <table id="grd_grpList">
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
     	$("#grd_grpList").jqGrid("clearGridData", true);
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
        $("#grd_grpList").jqGrid("clearGridData", true);        
        var results = sendAjaxFrm("frm_Search", "/LALM0833_selGrpList", "POST");        
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
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){    
    	 if($("#wk_grp_c").val() == '') {
             MessagePopup("OK", "그룹코드를 입력하세요.");
             return;
         }
    	 if($("#wk_grpnm").val() == '') {
             MessagePopup("OK", "그룹명을 입력하세요.");
             return;
         }
    	 
    	 MessagePopup('YESNO',"저장하시겠습니까?",function(res){
             if(res){
                 var results = sendAjaxFrm("frm_Search", "/LALM0833_updGrpList", "POST");        
                 var result;
                 
                 if(results.status != RETURN_SUCCESS){
                     showErrorMessage(results);
                     return;
                 }else{          
                     MessagePopup("OK", "저장되었습니다.");
                     fn_Search();
                 }      
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });
    	 
     }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Delete (){
         
        //프로그램삭제 validation check     
        if($("#wk_grp_c").val() == '') {
            MessagePopup("OK", "그룹코드를 입력하세요.");
            return;
        }
        
        MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
            if(res){
                var results = sendAjaxFrm("frm_Search", "/LALM0833_delGrpList", "POST");        
                var result;
                
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.");
                    fn_Search();
                }      
            }else{
                MessagePopup('OK','취소되었습니다.');
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
        
        var searchResultColNames = ["코드", "코드명", "사용여부"];        
        var searchResultColModel = [
						             {name:"WK_GRP_C", index:"WK_GRP_C", width:30,  align:'center'},
                                     {name:"WK_GRPNM", index:"WK_GRPNM", width:120, align:'left'},
						             {name:"UYN",      index:"UYN",      width:120, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:사용;0:미사용;"}},                                     
                                     ];
            
        $("#grd_grpList").jqGrid("GridUnload");
                
        $("#grd_grpList").jqGrid({
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
            onSelectRow: function(rowid, status, e){                                   
                var sel_data = $("#grd_grpList").getRowData(rowid);                
                $("#wk_grp_c").val(sel_data.WK_GRP_C);
                $("#wk_grpnm").val(sel_data.WK_GRPNM);
                $("#uyn").val(sel_data.UYN);
           },
        });         
        //행번호
        $("#grd_grpList").jqGrid("setLabel", "rn","No");
    }
</script>
</html>