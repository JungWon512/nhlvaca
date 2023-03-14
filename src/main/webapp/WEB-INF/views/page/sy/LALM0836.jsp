<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp" %>
<%@ include file="/WEB-INF/common/head.jsp" %>

<link rel="stylesheet" href="/css/jqTree/jqtree.css">

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  
</head>

<style>
.ui-jqgrid .ui-state-highlight{border:1px solid #dddddd;background:white;}
</style>

<script type="text/javascript">

var setRowStatus = ""; // I == 입력초기화 인서트,  U == 쿼리그리드 업데이트
let scheDtGb = "";

 $(document).ready(function(){
	 fn_Creategrd_AucInfo();	
	 fn_Init();
	 sche_dt_month();
	
	 
	/********************************
	  경매대상 버튼 불러오기
	  ********************************/
	fn_setCodeRadio();
	fn_setCodeRadio("auc_obj_dsc","hd_auc_obj_dsc","AUC_OBJ_DSC", 2); 
	fn_setRadioChecked("auc_obj_dsc");


	
	//**************************************
	//function  : CLNTNM(조합 조회) 
	//paramater :  result
	//result   : N/A
	//**************************************
	$('#na_bzplcloc').on('change', function(){
		sel_clntnm();
	});


	//**************************************
	//function  : 조합 선택 후 정보 노출 ( 전화번호 & 주소) 
	//paramater :  N/A
	//result   : N/A
	//**************************************
	$('#na_bzplc').on('change',function() {
		const na_bzplcnoObj = {
			na_bzplcno: $("#na_bzplc option:checked").attr("id")
		}
		var results = sendAjax(na_bzplcnoObj, "/LALM0836_selTelAddress", "POST");
		var result;
		
		if(results.status != RETURN_SUCCESS){
	    	showErrorMessage(results);
	        return;
	    }else{      
	        result = setDecrypt(results);
	       		
			$('#telno').attr('value',result.TELNO);
			$('#addr1').attr('value',result.ADDR1);
			$('#addr2').attr('value',result.ADDR2);
		}
	});

	/********************************
	경매일자 정보 disabled 처리 
	********************************/
	fn_DisableFrm('frm_AucDateInfo', true);
	$("input[name='sche_dotw']").attr("disabled", true);    

/********************************
   입력초기화 버튼클릭 이벤트
  ********************************/
	$("button[name='btn_Init']").on("click",  function(event) {   
	 	event.preventDefault() ;
	 	bzplcloc(); // 지역조회 함수 실행.
	 	$("option[name='na_bzplcnoVal']").remove(); //값 삭제
		mv_RunMode = 1;
		setRowStatus = "I"; // I == 입력초기화 인서트
		fn_InitFrm('frm_AucDateInfo');
		fn_DisableFrm('frm_AucDateInfo', false);
		$("select[name='sche_dt']").attr("disabled",true);
		$("#hd_auc_obj_dsc").val("1");
		$('input[name="sche_dotw"]').removeAttr("disabled");
		fn_setChgRadio("sche_dt_gb", "2");
	});

	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 지정일자 or 지정요일 선택 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	$("input[name=sche_dt_gb]").on('change',function() {
		
		fn_setChgRadio("sche_dt_gb", $(this).val() );
		radioDisabled( $(this).val() );

		if(setRowStatus == "U") {
			if($(this).val() != scheDtGb ) {
				MessagePopup("OK","변경시, 같은조합-다른 경매대상의  '날짜가 사라집니다.''");
				return;			
			}
		}		
	});
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    :  checkbox value -> hidden 으로 넣기 (sche_week 는 저장버튼 유효성 검사에서 처리 )
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/	 
	$('.sche_dotw').on('change',function(){
		if( $(".sche_dotw").is(":checked") ){
			var weekValue = $(this).val();
			$('#sche_dotw').val( weekValue );
		}
	});
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 중복체크 방지
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	/* select checkDupl*/
	$('select[name="sche_dt"]').on('input',function(){
		var others = $("select[name='sche_dt']").not($(this));
		for(var i = 0; i < others.length; i++) {
			if($(others).eq(i).val() == $(this).val()) {
				MessagePopup("OK","중복된 날짜입니다.");
				$(this).val(0);
				break;
			}
		}
	});

	/*  sche_dotw dupl*/
	$('input[name="sche_dotw"]').on('click',function(){
		if( $(this).prop('checked')){
			$('input[name="sche_dotw"]').prop('checked',false);
			$(this).prop('checked',true);
		}
	}); 

}); /***************** ready fuction *********************/

////////////////////////////////////////////////////////////////////////////////
//  공통버튼 클릭함수 시작
////////////////////////////////////////////////////////////////////////////////

 /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        fn_Creategrd_AucInfo();
        
        //폼 초기화
        fn_InitFrm('frm_AucDateInfo');        
        fn_InitFrm('frm_Search');        
        
        setRowStatus = "";
        
        fn_DisableFrm('frm_AucDateInfo', true);
        mv_RunMode = 1;
        
        $("#btn_Save").attr('disabled', false);
        $("#btn_Delete").attr('disabled', false);
    }
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	$("#mainGrid").jqGrid("clearGridData", true);
    	
    	var results = sendAjaxFrm("frm_Search", "/LALM0836_SelAucInfo", "POST");
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
             return;
        }else{     
        	result = setDecrypt(results);
        }
        fn_Creategrd_AucInfo(result);
    	
     }
    
    
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 저장 함수
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function fn_Save(){	  
		// 정합성 체크
		if( fn_isNull($('#na_bzplcloc').val()) == true ){
			   MessagePopup("OK", "지역을 선택하세요",function(res){
		              $('#na_bzplcloc').focus();
		          });
		          return;
		}
		if( fn_isNull($('#na_bzplc').val()) == true ){
			   MessagePopup("OK", "조합을 선택하세요",function(res){
		              $('#na_bzplc').focus();
		          });
		          return;
		}			
		if( fn_isNull($('#aucdt_det').val()) == true ){
			   MessagePopup("OK", "거래일을 입력 해주세요.",function(res){
		              $('#aucdt_det').focus();
		          });
		          return;
		} 
		if ($('input:checked[id="sche_dt_gb_1"]').is(":checked") ){
			if( $(".sche_dt option:selected").filter( function() {return this.value != "0"; }).length == "0" ){ 
				   MessagePopup("OK", "지정일자를 선택 해주세요.",function(res){
					   $("#sche_dt1 option:selected" ).focus();
		           });
		           return;
			} 
		}
		if ($('input:checked[id="sche_dt_gb_2"]').is(":checked") ){
			if($('input[name="sche_week"]:checkbox:checked').length < 1 ){
				   MessagePopup("OK", "주차를 선택 해주세요.",function(res){
					   $("#sche_week option:selected" ).focus();
		           });
		           return;
			} 
			if($('input[name="sche_dotw"]:checkbox:checked').length < 1 ){
				   MessagePopup("OK", "요일을 선택 해주세요.",function(res){
					   $("#sche_dotw option:selected" ).focus();
		           });
		           return;
			} 
		}
		// 지정일자 선택시
		if($('#sche_dt_gb').val() == '1') {
			var selectnum = [];
			var seldt = $('.sche_dt option:selected');
			
			for (i=0; i<seldt.length; i++){
				if(seldt[i].selected != '') {
					selectnum.push( seldt[i].value );
				}
			}
			$('input[name="sche_dt_arr"]').val(selectnum);
		}	
		
// 		지정요일 선택시
		if($('#sche_dt_gb').val() == '2') {
			
			var checknum = [];
			var chkbox = $('.sche_week:checked');
			
			for(i=0; i<chkbox.length; i++) {
			    if(chkbox[i].checked == true){
			        checknum.push( chkbox[i].value );
			    }
			}
			$('input[name="sche_week_arr"]').val(checknum);
		}	

		// 유효성 끝나면 저장함수 실행.
		MessagePopup('YESNO',"저장 하시겠습니까?",function(res){
			if(res){
			var result = sendAjaxFrm("frm_AucDateInfo", "/LALM0836_insAucDateInfo", "POST");            
			    	 
			     if(result.status == RETURN_SUCCESS){
			     	MessagePopup("OK", "저장되었습니다.");
			     	mv_RunMode = 3;
			     	fn_Init();
			        fn_Search();
			     } else {
			     	showErrorMessage(result);
			         return;
			     }
			}else{
			    MessagePopup('OK','취소되었습니다.');
			}
		});
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
		}   	
    	MessagePopup('YESNO',"삭제하시겠습니까?",function(res){                           
	        if(res){
				var results = sendAjaxFrm("frm_AucDateInfo", "/LALM0836_delAucDateInfo", "POST");        
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
////////////////////////////////////////////////////////////////////////////////
// 공통버튼 클릭함수 종료
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// 그리드 시작 
////////////////////////////////////////////////////////////////////////////////

	function fn_Creategrd_AucInfo(data){
		var rowNoValue = 0;     
		if(data != null){
		    rowNoValue = data.length;
		}
	
		var searchResultColNames = ["지역","조합","경매구분","거래주기","거래일","등록일자","등록자","통합사업장코드","지역코드","등록일련번호","경매구분 값", "거래주기히든","거래일히든","지정요일히든","경매구분히든","거래일상세 히든","동이상주소 히든","동이하주소 히든","조합 전화번호 히든"];  
		var searchResultColModel = [                                                              
			{name:"LOCNM",        index:"LOCNM",        width:40, align:'center'},
		    {name:"CLNTNM",        index:"CLNTNM",        width:40, align:'center'},
		    {name:"HD_AUC_OBJ_DSC",        index:"HD_AUC_OBJ_DSC",        width:40, align:'center'},
		    {name:"SCHE_WEEK",           index:"SCHE_WEEK",           width:40, align:'center'}, 
		    {name:"AUC_DATE",             index:"AUC_DATE",             width:40, align:'center'}, 
		    {name:"FSRG_DTM",         index:"FSRG_DTM",         width:40, align:'center'},
		    {name:"LS_CMENO",                 index:"LS_CMENO",                 width:40, align:'center'},
		    {name:"NA_BZPLC",                 index:"NA_BZPLC",                 width:40, align:'center',  hidden:true},
		    {name:"NA_BZPLCLOC",                 index:"NA_BZPLCLOC",                 width:40, align:'center',  hidden:true},
		    {name:"REG_SEQ",                 index:"REG_SEQ",                 width:40, align:'center',  hidden:true},
		    {name:"AUC_OBJ_DSC",                 index:"AUC_OBJ_DSC",                 width:40, align:'center',  hidden:true},
			{name:"SCHE_WEEK_ORI",                 index:"SCHE_WEEK_ORI",                 width:40, align:'center',  hidden:true},
			{name:"SCHE_DT_ORI",                 index:"SCHE_DT_ORI",                 width:40, align:'center',  hidden:true}, 
			{name:"SCHE_DT_GB",                 index:"SCHE_DT_GB",                 width:40, align:'center',  hidden:true} ,
			{name:"AUC_OBJ_DSC",                 index:"AUC_OBJ_DSC",                 width:40, align:'center',  hidden:true}, 
			{name:"AUCDT_DET",                 index:"AUCDT_DET",                 width:40, align:'center',  hidden:true}, 
			{name:"ADDR1",                 index:"ADDR1",                 width:40, align:'center',  hidden:true}, 
			{name:"ADDR2",                 index:"ADDR2",                 width:40, align:'center',  hidden:true}, 
			{name:"TELNO",                 index:"TELNO",                 width:40, align:'center',  hidden:true} 
		];
          
		$("#mainGrid").jqGrid("GridUnload");
          
		$("#mainGrid").jqGrid({
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
			    var sel_data = $("#mainGrid").getRowData(rowid);
			    setRowStatus = "U";
			    
			    fn_setFrm_AucInfo(sel_data);    
			}
		});    
		//행번호
		$("#mainGrid").jqGrid("setLabel", "rn","No");
	}
	
	// 그리드 클릭해서 업데이트 가능하게 불러오기
	function fn_setFrm_AucInfo(sel_data) {
		// 정보 초기화
		fn_InitFrm('frm_AucDateInfo');
		
		//경매일자정보 활성화
        $("#btn_Save").attr('disabled', false);
        $("#btn_Delete").attr('disabled', false);
        fn_DisableFrm('frm_AucDateInfo', false);
        
        // 수정 불가사항들  na_bzplcloc na_bzplc hd_auc_obj_dsc
        $("#na_bzplcloc").attr('disabled', true);
        $("#na_bzplc").attr('disabled', true);
          
        if(sel_data == null){
            showErrorMessage(sel_data, "NOTFOUND");
            return;
        }else{
	         fn_setFrmByObject("frm_AucDateInfo", sel_data);		
	         
	         // 체크박스 초기화
	         $('input[name="sche_week"]').removeAttr("checked");
			 $('input[name="sche_dotw"]').removeAttr("checked"); 
			 $("select[name='sche_dt']").val(0);
			 
	       	// 경매구분 라디오.
	        fn_setChgRadio("hd_auc_obj_dsc", sel_data.AUC_OBJ_DSC);
	        fn_setRadioChecked("hd_auc_obj_dsc");
	        // hd_auc_obj_dsc 에  $("#hd_auc_obj_dsc").attr('disabled', true);가 되지않아 div 안에있는 태그들을 비활성
	        $("#auc_obj_dsc :input").attr('disabled', true); 
	          
	       	//  등록일자구분
	        fn_setChgRadio("sche_dt_gb", sel_data.SCHE_DT_GB);
	        fn_setRadioChecked("sche_dt_gb");
	        radioDisabled(sel_data.SCHE_DT_GB);
	           
	          // 주 체크
			const week_str= sel_data.SCHE_WEEK_ORI ;
			const arr1 = week_str.split(',');
			
			for(let i = 0; i<arr1.length; i++ ){ 
			    fn_contrChBox(true, "sche_week"+ arr1[i] , "", arr1[i]  , arr1[i] +"주" + (arr1[i] == "5" ? "(마지막주)" : "") );
			}
			         
			// 지정일자 셀렉트박스 
			if( sel_data.SCHE_DT_GB == '1') {
// 			    sche_dt_month(); 
				const week_dt= sel_data.SCHE_DT_ORI ;
				const arr2 = week_dt.split(',');
			    
				for(let d = 0; d<arr2.length; d++) {
					$('#sche_dt'+ (d+1) ).val(arr2[d]);			    	  
				}			
					scheDtGb = "1";
			}
			if( sel_data.SCHE_DT_GB == '2') {
				scheDtGb = "2";
			}
			 
			 // 일 체크
			fn_contrChBox(true, "sche_dotw"+sel_data.SCHE_DT_ORI, "", sel_data.SCHE_DT_ORI );		
			$('#sche_dotw').val(sel_data.SCHE_DT_ORI);
			  
			//  지역선택
			bzplcloc();
			$('#na_bzplcloc').val(sel_data.NA_BZPLCLOC);
			
			 // 조합 조회함수 실행 
			sel_clntnm();
			$('#na_bzplc').val(sel_data.NA_BZPLC);
			
			// 거래일 상세
			 $('#aucdt_det').val(sel_data.AUCDT_DET); 
			
			// 동이상주소
			 $('#addr1').val(sel_data.ADDR1); 
			
			// 동이하주소
			 $('#addr2').val(sel_data.ADDR2); 
			
			// 조합전화번호
			 $('#telno').val(sel_data.TELNO);
       	}
	}
	
	
	//**************************************
	//function  : na_bzplcloc(지역 조회) 
	//paramater : 
	// result   : N/A
	//**************************************
	  
	function bzplcloc(){	
		  
		var results = sendAjaxFrm("", "/LALM0836_selBzplcloc", "POST");
		var result;
		
		if(results.status != RETURN_SUCCESS){
		      showErrorMessage(results);
		      return;
		}else{      
			result = setDecrypt(results);
		         
		    var select = $('#na_bzplcloc');
		    var select2 = $('#na_bzplc');
		    
		    select.html("");
		    select2.html("");
		    
		  	select.append( '<option value="" hidden>' + "지역을 선택하세요." + '</option>' );
		  	select2.append( '<option value=""  >' + "조합을 선택하세요." + '</option>' );
		    if (result.length > 0) {
			    for ( var r of result ) {
			    	select.append( '<option value="' + r.NA_BZPLCLOC  + '">' + r.NA_BZPLCLOC_NM + '</option>' );
			    }
		    }
		}        
}
	
	
	
	//**************************************
	//function  : 조합 조회
	//paramater : 
	// result   : N/A
	//**************************************
	function sel_clntnm(){
	    const op = $("option[name='na_bzplcnoVal']");
	    op.remove(); // 누적 값 삭제
	    
	    var na_bzplcloc = $('#na_bzplcloc').val();
	    const selecObj = { na_bzplcloc : na_bzplcloc }
		
		var results = sendAjax(selecObj, "/LALM0836_selClntnm", "POST");
		var result;
	
	    result = setDecrypt(results);
	    
	    $("#na_bzplc").innerHTML="";
	    
		for( let r of result) {
			$("#na_bzplc").append( '<option  id="'+ r.NA_BZPLCNO +'" name="na_bzplcnoVal" value="' + r.NA_BZPLC + '">' + r.CLNTNM + '(' + r.AREANM +')' + '</option>' );
		}
    }
	
	
	// 라디오버튼 disabled처리
	function  radioDisabled(flag) {
		if (flag == '1') {
			$("select[name='sche_dt']").removeAttr("disabled");
			$('input[name="sche_week"]').attr("disabled",true);
			$('input[name="sche_dotw"]').attr("disabled",true);
			$('input[name="sche_week"]').removeAttr("checked");
			$('input[name="sche_dotw"]').removeAttr("checked");
		} else {
			$("select[name='sche_dt']").attr("disabled",true);
			$('input[name="sche_week"]').removeAttr("disabled");
			$('input[name="sche_dotw"]').removeAttr("disabled");
			$("select[name='sche_dt']").val(0);
		}
	}
	
	/*------------------------------------------------------------------------------
	 * 1. 함 수 명    : 지정일자 1~4회에 1~31일 넣기
	 * 2. 입 력 변 수 : N/A
	 * 3. 출 력 변 수 : N/A
	 ------------------------------------------------------------------------------*/
	function sche_dt_month(){
	 	$("select[name='sche_dt']").val(0);
		var name = 'sche_dt';
		for(var j = 1; j< 7; j++) {
			for(var i = 1; i<32; i++){
				$('#'+name+j).append('<option name="optionDate" value="' + i + '">' + i +"일"+ '</option>') ;
			}
		}
	}
    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 엑셀 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Excel(){
   		fn_ExcelDownlad('mainGrid', '경매일자 정보');
    }
	
////////////////////////////////////////////////////////////////////////////////
// 그리드 끝
////////////////////////////////////////////////////////////////////////////////
	
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
                    <table>
                        <colgroup>
                            <col width="150">
                            <col width="250">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">조합명</th>
                                <td>
                                    <input type="text" id="search_clntnm"  maxlength="30" >                                        
                                </td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">경매일자 정보</p> </li>
                </ul>
                
                <div class="fl_R">
                    <button class="tb_btn" name="btn_Init" value="입력초기화">입력초기화</button>
                </div> 
            </div> 
                
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_AucDateInfo" name="frm_AucDateInfo">
	                    <table>
	                        <colgroup>
	                            <col width="100">
	                            <col width="*">
	                            <col width="100">
	                            <col width="*">
	                            <col width="100"> 
	                            <col width="*">     
	                        </colgroup>
	                        <tbody>
	                            <tr>
	                                <th scope="row">지역</th>
                                    <td  >
	                                    <select  id="na_bzplcloc"></select>
	                                </td>
	                                <th scope="row">조합</th>
	                                <td  >
		                                    <select  id="na_bzplc" ></select>
<!-- 			                                    <input type="hidden"  id="na_bzplc"> -->
	                                </td>
	                                <th scope="row"><span >경매대상</span></th>
	                  				   	<td >
											 <div class="cellBox" id="auc_obj_dsc"></div>
                                 				  <input type="hidden" id="hd_auc_obj_dsc" name="hd_auc_obj_dsc">
										</td>                   
		                       			 <!-- <td id="radio" class="radio" >
		                                	 <input type="radio" name="srch_con" id="cb_auc_obj_dsc1"  value="1"><label for="cb_auc_obj_dsc1">송아지</label>
		                                 	 <input type="radio" name="srch_con" id="cb_auc_obj_dsc2"  value="2"><label for="cb_auc_obj_dsc2">비육우</label> 
		                                     <input type="radio" name="srch_con" id="cb_auc_obj_dsc3"  value="3"><label for="cb_auc_obj_dsc3">번식우</label> 
		                                 	 <input type="radio" name="srch_con" id="cb_auc_obj_dsc0"  value="0"><label for="cb_auc_obj_dsc0">일괄</label> 
		                                 </td>      -->
	                            </tr>
	                            <tr>
	                            	<th scope="row">거래일</th>	
	                            	<td >
	                            	 	<input type="text" id="aucdt_det" maxlength="30" >
	                            	</td>
	                            	<th scope="row">연락처</th>
	                            	<td >
	                                    <input type="text" id="telno"  maxlength="14">
	                                </td>                
	                            </tr>
                                <tr>
	                            	<th scope="row">시장주소 </th>	
	                            	<td colspan="1" >
	                                    <input type="text" id="addr1"  maxlength="30">
	                                </td>                
	                            	<th scope="row">상세주소</th>	
	                            	<td colspan="3">		
	                                    <input type="text" id="addr2"  maxlength="30">
	                                </td>                
	                            </tr>
	                            <tr>
	                            	<th scope="row">지정일자 <input type="radio"  id="sche_dt_gb_1" value="1"name="sche_dt_gb" 
	                            																	onclick="javascript:fn_setChgRadio('sche_dt_gb','1');fn_setRadioChecked('sche_dt_gb');"/>
	                              	<input type="hidden"  id="sche_dt_gb" name="sche_dt_gb"  > <!-- sche_dt_gb ==  지정일 : 1 / 지정요일 : 2 -->
	                            	</th>	
	                            	<td  colspan="5">
	                            		<input type="hidden"  id="sche_dt" name="sche_dt_arr"> 
	                                    <select id="sche_dt1"  name="sche_dt" class="sche_dt"  style="width:15%;"><option value="0" disabled selected hidden>1회</option></select>
	                                    <select id="sche_dt2"  name="sche_dt" class="sche_dt"  style="width:15%;"><option value="0" disabled selected hidden>2회</option></select>
	                                    <select id="sche_dt3"  name="sche_dt"  class="sche_dt" style="width:15%;"><option value="0" disabled selected hidden>3회</option></select>
	                                    <select id="sche_dt4"  name="sche_dt" class="sche_dt"  style="width:15%;"><option value="0" disabled selected hidden>4회</option></select>
	                                    <select id="sche_dt5"  name="sche_dt" class="sche_dt"  style="width:15%;"><option value="0" disabled selected hidden>5회</option></select>
	                                    <select id="sche_dt6"  name="sche_dt" class="sche_dt"  style="width:15%;"><option value="0" disabled selected hidden>6회</option></select>
	                            	</td>
	                            </tr>
	                            <tr>
	                            	<th rowspan="2">지정요일 <input type="radio" id="sche_dt_gb_2"  value="2" name="sche_dt_gb"  
	                            																	onclick="javascript:fn_setChgRadio('sche_dt_gb','2');fn_setRadioChecked('sche_dt_gb');"/>
	                            	</th>	
	                            	<td colspan="5">
	                            		<input type="hidden"  id="sche_week" name="sche_week_arr"> <!-- mapper에서 쓸 값. -->
	                            		<input type="checkbox" id="sche_week1" value="1" name="sche_week" class="sche_week" ><label id="sche_week1_text" for="sche_week1"> 1주&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_week2" value="2" name="sche_week" class="sche_week" ><label id="sche_week2_text" for="sche_week2"> 2주&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_week3" value="3" name="sche_week" class="sche_week" ><label id="sche_week3_text" for="sche_week3"> 3주&nbsp;&nbsp;</label>                  
	                                    <input type="checkbox" id="sche_week4" value="4" name="sche_week" class="sche_week" ><label id="sche_week4_text" for="sche_week4"> 4주&nbsp;&nbsp;</label>                   
	                                    <input type="checkbox" id="sche_week5" value="5" name="sche_week" class="sche_week" ><label id="sche_week5_text" for="sche_week5"> 5주(마지막주)</label>              
	                            	</td>
	                            </tr>
	                            <tr>
	                            	<td colspan="5">
	                            		<input type="hidden"  id="sche_dotw">  <!-- mapper에서 쓸 값. -->
	                            		<input type="checkbox" id="sche_dotw2" class="sche_dotw" name="sche_dotw" value="2"> <label for="sche_dotw2">월&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_dotw3" class="sche_dotw" name="sche_dotw" value="3"> <label for="sche_dotw3">화&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_dotw4" class="sche_dotw" name="sche_dotw" value="4"> <label for="sche_dotw4">수&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_dotw5" class="sche_dotw" name="sche_dotw" value="5"> <label for="sche_dotw5">목&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_dotw6" class="sche_dotw" name="sche_dotw" value="6"> <label for="sche_dotw6">금&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_dotw7" class="sche_dotw" name="sche_dotw" value="7"> <label for="sche_dotw7">토&nbsp;&nbsp;</label>
	                                    <input type="checkbox" id="sche_dotw1" class="sche_dotw" name="sche_dotw" value="1"> <label for="sche_dotw1">일&nbsp;&nbsp;</label>
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
    <table id="mainGrid" style="width: 100%;">
    </table>
</div>
            
        </section>       
        
    </div>
</body>
</html>