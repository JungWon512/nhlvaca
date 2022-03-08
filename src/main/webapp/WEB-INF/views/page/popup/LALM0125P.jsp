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
            <table id="grd_MmMwmn">
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
    	//그리드 초기화
        fn_CreateGrid();
    	
        if(pageInfo.param){
        	//폼 초기화
            fn_InitFrm('frm_Search');
            $("#sra_mwmnnm").val(pageInfo.param.sra_mwmnnm);  
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
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MmMwmn");             
        
        $("#grd_MmMwmn").jqGrid("hideCol","MWMN_NA_TRPL_C");
        $("#grd_MmMwmn").jqGrid("hideCol","FRLNO");
        $("#grd_MmMwmn").jqGrid("hideCol","TMS_YN");
        $("#grd_MmMwmn").jqGrid("hideCol","DEL_YN");
        $("#grd_MmMwmn").jqGrid("hideCol","RMK_CNTN");
        $("#v_trmn_amnno").hide();        
    
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      	 
     	//그리드 초기화
     	$("#grd_MmMwmn").jqGrid("clearGridData", true);
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
	 	$( "#v_trmn_amnno" ).val().clear;
	 	
    	if (fn_isNull($("#sra_mwmnnm").val())){
        		MessagePopup('OK','중도매인명을 한글자 이상입력하세요.');
                return;
       	}	 
	 	
	 	if( fn_isNum($( "#sra_mwmnnm" ).val()) && fn_isChar($( "#sra_mwmnnm" ).val()) ){
	     	$( "#v_trmn_amnno" ).val('2');
	    }else if( fn_isNum($( "#sra_mwmnnm" ).val()) ){
	     	$( "#v_trmn_amnno" ).val('1');
	    }else{
	     	$( "#v_trmn_amnno" ).val('2');
	    }         
        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0125P_selList", "POST");        
        var result;
        
     	//그리드 초기화
     	$("#grd_MmMwmn").jqGrid("clearGridData", true); 
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
        }        
        fn_CreateGrid(result);                 
    } 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 선택함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Select(){     
        var sel_rowid = $("#grd_MmMwmn").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_MmMwmn").jqGrid("getRowData", sel_rowid);
        
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
        
        var searchResultColNames = ["중도매인번호", "중도매인<br>거래처코드", "중도매인명", "실명번호<br>(앞6자리)","우편번호","동이상주소","동이하주소","자택 전화번호","휴대폰 번호","조합원여부","관내외<br>구분코드","개인정보제공<br>동의여부", "전송여부", "삭제여부", "비고", "인증번호", "불량거래인<br>여부" ];        
        var searchResultColModel = [
                                     {name:"TRMN_AMNNO"			, index:"TRMN_AMNNO"		, width:80,  align:'center'},
                                     {name:"MWMN_NA_TRPL_C" 	, index:"MWMN_NA_TRPL_C"	, width:80,  align:'center'},
                                     {name:"SRA_MWMNNM"			, index:"SRA_MWMNNM"		, width:80,  align:'center'},
                                     {name:"FRLNO"				, index:"FRLNO"				, width:80,  align:'center'},
                                     {name:"ZIP"				, index:"ZIP"				, width:60,  align:'center'},
                                     {name:"DONGUP"				, index:"DONGUP"			, width:100, align:'left'},
                                     {name:"DONGBW"				, index:"DONGBW"			, width:100, align:'left'},
                                     {name:"OHSE_TELNO"			, index:"OHSE_TELNO"		, width:90,  align:'center'},
                                     {name:"CUS_MPNO"			, index:"CUS_MPNO"			, width:90,  align:'center'},
                                     {name:"MACO_YN"			, index:"MACO_YN"			, width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
                                     {name:"JRDWO_DSC"			, index:"JRDWO_DSC"			, width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"PSN_INF_OFR_AGR_YN" , index:"PSN_INF_OFR_AGR_YN", width:100,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"TMS_YN"				, index:"TMS_YN"			, width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"DEL_YN"				, index:"DEL_YN"			, width:160, align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"RMK_CNTN"			, index:"RMK_CNTN"			, width:100,  align:'center'},
                                     {name:"SMS_NO"			    , index:"SMS_NO"			, width:70,  align:'center', hidden:true},
                                     {name:"BAD_TRMN_AMNNO"		, index:"BAD_TRMN_AMNNO"	, width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     
                                     ];
            
        $("#grd_MmMwmn").jqGrid("GridUnload");
                
        $("#grd_MmMwmn").jqGrid({
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
        $("#grd_MmMwmn").jqGrid("hideCol","MWMN_NA_TRPL_C");
        $("#grd_MmMwmn").jqGrid("hideCol","FRLNO");
        $("#grd_MmMwmn").jqGrid("hideCol","TMS_YN");
        $("#grd_MmMwmn").jqGrid("hideCol","DEL_YN");
        $("#grd_MmMwmn").jqGrid("hideCol","RMK_CNTN");        
        //가로스크롤 있는경우 추가
        $("#grd_MmMwmn .jqgfirstrow td:last-child").width($("#grd_MmMwmn .jqgfirstrow td:last-child").width() - 17);
        
    }
    
</script>
</html>