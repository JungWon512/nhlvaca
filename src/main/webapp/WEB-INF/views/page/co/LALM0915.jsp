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
                <li><p class="dot_allow" >비밀번호 초기화</p></li>
            </ul>
        </div>
        <div class="sec_table mb0">
            <div class="blueTable rsp_v">
                <form id="frm_Search" name="frm_Search">
                <table width="100%">
                    <colgroup>
                        <col width="150">
                        <col width="*">
                        <col width="150">
                        <col width="*">                   
                    </colgroup>
                    <tbody>
                        <tr>
                             
                            <th scope="row">사용자ID</th>
                            <td>
                                <input type="text" id="usrid" maxlength="10"/>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row">성명</th>
                            <td>
                                <input type="text" id="usrnm" maxlength="20"/>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row">휴대전화번호</th>
                            <td>
                                <input type="text" id="mpno" class="telno" maxlength="13"/>
                            </td>
                            <td>'-' 없이 숫자만 입력</td>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row">인증번호</th>
                            <td>
                                <input type="text" id="usr_pw" autocomplete="off" maxlength="8"/>
                            </td>
                            <td><button class="tb_btn" id="pb_timer">인증번호요청</button></td>
                            <td></td>
                        </tr>
                        <tr>
                            <th scope="row">인증유효시간</th>
                            <td>
                                <div id="countTime"></div>
                            </td>
                            <td><button class="tb_btn" id="pb_access">인증번호확인</button></td>
                            <td></td>  
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="fl_L"><!--  //버튼 모두 우측정렬 -->
            <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">* 사용자ID, 성명, 휴대전화번호는 가입시 등록한 정보와 일치하여야 인증처리가 가능합니다.</label>
            <br>
            <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">* 인증 유효시간은 5분입니다.</label>
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
    	$('#pb_access').attr('disabled',true);
    	$('#usr_pw').attr('disabled',true);
        /******************************
         * 인증번호 요청
         ******************************/
        $("#pb_timer").bind('click',function(e){
            e.preventDefault();
            fn_selUsrChk();
        });
        
        /******************************
        * 인증번호 확인
        ******************************/
        $("#pb_access").bind('click',function(e){
            e.preventDefault();
            if(document.getElementById("countTime").innerHTML == "countdown's over")  {
            	MessagePopup('OK','유효시간이 만료되었습니다.');
            	return;
            }else {
            	fn_Access();
            }
        });
    });
    
    //사용자 체크
    function fn_selUsrChk(){
    	//사용자 여부 조회    	
        var result        = null;
        
        var sendData = new Object();       

        sendData["ctgrm_cd"]  = '3000';
        sendData["usrid"]     = $("#usrid").val();
        sendData["usrnm"]     = $("#usrnm").val();
        sendData["mpno"]      = $("#mpno").val().replace(/-/gi,"");
        
        var results = sendAjax(sendData, "/co/LALM0915_selUsr", "POST");
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{
    		 //result = setDecrypt(results);
    		 MessagePopup('OK','인증번호를 발송하였습니다. 유효시간내에 인증번호를 입력하십시오.',function(res){
    			 $("#pb_timer").attr('disabled', true);
                 $("#usrid").attr('disabled', true);
                 $("#usrnm").attr('disabled', true);
                 $("#mpno").attr('disabled', true);
                 $('#pb_access').attr('disabled',false);
                 $('#usr_pw').attr('disabled',false);
                     
                 //5분 카운트 시작
                 fn_CountDown();
    		 });
           
        }         
    }
    
    function fn_CountDown(){
    	
    	var element, endTime, hours, mins, msLeft, time;
    	
    	function twoDigits(n){
    		return (n <= 9 ? "0" + n : n);
    	}
    	
        function updateTimer(){
        	
        	msLeft = endTime - (+new Date);
        	if(msLeft < 1000){
        		element.innerHTML = "countdown's over";        		
        	}else{
        		time  = new Date(msLeft);
        		hours = time.getUTCHours();
        		mins  = time.getUTCMinutes();
        		element.innerHTML = (hours ? hours + ":" + twoDigits(mins) : mins) + ":" + twoDigits(time.getUTCSeconds());
        		setTimeout(updateTimer, time.getUTCMilliseconds());
        	}
        }    
        
        element = document.getElementById("countTime");
        endTime = (+new Date) + 1000 * (60 * 5 + 0) + 500;
        updateTimer();
    }
    
    function fn_Access(){
    	var sendData = new Object();
        sendData["usrid"]     = $("#usrid").val();
        sendData["usrnm"]     = $("#usrnm").val();
        sendData["mpno"]      = $("#mpno").val().replace(/-/gi,"");
        sendData["attc_no"]   = $("#usr_pw").val();
        
        var results = sendAjax(sendData, "/co/LALM0915_selPW", "POST");
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{ 
        	parent.MessagePopup("OK",'인증되었습니다. 비밀번호를 변경하시기 바랍니다.',function(res){
                var pgid = 'LALM0916';
                var menu_id = $("#menu_info").attr("menu_id");
                var data = new Object();
                data['usrid'] = $('#usrid').val();
                data['usr_pw'] = $("#usr_pw").val();
                data['old_pw_yn'] = 'N';
                  
                parent.loginLayerPopupPage(pgid, '비밀번호 변경', data, 500, 300,function(result){
                    if(result){
                        parent.PopupClose('#popupPage_LALM0915');
                    }
                });
            }); 
        }
    	
    }
    
    
</script>
</html>







