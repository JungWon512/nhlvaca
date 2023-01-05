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
//     	fn_SelOptions();
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
        	
   			fn_DisableFrm('frm_Talk', false);
        	
        	setRowStatus = setRowStatus == "U" ? "U" : "I";

        	if (setRowStatus == "U") {
         		$("input[name=code]").attr('disabled', true);
//                 $("select[name=na_bzplc]").attr('disabled', true);
        	}
        	
   			
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
         fn_DisableFrm('frm_Talk', true);
         
         // 초기화
     	$('input[name=code]').val('');
     	$('input[name=search_code]').val('');
// 		$('select[name=na_bzplc]').val('0000000000000');
// 		$('select[name=search_na_bzplc]').val('0000000000000');
		$('input[name=talk_title]').val('');
		$('#talk_content').val('');
		
		setRowStatus = "";

//     	 fn_Search();
    }
    

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
        //그리드 초기화
         $("#grd_Msg").jqGrid("clearGridData", true);
    	 
    	var srchData = new Object();
    	srchData["search_code"] = $('input[name=search_code]').val();
//     	srchData["na_bzplc"] = $('select[name=search_na_bzplc]').val();
            	 
    	var results = sendAjax(srchData, "/LALM0840_selList", "POST");
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
        	frmData["code"] = $('input[name=code]').val();
//         	frmData["na_bzplc"] = $('select[name=na_bzplc]').val();
         }
    	        
    	MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
			if(res){									
				var result = sendAjax(frmData, "/LALM0840_delMsgTalk", "POST");            
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
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
  	function fn_Save(){
    	if($('input[name=code]').val() == ''){
            MessagePopup('OK','템플릿 코드를 입력해주세요.');
            return;
    	}
    	
    	if($('input[name=talk_title]').val() == ''){
            MessagePopup('OK','제목을 입력해주세요.');
            return;
    	}
    	
    	if($('#talk_content').val() == '' || $('#talk_content').val() == undefined){
            MessagePopup('OK','내용을 입력해주세요.');
            return;
    	}

    	var frmData = {};
   		frmData["code"] = $('input[name=code]').val();
//    		frmData["na_bzplc"] = $('select[name=na_bzplc]').val();
   		frmData["talk_title"] = $('input[name=talk_title]').val();
   		frmData["talk_content"] = $('#talk_content').val();
    	
  		var results = setRowStatus != "U" ? sendAjax(frmData, "/LALM0840_insMsgTalk", "POST") : sendAjax(frmData, "/LALM0840_updMsgTalk", "POST"); 
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
        	MessagePopup("OK", setRowStatus != "U" ? "등록하였습니다." : "수정하였습니다.");
        	
        	//초기화
   			$('input[name=code]').val('');
	     	$('input[name=search_code]').val('');
// 			$('select[name=na_bzplc]').val('0000000000000');
// 			$('select[name=search_na_bzplc]').val('0000000000000');
			$('input[name=talk_title]').val('');
			$('#talk_content').val('');
        	
	        fn_Search();
        }
  	}
    
	////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    function fn_CreateGrid(data){
    	
    	var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = [
        							"템플릿코드","사업장코드","등록순번","제목","내용","등록일자","등록자"
                                   ];        
        var searchResultColModel = [
                      {name:"CODE",       				index:"CODE",       			width:60, 	align:'center'},
                      {name:"NA_BZPLC",       			index:"NA_BZPLC",       		width:60, 	align:'center', hidden:true},
//                       {name:"CLNTNM",       			index:"CLNTNM",       		width:60, 	align:'center'},
                      {name:"REG_NO",       			index:"REG_NO",       		width:60, 	align:'center', hidden:true},
                      {name:"TALK_TITLE",    			index:"TALK_TITLE",    		width:60, 	align:'center'},
                      {name:"TALK_CONTENT",  		index:"TALK_CONTENT",  	width:100, 	align:'left', cellattr: function(){return 'style="white-space:nowrap;"';}},
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
                fn_setMsgInfo(sel_data);
            }
        });
        
        //행번호
        $("#grd_Msg").jqGrid("setLabel", "rn","No");  
    	
    }
	
 	//전체 조합 리스트 가져오기 -> 사용하지 않음
    function fn_SelOptions(){    	
    	var results = sendAjaxFrm("frm_Search", "/LALM0838_selNaList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
            
            var sel = $('#search_na_bzplc');
       		sel.append("<option value='0000000000000'>공통</option>")
            result.forEach((o)=>{
           	 	sel.append("<option value='"+o.NA_BZPLC+"'>"+o.NA_BZPLNM+"</option>")
            });
       		
            var sel2 = $('#na_bzplc');
       		sel2.append("<option value='0000000000000'>공통</option>")
            result.forEach((o)=>{
           	 	sel2.append("<option value='"+o.NA_BZPLC+"'>"+o.NA_BZPLNM+"</option>")
            });
       		
        }
    }
  	//메시지 폼 추가
    function fn_addForm(flag){
  		var alarmText = $("textarea[id=talk_content]").val();
  		var tempText = '';
  		
  		switch(flag){
  			case 'chk_1' :
  				tempText = '\#{고객명}';
  				break;
  			case 'chk_2' :
  				tempText = '\#{조합명}';
  				break;
  			case 'chk_3' :
  				tempText = '\#{경매일}';
  				break;
  			case 'chk_4' :
  				tempText = '\#{경매대상}';
  				break;
  			case 'chk_5' :
  				tempText = '\#{경매번호}';
  				break;
  			case 'chk_6' :
  				tempText = '\#{출하주}';
  				break;
  			case 'chk_7' :
  				tempText = '\#{성별}';
  				break;
  			case 'chk_8' :
  				tempText = '\#{중량}';
  				break;
  			case 'chk_9' :
  				tempText = '\#{예정가}';
  				break;
  			case 'chk_10' :
  				tempText = '\#{낙찰가}';
  				break;
  			case 'chk_11' :
  				tempText = '\#{최저낙찰가}';
  				break;
  			case 'chk_12' :
  				tempText = '\#{최고낙찰가}';
  				break;
  			case 'chk_13' :
  				tempText = '\#{경매안내문구}';
  				break;
  			case 'chk_14' :
  				tempText = '\#{출장우현황정보}';
  				break;
  			case 'chk_15' :
  				tempText = '\#{인증번호}';
  				break;
  			case 'chk_16' :
  				tempText = '\#{조합전화번호}';
  				break;
  			case 'chk_17' :
  				tempText = '\#{전환예정일자}';
  				break;
  			case 'chk_18' :
  				tempText = '\#{파기예정일자}';
  				break;
  		}
  		var result = alarmText.substring(0, cursorIndex) + tempText + alarmText.substring(cursorIndex);
  		cursorIndex = (alarmText.substring(0, cursorIndex) + tempText).length;
  		$("textarea[id=talk_content]").val(result);
  		$("textarea[id=talk_content]").focus();
    }
    
  	// 그리드 상세
	function fn_setMsgInfo(sel_data){
    	var frmData = {
    		code: sel_data.CODE
    	}
    	
    	var results = sendAjax(frmData, "/LALM0840_selInfo", "POST");
    	
    	var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results, "NOTFOUND");
            return;
        }else{
        	result = setDecrypt(results);
        }
        
        fn_setFrmByObject("frm_Talk", result);
    }
	////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
</script>
<body>
 <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
        	<div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색조건</p></li>
                </ul> 
            </div>
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search" autocomplete="off">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
<%--                             <col width="100"> --%>
<%--                             <col width="*"> --%>
                        </colgroup>
                        <tbody>
                            <tr>
			                   <th>템플릿 코드</th>
			                   <td>
			                       <input type="text" id="search_code" name="search_code" maxlength="15" />
			                   </td>
<!-- 			                   <th>조합</th> -->
<!-- 			                   <td>  -->
<!-- 			                       <select name="search_na_bzplc" id="search_na_bzplc" class="search_na_bzplc"> -->
<!-- 			                       </select> -->
<!-- 			                   </td> -->
			               </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
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
                            <col width="10%">
                            <col width="90%">
<%--                             <col width="10%"> --%>
<%--                             <col width="40%"> --%>
                        </colgroup>
                        <tbody>
                        	<tr>
                                <th>템플릿 코드<strong class="req_dot">*</strong></th>
                                <td>
                                    <input type="text" id="code" name="code" value="${data.CODE}"/>
                                </td>
<!--                                 <th>조합<strong class="req_dot">*</strong></th> -->
<!--                                 <td>  -->
<!--                                     <select name="na_bzplc" id="na_bzplc" class="na_bzplc"> -->
<!--                                     </select> -->
<!--                                 </td> -->
                            </tr>
                            <tr>
                                <th scope="row">제목<strong class="req_dot">*</strong></th>
                                <td colspan="2">
                                    <input type="text" id="talk_title" name="talk_title" value="${data.TALK_TITLE}"/>
                                </td>
                            </tr>
                            <tr>
                                <th>내용<strong class="req_dot">*</strong></th>
                                <td colspan="2"> 
                                    <div class="cellBox" id="rd_msg">
                                        <textarea id="talk_content" name="talk_content" rows="5" maxlength="1000">${data.TALK_CONTENT}</textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                            	<th>메시지 항목</th>
                           		<td colspan="6">
                                	<button type="button" class="tb_btn alarm_chk" id="chk_1">고객명</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_2">조합명</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_3">경매일</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_4">경매대상</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_5">경매번호</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_6">출하주</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_7">성별</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_8">중량</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_9">예정가</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_10">낙찰가</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_11">최저낙찰가</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_12">최고낙찰가</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_13">경매안내문구</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_14">출장우현황정보</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_15">인증번호</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_16">조합전화번호</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_17">전환예정일자</button>
                                	<button type="button" class="tb_btn alarm_chk" id="chk_18">파기예정일자</button>
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