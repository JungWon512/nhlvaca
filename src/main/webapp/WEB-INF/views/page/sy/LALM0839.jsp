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
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 시작
    ////////////////////////////////////////////////////////////////////////////////
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : onload 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/    
	 var wkGrpNm="";
    $(document).ready(function(){
    	
        fn_CreateGrid();
    	$( "#st_dt" ).datepicker().datepicker("setDate", fn_getDay(-7));
        $( "#ed_dt" ).datepicker().datepicker("setDate", fn_getToday());
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 배치 재실행 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_batchReExecForId(batchIdNum, batActDt){
    	 
    	var batchUrl = "/batch/batch_BJ_LM_" + batchIdNum;
    	var srchData = new Object();
        srchData["exec_flag"] = "Y";
        srchData["bat_act_dt"] = batActDt;
    	
        MessagePopup('YESNO',"배치 재실행 하시겠습니까?",function(res){
	         if(res){
	        	 var results = sendAjax(srchData, batchUrl, "POST"); 
	         	 var result;
	             if(results.status != RETURN_SUCCESS){
	                 showErrorMessage(results, "NOTFOUND");
	             }else{
	             	result = setDecrypt(results);
	             }
	             
            	 fn_Search();  
	         }else{
	             MessagePopup('OK','취소되었습니다.');
	         }
	     });
    	
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){
        $("#grd_MmBatLog").jqGrid("clearGridData", true);
        
        if(fn_isNull($("#st_dt").val())){
            MessagePopup('OK','조회 시작일자를 선택해주세요.');
            return;
        }
        
        if(fn_isNull($("#ed_dt").val())){
            MessagePopup('OK','조회 종료일자를 선택해주세요.');
            return;
        }
        
        var results = sendAjaxFrm("frm_Search", "/LALM0839_selList", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);            
            fn_CreateGrid(result);
        }
                        
    }

    function fn_CreateGrid(data){    	
        var rowNoValue = 0;
        if(data != null){
            rowNoValue = data.length;
        }
        var searchResultColNames = ["배치아이디","실행일자","차수","배치시작일시","배치종료일시","배치성공여부","배치결과메세지","배치재실행"];        
        var searchResultColModel = [
				{name:"BAT_ID",		index:"BAT_ID",	width:70,  sortable:false, align:'center'},
				{name:"BAT_ACT_DT",           	index:"BAT_ACT_DT",          width:70,  sortable:false, align:'center', formatter:'gridDateFormat'},                                    
                {name:"BAT_ACT_SEQ",         		index:"BAT_ACT_SEQ",         	width:50, sortable:false, align:'center'},
                {name:"BAT_ST_DTM",        index:"BAT_ST_DTM",    width:100, sortable:false, align:'center'},
                {name:"BAT_ED_DTM",         	index:"BAT_ED_DTM",      width:100,  sortable:false, align:'center'},
                {name:"BAT_SUC_YN",         	index:"BAT_SUC_YN",      width:70,  sortable:false, align:'center'},
                {name:"BAT_RST_MSG",           index:"BAT_RST_MSG",           width:260,  sortable:false, align:'center'},
                {name:"BAT_ID_NUM",            index:"BAT_ID_NUM",        width:70,  sortable:false, align:'center', formatter:function(cellvalue, options, rowObject){if(rowObject.BAT_SUC_YN == "S"){return "-";}else{return '<button type="button" class="tb_btn" onclick="fn_batchReExecForId(\''+rowObject.BAT_ID_NUM+'\', \''+rowObject.BAT_ACT_DT+'\');">재실행</button>'}}},                                     
		];
            
        $("#grd_MmBatLog").jqGrid("GridUnload");
                
        $("#grd_MmBatLog").jqGrid({
            datatype:    "local",
            data:        data,
            height:      550,
            rowNum:      rowNoValue,
            resizeing:   true,
            autowidth:   false,
            shrinkToFit: false, 
            rownumbers:true,
            rownumWidth:30,
            userDataOnFooter: true,
            colNames: searchResultColNames,
            colModel: searchResultColModel
        });
        
      	//행번호
        $("#grd_MmBatLog").jqGrid("setLabel", "rn","No");
    }
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
                    <table>
                        <colgroup>
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                            <col width="90">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">배치 아이디</th>
                                <td>
                                    <input type="text" id="srch_bat_id" style="width:80%;">
                                </td>
                                <th scope="row">조회일자</th>
                                <td>
                                    <div class="cellBox">
                                        <div class="cell"><input type="text" class="date" id="st_dt"></div>
                                        <div class="cell ta_c"> ~ </div>
                                        <div class="cell"><input type="text" class="date" id="ed_dt"></div>
                                    </div>
                                </td>
                                <th scope="row">성공여부</th>
                                <td>
                                	<div class="cellBox" id="rd_bat_suc_yn">
                                        <div class="cell">
                                            <input type="radio" id="bat_suc_yn_ALL" name="bat_suc_yn" value="" checked="checked"
                                            	onclick="javascript:fn_setChgRadio('bat_suc_yn','');fn_setRadioChecked('bat_suc_yn');"/>
                                            <label for="bat_suc_yn_ALL">전체</label>
                                            <input type="radio" id="bat_suc_yn_S" name="bat_suc_yn" value="S"
                                            	onclick="javascript:fn_setChgRadio('bat_suc_yn','S');fn_setRadioChecked('bat_suc_yn');"/>
                                            <label for="bat_suc_yn_S">성공</label>
                                            <input type="radio" id="bat_suc_yn_F" name="bat_suc_yn" value="F" 
                                            	onclick="javascript:fn_setChgRadio('bat_suc_yn','F');fn_setRadioChecked('bat_suc_yn');"/>
                                            <label for="bat_suc_yn_F">실패</label>
                                        </div>
                                    </div>
                                    <input type="hidden" id="bat_suc_yn" value="" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div> 
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">검색결과</p></li>
                </ul> 
            </div>
            <div class="listTable mb5">
                <table id="grd_MmBatLog">
                </table>
            </div>
        </section>
        
    </div>
<!-- ./wrapper -->
</body>
</html>