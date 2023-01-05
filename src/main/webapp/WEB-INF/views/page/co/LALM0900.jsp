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

<style>
.ui-jqgrid .ui-state-highlight{border:1px solid #dddddd;background:white;}
</style>
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
        fn_CreateGrid();        
        fn_Init();
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //폼 초기화
        fn_InitFrm('frm_Search');
        $('#na_bzplc').val(App_na_bzplc);
        $('#blbd_dsc').val("1");
        $("#mainGrid").jqGrid("clearGridData", true);
        $("#pager").hide();
        fn_Search();
        
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
    	$("#mainGrid").jqGrid("clearGridData", true);
        $("#pager").hide();
        var results = sendAjaxFrm("frm_Search", "/LALM0900_selList", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
            fn_CreateGrid(result);
        }                       
    } 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 등록 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Insert(){                
    	var pgid = 'LALM0900P1';
        var menu_id = $("#menu_info").attr("menu_id");
        var data = new Object();
        data['blbd_dsc'] = $("#blbd_dsc").val();
        parent.layerPopupPage(pgid, menu_id, data, null, 1000, 600,function(result){
        	if(result){
                fn_Search();
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
    	TitleData.title = "공지사항 관리";
    	TitleData.sub_title = "";
    	TitleData.unit="";
    	TitleData.srch_condition=  '[검색내용 : ' + $('#bbrd_tinm_cntn').val()+ ']';
    	
    	ReportPopup('LALM0900R',TitleData, 'mainGrid', 'V');
    		
    	}
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    //그리드 생성
    function fn_CreateGrid(data){              
        
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
        
       	var searchResultColNames = ["H사업장코드","H게시판구분","H댓글번호","고정여부","게시글번호","제목", "등록자","등록일","조회건수"];        
        var searchResultColModel = [
        	                         {name:"NA_BZPLC",         index:"NA_BZPLC",     width:80, align:'center',hidden:true},
        	                         {name:"BLBD_DSC",         index:"BLBD_DSC",     width:80, align:'center',hidden:true},
                                     {name:"RL_SQNO",          index:"RL_SQNO",      width:80, align:'center',hidden:true},
                                     {name:"FIX_YN",           index:"FIX_YN",       width:80, align:'center',hidden:true},
        	                         {name:"BBRD_SQNO",        index:"BBRD_SQNO",    width:100, align:'center'},
						        	 {name:"BBRD_TINM",        index:"BBRD_TINM",    width:500, align:'left'},
                                     {name:"USRNM",            index:"USRNM",        width:100, align:'center'},
                                     {name:"FSRG_DTM",         index:"FSRG_DTM",     width:150, align:'center'},
                                     {name:"BBRD_INQ_CN",      index:"BBRD_INQ_CN",  width:100, align:'center'},
                                    ];
            
        $("#mainGrid").jqGrid("GridUnload");
                
        $("#mainGrid").jqGrid({
            datatype:    "local",
            data:        data,
            height:      550,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   true,
            shrinkToFit: false,
            rownumbers:  true,
            pager :     "#pager",
            rownumWidth: 40,
            colNames: searchResultColNames,
            colModel: searchResultColModel,
            ondblClickRow: function(rowid, status, e){
            	var pgid = 'LALM0900P1';
                var menu_id = $("#menu_info").attr("menu_id");
                var data = new Object();
                data['blbd_dsc'] =  $("#mainGrid").jqGrid('getCell', rowid, 'BLBD_DSC');
                data['bbrd_sqno'] =  $("#mainGrid").jqGrid('getCell', rowid, 'BBRD_SQNO');
                data['rl_sqno'] =  $("#mainGrid").jqGrid('getCell', rowid, 'RL_SQNO');
                parent.layerPopupPage(pgid, menu_id, data, null, 1000, 600,function(result){
                      if(result){
                    	  fn_Search();
                      }
                });
           },
           loadComplete:function(){
        	   var ids = $("#mainGrid").getDataIDs();
        	   $.each(ids,function(idx,rowld){
        		   var rowdata = $("#mainGrid").getRowData(rowld);
        		   if(rowdata.FIX_YN == '1'){
        			   $("#mainGrid").setRowData(rowld,false ,{color:'#a8104d',background:'#fdf890'});
        		   } 
        	   });
           },
        });
        
        $("#mainGrid").jqGrid("setLabel", "rn","No");
        
    }
	////////////////////////////////////////////////////////////////////////////////
    //  그리드 함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    
    
    
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">조회조건</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <form id="frm_Search" name="frm_Search">
                    <input type="hidden" id="na_bzplc">
                    <input type="hidden" id="blbd_dsc">
                    <table>
                        <colgroup>
                            <col width="100">
                            <col width="150">
                            <col width="300">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">검색내용<strong class="req_dot">*</strong></th>
                                <td>
                                    <select id="cb_condi">
                                    	<option value="1">제목</option>
                                    	<option value="2">내용</option>
                                    	<option value="3">작성자</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" id="bbrd_tinm_cntn">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
            
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul>
            </div>
            <div class="listTable rsp_v">
                <table id="mainGrid" style="width:100%;">
                </table>
                <!-- 페이징 -->
                <div id="pager"></div>
            </div>
            
        </section>       
    </div>
</body>
</html>