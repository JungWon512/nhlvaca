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
var LALM0412_isFrmOrgData = null;

    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/    
    $(document).ready(function(){
    	
    	fn_CreateGrd_MmIndv();
    	
        fn_setCodeBox("mcow_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);
        fn_setCodeBox("rg_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);
        fn_setCodeBox("indv_sex_c", "INDV_SEX_C", 1);
        
        $("#sh_sra_indv_amnno").bind("keyup", function(e){
        	fn_InitFrm('frm_MhSogCow');
            
            $("#btn_Save").attr('disabled', true);
            $("#btn_Delete").attr('disabled', true);
            $("#sra_indv_amnno").attr('disabled', true);
            $("#anw_yn").attr('disabled', true);
            
            fn_DisableFrm('frm_MhSogCow', true);
            
            $("#sh_sra_indv_amnno").focus();
        });
        
    	/******************************
        * 농가정보 팝업
        ******************************/
        $("#ftsnm").keypress(function(e){           
            if(e.keyCode == 13){
                if(fn_isNull($("#ftsnm").val())){
                    MessagePopup('OK','농가 명을 입력하세요.');
                    return;
                }else {
                     var data = new Object();
                     data['ftsnm'] = $("#ftsnm").val();
                     fn_CallFtsnm0127Popup(data,true,function(result){
                         if(result){
                        	 //조회한 농가정보 입력
                        	 $("#sra_fhs_id_no").val(result.FHS_ID_NO);
                        	 $("#farm_amnno").val(result.FARM_AMNNO);
                        	 $("#ftsnm").val(result.FTSNM);
                        	 
                         }
                     });
                }
             }else {
                 $("#sra_mwmnnm").val('');
             }
        });
    	 
    	$("#pb_searchFhs").on('click',function(e){
             e.preventDefault();
             this.blur();
             fn_CallFtsnm0127Popup(null,false,function(result){
                 if(result){
                     //조회한 농가정보 입력
                     $("#sra_fhs_id_no").val(result.FHS_ID_NO);
                     $("#farm_amnno").val(result.FARM_AMNNO);
                     $("#ftsnm").val(result.FTSNM);
                 }
             });
        });
    	
    	/******************************
        * 입력초기화
        ******************************/
        $("#pb_Init").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_BtnInit();
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
    	 
        //그리드 초기화
        $("#grd_MmIndv").jqGrid("clearGridData", true);
        //폼초기화
        fn_InitFrm('frm_Search');
        fn_InitFrm('frm_MhSogCow');
        
        $("#btn_Save").attr('disabled', true);
        $("#btn_Delete").attr('disabled', true);
        $("#sra_indv_amnno").attr('disabled', true);
        $("#anw_yn").attr('disabled', true);
        
        fn_DisableFrm('frm_MhSogCow', true);
        
        $("#sh_sra_indv_amnno").focus();
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
    	if($("#sh_sra_indv_amnno").val().length < 4){
    		MessagePopup('OK','귀표번호를 4자리 이상 입력하세요.');
    		return;
    	}
    	
    	if($("#sh_sra_indv_amnno").val().length == 4){
    		$("#sh_condition").val("4");
    	}else if($("#sh_sra_indv_amnno").val().length == 9){
    		$("#sh_condition").val("9");
    	}else if($("#sh_sra_indv_amnno").val().length < 9 && $("#sh_sra_indv_amnno").val().length > 4){
            $("#sh_condition").val("5");
        }
    	 
        //그리드 초기화
        $("#grd_MmIndv").jqGrid("clearGridData", true);
        
        fn_DisableFrm('frm_MhSogCow', false);        
        $("#sra_indv_amnno").attr('disabled', true);
        $("#sra_fhs_id_no").attr('disabled', true);
        $("#farm_amnno").attr('disabled', true);

        $("#sra_srs_dsc").attr('disabled', true);
        $("#anw_yn").attr('disabled', true);
    	 
    	//개체조회
        var results = sendAjaxFrm("frm_Search", "/LALM0114_selList", "POST");
    	var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
             return;
        }else{     
        	result = setDecrypt(results);
        }
        
        $("#sh_condition").val("");
        fn_CreateGrd_MmIndv(result);
             
    }    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	 
    	 if($("#sra_indv_amnno").val().length != 15){
    		 MessagePopup('OK','귀표번호는 410포함 15자를 입력하셔야합니다.');
    		 return;
    	 }
    	 if($("#sra_indv_amnno").val().substr(0,3) != '410'){
             MessagePopup('OK','귀표번호 시작은 410으로 시작합니다 귀표번호를 다시 확인하시기 바랍니다.');
             return;
    	 }
    	 if($("#sra_fhs_id_no").val() == ''){
    		 MessagePopup('OK','농가식별번호는 필수 입력사항입니다.');
             return;
    	 }
    	 if($("#farm_amnno").val() == ''){
             MessagePopup('OK','농가관리번호는 필수 입력사항입니다.');
             return;
         }
    	 
    	 //신규
         if(!$("#sra_indv_amnno").is(":disabled")){
        	 MessagePopup('YESNO',"신규등록하시겠습니까?",function(res){
                 if(res){
                     var results = sendAjaxFrm("frm_MhSogCow", "/LALM0114_insIndv", "POST"); 
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{          
                         MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                             fn_Search();
                         });
                     }      
                 }else{
                     MessagePopup('OK','취소되었습니다.');
                 }
             });
         //수정
         }else{
        	 MessagePopup('YESNO',"수정하시겠습니까?",function(res){
                 if(res){
                     var results = sendAjaxFrm("frm_MhSogCow", "/LALM0114_updIndv", "POST"); 
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{          
                         MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                             fn_Search();
                         });
                     }      
                 }else{
                     MessagePopup('OK','취소되었습니다.');
                 }
             });
         }
     }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 출력 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Print(){
    	var TitleData = new Object();
    	TitleData.title = "개체 관리";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[귀표번호 : ' + $('#sh_sra_indv_amnno').val()  + ' / 농가명 : '+ $('#sh_ftsnm').val() +']';
    	
    	ReportPopup('LALM0114R',TitleData, 'grd_MmIndv', 'V');
    		
    	}
    
     /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
     function fn_Delete(){  
    	 
    	 if($("#anw_yn").val() != "9"){
    		 MessagePopup('OK','한우종합에 등록된 개체는 삭제가 불가능합니다.');
    		 return;
    	 }
    	 
    	 MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
             if(res){
                 var results = sendAjaxFrm("frm_MhSogCow", "/LALM0114_delIndv", "POST"); 
                 if(results.status != RETURN_SUCCESS){
                     showErrorMessage(results);
                     return;
                 }else{          
                     MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                         fn_Search();
                     });
                 }      
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });
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
         fn_ExcelDownlad('grd_MmIndv', '개체관리');

     }   
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    function fn_CreateGrd_MmIndv(data){
    	var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = [
                                    "경제통합사업장코드","귀표번호","축산축종구분코드","농가식별번호","농가식별"
                                   ,"농장관리번호","농가명","생년월일","어미구분","KPN번호"
                                   ,"성별","어미귀표번호","어미산차","계대","개체식별번호"
                                   ,"등록번호","신규여부","등록구분",
                                  
                                  ];        
        var searchResultColModel = [                                                              
                                     {name:"NA_BZPLC",              index:"NA_BZPLC",              width:40, align:'center', hidden:true},
                                     {name:"SRA_INDV_AMNNO",        index:"SRA_INDV_AMNNO",        width:40, align:'center', formatter:'gridIndvFormat'},
                                     {name:"SRA_SRS_DSC",           index:"SRA_SRS_DSC",           width:40, align:'center', hidden:true},
                                     {name:"FHS_ID_NO",             index:"FHS_ID_NO",             width:40, align:'center'},
                                     {name:"SRA_FHS_ID_NO",         index:"SRA_FHS_ID_NO",         width:40, align:'center', hidden:true},
                                     {name:"FARM_AMNNO",            index:"FARM_AMNNO",            width:40, align:'center', hidden:true},
                                     {name:"FTSNM",                 index:"FTSNM",                 width:40, align:'center'},
                                     {name:"BIRTH",                 index:"BIRTH",                 width:40, align:'center', formatter:'gridDateFormat'},
                                     {name:"MCOW_DSC",              index:"MCOW_DSC",              width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     {name:"KPN_NO",                index:"KPN_NO",                width:40, align:'center'},
                                     {name:"INDV_SEX_C",            index:"INDV_SEX_C",            width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
                                     {name:"MCOW_SRA_INDV_AMNNO",   index:"MCOW_SRA_INDV_AMNNO",   width:40, align:'center', formatter:'gridIndvFormat'},
                                     {name:"MATIME",                index:"MATIME",                width:40, align:'right'},
                                     {name:"SRA_INDV_PASG_QCN",     index:"SRA_INDV_PASG_QCN",     width:40, align:'right'},
                                     {name:"INDV_ID_NO",            index:"INDV_ID_NO",            width:40, align:'right'},
                                     {name:"SRA_INDV_BRDSRA_RG_NO", index:"SRA_INDV_BRDSRA_RG_NO", width:40, align:'center'},
                                     {name:"ANW_YN",                index:"ANW_YN",                width:40, align:'center', hidden:true},
                                     {name:"RG_DSC",                index:"RG_DSC",                width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("SRA_INDV_BRDSRA_RG_DSC", 1)}},
                                     ];
             
        $("#grd_MmIndv").jqGrid("GridUnload");
                
        $("#grd_MmIndv").jqGrid({
            datatype:    "local",
            data:        data,
            height:      400,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            onSelectRow: function(rowid, status, e){
                var sel_data = $("#grd_MmIndv").getRowData(rowid);
                fn_setFrm_Mmlndv(sel_data);
            },  
        });    
    
        //행번호
        $("#grd_MmIndv").jqGrid("setLabel", "rn","No");

        //가로스크롤 있는경우 추가(마지막 컬럼 길이 조절)
        //$("#grd_MmIndv .jqgfirstrow td:last-child").width($("#grd_MmIndv .jqgfirstrow td:last-child").width() - 17);     
    }
    
    function fn_setFrm_Mmlndv(sel_data){
    	
        fn_InitFrm('frm_MhSogCow');
    	
    	if(App_na_bzplc == sel_data.NA_BZPLC){
            $("#btn_Save").attr('disabled', false);
            $("#btn_Delete").attr('disabled', false);
            $("#sra_indv_amnno").attr('disabled', true);
    	}else{
            $("#btn_Save").attr('disabled', true);
            $("#btn_Delete").attr('disabled', true);
            $("#sra_indv_amnno").attr('disabled', false);
    	}
    	$("#sra_srs_dsc").attr('disabled', true);
    	$("#anw_yn").attr('disabled', true);
    	
        var srchData = new Object();
        srchData["sra_indv_amnno"] = sel_data.SRA_INDV_AMNNO;
    	
    	var results = sendAjax(srchData, "/LALM0114_selIndvDetail", "POST"); 
    	var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results, "NOTFOUND");
            return;
        }else{
        	result = setDecrypt(results);
        }
                
        fn_setFrmByObject("frm_MhSogCow", result);
    	
    }
    
    function fn_BtnInit(){
    	
    	var pgid = 'LALM0224P';
        var menu_id = $("#menu_info").attr("menu_id");
        
        var call_result;
        
        parent.layerPopupPage(pgid, menu_id, null, null, 800, 600,function(result){
        	
        	$("#sra_indv_amnno").val(result.SRA_INDV_AMNNO);
        	$("#birth").val(result.SRA_INDV_BIRTH);
        	$("#mcow_dsc").val(result.SRA_INDV_MCOW_BRDSRA_RG_DSC);
        	
        	$("#sra_fhs_id_no").val(result.FHS_ID_NO);
        	$("#farm_amnno").val(result.FARM_AMNNO);
        	$("#ftsnm").val(result.SRA_FHSNM);
        	
        	$("#indv_sex_c").val(result.INDV_SEX_C);
        	$("#mcow_sra_indv_amnno").val(result.MCOW_SRA_INDV_EART_NO);        	
        	$("#matime").val(result.SRA_INDV_LS_MATIME);        	
        	$("#indv_id_no").val(result.SRA_INDV_ID_NO);
        	$("#rg_dsc").val(result.SRA_INDV_BRDSRA_RG_NO);        	
        	$("#sra_indv_pasg_qcn").val(result.SRA_INDV_PASG_QCN);
        	$("#kpn_no").val(result.SRA_KPN_NO);        	
        	$("#rg_dsc").val(result.SRA_INDV_BRDSRA_RG_DSC);
        	
        });
        
    	
        fn_DisableFrm('frm_MhSogCow', false);
        fn_InitFrm('frm_MhSogCow');

        $("#sra_fhs_id_no").attr('disabled', true);
        $("#farm_amnno").attr('disabled', true);
        $("#sra_srs_dsc").attr('disabled', true);
        $("#anw_yn").attr('disabled', true);
        
        $("#sra_indv_amnno").focus();

        $("#btn_Save").attr('disabled', false);
        $("#btn_Delete").attr('disabled', true);
    }
    
</script>
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
                    <input type="hidden" id="sh_condition"/>
                    <table>
                        <colgroup>
                            <col width="150">
                            <col width="250">
                            <col width="*">
                            <col width="150">
                            <col width="250">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">귀표번호<strong class="req_dot">*</strong></th>
                                <td>
                                    <input type="text" id="sh_sra_indv_amnno" class="popup" maxlength="9">
                                </td>
                                <td></td>
                                <th scope="row">농가명</th>
                                <td>
                                    <input type="text" id="sh_ftsnm">                                        
                                </td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <!-- 개체정보 -->
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">개체정보</p></li>
                </ul>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->
                    <button class="tb_btn" id="pb_Init">입력초기화</button>
                </div>
            </div>
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_MhSogCow">
                        <input type="hidden" id="io_all_yn"/>
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
                                <col width="10%">
                            </colgroup>
                            <tbody>
                               <tr>
                                   <th>귀표번호</th>
                                   <td>
                                       <input class="popup" type="text" id="sra_indv_amnno" maxlength="15"/>
                                   </td>
                                   <th>생년월일</th>
                                   <td>
                                       <div class="cellBox">
	                                       <div class="cell"><input type="text" class="date popup" id="birth" name="birth" maxlength="10"></div>
	                                   </div>
                                   </td>
                                   <th>어미구분</th>
                                   <td>
                                        <select id="mcow_dsc">
                                        </select>
                                   </td>
                                   <th>농가정보</th>
                                   <td colspan="3">
                                       <div class="cellBox v_addr">
	                                       <div class="cell" style="width:55px;">
	                                           <input type="text" id="sra_fhs_id_no"/>
	                                       </div>
                                           <div class="cell pl2" style="width:20px; text-align:center;">
                                               -
                                           </div>
	                                       <div class="cell pl2" style="width:40px;">
	                                           <input type="text" id="farm_amnno"/>
	                                       </div>
	                                       <div class="cell pl2" style="width:60px;">
	                                           <input type="text" id="ftsnm"/>
	                                       </div>
	                                       <div class="cell pl2" style="width:26px;">
	                                             <button id="pb_searchFhs" class="tb_btn white srch"><i class="fa fa-search"></i></button>
	                                         </div>
	                                   </div>
                                   </td>
                               </tr>
                               <tr>
                                   <th>성별</th>
                                   <td>
                                       <select id="indv_sex_c"></select>
                                   </td>
                                   <th>어미귀표번호</th>
                                   <td>
                                       <input type="text" id="mcow_sra_indv_amnno"/>
                                   </td>
                                   <th>산차</th>
                                   <td>
                                       <input type="text" id="matime"/>
                                   </td>
                                   <th>개체식별번호</th>
                                   <td>
                                       <input type="text" id="indv_id_no"/>
                                   </td>
                                   <th>등록번호</th>
                                   <td>
                                       <input type="text" id="sra_indv_brdsra_rg_no"/>
                                   </td>
                               </tr>
                               <tr>
                                   <th>계대</th>
                                   <td>
                                       <input type="text" id="sra_indv_pasg_qcn"/>
                                   </td>
                                   <th>KPN번호</th>
                                   <td>
                                       <input type="text" id="kpn_no"/>
                                   </td>
                                   <th>등록구분</th>
                                   <td>
                                       <select id="rg_dsc"></select>
                                   </td>
                                   <th>축종구분</th>
                                   <td>
                                       <select id="sra_srs_dsc">
                                           <option value="01">소</option>
                                       </select>
                                   </td>
                                   <th>한우종합여부</th>
                                   <td>
                                       <select id="anw_yn" disabled>
                                           <option value="9">부</option>
                                           <option value="1">여</option>
                                           <option value="0">부</option>
                                       </select>
                                   </td>
                               </tr>
                            </tbody>
                        </table>
                    </form>
                </div>
            </div> 
            <!-- 검색결과 -->
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
            <div class="listTable rsp_v">
                <table id="grd_MmIndv">
                </table>
                <!-- 페이징 -->
                <div id="pager"></div>
            </div>
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>