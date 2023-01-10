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
                        <col width="85">
                        <col width="*">                        
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">거래처구분</th>
                            <td>
                                <select id="lvst_mkt_trpl_dsc"></select>
                            </td>                        
                            <th><span class="tb_dot">거래처명</span></th>
                            <td><input type="text" id="brkr_name"></td>
                            <td><input type="text" id="v_brkr_name_c"></td>                             
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
            <table id="grd_MmTrpl">
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
    	fn_setCodeBox("lvst_mkt_trpl_dsc", "LVST_MKT_TRPL_DSC", 1, true);    	
    	//그리드 초기화
        fn_CreateGrid();
    	
        if(pageInfo.param){
        	//폼 초기화
            fn_InitFrm('frm_Search');
            $("#lvst_mkt_trpl_dsc").val(pageInfo.param.lvst_mkt_trpl_dsc);         	
            $("#brkr_name").val(pageInfo.param.sra_mwmnnm);

            //거래처 구분값이 존재 할 시 버튼 비활성화
        	if(pageInfo.param.lvst_mkt_trpl_dsc != null){
        		$("#lvst_mkt_trpl_dsc").attr("disabled", true);
        	} else {
        		$("#lvst_mkt_trpl_dsc").val(1);
        	}
            
        	if( pageInfo.result != null){
        		fn_CreateGrid(pageInfo.result);
        	}
            $("#brkr_name").focus();
        }else {
            fn_Init();
        }        
        
        /******************************
         * 폼변경시 클리어 이벤트
         ******************************/   
        fn_setClearFromFrm("frm_Search","#grd_MmTrpl");       
        
        $("#grd_MmTrpl").jqGrid("hideCol","PR_RKON_CM_ALW");
        $("#grd_MmTrpl").jqGrid("hideCol","DEL_YN");
        $("#v_brkr_name_c").hide();        
    
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){      	 
     	//그리드 초기화
     	$("#grd_MmTrpl").jqGrid("clearGridData", true);
         //폼 초기화
         fn_InitFrm('frm_Search');
         $("#brkr_name").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){   
    	 $( "#v_brkr_name_c" ).val().clear;
    	if( fn_isNum($( "#brkr_name" ).val()) && fn_isChar($( "#brkr_name" ).val()) ){
        	$( "#v_brkr_name_c" ).val('2');
        }else if( fn_isNum($( "#brkr_name" ).val()) ){
        	$( "#v_brkr_name_c" ).val('1');
        }else{
        	$( "#v_brkr_name_c" ).val('2');
        }      	

        //정합성체크        
        var results = sendAjaxFrm("frm_Search", "/LALM0131P_selList", "POST");        
        var result;
        
     	//그리드 초기화
     	$("#grd_MmTrpl").jqGrid("clearGridData", true); 
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
        var sel_rowid = $("#grd_MmTrpl").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_MmTrpl").jqGrid("getRowData", sel_rowid);
        
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
        
        var searchResultColNames = ["거래처구분", "거래처코드", "경제통합<br>거래처코드", "거래처명","우편번호","동이상주소","동이하주소","자택 전화번호","가격산정위원수당","삭제여부","휴대폰 번호"];        
        var searchResultColModel = [
                                     {name:"LVST_MKT_TRPL_DSC"	, index:"LVST_MKT_TRPL_DSC"		, width:80,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("LVST_MKT_TRPL_DSC", 1)}},
                                     {name:"LVST_MKT_TRPL_AMNNO", index:"LVST_MKT_TRPL_AMNNO"	, width:80,  align:'center'},
                                     {name:"NA_TRPL_C"			, index:"NA_TRPL_C"				, width:80,  align:'center'},
                                     {name:"BRKR_NAME"			, index:"BRKR_NAME"				, width:80,  align:'center'},
                                     {name:"ZIP"				, index:"ZIP"					, width:60,  align:'center'},
                                     {name:"DONGUP"				, index:"DONGUP"				, width:100, align:'left'},
                                     {name:"DONGBW"				, index:"DONGBW"				, width:100, align:'left'},
                                     {name:"OHSE_TELNO"			, index:"OHSE_TELNO"			, width:90,  align:'center'},
                                     {name:"PR_RKON_CM_ALW"		, index:"PR_RKON_CM_ALW"		, width:100,  align:'center'},
                                     {name:"DEL_YN"				, index:"DEL_YN"				, width:160, align:'center'},
                                     {name:"CUS_MPNO"			, index:"CUS_MPNO"				, width:90,  align:'center'},                                     
                                     ];
            
        $("#grd_MmTrpl").jqGrid("GridUnload");
                
        $("#grd_MmTrpl").jqGrid({
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
        $("#grd_MmTrpl").jqGrid("hideCol","PR_RKON_CM_ALW");
        $("#grd_MmTrpl").jqGrid("hideCol","DEL_YN");
     
        //가로스크롤 있는경우 추가
        $("#grd_MmTrpl .jqgfirstrow td:last-child").width($("#grd_MmTrpl .jqgfirstrow td:last-child").width() - 17);
        
    }
    
</script>
</html>