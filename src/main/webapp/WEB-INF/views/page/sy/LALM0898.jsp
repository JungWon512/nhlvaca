<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<!-- 암호화 -->
<%@ include file="/WEB-INF/common/serviceCall.jsp" %>
<%@ include file="/WEB-INF/common/head.jsp" %>

<script type="text/javascript">

	$(document).ready(function(){
		$( "#cpy_auc_dt" ).attr('disabled',true);
		$( "#ori_auc_dt" ).datepicker().datepicker("setDate", fn_getToday());
		$( "#cpy_auc_dt" ).datepicker().datepicker("setDate", fn_getToday());
	});
	function fn_cpyAucData(){
        var data = new Object();                
        data["ori_auc_dt"] = $('#ori_auc_dt').val().replaceAll('-','');           
        data["cpy_auc_dt"] = $('#cpy_auc_dt').val().replaceAll('-','');
        
        if(data["cpy_auc_dt"] == data["ori_auc_dt"]){
        	MessagePopup("OK","동일한 경매일자의 데이터를 지정할수없습니다.");
        	return;
        }
        
        var results = sendAjax(data, "/LALM0898_insAucData", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,"NOTFOUND");
            return;
        }else{      
        	result = setDecrypt(results);
        }
		
	}
	function fn_delAucData(){
        var data = new Object();                           
        data["cpy_auc_dt"] = $('#cpy_auc_dt').val().replaceAll('-','');
        var results = sendAjax(data, "/LALM0898_delAucData", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(Results,"NOTFOUND");
            return;
        }else{      
        	result = setDecrypt(results);
        }
		
	}
	function fn_initAucData(){
        var data = new Object();                           
        data["cpy_auc_dt"] = $('#cpy_auc_dt').val().replaceAll('-','');
        var results = sendAjax(data, "/LALM0898_updAucDataInit", "POST");
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(Results,"NOTFOUND");
            return;
        }else{      
        	result = setDecrypt(results);
        }
		
	}
</script>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Tell the browser to be responsive to screen width -->
 <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<body>
	<div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>
        <!-- content -->
        <section class="content">
        <!-- //tab_box e -->
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">테스트 데이터 생성/삭제</p></li>
                </ul>    
            </div>
            <div class="sec_table">            
	            <div class="blueTable rsp_v">
	                <table id="srchFrm_list">
	                    <colgroup>
	                        <col width="100">
	                        <col width="*">
	                        <col width="100">
	                        <col width="*">
	                    </colgroup>
	                    <tbody>
	                        <tr>
	                            <th scope="row"><span class="tb_dot">원본 경매일</span></th>
	                            <td>
	                                <input type="text" class="date" id="ori_auc_dt">
	                            </td>
	                            <th scope="row"><span class="tb_dot">생성 경매일</span></th>
	                            <td>
	                                <input type="text" class="date" id="cpy_auc_dt">
	                            </td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
            </div>
            <div class="fl_R"><!--  //버튼 모두 우측정렬 -->                       
                <button class="tb_btn" id="btn_cpyAuc" onclick="fn_cpyAucData();">테스트 경매생성</button>
                <button class="tb_btn" id="btn_cpyAuc" onclick="fn_initAucData();">테스트 출장우정보 초기화</button>
                <button class="tb_btn" id="btn_delAuc" onclick="fn_delAucData();">테스트 경매삭제</button>
            </div> 
        </section>
    </div>
</body>
</html>