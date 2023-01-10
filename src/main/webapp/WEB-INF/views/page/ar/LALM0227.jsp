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
	// 내용의 위치
	var cursorIndex = 0;
	var regNo = 0;
	var setRowStatus = ""; 

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
    	fn_SelObjGbn();
    	fn_Init();
    	
        /******************************
         * 메시지 항목 버튼 이벤트
         ******************************/   
         $(document).on("click", ".alarm_chk", function(e) {
        	e.preventDefault();
        	fn_addForm($(this).attr("id"));
         });
    	/******************************
         * 내용 포커스아웃 이벤트
         ******************************/
        $(document).on("focusout", "textarea", function(e) {
        	e.preventDefault();
        	cursorIndex = this.selectionStart;
        });
        /******************************
         * 입력 초기화 이벤트
         ******************************/
        $(document).on("click", "#reset", function(e) {
        	e.preventDefault();
        	
        	fn_setChgRadio("sender_gb", "01");
	        fn_setRadioChecked("sender_gb");
	        fn_setChgRadio("msg_gb", "01");
	        fn_setRadioChecked("msg_gb");
	        
   			$('input[name=talk_title]').val('');
   			$('#talk_content').val('');
   			
   			setRowStatus = ""; 
   			regNo = 0;
        });
    });
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
    	 //그리드 초기화
         $("#grd_Msg").jqGrid("clearGridData", true);
//     	 fn_Search();
    }
    

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	if($('input[name="sender_gb"]:checked').val() == undefined){
            MessagePopup('OK','대상자 종류를 선택하세요.');
            return;
    	}
    	
    	if($('input[name="msg_gb"]:checked').val() == undefined){
            MessagePopup('OK','발송구분 종류를 선택하세요.');
            return;
    	}
    	        
        //그리드 초기화
         $("#grd_Msg").jqGrid("clearGridData", true);
    	 
    	var srchData = new Object();
            	 
    	var results = sendAjax(srchData, "/LALM0227_selList", "POST");
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
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Delete(){
    	 
    	 if(setRowStatus != "U") {
         	MessagePopup("OK", "삭제할 대상을 선택하세요.");
             return;
         } else {
	    	var frmData = {};
        	frmData["reg_no"] = regNo
         }
    	        
    	MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
			if(res){									
				var result = sendAjax(frmData, "/LALM0227_delMsgTalk", "POST");            
	            if(result.status == RETURN_SUCCESS){
	            	MessagePopup("OK", "삭제되었습니다.");
	            	mv_RunMode = 3;
	            	fn_Init();
	                fn_Search();
	            } else {
	            	showErrorMessage(result);
	                return;
	            }
    		}else{    			
    			MessagePopup('OK','취소되었습니다.');
    			fn_InitFrm('frm_MhAucStn');
    			return;
    		}
		}); 
    }
    //메세지 라디오 설정
    function fn_SelObjGbn(){    	
        fn_setChgRadio("sender_gb", "01");
        fn_setRadioChecked("sender_gb");
        
        fn_setChgRadio("msg_gb", "01");
        fn_setRadioChecked("msg_gb");
    	
    }
  	//메시지 폼 추가
    function fn_addForm(flag){
  		var alarmText = $("textarea[id=talk_content]").val();
  		var tempText = '';
  		
  		switch(flag){
  			case 'chk_1' :
  				tempText = '\#{조합명}';
  				break;
  			case 'chk_2' :
  				tempText = '\#{경매일}';
  				break;
  			case 'chk_3' :
  				tempText = '\#{경매대상}';
  				break;
  			case 'chk_4' :
  				tempText = '\#{경매번호}';
  				break;
  			case 'chk_5' :
  				tempText = '\#{출하주}';
  				break;
  			case 'chk_6' :
  				tempText = '\#{성별}';
  				break;
  			case 'chk_7' :
  				tempText = '\#{중량}';
  				break;
  			case 'chk_8' :
  				tempText = '\#{예정가}';
  				break;
  			case 'chk_9' :
  				tempText = '\#{낙찰가}';
  				break;
  			case 'chk_10' :
  				tempText = '\#{최저낙찰가}';
  				break;
  			case 'chk_11' :
  				tempText = '\#{최고낙찰가}';
  				break;
  		}
  		var result = alarmText.substring(0, cursorIndex) + tempText + alarmText.substring(cursorIndex);
  		cursorIndex = (alarmText.substring(0, cursorIndex) + tempText).length;
  		$("textarea[id=talk_content]").val(result);
  		$("textarea[id=talk_content]").focus();
    }
  	
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
  	function fn_Save(){
  		if($('input[name="sender_gb"]:checked').val() == undefined){
            MessagePopup('OK','대상자 종류를 선택하세요.');
            return;
    	}
    	
    	if($('input[name="msg_gb"]:checked').val() == undefined){
            MessagePopup('OK','발송구분 종류를 선택하세요.');
            return;
    	}
    	
    	if($('input[name=talk_title]').val() == ''){
            MessagePopup('OK','제목을 입력해주세요.');
            return;
    	}
    	
    	if($('#talk_content').val() == undefined){
            MessagePopup('OK','내용을 입력해주세요.');
            return;
    	}

    	var frmData = {
   			sender_gb: $('input[name=sender_gb]:checked').val(),
   			msg_gb: $('input[name=msg_gb]:checked').val(),
   			talk_title: $('input[name=talk_title]').val(),
   			talk_content: $('#talk_content').val()
    	}
    	
    	if (setRowStatus == "U") {
    		frmData["reg_no"] = regNo
    	} 
    	
  		var results = setRowStatus != "U" ? sendAjax(frmData, "/LALM0227_insMsgTalk", "POST") : sendAjax(frmData, "/LALM0227_updMsgTalk", "POST"); 
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
        	MessagePopup("OK", setRowStatus != "U" ? "등록하였습니다." : "수정하였습니다.");
        	
        	//초기화
        	fn_setChgRadio("sender_gb", "01");
	        fn_setRadioChecked("sender_gb");
	        fn_setChgRadio("msg_gb", "01");
	        fn_setRadioChecked("msg_gb");
	        
   			$('input[name=talk_title]').val('');
   			$('#talk_content').val('');
        	
	        fn_Search();
        }
  	}
  	
    function fn_CreateGrid(data){
    	
    	var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = [
        							"사업장코드","등록순번","대상자","발송구분","제목","내용","등록일자","등록자"
                                   ];        
        var searchResultColModel = [
                      {name:"NA_BZPLC",       			index:"NA_BZPLC",       		width:60, 	align:'center', hidden:true},
                      {name:"REG_NO",       			index:"REG_NO",       		width:60, 	align:'center', hidden:true},
                      {name:"SENDER_GB_STR",    	index:"SENDER_GB_STR",   width:60, 	align:'center'},
                      {name:"MSG_GB_STR",    		index:"MSG_GB_STR",    	width:60, 	align:'center'},
                      {name:"TALK_TITLE",    			index:"TALK_TITLE",    		width:60, 	align:'center'},
                      {name:"TALK_CONTENT",  		index:"TALK_CONTENT",  	width:100, 	align:'left'},
                      {name:"FSRG_DTM",    			index:"FSRG_DTM",    		width:50, 	align:'center'},
                      {name:"FSRGMN_ENO",     		index:"FSRGMN_ENO",    	width:50, 	align:'center'}
                     ];
        
        $("#grd_Msg").jqGrid("GridUnload");
        
        $("#grd_Msg").jqGrid({
	        datatype:    "local",
	        data:        data,
	        height:      500,
	        rowNum:      rowNoValue,
	        cellEdit:    false,
	        resizeing:   true,
	        autowidth:   false,
	        shrinkToFit: false, 
	        rownumbers:true,
	        rownumWidth:30,
// 	        multiselect:true,
	        colNames: searchResultColNames,
	        colModel: searchResultColModel,
// 	        onSelectAll:function(aRowids,status){
// 	        	var v_rowids = aRowids;
// 	        	if(status == true){
// 	        		if(cArray.length > 0){
// 	                    for(var j = 0; j < cArray.length; j++){
// 	                    	$("#grd_Msg").jqGrid("setSelection",cArray[j],false);
// 	                    }	
// 	        		}
// 	        	}
// 	        },
	        onSelectRow: function(rowid, status, e){
                var sel_data = $("#grd_Msg").getRowData(rowid);
                setRowStatus = "U";
                regNo = sel_data.REG_NO;
                fn_setMsgInfo(sel_data);
            }
        });
        
        //행번호
        $("#grd_Msg").jqGrid("setLabel", "rn","No");  
    	
    }
    
	function fn_setMsgInfo(sel_data){
    	if(App_na_bzplc == sel_data.NA_BZPLC){
            $("#btn_Save").attr('disabled', false);
            $("#btn_Delete").attr('disabled', false);
    	}else{
            $("#btn_Save").attr('disabled', true);
            $("#btn_Delete").attr('disabled', true);
    	}
    	
    	var frmData = {
    		reg_no: sel_data.REG_NO
    	}

    	var results = sendAjax(frmData, "/LALM0227_selInfo", "POST");
    	
    	var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results, "NOTFOUND");
            return;
        }else{
        	result = setDecrypt(results);
        }
        
        fn_setChgRadio("sender_gb", result.SENDER_GB);
        fn_setRadioChecked("sender_gb");
        fn_setChgRadio("msg_gb", result.MSG_GB);
        fn_setRadioChecked("msg_gb");
        
        fn_setFrmByObject("frm_Talk", result);
    }
    
</script>
<body>
 <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">알림톡 내용</p></li>
                </ul>
	            <div class="fl_R"><!--  //버튼 모두 우측정렬 -->    
	                <button class="tb_btn" id="reset">입력 초기화</button>
	            </div>  
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Talk" name="frm_Talk" class="enterAllow">
                    <table>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                        	<tr>
                                <th>대상자</th>
                                <td colspan="4"> 
                                    <div class="cellBox" id="sender_gb">
                                        <div class="cell" id="sender_gb_div">
                                        	<input type="radio" id="sender_gb_01" name="sender_gb" value="01"><label for="sender_gb_01">응찰자</label>
                                        	<input type="radio" id="sender_gb_02" name="sender_gb" value="02"><label for="sender_gb_02">출하자</label>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        	<tr>
                                <th>발송구분</th>
                                <td colspan="4"> 
                                    <div class="cellBox" id="msg_gb">
                                        <div class="cell" id="msg_gb_div">
                                        	<input type="radio" id="msg_gb_01" name="msg_gb" value="01"><label for="msg_gb_01">경매전(응찰자)</label>
                                        	<input type="radio" id="msg_gb_02" name="msg_gb" value="02"><label for="msg_gb_02">경매후(낙찰평균)</label>
                                        	<input type="radio" id="msg_gb_03" name="msg_gb" value="03"><label for="msg_gb_03">경매후(최고,최저)</label>
                                        	<c:if test="${App_na_bzplc == '8808990657615'}">
                                        		<input type="radio" id="msg_gb_04" name="msg_gb_radio" value="04"><label for="msg_gb_04">경매후(입금금액)</label>
                                        	</c:if>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">제목<strong class="req_dot">*</strong></th>
                                <td>
                                    <input type="text" id="talk_title" name="talk_title" value="${data.TALK_TITLE}"/>
                                </td>
                            </tr>
                            <tr>
                                <th>내용<strong class="req_dot">*</strong></th>
                                <td colspan="4"> 
                                    <div class="cellBox" id="rd_msg">
                                        <textarea id="talk_content" name="talk_content" rows="5" maxlength="1000">${data.TALK_CONTENT}</textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                            	<th>메시지 항목</th>
                           		<td>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_1">조합명</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_2">경매일</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_3">경매대상</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_4">경매번호</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_5">출하주</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_6">성별</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_7">중량</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_8">예정가</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_9">낙찰가</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_10">최저낙찰가</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_11">최고낙찰가</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <div class="fl_R"><!--  //버튼 모두 우측정렬 -->   
                <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">\#{ } 안의 문구를 변경시 알림톡이 제대로 반영되지 않을 수 있습니다.</label>
            </div>  
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul> 
            </div>
            <div class="listTable mb0">
                <table id="grd_Msg">
                </table>
            </div>
        </section>
    </div>
<!-- /wrapper -->
</body>
</html>