<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script type="text/javascript">
$(document).ready(function() {
    //컨텍스트 메뉴     
    window.addEventListener("contextmenu",function(event){
        if(event.target.tagName != "INPUT" && document.getSelection() == ""){
            event.preventDefault();
        }
    });  
    
    // F5, ctrl + F5, ctrl + r 새로고침 방지
    $(document).keydown(function (e) {
    	var code = e.keyCode || e.which;
        if (e.which === 116) {
            if (typeof event == "object") {
                event.keyCode = 0;
            }
            if($('#btn_Save')[0]) $('#btn_Save').click();
            return false;
        } else if (e.which === 82 && e.ctrlKey) {
            return false;
        }
        if (code == 115) {
            if($('#btn_Search')[0]) $('#btn_Search').click();
            return false;
        }
    });
    
    //폼 엔터값 방지    
    $('form').not('.enterAllow').keypress(function(e){
    	var code = e.keyCode || e.which;
    	if(code == 13){
    		e.preventDefault();
    		return false;
    	}
    });
    
    // 폼 input 자동완성 off
    $('form').attr("autocomplete", "off");
    
    //날짜 기본 설정
    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNames: ['일','월','화','수','목','금','토'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
        showMonthAfterYear: true,
        changeMonth: true,
        changeYear: true
        
    });

    //NUMBER타입 음수 INPUT변수에 숫자만 입력 콤마추가
    $(document).on("input",".integer", function(){
    	$(this).val($(this).val().replace(/[^0-9]/g,'').replace(/(\..*)\./g,'$1'));
    }).on("focus",".integer",function(){
    	if($(this).val() == 0){
    		$(this).val(null) ;
    	}else {
    		$(this).val($(this).val().replace(/[^0-9]/g,'').replace(/(\..*)\./g,'$1'));
    	}
    }).on("focusout",".integer",function(){
    	$(this).val($(this).val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    });

    //NUMBER타입 음수 INPUT변수에 숫자만 입력 콤마추가
    $(document).on("input",".minusnumber", function(){
    	$(this).val($(this).val().replace(/[^-?0-9.]/g,'').replace(/(\..*)\./g,'$1'));
    }).on("focus",".minusnumber",function(){
    	if($(this).val() == 0){
    		$(this).val(null) ;
    	}else {
    		$(this).val($(this).val().replace(/[^-?0-9.]/g,'').replace(/(\..*)\./g,'$1'));
    	}
    }).on("focusout",".minusnumber",function(){
    	$(this).val($(this).val().replace(/(-?\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    });

    //NUMBER타입 INPUT변수에 숫자만 입력 콤마추가
    $(document).on("input",".number", function(){
    	$(this).val($(this).val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'));
    }).on("focus",".number",function(){
    	if($(this).val() == 0){
    		$(this).val(null) ;
    	}else {
    		$(this).val($(this).val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'));
    	}
    }).on("focusout",".number",function(){
    	$(this).val($(this).val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
    });
  
    //그리드 NUMBER
    $(document).on("input",".grid_number", function(){
        $(this).val($(this).val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'));
    }).on("focus",".grid_number",function(){
        if($(this).val() == 0){
            $(this).val(null) ;
        }else {
            $(this).val($(this).val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'));
        }
    });
    
    //DIGIT타입 INPUT변수에 숫자만 입력
    $(document).on("input",".digit", function(){
        $(this).val($(this).val().replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'));
    }).on("focus",".digit",function(){
        if($(this).val() == 0){
            $(this).val(null) ;
        }
    });
    
    //TELNO타입 INPUT변수에 숫자,'-'만 입력
    $(document).on("input",".telno", function(){
        $(this).val($(this).val().replace(/[^0-9.:\-]/g,'').replace(/(\..*)\./g,'$1'));
    });
    
    //일자 Keydwon 이벤트(숫자만 입력되게)
    $(document).on("keydown", ".date", function(event) {
        if(!(event.which && (event.which > 47 && event.which < 58  //숫자
        		          || event.which > 95 && event.which < 106 //키패드숫자
        		          || event.which == 8 || event.which == 46 //backspace, del
        		          || event.which == 13 // 엔터키
        		          || event.which == 37 || event.which == 38 || event.which == 39 || event.which == 40 //방향키 
        		          ))) {
            event.preventDefault();
        }
    });        
    $(document).on("keyup", ".date", function(event) {
        var tmpInputBox  = $(this).val();
        var tmpInputLength = $(this).val().length;
        var tmpNumber    = tmpInputBox.replace(/[^0-9]/g, "");
        var position     = this.selectionStart;  
        var tmpYYYYMMDD  = "";
        if(tmpNumber.length <= 4) {
        	tmpYYYYMMDD = tmpNumber;
        } else if(tmpNumber.length <= 6) {
            tmpYYYYMMDD += tmpNumber.substring(0,4);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(4);
        } else {
            tmpYYYYMMDD += tmpNumber.substring(0,4);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(4,6);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(6,8);
        }
        $(this).val(tmpYYYYMMDD);
        if(event.which == 8 || event.which == 46 
                || event.which == 37 || event.which == 38 || event.which == 39 || event.which == 40)
        this.setSelectionRange(position,position);
    });
    
    $(document).on("focus", ".date", function(event) {
        var tmpInputBox  = $(this).val();
        var tmpInputLength = $(this).val().length;
        var tmpNumber    = tmpInputBox.replace(/[^0-9]/g, "");
        var position     = this.selectionStart;  
        var tmpYYYYMMDD  = "";
        if(tmpNumber.length <= 4) {
            tmpYYYYMMDD = tmpNumber;
        } else if(tmpNumber.length <= 6) {
            tmpYYYYMMDD += tmpNumber.substring(0,4);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(4);
        } else {
            tmpYYYYMMDD += tmpNumber.substring(0,4);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(4,6);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(6);
        }
        
        if(fn_isDate(tmpYYYYMMDD)){
        	$(this).val(tmpYYYYMMDD);
        }else{
        	$(this).val('');
        }
        if(event.which == 8 || event.which == 46 
                || event.which == 37 || event.which == 38 || event.which == 39 || event.which == 40)
        this.setSelectionRange(position,position);
    });
    
    $(document).on("focusout", ".date", function(event) {
        var tmpInputBox  = $(this).val();
        var tmpInputLength = $(this).val().length;
        var tmpNumber    = tmpInputBox.replace(/[^0-9]/g, "");
        var position     = this.selectionStart;  
        var tmpYYYYMMDD  = "";
        if(tmpNumber.length <= 4) {
            tmpYYYYMMDD = tmpNumber;
        } else if(tmpNumber.length <= 6) {
            tmpYYYYMMDD += tmpNumber.substring(0,4);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(4);
        } else {
            tmpYYYYMMDD += tmpNumber.substring(0,4);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(4,6);
            tmpYYYYMMDD += "-";
            tmpYYYYMMDD += tmpNumber.substring(6,8);
        }
        
        if(fn_isDate(tmpYYYYMMDD)){
        	$(this).val(tmpYYYYMMDD);
        }else{
        	$(this).val('');
        }
    });
    
    //그리드 포멧
    //날짜 ####-##-##
    $.extend($.fn.fmatter,{
        gridDateFormat:function(val, options, rowdata) {
        	val = !val?.trim() ? '' : val.trim().replace(/[^0-9]/g,'');
        	if(val.length == 8 && fn_isDate(val)){
        		var y,m,d;
                y = val.substring(0,4);
                m = val.substring(4,6);
                d = val.substring(6,8);
                return y+"-"+m+"-"+d;
        	}else{
        		return val;
        	}
            
        }
    });
    $.extend($.fn.fmatter.gridDateFormat,{
        unformat:function(val,options){
            return val.replace(/-/gi,"");
        }
    });
    //개체식별번호 ###-###-#########
    $.extend($.fn.fmatter,{
        gridIndvFormat:function(val, options, rowdata) {
        	if(val.trim().length == 15){
        		var a,b,c;
                a = val.substring(0,3);
                b = val.substring(3,6);
                c = val.substring(6);
                return a+"-"+b+"-"+c;
            }else if(val.trim().length == 12){
                var a,b;
                a = val.substring(0,3);
                b = val.substring(3);
                return a+"-"+b;
            }else{
                return val;
            }
        }
    });
    $.extend($.fn.fmatter,{
        gridBarCodeFormat : function(val, options, rowdata) {
        	val = !val?.trim() ? '' : val.trim().replace(/[^0-9]/g,'');
        	return val.slice(-9, val.length);
        }
    });
    $.extend($.fn.fmatter.gridIndvFormat,{
        unformat:function(val,options){
            return val.replace(/-/gi,"");
        }
    });
    
    //우편번호 ###-###
    $.extend($.fn.fmatter,{
        gridPostFormat:function(val, options, rowdata) {
            if(val.trim().length == 6){
                var y,m,d;
                a = val.substring(0,3);
                b = val.substring(3,6);
                return a+"-"+b;
            }else{
                return val;
            }
        }
    });
    $.extend($.fn.fmatter.gridPostFormat,{
        unformat:function(val,options){
            return val.replace(/-/gi,"");
        }
    });    
});

//**************************************
//function  : fn_setGridStatus 
//paramater : p_obj ex) 'p_Gird' 
//          , p_rowid
//          , p_oldValue
//          , p_newValue
//result    : N/A
//그리드 상태 변경 '_STATUS_' 컬럼 반드시 필요함
//**************************************  

function fn_setGridStatus(p_grid, p_rowid, p_oldValue, p_newValue){
    if($("#"+p_grid).jqGrid('getCell', p_rowid, '_STATUS_') == '+') {
        return;
    }else {
        if(p_oldValue != p_newValue){
            $("#"+p_grid).jqGrid('setCell', p_rowid, '_STATUS_', '*',GRID_MOD_BACKGROUND_COLOR);
        }
    }       
}

//**************************************
//function  : fn_GridColByName 
//paramater : p_obj ex) 'p_Gird' 
//        , p_name
//result    : colIndex
//**************************************  
function fn_GridColByName(p_grd, p_name){
    var colModel    = $('#' + p_grd).jqGrid('getGridParam', 'colModel');
    var returnVal = '' 
    for (var i = 0, len = colModel.length; i < len; i++) {
        if(colModel[i].name == p_name) returnVal =  i;
    }
    return returnVal;
}

//**************************************
//function  : fn_setGridFooter 
//paramater : p_obj ex) 'p_Gird' 
//          , p_arr
//          , p_depth (footer 순서)
//result    : N/A
//**************************************    
function fn_setGridFooter(p_obj, p_arr){
    var $obj = document.getElementById(p_obj);  
    $($obj.grid.sDiv).find("tr.footrow:not(:last)").remove();
    var $footerRows = $($obj.grid.sDiv).find("tr.footrow");
    var $footerLastRow = $($obj.grid.sDiv).find("tr.footrow:last");
    for(var arr = 0; arr< p_arr.length;arr++){
    	var arrList = p_arr[arr];
        var $footerRow = $footerLastRow.clone();
        $footerRow.insertBefore($footerRows);
    
	    for(var arrData = 0; arrData<arrList.length;arrData++){
	    
	        var arrItem = arrList[arrData];        
	        var startIndex = $footerRow.find(">td[aria-describedby=" + $obj.id +"_" + arrItem[0] + "]").index();
	        if(arrItem[3] == "String"){
	            $footerRow.find(">td[aria-describedby=" + $obj.id +"_" + arrItem[0] + "]").css({"text-align":"center"});
	            $footerRow.find(">td[aria-describedby=" + $obj.id +"_" + arrItem[0] + "]").text(arrItem[1]);
	        }else if(arrItem[3] == "Integer"){
	            $footerRow.find(">td[aria-describedby=" + $obj.id +"_" + arrItem[0] + "]").css({"text-align":"right"});
	            $footerRow.find(">td[aria-describedby=" + $obj.id +"_" + arrItem[0] + "]").text($.fmatter.util.NumberFormat(arrItem[1], $.jgrid.formatter.integer));
	        }else if(arrItem[3] == "Number"){
	            $footerRow.find(">td[aria-describedby=" + $obj.id +"_" + arrItem[0] + "]").css({"text-align":"right"});
	            $footerRow.find(">td[aria-describedby=" + $obj.id +"_" + arrItem[0] + "]").text($.fmatter.util.NumberFormat(arrItem[1], $.jgrid.formatter.Number));
	        }
	        if(parseInt(arrItem[2]) > 1){
	        	$footerRow.find("td:eq("+startIndex+")").attr("colspan",arrItem[2]);
	            var width = parseInt($footerRow.find("td:eq("+startIndex+")").css("width").replace("px",""));
	            
	            var spanTdStartIndex = (startIndex+1);
	            var spanTdEndIndex = (spanTdStartIndex + (parseInt(arrItem[2]) - 1));
	            for(i=spanTdStartIndex;i<spanTdEndIndex;i++){
	            	if($footerRow.find("td:eq("+i+")").is(':visible') == false)continue;
	                $footerRow.find("td:eq("+i+")").hide();
	                width += parseInt($footerRow.find("td:eq("+i+")").css("width").replace("px",""));
	                
	            }
	            $footerRow.find("td:eq("+startIndex+")").css({"width":width+"px"});
	        }	        
	    }
    }
    $footerLastRow.hide();    
}    
    

//**************************************
//function  : fn_OpenMenu 
//paramater : p_pgid 프로그램아이디
//          , param (OBJECT )
//result    : N/A
//**************************************
function fn_OpenMenu(p_pgid,param,p_close){
	
	var v_menuList = parent.menuList;
	var panelId = parent.$('li.ui-tabs-tab.ui-corner-top.ui-state-default.ui-tab.ui-tabs-active.ui-state-active').attr('aria-controls');
	$.each(v_menuList, function(i){
		
	    if(v_menuList[i].MENU_LVL_C == "3" &&  v_menuList[i].PGID == p_pgid){
	        
	        var $treeview = parent.$("#" + v_menuList[i].MENU_ID );
	        parent.activeTab($treeview, param);
	        if(p_close){
	            //사이드패널삭제
	            var sideId = panelId.replace("tabs-","side-");
	            parent.$( "#" + sideId ).closest( "li" ).remove();
	            // 해당하는 탭 제거
                parent.$('li[aria-controls=' + panelId +']').remove();
                // 해당하는 화면 제거
                parent.$( "#" + panelId ).remove();
	        }
	    }
	});
}


//**************************************
// function  : MessagePopup 
// paramater : p_type ('OK, WANNING, ERROR' = alert, 'YESNO' = comfirm) 
//           , p_msg
//           , p_title (NULL = ('OK'='알림', 'WANNING'='경고', 'ERROR'='애러', 'YESNO'='선택'))
//           , callback (comfirm일경우 필수)
// result    : N/A
//**************************************
function MessagePopup(p_type, p_msg, callback){
    if(callback == null){
        parent.MessagePopup(p_type, p_msg, callback); 
    }else {     
        parent.MessagePopup(p_type, p_msg, function(res){
            if(typeof callback == 'function'){
                callback(res);
            }
        });
    }
}

//**************************************
//function  : ReportPopup 
//paramater : p_reportName 
//          , p_titleObj
//          , p_grd ex)'grdId'
//          , p_type (H:세로,V:가로)
//result    : N/A
//**************************************
function ReportPopup(p_reportName,p_titleObj, p_grd, p_type){
	
	p_titleObj['filename'] = p_reportName;
	//p_titleObj['samuso']   = App_na_bzplc +" " + App_na_bzplnm ;
	p_titleObj['samuso']   = App_na_bzplnm ;
    p_titleObj['usrnm']    = App_userNm;
    p_titleObj['pgid']     = pageInfo.pgid;
    p_titleObj['pgmnm']    = pageInfo.pgmnm;
    
    var ReportData = new Object();
    
    if(typeof p_grd == "object"){
    	if (p_grd.length == 0) {
            MessagePopup("OK", '조회된 데이터가 없습니다.');
            return false;
         }
    	
    	ReportData['LISTDATA_1'] = p_grd;
    	
    }else if(typeof p_grd == "string"){
    	var grdArr = p_grd.split(',');
    	if(grdArr.length == 1){
    		//그리드 값 가져오기
            gridSaveRow(p_grd);
            var $clonGrid = $('#' + p_grd);

            var colModel    = $clonGrid.jqGrid('getGridParam', 'colModel');
            var gridData    = $clonGrid.jqGrid('getGridParam', 'data');
                
            if (gridData.length == 0) {
               MessagePopup("OK", '조회된 데이터가 없습니다.');
               return false;
            }
            for (var i = 0, len = colModel.length; i < len; i++) {
               if (colModel[i].hidden === true) {
                   continue;
               }
               
               if (colModel[i].formatter == 'select') {
                   $clonGrid.jqGrid('setColProp', colModel[i].name, {
                       unformat: gridUnfmt
                   });
               }
            }
            
            ReportData['LISTDATA_1'] = $clonGrid.getRowData();
            
            for (var i = 0, len = colModel.length; i < len; i++) {
                if (colModel[i].hidden === true) {
                    continue;
                }
                
                if (colModel[i].formatter == 'select') {
                    $clonGrid.jqGrid('setColProp', colModel[i].name, {
                        unformat: gridRedoFmt
                    });
                }
            }
    	}else {
    		var listCnt = 0;
    		while(true){
    			var v_grd = grdArr[listCnt];
    			//그리드 값 가져오기
                gridSaveRow(v_grd);
                var $clonGrid = $('#' + v_grd);

                var colModel    = $clonGrid.jqGrid('getGridParam', 'colModel');
                var gridData    = $clonGrid.jqGrid('getGridParam', 'data');
                    
                if (gridData.length == 0) {
                   MessagePopup("OK", '조회된 데이터가 없습니다.');
                   return false;
                }
                for (var i = 0, len = colModel.length; i < len; i++) {
                   if (colModel[i].hidden === true) {
                       continue;
                   }
                   
                   if (colModel[i].formatter == 'select') {
                       $clonGrid.jqGrid('setColProp', colModel[i].name, {
                           unformat: gridUnfmt
                       });
                   }
                }
                
                ReportData['LISTDATA_' + (listCnt + 1) ] = $clonGrid.getRowData();
                
                for (var i = 0, len = colModel.length; i < len; i++) {
                    if (colModel[i].hidden === true) {
                        continue;
                    }
                    
                    if (colModel[i].formatter == 'select') {
                        $clonGrid.jqGrid('setColProp', colModel[i].name, {
                            unformat: gridRedoFmt
                        });
                    }
                }
                listCnt++;
                if(listCnt == grdArr.length) break;
    			
    		}
    	}
    	
    }
    
    var Data = new Object();
    Data['TITLE'] = p_titleObj;
    Data[p_reportName] = ReportData;
    
    if(p_type == 'T'){
    	console.log(JSON.stringify(Data));
    }
    	
	parent.layerPopupReport(p_reportName,p_titleObj.title,JSON.stringify(Data),p_type);
}

//**************************************
//function  : fn_InitFrm 
//paramater : p_FrmId ex) 'p_FrmId' 
// result   : N/A
//**************************************
function fn_InitFrm(p_FrmId){
    var initFrm   = $("#" + p_FrmId).find("input,select,textarea,checkbox");              
    var initItem  = "";
    var itemNames = "";
    
    for(var i=0; i<initFrm.length; i++){
        initItem = $(initFrm[i]).prop('tagName');                               
        if(initItem == "INPUT" || initItem == "TEXTAREA"){
            if($(initFrm[i]).attr("type") == "checkbox"){
            	if ($(initFrm[i]).hasClass("checked")) {
	                $(initFrm[i]).prop("checked", true);
            	}
            	else {
            		if (!$(initFrm[i]).hasClass("no_chg")) {
		                $(initFrm[i]).prop("checked", false);
            		}
            	}
            }else if($(initFrm[i]).attr("type") == "radio"){
                itemNames = "";
                itemNames = $(initFrm[i]).attr("name");
                $("input[name="+itemNames+"]").removeAttr("checked");
                $("input[name="+itemNames+"]")[0].checked = true;
            }else{
                $(initFrm[i]).val("");  
            } 
        }else if(initItem == "SELECT"){
            $(initFrm[i]).find("option:first").attr("selected", "selcted");
        }
    }       
}
//**************************************
//function  : fn_setClearFromFrm
//paramater : p_FrmId ex) 'p_FrmId'
//          , p_GridIDs ex) '#Grid1 , #Grid2' 
//result    : N/A
//**************************************
function fn_setClearFromFrm(p_FrmId,p_GridIDs){
   
	$("#"+ p_FrmId).find('input[type=hidden], input[type=text], input[type=password], textarea, select, input[type=checkbox]').not('.noEvent').bind('input',function(event){
		//console.log(event);
        //그리드 초기화
        $(p_GridIDs).jqGrid("clearGridData", true);
    });  
}

//**************************************
//function  : fn_DisableFrm(프레임단위 Disable)
//paramater : p_FrmId, p_boolean ex) 'p_FrmId', true 
//result   : N/A
//**************************************
function fn_DisableFrm(p_FrmId, p_boolean){
     
	var disableFrm = $("#" + p_FrmId).find("input,select,textarea,checkbox,button");
	var itemNames = "";
	
	for(var i=0; i<disableFrm.length; i++){
	    itemNames = $(disableFrm[i]).attr("id");
	    
	    if(p_boolean) {
	        $("#"+itemNames).attr("disabled", true);            
	    } else {
	        $("#"+itemNames).attr("disabled", false);           
	    }
	}       
}

//***************************************
//* function   : fn_getDay
//* paramater  : p_addDate,p_retType('YYYYMMDD')
//* result     : today = "" + year + "-" + month + "-" + date + " " + hour + ":" + minute;
//*                  ex)2021-05-18 10:06
//***************************************
function fn_getDay(p_addDate,p_retType){
	var v_now    = new Date();
	v_now.setDate(v_now.getDate()+p_addDate);
	
	var v_year   = v_now.getFullYear();
	var v_month  = v_now.getMonth() + 1;
	var v_date   = v_now.getDate();
	var v_hour   = v_now.getHours();
	var v_minute = v_now.getMinutes();
	var v_second = v_now.getSeconds();
	
	v_month = v_month >= 10 ? v_month : "0" + v_month;
	v_date  = v_date  >= 10 ? v_date  : "0" + v_date;
	// ""을 빼면 year + month (숫자+숫자) 됨.. ex) 2018 + 12 = 2030이 리턴됨.
	
	if(p_retType == 'YYYYMMDD'){
        return v_year + v_month + v_date;
    }else if(p_retType == 'YYYY-MM-DD'){
        return v_year + "-" + v_month + "-" + v_date;
    }else {
		return v_year + "-" + v_month + "-" + v_date + " " + v_hour + ":" + v_minute;
	}
}

//***************************************
//* function   : fn_getAddDay
//* paramater  : p_date, p_addDate,p_retType('YYYYMMDD')
//* result     : year + "-" + month + "-" + date + " " + hour + ":" + minute;
//*              ex)2021-05-18 10:06
//***************************************
function fn_getAddDay(p_date, p_addDate, p_retType){
	
	var vValue_Num = p_date.replace(/[^0-9]/g,"");
    
    if(fn_isNull(vValue_Num) == true || vValue_Num.length != 8){
        alert('날짜가 아닙니다.');
        return;
    }
        
    var rxDatePattern = /^(\d{4})(\d{1,2})(\d{1,2})$/;
    var dtArray = vValue_Num.match(rxDatePattern);
        
    var dtYear = dtArray[1];
    var dtMonth = dtArray[2];
    var dtDay = dtArray[3];
    
    var v_now    = new Date(dtYear, dtMonth - 1, dtDay);
    v_now.setDate(v_now.getDate()+p_addDate);
    var v_year   = v_now.getFullYear();
    var v_month  = v_now.getMonth() + 1;
    var v_date   = v_now.getDate();
    var v_hour   = v_now.getHours();
    var v_minute = v_now.getMinutes();
    var v_second = v_now.getSeconds();
    
    v_month = v_month >= 10 ? v_month : "0" + v_month;
    v_date  = v_date  >= 10 ? v_date  : "0" + v_date;
    // ""을 빼면 year + month (숫자+숫자) 됨.. ex) 2018 + 12 = 2030이 리턴됨.
    
    if(p_retType == 'YYYYMMDD'){
        return ""+v_year + v_month + v_date;
    }else if(p_retType == 'YYYY-MM-DD'){
        return ""+v_year + "-" + v_month + "-" + v_date;
    }else {
    	return ""+v_year + "-" + v_month + "-" + v_date + " " + v_hour + ":" + v_minute;
    }
}

//***************************************
//* function   : fn_SpanDay
//* paramater  : p_sDate, p_eDate, p_retType(Year,Month,Day), p_addDay(option)
//* result     : today = "" + year + "-" + month + "-" + date + " " + hour + ":" + minute;
//*                  ex)2021-05-18 10:06
//***************************************
function fn_SpanDay(p_sDate, p_eDate, p_retType){

	var vSValue_Num = p_sDate.replace(/[^0-9]/g,"");
	var vEValue_Num = p_eDate.replace(/[^0-9]/g,"");
	
	var rxDatePattern = /^(\d{4})(\d{1,2})(\d{1,2})$/;
    var sDtArray = vSValue_Num.match(rxDatePattern);
    var eDtArray = vEValue_Num.match(rxDatePattern);

    var v_sdate    = new Date(sDtArray[1], sDtArray[2] - 1, sDtArray[3]);
    var v_edate    = new Date(eDtArray[1], eDtArray[2] - 1, eDtArray[3]);
    
    if(p_retType == 'Year'){
        var sYear = parseInt(v_sdate.getFullYear());
        var eYear = parseInt(v_edate.getFullYear());
        
        return (eYear - sYear);
    }else if(p_retType == 'Month'){
        var sYear = parseInt(v_sdate.getFullYear());
        var eYear = parseInt(v_edate.getFullYear());

        var sMonth  = parseInt(v_sdate.getMonth()+ 1) ;
        var eMonth  = parseInt(v_edate.getMonth()+ 1) ;
        
        return ((eYear - sYear) * 12) + (eMonth - sMonth);
    }else if(p_retType == 'day'){
    	var inteval = v_edate - v_sdate;
        var day = 1000*60*60*24;
        
        return Math.floor(p_retType / day);
    }
}

//***************************************
//* function   : fn_getToday
//* paramater  : 
//* result     : 2021-05-18
//***************************************
function fn_getToday(p_retType){
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1;
    var yyyy = today.getFullYear();

    if(dd < 10) {
        dd='0'+dd
    }
    
    if(mm < 10) {
        mm='0'+mm
    }
    
    if(p_retType == 'YYYYMMDD'){
    	return ""+ yyyy  + mm + dd;
    }else {
    	return yyyy + '-' + mm + '-' +dd;
    }
    
    
}

//***************************************
//* function   : fn_toDate
//* paramater  : date(날짜) ex) 20211007
//* result     : 2021-10-07
//***************************************
function fn_toDate(date,type){
  var yyyy = date.substr(0,4);
  var mm = date.substr(4,2);
  var dd = date.substr(6,2);
  if(type =="KR"){
	  return yyyy + '년 ' + mm + '월 ' +dd + '일';  
  }else {
	  return yyyy + '-' + mm + '-' +dd; 
  }
  
}

//***************************************
//* function   : fn_dateToData
//* paramater  : date(날짜) ex) 2021-10-07
//* result     : 20211007
//***************************************
function fn_dateToData(date){
	return date.replace(/[^0-9]/g,'').substring(0,8);
}

/*------------------------------------------------------------------------------
 * 1. 함 수 명    : fn_isNum
 * 2. 입 력 변 수 : 
 * 3. 출 력 변 수 : true, false
 ------------------------------------------------------------------------------*/
function fn_isNum(str){        
    const regExp = /[0-9]/g;
	if(regExp.test(str)){
		return true;
	} else {
		return false;
	}
}


/*------------------------------------------------------------------------------
 * 1. 함 수 명    : fn_isChar
 * 2. 입 력 변 수 : 
 * 3. 출 력 변 수 : true, false
 ------------------------------------------------------------------------------*/
function fn_isChar(str){        
    const regExp = /[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z]/g;
	if(regExp.test(str)){
		return true;
	} else {
		return false;
	}
} 


//***************************************
//* function   : fn_toComma
//* paramater  : num(숫자) ex) 123123123
//* result     : 123,123,123
//***************************************
function fn_toComma(num){
	data = String(num).split(".");
	if(data.length == 2){
		return data[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "." + data[1];
	}else {
		return data[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}

}

//***************************************
//* function   : fn_delComma
//* paramater  : num(숫자) ex) 123,123,123
//* result     : 123123123
//***************************************
function fn_delComma(num){
	if (num != undefined) {
		return num.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');
	}
	else {
		return "";
	}
}

//***************************************
//* function   : fn_createVetCodeBox
//* paramater  : p_obj
//* result     : p_obj가 없을경우 Grid CodeString
//***************************************
function fn_createVetCodeBox(p_obj,p_codeView, p_flag) {

	var comboListData = sendAjaxFrm("", "/Common_selVet", "POST");
	
	if(comboListData.status != RETURN_SUCCESS){
	    showErrorMessage(comboListData,'NOTFOUND');
	    return;
	}else {
	    var comboList = setDecrypt(comboListData);
	    if (p_obj != null){
	    
	            
	        $("#" + p_obj).empty().data('options');
	  
	        if (p_flag != null) {
	            $("#" + p_obj).append('<option value="">' + p_flag + '</option>');
	        }
	        
	        $.each(comboList, function(i){
	            var v_simp_nm = (p_codeView)?('['+comboList[i].LVST_MKT_TRPL_AMNNO + '] ' + comboList[i].BRKR_NAME):'' + comboList[i].BRKR_NAME;
	            $("#" + p_obj).append('<option value=' + comboList[i].LVST_MKT_TRPL_AMNNO + '>' + v_simp_nm + '</option>');
	        });
	    }else {
	        var resultString = '';
	        
	        if (p_flag != null) {
	            resultString += ':'+p_flag;
	        }
	          
	        $.each(comboList, function(i){
	            if(resultString != '')resultString += ';'
	            resultString += comboList[i].LVST_MKT_TRPL_AMNNO + ':' + comboList[i].BRKR_NAME;
	        }); 
	        return resultString;
	        
	    }
	}
}



//***************************************
//* function   : fn_setCodeBox
//* paramater  : 
//* result     : N/A
//***************************************
function fn_setCodeBox(p_obj, p_simp_tpc, p_simp_c_grp_sqno, p_codeView, p_flag) {
  <c:if test="${requestScope['javax.servlet.forward.request_uri'] != '/index'}">
    var comboList = parent.comboList;
  </c:if>
  
  $("#" + p_obj).empty().data('options');

  if (p_flag != null) {
      $("#" + p_obj).append('<option value="">' + p_flag + '</option>');
  }
    
  $.each(comboList, function(i){
      if(comboList[i].SIMP_TPC == p_simp_tpc && comboList[i].SIMP_C_GRP_SQNO == p_simp_c_grp_sqno){
          var v_simp_nm = (p_codeView)?('['+comboList[i].SIMP_C + '] ' + comboList[i].SIMP_CNM):'' + comboList[i].SIMP_CNM;
          $("#" + p_obj).append('<option value=' + comboList[i].SIMP_C + '>' + v_simp_nm + '</option>');
      }        
  }); 
}

//***************************************
//* function   : fn_setCustomCodeBox
//* paramater  : 
//* result     : N/A
//***************************************
function fn_setCustomCodeBox(p_target, p_obj) {
	$("#" + p_target).empty().data('options');
	for (info of p_obj) {
		$("#" + p_target).append("<option value='" + info["value"] + "' data-details='" + info["details"] + "'>" + info["text"] + "</option>");
	}
// 	if (p_flag != null) {
// 	    $("#" + p_obj).append('<option value="">' + p_flag + '</option>');
// 	}
	  
// 	$.each(comboList, function(i){
// 	    if(comboList[i].SIMP_TPC == p_simp_tpc && comboList[i].SIMP_C_GRP_SQNO == p_simp_c_grp_sqno){
// 	        var v_simp_nm = (p_codeView)?('['+comboList[i].SIMP_C + '] ' + comboList[i].SIMP_CNM):'' + comboList[i].SIMP_CNM;
// 	        $("#" + p_obj).append('<option value=' + comboList[i].SIMP_C + '>' + v_simp_nm + '</option>');
// 	    }        
// 	}); 
}

//***************************************
//* function   : fn_setCodeRadio
//* paramater  : 
//* result     : N/A
//***************************************
function fn_setCodeRadio(p_target, p_obj, p_simp_tpc, p_simp_c_grp_sqno) {
    <c:if test="${requestScope['javax.servlet.forward.request_uri'] != '/index'}">
    var comboList = parent.comboList;
    </c:if>

    $("#" + p_target).empty();
    
    $.each(comboList, function(i){
        if(comboList[i].SIMP_TPC == p_simp_tpc && comboList[i].SIMP_C_GRP_SQNO == p_simp_c_grp_sqno){
        	var appendData = '<div class="cell">\n'
        	               + '<input type="radio" id="' + p_obj + '_' + comboList[i].SIMP_C
        	               + '" name="' + p_obj + '_radio" value="' + comboList[i].SIMP_C + '"'
        	               + ' onclick="javascript:fn_setChgRadio(\''+p_obj+'\',\''+comboList[i].SIMP_C+'\');"/>\n'
        	               + '<label for="' + p_obj + '_' + comboList[i].SIMP_C + '">' + comboList[i].SIMP_CNM + '</label>\n'
        	               + '</div>';
        	
            $("#" + p_target).append(appendData);
        }        
    }); 
}

//***************************************
//* function   : fn_setChgRadio
//* paramater  : 
//* result     : N/A
//***************************************
function fn_setChgRadio(p_target, p_simp_c) {
    $("#" + p_target).val(p_simp_c);
	var v_target = p_target + '_' + p_simp_c;
	$("#" + v_target).prop('checked',true);
}

//***************************************
//* function   : fn_setRadioChecked
//* paramater  : 
//* result     : N/A
//***************************************
function fn_setRadioChecked(p_obj) {
	var v_simp_c = $("#" + p_obj).val();
	var v_target = p_obj + '_' +v_simp_c;
	$("#" + v_target).prop('checked',true);
}

//***************************************
//* function   : fn_setCodeString(그리드에서 사용)
//* paramater  : 
//* result     : ex) 1:여;0:부
//***************************************
function fn_setCodeString(p_simp_tpc, p_simp_c_grp_sqno, p_flag) {
  <c:if test="${requestScope['javax.servlet.forward.request_uri'] != '/index'}">
    var comboList = parent.comboList;
  </c:if>
  
  var resultString = '';
  
  if (p_flag != null) {
	  resultString += ':'+p_flag;
  }
    
  $.each(comboList, function(i){
      if(comboList[i].SIMP_TPC == p_simp_tpc && comboList[i].SIMP_C_GRP_SQNO == p_simp_c_grp_sqno){
    	  if(resultString != '')resultString += ';'
    	  resultString += comboList[i].SIMP_C + ':' + comboList[i].SIMP_CNM;
      }        
  });
  return resultString;
}
 
//***************************************
//* function   : fn_setCustonCodeString(커스텀 코드 그리드 사용 텍스트 변환)
//* paramater  : 
//* result     : ex) 1:여;0:부
//***************************************
function fn_setCustonCodeString(p_list) {
	var rtnString = "";
	for (obj of p_list) {
		if (fn_isNull(obj["value"])) continue;
		rtnString += obj["value"];
		rtnString += ":";
		rtnString += obj["text"];
		rtnString += ";";
	}
	return rtnString;
}

//***************************************
//* function   : fn_setCodeArr
//* paramater  : 
//* result     : ex) 1:여;0:부
//***************************************
function fn_setCodeArr(p_simp_tpc, p_simp_c_grp_sqno) {
<c:if test="${requestScope['javax.servlet.forward.request_uri'] != '/index'}">
  var comboList = parent.comboList;
</c:if>

var resultArr = [];

$.each(comboList, function(i){
    if(comboList[i].SIMP_TPC == p_simp_tpc && comboList[i].SIMP_C_GRP_SQNO == p_simp_c_grp_sqno){
    	var tempObj = {
    		code: comboList[i].SIMP_C,
    		codeNm: comboList[i].SIMP_CNM
    	}
    	
    	resultArr.push(tempObj);
    }        
}); 
return resultArr;
}
 
//***************************************
//* function   : fn_isDate
//* paramater  : 
//* result     : true/false
//***************************************
function fn_isDate(p_date) {
    var vValue = p_date;
    var vValue_Num = vValue.replace(/[^0-9]/g,"");
    
    if(fn_isNull(vValue_Num) == true){
    	return false;
    }
    
    if(vValue_Num.length != 8){
    	return false;
    }
    
    var rxDatePattern = /^(\d{4})(\d{1,2})(\d{1,2})$/;
    var dtArray = vValue_Num.match(rxDatePattern);
    
    if(dtArray == null){
    	return false;
    }
    
    var dtYear = dtArray[1];
    var dtMonth = dtArray[2];
    var dtDay = dtArray[3];
    
    if(dtMonth < 1 || dtMonth > 12){
    	return false;
    }
    else if(dtDay < 1 || dtDay > 31){
    	return false;
    }
    else if((dtMonth == 4 || dtMonth == 6 ||dtMonth == 9 ||dtMonth == 11) && dtDay == 31){
    	return false;
    }
    else if(dtMonth == 2){
    	var isLeap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
    	if(dtDay > 29 || (dtDay == 29 && !isLeap)){
    		return false;
    	}
    }
    return true;
}

//***************************************
//* function   : fn_isNull
//* paramater  : 
//* result     : true/false
//***************************************
function fn_isNull(p_data){
	if(String(p_data) == 'undefined' || String(p_data) == 'null' || String(p_data) == '' ){
		return true;
	}else {
		return false;
	}
}

//***************************************
//* function   : 농가검색 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallFtsnmPopup(p_param,p_flg,callback){
	var pgid = 'LALM0134P';
	var menu_id = $("#menu_info").attr("menu_id");
	
	if(p_flg){
		var result;
		var resultData = sendAjax(p_param, "/LALM0134P_selList", "POST");  
        
        if(resultData.status != RETURN_SUCCESS){
            showErrorMessage(resultData,'NOTFOUND');
        }else{      
            result = setDecrypt(resultData);
        }
        if(result != null && result.length == 1){
        	callback(result[0]);
        }else {
        	parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
                callback(result);
            });
        }
	}else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
	        callback(result);
	    });
	}
}

//***************************************
//* function   : 농가검색 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallFtsnm0127Popup(p_param,p_flg,callback){
  var pgid = 'LALM0127P';
  var menu_id = $("#menu_info").attr("menu_id");
  
  if(p_flg){
      var result;
      var resultData = sendAjax(p_param, "/LALM0127P_selList", "POST");  
      
      if(resultData.status != RETURN_SUCCESS){
          showErrorMessage(resultData,'NOTFOUND');
      }else{      
          result = setDecrypt(resultData);
      }
      if(result != null && result.length == 1){
          callback(result[0]);
      }else {
          parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
              callback(result);
          });
      }
  }else {
      parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
          callback(result);
      });
  }
}


//***************************************
//* function   : 중도매인 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallMwmnnmPopup(p_param,p_flg,callback){
	var pgid = 'LALM0125P';
	var menu_id = $("#menu_info").attr("menu_id");
	
	if(p_flg){
		var result;
	 	if( fn_isNum(p_param['sra_mwmnnm']) && fn_isChar(p_param['sra_mwmnnm']) ){
	 		p_param['v_trmn_amnno']       = '2';
	    }else if( fn_isNum(p_param['sra_mwmnnm']) ){
	    	p_param['v_trmn_amnno']       = '1';
	    }else{
	    	p_param['v_trmn_amnno']       = '2';
	    }		
		var resultData = sendAjax(p_param, "/LALM0125P_selList", "POST");  
      
		if(resultData.status != RETURN_SUCCESS){
            showErrorMessage(resultData,'NOTFOUND');
        }else{      
            result = setDecrypt(resultData);
        }
        if(result != null && result.length == 1){
      	    callback(result[0]);
        }else {
      	    parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
              callback(result);
          });
        }
	}else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
	        callback(result);
	    });
	}
}

//***************************************
//* function   : 중도매인(참가번호) 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallMwmnnmNoPopup(p_param,p_flg,callback){
	var pgid = 'LALM0129P';
	var menu_id = $("#menu_info").attr("menu_id");
	
	if(p_flg){
		var result;

	 	if( fn_isNum(p_param['sra_mwmnnm']) && fn_isChar(p_param['sra_mwmnnm']) ){
	 		p_param['v_trmn_amnno']       = '2';
	    }else if( fn_isNum(p_param['sra_mwmnnm']) ){
	    	p_param['v_trmn_amnno']       = '1';
	    }else{
	    	p_param['v_trmn_amnno']       = '2';
	    }		
		var resultData = sendAjax(p_param, "/LALM0129P_selList", "POST");  
    
		if(resultData.status != RETURN_SUCCESS){
            showErrorMessage(resultData,'NOTFOUND');
        }else{      
            result = setDecrypt(resultData);
        }
        if(result != null && result.length == 1){
    	    callback(result[0]);
        }else {
    	    parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
                callback(result);
            });
        }
	}else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
	        callback(result);
	    });
	}
}

//***************************************
//* function   : 수송자검색 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallCaffnmPopup(p_param,p_flg,callback){
	var pgid = 'LALM0128P';
	var menu_id = $("#menu_info").attr("menu_id");
	
	if(p_flg){
		var result;
	 	if( fn_isNum(p_param['vhc_drv_caffnm']) && fn_isChar(p_param['vhc_drv_caffnm']) ){
	     	p_param['vhc_drv_caffnm_c']       = '2';
	    }else if( fn_isNum($( "#vhc_drv_caffnm" ).val()) ){
	    	p_param['vhc_drv_caffnm_c']       = '1';
	    }else{
	    	p_param['vhc_drv_caffnm_c']       = '2';
	    }		
		var resultData = sendAjax(p_param, "/LALM0128P_selList", "POST");  
  
		if(resultData.status != RETURN_SUCCESS){
            showErrorMessage(resultData,'NOTFOUND');
        }else{      
            result = setDecrypt(resultData);
        }
        if(result != null && result.length == 1){
  	        callback(result[0]);
        }else {
  	        parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
              callback(result);
           });
        }
	}else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
	        callback(result);
	    });
	}
}

//***************************************
//* function   : 개체검색 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallMmIndvPopup(p_param,p_flg,callback){
	var pgid = 'LALM0221P';
	var menu_id = $("#menu_info").attr("menu_id");
	
	if(p_flg){
		if(p_param.sra_indv_amnno.length < 4 ){
			MessagePopup('OK','귀표번호는 4자리 이상입력해야합니다.',function(){
			});
			return;
		}     	 
		 
		if(p_param.sra_indv_amnno.length == 4) {
			p_param["hid_sra_indv_amnno_c"] = "1";
		} else if(p_param.sra_indv_amnno.length >= 5) {
			p_param["hid_sra_indv_amnno_c"] = "2";
		} else if(p_param.sra_indv_amnno != null) {
			p_param["hid_sra_indv_amnno_c"] = "3";
		}
		
		var result;
		
		var resultData = sendAjax(p_param, "/LALM0221P_selList", "POST");  
    
		if(resultData.status != RETURN_SUCCESS){
          showErrorMessage(resultData,'NOTFOUND');
      }else{      
          result = setDecrypt(resultData);
      }
      if(result != null && result.length == 1){
    	    callback(result[0]);
      }else {
    	    parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
            callback(result);
        });
      }
	}else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
	        callback(result);
	    });
	}
}

//***************************************
//* function   : 수의사 검색 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallMmTrplPopup(p_param,p_flg,callback){
	var pgid = 'LALM0131P';
	var menu_id = $("#menu_info").attr("menu_id");
	if(p_flg){
		var result;
	 	if( fn_isNum(p_param['brkr_name']) && fn_isChar(p_param['brkr_name']) ){
	     	p_param['v_brkr_name_c']       = '2';
	    }else if( fn_isNum($( "#vhc_drv_caffnm" ).val()) ){
	    	p_param['v_brkr_name_c']       = '1';
	    }else{
	    	p_param['v_brkr_name_c']       = '2';
	    }	
		var resultData = sendAjax(p_param, "/LALM0131P_selList", "POST");  
  
		if(resultData.status != RETURN_SUCCESS){
        showErrorMessage(resultData,'NOTFOUND');
    }else{      
        result = setDecrypt(resultData);
    }
    if(result != null && result.length == 1){
  	    callback(result[0]);
    }else {
  	    parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
          callback(result);
      });
    }
	}else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
	        callback(result);
	    });
	}
}

//***************************************
//* function   : 경제통합거래처검색 검색 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallBmTrplPopup(p_param,p_flg,callback){
  var pgid = 'LALM0132P';
  var menu_id = $("#menu_info").attr("menu_id");
  if(p_flg){
      var result;
      if( fn_isNum(p_param['brkr_name']) && fn_isChar(p_param['brkr_name']) ){
          p_param['v_brkr_name_c']       = '2';
      }else if( fn_isNum($( "#vhc_drv_caffnm" ).val()) ){
          p_param['v_brkr_name_c']       = '1';
      }else{
          p_param['v_brkr_name_c']       = '2';
      }   
      var resultData = sendAjax(p_param, "/LALM0131P_selList", "POST");  

      if(resultData.status != RETURN_SUCCESS){
      showErrorMessage(resultData,'NOTFOUND');
  }else{      
      result = setDecrypt(resultData);
  }
  if(result != null && result.length == 1){
      callback(result[0]);
  }else {
      parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
        callback(result);
    });
  }
  }else {
      parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
          callback(result);
      });
  }
}
 
//***************************************
//* function   : 주소 검색 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallRoadnmPopup(callback){
  var pgid = 'LALM0126P';
  var menu_id = $("#menu_info").attr("menu_id");
  
  parent.layerPopupPage(pgid, menu_id, null, null, 800, 600,function(result){
      callback(result);
  });
  
}

//***************************************
//* function   : 그룹 추가 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallGrpAddPopup(callback){
	var pgid = 'LALM0833P';
	var menu_id = $("#menu_info").attr("menu_id");
	
	parent.layerPopupPage(pgid, menu_id, null, null, 800, 600,function(result){
	    callback(result);
	});
}

//***************************************
//* function   : 유저 추가 팝업
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallUserAddPopup(callback){
	var pgid = 'LALM0833P2';
	var menu_id = $("#menu_info").attr("menu_id");
	
	parent.layerPopupPage(pgid, menu_id, null, null, 800, 600,function(result){
	    callback(result);
	});
}


//***************************************
//* function   : 개체이력조회 팝업(인터페이스)
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallIndvInfHstPopup(p_param,p_flg,callback){
	var pgid = 'LALM0222P';
	var menu_id = $("#menu_info").attr("menu_id");
	p_param["ctgrm_cd"]  = "4700"
	
	if(p_flg){
		
		var result;
		
		var resultData = sendAjax(p_param, "/LALM0899_selIfSend", "POST");  
		
		if(resultData.status != RETURN_SUCCESS){
        	showErrorMessage(resultData,'NOTFOUND');
	    }else{      
	        result = setDecrypt(resultData);
	    }
		
	    if(result != null && result["INQ_CN"] == 1){
	  	    callback(result);
	    } else {
	  	    parent.layerPopupPage(pgid, menu_id, p_param, result, 1300, 900,function(result){
	          callback(result);
	      	});
	    }
	    
	} else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 1300, 900,function(result){
	        callback(result);
	    });
	}
}

function fn_CallIndvInfHstPopupForExcel(p_param,p_flg,callback){
	var pgid = 'LALM0222P';
	var menu_id = $("#menu_info").attr("menu_id");
	p_param["ctgrm_cd"]  = "4700"
	
	if(p_flg){
		
		var result;
		
		var resultData = sendAjax(p_param, "/LALM0899_selIfSend", "POST");  
		
		if(resultData.status != RETURN_SUCCESS){
        	showErrorMessage(resultData,'NOTFOUND');
	    }else{      
	        result = setDecrypt(resultData);
		    if(result != null && result["INQ_CN"] == 1){
		  	    callback(result);
		    } else {
		  	    parent.layerPopupPage(pgid, menu_id, p_param, result, 1300, 900,function(result){
		          callback(result);
		      	});
		    }
	    }
	} else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 1300, 900,function(result){
	        callback(result);
	    });
	}
}
//***************************************
//* function   : 농가정보조회 팝업(인터페이스)
//* paramater  : p_param(object), p_flg(단건 리턴여부)
//* result     : gridRowData
//***************************************
function fn_CallFhsPopup(p_param,p_flg,callback){
	var pgid = 'LALM0223P';
	var menu_id = $("#menu_info").attr("menu_id");
	
	if(p_flg){
		
		var result;
		
		p_param["ctgrm_cd"]  = "4100"
		
		var resultData = sendAjax(p_param, "/LALM0899_selIfSend", "POST");  
  
		if(resultData.status != RETURN_SUCCESS){
        	showErrorMessage(resultData,'NOTFOUND');
	    }else{      
	        result = setDecrypt(resultData);
	    }
		
	    if(result != null && result.length == 1){
	  	    callback(result[0]);
	    }else {
	  	    parent.layerPopupPage(pgid, menu_id, p_param, result, 800, 600,function(result){
	          callback(result);
	      	});
	    }
	    
	}else {
		parent.layerPopupPage(pgid, menu_id, p_param, null, 800, 600,function(result){
	        callback(result);
	    });
	}
}

 
//***************************************
//* function   : gridSaveRow
//* paramater  : gridID
//* result     : N/A
//인라인 에디팅 중 다른 행으로 넘어가면
//기존에 변경된 것이 원래대로 복원되면서 다른 행으로 이동한다(설명 : http://1004lucifer.blogspot.com/2019/05/jqgrid-inline.html)
//saveRow는 변경된 것을 저장하고 다른 행이로 이동하는 방법이긴 한데 실제 사용된 부분에선 그냥 저장하든 수정후 저장하든 false가 나온다.
//***************************************
function gridSaveRow(gridID) {
	var flag = false;
	var ids = $('#' + gridID).jqGrid('getDataIDs');
	for (var i = 0, len = ids.length; i < len; i++) {
		var flg = $('#' + gridID).jqGrid('saveRow', ids[i]);
		if (flg === true) {
			flag = true;
		}
	}
	return flag;
}


//***************************************
//* function   : ExcelDownload
//* paramater  : grid
//* result     : N/A
//***************************************
function fn_ExcelDownlad(gid, p_title, p_footer){

	gridSaveRow(gid);
   var gridData    = $('#' + gid).jqGrid('getGridParam', 'data');
   
   if (gridData.length == 0) {
       MessagePopup("OK", '조회된 데이터가 없습니다.');
       return false;
   }
   
   var message = '다운로드사유를 입력하세요.<br/><br/><input id="input_rn" maxlength="50" style="padding: 4px 6px 2px 6px;width: 100%;line-height: 12px;border: 1px solid #d9d9d9;vertical-align: middle;background: #fff;outline: none;"';   
   message += '/>';
   message += '<script type="text/javascript">';
   message += '$(document).find(\'input[id=input_rn]\').focusout(function(e){';
   message += 'parent.inputRn=$(this).val();';
   message += '});';
   message += '<';
   message += "/script>";
   
   MessagePopup('YESNO', message, function(res){
	   if(res){
		   if(parent.inputRn.length < 2){
			   MessagePopup('OK','다운로드사유를 2글자 이상 입력해주세요.');
			   return;
		   }
		   fn_ExcelDownlad_Tmp(gid, p_title, p_footer,parent.inputRn);
	   }
   });
   
   function fn_ExcelDownlad_Tmp(gid, p_title, p_footer,input_rn){
	   var newcolModel = [];
	   var colModel    = $('#' + gid).jqGrid('getGridParam', 'colModel');
	   var colName     = $('#' + gid).jqGrid('getGridParam', 'colNames');
	   var gridData    = $('#' + gid).jqGrid('getGridParam', 'data');
	
	   var title       = p_title + "_" + fn_getDay(0).replace(/-/gi, "").replace(" ", "").replace(":", "");
	   
	   if (gridData.length == 0) {
	       MessagePopup("OK", '조회된 데이터가 없습니다.');
	       return false;
	   }
	   for (var i = 0, len = colModel.length; i < len; i++) {
	       if (colModel[i].hidden === true) {
	           continue;
	       }
	       if (colModel[i].colmenu === false) {
	           continue;
	       }
	       var rowdata = {};
	       if(colModel[i].name != 'CHK' && colModel[i].name != 'ROWNUM1') {  //엑셀파일 출력 시 NO와 CHK박스 제외
				rowdata['label']     = colName[i].replaceAll("<br/>", "\n").replaceAll("<br />", "\n");
	           rowdata['name']      = colModel[i].name;
	           rowdata['width']     = colModel[i].width;
	           rowdata['align']     = fn_isNull(colModel[i].align) ? 'left' : colModel[i].align;
	           rowdata['formatter'] = fn_isNull(colModel[i].formatter) ? '' : colModel[i].formatter;
	           
	       }
	       newcolModel.push(rowdata);
	       if (colModel[i].formatter == 'select') {
	           $('#' + gid).jqGrid('setColProp', colModel[i].name, {
	               unformat: gridUnfmt
	           });
	       }
	   }
	   var rowNumtemp    = $('#' + gid).jqGrid('getGridParam', 'rowNum');
	   var scrolltemp    = $('#' + gid).jqGrid('getGridParam', 'scroll');
	   var pgbuttonstemp = $('#' + gid).jqGrid('getGridParam', 'pgbuttons');
	   $('#' + gid).jqGrid('setGridParam', {
	       rowNum   : 1000000000
	     , scroll   : 1
	     , pgbuttons: false
	   });
	   var gridDatatemp = $('#' + gid).getRowData();
	        
	   $('#' + gid).jqGrid('setGridParam', {
	       rowNum   : rowNumtemp
	     , scroll   : scrolltemp
	     , pgbuttons: pgbuttonstemp
	   });
	   $('#' + gid).trigger('reloadGrid');
		for (var i = 0, len = colModel.length; i < len; i++) {
	       if (colModel[i].formatter == 'select') {
	           $('#' + gid).jqGrid('setColProp', colModel[i].name, {
	               unformat: null
	           });
	       }
	   }
	   var excelUrl = "/excelDownload";
	   var xhr  = new XMLHttpRequest();
	   
	   var param = JSON.stringify({'colModel': newcolModel, 'gridData': gridDatatemp, 'title': title, 'footer': p_footer});
	   
	   xhr.open("POST", excelUrl, true);
	   xhr.responseType = "blob";
	   xhr.setRequestHeader("Authorization", 'Bearer ' + localStorage.getItem("nhlvaca_token"));
	   xhr.setRequestHeader("Content-Type",  "application/json; charset=UTF-8");
	                     
	   xhr.onload = function(e){	       
		   localStorage.setItem("nhlvaca_token", getCookie('token'));    
	       var filename = title;
	       var disposition = xhr.getResponseHeader('Content-Disposition');
	       if(disposition && disposition.indexOf("attachment") !== -1){
	           var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
	           var matches       = filenameRegex.exec(disposition);
	           if(matches != null && matches[1]){
	               filename = decodeURI(matches[1].replace(/['"]/g, ''));
	           }
	           
	           if(this.status == 200){
	               var blob = this.response;
	               if(window.navigator.msSaveOrOpenBlob){
	                   window.navigator.msSaveBlob(blob, filename);
	               }else{
	                  var downloadLink = window.document.createElement('a');
	                  var contentTypeHeader = xhr.getResponseHeader("Content-Type");
	                  downloadLink.href = window.URL.createObjectURL(new Blob([blob], {type:contentTypeHeader}));
	                  downloadLink.download = filename;
	                  document.body.appendChild(downloadLink);
	                  downloadLink.click();
	                  document.body.removeChild(downloadLink);                     
	               }
	           }                 
	       }
	   };
	               
	   xhr.send(param);
	   /*20221005 jjw 리포트 로그 저장*/
	    var srchData = new Object();
	   if(typeof pageInfo == 'undefined'){
		   srchData["PGID"] 	= p_title;		   
	   }else{
		   srchData["PGID"] 	= pageInfo.pgid??p_title;
	   }		
		srchData["INQ_CN"] 		= gridData.length;
		srchData["BTN_TPC"] 		= "E";
		srchData["APVRQR_RSNCTT"] 		= input_rn; 	
	    fn_InsDownloadLog(srchData);
   };
}
 
 function fn_InsDownloadLog(param){
	parent.inputRn = '';
    param["SRCH_CND_CNTRN"] 		= JSON.stringify(setFrmToData('frm_Search')).substr(0,2000);    
	result = sendAjax(param, "/insDownloadLog", "POST");	 
 }
 
//***************************************
//* function   : fn_fileDownlad
//* paramater  : title
//* result     : N/A
//***************************************
function fn_fileDownlad(p_title){
	var excelUrl = "/fileDownload";
    var xhr  = new XMLHttpRequest();
       
    var param = JSON.stringify({'title': p_title});
       
    xhr.open("POST", excelUrl, true);
    xhr.responseType = "blob";
    xhr.setRequestHeader("Authorization", 'Bearer ' + localStorage.getItem("nhlvaca_token"));
    xhr.setRequestHeader("Content-Type",  "application/json; charset=UTF-8");
                         
    xhr.onload = function(e){
 	   localStorage.setItem("nhlvaca_token", getCookie('token'));
           
        var filename = p_title;
        var disposition = xhr.getResponseHeader('Content-Disposition');
        if(disposition && disposition.indexOf("attachment") !== -1){
            var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
            var matches       = filenameRegex.exec(disposition);
            if(matches != null && matches[1]){
                filename = decodeURI(matches[1].replace(/['"]/g, ''));
            }
             
            if(this.status == 200){
                var blob = this.response;
                if(window.navigator.msSaveOrOpenBlob){
                    window.navigator.msSaveBlob(blob, filename);
                }else{
                   var downloadLink = window.document.createElement('a');
                   var contentTypeHeader = xhr.getResponseHeader("Content-Type");
                   downloadLink.href = window.URL.createObjectURL(new Blob([blob], {type:contentTypeHeader}));
                   downloadLink.download = filename;
                   document.body.appendChild(downloadLink);
                   downloadLink.click();
                   document.body.removeChild(downloadLink);                     
                }
            }                 
        }           
    };
                   
    xhr.send(param);
}

//**************************************
//function  : fn_contrChBox(달력 초기값 셋팅) 
//paramater : p_bool(체크여부), p_param(체크박스명칭), p_param_text(체크박스텍스트여부), p_param_val(체크박스 Value), p_param_textVal(텍스트에 들어갈 내용) 
// ex) true, "checkbox", "checkboxtext(값이있으면 해당 값에 여부 체크, 빈값이면_text자동 세팅, null이면 여부표시X)", "p_param_textVal" 
// result   : N/A
//**************************************
function fn_contrChBox(p_bool, p_param, p_param_text, p_param_val, p_param_textVal) {
	if(p_bool == true) {
		$("input:checkbox[id='" + p_param + "']").prop("checked", true);
		
		if(p_param_textVal == "" || p_param_textVal == null) {
			$("#"+ p_param).val("1");
		} else {
			$("#"+ p_param).val(p_param_val);
		}
		
		if(p_param_text == "") {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param + "_text").text("여");
			} else {
				$("#"+ p_param + "_text").text(p_param_textVal);
			}
		} else if(p_param_text == null) {
		} else {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param_text).text("여");
			} else {
				$("#"+ p_param_text).text(p_param_textVal);
			}
			
		}
		
	} else if(p_bool == false) {
		$("input:checkbox[id='" + p_param + "']").prop("checked", false);

		if(p_param_textVal == "" || p_param_textVal == null) {
			$("#"+ p_param).val("0");
		} else {
			$("#"+ p_param).val(p_param_val);
		}
		
		if(p_param_text == "") {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param + "_text").text("부");
			} else {
				$("#"+ p_param + "_text").text(p_param_textVal);
			}
		} else if(p_param_text == null) {
		} else {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param_text).text("부");
			} else {
				$("#"+ p_param_text).text(p_param_textVal);
			}
		}
	}
}

//**************************************
//function  : fn_setFrmByObject(폼에 Obejct값 설정) 
//paramater : frmStr , sel_data
//ex) frmStr : 'frm_input'
//result   : N/A
//**************************************
function fn_setFrmByObject(frmStr, sel_data){         
    var frmIds = $("#" + frmStr).find('input[type=hidden], input[type=text], input[type=password], textarea, select, input[type=checkbox]');    
    var id = "";        
    var tagName = "";
    var tagType = "";
    var className = "";
    
    for(var i=0; i<frmIds.length; i++){ 
        tagName = $(frmIds[i]).prop('tagName');             
        id = $(frmIds[i]).attr('id');
        var colName = id.toUpperCase();
        className = $(frmIds[i]).attr('class');
        if(tagName == 'INPUT'){
            tagType = $(frmIds[i]).attr('type');                
            if(tagType == 'text' || tagType == 'password' || tagType == 'hidden'){
                if(String(className) != 'undefined' && className.indexOf('date') > -1){
                	if(!sel_data[colName] == ''){
                		$(frmIds[i]).val(fn_toDate(sel_data[colName]));	
                	}
                }else if(String(className) != 'undefined' && className.indexOf('number') > -1){
                    $(frmIds[i]).val(fn_toComma(sel_data[colName]));
                }else {
                    $(frmIds[i]).val(fn_xxsDecode(sel_data[colName]));
                }                                    
            }else if(tagType == 'checkbox'){                    
                //$(frmIds[i]).val(sel_data[colName]);
                if(sel_data[colName] == '1'){
                    $(frmIds[i]).prop("checked",true);
                }else{
                    $(frmIds[i]).prop("checked",false);
                }
            }                
        }else if(tagName == 'TEXTAREA'){
            $(frmIds[i]).val(fn_xxsDecode(sel_data[colName]));             
        }else if(tagName == 'SELECT'){
            $(frmIds[i]).val(sel_data[colName]);   
        }
    }
}

//**************************************
//function  : fn_contrChBox(체크박스 셋팅) 
//paramater : p_bool(체크여부:필수), p_param(체크박스명칭:필수), p_param_text(체크박스텍스트여부), p_param_val(체크박스 Value), p_param_textVal(텍스트에 들어갈 내용) 
//ex) true, "checkbox", "checkboxtext(값이있으면 해당 값에 여부 체크, 빈값이면_text자동 세팅, null이면 여부표시X)", "p_param_textVal" 
//result   : N/A
//**************************************
function fn_contrChBox(p_bool, p_param, p_param_text, p_param_val, p_param_textVal) {
	if(p_bool == true) {
		$("input:checkbox[id='" + p_param + "']").prop("checked", true);
		
		if(p_param_val == "" || p_param_val == null) {
			$("#"+ p_param).val("1");
		} else {
			$("#"+ p_param).val(p_param_val);
		}
		
		if(p_param_text == "") {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param + "_text").text("여");
			} else {
				$("#"+ p_param + "_text").text(p_param_textVal);
			}
		} else if(p_param_text == null) {
		} else {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param_text).text("여");
			} else {
				$("#"+ p_param_text).text(p_param_textVal);
			}
			
		}
		
	} else if(p_bool == false) {
		$("input:checkbox[id='" + p_param + "']").prop("checked", false);

		if(p_param_val == "" || p_param_val == null) {
			$("#"+ p_param).val("0");
		} else {
			$("#"+ p_param).val(p_param_val);
		}
		
		if(p_param_text == "") {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param + "_text").text("부");
			} else {
				$("#"+ p_param + "_text").text(p_param_textVal);
			}
		} else if(p_param_text == null) {
		} else {
			if(p_param_textVal == "" || p_param_textVal == null) {
				$("#"+ p_param_text).text("부");
			} else {
				$("#"+ p_param_text).text(p_param_textVal);
			}
		}
	}
}

function fn_xxsDecode(p_str){
    var result = "";
    if(p_str != null && typeof p_str == 'string' && p_str != ""){
    	result = p_str;
        result = result.replace(/&amp;/gi , "&");
        result = result.replace(/&#35;/gi , "#");
        result = result.replace(/&lt;/gi  , "<");
        result = result.replace(/&gt;/gi  , ">");
        result = result.replace(/&#40;/gi , "(");
        result = result.replace(/&#41;/gi , ")");
        result = result.replace(/&quot;/gi, "\"");
        result = result.replace(/&#x27;/gi, "'");      
        return result;
    }else{
    	return p_str;
    }
}

 
</script>


