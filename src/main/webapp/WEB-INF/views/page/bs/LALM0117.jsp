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


<script type="text/javascript">
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장 업무정산
 * 2. 파  일  명   : LALM0117
 * 3. 파일명(한글) : 휴면/이용해지 관리
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2022.10.31   박가연   최초작성
 ------------------------------------------------------------------------------*/
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     var pageInfos = setDecryptData('${pageInfo}');
     var na_bzplc = App_na_bzplc;
     var mv_cut_am       = "";
	 var mv_sqno_prc_dsc = "";
	 var cArray = new Array();	//휴면대상 해제할 사람 선택한 내용
	 var sArray = new Array();	//이용해지 신청회원 중, 해지할 사람 선택한 내용
     console.log(pageInfos);
     $(document).ready(function(){
    	$(".tab_content").hide();
        $(".tab_content:first").show();
        if(pageInfos.param != null){
	        $("input[name='flagSecAply']").val(pageInfos.param.flag_secaply);    
        }
         
        var $tabEvtT = $('.tab_box .tab_list li a');        
 		$tabEvtT.on('click',function(){
 			$tabEvtT.removeClass('on');
 			$(this).addClass('on');
 			$(".tab_content").hide();
 			var activeTab = $(this).attr("href");
 			$(activeTab).fadeIn();
 			
 			$(".tb_btn", $(".dorm_secs_btn")).hide();
 			var btnClass = "btn_" + activeTab.replace("#", "");
 			$("." + btnClass , $(".dorm_secs_btn")).show();	//tab에 따른 버튼 영역도 조정
 			
 			//검색해야 하는 영역에 대한 값도 셋팅
 			$("#srch_tab_gubun").val(activeTab.replace("#", ""));
 			
 			//이용해지신청회원 탭인 경우
 			if(activeTab.replace("#", "") == "tab3"){
 				$("#mbintg_gubun_02").attr("disabled", true);
 				$(".secession_info").show();
 			}else{
 				$("#mbintg_gubun_02").attr("disabled", false);
 				$(".secession_info").hide();
 			}
 			
 			// 휴면회원 탭인경우
 			if(activeTab.replace("#", "") == "tab2"){
 				$(".dormCncl_info").show();
 			}else{
 				$(".dormCncl_info").hide();
 			}
 			
 			//휴면대상 탭인 경우
 			if(activeTab.replace("#", "") == "tab1"){
 				$(".dorm_preUsr_comment").show();
 			}else{
 				$(".dorm_preUsr_comment").hide();
 			}
 			
 			//탭 이동 있을 때마다 그리드 초기화
 			$("#grd_MmMbDormEx").jqGrid("clearGridData", true);
 	    	$("#grd_MmMbDormcy").jqGrid("clearGridData", true);
 	    	$("#grd_MmSecession").jqGrid("clearGridData", true);
 	    	
 	    	cArray = new Array();
 	    	sArray = new Array();
 			
 			return false;
 	    });
 		
        fn_Init();
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MmMbDormEx");
        fn_setClearFromFrm("frm_Search","#grd_MmMbDormcy");
        fn_setClearFromFrm("frm_Search","#grd_MmSecession");
        
        //휴면대상 해제 버튼
        $("#pb_Psn").unbind("click").click(function(e){
        	e.preventDefault();
        	if(cArray.length <= 0){
        		MessagePopup('OK','휴면대상 해제할 회원을 선택해주세요.');
    			return;
        	}
        	else{
        		MessagePopup('YESNO',"선택한 회원을 휴면대상 해제하시겠습니까?",function(res){
        			if(res){
        				var updDataObj = new Object();
        				updDataObj["mbintglist"] = cArray;
        				
        				var result = sendAjax(updDataObj, "/LALM0117_updDormcPreClear", "POST");
        	            if(result.status == RETURN_SUCCESS){
        	            	MessagePopup("OK", "해제 하였습니다.");
        	                fn_Search("clear");
        	                cArray = new Array();
        	            } else {
        	            	showErrorMessage(result);
        	                return;
        	            }
            		} else {    			
            			MessagePopup('OK','취소되었습니다.');
            			return;
            		}
        		});
        	}
        });
        
      	//휴면회원 해제 버튼
        $("#pb_dormCncl").unbind("click").click(function(e){
        	e.preventDefault();
        	if(cArray.length <= 0){
        		MessagePopup('OK','휴면회원 해제할 회원을 선택해주세요.');
    			return;
        	}
        	else{
        		MessagePopup('YESNO',"선택한 휴면회원을 해제하시겠습니까?",function(res){
        			if(res){
        				var updDataObj = new Object();
        				updDataObj["mbintglist"] = cArray;
        				updDataObj["mbintg_gubun"] = $("input[name='mbintg_gubun']:checked").val();
        				
        				var result = sendAjax(updDataObj, "/LALM0117_updDormcUsrClear", "POST");
        	            if(result.status == RETURN_SUCCESS){
        	            	MessagePopup("OK", "해제 하였습니다.");
        	                fn_Search("clear");
        	                cArray = new Array();
        	            } else {
        	            	showErrorMessage(result);
        	                return;
        	            }
            		} else {    			
            			MessagePopup('OK','취소되었습니다.');
            			return;
            		}
        		});
        	}
        });
      	
      	//[선택삭제] 버튼 클릭 시
      	$("#pb_delete").unbind("click").click(function(e){
      		e.preventDefault();
      		
      		if(cArray.length <= 0){
        		MessagePopup('OK','삭제할 회원을 선택해주세요.');
    			return;
        	}
        	else{
        		//TO-DO: 출하주(농가) 삭제는 안 되는 것으로 막아야할지?
        		MessagePopup('YESNO',"선택한 휴면회원 계정을 삭제하시겠습니까?",function(res){
        			if(res){
        				var updDataObj = new Object();
        				updDataObj["mbintglist"] = cArray;
        				updDataObj["mbintg_gubun"] = $("input[name='mbintg_gubun']:checked").val();
        				
        				var result = sendAjax(updDataObj, "/LALM0117_delDormcSelectUser", "POST");
        	            if(result.status == RETURN_SUCCESS){
        	            	MessagePopup("OK", "삭제 하였습니다.");
        	                fn_Search("clear");
        	                cArray = new Array();
        	            } else {
        	            	showErrorMessage(result);
        	                return;
        	            }
            		} else {    			
            			MessagePopup('OK','취소되었습니다.');
            			return;
            		}
        		});
        	}
      	});
      	
      	//[이용해지 처리] 버튼 클릭 시
      	$("#pb_secession").unbind("click").click(function(e){
      		e.preventDefault();
      		if(sArray.length <= 0){
        		MessagePopup('OK','이용해지할 회원을 선택해주세요.');
    			return;
        	}
      		else{
        		MessagePopup('YESNO',"선택한 회원을 이용해지 처리하시겠습니까?",function(res){
        			if(res){
        				var updDataObj = new Object();
        				updDataObj["trmn_amnno_list"] = sArray;
        				
        				var result = sendAjax(updDataObj, "/LALM0117_delSecApplyUserData", "POST");
        	            if(result.status == RETURN_SUCCESS){
        	            	MessagePopup("OK", "이용해지 처리하였습니다.");
        	                fn_Search("clear");
        	                sArray = new Array();
        	            } else {
        	            	showErrorMessage(result);
        	                return;
        	            }
            		} else {    			
            			MessagePopup('OK','취소되었습니다.');
            			return;
            		}
        		});
        	}
        	
      	});
      	
      	//휴면대상자에게 알림톡 발송
      	$("#pb_sendSms").unbind("click").click(function(e){
      		e.preventDefault();
      		if(cArray.length <= 0){
        		MessagePopup('OK','문자 발송할 회원을 선택해주세요.');
    			return;
        	}
        	else{
        		MessagePopup('YESNO',"선택한 회원에게 문자 발송하시겠습니까?",function(res){
        			if(res){
        				var updDataObj = new Object();
        				updDataObj["mbintglist"] = cArray;
        				
        				var result = sendAjax(updDataObj, "/LALM0117_sendAlimPreDormcUser", "POST");
        	            if(result.status == RETURN_SUCCESS){
        	            	MessagePopup("OK", "전송하였습니다.");
        	                fn_Search("clear");
        	                cArray = new Array();
        	            } else {
        	            	showErrorMessage(result);
        	                return;
        	            }
            		} else {    			
            			MessagePopup('OK','취소되었습니다.');
            			return;
            		}
        		});
        	}
      	});
      
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //폼 초기화
        fn_InitFrm('frm_Search');
        
        fn_setChgRadio('mbintg_gubun','01');
        fn_setRadioChecked('mbintg_gubun');
        
      	//탭 초기화
        $(".tab_content").hide();
        $("#tab1").fadeIn('on');
        
        $("#pb_tab1").addClass('on');
		$("#pb_tab2").removeClass('on');
        $("#pb_tab3").removeClass('on');
        
        //버튼 영역 초기화
        $(".tb_btn", $(".dorm_secs_btn")).hide();
        $(".btn_tab1", $(".dorm_secs_btn")).show();
        
        $("#srch_tab_gubun").val("tab1");
		if($("input[name='flagSecAply']").val() != null && $("input[name='flagSecAply']").val() != ""){
			$("#pb_tab3").click();
		}
		
		//그리드 초기화
		$("#grd_MmMbDormEx").jqGrid("clearGridData", true);
		$("#grd_MmMbDormcy").jqGrid("clearGridData", true);
		$("#grd_MmSecession").jqGrid("clearGridData", true);
		
        fn_CreateGridMbDormPre();
        fn_CreateGridMbDormUsr();
        fn_CreateGridMbSecession();
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(clearFlag){
    	var searchUrl =  ""; 
        var tabGubun = $("#srch_tab_gubun").val();
    	$("#grd_MmMbDormEx").jqGrid("clearGridData", true);
    	$("#grd_MmMbDormcy").jqGrid("clearGridData", true);
    	$("#grd_MmSecession").jqGrid("clearGridData", true);
    	
        if(tabGubun == "tab1"){
        	searchUrl = "/LALM0117_selDormacPreList";
        }else if(tabGubun == "tab2"){
        	searchUrl = "/LALM0117_selDormacUsrList";
        }else if(tabGubun == "tab3"){
        	searchUrl = "/LALM0117_selSecessionAplyUsrList";
        }
       	var results = sendAjaxFrm("frm_Search", searchUrl, "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            if(clearFlag != "clear"){
                showErrorMessage(results);
            }
            return;      	
        }else{
            result = setDecrypt(results);
            mv_RunMode = 2;
            if(tabGubun == "tab1"){
	            fn_CreateGridMbDormPre(result);
            }else if(tabGubun == "tab2"){
            	fn_CreateGridMbDormUsr(result);
            }else if(tabGubun == "tab3"){
            	fn_CreateGridMbSecession(result);
            }
        }
    	
    }
     
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    
  	//그리드 생성
    function fn_CreateGridMbDormPre(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["코드", "이름", "생년월일/<br/>사업자번호", "연락처", "주소", "상세주소","문자발송일자", "휴면예정일자", "남은일수", "통합회원코드"];        
        var searchResultColModel = [						 
	           {name:"VIEW_CODE",	index:"VIEW_CODE",	width:100, align:'center'},                                     
	           {name:"MB_INTG_NM",   	index:"MB_INTG_NM", 		width:80, align:'center'},
	           {name:"MB_RLNO",   	index:"MB_RLNO",    	width:80, align:'center'},                                     
	           {name:"MB_MPNO",     index:"MB_MPNO",      width:100, align:'center'},
	           {name:"DONGUP",     	index:"DONGUP",      	width:100, align:'center'},
	           {name:"DONGBW",     	index:"DONGBW",      	width:100, align:'center'},
	           {name:"SMS_DATE",     	index:"SMS_DATE",      	width:100, align:'center'},
	           {name:"DORMANCY_DATE",     	index:"DORMANCY_DATE",      	width:100, align:'center'},
	           {name:"CHARGE_DATE",	index:"CHARGE_DATE",	width:100, align:'center'},
	           {name:"MB_INTG_NO",   index:"MB_INTG_NO",    width:100,  align:'center'}
        ];
        
        $("#grd_MmMbDormEx").jqGrid("GridUnload");
        
        $("#grd_MmMbDormEx").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            multiselect:true,	/*체크박스 선택 가능하게끔 하는 속성*/
            onSelectAll: function(aRowids, status){
         		var mb_intg_no;
            	var v_rowids = aRowids;
            	if(status == true){	//전체 선택했을 때
            		for(var i = 0; i < v_rowids.length; i++){
            			mb_intg_no = $("#grd_MmMbDormEx").jqGrid("getCell", v_rowids[i], "MB_INTG_NO");
            			if($.inArray(mb_intg_no, cArray) < 0){
	            			cArray.push(mb_intg_no);
            			}
            		}
            	}else{	//전체 선택 해제했을 때
            		cArray = new Array();
            	}
            },
            onSelectRow: function(rowid, status, e){
            	var sel_data = $("#grd_MmMbDormEx").getRowData(rowid);
            	if(status == true){
            		if($.inArray(sel_data.MB_INTG_NO, cArray) < 0){
		            	cArray.push(sel_data.MB_INTG_NO);
            		}
            	}else{
	            	cArray.pop(sel_data.MB_INTG_NO);
            	}
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel,
        });
        
        $("#grd_MmMbDormEx").jqGrid("setLabel", "rn","No");
    }
  	
    //grd_MmMbDormcy 그리드 생성
    function fn_CreateGridMbDormUsr(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["코드", "이름", "생년월일/<br/>사업자번호", "연락처", "주소", "상세주소","휴면계정 전환일", "최종 접속일", "통합회원코드"];         
        var searchResultColModel = [						 
	           {name:"VIEW_CODE",	index:"VIEW_CODE",	width:100, align:'center'},                                     
	           {name:"MB_INTG_NM",   	index:"MB_INTG_NM", 		width:80, align:'center'},
	           {name:"MB_RLNO",   	index:"MB_RLNO",    	width:80, align:'center'},                                     
	           {name:"MB_MPNO",     index:"MB_MPNO",      width:100, align:'center'},
	           {name:"DONGUP",     	index:"DONGUP",      	width:100, align:'center'},
	           {name:"DONGBW",     	index:"DONGBW",      	width:100, align:'center'},
	           {name:"DORMACC_DT",     	index:"DORMACC_DT",      	width:100, align:'center'},
	           {name:"FNCON_DTM",	index:"FNCON_DTM",	width:100, align:'center'},
	           {name:"MB_INTG_NO",   index:"MB_INTG_NO",    width:100,  align:'center'}
     	];
        
        $("#grd_MmMbDormcy").jqGrid("GridUnload");
        
        $("#grd_MmMbDormcy").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            multiselect:true,	/*체크박스 선택 가능하게끔 하는 속성*/
            onSelectAll: function(aRowids, status){
         		var mb_intg_no;
            	var v_rowids = aRowids;
            	if(status == true){	//전체 선택했을 때
            		for(var i = 0; i < v_rowids.length; i++){
            			mb_intg_no = $("#grd_MmMbDormcy").jqGrid("getCell", v_rowids[i], "MB_INTG_NO");
            			if($.inArray(mb_intg_no, cArray) < 0){
	            			cArray.push(mb_intg_no);
            			}
            		}
            	}else{	//전체 선택 해제했을 때
            		cArray = new Array();
            	}
            },
            onSelectRow: function(rowid, status, e){
            	var sel_data = $("#grd_MmMbDormcy").getRowData(rowid);
            	if(status == true){
            		if($.inArray(sel_data.MB_INTG_NO, cArray) < 0){
		            	cArray.push(sel_data.MB_INTG_NO);
            		}
            	}else{
	            	cArray.pop(sel_data.MB_INTG_NO);
            	}
            },
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        $("#grd_MmMbDormcy").jqGrid("setLabel", "rn","No");
        
    }
  
    //grd_MmSecession 그리드 생성
    function fn_CreateGridMbSecession(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
      
        var searchResultColNames = ["중도매인코드", "중도매인이름", "생년월일/<br/>사업자번호", "연락처","이용해지 신청일자", "이용해지 사유", "통합회원코드"];         
        var searchResultColModel = [						 
	           {name:"TRMN_AMNNO",	index:"TRMN_AMNNO",	width:80, align:'center'},                                     
	           {name:"SRA_MWMNNM",   	index:"SRA_MWMNNM", 		width:80, align:'center'},
	           {name:"CUS_RLNO",   	index:"CUS_RLNO",    	width:80, align:'center'},                                     
	           {name:"CUS_MPNO",     index:"CUS_MPNO",      width:80, align:'center'},
	           {name:"SEC_RECE_DTM",     	index:"SEC_RECE_DTM",      	width:80, align:'center'},
	           {name:"SEC_REASON",     	index:"SEC_REASON",      	width:240, align:'center'},
	           {name:"MB_INTG_NO",   index:"MB_INTG_NO",    width:80,  align:'center'}
     	];
        
        $("#grd_MmSecession").jqGrid("GridUnload");
        
        $("#grd_MmSecession").jqGrid({
            datatype:    "local",
            data:        data,
            height:      350,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:  true,
            rownumWidth: 30,
            multiselect:true,	/*체크박스 선택 가능하게끔 하는 속성*/
            onSelectAll: function(aRowids, status){
         		var trmn_amnno;
         		var mb_intg_no;
            	var v_rowids = aRowids;
            	if(status == true){	//전체 선택했을 때
            		for(var i = 0; i < v_rowids.length; i++){
            			trmn_amnno = $("#grd_MmSecession").jqGrid("getCell", v_rowids[i], "TRMN_AMNNO");
            			mb_intg_no = $("#grd_MmSecession").jqGrid("getCell", v_rowids[i], "MB_INTG_NO");
            			var obj = {trmn_amnno : trmn_amnno, mb_intg_no : mb_intg_no};
            			var dataToFind = sArray.find(function(item){return item.trmn_amnno === trmn_amnno});
                   		var idx = sArray.indexOf(dataToFind);
                   		
                   		if(idx < 0){
	            			sArray.push(obj);
                   		}
            		}
            	}else{	//전체 선택 해제했을 때
            		sArray = new Array();
            	}
            },
            onSelectRow: function(rowid, status, e){
            	var sel_data = $("#grd_MmSecession").getRowData(rowid);
       			var obj = {trmn_amnno : sel_data.TRMN_AMNNO, mb_intg_no : sel_data.MB_INTG_NO};
           		var dataToFind = sArray.find(function(item){return item.trmn_amnno === sel_data.TRMN_AMNNO});
           		var idx = sArray.indexOf(dataToFind);
           		
            	if(status == true){
            		if(idx < 0){
	            		sArray.push(obj);
            		}
            	}else{
            		if(idx > -1){
	            		sArray.splice(idx, 1);
            		}
            	}
            }, 
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        
        $("#grd_MmSecession").jqGrid("setLabel", "rn","No");
        
    }
  
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
	////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 휴면대상 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchDormacPre(p_param){
    	$("#grd_MmMbDormEx").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0117_selDormacPreList", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS) {      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridMbDormPre(result);
        }
    }
	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 휴면회원 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchDormacUsr(p_param){
    	$("#grd_MmMbDormcy").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0117_selDormacUsrList", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS) {      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridMbDormUsr(result);
        }
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 이용해지신청회원 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_SearchSecession(p_param){
    	$("#grd_MmSecession").jqGrid("clearGridData", true);
    	
    	var results = sendAjax(p_param, "/LALM0117_selSecessionAplyUsrList", "POST");        
        var result;
        
        if(results.status == RETURN_SUCCESS) {      
            result = setDecrypt(results);
            mv_RunMode = 2;
            fn_CreateGridMbSecession(result);
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
        	<input type="hidden" name="flagSecAply" value="" />		<!-- pageInfo.param.flag_secaply -->
        	
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                	<form id="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="200">
                            <col width="80">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">이름<strong class="req_dot">*</strong></th>
                                <td>
                                    <input type="text" name="mb_intg_nm" id="mb_intg_nm" class="popup" maxlength="20">
                                </td>
                                <th scope="row">구분<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox" id="rd_mbintg_gubun">
                                        <div class="cell">
                                            <input type="radio" id="mbintg_gubun_01" name="mbintg_gubun" value="01" checked="checked"
                                            	onclick="javascript:fn_setChgRadio('mbintg_gubun','01');fn_setRadioChecked('mbintg_gubun');"/>
                                            <label for="mbintg_gubun_01">중도매인</label>
                                            <input type="radio" id="mbintg_gubun_02" name="mbintg_gubun" value="02" 
                                            	onclick="javascript:fn_setChgRadio('mbintg_gubun','02');fn_setRadioChecked('mbintg_gubun');"/>
                                            <label for="mbintg_gubun_02">출하주(농가)</label>
                                        </div>
                                    </div>
                                    <input type="hidden" id="mbintg_gubun" />
                                    <input type="hidden" id="srch_tab_gubun" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
                    <div><p class="tab_box dorm dorm_preUsr_comment">※ 휴면대상 해제 시 휴면 대상자는 1년 유예 처리됩니다.</p></div>
                    <div><p class="tab_box dormCncl_info" style="display:none;">※ 휴면회원에 대한 휴면 해제 시 대상자 지정에 대한 1년 유예 처리됩니다.</p></div>
            
            <div class="tab_box clearfix line">
				<ul class="tab_list fl_L">
					<li><a href="#tab1" id="pb_tab1" class="on">휴면대상</a></li>
					<li><a href="#tab2" id="pb_tab2">휴면회원</a></li>
					<li><a href="#tab3" id="pb_tab3">중도매인 이용해지신청회원</a></li>
				</ul>
				
				<div class="fl_R dorm_secs_btn"><!--  //버튼 모두 우측정렬 -->
	                <span class="dorm_preUsr_comment">주) 휴면 대상은 30일 이내 대상자 입니다.</span>
                    <button class="tb_btn btn_tab1" id="pb_Psn">휴면대상 해제</button>
                    <!--<button class="tb_btn btn_tab1" id="pb_sendSms">문자 발송</button>-->
                    <button class="tb_btn btn_tab1" id="pb_sendSms">알림톡 발송</button>
                    <button class="tb_btn btn_tab2" id="pb_delete" style="display:none;">선택 삭제</button>
                    <button class="tb_btn btn_tab2" id="pb_dormCncl" style="display:none;">휴면 해제</button>
                    <span class="secession_info" style="display:none;">* 이용해지 처리시 모든 회원정보가 삭제됩니다.</span>
                    <button class="tb_btn btn_tab3" id="pb_secession" style="display:none;">이용해지 처리</button>
                </div>
			</div>
			<div id="tab1" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MmMbDormEx" style="width:100%;">
	                </table>
                </div>
			</div>
			<div id="tab2" class="tab_content">
				<div class="listTable rsp_v">
					<table id="grd_MmMbDormcy" style="width:100%;">
	               
	                </table>
                </div>
			</div>
			<div id="tab3" class="tab_content">
            	<div class="listTable rsp_v">
					<table id="grd_MmSecession" style="width:100%;">
					
	                </table>
            	</div>
			</div>
            
        </section>       
    </div>
</body>
</html>