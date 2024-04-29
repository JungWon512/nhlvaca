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
<body>
    <div class="pop_warp">
        <div class="tab_box btn_area clearfix">
            <ul class="tab_list fl_L">
                <li><p class="dot_allow" >검색조건</p></li>
            </ul>
            <%@ include file="/WEB-INF/common/popupBtn.jsp" %>
        </div>
        <div class="sec_table">
            <div class="blueTable rsp_v">
                <form id="frm_Search" name="frm_Search">
                <table width="100%">
                    <colgroup>
                        <col width="85">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><span class="tb_dot">귀표번호</span></th>
                            <td><input type="text" id="sra_indv_amnno" maxlength="15"></td>    
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
        </div>
        
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">관리농가정보</p></li>
            </ul>
        </div>
        <div class="sec_table">
            <div class="grayTable rsp_v">
                <form id="frm_MhSogCow" name="frm_MhSogCow">
                <table width="100%">
                    <tbody>
                        <tr>
                            <th scope="row" colspan=3><span>농가명(목장명)</span></th>
                            <th scope="row" colspan=1><span>성별</span></th>    
                            <th scope="row" colspan=2><span>목장전화번호</span></th>
                            <th scope="row" colspan=2><span>핸드폰번호</span></th>
                            <th scope="row" colspan=2><span>계좌번호</span></th>
                        </tr>
                        <tr>
                        	<td colspan=2>
                           		<input type="text" disabled="disabled" id="sra_fhsnm">
                           		<input type="hidden" id="hdn_sra_fhsnm">
                           		<input type="hidden" id="sra_fhs_birth">
                           	</td>
                           	<td>
                           		<button class="tb_btn" id="pb_IndvHst" value="개체이력조회">농가변경</button>
                           	</td>
                           	<td>
                           		<input type="text" disabled="disabled" id="sex">
                           	</td>
                           	<td colspan=2>
                           		<input type="text" disabled="disabled" id="telno">
                           	</td>
                           	<td colspan=2>
                           		<input type="text" disabled="disabled" id="mpno">
                           	</td>
                           	<td colspan=2>
                           		<input type="text" disabled="disabled" id="acno">
                           	</td>
                        </tr>
                        <tr>
                        	<th scope="row" colspan=2><span>목장주소</span></th>
                        	<td colspan=4>
                           		<input type="text" disabled="disabled" id="addr">
                           	</td>
                           	<th scope="row" colspan=2><span>관리사무소</span></th>
                        	<td colspan=2>
                           		<input type="text" disabled="disabled" id="brc">
                           	</td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
        </div>
        
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">개체정보</p></li>
            </ul>
        </div>
        <div class="sec_table">
            <div class="grayTable rsp_v">
                <form id="frm_MhSogCow1" name="frm_MhSogCow1">
                <table width="100%">
                    <tbody>
                        <tr>
                        	<th scope="row"><span>귀표번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_eart_no">
                           	</td>
                           	<th scope="row"><span>품종</span></th>
                        	<td>
                           		<select disabled="disabled"  id="sra_indv_kn_c"></select>
                           	</td>
                           	<th scope="row"><span>개체관리번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_id_no">
                           	</td>
                           	<th scope="row"><span>등록번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_brdsra_rg_no">
                           	</td>
                           	<th scope="row"><span>귀표부착일자</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_earstk_dt">
                           	</td>
                        </tr>
                        
                        <tr>
                        	<th scope="row"><span>입식일자</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_byng_dt">
                           	</td>
                           	<th scope="row"><span>개체구분</span></th>
                        	<td>
                           		<select disabled="disabled"  id="sra_indv_dsc"></select>
                           	</td>
                           	<th scope="row"><span>성별</span></th>
                        	<td>
                           		<select disabled="disabled"  id="indv_sex_c"></select>
                           	</td>
                           	<th scope="row"><span>생년월일</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_birth">
                           	</td>
                           	<th scope="row"><span>등록구분</span></th>
                        	<td>
                           		<select disabled="disabled"  id="sra_indv_brdsra_rg_dsc"></select>
                           	</td>
                        </tr>
                        
                        <tr>
                        	<th scope="row"><span>KPN번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_kpn_no">
                           	</td>
                           	<th scope="row"><span>생시체중</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_lftm_wgh">
                           	</td>
                           	<th scope="row"><span>혈통등록시체중</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_pdg_rg_wgh">
                           	</td>
                           	<th scope="row"><span>개체상태</span></th>
                        	<td>
                           		<select disabled="disabled"  id="sra_indv_stsc"></select>
                           	</td>
                           	<th scope="row"><span>계대</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_pasg_qcn">
                           	</td>
                        </tr>
                        
                        <tr>
                        	<th scope="row"><span>어미귀표번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="mcow_sra_indv_eart_no">
                           	</td>
                           	<th scope="row"><span>어미등록번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_mcow_brdsra_rg_no">
                           	</td>
                        	<th scope="row"><span>외조부 KPN 번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="mtgrfa_sra_kpn_no">
                           	</td>
                           	<th scope="row"><span>외조부 개체번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="mtgrfa_sra_indv_eart_no">
                           	</td>
                           	<th scope="row"><span>외조모 개체번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="mtgrmo_sra_indv_eart_no">
                           	</td>
                        </tr>
                        <tr>
                           	<th scope="row"><span>어미등록구분</span></th>
                        	<td>
                           		<select disabled="disabled"  id="sra_indv_mcow_brdsra_rg_dsc"></select>
                           	</td>
                           	<th scope="row"><span>어미산차</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_mothr_matime">
                           	</td>
                           	<td colspan=6>
                           	</td> 
                        </tr>  
                        
                        <tr>
                        	<th scope="row"><span>아비귀표번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="fcow_sra_indv_eart_no">
                           	</td>
                           	<th scope="row"><span>아비등록번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="sra_indv_fcow_brdsra_rg_no">
                           	</td>
                        	<th scope="row"><span>조부 KPN 번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="grfa_sra_kpn_no">
                           	</td>
                           	<th scope="row"><span>조부 개체번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="grfa_sra_indv_eart_no">
                           	</td>
                           	<th scope="row"><span>조모 개체번호</span></th>
                        	<td>
                           		<input type="text" disabled="disabled" id="grmo_sra_indv_eart_no">
                           	</td>
                        </tr>     
                    </tbody>
                </table>
                </form>
            </div>
        </div>
        
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">분만정보</p></li>
            </ul>
        </div>
        <div class="listTable">           
            <table id="grd_BhPtur">
            </table>
        </div>
        
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">교배정보</p></li>
            </ul>
        </div>
        <div class="listTable">           
            <table id="grd_BhCross">
            </table>
        </div>
        
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">개체 이동정보</p></li>
            </ul>
        </div>
        <div class="listTable">           
            <table id="grd_CattleMove">
            </table>
        </div>    
        
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">형매정보</p></li>
            </ul>
        </div>
        
        <div class="listTable">           
            <table id="grd_SibIndv">
            </table>
        </div>
        
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">후대정보</p></li>
            </ul>
        </div>
        <div class="listTable">           
            <table id="grd_PostIndv">
            </table>
        </div>    
    </div>
    <!-- //pop_body e -->
</body>
<script type="text/javascript">
/*------------------------------------------------------------------------------
 * 1. 단위업무명   : 가축시장
 * 2. 파  일  명   : LALM0222P
 * 3. 파일명(한글) : 개체검색(인터페이스) 팝업
 *----------------------------------------------------------------------------*
 *  작성일자      작성자     내용
 *----------------------------------------------------------------------------*
 * 2021.11.01   신명진   최초작성
 ------------------------------------------------------------------------------*/
 var mcow_sra_indv_eart_no = "";
 var tmpZip   = ""; 
 var tmpTelno = "";   
 var tmpMpno  = "";
 var selresult = null;
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    $(document).ready(function(){
    	//그리드 초기화
        fn_CreatePturGrid();
        fn_CreateBhCrossGrid();
        fn_CreateGridSibIndv();
        fn_CreateGridPostIndv();
        fn_CreateGridCattleMove();
        
        fn_setCodeBox("sra_indv_kn_c", "SRA_INDV_KN_C", 1);
        fn_setCodeBox("sra_indv_dsc", "SRA_INDV_DSC", 1);
        fn_setCodeBox("indv_sex_c", "INDV_SEX_C", 1);
        fn_setCodeBox("sra_indv_brdsra_rg_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);
        fn_setCodeBox("sra_indv_stsc", "SRA_INDV_STSC", 1);
        fn_setCodeBox("sra_indv_mcow_brdsra_rg_dsc", "SRA_INDV_BRDSRA_RG_DSC", 1);
        
        /******************************
         * 개체이월일자 변경이벤트
         ******************************/
         $("#sra_indv_amnno").keydown(function(e){
             if(e.keyCode == 13){
            	 fn_Search();
             } else {
            	 fn_InitFrm('frm_MhSogCow');
            	 fn_InitFrm('frm_MhSogCow1');
            	 
            	 $("#grd_BhPtur").jqGrid("clearGridData", true);
              	 $("#grd_BhCross").jqGrid("clearGridData", true);
              	 
              	 $("#sra_indv_kn_c").val("");
                 $("#sra_indv_dsc").val("");
                 $("#indv_sex_c").val("");
                 $("#sra_indv_brdsra_rg_dsc").val("");
                 $("#sra_indv_stsc").val("");
                 $("#sra_indv_mcow_brdsra_rg_dsc").val("");
             }
         });
    	
        if(pageInfo.param){
        	//폼 초기화
            fn_InitFrm('frm_Search');
            $("#sra_indv_amnno").val(pageInfo.param.sra_indv_amnno);
            fn_Search();
            if(pageInfo.param?.unique_yn == 'Y')fn_Select();
            $("#sra_indv_amnno").focus();
        }else {
            fn_Init();
        }        
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      	 
     	//그리드 초기화
     	$("#grd_BhPtur").jqGrid("clearGridData", true);
     	$("#grd_BhCross").jqGrid("clearGridData", true);
     	
         //폼 초기화
         fn_InitFrm('frm_Search');
         
         $("#sra_indv_kn_c").val("");
         $("#sra_indv_dsc").val("");
         $("#indv_sex_c").val("");
         $("#sra_indv_brdsra_rg_dsc").val("");
         $("#sra_indv_stsc").val("");
         $("#sra_indv_mcow_brdsra_rg_dsc").val("");
         
         $("#sra_indv_amnno").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	if( $("#sra_indv_amnno").val().length != 15){
    		MessagePopup('OK',"귀표번호를 확인해 주세요.");
    		return;
    	}
    	//개체이력정보
    	var srchData = new Object();
    	var results = null;
    	selresult = null;
    	
        srchData["ctgrm_cd"]  = "4700";
        srchData["sra_indv_amnno"] = $("#sra_indv_amnno").val();
        
        results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        } else {
        	$("#grd_BhPtur").jqGrid("clearGridData", true);
         	$("#grd_BhCross").jqGrid("clearGridData", true);
        	$("#grd_SibIndv").jqGrid("clearGridData", true);
         	$("#grd_PostIndv").jqGrid("clearGridData", true);
         	$("#grd_CattleMove").jqGrid("clearGridData", true);
         	
         	selresult = setDecrypt(results);
         	var inqCn = new Number(selresult.INQ_CN);
         	if(!fn_isNum(selresult.INQ_CN) || inqCn == "0") {
         		MessagePopup('OK',"조회된 내역이 없습니다.");
        		return;
         	} else {
         		fn_FrmMhSogCow(selresult);
                fn_SelBhPtur();
                fn_SelBhCross();
				//형매
                fn_SelSibIndv();
              	//후대
                fn_SelPostIndv();
              	//개체 이동내역
                fn_SelCattleMove();
         	}
         	
        }
    } 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 선택함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Select(){
	   	 if(selresult == null){
	   		MessagePopup('OK',"조회된 내역이 없습니다.");
			 $('#sra_indv_amnno').focus();
			 return;
		 }else if(selresult.SRA_INDV_AMNNO == ''){
	   		 MessagePopup('OK',"조회된 귀표번호가 없습니다.");
			 $('#sra_indv_amnno').focus();
			 return;			 
		 }else if(selresult.FHS_ID_NO == '' && selresult.FARM_AMNNO == ''){
	   		 MessagePopup('OK',"조회된 농가정보가 없습니다.");
			 $('#sra_indv_amnno').focus();
			 return;			 
		 }
	   	 	   	 
    	 selresult.LIST_SIB_INDV = $('#grd_SibIndv').getRowData();			//형매정보
    	 selresult.LIST_POST_INDV = $('#grd_PostIndv').getRowData();		//후대정보
    	 selresult.LIST_CATTLE_MOVE = $('#grd_CattleMove').getRowData();	//이동정보
    	 selresult.LIST_BH_PTUR = $('#grd_BhPtur').getRowData();			//분만정보
    	 selresult.LIST_BH_CROSS = $('#grd_BhCross').getRowData();			//교배정보
         var results = sendAjax(selresult, "/LALM0222P_updReturnValue", "POST");
         var returnVal;
         
         if(results.status != RETURN_SUCCESS) {
             showErrorMessage(results);
             return;

         } else {
        	 returnVal = setDecrypt(results);
             var len = $('#grd_BhCross').getRowData().length;
             var crossSort = selresult.LIST_BH_CROSS.sort(function(pre,next){return next.CRSBD_DT - pre.CRSBD_DT;});
             pageInfo.returnValue = returnVal[0];
             pageInfo.returnValue.PTUR_PLA_DT = '';
             if(crossSort.length > 0) pageInfo.returnValue.PTUR_PLA_DT = $.trim(crossSort[0].CRSBD_DT);
             //pageInfo.returnValue.SIB_INDV = $('#grd_SibIndv').getRowData();
             //pageInfo.returnValue.POST_INDV = $('#grd_PostIndv').getRowData(); 
             var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
             parentInput.val(true).trigger('change');
         }
    	 
    }  
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    
    
  	//**************************************
 	//function  : fn_SelPostIndv(형매정보 인터페이스) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_SelSibIndv() {
    	var srchData = new Object();
    	var results = null;
    	var result = null;
    	
        srchData["ctgrm_cd"]  = "4900";
        srchData["sra_indv_amnno"] = $("#mcow_sra_indv_eart_no").val();
        //srchData["mcow_sra_indv_amnno"] = $("#mcow_sra_indv_eart_no").val();
        results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        if(results.status != RETURN_SUCCESS){
           //showErrorMessage(results,'NOTFOUND');
           return;
        }else{      
			result = setDecrypt(results);
			var sibResult = result.map((e,i)=>{
	    		Object.keys(e).forEach((key)=>{
	    			var temp = e[key];
	    			e[key] = temp.trim()||''; 
	    		});
				return e;
			});
			fn_CreateGridSibIndv(sibResult);
        }
    }
  	//**************************************
 	//function  : fn_SelCattleMove(개체 이동내역 인터페이스) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_SelCattleMove() {
    	var srchData = new Object();
    	var results = null;
    	var result = null;
    	
        srchData["trace_no"] = $("#sra_indv_amnno").val();
        results = sendAjax(srchData, "/LALM0899_selRestApiCattleMove", "POST");        
        if(results.status != RETURN_SUCCESS){
            //showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
        	result = setDecrypt(results);
            fn_CreateGridCattleMove(result);
        }
    }
    
    
    
  	//**************************************
 	//function  : fn_SelPostIndv(후대정보 인터페이스) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_SelPostIndv() {
    	var srchData = new Object();
    	var results = null;
    	var result = null;
    	
        srchData["ctgrm_cd"]  = "4900";
        srchData["sra_indv_amnno"] = $("#sra_indv_amnno").val();
        results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        if(results.status != RETURN_SUCCESS){
           //showErrorMessage(results,'NOTFOUND');
           return;
        }else{      
        	result = setDecrypt(results);
			var postResult = result.map((e,i)=>{
	    		Object.keys(e).forEach((key)=>{
	    			var temp = e[key];
	    			e[key] = temp.trim()||''; 
	    		});
				return e;
			});
           fn_CreateGridPostIndv(postResult);
        }
    }
    
    
    //**************************************
 	//function  : fn_SelBhPtur(분만정보 인터페이스) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_SelBhPtur() {
    	var srchData = new Object();
    	var resultsBhPtur = null;
    	var resultBhPtur = null;
    	
        srchData["ctgrm_cd"]  = "2300";
        srchData["mcow_sra_indv_eart_no"] = $("#sra_indv_amnno").val();
        resultsBhPtur = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
        
        if(resultsBhPtur.status != RETURN_SUCCESS){
            showErrorMessage(resultsBhPtur,'NOTFOUND');
            return;
        }else{      
        	resultBhPtur = setDecrypt(resultsBhPtur);
            fn_CreatePturGrid(resultBhPtur);
        }
    }
    
  	//**************************************
 	//function  : fn_SelBhCross(교배정보 인터페이스) 
 	//paramater : N/A
 	// result   : N/A
 	//**************************************
    function fn_SelBhCross() {
    	var srchData = new Object();
    	var resultsBhCross = null;
    	var resultBhCross = null;
    	
        srchData["ctgrm_cd"]  = "2400";
        srchData["mcow_sra_indv_eart_no"] = $("#sra_indv_amnno").val();
        resultsBhCross = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        if(resultsBhCross.status != RETURN_SUCCESS){
            showErrorMessage(resultsBhCross,'NOTFOUND');
            return;
        }else{      
        	resultBhCross = setDecrypt(resultsBhCross);
            fn_CreateBhCrossGrid(resultBhCross);
        }
    }
    
	////////////////////////////////////////////////////////////////////////////////
    //  사용자 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    // 분만정보 그리드 생성
    function fn_CreatePturGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }

        var searchResultColNames = ["산차", "교배차수", "교배일자", "KPN", "분만일자", "분만구분", "송아지귀표번호", "성별", "생시체중", "분만간격", "분만농가"
        							,"모개체번호","분만일련번호","농가식별번호","축산개체인공수정방법","분만두수","분만확인일자","분만상태코드","등록사무소코드","관리수무소코드","임신기간일수"];   
        var searchResultColModel = [
						            {name:"MATIME"       			, index:"MATIME"         			, width:70,  align:'center', formatter:'integer'},
						            {name:"CRSBD_QCN"       		, index:"CRSBD_QCN"              	, width:70,  align:'center', formatter:'integer'},
						            {name:"CRSBD_DT"        		, index:"CRSBD_DT"             		, width:70,  align:'center', formatter:'gridDateFormat'},
						            {name:"SRA_KPN_NO"             	, index:"SRA_KPN_NO"               	, width:70,  align:'center'},
						            {name:"PTUR_DT"                	, index:"PTUR_DT"                  	, width:70,  align:'center', formatter:'gridDateFormat'},
						            {name:"PTUR_DSC"             	, index:"PTUR_DSC"               	, width:70,  align:'center'},
						            {name:"CALF_SRA_INDV_EART_NO"	, index:"CALF_SRA_INDV_EART_NO"		, width:150, align:'center'},
						            {name:"INDV_SEX_C"           	, index:"INDV_SEX_C"             	, width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("INDV_SEX_C", 1)}},
						            {name:"LFTM_WGH"  				, index:"LFTM_WGH"    				, width:70,  align:'center', formatter:'integer'},
						            {name:"PTUR_INTV_DDS"           , index:"PTUR_INTV_DDS"             , width:70,  align:'center', formatter:'integer'},
						            {name:"SRA_FARMNM"    			, index:"SRA_FARMNM"      			, width:150, align:'center'},
						            {name:"SRA_INDV_AMNNO"    		, index:"SRA_INDV_AMNNO"      		, width:50, align:'center',hidden:true},
						            {name:"PTUR_SQNO"    			, index:"PTUR_SQNO"      			, width:50, align:'center',hidden:true},
						            {name:"FHS_ID_NO"    			, index:"FHS_ID_NO"      			, width:50, align:'center',hidden:true},						            
						            {name:"FERT_METHC"    			, index:"FERT_METHC"      			, width:50, align:'center',hidden:true},						            
						            {name:"PTUR_HDCN"    			, index:"PTUR_HDCN"      			, width:50, align:'center',hidden:true},
						            {name:"PTUR_CNF_DT"    			, index:"PTUR_CNF_DT"      			, width:50, align:'center',hidden:true},
						            {name:"PTUR_STSC"    			, index:"PTUR_STSC"      			, width:50, align:'center',hidden:true},
						            {name:"RG_BRC"    				, index:"RG_BRC"      				, width:50, align:'center',hidden:true},
						            {name:"MBR_BRC"    				, index:"MBR_BRC"      				, width:50, align:'center',hidden:true},
						            {name:"PRNY_PRD_DDS"    		, index:"PRNY_PRD_DDS"      		, width:50, align:'center',hidden:true}
						            
						            
						            
                                     ];
            
        $("#grd_BhPtur").jqGrid("GridUnload");
                
        $("#grd_BhPtur").jqGrid({
            datatype:    "local",
            data:        data,
            height:      100,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
           },
           
        });   
        
    }
    
  	// 교배정보 그리드 생성
    function fn_CreateBhCrossGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["예정산차", "교배차수", "교배일자", "수정방법", "KPN", "인공수정사", "분만일자", "임신기간", "교배농가","분만예정일자","농가번호"];        
        var searchResultColModel = [
						            {name:"CRSBD_MATIME"       				, index:"CRSBD_MATIME"         			, width:100,  align:'center', formatter:'integer'},
						            {name:"CRSBD_QCN"            			, index:"CRSBD_QCN"              		, width:100,  align:'center', formatter:'integer'},
						            {name:"CRSBD_DT"           				, index:"CRSBD_DT"             			, width:100,  align:'center', formatter:'gridDateFormat'},
						            {name:"FERT_METHC"		                , index:"FERT_METHC"	             	, width:100,  align:'center'},
						            {name:"SRA_KPN_NO"             			, index:"SRA_KPN_NO"               		, width:100,  align:'center'},
						            {name:"FERT_AMRNM"             	     	, index:"FERT_AMRNM"                 	, width:100,  align:'center'},
						            {name:"PTUR_DT"               			, index:"PTUR_DT"                 		, width:100,  align:'center', formatter:'gridDateFormat'},
						            {name:"PRNY_PRD_DDS"           			, index:"PRNY_PRD_DDS"             		, width:100,  align:'center', formatter:'integer'},
						            {name:"SRA_FARMNM"  					, index:"SRA_FARMNM"    				, width:200,  align:'center'},
						            {name:"PTUR_PLA_DT"               		, index:"PTUR_PLA_DT"                 		, hidden:true},
						            {name:"FHS_ID_NO"               		, index:"FHS_ID_NO"                 		, hidden:true},
                                     ];
            
        $("#grd_BhCross").jqGrid("GridUnload");
                
        $("#grd_BhCross").jqGrid({
            datatype:    "local",
            data:        data,
            height:      100,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
           },
           
        });   
        
    }
  	

    
  	// 형매정보 그리드 생성
    function fn_CreateGridSibIndv(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }

        var searchResultColNames = ["축산개체관리번호","산차","계대","등록구분코드","KPN번호","개체성별코드","생년월일","도체중","등급","도축일"];        
        var searchResultColModel = [					
						            {name:"SRA_INDV_AMNNO"                   , index:"SRA_INDV_AMNNO"               , width:100,  align:'center'},
						            {name:"SRA_INDV_LS_MATIME"               , index:"SRA_INDV_LS_MATIME"           , width:50,  align:'center'},
						            {name:"SRA_INDV_PASG_QCN"                , index:"SRA_INDV_PASG_QCN"            , width:50,  align:'center'},
						            {name:"RG_DSC"                           , index:"RG_DSC"                       , width:80,  align:'center'},
						            {name:"SRA_KPN_NO"                       , index:"SRA_KPN_NO"                   , width:80,  align:'center'},
						            {name:"INDV_SEX_C"                       , index:"INDV_SEX_C"                   , width:80,  align:'center'},
						            {name:"MIF_SRA_INDV_BIRTH"               , index:"MIF_SRA_INDV_BIRTH"           , width:100,  align:'center'},
						            {name:"METRB_BBDY_WT"                    , index:"METRB_BBDY_WT"                , width:100,  align:'center'},
						            {name:"METRB_METQLT_GRD"                 , index:"METRB_METQLT_GRD"             , width:100,  align:'center'},
						            {name:"MIF_BTC_DT"                       , index:"MIF_BTC_DT"                   , width:100,  align:'center'}
		];
            
        $("#grd_SibIndv").jqGrid("GridUnload");
                
        $("#grd_SibIndv").jqGrid({
            datatype:    "local",
            data:        data,
            height:      100,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
           },
           
        });        
    }
    
  	// 후대정보 그리드 생성
    function fn_CreateGridPostIndv(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["축산개체관리번호","산차","계대","등록구분코드","KPN번호","개체성별코드","생년월일","도체중","등급","도축일"];        
        var searchResultColModel = [
			            {name:"SRA_INDV_AMNNO"                   , index:"SRA_INDV_AMNNO"               , width:100,  align:'center'},
			            {name:"SRA_INDV_LS_MATIME"               , index:"SRA_INDV_LS_MATIME"           , width:50,  align:'center'},
			            {name:"SRA_INDV_PASG_QCN"                , index:"SRA_INDV_PASG_QCN"            , width:50,  align:'center'},
			            {name:"RG_DSC"                           , index:"RG_DSC"                       , width:80,  align:'center'},
			            {name:"SRA_KPN_NO"                       , index:"SRA_KPN_NO"                   , width:80,  align:'center'},
			            {name:"INDV_SEX_C"                       , index:"INDV_SEX_C"                   , width:80,  align:'center'},
			            {name:"MIF_SRA_INDV_BIRTH"               , index:"MIF_SRA_INDV_BIRTH"           , width:100,  align:'center'},
			            {name:"METRB_BBDY_WT"                    , index:"METRB_BBDY_WT"                , width:100,  align:'center'},
			            {name:"METRB_METQLT_GRD"                 , index:"METRB_METQLT_GRD"             , width:100,  align:'center'},
			            {name:"MIF_BTC_DT"                       , index:"MIF_BTC_DT"                   , width:100,  align:'center'}
		];
            
        $("#grd_PostIndv").jqGrid("GridUnload");
                
        $("#grd_PostIndv").jqGrid({
            datatype:    "local",
            data:        data,
            height:      100,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
           },
           
        });        
    }

    
  	// 후대정보 그리드 생성
    function fn_CreateGridCattleMove(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["축산개체관리번호","소유자","신고구분","신고일","사육지","농장번호"];        
        var searchResultColModel = [
			            {name:"SRA_INDV_AMNNO"          , index:"SRA_INDV_AMNNO"        , width:100,  align:'center'},
			            {name:"FARMER_NM"               , index:"FARMER_NM"             , width:50,  align:'center'},
			            {name:"REG_TYPE"                , index:"REG_TYPE"            	, width:50,  align:'center'},
			            {name:"REG_YMD"                 , index:"MOVE_YMD"              , width:80,  align:'center'},
			            {name:"FARM_ADDR"               , index:"FARM_ADDR"             , width:80,  align:'center'},
			            {name:"FARM_NO"                 , index:"FARM_NO"             	, width:80,  align:'center'}
		];
            
        $("#grd_CattleMove").jqGrid("GridUnload");
                
        $("#grd_CattleMove").jqGrid({
            datatype:    "local",
            data:        data,
            height:      100,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
           },
           
        });        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    //  이벤트 함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    // 버튼클릭 이벤트
    $(document).ready(function() {
    	// 농가변경 팝업 호출 이벤트
    	$("#pb_IndvHst").on('click',function(e){
            e.preventDefault();
            this.blur();
            var data = new Object();
            data['flag'] = '2';
            data['sra_fhsnm'] = $("#hdn_sra_fhsnm").val();
            fn_CallFhsPopup(data, false, function(result){
            	if(result){
            		selresult.SRA_FARM_FZIP      = result.SRA_FARM_FZIP;
            		selresult.SRA_FARM_RZIP      = result.SRA_FARM_RZIP;
            		selresult.SRA_FARM_AMN_ATEL  = result.SRA_FARM_AMN_ATEL;
            		selresult.SRA_FARM_AMN_HTEL  = result.SRA_FARM_AMN_HTEL;
            		selresult.SRA_FARM_AMN_STEL  = result.SRA_FARM_AMN_STEL;
            		selresult.SRA_FHS_REP_MPSVNO = result.SRA_FHS_REP_MPSVNO;
            		selresult.SRA_FHS_REP_MPHNO  = result.SRA_FHS_REP_MPHNO;
            		selresult.SRA_FHS_REP_MPSQNO = result.SRA_FHS_REP_MPSQNO;
            		selresult.SRA_FHSNM          = result.SRA_FHSNM;
            		selresult.SRA_FHSNM          = result.SRA_FHSNM;
            		selresult.FHS_ID_NO          = result.FHS_ID_NO;
            		selresult.FARM_AMNNO         = result.FARM_AMNNO;
            		selresult.SRA_FARM_ACNO      = result.SRA_FARM_ACNO;
            		selresult.SRA_FHS_DONGUP     = result.SRA_FHS_DONGUP;
            		selresult.SRA_FHS_DONGBW     = result.SRA_FHS_DONGBW;
            		selresult.MBR_BRC            = result.MBR_BRC;
            		selresult.BRNM               = result.BRNM;
                 	
                 	fn_FrmMhSogCow(selresult);
            	}
            });
        });
    });
    
	
	function fn_FrmMhSogCow(result) {
		tmpZip   = ""; 
		tmpTelno = "";
		tmpMpno  = "";
		
		if(!fn_isNull(result.SRA_FARM_FZIP.trim()) || !fn_isNull(result.SRA_FARM_RZIP.trim())) {
			tmpZip   = result.SRA_FARM_FZIP.trim() + '-' + result.SRA_FARM_RZIP.trim();
		}
		if(!fn_isNull(result.SRA_FARM_AMN_ATEL.trim()) || !fn_isNull(result.SRA_FARM_AMN_HTEL.trim()) || !fn_isNull(result.SRA_FARM_AMN_STEL.trim())) {
			tmpTelno = result.SRA_FARM_AMN_ATEL.trim() + '-' + result.SRA_FARM_AMN_HTEL.trim() + '-' + result.SRA_FARM_AMN_STEL.trim();
		}
		if(!fn_isNull(result.SRA_FHS_REP_MPSVNO.trim()) || !fn_isNull(result.SRA_FHS_REP_MPHNO.trim()) || !fn_isNull(result.SRA_FHS_REP_MPSQNO.trim())) {
			tmpMpno  = result.SRA_FHS_REP_MPSVNO.trim() + '-' + result.SRA_FHS_REP_MPHNO.trim() + '-' + result.SRA_FHS_REP_MPSQNO.trim();
		}
	    
	    $("#hdn_sra_fhsnm").val($.trim(result.SRA_FHSNM));
		$("#sra_fhsnm").val($.trim(result.SRA_FHSNM) + '[' + $.trim(result.FHS_ID_NO) + '-' + $.trim(result.FARM_AMNNO) + ']');
		$("#telno").val(tmpTelno);
		$("#mpno").val(tmpMpno);
		$("#acno").val($.trim(result.SRA_FARM_ACNO));
		$("#addr").val('[' + tmpZip + ']' + $.trim(result.SRA_FHS_DONGUP) + ' ' + $.trim(result.SRA_FHS_DONGBW));
		$("#brc").val('[' + $.trim(result.MBR_BRC) + ']' + $.trim(result.BRNM));

		$("#sra_indv_eart_no").val($.trim(result.SRA_INDV_ID_NO));
		$("#sra_indv_kn_c").val($.trim(result.SRA_INDV_KN_C));
		$("#sra_indv_id_no").val($.trim(result.SRA_INDV_AMNNO));
		$("#sra_indv_brdsra_rg_no").val($.trim(result.SRA_INDV_BRDSRA_RG_NO));
		$("#sra_indv_earstk_dt").val($.trim(result.SRA_INDV_EARSTK_DT));
		$("#sra_indv_byng_dt").val($.trim(result.SRA_INDV_BYNG_DT));
		$("#sra_indv_dsc").val($.trim(result.SRA_INDV_DSC));
		$("#indv_sex_c").val($.trim(result.INDV_SEX_C));
		$("#sra_indv_birth").val($.trim(result.SRA_INDV_BIRTH));
		$("#sra_indv_brdsra_rg_dsc").val($.trim(result.SRA_INDV_BRDSRA_RG_DSC));
		$("#sra_indv_kpn_no").val($.trim(result.SRA_KPN_NO));
		$("#sra_indv_lftm_wgh").val(parseInt($.trim(result.SRA_INDV_LFTM_WGH)==''?'0':$.trim(result.SRA_INDV_LFTM_WGH)));
		$("#sra_indv_pdg_rg_wgh").val(parseInt($.trim(result.SRA_INDV_PDG_RG_WGH)==''?'0':$.trim(result.SRA_INDV_PDG_RG_WGH)));
		$("#sra_indv_stsc").val($.trim(result.SRA_INDV_STSC));
		$("#sra_indv_pasg_qcn").val(parseInt($.trim(result.SRA_INDV_PASG_QCN)==''?'0':$.trim(result.SRA_INDV_PASG_QCN)));
		$("#mcow_sra_indv_eart_no").val($.trim(result.MCOW_SRA_INDV_EART_NO));
		$("#sra_indv_mcow_brdsra_rg_dsc").val($.trim(result.SRA_INDV_MCOW_BRDSRA_RG_DSC));
		$("#sra_indv_mcow_brdsra_rg_no").val($.trim(result.SRA_INDV_MCOW_BRDSRA_RG_NO));
		$("#sra_indv_mothr_matime").val(parseInt($.trim(result.SRA_INDV_MOTHR_MATIME)==''?'0':$.trim(result.SRA_INDV_MOTHR_MATIME)));
		$("#fcow_sra_indv_eart_no").val($.trim(result.FCOW_SRA_INDV_EART_NO));
		$("#sra_indv_fcow_brdsra_rg_no").val($.trim(result.SRA_INDV_FCOW_BRDSRA_RG_NO));

		//20221103 jjw 개체 인터페이스 2200 => 4700 변경시 적용
		$("#sra_fhs_birth").val($.trim(result.BIRTH));		
		$("#grfa_sra_kpn_no").val($.trim(result.GRFA_SRA_KPN_NO));		
		$("#grfa_sra_indv_eart_no").val($.trim(result.GRFA_SRA_INDV_EART_NO));		
		$("#grmo_sra_indv_eart_no").val($.trim(result.GRMO_SRA_INDV_EART_NO));		
		$("#mtgrfa_sra_kpn_no").val($.trim(result.MTGRFA_SRA_KPN_NO));		
		$("#mtgrfa_sra_indv_eart_no").val($.trim(result.MTGRFA_SRA_INDV_EART_NO));		
		$("#mtgrmo_sra_indv_eart_no").val($.trim(result.MTGRMO_SRA_INDV_EART_NO));		
		
		
	}
    
</script>
</html>