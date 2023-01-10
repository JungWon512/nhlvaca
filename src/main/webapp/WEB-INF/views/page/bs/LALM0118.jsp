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
    	
    	fn_Creategrd_MmBlack();
        
        $("#srch_trmn_amnno").bind("keyup", function(e){
        	fn_InitFrm('frm_MmBlackList');
            
            $("#btn_Save").attr('disabled', true);
            $("#btn_Delete").attr('disabled', true);
            
            fn_DisableFrm('frm_MmBlackList', true);
            $("#srch_trmn_amnno").focus();
        });
        
    	/******************************
        * [입력초기화] 버튼 클릭 시
        ******************************/
        $("#pb_Init").on('click',function(e){
            e.preventDefault();
            this.blur();
            fn_BtnInit();
        }); 
    	
        /******************************
         * 중도매인 검색(돋보기) 팝업 호출 이벤트
         ******************************/
    	$("#pb_sra_mwmnnm").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            fn_CallMwmnPopup("tbIn",false);
        });
        
        $("#limit_date").datepicker();
        
    	fn_Init();
    	
    	$("select[name='na_bzplcloc']").on("change", function(){
    		sel_clntnm();
    	});
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){
        //그리드 초기화
        $("#grd_BLIndv").jqGrid("clearGridData", true);
        
        //폼초기화
        fn_InitFrm('frm_Search');
        fn_InitFrm('frm_MmBlackList');
        
        $("#btn_Save").attr('disabled', true);
        $("#btn_Delete").attr('disabled', true);
        
        fn_DisableFrm('frm_MmBlackList', true);
        
        $("#auc_part_limit_yn").val($("input[name='auc_part_limit_yn']:checked").val());		//초기 경매참여 여부 값은 1로 셋팅
        $("#srch_trmn_amnno").focus();
        
        set_BzPlcLoc();
    }

    function set_BzPlcLoc(){	
		  
		var results = sendAjaxFrm("", "/LALM0118_selBzplcloc", "POST");
		var result;
		
		if(results.status != RETURN_SUCCESS){
		      showErrorMessage(results);
		      return;
		}else{      
			result = setDecrypt(results);
		         
		    var select = $("select[name='na_bzplcloc']");
		    var select2 = $("select[name='na_bzplc']");
		    
		    select.html("");
		    select2.html("");
		    select.attr("disabled", false);
		    select2.attr("disabled", false);
		    
		  	select.append( '<option value="">' + "지역을 선택하세요." + '</option>' );
		  	select2.append( '<option value=""  >' + "조합을 선택하세요." + '</option>' );
		    if (result.length > 0) {
			    for ( var r of result ) {
			    	select.append( '<option value="' + r.NA_BZPLCLOC  + '">' + r.NA_BZPLCLOC_NM + '</option>' );
			    }
		    }
		}        
	}
    
    function sel_clntnm(){
	    const op = $("option[name='na_bzplcnoVal']");
	    op.remove(); // 누적 값 삭제
	    
	    var na_bzplcloc = $("select[name='na_bzplcloc']").val();
	    const selecObj = { na_bzplcloc : na_bzplcloc }
		
		var results = sendAjax(selecObj, "/LALM0118_selClntnm", "POST");
		var result;
	
	    result = setDecrypt(results);
	    
	    $("select[name='na_bzplc']").innerHTML="";
	    
		for( let r of result) {
			$("select[name='na_bzplc']").append( '<option  id="'+ r.NA_BZPLCNO +'" name="na_bzplcnoVal" value="' + r.NA_BZPLC + '">' + r.CLNTNM + '</option>' );
		}
    }
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
        //그리드 초기화
        $("#grd_BLIndv").jqGrid("clearGridData", true);
        
        fn_DisableFrm('frm_MmBlackList', false); 	//해당 form 하위에 있는 요소들 disabled 해제하기   
        
        //수정되면 안되는 요소들은 계속 disabled 처리 하기
        $("#trmn_amnno").attr('disabled', true);
        $("#cus_rlno").attr('disabled', true);
        $("#cus_mpno").attr('disabled', true);
        $("#dongup").attr('disabled', true);
        $("#dongbw").attr('disabled', true);
        
        fn_setChgRadio("auc_part_limit_yn", "1");
        fn_setRadioChecked("auc_part_limit_yn");
    	 
    	//불량회원 조회
        var results = sendAjaxFrm("frm_Search", "/LALM0118_selList", "POST");
    	var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
             return;
        }else{     
        	result = setDecrypt(results);
        }
        
        fn_Creategrd_MmBlack(result);
             
    }    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수 (insert, update 둘다 같은 메소드에서 처리함)
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){
    	 
    	if($("#limit_date").val() == ''){
   		 	MessagePopup('OK','적용기한을 입력해주세요.');
            return;
   	 	}
         
   	 	if($("#reg_reason").val() == ''){
            MessagePopup('OK','B/L 사유를 입력해주세요.');
            return;
        }
   	 
	   	MessagePopup('YESNO',"저장하시겠습니까?",function(res){
	         if(res){
	             var results = sendAjaxFrm("frm_MmBlackList", "/LALM0118_insBlackList", "POST"); 
	             if(results.status != RETURN_SUCCESS){
	                 showErrorMessage(results);
	                 return;
	             }else{          
	                 MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
	                     fn_Search();
	                     fn_InitFrm('frm_MmBlackList');		 
	                 });
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
    	 
    	 MessagePopup('YESNO',"삭제하시겠습니까?",function(res){
             if(res){
                 var results = sendAjaxFrm("frm_MmBlackList", "/LALM0118_delBlack", "POST"); 
                 if(results.status != RETURN_SUCCESS){
                     showErrorMessage(results);
                     return;
                 }else{          
                     MessagePopup("OK", "정상적으로 처리되었습니다.", function(res){
                         fn_Search();
	                     fn_InitFrm('frm_MmBlackList');	
                     });
                 }      
             }else{
                 MessagePopup('OK','취소되었습니다.');
             }
         });
     }
     
     /*------------------------------------------------------------------------------
      * 1. 함 수 명    : 추가 함수 (중도매인 검색 팝업을 똑같이 띄우기)
      * 2. 입 력 변 수 : N/A
      * 3. 출 력 변 수 : N/A
      ------------------------------------------------------------------------------*/
     function fn_Insert(){
         fn_CallMwmnPopup("addBtn", false);
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
         fn_ExcelDownlad('grd_BLIndv', '개체관리');

     }   
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    //검색조건 결과 목록 grid 로 표현하기
    function fn_Creategrd_MmBlack(data){
    	var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
         
        var searchResultColNames = ["경제통합사업장코드","등록일련번호","소속조합","중도매인코드","중도매인명","생년월일/사업자번호","휴대폰","경매참여","B/L등록일자","B/L적용기한","B/L사유", "통합회원번호"];  
        var searchResultColModel = [                                                              
            {name:"NA_BZPLC",        index:"NA_BZPLC",        width:40, align:'center', hidden:true},
            {name:"REG_SEQ",        index:"REG_SEQ",        width:40, align:'center', hidden:true},
            {name:"CLNTNM",                 index:"CLNTNM",                 width:40, align:'center'},
            {name:"TRMN_AMNNO",        index:"TRMN_AMNNO",        width:40, align:'center', formatter:'gridIndvFormat'},
            {name:"SRA_MWMNNM",           index:"SRA_MWMNNM",           width:40, align:'center'},
            {name:"CUS_RLNO",             index:"CUS_RLNO",             width:40, align:'center'},
            {name:"CUS_MPNO",         index:"CUS_MPNO",         width:40, align:'center'},
            {name:"AUC_PART_LIMIT_YN",            index:"AUC_PART_LIMIT_YN",            width:40, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
            {name:"REG_DATE",                 index:"REG_DATE",                 width:40, align:'center', formatter:'gridDateFormat'},
            {name:"LIMIT_DATE",              index:"LIMIT_DATE",              width:40, align:'center', formatter:'gridDateFormat'},
            {name:"REG_REASON",                index:"REG_REASON",                width:40, align:'center'},
            {name:"MB_INTG_NO",                index:"MB_INTG_NO",                width:40, align:'center', hidden:true}
        ];
             
        $("#grd_BLIndv").jqGrid("GridUnload");
        
        $("#grd_BLIndv").jqGrid({
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
                var sel_data = $("#grd_BLIndv").getRowData(rowid);
                fn_setFrm_MmBlack(sel_data);
            },  
        });    
    
        //행번호
        $("#grd_BLIndv").jqGrid("setLabel", "rn","No");

    }
    
    //Grid 결과 목록에서 데이터 선택할 때, 불량회원 정보로 셋팅해주기
    function fn_setFrm_MmBlack(sel_data){
    	
        fn_InitFrm('frm_MmBlackList');
    	
        //동일한 조합만 수정, 삭제 가능하게끔 하기
        if(App_na_bzplc == sel_data.NA_BZPLC){
            $("#btn_Save").attr('disabled', false);
            $("#btn_Delete").attr('disabled', false);
            
            fn_DisableFrm('frm_MmBlackList', false);
          	//수정되면 안되는 요소들은 계속 disabled 처리 하기
            $("#trmn_amnno").attr('disabled', true);
            $("#cus_rlno").attr('disabled', true);
            $("#cus_mpno").attr('disabled', true);
            $("#dongup").attr('disabled', true);
            $("#dongbw").attr('disabled', true);
    	}
        else{
            $("#btn_Save").attr('disabled', true);
            $("#btn_Delete").attr('disabled', true);
            fn_DisableFrm('frm_MmBlackList', true);
    	}
        
        var srchData = new Object();
        srchData["na_bzplc"] = sel_data.NA_BZPLC;
        srchData["trmn_amnno"] = sel_data.TRMN_AMNNO;
        srchData["mb_intg_no"] = sel_data.MB_INTG_NO;
        srchData["reg_seq"] = sel_data.REG_SEQ;
        
        fn_setChgRadio("auc_part_limit_yn", sel_data.AUC_PART_LIMIT_YN);
        fn_setRadioChecked("auc_part_limit_yn");
    	
    	var results = sendAjax(srchData, "/LALM0118_selBlackDetail", "POST"); 
    	var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results, "NOTFOUND");
            return;
        }else{
        	result = setDecrypt(results);
        }
                
        fn_setFrmByObject("frm_MmBlackList", result);		//선택해서 가져온 값 셋팅하기
    }
    
    function fn_BtnInit(){
    	
        var call_result;
    	
        fn_DisableFrm('frm_MmBlackList', false);
        fn_InitFrm('frm_MmBlackList');

      	//수정되면 안되는 요소들은 계속 disabled 처리 하기
        $("#trmn_amnno").attr('disabled', true);
        $("#cus_rlno").attr('disabled', true);
        $("#cus_mpno").attr('disabled', true);
        $("#dongup").attr('disabled', true);
        $("#dongbw").attr('disabled', true);
        
        $("#sra_mwmnnm").focus();
        fn_setChgRadio("auc_part_limit_yn", "1");
        fn_setRadioChecked("auc_part_limit_yn");
        
        $("#btn_Save").attr('disabled', false);
        $("#btn_Delete").attr('disabled', true);
    }
    
  //**************************************
 	//function  : fn_CallMwmnPopup(중도매인 팝업 호출) 
 	//paramater : N/A 
 	// result   : N/A
 	//**************************************
 	function fn_CallMwmnPopup(selFlag, p_param) {
 		var checkBoolean = p_param;
 		var data = new Object();
 		
 		if(selFlag =="tbIn"){
	 		data['sra_mwmnnm'] = $("#sra_mwmnnm", $("#frm_MmBlackList")).val();
 		}else{
	 		data['sra_mwmnnm'] = $("#sra_mwmnnm", $("#frm_Search")).val();
 		}
        
 		fn_CallMwmnnmPopup(data,checkBoolean,function(result) {
 			if(result){
 				console.log(result)
 				if(result.BAD_TRMN_AMNNO == '1'){
 					MessagePopup('OK','이미 등록된 불량회원 입니다. 다른 중도매인을 선택해주세요.');
 		            return;
 				}else{
	 				$("#trmn_amnno").val(result.TRMN_AMNNO);
	 				$("#sra_mwmnnm", $("#frm_MmBlackList")).val(result.SRA_MWMNNM);
	 				$("#cus_rlno").val(result.CUS_RLNO);
	 				$("#cus_mpno").val(result.CUS_MPNO);
	 				$("#dongup").val(fn_xxsDecode(result.DONGUP));
	 				$("#dongbw").val(fn_xxsDecode(result.DONGBW));
	 				$("#mb_intg_no").val(result.MB_INTG_NO);
	 				$("#na_bzplc", $("#frm_MmBlackList")).val("");
	 				$("#reg_seq").val("");
 				}
 			} else {
 				$("#trmn_amnno").val("");
 				if(selFlag =="tbIn"){
	 				$("#sra_mwmnnm", $("#frm_MmBlackList")).val("");
 				}else{
	 				$("#sra_mwmnnm", $("#frm_Search")).val("");		
	 				$("#sra_mwmnnm", $("#frm_MmBlackList")).val("");	
 				}
 				$("#cus_rlno").val("");
 				$("#cus_mpno").val("");
 				$("#dongup").val("");
 				$("#dongbw").val("");
 				$("#mb_intg_no").val("");
 				$("#na_bzplc", $("#frm_MmBlackList")).val("");
 				$("#reg_seq").val("");
 			}
 			
 			$("#mb_intg_no").attr("disabled", false);
 			$("#reg_seq").attr("disabled", false);
 			$("#btn_Delete").attr("disabled", false);
 		});
 	}
    ////////////////////////////////////////////////////////////////////////////////
    //  팝업 함수 종료
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
                            <col width="150">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">중도매인</th>
                                <td>
                                    <input type="text" name="srch_trmn_amnno" id="srch_trmn_amnno" class="popup" maxlength="9">
                                </td>
                                <th scope="row">조합</th>
                                <td>
                                    <select name="na_bzplcloc" id="na_bzplcloc" style="width:30%;"></select>
                                    <select name="na_bzplc" id="na_bzplc" style="width:30%;"></select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <!-- 개체정보 -->
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">B/L(불량회원) 정보</p></li>
                </ul>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->
                    <button class="tb_btn" id="pb_Init">입력초기화</button>
                </div>
            </div>
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    <form id="frm_MmBlackList">
                        <input type="hidden" id="na_bzplc"/>
                        <input type="hidden" id="reg_seq"/>
                        <input type="hidden" id="mb_intg_no"/>
                        <table>
                            <colgroup>
                                <col width="10%">
	                            <col width="17%">
	                            <col width="10%">
	                            <col width="23%">
	                            <col width="10%">
	                            <col width="30%">
                            </colgroup>
                            <tbody>
                               <tr>
                                   <th>중도매인코드</th>
                                   <td>
                                       <input type="text" id="trmn_amnno" maxlength="15"/>
                                   </td>
                                   <th>중도매인</th>
                                   <td>
	                            		<input type="text" id="sra_mwmnnm" style="ime-mode:active;width:200px;" maxlength="20" />
	                            		<button id="pb_sra_mwmnnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                   </td>
                                   <th>경매참여</th>
                                   <td>
                                        <div class="cellBox" id="rd_auc_part_limit_yn">
	                                        <div class="cell">
	                                            <input type="radio" id="auc_part_limit_yn_1" name="auc_part_limit_yn" value="1" checked="checked"
	                                            	onclick="javascript:fn_setChgRadio('auc_part_limit_yn','1');fn_setRadioChecked('auc_part_limit_yn');"/>
	                                            <label>여</label>
	                                            <input type="radio" id="auc_part_limit_yn_0" name="auc_part_limit_yn" value="0" 
	                                            	onclick="javascript:fn_setChgRadio('auc_part_limit_yn','0');fn_setRadioChecked('auc_part_limit_yn');"/>
	                                            <label>부</label>
	                                        </div>
	                                    </div>
	                                    <input type="hidden" id="auc_part_limit_yn" />
                                   </td>
                               </tr>
                               <tr>
                                   <th>생년월일</th>
                                   <td>
                                   	   <input type="text" id="cus_rlno"/>
                                   </td>
                                   <th>연락처</th>
                                   <td>
                                       <input type="text" id="cus_mpno"/>
                                   </td>
                                   <th>주소</th>
                                   <td>
                                       <input type="text" id="dongup" style="width:150px;"/>
                                       <input type="text" id="dongbw" style="width:200px;"/>
                                   </td>
                               </tr>
                               <tr>
                                   <th>적용기한</th>
                                   <td>
                                       <div class="cellBox">
	                                       <div class="cell"><input type="text" class="date" id="limit_date" name="limit_date" maxlength="10"></div>
	                                   </div>
                                   </td>
                                   <th>B/L 사유</th>
                                   <td colspan="3">
                                       <input type="text" id="reg_reason"/>
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
                <table id="grd_BLIndv">
                </table>
                <!-- 페이징 -->
                <div id="pager"></div>
            </div>
        </section>
    </div>
<!-- ./wrapper -->
</body>
</html>