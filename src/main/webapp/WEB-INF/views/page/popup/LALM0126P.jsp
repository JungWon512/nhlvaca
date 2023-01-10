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
                <li><p class="dot_allow" >도로명으로 검색</p></li>
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
	                        <th scope="row">시도</th>
	                        <td>
	                            <select id="provnm"></select>
	                        </td>
	                        <th scope="row">시군구</th>
	                        <td>
	                            <select id="ccwnm"></select>
	                        </td>     
	                    </tr>
	                    <tr>
	                        <th scope="row">도로명</th>
	                        <td>
	                            <input type='text' id="adr_rodnm"/>
	                        </td>
	                        <th scope="row" colspan="2">읍면동으로 검색<strong class="req_dot">*</strong></th>
	                    </tr>
	                    <tr>
                            <th scope="row">건물명</th>
                            <td>
                                <input type='text' id="adr_bldnm1">
                            </td>
                            <th scope="row">읍면동</th>
                            <td>
                                <input type='text' id="ttvnm">
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
            <!-- //blueTable e -->
        </div>
        <div class="tab_box clearfix">
            <ul class="tab_list">
                <li><p class="dot_allow">검색내용</p></li>
            </ul>
        </div>
        
        <div class="listTable">           
            <table id="grd_BcRodnm">
            </table>
        </div>
    </div>
    <!-- //pop_body e -->
</body>
<script type="text/javascript">
var tbl_povnm;
var tbl_ccwnm;
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
        
    	//시도 조회
    	var results = sendAjaxFrm("", "/LALM0126P_selListProv", "POST");
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
        }else{      
        	tbl_povnm = setDecrypt(results);
        }
        
        //시군 조회
        var results_ccw = sendAjaxFrm("", "/LALM0126P_selListCcw", "POST");
        if(results_ccw.status != RETURN_SUCCESS){
            showErrorMessage(results_ccw,'NOTFOUND');
        }else{      
        	tbl_ccwnm = setDecrypt(results_ccw);
        }
                 
        fn_setProvnm();
        fn_ChangeProvnm();
        
        /******************************
         * 시도변경 변경
         ******************************/
        $("#provnm").bind('change',function(e){
            e.preventDefault();
            fn_ChangeProvnm(tbl_povnm);
        });
    	
    	
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
     	//그리드 초기화
     	$("#grd_BcRodnm").jqGrid("clearGridData", true);
         //폼 초기화
        fn_InitFrm('frm_Search');
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
    	 
    	if (fn_isNull($("#adr_bldnm1").val())
    	    && fn_isNull($("#adr_rodnm").val()) 
    	    && fn_isNull($("#ttvnm").val())){
    		MessagePopup('OK','도로명/건물명/읍면동 중 하나 이상 입력하세요.');
            return;
    	}
   	      
        //그리드 초기화
        $("#grd_BcRodnm").jqGrid("clearGridData", true);
        
        var results = sendAjaxFrm("frm_Search", "/LALM0126P_selList", "POST");        
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
        var sel_rowid = $("#grd_BcRodnm").jqGrid("getGridParam", "selrow");        
        pageInfo.returnValue = $("#grd_BcRodnm").jqGrid("getRowData", sel_rowid);
        
        var parentInput =  parent.$("#pop_result_" + pageInfo.popup_info.PGID );
        parentInput.val(true).trigger('change');
    }  
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    function fn_setProvnm(){
    	$("#provnm").empty().data('options');
        $.each(tbl_povnm, function(i){
            var v_simp_nm = '' + tbl_povnm[i].PROVNM;
            $("#provnm").append('<option>' + v_simp_nm + '</option>');
        });
    }
    
    //시도변경시 이벤트
    function fn_ChangeProvnm(){    	
    	$("#ccwnm").empty().data('options');    	
        $.each(tbl_ccwnm, function(i){
        	if(tbl_ccwnm[i].PROVNM == $("#provnm").val()){
                var v_simp_nm = '' + tbl_ccwnm[i].CCWNM;
                $("#ccwnm").append('<option>' + v_simp_nm + '</option>');
        	}
        });
    }
    
    //그리드 생성
    function fn_CreateGrid(data){              
        
        var rowNoValue = 0;     
        if(data != null){
            rowNoValue = data.length;
        }
        
        var searchResultColNames = ["우편번호", "도로명주소", "지번주소", "도로명코드","도로명일련번호"
        	                       ,"동이상주소","동이하주소", "읍명도명", "시군구건물명", "리명"
        	                       ,"산여부", "지번본번호", "지번부번호",
        	                      ];        
        var searchResultColModel = [
						             {name:"ZIP",          index:"ZIP",          width:30,  align:'center'},
                                     {name:"RODNM_ADR",    index:"RODNM_ADR",    width:120,  align:'left'},
						             {name:"ADR",          index:"ADR",          width:120,  align:'left'},
                                     {name:"RODNM_C", 	   index:"RODNM_C", 	 width:90,  align:'center', hidden:true},
                                     {name:"RODNM_SQNO",   index:"RODNM_SQNO", 	 width:90,  align:'center', hidden:true},
                                     {name:"DONGUP",       index:"DONGUP",       width:90,  align:'center', hidden:true},
                                     {name:"DONGBW",       index:"DONGBW",       width:90,  align:'center', hidden:true},
                                     {name:"TTVNM",        index:"TTVNM",        width:80,  align:'center', hidden:true},                       
                                     {name:"CCW_BLDNM",    index:"CCW_BLDNM",    width:80,  align:'center', hidden:true},
                                     {name:"RINM",         index:"RINM",         width:60,  align:'center', hidden:true},
                                     {name:"MONT_YN",      index:"MONT_YN",      width:60,  align:'left', hidden:true},
                                     {name:"LTNO_MAIN_NO", index:"LTNO_MAIN_NO", width:60,  align:'left', hidden:true},
                                     {name:"LTNO_ASST_NO", index:"LTNO_ASST_NO", width:90,  align:'center', hidden:true},
                                     
                                     ];
            
        $("#grd_BcRodnm").jqGrid("GridUnload");
                
        $("#grd_BcRodnm").jqGrid({
            datatype:    "local",
            data:        data,
            height:      280,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, row, col){                
                fn_Select();
                
           },
        });         
        //행번호
        $("#grd_BcRodnm").jqGrid("setLabel", "rn","No");
    }
</script>
</html>