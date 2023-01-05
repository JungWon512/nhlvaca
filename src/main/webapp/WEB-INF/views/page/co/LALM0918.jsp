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
    $(document).ready(function(){
        fn_Init();
    });
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
    	fn_Search();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
        var results = sendAjax({}, "/LALM0918_selData", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            resultList = setDecrypt(results);
            var resultList0 = resultList.filter(item => item.SIMP_C_GRP_SQNO == '0');
            var visList = resultList.filter(item => item.VISIB_YN == '1');
        	$("#frm_sett").empty();
        	
        	if (resultList.length > 0) {
    			var sHtml = "";
    			// 모바일 업무 간편 비고항목 추가
    				sHtml += '		<div class="tab_box clearfix">';
    	    		sHtml += '			<ul class="tab_list_0">';
    	    		sHtml += '				<li><p class="dot_allow">대상</p></li>';
    	    		sHtml += '			</ul>';
    	    		sHtml += '		</div>';
    	    		sHtml += '		 <div class="sec_table">';
    	    		sHtml += '		 	<div class="grayTable rsp_v">';
    	    		sHtml += '		 		<table>';
    	    		sHtml += '		 			<colgroup>';
    	    		sHtml += '		 				<col width="200">';
    	    		sHtml += '		 				<col width="*">';
    	    		sHtml += '		 			</colgroup>';
    	    		sHtml += '		 			<tbody>';
    	    		sHtml += '						<tr>';
					sHtml += '							<th scope="row">모바일 업무 간편 비고항목</th>';
					sHtml += '							<td>';
					sHtml += '								<input type="text" id="sms_buffer_2" name="sms_buffer_2" value=""/>';
					sHtml += '								<p class="dot_allow">항목을 반드시 , 단위로 추가해주시기 바랍니다.</p>';
					sHtml += '							</td>';
    	    		sHtml += '						</tr>';
    	    		sHtml += '		 			</tbody> ';
    	    		sHtml += '		 		</table>';
    	    		sHtml += '		 	</div>';
    	    		sHtml += '		 </div>';
    			
    	    	for (var i = 0; i < resultList0.length; i++) {
    	    		var tempList = resultList.filter(item => item.SIMP_C_GRP_SQNO == i+1);
    	    		sHtml += '		<div class="tab_box clearfix">';
    	    		sHtml += '			<ul class="tab_list_'+ resultList0[i].SIMP_C +'">';
    	    		sHtml += '				<li><p class="dot_allow">'+ resultList0[i].SIMP_CNM +'</p></li>';
    	    		sHtml += '			</ul>';
    	    		sHtml += '		</div>';
    	    		sHtml += '		 <div class="sec_table">';
    	    		sHtml += '		 	<div class="grayTable rsp_v">';
    	    		sHtml += '		 		<table>';
    	    		sHtml += '		 			<colgroup>';
    	    		sHtml += '		 				<col width="150">';
    	    		sHtml += '		 				<col width="*">';
    	    		sHtml += '		 			</colgroup>';
    	    		sHtml += '		 			<tbody>';
    	    		sHtml += '		 				<tr>';
    	    		sHtml += '		 				<th scope="row">대상</th>';	    		
    	    		sHtml += '		 					<td>';
					if (tempList.length > 0) {
						for (var idx in tempList) {
   							sHtml += '						<input type="checkbox" id="tab_'+tempList[idx].SIMP_C_GRP_SQNO + '_' + tempList[idx].SIMP_C+'" class="menu_select_'+resultList0[i].SIMP_C+'" value="'+ tempList[idx].SIMP_C +'"/>';
    	    				sHtml += '						<label for="tab_'+tempList[idx].SIMP_C_GRP_SQNO + '_' + tempList[idx].SIMP_C+'">'+tempList[idx].SIMP_CNM+'</label>';
    	    			}
    	    		} else {
    	    			sHtml += '							등록된 노출항목이 없습니다.';
    	    		}
    	    		sHtml += '		 					</td>';
    	    		sHtml += '		 				</tr>';
    	    		sHtml += '		 			</tbody> ';
    	    		sHtml += '		 		</table>';
    	    		sHtml += '		 	</div>';
    	    		sHtml += '		 </div>';
        		}
    	    	$("#frm_sett").append(sHtml);
        	}

        	fn_setBuffer2();
            fn_setMenu(visList);
        }                       
    } 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){     
    	var buffer2 = $("#sms_buffer_2").val();
    	buffer2 = buffer2.replaceAll(" ","");
    	 
    	 if(buffer2.length > 30){
            MessagePopup("OK", "간편비고항목은 30자 이상 입력불가합니다.");
            $("#sms_buffer_2").focus();
            return;
        } 
    	
        MessagePopup('YESNO',"수정 하시겠습니까?",function(res){
            if(res){
                var results = sendAjaxFrm('frm_sett', "/LALM0918_updData", "POST");                      
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{
                    MessagePopup("OK", "수정되었습니다.<br>시스템 적용하기위해서는 재시작 하셔야 합니다.",function(res){
                    	fn_Search();
                    });
                }      
            }else{
                MessagePopup('OK','취소되었습니다.');
            }
        });  
    }
    //라디오항목 데이터 맵핑
    function fn_setMenu(visList) {
    	// select 초기화
    	$("input[type=checkbox]").prop('checked',false);
    	
    	visList.forEach(item => {
    		$("#tab_" + item.SIMP_C_GRP_SQNO + "_" + item.SIMP_C).prop('checked',true);
    	})
    }
    //input항목 데이터 맵핑
    function fn_setBuffer2() {
    	var results = sendAjax({}, "/LALM0918_selMobileEtc", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
            fn_setFrmByObject("frm_sett", result);
        }
    	
    }
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>
        <!-- content -->
        <section class="content">
        <form id="frm_sett" name="frm_sett"></form>    
        </section>
    </div>
</body>
</html>