<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link rel="stylesheet" href="/css/font-awesome.min.css">
<link rel="stylesheet" href="/css/jquery/jquery-ui.css">
<link rel="stylesheet" href="/css/jquery/ui.jqgrid.css">
<link rel="stylesheet" href="/css/jqTree/jqtree.css">
<link rel="stylesheet" href="/css/slick.css">
<link rel="stylesheet" href="/css/common.css">
<link rel="stylesheet" href="/css/content.css">
<link rel="stylesheet" href="/css/content-media.css">

<link rel="shortcut icon" href="/images/common/favicon_new.ico">
<link rel="apple-touch-icon" sizes="64x64" href="/images/common/favicon_new64.png">
<link rel="icon" type="image/png" sizes="16x16" href="/images/common/favicon_new.ico">
<link rel="icon" type="image/png" sizes="32x32" href="/images/common/favicon_new64.png">  <!-- 32x32 적용필요-->
<link rel="icon" type="image/png" sizes="128x128" href="/images/common/favicon_new128.png">

<style>
.ui-jqgrid.ui-widget.ui-widget-content.ui-corner-all{width:100% !important;}
.ui-jqgrid-view{width:100% !important;}
.ui-jqgrid-hdiv{width:100% !important;}
.ui-jqgrid .ui-jqgrid-hbox{width:100% !important; padding-right:17px !important;}
.ui-jqgrid-htable{width:100% !important;}
.ui-jqgrid-bdiv{width:100% !important;}
.ui-jqgrid-btable{width:100% !important;}
.ui-jqgrid-sdiv{width:100% !important;}
.ui-jqgrid-ftable{width:100% !important;}
.ui-jqgrid-pager{width:100% !important;}
.ui-jqgrid .ui-jqgrid-bdiv{overflow-y:scroll !important;}
.ui-jqgrid .ui-jqgrid-htable th div{
  height:auto;
  overflow:hidden;
  padding-right:2px;
  padding-left:2px;
  padding-top:4px;
  padding-bottom:4px;
  position:relative;
  vertical-align:text-top;
  white-space:normal !important;
}
</style>

<script src="/js/jquery/jquery-1.11.2.min.js"></script>
<script src="/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<script src="/js/jquery/jquery.easing.1.3.min.js"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/slick.min.js"></script>
<script src="/js/jquery.placeholder.ls.js"></script>

<script src="/js/jquery/json2.js"></script>
<script src="/js/rollups/aes.js"></script>
<script src="/js/rollups/sha256.js"></script>


<script src="/js/jqGrid/grid.locale-en.js"></script>
<script src="/js/jqGrid/grid_common.js"></script>
<script src="/js/jqGrid/jqGrid.min.js"></script>

<script src="/js/date/dayjs.min.js"></script>

<script type="text/javascript">
    //OS사용에 따른 레이어 체크
    var isMobile = (navigator.platform)?("win16|win32|win64|mac|macintel".indexOf(navigator.platform.toLowerCase()) < 0):false;

    //상태코드
    var RETURN_SUCCESS = 200;
    var NO_DATA_FOUND  = 201;
    var TMS_FAILED     = 202;
    var TOKEN_ERROR    = 204;
    var SERVICE_ERROR  = 205;
    //그리드 코드
    var GRID_YN_DATA = "1:여;0:부";
    var GRID_MACO_YN_DATA ="1:조합원;0:비조합원";
    var GRID_TMS_YN_DATA ="1:전송;0:미전송";
    var GRID_AM_DATA ="1:원;10:십원;100:백원;1000:천원;10000:만원";
    var GRID_DNA_YN_DATA ="0:;1:일치;2:불일치;3:미확인;4:부불일치;5:모불일치;6:부or모불일치";
    var GRID_SEL_DSC_DATA ="11:대기;21:진행;22:종료;23:중지";
    var GRID_DDL_QCN_DATA ="0:0차;1:1차;2:2차;3:3차;4:4차;5:5차;6:6차;7:7차;8:8차;9:9차";
    
    //그리드 컬러
    var GRID_NOR_BACKGROUND_COLOR = {'background-color':''};
    var GRID_MOD_BACKGROUND_COLOR = {'background-color':'blue'};

    //암호화키
    var keyutf = CryptoJS.enc.Utf8.parse(localStorage.getItem("nhlvaca_key"));
    var ivutf  = CryptoJS.enc.Utf8.parse(localStorage.getItem("nhlvaca_iv"));
    
    // 공통 변수
    var App_na_bzplc  = localStorage.getItem("nhlvaca_na_bzplc"); 
    var App_na_bzplnm = localStorage.getItem("nhlvaca_na_bzplnm");   
    var App_userId    = localStorage.getItem("nhlvaca_userId"); 
    var App_userNm    = localStorage.getItem("nhlvaca_usrnm");
    var App_eno       = localStorage.getItem("nhlvaca_eno");
    var App_grp_c     = localStorage.getItem("nhlvaca_grp_c");
    function showLodingImg(){
    	parent.$('#loading-prograss').show();
    }
    function hideLodingImg(){
        parent.$('#loading-prograss').fadeOut();
    }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 데이터 전송
     * 2. 입 력 변 수 : objData
                    , sendUrl
                    , methodType
     * 3. 출 력 변 수 : result
     ------------------------------------------------------------------------------*/
    function sendAjax(objData, sendUrl, methodType){   
    	console.log(sendUrl, objData);
        var encrypt = setEncrypt(objData);                    
        var result;
        $.ajax({
            url: sendUrl,
            type: methodType,
            dataType:'json',
            async: false,
            headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
            data:{
                   data : encrypt.toString()
            },
            beforeSend:function(){
            	setTimeout(showLodingImg,0);
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
            },
            complete:function(data){
            	localStorage.setItem("nhlvaca_token", (getCookie('token')||localStorage.getItem('nhlvaca_token')));
              setTimeout(hideLodingImg,0);
            }
        });         
        return result;
    }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 폼데이터 전송
     * 2. 입 력 변 수 : frmStr
                    , sendUrl
                    , methodType
     * 3. 출 력 변 수 : result
     ------------------------------------------------------------------------------*/
    function sendAjaxFrm(frmStr, sendUrl, methodType){
        console.log(sendUrl, setFrmToData(frmStr));
        var encrypt = setEncrypt(setFrmToData(frmStr));
        var result;
        
        $.ajax({
            url: sendUrl,
            type: methodType,
            dataType:'json',
            async: false,
            headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
            data:{
                   data : encrypt.toString()
            },
            beforeSend:function(){
                setTimeout(showLodingImg,0);
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
            },
            complete:function(data){
            	localStorage.setItem("nhlvaca_token", (getCookie('token')||localStorage.getItem('nhlvaca_token')));
            	setTimeout(hideLodingImg,0);
            }
        });        
        return result;
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 폼데이터 => obj
     * 2. 입 력 변 수 : frmStr ex) 'frmStr'
     * 3. 출 력 변 수 : data
     ------------------------------------------------------------------------------*/
    function setFrmToData(frmStr){         
        var frmIds = $("#" + frmStr).find('input[type=hidden], input[type=text], input[type=password], textarea, select, input[type=checkbox]');    
        var data = new Object();             
        var id = "";        
        var tagName = "";
        var tagType = "";
        var className = "";
                    
        for(var i=0; i<frmIds.length; i++){ 
            tagName = $(frmIds[i]).prop('tagName');             
            id = $(frmIds[i]).attr('id');
            className = $(frmIds[i]).attr('class');
            if(tagName == 'INPUT'){             
                tagType = $(frmIds[i]).attr('type');                
                if(tagType == 'text' || tagType == 'password' || tagType == 'hidden'){
                	if(String(className) != 'undefined' && className.indexOf('date') > -1){
                		data[id] = $(frmIds[i]).val().replace(/[^0-9]/g,"");
                	}else if(String(className) != 'undefined' && className.indexOf('minusnumber') > -1){
                		data[id] = $(frmIds[i]).val().replace(/[^-?0-9.]/g,'').replace(/(\..*)\./g,'$1');
                	}else if(String(className) != 'undefined' && className.indexOf('integer') > -1){
                		data[id] = $(frmIds[i]).val().replace(/[^0-9]/g,'').replace(/(\..*)\./g,'$1');
                	}else if(String(className) != 'undefined' && className.indexOf('number') > -1){
                		data[id] = $(frmIds[i]).val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
                	}else {
                		data[id] = $(frmIds[i]).val();
                	}                                    
                }else if(tagType == 'checkbox'){                            
                    data[id] =  $(frmIds[i]).is(":checked") ? '1' : '0';                    
                }                
            }else if(tagName == 'TEXTAREA'){
                data[id] = $(frmIds[i]).val();                
            }else if(tagName == 'SELECT'){
                data[id] = $(frmIds[i]).val();
            }
        }
        
        return data;
    }
    

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 에러메시지 출력
     * 2. 입 력 변 수 : result
                    , errorPass ex)'NOTFOUND' 조회된자료없을시 메시지 표시하지 않음
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function showErrorMessage(result,errorPass,errPassMsg,callback){
    	 
        if(result.code.indexOf('T')>-1){
        	MessagePopup("OK",result.message, function(){
            <c:choose>
            <c:when test="${requestScope['javax.servlet.forward.request_uri'] == '/index'}">
              offBeforeunload();
              localStorage.removeItem("nhlvaca_token");
              document.location.href = '/';
            </c:when>
            <c:when test="${requestScope['javax.servlet.forward.request_uri'] == '/login'}">
            </c:when>
            <c:otherwise>
              parent.offBeforeunload();
              localStorage.removeItem("nhlvaca_token");
              parent.location.href = '/';
            </c:otherwise>
            </c:choose>
            });
        }else if(result.code.indexOf('C')>-1){
        	if(result.status == NO_DATA_FOUND && errorPass == "NOTFOUND"){
        		if(String(errPassMsg) != 'undefined'){
        			MessagePopup("OK",errPassMsg,function(res){
        				if(typeof callback == 'function'){
                            callback(true);
                        }
        			});
        			
        		}
        		return;
        	}
        	else {
        		MessagePopup("OK",result.message,function(res){
        			if(typeof callback == 'function'){
                        callback(true);
                    }
        		});
        		
        	}        	
        }
        
    }
    
    //데이터 encript
    function setEncrypt(data){
        // console.log(data);
        // String 형태로 변환
        var jsonData = JSON.stringify(data);
        var encrypt = CryptoJS.AES.encrypt(jsonData.toString(), keyutf, {iv:ivutf});          
        return encrypt; 
    }
    //데이터 decript
    function setDecrypt(encriptData){
    	var bytes  = CryptoJS.AES.decrypt(encriptData.data.toString(), keyutf, {iv: ivutf});
        var plaintext = bytes.toString(CryptoJS.enc.Utf8);              
        var result = JSON.parse(plaintext); 
    	return result;
    }    
    function setDecryptData(reData){
        var bytes  = CryptoJS.AES.decrypt(reData, keyutf, {iv: ivutf});
        var plaintext = bytes.toString(CryptoJS.enc.Utf8);              
        result = JSON.parse(plaintext);
                
        return result;
        
    } 


    var getCookie = function(name){
    	var cookies = document.cookie.split(';');
    	for(var i = 0;i<cookies.length;i++){
    		if(cookies[i].split('=')[0].trim() == name){
    			var result = cookies[i].split('=')[1]?.trim();
    			return result?result:'';
    		}
    	}
    };
</script>