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
   		fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);	
    	fn_Init();
    	
    	/******************************
         * 대상 라디오박스 이벤트
         ******************************/
        $(document).on("change", "input[name='obj_gbn_radio']", function() {
        	fn_SelObjGbn();
//         	fn_SearchMsgTemp();
        });
    	
        /******************************
         * 대상 라디오박스 이벤트
         ******************************/
        $(document).on("change", "input[name='msg_gbn_radio']", function() {
            $("#grd_Msg").jqGrid("clearGridData", true);
        });
        
        /******************************
         * 메세지 타입 라디오박스 이벤트
         ******************************/
//         $(document).on("change", "input[name='msg_type_gb']", function(e) {
//         	e.preventDefault();
//         	fn_SearchMsgTemp();
//         });
        
        /******************************
         * 알림톡전송
         ******************************/  
        $("#pb_sendMsgTalk").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_SendMsg();
        });
        
        $('#pb_talk_popup').on('click',(e)=>{
            e.preventDefault();
            var idsLen = $(".cbox:not(:first):checked").length;
            var selRowIds = $("#grd_Msg").jqGrid("getGridParam", "selrow");
			
            if (idsLen < 1) {
            	MessagePopup('OK',"항목을 선택해주세요.");
           		return;
            } else if (idsLen > 1) {
            	MessagePopup('OK',"항목을 하나만 선택해주세요.");
           		return;
            }
            
            var data = $("#grd_Msg").jqGrid("getRowData", selRowIds)?.MSG_CNTN;
//             var sHtml = data.replaceAll('\n','<br/>');
            var sHtml = data.replaceAll('\\n','<br/>');
    		MessagePopup('OK',sHtml,function(res){
    			return;
    		});
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
//          fn_setChgRadio("msg_type_gb", "01");
//          fn_setRadioChecked("msg_type_gb");
         fn_SelObjGbn();
         fn_setOptions('01');
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
    	
        //그리드 초기화
         $("#grd_Msg").jqGrid("clearGridData", true);
    	 
    	var srchData = new Object();
    	srchData["ctgrm_cd"]     = '3100';
    	srchData["tms_type"]     = '02';
    	srchData["reg_no"]		= '1';
        srchData["auc_obj_dsc"]  = $("#auc_obj_dsc").val();
        srchData["auc_dt"]       = fn_dateToData($("#auc_dt").val());
        srchData["obj_gbn"]      = $("#obj_gbn").val();
        srchData["sms_key"]      = $('input[name="msg_gbn_radio"]:checked').val().replaceAll("0","");
        srchData["msg_gbn"]      = $('input[name="msg_gbn_radio"]:checked').val();
            	 
    	var results = sendAjax(srchData, "/LALM0228_selList", "POST");        
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
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
        fn_ExcelDownlad('grd_Msg', '알림톡');

    }   
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    // 템플릿 조회
    function fn_SearchMsgTemp(){
    	const flag = $('input[name="msg_type_gb"]:checked').val();
    	
    	if(!flag){
            MessagePopup('OK','메세지 타입 종류를 선택하세요.');
            return;
    	}
    	fn_setOptions(flag);
    }
    
    function fn_setOptions(flag){
    	
    	if (!flag) {
    		return;
    	}
    	
    	if (flag == "01") {
    		// 셀렉트박스 옵션 추가
            $("select[name=talk_select]").empty();
         	
           	var sHtml = "";
           	
          	sHtml += '<option value="01">고정문구 템플릿 #1</option>';
            
            $("select[name=talk_select]").append(sHtml);
    	} else {
	    	var srchData = new Object();
	    	srchData["auc_obj_dsc"]  	= $("#auc_obj_dsc").val();
	        srchData["auc_dt"]       	= fn_dateToData($("#auc_dt").val());
	        srchData["sender_gb"]      = $("input[name=obj_gbn_radio]:checked").val() == "1" ? "01" : "02";
	        srchData["msg_gb"]      	= $("input[name=msg_gbn_radio]:checked").val();
	        srchData["msg_type_gb"]  = $('input[name="msg_type_gb"]:checked').val();
	            	 
	    	var results = sendAjax(srchData, "/LALM0227_selList", "POST");        
	        var result;
	        if(results.status != RETURN_SUCCESS){
	            showErrorMessage(results);
	            return;
	        }else{      
	            result = setDecrypt(results);
	            
	         	// 셀렉트박스 옵션 추가
	            $("select[name=talk_select]").empty();
	         	
	           	var sHtml = "";
	           	
	           	for (var item of result) {
	    	       	sHtml += '<option value="'+ item.REG_NO +'">'+ item.TALK_TITLE +'</option>';       		
	           	}
	            
	            $("select[name=talk_select]").append(sHtml);
	        }
    	}
    }
    
    //알림톡전송
    function fn_SendMsg(){
    	
    	var tmpObject = new Array();
    	
    	gridSaveRow('grd_Msg');    	
    	var ids = $('#grd_Msg').jqGrid('getDataIDs');    	
    	for(var i = 0, len = ids.length; i < len; i++) {
            var rowId =ids[i];
            if($("input:checkbox[id='jqg_grd_Msg_"+rowId+"']").is(":checked")){
                var rowdata = $("#grd_Msg").jqGrid('getRowData', rowId);
                // SMS 로그테이블(TB_LA_IS_MM_SMS) 에 필요한 파라메터
               	rowdata["TRMN_AMNNO_NO"] = rowdata["TRMN_AMNNO"]; //TRMN_AMNNO
               	rowdata["TRMN_AMNNO"] = rowdata["SMS_SEND_KEY"]; //2022082300001 => 로그 테이블에 trmn_amnno 컬럼에 저장
               	rowdata["FHS_ID_NO"] = rowdata["FHS_ID_NO"]; 
               	rowdata["FARM_AMNNO"] = rowdata["FARM_AMNNO"]; 
                rowdata["AUC_OBJ_DSC"] = $("#auc_obj_dsc").val(); //경매대상
                rowdata["DPAMN_DSC"]   = $("#obj_gbn").val(); //출하자, 응찰자 구분
                rowdata["SEL_STS_DSC"] = $('input[name="msg_gbn_radio"]:checked').val(); //SMS용 경매상태(01, 02, 03...)
                rowdata["RMS_MN_NAME"] = rowdata["REVE_USR_NM"]; // 수신자 명
                rowdata["SMS_RMS_MPNO"] = rowdata["CUS_MPNO"].replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'); // 수신자 전화번호
                rowdata["IO_TRMSNM"] = rowdata["CLNTNM"]; // 발신자 명
                rowdata["SMS_TRMS_TELNO"] = rowdata["CLNT_TELNO"].replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'); // 발신자 전화번호
                
                // 인터페이스에 필요한 파라메터
                rowdata["AUC_DT"] = rowdata["AUC_DT"]; //경매일자
                rowdata["ADJ_BRC"] = rowdata["ADJ_BRC"]; //사무소코드
                rowdata["KAKAO_TPL_C"] = rowdata["KAKAO_TPL_C"]; //템플릿코드
                rowdata["IO_DPAMN_MED_ADR"] = rowdata["CUS_MPNO"].replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'); //수신매체주소
                rowdata["IO_SDMN_MED_ADR"]   = rowdata["CLNT_TELNO"].replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1'); //송신매체주소
                rowdata["UMS_FWDG_CNTN"] = rowdata["MSG_CNTN"]; //fail-back 메시지 (LMS로 발송되는 메시지)
                
                if(!rowdata.SMS_RMS_MPNO.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1').length < 10){
                	tmpObject.push(rowdata);
                }
            }
        }
    	    	
    	var srchData = new Object();
        srchData["ctgrm_cd"]     = '5100';
        srchData["tms_type"]     = '02';
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
			                        +"<label for='msg_gbn_01' style='margin-right:10px;'>경매전(응찰자 </label>"
			                        +"<input type='radio' id='msg_gbn_02' name='msg_gbn_radio' value='02'/>"
			                        +"<label for='msg_gbn_02' style='margin-right:10px;'>경매후(낙찰평균 </label>"
			                        +"<input type='radio' id='msg_gbn_03' name='msg_gbn_radio' value='03'/>"
			                        +"<label for='msg_gbn_03' style='margin-right:10px;'>경매후(최고,최저 </label>"
			                        +"<input type='radio' id='msg_gbn_04' name='msg_gbn_radio' value='04'/>"
			                        +"<label for='msg_gbn_04' style='margin-right:10px;'>경매후(입금금액)</label>" 
			                        +"<input type='radio' id='msg_gbn_05' name='msg_gbn_radio' value='05'/>"
			                        +"<label for='msg_gbn_05' style='margin-right:10px;'>정산서1</label>" 
			                        +"<input type='radio' id='msg_gbn_06' name='msg_gbn_radio' value='06'/>"
			                        +"<label for='msg_gbn_06' style='margin-right:10px;'>정산서2</label>"); 
        	}else{
        		$("#msg_div").append("<input type='radio' id='msg_gbn_01' name='msg_gbn_radio' value='01'/>"
			                        +"<label for='msg_gbn_01' style='margin-right:10px;'>경매전(응찰자) </label>"
			                        +"<input type='radio' id='msg_gbn_02' name='msg_gbn_radio' value='02'/>"
			                        +"<label for='msg_gbn_02' style='margin-right:10px;'>경매후(낙찰평균)</label>"
			                        +"<input type='radio' id='msg_gbn_03' name='msg_gbn_radio' value='03'/>"
			                        +"<label for='msg_gbn_03' style='margin-right:10px;'>경매후(최고,최저)</label>"        		
			                        +"<input type='radio' id='msg_gbn_05' name='msg_gbn_radio' value='05'/>"
			                        +"<label for='msg_gbn_05' style='margin-right:10px;'>정산서</label>"        		
			                        +"<input type='radio' id='msg_gbn_06' name='msg_gbn_radio' value='06'/>"
			                        +"<label for='msg_gbn_06' style='margin-right:10px;'>정산서(링크버튼)</label>"
			                        );        		
        	}
        //출하자
        }else{
        	// 20230215 ymcho 문자메세지쪽에 있던 예정가 이전의 정보를 발송하는 템플릿 추가
        	$("#msg_div").append("<input type='radio' id='msg_gbn_00' name='msg_gbn_radio' value='00'/>"
			                    +"<label for='msg_gbn_00' style='margin-right:10px;'>예정가산정전(출하주)</label>"
        						+"<input type='radio' id='msg_gbn_01' name='msg_gbn_radio' value='01'/>"
			                    +"<label for='msg_gbn_01' style='margin-right:10px;'>경매전(출하주)</label>"
			                    +"<input type='radio' id='msg_gbn_02' name='msg_gbn_radio' value='02'/>"
			                    +"<label for='msg_gbn_02' style='margin-right:10px;'>경매후(낙찰가)</label>"
			                    +"<input type='radio' id='msg_gbn_03' name='msg_gbn_radio' value='03'/>"
			                    +"<label for='msg_gbn_03' style='margin-right:10px;'>정산서</label>"
			                    );
        }
    	
        fn_setChgRadio("msg_gbn", "01");
        fn_setRadioChecked("msg_gbn");
    	
    }
    
    function fn_CreateGrid(data){
    	var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["전송일자","수신자명","수신자전화번호","메세지내용","전송여부",
        							"사업장코드","전송일련번호","경매대상구분","전송번호","전송번호","전송번호","발신자전화번호","발신자명",
        	                        "최초등록일시","최초등록자개인번호","최종변경일시","최종변경자개인번호","SMS ID","송신메시지 전문","템플릿코드","정산사무소코드", "경매일자"
                                   ];        
        var searchResultColModel = [
                      {name:"SMS_FWDG_DT",    	index:"SMS_FWDG_DT",    	width:80, align:'center', formatter:'gridDateFormat'},
                      {name:"REVE_USR_NM",    	index:"REVE_USR_NM",    	width:80, align:'center'},
                      {name:"CUS_MPNO",       	index:"CUS_MPNO",       	width:80, align:'center'},
                      {name:"MSG_CNTN",       	index:"MSG_CNTN",       	width:250, align:'left', cellattr: function(){return 'style="white-space:nowrap;"';}},
                      {name:"TMS_YN",         		index:"TMS_YN",         		width:50, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:전송;0:실패;"}},
                      {name:"NA_BZPLC",       		index:"NA_BZPLC",       			hidden:true},
                      {name:"SMS_FWDG_SQNO", index:"SMS_FWDG_SQNO",		hidden:true},
                      {name:"AUC_OBJ_DSC",    	index:"AUC_OBJ_DSC",    	 	hidden:true},
                      {name:"TRMN_AMNNO",     	index:"TRMN_AMNNO",     	 	hidden:true},
                      {name:"FHS_ID_NO",     	index:"FHS_ID_NO",     	 	hidden:true},
                      {name:"FARM_AMNNO",     	index:"FARM_AMNNO",     	 	hidden:true},
                      {name:"CLNT_TELNO",   		index:"CLNT_TELNO",  			hidden:true},
                      {name:"CLNTNM",      	index:"CLNTNM",      	 	hidden:true},
                      {name:"FSRG_DTM",       	index:"FSRG_DTM",       	 	hidden:true},
                      {name:"FSRGMN_ENO",     	index:"FSRGMN_ENO",     	 	hidden:true},
                      {name:"LSCHG_DTM",      	index:"LSCHG_DTM",      	 	hidden:true},
                      {name:"LS_CMENO",       	index:"LS_CMENO",       	 	hidden:true},
                      {name:"SMS_SEND_KEY",   	index:"SMS_SEND_KEY",   	 	hidden:true},
                      {name:"SEND_MSG_CNTN",  index:"SEND_MSG_CNTN",  	hidden:true},
                      {name:"KAKAO_TPL_C",  		index:"KAKAO_TPL_C",   	 	hidden:true},
                      {name:"ADJ_BRC", 				index:"ADJ_BRC",   				hidden:true},
                      {name:"AUC_DT", 				index:"AUC_DT",   				hidden:true}
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
                    v_SMS_RMS_MPNO = $("#grd_Msg").jqGrid("getCell",v_rowids[i], "CUS_MPNO");                    
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
            
            var v_SMS_RMS_MPNO = $("#grd_Msg").jqGrid("getCell",rowid, "CUS_MPNO");
                        
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
<input type="hidden" id="clntTelno" name="clntTelno"/>
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
            <div class="fl_C"><!--  //버튼 모두 우측정렬 -->   
                <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 수신자전화번호가 10자리보다 작을시 전송되지 않습니다.</label>
            </div>  
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->    
                <button class="tb_btn" id="pb_talk_popup">미리보기</button>
                <button class="tb_btn" id="pb_sendMsgTalk">알림톡 전송</button>
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