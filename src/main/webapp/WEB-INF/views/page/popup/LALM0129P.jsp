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
                <li><p class="dot_allow" >검색조건 </p></li>
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
                        <col width="85">
                        <col width="*">
                        <col width="85">
                        <col width="*">                                                
                    </colgroup>
                    <tbody>
                            <tr>
                                <th scope="row">경매대상</th>
                                <td>
<!--                                     <select disabled="disabled" id="auc_obj_dsc"></select> -->
                                    <select id="auc_obj_dsc"></select>
                                </td>
                                <th scope="row">경매일자</th>
                                <td>
                                    <div class="cellBox">
<!--                                         <div class="cell"><input disabled="disabled" type="text" class="date" id="auc_dt"></div> -->
                                        <div class="cell"><input type="text" class="date" id="auc_dt"></div>
                                    </div>
                                </td>
	                            <th><span class="tb_dot">중도매인명</span></th>
	                            <td><input type="text" id="sra_mwmnnm"></td> 
	                            <td><input type="text" id="v_trmn_amnno"></td>     
                            </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">검색결과</p></li>
            </ul>
        </div>
        
        <div class="listTable">           
            <table id="grd_MmMwmnNo">
            </table>
        </div>
    </div>
    <!-- //pop_body e -->
</body>
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
    	fn_setCodeBox("auc_obj_dsc", "AUC_OBJ_DSC", 2, true);
//    	$( "#auc_dt"   ).datepicker().datepicker("setDate", fn_getToday());

 //       ******** 검색 결과가 1개 시 자동선택 기능 ********
// 		result_flag = "" ;
    	//그리드 초기화
        fn_CreateGrid();
        
        if(pageInfo.param){
        	//폼 초기화
            fn_InitFrm('frm_Search');        	
         	$("#auc_obj_dsc").val(pageInfo.param.auc_obj_dsc);    
         	$("#auc_dt").val(pageInfo.param.auc_dt);    
         	$("#sra_mwmnnm").val(pageInfo.param.sra_mwmnnm);  
         	
    	 	$( "#v_trmn_amnno" ).val().clear;
    	 	if( fn_isNum($( "#sra_mwmnnm" ).val()) && fn_isChar($( "#sra_mwmnnm" ).val()) ){
    	     	$( "#v_trmn_amnno" ).val('2');
    	    }else if( fn_isNum($( "#sra_mwmnnm" ).val()) ){
    	     	$( "#v_trmn_amnno" ).val('1');
    	    }else{
    	     	$( "#v_trmn_amnno" ).val('2');
    	    }  
    	 	
        	if( pageInfo.result != null){
        		fn_CreateGrid(pageInfo.result);
        	}
            $("#sra_mwmnnm").focus();
        }else {
            fn_Init();
        }
        
    	// enter로 조회
		$('#sra_mwmnnm').on('keydown',function(e){
			if(e.keyCode==13){
				 fn_Search();
		    	return;
			}
		});
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MmMwmnNo");           
        
        $("#grd_MmMwmnNo").jqGrid("hideCol","FRLNO");
        $("#grd_MmMwmnNo").jqGrid("hideCol","ZIP");
        $("#grd_MmMwmnNo").jqGrid("hideCol","DONGUP");
        $("#grd_MmMwmnNo").jqGrid("hideCol","DONGBW");
        $("#grd_MmMwmnNo").jqGrid("hideCol","OHSE_TELNO");
        $("#grd_MmMwmnNo").jqGrid("hideCol","MACO_YN");
        $("#grd_MmMwmnNo").jqGrid("hideCol","JRDWO_DSC");
        $("#grd_MmMwmnNo").jqGrid("hideCol","TMS_YN");
        $("#grd_MmMwmnNo").jqGrid("hideCol","DEL_YN");
        $("#grd_MmMwmnNo").jqGrid("hideCol","AUC_ENTR_GRN_AM");
        $("#grd_MmMwmnNo").jqGrid("hideCol","MWMN_NA_TRPL_C");   
        $("#v_trmn_amnno").hide();
    
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
    	 
     	//그리드 초기화
     	$("#grd_MmMwmnNo").jqGrid("clearGridData", true);
         //폼 초기화
        fn_InitFrm('frm_Search');
        $("#sra_mwmnnm").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){   
  
    	 if(fn_isNull( $('#sra_mwmnnm').val() )){
    			MessagePopup('OK', '중도매인명을 입력해주세요.', function(){
    				$( "#sra_mwmnnm" ).focus();
    			});
    			return;
    	 }
    	 
	 	$( "#v_trmn_amnno" ).val().clear;
	 	if( fn_isNum($( "#sra_mwmnnm" ).val()) && fn_isChar($( "#sra_mwmnnm" ).val()) ){
	     	$( "#v_trmn_amnno" ).val('2');
	    }else if( fn_isNum($( "#sra_mwmnnm" ).val()) ){
	     	$( "#v_trmn_amnno" ).val('1');
	    }else{
	     	$( "#v_trmn_amnno" ).val('2');
	    }        
	 	
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0129P_selList", "POST");        
        var result;
     	//그리드 초기화
     	$("#grd_MmMwmnNo").jqGrid("clearGridData", true); 
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        fn_CreateGrid(result); 
 //       ******** 검색 결과가 1개 시 자동선택 기능 ********
//         if(result.length == 1){
//         	 result_flag = 1 ;
//         	 fn_Select(result_flag);
//         }
    } 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 선택함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Select(sel_rowid){     
 //       ******** 검색 결과가 1개 시 자동선택 기능 ********
//         if(result_flag == 1){
//      	   pageInfo.returnValue = $("#grd_MmMwmnNo").jqGrid("getRowData", 1);
//         } else {
	        var sel_rowid = $("#grd_MmMwmnNo").jqGrid("getGridParam", "selrow");        
//         }
       	pageInfo.returnValue = $("#grd_MmMwmnNo").jqGrid("getRowData", sel_rowid);
        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
        parentInput.val(true).trigger('change');
    }  
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
    
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["응찰자명", "응찰자번호", "응찰기번호", "휴대폰 번호","거래확정구분","응찰기반납","개인정보제공<br>동의여부", "경매일자"
        	                      , "실명번호", "우편번호", "동이상주소", "동이하주소", "자택전화번호", "조합원여부", "관내외구분코드", "전송여부", "삭제여부", "경매참가보증금액", "중도매인경제통합거래처코드"
        	                      ];        
        var searchResultColModel = [
						             {name:"SRA_MWMNNM"			, index:"SRA_MWMNNM"		, width:80,  align:'center'},
                                     {name:"TRMN_AMNNO"			, index:"TRMN_AMNNO"		, width:80,  align:'center'},
						             {name:"LVST_AUC_PTC_MN_NO"	, index:"LVST_AUC_PTC_MN_NO", width:80,  align:'center'},
                                     {name:"CUS_MPNO"			, index:"CUS_MPNO"			, width:90,  align:'center'},
                                     {name:"TR_DFN_YN"			, index:"TR_DFN_YN"			, width:90,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"RTRN_YN"			, index:"RTRN_YN"			, width:90,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"PSN_INF_OFR_AGR_YN" , index:"PSN_INF_OFR_AGR_YN", width:90,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"AUC_DT" 	        , index:"AUC_DT"			, width:80,  align:'center'},                                     
                                     {name:"FRLNO"				, index:"FRLNO"				, width:80,  align:'center'},
                                     {name:"ZIP"				, index:"ZIP"				, width:60,  align:'center'},
                                     {name:"DONGUP"				, index:"DONGUP"			, width:100, align:'left'},
                                     {name:"DONGBW"				, index:"DONGBW"			, width:100, align:'left'},
                                     {name:"OHSE_TELNO"			, index:"OHSE_TELNO"		, width:90,  align:'center'},
                                     {name:"MACO_YN"			, index:"MACO_YN"			, width:70,  align:'center'},
                                     {name:"JRDWO_DSC"			, index:"JRDWO_DSC"			, width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"TMS_YN"				, index:"TMS_YN"			, width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"DEL_YN"				, index:"DEL_YN"			, width:160, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"AUC_ENTR_GRN_AM"	, index:"AUC_ENTR_GRN_AM"	, width:70,  align:'center'},
                                     {name:"MWMN_NA_TRPL_C"		, index:"MWMN_NA_TRPL_C"	, width:70,  align:'center'},
                                     
                                     ];
            
        $("#grd_MmMwmnNo").jqGrid("GridUnload");
                
        $("#grd_MmMwmnNo").jqGrid({
            datatype:    "local",
            data:        data,
            height:      330,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
            	fn_Select();
                
           },
        });
        $("#grd_MmMwmnNo").jqGrid("hideCol","FRLNO");
        $("#grd_MmMwmnNo").jqGrid("hideCol","ZIP");
        $("#grd_MmMwmnNo").jqGrid("hideCol","DONGUP");
        $("#grd_MmMwmnNo").jqGrid("hideCol","DONGBW");
        $("#grd_MmMwmnNo").jqGrid("hideCol","OHSE_TELNO");
        $("#grd_MmMwmnNo").jqGrid("hideCol","MACO_YN");
        $("#grd_MmMwmnNo").jqGrid("hideCol","JRDWO_DSC");
        $("#grd_MmMwmnNo").jqGrid("hideCol","TMS_YN");
        $("#grd_MmMwmnNo").jqGrid("hideCol","DEL_YN");
        $("#grd_MmMwmnNo").jqGrid("hideCol","AUC_ENTR_GRN_AM");
        $("#grd_MmMwmnNo").jqGrid("hideCol","MWMN_NA_TRPL_C");          
        //가로스크롤 있는경우 추가
 //       $("#grd_MmMwmnNo .jqgfirstrow td:last-child").width($("#grd_MmMwmnNo .jqgfirstrow td:last-child").width() - 17);
        
    }
    
</script>
</html>