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
    	
    	var setCombo = 1;
    	
    	//경주, 무진장
    	if("8808990659008" == App_na_bzplc || "8808990657202" == App_na_bzplc){
    		fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);	
    	}else{
    		fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 1, true);	
    	}   
    	
    	fn_Init();
    	
    	/******************************
         * 대상 라디오박스 이벤트
         ******************************/
        $(document).on("change", "input[name='obj_gbn_radio']", function() {
        	fn_SelObjGbn();
        });
    	
        /******************************
         * 대상 라디오박스 이벤트
         ******************************/
        $(document).on("change", "input[name='msg_gbn_radio']", function() {
            $("#grd_Msg").jqGrid("clearGridData", true);
        });
        
        /******************************
         * 문자전송
         ******************************/  
        $("#pb_sendMsg").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_SendMsg();
        });
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_Msg");
       
    });
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
    	 
    	 //그리드 초기화
         $("#grd_Msg").jqGrid("clearGridData", true);
    	 
    	 $( "#auc_dt" ).datepicker().datepicker("setDate", fn_getToday());
    	 
    	 fn_setChgRadio("obj_gbn", "1");
         fn_setRadioChecked("obj_gbn");
         fn_SelObjGbn();
         
    }
    

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
    	if($('input[name="msg_gbn_radio"]:checked').val() == undefined){
            MessagePopup('OK','메세지 종류를 선택하세요.');
            return;
    	}
    	
    	if($('#msg_plus').val().length > 40){
            MessagePopup('OK','추가문구는 40자 이하로 입력해주세요.');
            return;
    	}
    	        
    	if($('#msg_plus').val().length > 40){
            MessagePopup('OK','추가문구는 40자 이하로 입력해주세요.');
            return;
    	}
    	        
        //그리드 초기화
         $("#grd_Msg").jqGrid("clearGridData", true);
    	 
    	var srchData = new Object();
    	srchData["ctgrm_cd"]     = '3100';
    	srchData["tms_type"]     = '01';
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"]       = fn_dateToData($("#auc_dt").val());
        srchData["obj_gbn"]      = $("#obj_gbn").val();
        srchData["msg_gbn"]      = $('input[name="msg_gbn_radio"]:checked').val();
            	 
    	var results = sendAjax(srchData, "/LALM0218_selList", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        //2022.10.31 추가문구 요건 추가
       	const addMsg = $("#msg_plus").val() || '';
       	result.map(e => {
       		e.MSG_CNTN = e.MSG_CNTN + addMsg;
       	})
        fn_CreateGrid(result);
        
    }
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
        fn_ExcelDownlad('grd_Msg', '문자메세지');

    }   
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    //문자전송
    function fn_SendMsg(){
    	
    	var tmpObject = new Array();
    	
    	gridSaveRow('grd_Msg');    	
    	var ids = $('#grd_Msg').jqGrid('getDataIDs');    	
    	for(var i = 0, len = ids.length; i < len; i++) {
            var rowId =ids[i];
            if($("input:checkbox[id='jqg_grd_Msg_"+rowId+"']").is(":checked")){
                var rowdata = $("#grd_Msg").jqGrid('getRowData', rowId);
                rowdata["AUC_OBJ_DSC"] = $("#auc_obj_dsc").val();
                rowdata["DPAMN_DSC"]   = $("#obj_gbn").val();
                rowdata["SEL_STS_DSC"] = $('input[name="msg_gbn_radio"]:checked').val();
                if(!rowdata.SMS_RMS_MPNO.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1').length < 10){
                	tmpObject.push(rowdata);
                }
            }
        }
    	    	
    	var srchData = new Object();
        srchData["ctgrm_cd"]     = '3100';
        srchData["tms_type"]     = '01';
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"]       = fn_dateToData($("#auc_dt").val());
        srchData["obj_gbn"]      = $("#obj_gbn").val();
        srchData["msg_gbn"]      = $('input[name="msg_gbn_radio"]:checked').val();
        srchData["RPT_DATA"]     = tmpObject;
    	
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
        if(result.resultCnt > 0){
        	MessagePopup('OK',result.resultCnt + ' 건 전송하였습니다.');
        	fn_Search();
            return;
        }
    }
    
    //메세지 라디오 설정
    function fn_SelObjGbn(){    	
    	 $("#grd_Msg").jqGrid("clearGridData", true);
    	$("#msg_div").empty();    	
    	//응찰자
        if($("#obj_gbn").val() == '1'){        	
        	//구미칠곡        	
        	if("8808990657615" == App_na_bzplc){
        		$("#msg_div").append("<input type='radio' id='msg_gbn_01' name='msg_gbn_radio' value='01'/>"
			                        +"<label for='msg_gbn_01' style='margin-right:10px;'>경매전(응찰자)</label>"
			                        +"<input type='radio' id='msg_gbn_02' name='msg_gbn_radio' value='02'/>"
			                        +"<label for='msg_gbn_02' style='margin-right:10px;'>경매후(낙찰평균)</label>"
			                        +"<input type='radio' id='msg_gbn_03' name='msg_gbn_radio' value='03'/>"
			                        +"<label for='msg_gbn_03' style='margin-right:10px;'>경매후(최고,최저)</label>"
			                        +"<input type='radio' id='msg_gbn_04' name='msg_gbn_radio' value='04'/>"
			                        +"<label for='msg_gbn_04' style='margin-right:10px;'>경매후(입금금액)</label>"); 
        	}else{
        		$("#msg_div").append("<input type='radio' id='msg_gbn_01' name='msg_gbn_radio' value='01'/>"
			                        +"<label for='msg_gbn_01' style='margin-right:10px;'>경매전(응찰자)</label>"
			                        +"<input type='radio' id='msg_gbn_02' name='msg_gbn_radio' value='02'/>"
			                        +"<label for='msg_gbn_02' style='margin-right:10px;'>경매후(낙찰평균)</label>"
			                        +"<input type='radio' id='msg_gbn_03' name='msg_gbn_radio' value='03'/>"
			                        +"<label for='msg_gbn_03' style='margin-right:10px;'>경매후(최고,최저)</label>");        		
        	}
        //출하자
        }else{
        	$("#msg_div").append("<input type='radio' id='msg_gbn_01' name='msg_gbn_radio' value='01'/>"
			                    +"<label for='msg_gbn_01' style='margin-right:10px;'>경매전(출하주)</label>"
			                    +"<input type='radio' id='msg_gbn_02' name='msg_gbn_radio' value='02'/>"
			                    +"<label for='msg_gbn_02' style='margin-right:10px;'>경매후(낙찰가)</label>");
        }
    	
        fn_setChgRadio("msg_gbn", "01");
        fn_setRadioChecked("msg_gbn");
    	
    }
    
    function fn_CreateGrid(data){
    	
    	var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["사업장코드","전송일자","일련번호",
        	                        "경매대상구분","번호","수신자명","수신자명","수신자전화번호","수신자전화번호","발신자명","발신자전화번호","메세지내용",
        	                        "전송여부","최초등록일시","최초등록자개인번호","최종변경일시","최종변경자개인번호",
                                   ];        
        var searchResultColModel = [
                      {name:"NA_BZPLC",       index:"NA_BZPLC",       width:60, align:'center', hidden:true},
                      {name:"SMS_FWDG_DT",    index:"SMS_FWDG_DT",    width:80, align:'center', formatter:'gridDateFormat'},
                      {name:"SMS_FWDG_SQNO",  index:"SMS_FWDG_SQNO",  width:30, align:'center', hidden:true},
                      {name:"AUC_OBJ_DSC",    index:"AUC_OBJ_DSC",    width:30, align:'center', hidden:true},
                      {name:"TRMN_AMNNO",     index:"TRMN_AMNNO",     width:80, align:'center', hidden:true},
                      {name:"USRNM",          index:"USRNM",          width:30, align:'center', hidden:true},
                      {name:"RMS_MN_NAME",    index:"RMS_MN_NAME",    width:80, align:'center'},
                      {name:"CUS_MPNO",       index:"CUS_MPNO",       width:30, align:'center', hidden:true},
                      {name:"SMS_RMS_MPNO",   index:"SMS_RMS_MPNO",   width:80, align:'center'},
                      {name:"IO_TRMSNM",      index:"IO_TRMSNM",      width:60, align:'center', hidden:true},
                      {name:"SMS_TRMS_TELNO", index:"SMS_TRMS_TELNO", width:60, align:'center', hidden:true},
                      {name:"MSG_CNTN",       index:"MSG_CNTN",       width:250, align:'left'},
                      {name:"TMS_YN",         index:"TMS_YN",         width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:전송;0:실패;"}},
                      {name:"FSRG_DTM",       index:"FSRG_DTM",       width:60, align:'center', hidden:true},
                      {name:"FSRGMN_ENO",     index:"FSRGMN_ENO",     width:60, align:'center', hidden:true},
                      {name:"LSCHG_DTM",      index:"LSCHG_DTM",      width:30, align:'center', hidden:true},
                      {name:"LS_CMENO",       index:"LS_CMENO",       width:30, align:'center', hidden:true},
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
        multiselect:true,
        colNames: searchResultColNames,
        colModel: searchResultColModel,
        onSelectAll:function(aRowids,status){
        	var v_rowids = aRowids;
        	if(status == true){
        		var v_SMS_RMS_MPNO;        		
        		var cArray = new Array();
        		for(var i = 0; i < v_rowids.length; i++){
                    v_SMS_RMS_MPNO = $("#grd_Msg").jqGrid("getCell",v_rowids[i], "SMS_RMS_MPNO");                    
                    if(v_SMS_RMS_MPNO.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1').length < 10){                    	
                    	cArray.push(v_rowids[i]);
                    }
        		}
        		
        		if(cArray.length > 0){
                    for(var j = 0; j < cArray.length; j++){
                    	$("#grd_Msg").jqGrid("setSelection",cArray[j],false);
                    }	
        		}
        	}
        },
        beforeSelectRow:function(rowid,e){
            var $myGrid = $(this);
            var i= $.jgrid.getCellIndex($(e.target).closest('td')[0]);
            var cm = $myGrid.jqGrid('getGridParam','colModel');            
            
            var v_SMS_RMS_MPNO = $("#grd_Msg").jqGrid("getCell",rowid, "SMS_RMS_MPNO");
                        
            if(v_SMS_RMS_MPNO.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1').length < 10){
                if(cm[i].name == 'cb'){
                	MessagePopup('OK','수신자전화번호가 10자리 이하입니다.');
                	$("#grd_Msg").jqGrid("setSelection",rowid,false);	
                }
            	return (cm[i].name == 'cb');
            	
            }else{
            	return (cm[i].name == 'cb');
            }
        }
        });
        
        //행번호
        $("#grd_Msg").jqGrid("setLabel", "rn","No");  
    	
    }
    
</script>
<body>
 <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">조회조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경매대상<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="auc_obj_dsc" class="popup"></select>
                                </td>
                                <th scope="row">경매일자<strong class="req_dot">*</strong></th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="popup date" id="auc_dt"></div>
                                    </div>
                                </td>
                                <th>대상</th>
                                <td>
                                    <div class="cellBox" id="rd_obj_gbn">
                                        <div class="cell">
                                            <input type="radio" id="obj_gbn_1" name="obj_gbn_radio" value="1" 
                                            onclick="javascript:fn_setChgRadio('obj_gbn','1');"/>
                                            <label for="obj_gbn_1">응찰자</label>
                                            <input type="radio" id="obj_gbn_2" name="obj_gbn_radio" value="2" 
                                            onclick="javascript:fn_setChgRadio('obj_gbn','2');"/>
                                            <label for="obj_gbn_2">출하자</label>
                                        </div>
                                    </div>
                                    <input type="hidden" id="obj_gbn"/>
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <th>메세지</th>
                                <td colspan="4"> 
                                    <div class="cellBox" id="rd_msg_gbn">
                                        <div class="cell" id="msg_div">
                                        </div>
                                    </div>
                                    <input type="hidden" id="msg_gbn"/>
                                </td>
                                <th>추가문구</th>
                                <td colspan="4"> 
                                    <input type="text" id="msg_plus" style="width:70%;" maxlength="40"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            <div class="fl_C" style="width: 65%;left:60%;"><!--  //버튼 모두 우측정렬 -->   
                <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 체크한 수신자 전화번호가 10자리보다 작을시 전송되지 않습니다. 발송 메시지가 80자 초과시 2회로 나뉘어 전송됩니다.</label>
            </div>  
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->    
                <button class="tb_btn" id="pb_sendMsg">문자 전송</button>
            </div>  
            </div>
            <div class="listTable mb0">
                <table id="grd_Msg">
                </table>
            </div>
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>