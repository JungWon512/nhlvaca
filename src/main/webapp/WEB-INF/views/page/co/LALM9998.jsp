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
            <span id="runningFlag">Stop</span><br/>
        </div>
        <div class="sec_table mb0">
        |grep <input id="grep" type="text" />
    |grep -v <input id="grepV" type="text" />
    
    <br/>
        <input id="startTail" type="button" value="startTail" />
        <input id="stopTail" type="button" value="stopTail" />
    <span id="runningFlag">Stop</span><br/>
            <div class="grayTable mb0">
                <form id="frm_Input" name="frm_Input">
                <table width="100%">
                    <colgroup>
                        <col width="100%">                 
                    </colgroup>
                    <tbody>
                        <tr> 
                            <td>
                                <textarea id="console" style="height:500px;"></textarea>
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
var endPoint = 0;
var tailFalg = false;
var consoleLog;
var grep;
var pattern;
var patternV;
var runningFlag;
var match;
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    $(document).ready(function() {
        consoleLog = $('#console');
        runningFlag = $('#runningFlag');
         
        function startTail() {
        	runningFlag.html('Running');
        	grep = $.trim($('#grep').val());
        	grepV = $.trim($('#grepV').val());
        	pattern = new RegExp('.*' +grep+ '.*\\n' , 'g');
        	patternV = new RegExp('.*' +grepV+ '.*\\n' , 'g');
        	 
        	function requestLog() {
        		if(tailFlag) {
        			
                    var data = new Object();
                    data['preEndPoint'] = endPoint;
                    
//         			var results = sendAjax(data, "/co/Common_selLogFile", "POST");
//         			var result;
        			 
//         			if(results.status != RETURN_SUCCESS){
//         				showErrorMessage(results);
//         				return;
//         			}else{
//         				result = setDecrypt(results);
//         			}
        			
        			
        			var results;
        			var result;
        			var encrypt = setEncrypt(data);
                    
                    $.ajax({
                           url: '/co/Common_selLogFile',
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
                    
        			
                    endPoint = result.endPoint == false ? 0 : result.endPoint;
                    var logdata = decodeURIComponent(result.log);
                    
                    if(grep != false) {
                        match = logdata.match(pattern);
                        logdata = match ? match.join('') : '';
                    }
                    if (grepV != false) {
                        logdata = logdata.replace(patternV, '');
                    }
                    consoleLog.val(consoleLog.val() + logdata);
                    consoleLog.scrollTop(consoleLog.prop('scrollHeight'));
                        
                    setTimeout(requestLog, 5000);
                }
           }
           requestLog();
        }
        $('#startTail').on('click',function() { tailFlag = true; startTail();});
        $('#stopTail').on('click',function(){
            tailFlag = false;
            runningFlag.html('Stop');
        });
    });
</script>
</html>







