<%@ page language="java" import="java.net.InetAddress" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

<title>스마트가축시장</title>

<%@ include file="/WEB-INF/common/serviceCall.jsp" %>

<script type="text/javascript">

if(localStorage.getItem("nhlvaca_token") == null || localStorage.getItem("nhlvaca_token") == ""){
    document.location.href = '/';
}
var baseInfo;
var menuList;
var popupList
var btnList;
var authList;
var comboList;
var wmcList;
var envList;
var pop_zIndex = 10003;
var inputRn;
$(document).ready(function() {
    //새로고침 및 페이지 이동 방지
    window.addEventListener('beforeunload', beforeunloadFunc, true);
    
    // F5, ctrl + F5, ctrl + r 새로고침 막기
    $(document).keydown(function (e) {
        if (e.which === 116) {
            if (typeof event == "object") {
                event.keyCode = 0;
            }
            return false;
        } else if (e.which === 82 && e.ctrlKey) {
            return false;
        }
    });
    
    //유저정보
    setUserInfo();
    $('#nav_menu_userInfo').on('click',function(e){
    	if(App_grp_c == '001'){
    		var comboList = ${naList};
            
    	    var chg_na_bzplc = '<select id="chg_na_bzplc_select" onchange="$(\'#nav_menu_userInfo\').attr(\'na_bzplc\',this.value);">';

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
    				var data = new Object();
                    data['user_id']   = App_userId;
                    data['na_bzplc']  = $('#nav_menu_userInfo').attr('na_bzplc');

                    var results = sendAjax(data, "/relogin", "POST");
                    
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
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
                        localStorage.setItem("nhlvaca_strg_yn", results.strg_yn);
                        offBeforeunload();
                        document.location.href = '/index';
                    }
    			}
    		});
    		
    		$("#btn_log").click(function(event){
                event.preventDefault();
                this.blur();   
                var target = '#layer-popup';
                var $layerContent = $(target).find($('.layer-content'));
                $layerContent.find($('.layer-title')).text('');
                $layerContent.find($('.layer-cont')).text('');
                $layerContent.find($('#popBtnClose')).off('click');
                var $LayerBtn = $layerContent.find($('.layer-btn')); 
                $LayerBtn.find($('#popBtnYes')).off('click');    
                $LayerBtn.find($('#popBtnNo')).off('click'); 
                layerPopupClose(target);   
                fn_adminPop('LALM9998');              
            });
    		
    		$("#btn_query").click(function(event){
                event.preventDefault();
                this.blur(); 
                var target = '#layer-popup';
                var $layerContent = $(target).find($('.layer-content'));
                $layerContent.find($('.layer-title')).text('');
                $layerContent.find($('.layer-cont')).text('');
                $layerContent.find($('#popBtnClose')).off('click');
                var $LayerBtn = $layerContent.find($('.layer-btn')); 
                $LayerBtn.find($('#popBtnYes')).off('click');    
                $LayerBtn.find($('#popBtnNo')).off('click'); 
                layerPopupClose(target);   
                fn_adminPop('LALM9999');                     
            });
    	}
    })

    //기준정보 가져오기
    var baseInfoData = sendAjaxFrm("", "/selectBaseInfo", "POST");
    
    if(baseInfoData.status != RETURN_SUCCESS){
    	if(baseInfoData && baseInfoData.status == NO_DATA_FOUND){
    		MessagePopup('OK','기준정보를 조회할수 없습니다.<br>시스템담당자에게 문의하세요.',function(res){
    			logout();
    		});
    	}else {
    		showErrorMessage(baseInfoData,"NOTFOUND","",function(res){
    			logout();
    		});
    	}
    	return;
    }else{
    	baseInfo = setDecrypt(baseInfoData);
    	//메뉴리스트 가져오기
    	if(baseInfo.menuList == null){
    		MessagePopup('OK','권한 메뉴를 조회할수 없습니다.<br>시스템담당자에게 문의하세요.',function(res){
                logout();
            }); 
    		return;
        }else {
        	menuList = baseInfo.menuList;
        }
    	
    	//팝업화면리스트 가져오기
        if(baseInfo.popupList == null){
            MessagePopup('OK','화면정보를 조회할수 없습니다.<br>시스템담당자에게 문의하세요.',function(res){
                logout();
            }); 
            return;
        }else {
        	popupList = baseInfo.popupList;
        }
    	
        //화면버튼리스트 가저오기
        if(baseInfo.btnList == null){
            MessagePopup('OK','화면버튼정보를 조회할수 없습니다.<br>시스템담당자에게 문의하세요.',function(res){
                logout();
            }); 
            return;
        }else {
        	btnList = baseInfo.btnList;
        }
        
        //화면권한 가져오기
        if(baseInfo.authList == null){
            MessagePopup('OK','화면권한정보를 조회할수 없습니다.<br>시스템담당자에게 문의하세요.',function(res){
                logout();
            }); 
            return;
        }else {
        	authList = baseInfo.authList;
        }
        
        //공통코드 가져오기
        if(baseInfo.comboList == null){
            MessagePopup('OK','공통코드정보를 조회할수 없습니다.<br>시스템담당자에게 문의하세요.',function(res){
                logout();
            }); 
            return;
        }else {
        	comboList = baseInfo.comboList;
        }
    }

	const HC_MENU = ["000225", "000226"];
    $.each(menuList, function(i){
        if(menuList[i].MENU_LVL_C == "2"){
            var scd_menu_id = menuList[i].SCD_MENU_ID;            
            var sideMenu = '<li class="treeview" id=' + menuList[i].SCD_MENU_ID + '>'
                         +     '<a href="javascript:;" title="' + menuList[i].MENU_NM + '">'
                         +         '<i class="fa ' + menuList[i].ICON_NM + '"></i> '
                         +         '<span>' + menuList[i].MENU_NM + '</span>'
                         +         '<span class="pull-right-container">'
                         +             '<i class="fa fa-angle-left pull-right"></i>'
                         +         '</span>'
                         +     '</a>';
                         
            var depMenu = '<ul class="treeview-menu depth2">';
            for(var j = 0; j < menuList.length; j++){
                if(menuList[j].MENU_LVL_C == "3" && scd_menu_id == menuList[j].SCD_MENU_ID){
                	// 출장우 예약 접수, 예약 리스트는 합천에서만 노출되도록
                	if(App_grp_c != "001" && HC_MENU.includes(menuList[j].MENU_ID) && App_na_bzplc != "8808990656236") continue;
//                 	if(App_grp_c != "001" && HC_MENU.includes(menuList[j].MENU_ID) && App_na_bzplc != "8808990661315") continue;
                		
                    depMenu += '<li>'
                             + '<a href="javascript:;" id="' + menuList[j].MENU_ID + '" pgid="' + menuList[j].PGID + '" pgmnm="' + menuList[j].PGMNM + '" flnm="' + menuList[j].FLNM + '" >'
                             + '<i class="fa fa-circle-o"></i> '
                             + '<span>' + menuList[j].MENU_NM + '</span></a></li>';
                }
            }
            sideMenu += depMenu;
            sideMenu +=      '</ul>'
                      + '</li>';
            $(".sidebar-menu").append(sideMenu);
        }
    });
    
    //트리뷰 이벤트
    $('.treeview > a').on('click',function(){       
        if($(this).parent('.treeview').hasClass('menu-open')!=true){
            
            $(this).parent().children('.treeview').stop().removeClass('menu-open');
            $('.treeview-menu').stop().slideUp();
            
            //if($('body').hasClass('sidebar-mini')==true){
                $('.sidebar-menu > .treeview').stop().removeClass('menu-open');
            //}            
            
            $(this).parent('.treeview').stop().addClass('menu-open'); 
            
            if($('body').hasClass('sidebar-mini')!=true){
                $(this).next('.treeview-menu').stop().slideDown();
            }else{
                $('.treeview-menu').stop().hide();
                $(this).next('.treeview-menu').stop().show();
                $(this).next('.treeview-menu').children('li').removeClass('menu-open');
            }            
        }else{          
            $(this).parent('.treeview').stop().removeClass('menu-open');
            if($('body').hasClass('sidebar-mini')!=true){
                $(this).next('.treeview-menu').stop().slideUp();
            }else{
                $(this).next('.treeview-menu').stop().hide();
            }            
        }
    });    
    
    // documents의 a태그들 중 원하는 a태그 클릭 했을때 실행    
    $('.treeview-menu.depth2 > li > a').on('click',function(){
        // 현재 눌린 a 태그 가져오기
        var link = $(this);        
        activeTab(link);        
    });    
        
    
    $('.sidebar-toggle').on('click',function(){
        if(tp=="PC"){
            if($('body').hasClass('sidebar-mini')!=true){
                $('.treeview').stop().removeClass('menu-open');
                $('.treeview-menu').stop().hide();
                $('.treeview-menu.depth2 > li').stop().removeClass('menu-open');
            }
            
            $('body').stop().removeClass('sidebar-open');
            $('body').stop().toggleClass('sidebar-mini');
        }else if(tp=="MOBILE"){
            if($('body').hasClass('sidebar-mini')==true){
                $('body').stop().removeClass('sidebar-mini');
            }
            $('body').stop().toggleClass('sidebar-open');
        }
    });
    
    // 탭 선언
    var tabs = $( "#tabs" ).tabs();
    tabs.removeClass('ui-corner-all');
    $('#tab_list').removeClass('ui-corner-all');
        
    
    // 해당 탭 지우기
    tabs.on( "click", "span.ui-icon-close", function() {
        var panelId = $( this ).closest( "li" ).remove().attr( "aria-controls" );
        // 해당하는 탭 제거
        $( "#" + panelId ).remove();
        //사이드패널삭제
        var sideId = panelId.replace("tabs-","side-");
        $( "#" + sideId ).closest( "li" ).remove();
        // 탭 refresh
        tabs.tabs( "refresh" );
    });
    
    /* 탭 화면 모두 제거 */
    $('#tabsAllClose').on('click', function() {
    	MessagePopup('YESNO','모든창을 닫으시겠습니까?',function(res){
    		if(res){
	            $('#tabs-list > div').each(function(index, elem) {
	                if (index != 0) {
	                    var tabId = $("#tab_list li:eq(1)").remove().attr("aria-controls");
	                    $('#' + tabId).remove();
	                    var sideId = tabId.replace("tabs-","side-");
	                    $( "#" + sideId ).closest( "li" ).remove();
	                }
	            });
	            tabIndex = 1;
	            tabs.tabs('refresh');
	            tabs.tabs('option', 'active', tabIndex);
    		}
        });
    });
    
    $('#tabsLeftScroll').on('click',function(){
        $('#tab_list').scrollLeft($('#tab_list').scrollLeft() + 100).stop();
    });
    
    
    $('#tabsRightScroll').on('click',function(){
        $('#tab_list').scrollLeft($('#tab_list').scrollLeft() - 100).stop();
    });
    
    //모바일 탭메뉴 알림
    var mobileTabInterval;
    var alert_msg = $(".Rsidebar .alert_msg");
    mobileTabInterval = setInterval (function (){
         setTimeout(function(){
             alert_msg.slideDown(200);
             setTimeout(function(){
                 alert_msg.hide();
             }, 2000);
         }, 2000);
    }, 5000);
    

    //사이드패널 버튼 클릭이벤트 추가
    $('.btn_Rsidebar').on('click',function(){
        $('.control-sidebar').stop().toggleClass('control-sidebar-open');
        clearInterval(mobileTabInterval);        
        
    });
    
    //사이드패널 메인페이지 호출
    $('#side-0').on('click',function(){
        tabs.tabs("option","active", 0);             
        $('.control-sidebar').stop().toggleClass('control-sidebar-open');
    });
    
    //main iframe 데이터 전달
    var iform  = document.createElement("form");
    iform.method  = "POST";
    iform.id      = "iframeParam";
    iform.name    = "iframeParam";
    iform.target  = "icontent";
    iform.action  = "/main";
    
    var inputData = document.createElement("input");
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("id"  , "data");
    inputData.setAttribute("name", "data");
    
    iform.appendChild(inputData);    
    document.body.appendChild(iform);
    
    //data 생성
    var data = new Object();
    data['pgid']    = "main";
    
    // String 형태로 변환
    iform.data.value = setEncrypt(data);    
    iform.submit();
    
    $("#iframeParam").remove();
    
    //공판장기본 가져오기
    var wmcListData  = sendAjaxFrm("", "/selectWmcListData", "POST");
        
    if(wmcListData.status != RETURN_SUCCESS){
        
        if(wmcListData.status == NO_DATA_FOUND){
            MessagePopup('OK','사업장 정보를 조회할수 없습니다.<br>사업장 정보관리 화면에서 정보를 등록하세요.<br>등록되지 않을경우 시스템 사용에 문제가 발생할 수 있습니다.',function(res){
            	$.each(menuList, function(i){
                    if(menuList[i].MENU_LVL_C == "3" &&  menuList[i].PGID == 'LALM0912'){                        
                        var $treeview = $("#" + menuList[i].MENU_ID );
                        activeTab($treeview);
                    }
                });
            });
        }else {
        	showErrorMessage(wmcListData,"NOTFOUND","",function(res){
                logout();
            });
        }
        return;
        
    }else{      
        wmcList = setDecrypt(wmcListData);        
    }
    //환경설정기본 가져오기
    var envListData  = sendAjaxFrm("", "/selectEnvListData", "POST");
        
    if(envListData.status != RETURN_SUCCESS){
    	
        if(envListData.status == NO_DATA_FOUND){
        	MessagePopup('OK','사업장 정보를 조회할수 없습니다.<br>사업장 정보관리 화면에서 정보를 등록하세요.<br>등록되지 않을경우 시스템 사용에 문제가 발생할 수 있습니다.',function(res){
                $.each(menuList, function(i){
                    if(menuList[i].MENU_LVL_C == "3" &&  menuList[i].PGID == 'LALM0912'){                        
                        var $treeview = $("#" + menuList[i].MENU_ID );
                        activeTab($treeview);
                    }
                });
            });
        }else {
        	showErrorMessage(wmcListData,"NOTFOUND","",function(res){
                logout();
            });
        }
        return;
    }    
    envList = setDecrypt(envListData);
    
});

//사업장명칭 및 회원정보 설정
function setUserInfo(){
	//왼쪽메뉴
	$("#user-panel_name").text(App_userNm);
	$("#user-panel_bzplnm").html(App_na_bzplnm);
    //상단메뉴
    $(".user_name").html('[' + App_na_bzplnm + '] ' + App_userNm );
    $("#nav_menu_userInfo").attr('na_bzplc',App_na_bzplc);
    <% if("127.0.0.1".equals((request.getHeader("X-Forwarded-For") ==  null)?request.getRemoteAddr():request.getHeader("X-Forwarded-For"))) { %>
    $("#nav_systemInfo").text('[로컬]');
    <% }else if("192.168.70.60".equals(InetAddress.getLocalHost().getHostAddress())) { %>
    $("#nav_systemInfo").text('[개발]');
    <% }else { %>
    $("#nav_systemInfo").text('');
	<% }%>
}

//탭활성화
function activeTab(link,param){
	var tabs = $( "#tabs" );
    // tabs_id 선언
    var tabs_id = "tabs-" + $(link).attr("id");
    // find_id 선언
    var find_id = $("[id= " + tabs_id + "]").attr("id");
    // tab_id 선언
    var tab_id = "#"+tabs_id;
    // a태그에 해당하는 탭이 열려 있을 경우
    if(find_id == tabs_id){
        // 열려있는 탭으로 이동
        tabs.tabs("option","active", id2Index("#tabs",tab_id));
        if(param != null){
        	fn_sendIFrameData(tabs_id, link, param);
        }
    // 아닐경우
    }else{
        // 탭을 추가
        addTab(link, param);
    }
    if(tp=="PC"){
        if($('body').hasClass('sidebar-mini')==true){
            $('.treeview').stop().removeClass('menu-open');
            $('.treeview-menu').stop().hide();
            $('.treeview-menu.depth2 > li').stop().removeClass('menu-open');
        }            
    }else if(tp=="MOBILE"){
        $('body').stop().removeClass('sidebar-open');
    }
}

//탭 추가
function addTab(link, param){
	var tabs = $( "#tabs" );
	// 탭 li 선언
    var tabTemplate = "<li><a href='<%="#"%>{href}'><%="#"%>{label}</a> <span class='ui-icon ui-icon-close' role='presentation'>Remove Tab</span></li>";
    var sidebarTemplate ="<li aria-controls='<%="#"%>{tabId}'><a href='javascript:;' id='<%="#"%>{id}'><i class='fa fa-star'></i><%="#"%>{label}</a><a href='javascript:;' id='<%="#"%>{closeid}' class='del like_Del'><i class='fa fa-times'></i></a></li>";
    
    if($('#tabs >ul >li').length < 10){     
        // 탭 라벨 선언
        var label = $(link).text();
        // id 값을 tabs-? 로 선언
        var id =  "tabs-" + $(link).attr("id");
        var sideId =  "side-" + $(link).attr("id");
        var sidecloseId =  "sideClose-" + $(link).attr("id");
        // li replace
        var li = $( tabTemplate.replace( /#\{href\}/g, "#" + id ).replace( /#\{label\}/g, label ) );
        var html = $( sidebarTemplate.replace( /#\{tabId\}/g, id ).replace( /#\{id\}/g, sideId ).replace( /#\{label\}/g, label ).replace( /#\{closeid\}/g, sidecloseId ) );

        // 탭의 ui-tabs-nav 찾아서 li를 append 시킨다
        tabs.find(".ui-tabs-nav").append(li);
        $("#sort_fav_lst").append(html);
        
        // 사이드패널에 클릭이벤트 추가
        $('#'+sideId).on('click',function(){
            // tab_id 선언
            var tab_id = "#" + id;
            // 열려있는 탭으로 이동
            tabs.tabs("option","active", id2Index("#tabs",tab_id));             
            $('.control-sidebar').stop().toggleClass('control-sidebar-open');
        });
        $('#'+sidecloseId).on('click',function(){               
            $("[aria-controls= " + id + "]").remove();
            $( "#" + id ).remove();
            $( "#" + sidecloseId ).closest( "li" ).remove();
            // 탭 refresh
            tabs.tabs( "refresh" );
        });
                            
        // 추가된 탭의 내용을 삽입
        tabs.find(".tabs-list").append( "<div id='" + id + "' style='width:100%;height:100%;padding:0;margin:0;border:0;'><iframe id='i" + id + "' name='i" + id + "' style='width:100%;height:100%;' frameborder=0 border=0 hspace='0' vspace='0'></iframe></div>"  );
        
        //iframe 데이터 전달
        fn_sendIFrameData(id, link, param);          

        // 탭 새로고침
        tabs.tabs( "refresh" );
        
        // 생성 된 탭으로 바로 가게 한다.
        setTimeout(function() {
            var index = $('#tabs a[href="#tab_id"]').parent().index();
            
            tabs.tabs('option', 'active', index);
            if($('#tab_list').get(0).scrollWidth  > $('#tab_list').width()){
            	$('#tab_list').scrollLeft($('#tab_list').get(0).scrollWidth).stop();
            }
        }, 100);
               
        
    }else{
        MessagePopup('OK','메뉴는 10개 이상 열 수 없습니다. '); 
    }
}

//선택한 documents a 태그의 해당하는 tab index 찾기
function id2Index(tabsId, srcId){
    // index 값 -1로 설정
    var index = -1;
    // i 값 선언, tbH : 해당하는 탭의 a 태그 찾기
    var i = 0, tbH = $(tabsId).find("li a");
    // tbH 길이 선언
    var lntb = tbH.length;
    // lntb가 0보다 클경우
    if(lntb>0){
        for(i=0;i<lntb;i++){
            o=tbH[i];
            if(o.href.search(srcId)>0){
                index = i;
            }
        }
    }
    // index값 리턴
    return index;
}

//로그아웃
function logout(){
	var result;                     
    $.ajax({
        url: "/userLogout",
        type: "POST",
        dataType:'json',
        async: false,
        headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
        success:function(data) {                    
            var bytes  = CryptoJS.AES.decrypt(data.data.toString(), keyutf, {iv: ivutf});
            var plaintext = bytes.toString(CryptoJS.enc.Utf8);              
            result = JSON.parse(plaintext);  
            if(result.result == "logOut"){
                localStorage.removeItem("nhlvaca_token");
                localStorage.removeItem("nhlvaca_key");
                localStorage.removeItem("nhlvaca_iv");
                localStorage.removeItem("nhlvaca_userId");
                localStorage.removeItem("nhlvaca_eno");
                localStorage.removeItem("nhlvaca_na_bzplc");
                localStorage.removeItem("nhlvaca_security");
                localStorage.removeItem("nhlvaca_na_bzplnm");
                localStorage.removeItem("nhlvaca_usrnm");
                localStorage.removeItem("nhlvaca_grp_c");
                localStorage.removeItem("nhlvaca_strg_yn");
                offBeforeunload();
                document.location.href="/";
            }                 
        },
        error:function(response){            
            result = JSON.parse(response.responseText);
            showErrorMessage(result);
        }
    });          
    return result; 
}

//새로고침
function beforeunloadFunc(event){
    // 표준에 따라 기본 동작 방지
    event.preventDefault();
    // Chrome에서는 returnValue 설정이 필요함
    event.returnValue = '';
}
//새로고침 및 페이지 이동 방지 취소
function offBeforeunload(){ 
    window.removeEventListener('beforeunload', beforeunloadFunc,true);
}
//
function fn_adminPop(p_pgid){
    var menu_id = '000801';      
    layerPopupPage(p_pgid, menu_id, null, null, 1000, 750,function(result){
        //callback(result);
    });
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
    $("<div id='overlay' class='overlay'></div>").appendTo('.wrapper');    
}
//모달레이어팝업Report
function layerPopupReport(reportId,reportNm,reportData,reportType,callback){
    var target = '#layer-popupReport';
    var $winW = $(window).width();
    var $winH = $(window).height();
    var $layerContent = $(target).find($('.report-content'));

    $layerContent.find($('.report-title')).text(reportNm);
    if(reportType = 'V'){
        $layerContent.css({'max-width': '1200px','height':'860px'});
        $layerContent.find($('.report-cont')).css({'height':'820px'});
    }else if(reportType = 'H'){
        $layerContent.css({'max-width': '900px','height':'900px'});
        $layerContent.find($('.report-cont')).css({'height':'860px'});
    }else {
        $layerContent.css({'max-width': '1280px','height': '960px'});
        $layerContent.find($('.report-cont')).css({'height':(960 - 40)+'px'});
    }
    
    // 추가된 탭의 내용을 삽입
    $layerContent.find($('.report-cont')).html( "<iframe id='report_" + reportId + "' name='report_" + reportId + "' style='width:100%;height:100%;' frameborder=0 border=0 hspace='0' vspace='0'></iframe>"  );
    
    //iframe 데이터 전달  
    fn_sendIFrameDataReport(reportId, reportData);   

    
    $(target).show().addClass('open');
    var $layerContentH = $(target).find($('.report-content')).height() + 40;
    var $conPos = ($winH / 2) - ($layerContentH / 2);
    
    if( $winH > $layerContentH ){
        $layerContent.css({marginTop: $conPos});
    } else {
        $layerContent.css({marginTop: 0});
    }
    $("<div id='overlay' class='overlay'></div>").appendTo('.wrapper'); 
    
    
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

//모달레이어팝업Page
function layerPopupPage(pgid,menu_id,param,result,width,height,callback){
	
	var popup_info;
	
    $.each(popupList, function(i){
        if(popupList[i].PGID == pgid){
            popup_info = popupList[i];
        }
    });
	
	var popupPage = '<div id="popupPage_'+pgid+'" class="popup-wrap" style="z-index:'+pop_zIndex+';" tabindex="0">'
	              + ' <div class="popup-content">'
	              + '  <div class="pop_head"><p>['+pgid+']'+popup_info.PGMNM+'</p></div>'
	              + '  <div class="pop_body">'
	              + '      <iframe id="pop_' + pgid + '" name="pop_' + pgid + '" style="width:100%;height:100%;" frameborder=0 border=0 hspace=0 vspace=0></iframe><input type="hidden" id="pop_result_' + pgid + '" value="false">'
	              + '  </div>'
	              + '  <button id="popBtnClose" class="popup_close" onclick="javascript:PopupClose(\'#popupPage_'+pgid+'\');return false;"><span class="fa fa-remove"></span></button>'
	              + ' </div>'
	              + '</div>';
	
	$(popupPage).appendTo('body'); 
	
    var target = "#popupPage_"+pgid;
    var $winW = $(window).width();
    var $winH = $(window).height();
    var $layerContent = $(target).find($('.popup-content'));
    

    $layerContent.css({'max-width': width +'px','height': height +'px'});
    $layerContent.find($('.pop_body')).css({'height':(height - 40)+'px'});
    
    //iframe 데이터 전달
    fn_sendIFrameDataPopup(popup_info, menu_id, param, result);  
    
    if(!param || param.unique_yn != 'Y') $(target).show().addClass('open');
    var $layerContentH = $layerContent.height();
    var $conPos = ($winH / 2) - ($layerContentH / 2);
    
    if( $winH > $layerContentH ){
        $layerContent.css({marginTop: $conPos});
    } else {
        $layerContent.css({marginTop: 0});
    }    
    $("<div id='popupPage_"+pgid+"_overlay' class='pop_overlay' style='z-index:"+pop_zIndex+"'></div>").appendTo('.wrapper');
    //리턴받을경우
    $("#pop_result_" + pgid ).on('change',function(){
    	console.log('TEST : TEST');
		if($(this).val()){
            var result = $('iframe#pop_'+pgid).get(0).contentWindow.pageInfo;
            PopupClose(target);
			callback(result.returnValue);
		};
    });
    pop_zIndex++;
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
    pop_zIndex--;
};


//iframeData 전송
function fn_sendIFrameData(id, link, param){

    var pgid    = $(link).attr("pgid");
    var pgmnm   = $(link).attr("pgmnm");
    var flnm    = $(link).attr("flnm");
    var menu_id = $(link).attr("id"); 
    var menu_nm = $(link).find("span").text();
    
    //create form
    var iform  = document.createElement("form");
    iform.method  = "POST";
    iform.id   = "iframeParam";
    iform.name = "iframeParam";
    iform.target = "i" + id;
    iform.action = "/page/" + flnm;
    
    var inputData = document.createElement("input");
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("id"  , "data");
    inputData.setAttribute("name", "data");
    
    iform.appendChild(inputData);    
    document.body.appendChild(iform);
    
    //data 생성
    var data = new Object();
    data['pgid']    = pgid;
    data['pgmnm']   = pgmnm;
    data['menu_id'] = menu_id;    
    data['menu_nm'] = menu_nm;
    if(param != null){
    	data['param'] = param;
    }else {
    	data['param'] = null;
    }
    
        
    $.each(btnList, function(i){
        if(btnList[i].PGID == pgid){
            data['menu_btn'] = btnList[i];
        }
    });
    
    $.each(authList, function(i){
        if(authList[i].MENU_ID == menu_id){
            data['auth_btn'] = authList[i];
        }
    });
    
    // String 형태로 변환
    iform.data.value = setEncrypt(data);    
    iform.submit();
    
    $("#iframeParam").remove();
}


//popupData 전송
function fn_sendIFrameDataPopup(popup_info,menu_id,param,result){
    //create form
    var iform  = document.createElement("form");
    iform.method  = "POST";
    iform.id   = "iframeParam";
    iform.name = "iframeParam";
    iform.target = "pop_" + popup_info.PGID;
    iform.action = "/page/" + popup_info.FLNM;
    
    var inputData = document.createElement("input");
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("id"  , "data");
    inputData.setAttribute("name", "data");
    
    iform.appendChild(inputData);    
    document.body.appendChild(iform);
    
    //data 생성
    var data = new Object();
    data['menu_id']  = menu_id;
    data['pgid']  = popup_info.PGID;
    data['pgmnm']  = popup_info.PGMNM;
    data['param']    = param;
    data['popup_info'] = popup_info;
    
    $.each(btnList, function(i){
        if(btnList[i].PGID == popup_info.PGID){
            data['menu_btn'] = btnList[i];
        }
    });
    $.each(authList, function(i){
        if(authList[i].MENU_ID == menu_id){
            data['auth_btn'] = authList[i];
        }
    });
    
    data['result'] = result;
            
    // String 형태로 변환
    iform.data.value = setEncrypt(data);    
    iform.submit();
    
    $("#iframeParam").remove();
}

//iframeData 전송
function fn_sendIFrameDataReport(id, data){
    //create form
    var iform  = document.createElement("form");
    iform.method  = "POST";
    iform.id   = "iframeParam";
    iform.name = "iframeParam";
    iform.target = "report_" + id;
<% if(InetAddress.getLocalHost().getHostAddress().indexOf("10.220.235.") > -1) { %>
    iform.action = "http://localhost:8270/aireport65/aiServer.jsp";
<% }else { %>
    iform.action = "/AIREPORT/AISERVER";
<% }%>
    
    var inputData = document.createElement("input");
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("name", "reportID");
    
    iform.appendChild(inputData);
    

    var inputData = document.createElement("input");
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("name", "data");
    

    iform.appendChild(inputData);
    
    
    var inputData = document.createElement("input");
    inputData.setAttribute("type", "hidden");
    inputData.setAttribute("name", "reportParams");
    
    iform.appendChild(inputData);

    
    document.body.appendChild(iform);

    iform.reportID.value = id;
    iform.data.value = data;
    iform.reportParams.value = "showEXCEL:true,showHWP:false,showPOWERPOINT:false,showMSWORD:false,contextMenu:false";
    
    iform.submit();
    
    $("#iframeParam").remove();
}  
</script>
</head>
<body oncontextmenu='return false'>
<!-- wrapper -->
<div class="wrapper">
    <!-- header -->
    <header class="header">
        <!-- Logo -->
        <a href="javascript:$('#tabs').tabs('option','active', 0);" class="logo">
            <span class="logo-mini"><img src="/images/common/logo_header.png" alt=""></span>
            <span class="logo-lg"><img src="/images/common/logo_header.png" alt=""><b>스마트가축시장</b></span>
        </a>
        <!-- Header topNav -->
        <nav class="topNav clearfix">
            <!-- Sidebar toggle button-->
            <a href="javascript:;" class="sidebar-toggle">
                <span class="sr-only">Toggle navigation</span>
            </a>
            
            <!-- topNav nav_menu -->
            <div class="nav_menu">
                <ul class="nav clearfix">
                    <!-- Tasks -->
                    <li class="tasks-menu">
                        <p>
                            <span id="nav_systemInfo"></span>
                        </p>
                    </li>

                    <!-- User Account -->
                    <li class="user-menu">
                        <p>
                            <img src="/images/common/ico_header_person.svg" class="user-image" alt="User Image" id="nav_menu_userInfo" />
                            <span class="user_name"></span>
                        </p>
                    </li>
                    <li>
                        <a  href="javascript:;" onclick="logout(); return false;">Logout</a>  
                    </li> 
                    <!-- Control Sidebar Toggle Button -->
                    <li class="Rsidebar">
                        <a href="javascript:;" class="btn_Rsidebar"><i class="fa fa-gears"></i></a>
                        <span class="alert_msg">
                            모바일 탭메뉴는 여기를 클릭하세요.
                        </span>
                    </li>          
                </ul>
            <!-- topNav nav_menu -->
            </div>
        <!-- Header topNav -->
        </nav>
    <!-- header -->
    </header>
        
    <aside class="main-sidebar">
        <section class="sidebar">
            <!-- user-panel -->
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="/images/common/ico_menu_login.svg">
                </div>
                <div class="pull-left info">
                    <p id="user-panel_name"></p>
                    <span id="user-panel_bzplnm"></span>
                </div>
            </div>
            <!-- //.user-panel -->
            <ul class="sidebar-menu" data-widget="tree">
                <!-- sidebar menu -->
            </ul>
        </section>
        <!-- //.sidebar -->
    </aside>
        
    <!-- content-wrapper -->
    <div class="content-wrapper"> 
        
        <div id="tabs" class="index_tab_box clearfix line" style="z-index:10000 !important">
            
            <div id="tabs-list" class="tabs-list"> 
                <div id="tabs-0" style='width:100%;height:100%;padding:0;margin:0;border:0;'>
                    <iframe id="icontent" name="icontent" style="width:100%;height:100%;"  allowfullscreen></iframe>
                    
                </div>
            </div>
            <div class="tabs-close">
                <a href="javascript:;" id="tabsLeftScroll" ><</a>
                <a href="javascript:;" id="tabsRightScroll">></a>
                <a href="javascript:;" class="all_close" id="tabsAllClose">전체탭닫기</a>
            </div>
            <ul id="tab_list" class="tabs">
                <li><a href="#tabs-0">main</a></li>                
            </ul>
        </div>
    </div>
    <!-- content-wrapper -->
    <!-- footer -->
    <footer class="footer">
        <strong>Copyright &copy; 2021 스마트가축시장.</strong> All rights reserved.
    </footer>
    <!-- //.footer -->
    <!-- control-sidebar-->
    <aside class="control-sidebar">
        <div class="inner" id="box_sidebar">
            <div class="ta_r">
                활성화 페이지
            </div>
            <ul class="fav_lst" id="sort_fav_lst">
                <li aria-controls="tabs-0">
                    <a href="javascript:;" id="side-0"><i class="fa fa-star"></i> main</a>
                </li>
            </ul>
        </div>
    </aside>
    <!-- //.control-sidebar -->      
</div>
<!-- wrapper -->

<!-- 팝업 -->
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
</div>


<!-- 출력물을 위한 레이어  -->
<div id="layer-popupReport" class="report-wrap" tabindex="0">
    <div class="report-content">
        <div class="report-title"></div>
        <div class="report-cont"></div>
        <button id="popBtnClose" class="report_popup_close" onclick="javascript:layerPopupClose('#layer-popupReport');return false;"><span class="fa fa-remove"></span></button>
    </div>
</div>

<!-- 프로그래스바  -->
<div id="loading-prograss" class="loading-prograss" tabindex="0">
    <div class="spinner-border text-seconary" role="status">
        <img class="loading-image" src="/images/common/loading/Spin-1s-200px.gif">
    </div>
</div>

<script src="/js/default.js"></script>
</body>
</html>