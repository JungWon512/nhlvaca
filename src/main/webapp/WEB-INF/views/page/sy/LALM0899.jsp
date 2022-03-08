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


/*------------------------------------------------------------------------------
 * 1. 함 수 명    : 조회 함수
 * 2. 입 력 변 수 : N/A
 * 3. 출 력 변 수 : N/A
 ------------------------------------------------------------------------------*/
function fn_Search(){
	 
     var srchData = new Object();
	 
	if($("#ctgrm_cd").val() == "1200"){
        //농가정보
        srchData["oi_all_yn"] = '0';
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["in_sqno"]   = '1';
        srchData["in_rec_cn"] = '10';
        srchData["na_bzplc"] = '8808990643625';
        srchData["inq_st_dt"] = '20190818';
        srchData["inq_ed_dt"] = '20210930';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "1300"){
        //중도매인
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "1400"){
		//개체정보        
	    srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
	    srchData["oi_all_yn"] = '0';
	    srchData["in_sqno"]   = '1';
	    srchData["in_rec_cn"] = '100';
	    srchData["na_bzplc"] = '8808990643625';
	    srchData["inq_st_dt"] = '20210801';
	    srchData["inq_ed_dt"] = '20211028';
	    var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
	    var result;
	    if(results.status != RETURN_SUCCESS){
	        showErrorMessage(results,'NOTFOUND');
	        return;
	    }else{      
	        result = setDecrypt(results);
	    }   	
	}else if($("#ctgrm_cd").val() == "1500"){
        //수송자   
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["na_bzplc"] = '8808990643625';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "1600"){
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["auc_dt"]    = '20141008';
        var start_yn          = "1";
        srchData["start"]     = start_yn;

        var fix_pos     = 100;
        
        var tot_cow_cnt = 0;
        var cow_st_pos  = 1;
        var cow_ed_pos  = fix_pos;
        
        var tot_fee_cnt = 0;
        var fee_st_pos  = 1;
        var fee_ed_pos  = fix_pos;
        
        var tot_calf_cnt = 0;
        var calf_st_pos  = 1;
        var calf_ed_pos  = fix_pos;
        
        var tot_mmfhs_cnt = 0;
        var mmfhs_st_pos  = 1;
        var mmfhs_ed_pos  = fix_pos;
        
        var cow_results;
        var cow_result;
        var fee_results;
        var fee_result;
        var calf_results;
        var calf_result;
        var mmfhs_results;
        var mmfhs_result;
        var indv_results;
        var indv_result;
        
        //출장우
    	while(true){
    		//첫 전송
    		if(start_yn == "1"){
    			cow_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
    			if(cow_results.status != RETURN_SUCCESS){
    	            showErrorMessage(cow_results);
    	            return;
    	        }else{
    	        	//정상이면
    	            cow_result = setDecrypt(cow_results);
    	        	tot_cow_cnt = cow_result.tot_cnt;
    	        	start_yn = "0";
    	        }
    		//데이터 전송
    		}else{
    		    srchData["start"]  = start_yn;
                srchData["st_pos"] = cow_st_pos;
                srchData["ed_pos"] = cow_ed_pos; 
                cow_results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");
                if(cow_results.status != RETURN_SUCCESS){
                    showErrorMessage(cow_results);
                    return;
                }
                //종료포지션이 전체카운트보다 
                if(tot_cow_cnt < cow_ed_pos){
                    return;
                }
                cow_st_pos += fix_pos;
                cow_ed_pos += fix_pos;
    		}
    	}
                
    }else if($("#ctgrm_cd").val() == "1700"){
        //수수료 
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["oi_all_yn"] = '0';
        srchData["na_bzplc"] = '8808990643625';
        srchData["inq_st_dt"] = '20190818';
        srchData["inq_ed_dt"] = '20210930';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "1800"){
        //불량거래인 
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["oi_all_yn"] = '0';
        srchData["na_bzplc"] = '8808990643625';
        srchData["inq_st_dt"] = '20190818';
        srchData["inq_ed_dt"] = '20210930';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "1900"){
        //경매차수정보
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["auc_dt"] = '20151023';        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "2000"){
        //중도매인입금정보
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val(); 
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "2100"){
        //응찰로그정보
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["auc_obj_dsc"] = '1';
        srchData["auc_dt"] = '20210127';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "2200"){
        //개체이력정보
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["io_all_yn"]   = $("#para2").val();
        srchData["sra_indv_amnno"] = $("#para1").val();
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{     
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "2300"){
        //분만정보
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["mcow_sra_indv_eart_no"] = '410000182684654';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
            console.log(result);
            
        }
    }else if($("#ctgrm_cd").val() == "2400"){
        //교배정보
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["mcow_sra_indv_eart_no"] = '410000174069414';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        console.log(results);
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
            console.log(result);
        }
        
    }else if($("#ctgrm_cd").val() == "2500"){
        //공통코드
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["na_bzplc"] = '8808990643625';
        srchData["inq_st_dt"] = '20190818';
        srchData["inq_ed_dt"] = '20210930';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "2600"){
        //경제통합거래처정보
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["na_bzplc"]  = '8808990643625';
        srchData["na_trpl_c"] = '0';
        srchData["clntnm"]    = '2520064654257';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "2700"){
        //경매참가번호
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["auc_dt"] = '20140128';
        srchData["st_pos"] = 1;
        srchData["ed_pos"] = 100; 
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "2800"){
		//회원정보        
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["na_bzplc"] = '8808990499055';
        srchData["eno"] = 'S1412805';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
	}else if($("#ctgrm_cd").val() == "2900"){
        //인공수정KPN정보       
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["SRA_INDV_AMNNO"] = '410000001594276';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3000"){
        //비밀번호초기화인증정보       
        srchData["ctgrm_cd"]  = $("#ctgrm_cd").val();
        srchData["na_bzplc"]  = '8808990810652';
        srchData["mpno"]  = '01063651361';
        srchData["usrnm"] = 'LUG00001';
        srchData["usrid"] = 'LUG00001';
        srchData["pw"]    = '12345678';
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3100"){
        //문자정보수신
        srchData["ctgrm_cd"]     = $("#ctgrm_cd").val();
        srchData["auc_obj_dsc"]  = '1';
        srchData["auc_dt"]       = '20201216';
        srchData["obj_gbn"]      = '1';
        srchData["msg_gbn"]      = '01';
        
        //경매대상 auc_obj_dsc 1:송아지 2:비육우 3:번식우, 8808990659008 0:일괄 1:송아지 2:비육우 3:번식우
        //경매일자 auc_dt
        //대상     obj_gbn     1:응찰자 2:출하자
        //메시지   msg_gbn     1:응찰자 01:경매전(응찰자) 02:경매후(낙찰평균) 03:경매후(최고,최저)
        //                     2:출하자 01:경매전(출하주) 02:경매후(낙찰가)
        //                     8808990657615 1:응찰자 01:경매전(응찰자) 02:경매후(낙찰평균) 03:경매후(최고,최저) 04:경매후(입금금액)
        
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results); 
        }
    }else if($("#ctgrm_cd").val() == "3200"){
        //주소정보
        srchData["ctgrm_cd"]   = $("#ctgrm_cd").val();
        srchData["in_sqno"]    = 1;
        srchData["in_rec_cn"]  = "20";
        srchData["provnm"]     = '강원도';
        srchData["ccwnm"]      = '전체';
        srchData["adr_rodnm"]  = '장미';
        srchData["ttvnm"]      = '';
        srchData["adr_bldnm1"] = '';
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3300"){
        //KPN 정보
        srchData["ctgrm_cd"]   = $("#ctgrm_cd").val();
        srchData["in_sqno"]    = 1;
        srchData["in_rec_cn"]  = "100";
        srchData["na_bzplc"]   = '8808990643625';
        srchData["inq_st_dt"]  = '20190818';
        srchData["inq_ed_dt"]  = '20210930';
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3400"){
        //거래처(산정위원_수의사)
        srchData["ctgrm_cd"]   = $("#ctgrm_cd").val();
        srchData["na_bzplc"]   = '8808990643625';
        srchData["inq_st_dt"]  = '20190818';
        srchData["inq_ed_dt"]  = '20210930';
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3500"){
        //거래처(산정위원_수의사)
        srchData["ctgrm_cd"]   = $("#ctgrm_cd").val();
        srchData["auc_dt"]     = '20190818';
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3600"){
        //중도매인 조합원여부정보
        srchData["ctgrm_cd"]   = $("#ctgrm_cd").val();
        srchData["na_bzplc"]       = '8808990643625';
        srchData["mwmn_na_trpl_c"] = '8808990643625';
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3700"){
        //출장우 송아지 내역정보
        srchData["ctgrm_cd"]    = $("#ctgrm_cd").val();
        srchData["st_pos"]    = 1;
        srchData["ed_pos"]  = "100";
        srchData["auc_obj_dsc"] = '1';
        srchData["auc_dt"]      = '20140827';
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3800"){
        //출장우농가(농장)정보
        srchData["ctgrm_cd"]    = $("#ctgrm_cd").val();
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "3900"){
        //출장우 수수료정보
        srchData["ctgrm_cd"]    = $("#ctgrm_cd").val();
        srchData["st_pos"]    = 1;
        srchData["ed_pos"]  = "100";
        srchData["auc_obj_dsc"] = '1';
        srchData["auc_dt"]      = "20141027";
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "4000"){
        //출장우수기개체등록정보
        srchData["ctgrm_cd"]    = $("#ctgrm_cd").val();
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "4100"){
        //개체이력 농가 조회
        srchData["ctgrm_cd"]   = $("#ctgrm_cd").val();
        srchData["in_sqno"]    = 1;
        srchData["in_rec_cn"]  = "2";
        srchData["farm_amnno"] = '0';
        srchData["fhs_id_no"]  = '';
        srchData["sra_fhsnm"]  = '이서';
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
    }else if($("#ctgrm_cd").val() == "4200"){
        srchData["ctgrm_cd"]     = $("#ctgrm_cd").val();
        srchData["rc_na_trpl_c"] = "8808990768700"; //축산연구원
        srchData["indv_id_no"]   = $("#para1").val();
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        console.log(result);
        
    }else if($("#ctgrm_cd").val() == "4300"){
        srchData["ctgrm_cd"]     = $("#ctgrm_cd").val();
        srchData["rc_na_trpl_c"] = "8808990768700"; //축산연구원
        srchData["indv_id_no"]   = $("#para1").val();
        
        var results = sendAjax(srchData, "/LALM0899_selIfSend", "POST");        
        var result;
        
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results,'NOTFOUND');
            return;
        }else{      
            result = setDecrypt(results);
        }
        
        console.log(result);
    }               
}



function bbb(){ 
	
	var srchData = new Object();

    srchData["trace_no"]     = $("#traceNo").val();
    srchData["option_no"]    = $("#optionNo").val();
    
    var results = sendAjax(srchData, "/LALM0899_selRestApi", "POST");        
    var result;
    
    console.log(results);
    
    if(results.status != RETURN_SUCCESS){
        showErrorMessage(results,'NOTFOUND');        
        return;
    }else{      
        result = setDecrypt(results);
    }
    
    console.log(result);


}


function ccc(){     
    
    var pom = document.createElement("iframe");     
    var url = "http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch?ServiceKey=7vHI8ukF3BjfpQW8MPs9KtxNwzonZYSbYq6MVPIKshJNeQHkLqxsqd1ru5btfLgIFuLRCzCLJDLYkHp%2FvI6y0A%3D%3D";
    var traceNo     = "&traceNo=002125769192";
    var traceNoType = "&traceNoType=CATTLE/CATTLE_NO";
    var infoType    = "&infoType=7";
    pom.setAttribute("id","eee");
    pom.setAttribute("name","eee");
    pom.style.width = "1000px";
    pom.style.height = "500px";
    pom.src = url+traceNo+traceNoType+infoType;
    document.getElementById("ddd").append(pom);
    
    $('iframe#eee').load(function(){
        var element  = $('iframe#eee');
        console.log(element);           
    });


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
                    <li><p class="dot_allow">MCA</p></li>
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
                                <th scope="row"><span class="tb_dot">인터페이스ID</span></th>
                                <td>
                                    <input type="text" id="ctgrm_cd">
                                </td>
                                <th scope="row"><span class="tb_dot">para1</span></th>
                                <td>
                                    <input type="text" id="para1">
                                </td>
                                <th scope="row"><span class="tb_dot">para2</span></th>
                                <td>
                                    <input type="text" id="para2">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="tab_box clearfix">
                <ul class="tab_list fl_L">
                    <li><p class="dot_allow">품평원</p></li>
                </ul>
                <div class="fl_R"><!--  //버튼 모두 우측정렬 -->                       
                    <button class="tb_btn" id="bbb" onclick="bbb();">JAVA</button>
                    <button class="tb_btn" id="ccc" onclick="ccc();">script</button>
                </div> 
                
                  
            </div> 
            <div class="sec_table">
                <div class="blueTable rsp_v">
                    <table id="srchFrm_list2">
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><span class="tb_dot">개체번호</span></th>
                                <td>
                                    <input type="text" id="traceNo">
                                </td>
                                
                                <th scope="row"><span class="tb_dot">옵션번호</span></th>
                                <td>
                                    <input type="text" id="optionNo">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div id="ddd"></div>
        </section>
    </div>
</body>
</html>