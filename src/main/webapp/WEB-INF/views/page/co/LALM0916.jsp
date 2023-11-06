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
                <li><p class="dot_allow" >비밀번호 변경</p></li>
            </ul>
            <div class="tab_box fl_R"><!--  //버튼 모두 우측정렬 -->
	            <label style="font-size:15px;color: blue;font: message-box;">* 영문,숫자의 조합으로 10자리 이상</label>
	        </div>
        </div>
        <div class="sec_table">
            <div class="blueTable rsp_v">
                <form id="frm_ChgPw" name="frm_ChgPw">
                <input type="hidden" id="usrid"/>
                <input type="hidden" id="usr_pw"/>
                <table width="100%">
                    <colgroup>
                        <col width="150">
                        <col width="*">                
                    </colgroup>
                    <tbody>
                        <tr> 
                            <th scope="row">현재비밀번호</th>
                            <td>
                                <input type="password" id="io_old_pw"/>
                            </td>
                        </tr>
                        <tr>                             
                            <th scope="row">새비밀번호</th>
                            <td>
                                <input type="password" id="io_new_pw"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">새비밀번호 확인</th>
                            <td>
                                <input type="password" id="cnf_pw"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
            
        </div>
        <div class="tab_box fl_C"><!--  //버튼 모두 우측정렬 -->
            <button class="button saveBtn" id="btn_Save"><span>저장</span></button>
            <button class="button closeBtn" id="btn_Close"><span>닫기</span></button>
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
     var pageInfo = setDecryptData('${pageInfo}');
     $(document).ready(function() {
    	 jQuery("link[rel=stylesheet][href*='/css/content-media.css']").remove();
         //메뉴 아이디
         var menu_id  = pageInfo.menu_id;
         var pgid     = pageInfo.pgid;
         var pgmnm    = pageInfo.pgmnm;
         
         $( "#usrid" ).val(pageInfo.param.usrid);
         if(pageInfo.param.old_pw_yn == 'N'){
        	 $( "#io_old_pw" ).attr('disabled','disabled');
        	 $( "#usr_pw" ).val(pageInfo.param.usr_pw);
         }
         
         $("#btn_Save").click(function(event){
             event.preventDefault();
             this.blur();
             fn_Save();                   
         });
         
         $("#btn_Close").click(function(event){
             event.preventDefault();
             this.blur();
             parent.PopupClose("#popupPage_"+pgid);
             return false;                  
         });
         
    });
     
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      
         //폼 초기화
         fn_InitFrm('frm_ChgPw');
         
         if(pageInfo.param.old_pw_yn == 'Y'){
        	 $('#io_old_pw').focus();
         }else {
        	 $('#io_new_pw').focus();
         }    
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	var pw = $('#io_new_pw').val();
    	var num = pw.search(/[0-9]/g);
    	var eng = pw.search(/[a-z]/ig);
    	//var spe = pw.search(/['-!@@#$%^&*|\\\'\";:\/?]/gi);
    	 
    	if(!$( "#io_old_pw" ).attr('disabled') && !$( "#io_old_pw" ).val()){    	
    		MessagePopup('OK','기존 비밀번호를 입력하세요.',function(){
                $( "#io_old_pw" ).focus();
            });
            return;
    	}
    	 
    	if(pw.length < 10 || pw.length > 20){
    		MessagePopup('OK','비밀번호는 10자리 이상 20자리 이내로 입력하세요.',function(){
                $( "#io_new_pw" ).focus();
            });
            return;
    	}else if(pw.search(/\s/) != -1){
    		MessagePopup('OK','비밀번호는 공백 없이 입력해주세요.',function(){
                $( "#io_new_pw" ).focus();
            });
            return;
    	}else if(num < 0 || eng < 0 ){//} || spe < 0){, 특수문자
    		MessagePopup('OK','비밀번호는 영문,숫자를 혼합하여 입력해주세요.',function(){
                $( "#io_new_pw" ).focus();
            });
            return;
    	}
    	if(pw != $('#cnf_pw').val()){
            MessagePopup('OK','새 비밀번호가 비밀번호 확인란과 불일치 합니다.',function(){
                $( "#io_new_pw" ).focus();
            });
            return;
        }
        
    	if(pw == $('#io_old_pw').val()){
            MessagePopup('OK','새 비밀번호가 현재 비밀번호와 일치 합니다.',function(){
                $( "#io_new_pw" ).focus();
            });
            return;
        }
    	
    	if(pageInfo.param.old_pw_yn == 'Y' && App_grp_c != '001'){
    		if(fn_isNull($('#io_old_pw').val()) == true){
                MessagePopup('OK','현재 비밀번호를 입력하세요.',function(){
                    $( "#io_old_pw" ).focus();
                });
                return;
            }
    		
    		var result        = null;
                                
            var results = null;
            
            if(pageInfo.param.nhlvaca_token != undefined && pageInfo.param.nhlvaca_token != null && pageInfo.param.nhlvaca_token != ""){
                results = sendAjaxFrmWithToken("frm_ChgPw", "/LALM0916_selPw", "POST", pageInfo.param.nhlvaca_token);
            }else {
            	results = sendAjaxFrm("frm_ChgPw", "/LALM0916_selPw", "POST");
            }
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results);
                return;
            }else{      
                result = setDecrypt(results);                
                if(result.PASSWORD == 1){
                	MessagePopup('OK','기존 비밀번호가 일치하지 않습니다.',function(){
                        $( "#io_old_pw" ).focus();
                    });
                    return;
                }
                
                if(result.PASSWORD == 2){
                    MessagePopup('OK','기존 비밀번호와 새 비밀번호가 동일합니다.',function(){
                        $( "#io_new_pw" ).focus();
                    });
                    return;
                }
            } 
    	
    	}
    	
    	
         MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
             if(res){
                 
            	 var result        = null;
            	 if(pageInfo.param.old_pw_yn == 'Y'){
            		 if(pageInfo.param.nhlvaca_token != undefined && pageInfo.param.nhlvaca_token != null && pageInfo.param.nhlvaca_token != ""){
            			 console.log(pageInfo.param.nhlvaca_token);
            			 result = sendAjaxFrmWithToken("frm_ChgPw", "/LALM0916_updPw", "POST", pageInfo.param.nhlvaca_token);
            		 }else {
            			 result = sendAjaxFrm("frm_ChgPw", "/LALM0916_updPw", "POST");
            		 }
	                 
	                 if(result.status == RETURN_SUCCESS){
	                     MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
	                    	 pageInfo.returnValue = true;
	                    	 var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
	                         parentInput.val(true).trigger('change');
	                     });
	                 }else {
                         showErrorMessage(result);
                         return;
                     } 
            	 }else {
            		 var encrypt = setEncrypt(setFrmToData('frm_ChgPw'));
            		 
            		 $.ajax({
            	            url: '/co/updatePassword',
            	            type: "POST",
            	            dataType:'json',
            	            header:{
                                "Content-Type":"application/json"},
                            async: false,
            	            data:{
            	                   data : encrypt.toString()
            	            },
            	            success:function(data) {                                    
            	                result = data;  
            	                if(result.status == RETURN_SUCCESS){
                                    MessagePopup("OK", "정상적으로 처리되었습니다.",function(res){
                                        pageInfo.returnValue = true;
                                        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
                                        parentInput.val(true).trigger('change');
                                    });
                                }else {
                                    showErrorMessage(result);
                                    return;
                                } 
            	            },
            	            error:function(response){
            	            	showErrorMessage(result);
                                return;
            	            }
            	     }); 
            	        
            	 }
                 
                    
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });      
    }     
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    function sendAjaxFrmWithToken(frmStr, sendUrl, methodType, token){
        var encrypt = setEncrypt(setFrmToData(frmStr));
        var result;
        
        $.ajax({
            url: sendUrl,
            type: methodType,
            dataType:'json',
            async: false,
            headers : {"Authorization": 'Bearer ' + token},
            data:{
                   data : encrypt.toString()
            },
            success:function(data) {
                result = data;                                    
            },
            error:function(response){
                if(response.status == 404){
                    result = "";
                }else {
                    result = JSON.parse(response.responseText); 
                }            
            },complete:function(data){
            	localStorage.setItem("nhlvaca_token", (getCookie('token')||localStorage.getItem('nhlvaca_token')));
			}
        });        
        return result;
    }
</script>
</html>







