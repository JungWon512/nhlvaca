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
var isFrmOrgData = null;

    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    
    $(document).ready(function() {
    	
    	fn_CreateGrd_MmFhs();
    	    	
        $("#farm_id_no").bind("keyup", function(e){
            if(e.key == '.' || e.key == '-' || e.key >= 0 && e.key <= 9){
            	return true;
            }
        	return false;
        });
    	
        $("#btn_FrmInit").on('click', function(e){
        	e.preventDefault();
            this.blur();
        	fn_FrmInit();
        });
            
        $("#sh_ftsnm").on("keydown", function(e){         
            if(e.keyCode == 13) {
                if(fn_isNull($("#sh_ftsnm").val())){
                    MessagePopup('OK','농가 명을 입력하세요.');
                    return;
                }else {
                	fn_Search();
                }
            } 
        });     
        
        $("#birth").datepicker();
        
        fn_Init();
    });   
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
    	 
    	if(isFrmOrgData != null && fn_IsChangeFrm()){
    		MessagePopup('YESNO',"입력중인 내용이 있습니다. 초기화 하시겠습니까?",function(res){                           
                if(res){
                	fn_Reset();
                }                            
            });
    	}else{
    		fn_Reset();
    	}
    	
    	$("#sh_ftsnm").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){    
    	fn_InitFrm('frm_Farm');
         
        $("#sra_fhs_id_no").attr('disabled', true);
        $("#farm_amnno").attr('disabled', true); 
        isFrmOrgData = null;
            	 
        var results = sendAjaxFrm("frm_Search", "/LALM0111_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            fn_CreateGrd_MmFhs();
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        fn_CreateGrd_MmFhs(result);
        
    }    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	 
        //필수항목체크
        /*
    	if($("#sra_fhs_id_no").val() == ''){
           MessagePopup('OK','농가식별번호를 입력하세요.');
           return;
        }
    	if($("#farm_amnno").val() == ''){
            MessagePopup('OK','농장관리번호를 입력하세요.');
            return;
        }
    	if($("#farm_id_no").val() == ''){
            MessagePopup('OK','농장식별번호를 입력하세요.');
            return;
        }
    	*/
    	if($("#ftsnm").val() == ''){
            MessagePopup('OK','농가 명을 입력하세요.');
            return;
    	}
    	
    	var fhs_results;
    	var fhs_result;
    	    	
    	//수정
    	//if($("#sra_fhs_id_no").is(":disabled")){
    	if($("#sra_fhs_id_no").val() != ''){
    		MessagePopup('YESNO',"수정하시겠습니까?",function(res){                           
                if(res){
                    fhs_results = sendAjaxFrm("frm_Farm", "/LALM0111_updFarm", "POST");        
                    
                    if(fhs_results.status != RETURN_SUCCESS){
                        showErrorMessage(fhs_results);
                        return;
                    }else{ 
                    	
                    	//한우종합
                        if($("#anw_yn").val() == '9'){
                        /* 축경 전자경매 농가채번 issue: 농가번호가 T이후로 숫자만 입력이 되어야하는데 TYJ,T영축,영축으로 등록되는 데이터로인하여 문제*/
                            //3800 전송
                            //개체이력 농가 조회
                            var srchData           = new Object(); 
                            srchData["ctgrm_cd"]   = "3800";
                            srchData["fhs_id_no"]  = $("#sra_fhs_id_no").val();
                            srchData["farm_amnno"] = $("#farm_amnno").val();
                            srchData["ftsnm"]      = $("#ftsnm").val();
                            
                            
                            fhs_results = sendAjax(srchData, "/LALM0111_updFhsAnw", "POST");    
                            if(fhs_results.status != RETURN_SUCCESS){
                                //showErrorMessage(fhs_results,'NOTFOUND');
                            }else{      
                                fhs_result = setDecrypt(fhs_results);
                            }
                            
                        }
                    	
                    	MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                            fn_Search();
                        });
                    }
                }                            
            });   
    	//신규	
    	}else{
    		//개체이력 농가 조회
            var srchData           = new Object(); 
            srchData["ctgrm_cd"]   = "4100";
            srchData["in_sqno"]    = 1;
            srchData["in_rec_cn"]  = "1";
            srchData["farm_amnno"] = $("#farm_amnno").val();
            srchData["fhs_id_no"]  = $("#farm_id_no").val();
            srchData["sra_fhsnm"]  = $("#ftsnm").val();

            var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
            var result;
            
            if(results.status != RETURN_SUCCESS){
                showErrorMessage(results,'NOTFOUND');
            }else{      
                result = setDecrypt(results);
            }
            
            if(result != null){
            	$("#sra_fhs_id_no").val(result[0].FHS_ID_NO);
            }
            
            MessagePopup('YESNO',"저장하시겠습니까?",function(res){                           
                if(res){
                	fhs_results = sendAjaxFrm("frm_Farm", "/LALM0111_insFarm", "POST");        
                    
                    if(fhs_results.status != RETURN_SUCCESS){
                        showErrorMessage(fhs_results);
                        return;
                    }else{      
                    	fhs_result = setDecrypt(fhs_results);
                        //3800 전송
                        //개체이력 농가 조회
                        var srchData           = new Object(); 
                        srchData["ctgrm_cd"]   = "3800";
                        srchData["fhs_id_no"]  = fhs_result.sraFhsIdNo;
                        srchData["farm_amnno"] = fhs_result.farmAmnno;
                        srchData["ftsnm"]      = fhs_result.ftsnm;
                        
                        
                        fhs_results = sendAjax(srchData, "/LALM0111_updFhsAnw", "POST");    
                        if(fhs_results.status != RETURN_SUCCESS){
                            //showErrorMessage(fhs_results,'NOTFOUND');
                        }else{      
                            fhs_result = setDecrypt(fhs_results);
                        }
                    	MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                            fn_Search();
                        });
                    }
                }                            
            });   
    	}
     }    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     function fn_Delete(){  
    	 
         MessagePopup('YESNO',"삭제하시겠습니까?",function(res){                           
             if(res){
            	 
            	 var results = sendAjaxFrm("frm_Farm", "/LALM0111_delFhs", "POST");        
                 var result;
                 
                 if(results.status != RETURN_SUCCESS){
                     showErrorMessage(results);
                     return;
                 }else{      
                     MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                         fn_Search();
                     });
                 }
             }                            
         });
     }
     /*------------------------------------------------------------------------------
      * 1. 함 수 명    : 출력 함수
      * 2. 입 력 변 수 : N/A
      * 3. 출 력 변 수 : N/A
      ------------------------------------------------------------------------------*/
     function fn_Print(){
     	var TitleData = new Object();
     	TitleData.title = "농가 관리";
     	TitleData.sub_title = "";
     	TitleData.unit="";
     	TitleData.srch_condition=  '[농가명 : ' + $('#ftsnm').val()  + ']';
     	
     	ReportPopup('LALM0111R',TitleData, 'grd_MmFhs', 'V');
     		
     	}
     
     ////////////////////////////////////////////////////////////////////////////////
     //  공통버튼 클릭함수 종료
     ////////////////////////////////////////////////////////////////////////////////
     /*------------------------------------------------------------------------------
      * 1. 함 수 명    : 엑셀 함수
      * 2. 입 력 변 수 : N/A
      * 3. 출 력 변 수 : N/A
      ------------------------------------------------------------------------------*/
     function fn_Excel(){
         fn_ExcelDownlad('grd_MmFhs', '농가관리');

     }   
     
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
        
    //그리드 생성
    function fn_CreateGrd_MmFhs(data){            
            
            var rowNoValue = 0;     
            if(data != null){
                rowNoValue = data.length;
                if(rowNoValue > 500){
                	rowNoValue = 500;
                	$("#pager").show();
                }else{
                	$("#pager").hide();
                }
            }
            
            var searchResultColNames = ["경제통합사업장코드", "농가식별번호", "농가식별번호_sra", "농장관리번호","경제통합거래처코드"
            	                      , "농가명", "조합원여부", "관내외구분", "우편번호", "동이상주소"
            	                      , "동이하주소", "전화번호", "휴대전화번호", "계좌번호", "생년월일"
            	                      , "비고내용", "농장식별번호", "한우종합여부", "사료사용여부", "삭제여부"
            	                      ,
            	                      ];        
            var searchResultColModel = [
                                         {name:"NA_BZPLC",         index:"NA_BZPLC",         width:60, align:'center', hidden:true},
                                         {name:"FHS_ID_NO",        index:"FHS_ID_NO",        width:60, align:'center'},
                                         {name:"SRA_FHS_ID_NO",    index:"SRA_FHS_ID_NO",    width:60, align:'center', hidden:true},
                                         {name:"FARM_AMNNO",       index:"FARM_AMNNO",       width:60, align:'center', hidden:true},
                                         {name:"NA_TRPL_C",        index:"NA_TRPL_C",        width:60, align:'center', hidden:true},
                                         {name:"FTSNM",            index:"FTSNM",            width:60, align:'center'},
                                         {name:"MACO_YN",          index:"MACO_YN",          width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                         {name:"JRDWO_DSC",        index:"JRDWO_DSC",        width:60, align:'center', edittype:"select", formatter : "select", editoptions:{value:"1:관내;2:관외;"}},
                                         {name:"ZIP",              index:"ZIP",              width:60, align:'center', formatter:'gridPostFormat'},
                                         {name:"DONGUP",           index:"DONGUP",           width:120, align:'left'},
                                         {name:"DONGBW",           index:"DONGBW",           width:100, align:'left'},
                                         {name:"OHSE_TELNO",       index:"OHSE_TELNO",       width:60, align:'center'},
                                         {name:"CUS_MPNO",         index:"CUS_MPNO",         width:60, align:'center'},
                                         {name:"SRA_FARM_ACNO",    index:"SRA_FARM_ACNO",    width:80, align:'left'},
                                         {name:"BIRTH",            index:"BIRTH",            width:60, align:'center', formatter:'gridDateFormat'},
                                         {name:"RMK_CNTN",         index:"RMK_CNTN",         width:120,  align:'left'},
                                         {name:"FARM_ID_NO",       index:"FARM_ID_NO",       width:100, align:'center', hidden:true},
                                         {name:"ANW_YN",           index:"ANW_YN",           width:100, align:'center', hidden:true},
                                         {name:"SRA_FED_SPY_YN",   index:"SRA_FED_SPY_YN",   width:50,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                         {name:"DEL_YN",           index:"DEL_YN",           width:40,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                        ];
                
            $("#grd_MmFhs").jqGrid("GridUnload");
                    
            $("#grd_MmFhs").jqGrid({
                datatype:    "local",
                data:        data,
                height:      350,
                resizeing:   true,
                autowidth:   true,
                shrinkToFit: false, 
                rownumbers:  true,
                rownumWidth: 30,
                pager :     "#pager",
                rowNum:      rowNoValue,
                colNames: searchResultColNames,
                colModel: searchResultColModel,
                onSelectRow: function(rowid, status, e){
                	
                	var sel_data = $("#grd_MmFhs").getRowData(rowid);
                	
                	if(isFrmOrgData != null && fn_IsChangeFrm()){
                		MessagePopup('YESNO',"변경중이 내용이 있습니다. 선택하시겠습니까?",function(res){                			
                            if(res){
                            	fn_SetFrm_Farm(sel_data);             
                            }                            
                        });
                	}else{
                		fn_SetFrm_Farm(sel_data);
                	}    
                },
            });
            
            //행번호
            $("#grd_MmFhs").jqGrid("setLabel", "rn","No");  

            //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
//             $("#grd_MmFhs .jqgfirstrow td:last-child").width($("#grd_MmFhs .jqgfirstrow td:last-child").width() - 17);
    }
    
    
    
    //폼 오리진 데이터 생성
    function fn_orgFormValue(){
    	isFrmOrgData = $("#frm_Farm").serialize();
    }
    
    //폼 변경 체크
    function fn_IsChangeFrm(){
    	var isFrmData = $("#frm_Farm").serialize();
    	if(isFrmOrgData != isFrmData){
    		return true;
    	}
    	return false;
    }
    
    //체크박스 html 변경
    function fn_ChkSpa(){
    	if($("#sra_fed_spy_yn").is(":checked") == false){
    		$("#sra_fed_spy_yn_nm").html(" 부");
    	}else{
    		$("#sra_fed_spy_yn_nm").html(" 여");
    	}
    }
    
    function fn_Reset(){
        //그리드 초기화
        $("#grd_MmFhs").jqGrid("clearGridData", true);
        $("#pager").hide();
        
        //폼 초기화
        fn_InitFrm('frm_Search');
        fn_InitFrm('frm_Farm');
        
        $("#anw_yn").attr('disabled', true);
        
        $("#sra_fhs_id_no").attr('disabled', true);
        $("#farm_amnno").attr('disabled', true); 
        isFrmOrgData = null;
        
        $("#btn_Save").attr('disabled', true);
        $("#btn_Delete").attr('disabled', true);
        
    }
    
    function fn_FrmInit(){
    	
    	if(isFrmOrgData != null && fn_IsChangeFrm()){
            MessagePopup('YESNO',"초기화하시겠습니까?",function(res){                         
                if(res){
                	fn_InsFrmSet();
                }                            
            });
        }else{
        	fn_InsFrmSet();
        }    	
    }
    
    function fn_InsFrmSet(){
        
        $("#brc").val(parent.wmcList[0].BRC);
        
        if($("#brc").val() == ""){
            MessagePopup('OK','기준정보의 공판장정보관리에서 사무소코드가 없습니다.<br>사무소코드를 입력하기 바랍니다.');
            return;
        }
        
        fn_InitFrm('frm_Farm');
        isFrmOrgData = null;
        
        $("#anw_yn").attr('disabled', true);
        
        //$("#sra_fhs_id_no").attr('disabled', false);
        $("#farm_amnno").attr('disabled', false); 
        
        $("#btn_Save").attr('disabled', false);
        $("#btn_Delete").attr('disabled', true);
                
        $("#maco_yn").val('0');
        $("#jrdwo_dsc").val('1');
        $("#farm_id_no").val('0');
        $("#farm_amnno").val('1');
        $("#anw_yn").val('9');
        
        $("#ftsnm").focus();
        
    }
    
    function fn_SetFrm_Farm(sel_data){
    	
    	fn_InitFrm('frm_Farm');
    	
    	var srhData = new Object();
    	srhData["sra_fhs_id_no"] = sel_data.SRA_FHS_ID_NO;
    	srhData["farm_amnno"] = sel_data.FARM_AMNNO;
    	
    	var results = sendAjax(srhData, "/LALM0111_selDetail", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }
    	    	
    	fn_setFrmByObject("frm_Farm", result);
    	
    	$("#anw_yn").attr('disabled', true);
    	
        $("#sra_fhs_id_no").attr('disabled', true);
        $("#farm_amnno").attr('disabled', true);
        
        $("#btn_Save").attr('disabled', false);
        $("#btn_Delete").attr('disabled', false);

        fn_ChkSpa();
        
        fn_orgFormValue();
    }
    
    
  
</script>
</head>

<body>
    <div class="contents">
    <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색조건</p></li>
                </ul>
            </div>
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search">
                    <table>
                        <colgroup>
                            <col width="80">
                            <col width="200">
                            <col width="90">
                            <col width="50">
                            <col width="80">    
                            <col width="100"> 
                            <col width="*"> 
                                                                                                                                 
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">농가명</th>
                                <td>
                                    <input type="text" id="sh_ftsnm"/>
                                </td>
                                <th scope="row">수기등록농가</th>
                                <td>
                                    <input type="checkbox" id="broker"/>
                                </td>
                                <th scope="row">삭제여부</th>
                                <td>
                                    <select id="del_yn">
                                        <option value="">전체</option>
	                                   	<option value="0">부</option>
	                                   	<option value="1">여</option> 
	                                </select>                                   
                                </td>
                                <td></td>                         
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <!-- 관리농가정보 -->
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">관리농가정보</p></li>
                </ul>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 --> 
                    <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 한우종합에 등록되지 않은 농가정보를 등록합니다(한우종합은 별도로 등록하셔야합니다.)</label>
                    <label id="msg_Sbid" style="font-size:15px;color: red;font: message-box;">※ 본 화면 수정 후 한우종합 수정 시 한우종합 기준으로 반영 됨.(농가정산시 계좌번호에 특히 주의 요망)</label>
                    <button class="tb_btn" id="btn_FrmInit">입력초기화</button>
                </div> 
                
            </div>
            <!-- 관리농가정보 폼 -->
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_Farm">                    
                    <input type="hidden" id="brc"/>
                    <table>
                        <colgroup>
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">농가식별번호</th>
                                <th scope="row">농장관리번호</th>
                                <th scope="row">농장식별번호</th>
                                <th scope="row">조합원여부</th>
                                <th scope="row">농가명</th>
                                <th scope="row">관내외내부</th>
                                <th scope="row">자택전화번호</th>
                                <th scope="row">핸드폰번호</th>
                                <th scope="row">생년월일</th>      
                                <th scope="row">한우종합여부</th>     
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <input type="text" id="sra_fhs_id_no" name="sra_fhs_id_no" maxlength="10"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <input type="text" id="farm_amnno" name="farm_amnno"  maxlength="8"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <input type="text" id="farm_id_no" name="farm_id_no" maxlength="10" style="text-align:center;"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="maco_yn" name="maco_yn">
                                            <option value="1">조합원</option>
                                            <option value="0">비조합원</option>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <input type="text" id="ftsnm" name="ftsnm" class="popup"  maxlength="18" style="text-align:center;"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="jrdwo_dsc" name="jrdwo_dsc">
                                            <option value="1">관내</option>
                                            <option value="2">관외</option>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <input type="text" id="ohse_telno" name="ohse_telno" class="telno" maxlength="14"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <input type="text" id="cus_mpno" name="cus_mpno" class="telno" maxlength="14"/>
                                    </div>
                                </td>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class='date' id="birth" name="birth" maxlength="10"></div>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <select id="anw_yn" name="anw_yn">
                                            <option value="1">여</option>
                                            <option value="9">부</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">우편번호</th>
                                <td>
                                    <div>
                                        <input type="text" id="zip" name="zip" class="digit" maxlength="6"/>
                                    </div>
                                </td>
                                <th scope="row">동이상주소</th>
                                <td colspan="3">
                                    <div>
                                        <input type="text" id="dongup" name="dongup"/>
                                    </div>
                                </td>
                                <th scope="row">동이하주소</th>
                                <td colspan="3">
                                    <div>
                                        <input type="text" id="dongbw" name="dongbw"/>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">비고</th>
                                <td colspan="3">
                                    <div>
                                        <input type="text" id="rmk_cntn" name="rmk_cntn" maxlength="50"/>
                                    </div>
                                </td>
                                <th scope="row">계좌번호</th>
                                <td>
                                    <div>
                                        <input type="text" id="io_sra_farm_acno" name="io_sra_farm_acno" maxlength="17"/>
                                    </div>
                                </td>
                                <th scope="row">사료사용여부</th>
                                <td>
                                    <div>
                                        <input type="checkbox" id="sra_fed_spy_yn" name="sra_fed_spy_yn" onclick="fn_ChkSpa();"/><label id="sra_fed_spy_yn_nm" for="sra_fed_spy_yn"> 부</label>
                                    </div>
                                </td> 
                                <th scope="row">삭제여부</th>                                
                                <td>
                                    <div>
                                        <select id="del_yn" name="del_yn">
                                            <option value="1">여</option>
                                            <option value="0">부</option>
                                        </select>
                                    </div>                                
                                </td>                               
                           
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <!-- 검색결과 -->
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
            <div class="listTable rsp_v">
                <table id="grd_MmFhs">
                </table>
                <!-- 페이징 -->
                <div id="pager"></div>
            </div>
        </section>
        
    </div>
<!-- ./wrapper -->
</body>
</html>