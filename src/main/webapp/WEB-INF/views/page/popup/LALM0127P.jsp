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
                        <col width="250">
                        <col width="*">
                        <col width="*">                           
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">농가명</th>
                            <td>
                                <input type="text" id="ftsnm"/>
                                <input type="hidden" id="auc_obj_dsc" />
                            </td>
                            <td></td>
                            <td></td>
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
            <table id="grd_MmFhs">
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
            $("#ftsnm").val(pageInfo.param.ftsnm); 
            $("#auc_obj_dsc").val(pageInfo.param.auc_obj_dsc??''); 
                        
            if( pageInfo.result != null){
                fn_CreateGrid(pageInfo.result);
            }
            $("#ftsnm").focus();
        }else {
            fn_Init();
        }
        $("#ftsnm").keydown(function(e) {
             if(e.keyCode == 13) {
	            fn_Search();
             	return;
             }
        });
               
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //그리드 초기화
        $("#grd_MmFhs").jqGrid("clearGridData", true);
        //폼 초기화
        fn_InitFrm('frm_Search');
        $("#ftsnm").focus();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){     
        //정합성체크
        if(fn_isNull($( "#ftsnm" ).val()) == true){
            MessagePopup('OK','농가명을 입력하세요.',function(){
                $( "#ftsnm" ).focus();
            });
            return;
        }
        $("#grd_MmFhs").jqGrid("clearGridData", true);
        var results = sendAjaxFrm("frm_Search", "/LALM0127P_selList", "POST");        
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
     * 1. 함 수 명    : 선택함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Select(){     
        var sel_rowid = $("#grd_MmFhs").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_MmFhs").jqGrid("getRowData", sel_rowid);
        
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
        
        var searchResultColNames = ["경제통합사업장코드","경제통합거래처코드","축산농장계좌번호","농가코드","농가명","농장관리번호"
        	                        ,"농장식별번호","예방접종일", "우편번호","동이상주소","동이하주소","자택전화번호","휴대폰번호"
        	                        ,"조합원여부","관내외<br>구분코드","사료사용<br>여부","비고내용"];        
        var searchResultColModel = [
        	                         {name:"NA_BZPLC",       index:"NA_BZPLC",       width:70,  align:'center', hidden:true},
        	                         {name:"NA_TRPL_C",      index:"NA_TRPL_C",      width:70,  align:'center', hidden:true},
        	                         {name:"SRA_FARM_ACNO",  index:"SRA_FARM_ACNO",  width:70,  align:'center', hidden:true},
                                     {name:"FHS_ID_NO",      index:"FHS_ID_NO",      width:70,  align:'center'},
                                     {name:"FTSNM",          index:"FTSNM",          width:80,  align:'center'},
                                     {name:"FARM_AMNNO",     index:"FARM_AMNNO",     width:80,  align:'center'},
                                     {name:"FARM_ID_NO",     index:"FARM_ID_NO",     width:80,  align:'center'},
                                     {name:"VACN_DT",        index:"VACN_DT",        width:80,  align:'center', formatter:'gridDateFormat', hidden:(ETC_AUC_OBJ_DSC === '')},
                                     {name:"ZIP",            index:"ZIP",            width:60,  align:'center'},
                                     {name:"DONGUP",         index:"DONGUP",         width:100, align:'left'},
                                     {name:"DONGBW",         index:"DONGBW",         width:100, align:'left'},
                                     {name:"OHSE_TELNO",     index:"OHSE_TELNO",     width:90,  align:'center'},
                                     {name:"CUS_MPNO",       index:"CUS_MPNO",       width:90,  align:'center'},
                                     {name:"MACO_YN",        index:"MACO_YN",        width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_MACO_YN_DATA}},
                                     {name:"JRDWO_DSC",      index:"JRDWO_DSC",      width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:fn_setCodeString("JRDWO_DSC", 1)}},
                                     {name:"SRA_FED_SPY_YN", index:"SRA_FED_SPY_YN", width:70,  align:'center', edittype:"select", formatter : "select", editoptions:{value:GRID_YN_DATA}},
                                     {name:"RMK_CNTN",       index:"RMK_CNTN",       width:160, align:'left',   },
                                     ];
            
        $("#grd_MmFhs").jqGrid("GridUnload");
                
        $("#grd_MmFhs").jqGrid({
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

        //행번호
        $("#grd_MmFhs").jqGrid("setLabel", "rn","No");
        
        //가로스크롤 있는경우 추가
        $("#grd_MmFhs .jqgfirstrow td:last-child").width($("#grd_MmFhs .jqgfirstrow td:last-child").width() - 17);
        
    }
</script>
</html>