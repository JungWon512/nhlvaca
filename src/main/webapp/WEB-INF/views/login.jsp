<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<title>스마트가축시장</title>

<script type="text/javascript">
if(localStorage.getItem("nhlvaca_token") != null && localStorage.getItem("nhlvaca_token") != ""){
    document.location.href = '/index';
}
localStorage.setItem("nhlvaca_key", '${key}');
localStorage.setItem("nhlvaca_iv", '${iv}');
</script>

<%@ include file="/WEB-INF/common/serviceCall.jsp" %>

<%@ include file="/WEB-INF/common/head.jsp" %>

<script src="/js/rsa/jsbn.js"></script>
<script src="/js/rsa/prng4.js"></script>
<script src="/js/rsa/rng.js"></script>
<script src="/js/rsa/rsa.js"></script>



<script type="text/javascript">
    var login_pop_zIndex = 10003;
	$(document).ready(function(){
		
		var cookie_user_id = getCookie();
		
		if(cookie_user_id != ''){
			$("#user_id").val(cookie_user_id);
			$("#saveId").attr("checked", true);
		}
		document.body.style.backgroundColor= "#EEEEEE";
		
		$("#err_id").hide();
		$("#err_pw").hide();
		
		/******************************
        * 비밀번호 초기화
        ******************************/
        $("#resetPw").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_CallRoadnmPopup(function(result){
                if(result){
                     console.log(result);
                }
            });
        });
	});
	
	//로그인정보 저장
	function saveLogin(id){
		if(id != ''){
			setSave("userid", id, 7);
		}else{
			setSave("userid", id, -1);
		}
	}
	
	//쿠키저장
	function setSave(name, value, expiredays){
		var today = new Date();
		today.setDate(today.getDate() + expiredays);
		document.cookie = name + "=" + escape(value) + ";path=/; expires=" + today.toGMTString() + ";";
	}
	
	
	//쿠키값 가져오기
	function getCookie(){
		var cook = document.cookie + ";";
		var idx  = cook.indexOf("userid", 0);
		var val  = '';
		
		if(idx != -1){
			cook  = cook.substring(idx, cook.length);
			begin = cook.indexOf("=",0) + 1;
			end   = cook.indexOf(";", begin);
			val   = unescape(cook.substring(begin, end));
		}
		
		return val;
		
	}

    //인증토큰 요청
    function loginToken(frmStr, sendUrl, methodType, naBzplc){
    	
    	var rsa = new RSAKey();    	
    	rsa.setPublic($("#RSAModulus").val(), $("#RSAExponent").val());
    	var user_id = rsa.encrypt($("#user_id").val());
    	var user_pw = rsa.encrypt($("#user_pw").val());
    	var na_bzplc = "";
    	if(naBzplc) na_bzplc = rsa.encrypt(naBzplc);
        var result;          
        $.ajax({
            url: sendUrl,
            type: methodType,
            dataType:'json',
            header:{
                "Content-Type":"application/json"},
            async: false,
            data:{
                   user_id : user_id,
                   user_pw : user_pw,
                   na_bzplc : na_bzplc,
                   RSAKey  : $("#RSAKey").val(),
                   rsa_mod : $("#RSAModulus").val(),
                   rsa_exp : $("#RSAExponent").val()
            },
            success:function(data) {
            	result = data;
            	
            },
            error:function(request){
            	var errMsg = JSON.parse(request.responseText);
            	MessagePopup("OK",errMsg.message);
            }
        });
        
        if($("#saveId").is(":checked")){
        	saveLogin($("#user_id").val());
        }else{
        	saveLogin("");
        }
        
        return result;
    }
    
    //RsaKey 요청
    function getRsaKey(){
        
    	$.ajax({
            url: '/co/getRSAKey',
            type: 'POST',
            dataType:'json',
            header:{
                "Content-Type":"application/json"},
            async: false,
            success:function(data) {
                result = data;                
            },
            error:function(request){
            	
                console.log(request);
            }
        });
    	    	
    	$("#RSAKey").val(result.RSAKey);
    	$("#RSAModulus").val(result.RSAModulus);
    	$("#RSAExponent").val(result.RSAExponent);
    	
    	return result;
    }

    //인증토큰 요청
    function preLoginProc(sendUrl, methodType){
    	
    	var user_id = $("#user_id").val();
    	var user_pw = $("#user_pw").val();
    	
        var result;          
        $.ajax({
            url: sendUrl,
            type: methodType,
            dataType:'json',
            header:{
                "Content-Type":"application/json"},
            async: false,
            data:{
                   user_id : user_id,
                   user_pw : user_pw
            },
            success:function(data) {
            	result = data;
            	
            },
            error:function(request){
            	var errMsg = JSON.parse(request.responseText);
            	MessagePopup("OK",errMsg.message);
            }
        });
        
        return result;
    }
    
    //로그인 요청
    function getLogin(sendFrm){    	
    	
        if($("#user_id").val() == ''){
        	MessagePopup("OK",'ID를 입력하여 주십시오.');
            $("#err_id").show();
            return;
        }
        if($("#user_pw").val() == ''){
        	MessagePopup("OK",'패스워드를 입력하여 주십시오.');
            $("#err_pw").show();
            return;
        }        
        
        preResults = preLoginProc("/preLoginProc", "POST");       
        if(preResults != null){
            var preResult = setDecrypt(preResults);
            console.log(preResult);
            if(preResult && preResult.length > 1){
	    		var comboList = new Array();
	    		preResult.forEach(obj => {
	    			var tmp = new Object();
	    			tmp.NA_BZPLC  = obj.NA_BZPLC;
	    			tmp.NA_BZPLNM = obj.NA_BZPLNM;
	    			comboList.push(tmp);
	    		});
	    	    var chg_na_bzplc = '<select id="chg_na_bzplc_select" onchange="$(\'#sel_na_bzplc\').val(this.value);">';
	
	    	    $.each(comboList, function(i){
	    	        var v_simp_nm = ('['+comboList[i].NA_BZPLC + '] ' + comboList[i].NA_BZPLNM);
	    	        chg_na_bzplc = chg_na_bzplc + '<option value="' + comboList[i].NA_BZPLC + (comboList[i].NA_BZPLC == App_na_bzplc? '" selected':'"') + '>' + v_simp_nm + '</option>';
	    	    });
	    	    chg_na_bzplc = chg_na_bzplc + '</select>';
	            chg_na_bzplc = chg_na_bzplc + '<br>';
	            chg_na_bzplc = chg_na_bzplc + '<div class="fl_C">';
	            chg_na_bzplc = chg_na_bzplc + '<input type="button" class="tb_btn" id="btn_log"   value="로그보기">';
	            chg_na_bzplc = chg_na_bzplc + '<input type="button" class="tb_btn" id="btn_query" value="쿼리분석">';
	            chg_na_bzplc = chg_na_bzplc + '<div>';
	    		MessagePopup('YESNO',chg_na_bzplc,function(res){
	    			if(res){
				        fnLogin(sendFrm,$('#sel_na_bzplc').val());        
	    			}
	    		});
            	$('#sel_na_bzplc').val(preResult[0].NA_BZPLC);
            	return;
            }else if(!preResult || preResult.length < 1){
            	return;
            }
        }
        
        fnLogin(sendFrm);        
    }
  function fnLogin(sendFrm,na_bzplc){

        //인증토큰 요청
        results = getRsaKey();
                
        results = loginToken(sendFrm, "/signIn", "POST",na_bzplc);       
        if(results != null){  
        	if(results.token       == null || results.token  == '' || 
                    results.key    == null || results.key    == '' ||
                    results.iv     == null || results.iv     == '' ||
                    results.userId == null || results.userId == '' 
        	){
        		MessagePopup("OK",'로그인정보를 찾을수 없습니다.<br>시스템담당자에게 문의하세요.');
        	}else if(results.na_bzplc == null || results.na_bzplc == ''){
                MessagePopup("OK",'사업장정보를 찾을수 없습니다.<br>시스템담당자에게 문의하세요.');
        	}else if(results.grp_c == null || results.grp_c == ''){
                MessagePopup("OK",'권한정보를 찾을수 없습니다.<br>시스템담당자에게 문의하세요.');
            }else if(results.strg_dt != null && fn_SpanDay(results.strg_dt, fn_getToday('YYYYMMDD'), 'Month') > 3){
            	MessagePopup("OK",'비밀번호 변경시점에서 3개월 이상 경과하였습니다.<br>비밀번호를 변경하여 주십시오.',function(res){
            		var pgid = 'LALM0916';
                    var data = new Object();
                    data['usrid'] = $('#user_id').val();
                    data['old_pw_yn'] = 'Y';
                    data['nhlvaca_token'] = results.token;
                      
                    parent.loginLayerPopupPage(pgid, '비밀번호 변경', data, 500, 300,function(result){
                        if(result){
                        	localStorage.setItem("nhlvaca_token", results.token);
	                        localStorage.setItem("nhlvaca_key", results.key);
	                        localStorage.setItem("nhlvaca_iv", results.iv);
	                        localStorage.setItem("nhlvaca_userId", results.userId);
	                        localStorage.setItem("nhlvaca_eno", results.eno);
	                        localStorage.setItem("nhlvaca_na_bzplc", results.na_bzplc);
	                        localStorage.setItem("nhlvaca_security", results.security);
	                        localStorage.setItem("nhlvaca_na_bzplnm", results.na_bzplnm);
	                        localStorage.setItem("nhlvaca_usrnm", results.usrnm);
	                        localStorage.setItem("nhlvaca_grp_c", results.grp_c);
	                        localStorage.setItem("nhlvaca_strg_dt", results.strg_dt);
                        	window.location.href = "/index";
                        }
                    });
            	});
            }else {
            	localStorage.setItem("nhlvaca_token", results.token);
                localStorage.setItem("nhlvaca_key", results.key);
                localStorage.setItem("nhlvaca_iv", results.iv);
                localStorage.setItem("nhlvaca_userId", results.userId);
                localStorage.setItem("nhlvaca_eno", results.eno);
                localStorage.setItem("nhlvaca_na_bzplc", results.na_bzplc);
                localStorage.setItem("nhlvaca_security", results.security);
                localStorage.setItem("nhlvaca_na_bzplnm", results.na_bzplnm);
                localStorage.setItem("nhlvaca_usrnm", results.usrnm);
                localStorage.setItem("nhlvaca_grp_c", results.grp_c);
                localStorage.setItem("nhlvaca_strg_dt", results.strg_dt);
            	window.location.href = "/index";
            }
       	    
        }
  }
  
  //모달레이어팝업
  function MessagePopup(type,msg,callback){
	  var title = '';
	    if(type == 'OK')title = '알림'
	    else if(type == 'WANNING')title = '경고'
	    else if(type == 'ERROR')title = 'ERROR'
	    else if(type == 'YESNO')title = '선택';
	    
	    var target = '#layer-popup';
	    var $winW = $(window).width();
	    var $winH = $(window).height();
	    var $layerContent = $(target).find($('.layer-content'));
	    $layerContent.find($('.layer-title')).text(title);
	    $layerContent.find($('.layer-cont')).html(msg);
	    $(target).css({'overflow': 'auto'}).show().addClass('open');
	    var $layerContentH = $(target).find($('.layer-content')).height() + 40;
	    var $conPos = ($winH / 2) - ($layerContentH / 2);
	    
	    if( $winH > $layerContentH ){
	        $layerContent.css({marginTop: $conPos});
	    } else {
	        $layerContent.css({marginTop: 0});
	    }
	    var $LayerBtn = $layerContent.find($('.layer-btn'));    
	    
	    if(type == 'OK' ||  type == 'WANNING' || type == 'ERROR'){
	        $LayerBtn.find($('#popBtnOk')).show();
	        $LayerBtn.find($('#popBtnYes')).hide();
	        $LayerBtn.find($('#popBtnNo')).hide();
	        
	        $LayerBtn.find($('#popBtnOk')).on('click',function(e){
	            $layerContent.find($('.layer-title')).text('');
	            $layerContent.find($('.layer-cont')).text('');
	            $layerContent.find($('#popBtnClose')).off('click');
	            $LayerBtn.find($('#popBtnOk')).off('click');   
	            layerPopupClose(target);
	            if(typeof callback == 'function'){
	                callback(true);
	            }
	        });
	        $LayerBtn.find($('#popBtnOk')).focus();
	    }else if(type == 'YESNO'){
	        $LayerBtn.find($('#popBtnOk')).hide();
	        $LayerBtn.find($('#popBtnYes')).show();
	        $LayerBtn.find($('#popBtnNo')).show();
	        
	        $LayerBtn.find($('#popBtnYes')).on('click',function(e){
	            $layerContent.find($('.layer-title')).text('');
	            $layerContent.find($('.layer-cont')).text('');
	            $LayerBtn.find($('#popBtnYes')).off('click');    
	            $LayerBtn.find($('#popBtnNo')).off('click');
	            layerPopupClose(target);
	            if(typeof callback == 'function'){
	                callback(true);
	            }
	        });
	        
	        $LayerBtn.find($('#popBtnNo')).on('click',function(e){
	            $layerContent.find($('.layer-title')).text('');
	            $layerContent.find($('.layer-cont')).text('');
	            $LayerBtn.find($('#popBtnYes')).off('click');    
	            $LayerBtn.find($('#popBtnNo')).off('click');
	            layerPopupClose(target);
	            if(typeof callback == 'function'){
	                callback(false);
	            }
	        });

	        $LayerBtn.find($('#popBtnYes')).focus();
	    }   
	    $("<div id='overlay' class='overlay'></div>").appendTo('.login_wrap');    
  } 
  //touch
  function lock_touch(e){
      e.preventDefault();
  }
  //모달레이어팝업닫기
  function layerPopupClose(target){
      if (document.removeEventListener) {
          document.removeEventListener('touchmove', lock_touch);
      }else {
          document.detachEvent('touchmove', lock_touch);
      }
      $(target).hide().removeClass('open');
      $("#overlay").remove();
  };
  
  
//***************************************
//* function   : 비밀번호 초기화 팝업
//* paramater  : 
//* result     : 
//***************************************
function fn_CallRoadnmPopup(callback){
    var pgid = 'LALM0915';
    loginLayerPopupPage(pgid, '비밀번호초기화', null, 800, 430,function(result){
        callback(result);
    });
}
  
//모달레이어팝업Page
function loginLayerPopupPage(pgid,pgmnm,param,width,height,callback){
    
    var popup_info = new Object;
    popup_info['PGID'] = pgid;
    popup_info['PGMNM'] = pgmnm;
    var popupPage = '<div id="popupPage_'+pgid+'" class="popup-wrap" style="z-index:'+login_pop_zIndex+';" tabindex="0">'
                  + ' <div class="popup-content">'
                  + '  <div class="pop_head"><p>['+pgid+']'+pgmnm+'</p></div>'
                  + '  <div class="pop_body">'
                  + '      <iframe id="pop_' + pgid + '" name="pop_' + pgid + '" style="width:100%;height:100%;" frameborder=0 border=0 hspace=0 vspace=0></iframe><input type="hidden" id="pop_result_' + pgid + '" value="false">'
                  + '  </div>'
                  + '  <button id="popBtnClose" class="popup_close" onclick="javascript:PopupClose(\'#popupPage_'+pgid+'\');return false;"><span class="fa fa-remove"></span></button>'
                  + ' </div>'
                  + '</div>';
    $("<div id='popupPage_"+pgid+"_overlay' class='pop_overlay' style='z-index:"+login_pop_zIndex+"'></div>").appendTo('body');
    $(popupPage).appendTo('body'); 
    
    var target = "#popupPage_"+pgid;
    var $winW = $(window).width();
    var $winH = $(window).height();
    var $layerContent = $(target).find($('.popup-content'));
    
    $layerContent.css({'max-width': width +'px','height': height +'px'});
    $layerContent.find($('.pop_body')).css({'height':(height - 40)+'px'});
    
    //iframe 데이터 전달
    fn_sendIFrameDataPopup(popup_info,param);
    
    $(target).show().addClass('open');
    var $layerContentH = $layerContent.height();
    var $conPos = ($winH / 2) - ($layerContentH / 2);
    
    if( $winH > $layerContentH ){
        $layerContent.css({marginTop: $conPos});
    } else {
        $layerContent.css({marginTop: 0});
    }    
    
    login_pop_zIndex++;
    //리턴받을경우
    $('iframe#pop_'+pgid).load(function(){
        var result = $('iframe#pop_'+pgid).get(0).contentWindow.pageInfo;
        //var frmIds =$('iframe#pop_'+pgid).contents().find('#result_data');
        var resultInput = $("#pop_result_" + pgid );
        
        resultInput.bind('change', function(){
            if(resultInput.val()){
                PopupClose(target);
                callback(result.returnValue);
            };
        }); 
    }); 
}

//모달레이어팝업닫기
function PopupClose(target){
    if (document.removeEventListener) {
        document.removeEventListener('touchmove', lock_touch);
    }else {
        document.detachEvent('touchmove', lock_touch);
    }
    $(target).remove();
    $(target+"_overlay").remove();
    login_pop_zIndex--;
};

//popupData 전송
function fn_sendIFrameDataPopup(popup_info,param){
    //create form
    var iform  = document.createElement("form");
    iform.method  = "POST";
    iform.id   = "iframeParam";
    iform.name = "iframeParam";
    iform.target = "pop_"+popup_info.PGID;
    iform.action = "/page/co/"+ popup_info.PGID;    
    var inputData = document.createElement("input");
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("id"  , "data");
    inputData.setAttribute("name", "data");    
    iform.appendChild(inputData);    
    document.body.appendChild(iform);    
    //data 생성
    var data = new Object();  
    data['pgid']  = popup_info.PGID;
    data['pgmnm']  = popup_info.PGMNM;
    data['param']    = param;
    data['popup_info'] = popup_info;          
    // String 형태로 변환
    iform.data.value = setEncrypt(data);    
    iform.submit();    
    $("#iframeParam").remove();
}   

//새로고침 및 페이지 이동 방지 취소
function offBeforeunload(){ 
}
</script>
</head>
<body>
	<!-- login -->
	<div class="login_wrap">	
		<input type="hidden" id="sel_na_bzplc" value=""/>
		<div class="login_box">
			<div class="inner">
				<form id="frm_login">
				    <div class="ttl">
		                <h1 style="font-size: 36px;">로그인</h1>
		                <h2>스마트가축시장</h2>
		            </div>
		            <!-- <select id="na_bzplc"></select> -->
		            <input type="text" placeholder="아이디" id="user_id" onkeypress="javascript:if(event.keyCode==13){getLogin('frm_login');return false;}"/>
		            <p class="err_txt" id="err_id">* 아이디를 입력해주세요.</p>
		            <input type="password" placeholder="비밀번호" id="user_pw" onkeypress="javascript:if(event.keyCode==13){getLogin('frm_login');return false;}"/>
		            <p class="err_txt" id="err_pw">* 비밀번호를 입력해주세요.</p>
		            <span class="inp_saveID"><input type="checkbox" id="saveId" class="chkInput"><label for="saveId">아이디저장</label></span>
		            <button type="button" class="btn btn_login"  onClick="getLogin('frm_login');return false;">로그인</button>
                    <button type="button" class="btn btn_login"  id="resetPw" >패스워드 초기화</button>
                    <input type="hidden" id="RSAKey"      value="${RSAKey }"/>
                    <input type="hidden" id="RSAModulus"  value="${RSAModulus }"/>
                    <input type="hidden" id="RSAExponent" value="${RSAExponent }"/>
					
				</form>
			</div>
		</div>
	</div>
	<!-- wrapper -->
	<!-- 레이어팝업 v1 -->
	<div id="layer-popup" class="layer-wrap" tabindex="0">
	    <div class="layer-content">
	        <div class="layer-title"></div>
	        <div class="layer-cont"></div>
	        <div class="layer-btn ta_c">
	            <button id="popBtnOk" class="btn">확인</button>
	            <button id="popBtnYes" class="btn">예</button>
	            <button id="popBtnNo"  class="btn">아니오</button>
	        </div>
	    </div>
	    <!-- //layer-content e -->
	</div>
<script src="/js/default.js"></script>
</body>
<style>
    input::placeholder{font-size: 18px;}
</style>
</html>