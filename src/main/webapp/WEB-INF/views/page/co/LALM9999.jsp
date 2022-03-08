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
            <ul class="tab_list fl_L" id="backdoor">
                <li><p class="dot_allow" >검색조건</p></li>
            </ul>
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="grayTable rsp_v">
                <form id="frm_Input" name="frm_Input">
                <table width="100%">
                    <colgroup>
                        <col width="100%">                 
                    </colgroup>
                    <tbody>
                        <tr> 
                            <td>
                                <textarea id="query_text" style="height:250px;"></textarea>
                            </td>
                        </tr>
                        
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="listTable">
            <table id="grd_Data">
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
    	fn_CreateGrid();
    	$('#backdoor').on('click',function(){
    		
    		var data = new Object();
            data['updateBack'] = "1";  
            var results;
            var result;
            var encrypt = setEncrypt(data);
            
            $.ajax({
                   url: '/co/Common_updbackFile',
                   type: "POST",
                   dataType:'json',
                   header:{
                       "Content-Type":"application/json"},
                   async: false,
                   data:{
                          data : encrypt.toString()
                   },
                   success:function(data) {                                    
                       results = data;  
                       if(results.status == RETURN_SUCCESS){
                           result = setDecrypt(results);
                           $('#query_text').val(decodeURIComponent(result.back));
                       }else {
                           showErrorMessage(results);
                           return;
                       } 
                   },
                   error:function(response){
                       showErrorMessage(results);
                       return;
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
        $("#grd_Data").jqGrid("clearGridData", true);
        //폼 초기화
        fn_InitFrm('frm_Input');
        var data = new Object();
        data['updateBack'] = "0";  
        var results;
        var result;
        var encrypt = setEncrypt(data);
        
        $.ajax({
               url: '/co/Common_updbackFile',
               type: "POST",
               dataType:'json',
               header:{
                   "Content-Type":"application/json"},
               async: false,
               data:{
                      data : encrypt.toString()
               },
               success:function(data) {                                    
                   results = data;  
                   if(results.status == RETURN_SUCCESS){
                       result = setDecrypt(results);
                       $('#query_text').val(decodeURIComponent(result.back));
                   }else {
                       showErrorMessage(results);
                       return;
                   } 
               },
               error:function(response){
                   showErrorMessage(results);
                   return;
               }
        });
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){  
        var results = sendAjaxFrm("frm_Input", "/Common_selBack", "POST");        
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
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
         MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
             if(res){
            	 
            	 var dataArr = $('#query_text').val().replace(/\n+/g,'').split(';');
                 var fix_pos     = 100;
                 var cow_st_pos  = 0;
                 var cow_ed_pos  = fix_pos ;
                 var cow_tot_pos = dataArr.length - 1;
                 
                 while(true){
                     if(cow_tot_pos < cow_ed_pos) cow_ed_pos = cow_tot_pos;
                     
                     var sendData = '';
                     for(var i = cow_st_pos; i < cow_ed_pos ; i++){
                         sendData = sendData + dataArr[i] + ';';
                     }
                     var srchData = new Object();
                     srchData["query_text"]  = sendData; 
                     var result = sendAjax(srchData, "/Common_updBack", "POST");
                     if(result.status != RETURN_SUCCESS){
                         showErrorMessage(result);
                         break;
                     }
                     //종료포지션이 전체카운트보다 
                     if(cow_ed_pos == cow_tot_pos){
                         MessagePopup("OK", "정상적으로 처리되었습니다.");
                         break;
                     }
                     cow_st_pos += fix_pos;
                     cow_ed_pos += fix_pos;                     
                 }                   
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });      
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 추가 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Insert(){
         MessagePopup('YESNO',"추가 하시겠습니까?",function(res){
             if(res){
            	 var dataArr = $('#query_text').val().replace(/\n+/g,'').split(';');
            	 var fix_pos     = 100;
            	 var cow_st_pos  = 0;
                 var cow_ed_pos  = fix_pos ;
                 var cow_tot_pos = dataArr.length - 1;
                 
            	 while(true){
            		 if(cow_tot_pos < cow_ed_pos) cow_ed_pos = cow_tot_pos;
            		 
            		 var sendData = '';
            		 for(var i = cow_st_pos; i < cow_ed_pos ; i++){
            			 sendData = sendData + dataArr[i] + ';';
            		 }
            		 var srchData = new Object();
                     srchData["query_text"]  = sendData; 
                     var result = sendAjax(srchData, "/Common_insBack", "POST");
                     if(result.status != RETURN_SUCCESS){
                         showErrorMessage(result);
                         break;
                     }
                     //종료포지션이 전체카운트보다 
                     if(cow_ed_pos == cow_tot_pos){
                    	 MessagePopup("OK", "정상적으로 처리되었습니다.");
                         break;
                     }
                     cow_st_pos += fix_pos;
                     cow_ed_pos += fix_pos;                     
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
    function fn_Delete(){
         MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
             if(res){
            	 var dataArr = $('#query_text').val().replace(/\n+/g,'').split(';');
                 var fix_pos     = 100;
                 var cow_st_pos  = 0;
                 var cow_ed_pos  = fix_pos ;
                 var cow_tot_pos = dataArr.length - 1;
                 
                 while(true){
                     if(cow_tot_pos < cow_ed_pos) cow_ed_pos = cow_tot_pos;
                     
                     var sendData = '';
                     for(var i = cow_st_pos; i < cow_ed_pos ; i++){
                         sendData = sendData + dataArr[i] + ';';
                     }
                     var srchData = new Object();
                     srchData["query_text"]  = sendData; 
                     var result = sendAjax(srchData, "/Common_delBack", "POST");
                     if(result.status != RETURN_SUCCESS){
                         showErrorMessage(result);
                         break;
                     }
                     //종료포지션이 전체카운트보다 
                     if(cow_ed_pos == cow_tot_pos){
                         MessagePopup("OK", "정상적으로 처리되었습니다.");
                         break;
                     }
                     cow_st_pos += fix_pos;
                     cow_ed_pos += fix_pos;                     
                 }                   
             }else{
                 MessagePopup('OK','취소되었습니다.');
             } 
         });      
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
        fn_ExcelDownlad('grd_Data', '쿼리분석');
    } 
    
    //그리드 생성 
    function fn_CreateGrid(data){
        
        var rowNoValue = 0;  
        var searchResultColNames ;
        var searchResultColModel = new Array();
        if(data != null){
            rowNoValue = data.length;
            var header = Object.keys(data[0]);
            
            searchResultColNames = Object.keys(data[0]);
            for(var i=0;i<searchResultColNames.length;i++){
            	var obj = {name:searchResultColNames[i] , index:searchResultColNames[i],           width:100, align:'center'};
            	searchResultColModel.push(obj);
            }
            
        }else {
        	searchResultColNames = ["col1","col2","col3","col4","col5","col6","col7","col8","col9","col10"];  
        	searchResultColModel = [
                {name:"col1",           index:"col1",           width:50, align:'center'},
                {name:"col2",           index:"col2",           width:50, align:'center'},
                {name:"col3",           index:"col3",           width:50, align:'center'},
                {name:"col4",           index:"col4",           width:50, align:'center'},
                {name:"col5",           index:"col5",           width:50, align:'center'},
                {name:"col6",           index:"col6",           width:50, align:'center'},
                {name:"col7",           index:"col7",           width:50, align:'center'},
                {name:"col8",           index:"col8",           width:50, align:'center'},
                {name:"col9",           index:"col9",           width:50, align:'center'},
                {name:"col10",          index:"col10",          width:50, align:'center'},
            ];
        }
        
            
        $("#grd_Data").jqGrid("GridUnload");
                
        $("#grd_Data").jqGrid({
            datatype:    "local",
            data:        data,
            height:      300,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,            
        });
        
    }
</script>
</html>







