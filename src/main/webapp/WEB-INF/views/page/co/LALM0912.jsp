<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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
    var g_newFlg = false;    
    $(document).ready(function(){
    	fn_setCodeBox("rep_bnk_c", "REP_BNK_C", 1, false,"선택"); 
        fn_Init();
        fn_Search();
        
        $('#na_bzplc').on('keydown',function(e){
        	var code = e.keyCode || e.which;
        	if(code == 13){
        		e.preventDefault();
        		fn_Search();
        	}
        })
        		
        /******************************
         * 주소 검색
         ******************************/
         $("#pb_SearchZip").on('click',function(e){
             e.preventDefault();
             this.blur();
             //fn_CallRoadnmPopup(function(result){
             //    if(result){
             //    	$("#zip").val(result.ZIP);
             //        $("#dongup").val(result.RODNM_ADR);
             //    }
             //});
             new daum.Postcode({
 		        oncomplete: function(data) {
 		        	console.log(data);
             		$("#zip").val(data.zonecode);
                     $("#dongup").val(data.roadAddress);
 		        }
 		    }).open();
         });
        
        /******************************
         * 이미지 미리보기
         ******************************/
        $("#pb_SealImgView").on('click',function(e){
            e.preventDefault();
            this.blur();
            
            var encrypt = setEncrypt(setFrmToData('frm_MmWmc'));
            var result;
            
            $.ajax({
                url: '/LALM0912_selSealImg',
                type: 'POST',
                dataType:'TEXT',
                async: false,
                headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
                data:{
                       data : encrypt.toString()
                },
                success:function(data) {        
                    if(data.length > 0 && data != null){
                    	document.getElementById("preeview-image").src = data;
                    	var obj = $("#pb_SealImgView").offset();
                    	
                    	$('#imageView').css({"top":obj.top+"px","left":(obj.left + $("#pb_SealImgView").width()) + "px"});
                    	$('#imageView').show();
                    }                                    
                },
                error:function(response){
                	MessagePopup("OK", "이미지를 다운로드하지 못하였습니다.");
                    return;
                }
            }); 
            
        });
        
        
        
    });    
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 초기화 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Init(){        
        //폼 초기화
        fn_InitFrm('frm_MmWmc');
        $('#na_bzplc').attr("disabled",false);
        $("#pb_SealImgView").hide();
        g_newFlg = true;
        if(App_grp_c != '001')fn_Search();
    }
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 조회 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Search(){                
        
        var results = sendAjaxFrm("frm_MmWmc", "/LALM0912_selData", "POST");        
        var result;
        if(results.status != RETURN_SUCCESS){
            showErrorMessage(results);
            return;
        }else{      
            result = setDecrypt(results);
            fn_setFrmByObject("frm_MmWmc", result);
            var smsBuffer1 = result.SMS_BUFFER_1.split(',');
            result.SMS_BUFFER_1.split(',').forEach((o,i)=>{
            	switch(o){
				case "AD" :
					$('#buffer_1').prop('checked',true);
				break;
				case "T" :
					$('#buffer_2').prop('checked',true);
				break;
				case "H" :
					$('#buffer_3').prop('checked',true);
				break;
				case "AC" :
					$('#buffer_4').prop('checked',true);
				break;
            	}
            });            
            $('#na_bzplc').attr("disabled",true);
            if(result.SEAL_IMG_FLNM != ""){
            	$("#pb_SealImgView").show();
            }
            g_newFlg = false;
        }                       
    } 
    
    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 저장 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Save(){     
        //정합성체크
        if(fn_isNull($('#na_bzplc').val()) == true){
            MessagePopup("OK", "사업장코드를 입력하세요.");
            $('#na_bzplc').focus();
            return;
        } 
        if($('#na_bzplc').val().length != 13){
            MessagePopup("OK", "사업장코드에 13자리 숫자를 입력하세요.");
            $('#na_bzplc').focus();
            return;
        } 
        
        if(fn_isNull($('#trpl_shrt_c').val()) == true){
            MessagePopup("OK", "사업장단축코드를 입력하세요.");
            $('#trpl_shrt_c').focus();
            return;
        }
        
		var buffer_1='';
		var index=0;
		$('.sms_buffer_1').each((i,o)=>{
        	if($(o).is(':checked')){
        		if(index > 0) buffer_1 +=','; 
        		buffer_1 += $(o).val();
        		index++;
        	}
        });
        $('#sms_buffer_1').val(buffer_1);
        
        if(g_newFlg == true){
             MessagePopup('YESNO',"신규등록 하시겠습니까?",function(res){
                 if(res){
                     var results = sendAjaxFrm('frm_MmWmc', "/LALM0912_insWmc", "POST");  
                     if(results.status != RETURN_SUCCESS){
                         showErrorMessage(results);
                         return;
                     }else{  
                    	 if($("#seal_img_flnm").val() != ""){
                    		 g_newFlg = false;
                             if(fileUpload() == true){
                                 MessagePopup("OK", "신규등록되었습니다.<br>시스템 적용하기위해서는 재시작 하셔야 합니다.",function(res){
                                	 fn_Search();
                                 });
                                 
                             }
                         }else {
                             MessagePopup("OK", "신규등록되었습니다.<br>시스템 적용하기위해서는 재시작 하셔야 합니다.",function(res){
                            	 fn_Search();
                             });
                         }
                         
                     }      
                 }else{
                     MessagePopup('OK','취소되었습니다.');
                 }
             });
        }else {
            MessagePopup('YESNO',"수정 하시겠습니까?",function(res){
                if(res){
                    var results = sendAjaxFrm('frm_MmWmc', "/LALM0912_updWmc", "POST");                      
                    if(results.status != RETURN_SUCCESS){
                        showErrorMessage(results);
                        return;
                    }else{
                    	if($("#seal_img_flnm").val() != ""){
                    		if(fileUpload() == true){
                                MessagePopup("OK", "수정되었습니다.<br>시스템 적용하기위해서는 재시작 하셔야 합니다.",function(res){
                                	fn_Search();
                                });
                                
                            }
                    	}else {
                    		MessagePopup("OK", "수정되었습니다.<br>시스템 적용하기위해서는 재시작 하셔야 합니다.",function(res){
                    			fn_Search();
                    		});
                    	}
                    }      
                }else{
                    MessagePopup('OK','취소되었습니다.');
                }
            });
        }        
    }

    /*------------------------------------------------------------------------------
     * 1. 함 수 명    : 삭제 함수
     * 2. 입 력 변 수 : N/A
     * 3. 출 력 변 수 : N/A
     ------------------------------------------------------------------------------*/
    function fn_Delete (){
           
        if(g_newFlg == true){
            MessagePopup("OK", "신규사업장은 삭제할수 없습니다.");
            return;
        }       
        MessagePopup('YESNO',"삭제 하시겠습니까?",function(res){
            if(res){
                var results = sendAjaxFrm('frm_MmWmc', "/LALM0912_delWmc", "POST");      
                if(results.status != RETURN_SUCCESS){
                    showErrorMessage(results);
                    return;
                }else{          
                    MessagePopup("OK", "삭제되었습니다.",function(res){
                    	fn_Init();
                    });
                }      
            }else{
                MessagePopup('OK','취소되었습니다.');
            }
        });
    } 
    
    ////////////////////////////////////////////////////////////////////////////////
    //  공통버튼 클릭함수 종료
    ////////////////////////////////////////////////////////////////////////////////
    function fileUpload(){
        //폼데이터 전송           
        var result;
        
        var formData = new FormData($("#frm_MmWmc")[0]);
        formData.append("na_bzplc", $("#na_bzplc").val());
        $.ajax({
            url: "/LALM0912_updSealImg",
            type: "POST",
            enctype:"multipart/form-data",
            processData:false,
            contentType:false,
            data: formData,
            async: false,
            headers : {"Authorization": 'Bearer ' + localStorage.getItem("nhlvaca_token")},
            success:function(data) {    
            	result = true;            
            },
            error:function(request){            
                result = false;
                            
            }
        }); 
        
        return result; 
    
    }
    
    function fn_closeImage(){
    	$('#imageView').hide();
    }
    
    
</script>

<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
        <form id="frm_MmWmc" name="frm_MmWmc">
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">공판장정보</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    
                    <table>
                        <colgroup>
                            <col width="200">
                            <col width="*">
                            <col width="200">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">경제통합사업장코드<strong class="req_dot">*</strong></th>
                                <td>
                                    <input type="text" class="popup" id="na_bzplc" name="na_bzplc" class="digit" maxlength="13" >
                                </td>                                
                                <th scope="row">사업장단축코드</th>
                                <td>
                                    <input type="text" class="popup" id="trpl_shrt_c" class="digit" maxlength="4">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">경제통합사업장명</th>
                                <td colspan="3">
                                    <input type="text" id="na_bzplnm" maxlength="30">
                                </td>
                            </tr>                            
                            <tr>
                                <th scope="row">대표사업자번호</th>
                                <td >
                                    <input type="text" id="bzno" class="digit" maxlength="10">
                                </td>
                                <th scope="row">사무소코드</th>
                                <td >
                                    <input type="text" id="brc" class="digit" maxlength="6">
                                </td>
                            </tr>                         
                            <tr>
                                <th scope="row">대표자명</th>
                                <td >
                                    <input type="text" id="repmnm" maxlength="30">
                                </td>
                                <th scope="row">대표전화번호</th>
                                <td >
                                    <input type="text" id="telno" class="digit" maxlength="14">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">주소</th>
                                <td colspan="3">
                                    <div class="cellBox">
                                        <div class="cell" style="width:60px;"><input type="text" id="zip" disabled="disabled"></div>
                                        <div class="cell pl2" style="width:26px;">
                                            <button id="pb_SearchZip" class="tb_btn white srch"><i class="fa fa-search"></i></button>
                                        </div>
                                        <div class="cell"><input type="text" id="dongup" disabled="disabled"></div>
                                        <div class="cell"><input type="text" id="dongbw" maxlength="100"></div>
                                    </div>
                                    
                                </td>
                            </tr>                         
                            <tr>
                                
                                <th scope="row">직인정보</th>
                                <td colspan="3" >
                                    <div class="cellBox">
                                        <div class="cell" style="width:500px;"><input type="file" id="seal_img_flnm"  name="seal_img_flnm" title="파일첨부" accept=".gif,.jpg,.png"/></div>
                                        <div class="cell"><button class="tb_btn" id="pb_SealImgView" >이미지보기</button></div>
                                    </div>
                                    
                                </td>
                            </tr>                      
                            <tr>
                                <th scope="row">결제계좌은행</th>
                                <td >
                                    <select id="rep_bnk_c"></select>
                                </td>
                                <th scope="row">계좌번호</th>
                                <td >
                                    <input type="text" id="acno" maxlength="30">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">비고</th>
                                <td colspan="3">
                                    <input type="text" id="rmk_cntn" maxlength="200">
                                </td>
                            </tr> 
                        </tbody>
                    </table>
                    
                </div>
            </div> 
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">환경정보</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    
                    <table>
                        <colgroup>
                            <col width="200">
                            <col width="*">
                            <col width="200">
                            <col width="*">
                            <col width="200">
                            <col width="*">
                            <col width="200">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">비육우단가기준</th>
                                <td>
                                    <select id="nbfct_auc_upr_dsc">
                                        <option value="1">KG별</option>
                                        <option value="2">두별</option>
                                    </select>
                                </td>
                                <th scope="row">당일접수비용</th>
                                <td>
                                    <input type="text" id="td_rc_cst" class="number" maxlength="15">
                                </td>
                                <th scope="row">12개월이상수수료</th>
                                <td>
                                    <input type="text" id="mt12_ovr_fee" class="number" maxlength="15">
                                </td>                               
                                <th scope="row">사료미사용추가수수료</th>
                                <td>
                                    <input type="text" id="sra_fed_spy_yn_fee" class="number" maxlength="15">
                                </td>
                            </tr>
                            <tr style="display:none">
                                <th scope="row">연계시스템URL</th>
                                <td>
                                    <input type="text" id="url_nm">
                                </td>
                                <th scope="row">연계시스템구분</th>
                                <td>
                                    <input type="text" id="cnnt_obj_sys_dsc">
                                </td>                                
                                <th scope="row">음성경매여부</th>
                                <td>
                                    <input type="text" id="phn_auc_yn">
                                </td>                                                               
                                <th scope="row">KPN자리수</th>
                                <td>
                                    <input type="text" id="kpn_cip">
                                </td>  
                            </tr>
                        </tbody> 
                    </table>                           
                    <table style="display:none">
                        <colgroup>
                            <col width="150">
                            <col width="*">
                            <col width="150">
                            <col width="*">
                            <col width="150">
                            <col width="*">
                            <col width="150">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">멀티A</th>
                                <td >
                                    <input type="text" id="ebbo_ip_addr1">
                                </td>
                                <th scope="row">PDP A</th>
                                <td >
                                    <input type="text" id="ebbo_ip_addr2">
                                </td>
                                <th scope="row">멀티B</th>
                                <td >
                                    <input type="text" id="ebbo_ip_addr3">
                                </td>
                                <th scope="row">PDP B</th>
                                <td >
                                    <input type="text" id="ebbo_ip_addr4">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">멀티A 포트</th>
                                <td >
                                    <input type="text" id="ebbo_port_no1">
                                </td>
                                <th scope="row">PDP A 포트</th>
                                <td >
                                    <input type="text" id="ebbo_port_no2">
                                </td>
                                <th scope="row">멀티B 포트</th>
                                <td >
                                    <input type="text" id="ebbo_port_no3">
                                </td>
                                <th scope="row">PDP B 포트</th>
                                <td >
                                    <input type="text" id="ebbo_port_no4">
                                </td>
                            </tr>
                        </tbody> 
                    </table>                           
                    <table style="display:none">
                        <colgroup>
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <td >전광판설정<strong class="req_dot">*</strong></td>
                                <th scope="row">경매번호</th>
                                <th scope="row">출하주</th>
                                <th scope="row">중량</th>
                                <th scope="row">성별</th>
                                <th scope="row">계대</th>
                                <th scope="row">산차</th>
                                <th scope="row">예정가</th>
                                <th scope="row">낙찰가</th>
                                <th scope="row">낙찰자</th>
                            </tr>                         
                            <tr>
                                <th scope="row">멀티 자릿수</th>
                                <td >
                                    <input type="text" id="multi_aucno">
                                </td>
                                <td >
                                    <input type="text" id="multi_ftsnm">
                                </td>
                                <td >
                                    <input type="text" id="multi_weight">
                                </td>
                                <td >
                                    <input type="text" id="multi_sex">
                                </td>
                                <td >
                                    <input type="text" id="multi_qcn">
                                </td>
                                <td >
                                    <input type="text" id="multi_matime">
                                </td>
                                <td >
                                    <input type="text" id="multi_sbid_lmt_am">
                                </td>
                                <td >
                                    <input type="text" id="multi_sbid_upr">
                                </td>
                                <td >
                                    <input type="text" id="multi_mwmnnm">
                                </td>
                            </tr>                      
                            <tr>
                                <th scope="row">PDP 자릿수</th>
                                <td >
                                    <input type="text" id="pdp_aucno">
                                </td>
                                <td >
                                    <input type="text" id="pdp_ftsnm">
                                </td>
                                <td >
                                    <input type="text" id="pdp_weight">
                                </td>
                                <td >
                                    <input type="text" id="pdp_sex">
                                </td>
                                <td >
                                    <input type="text" id="pdp_qcn">
                                </td>
                                <td >
                                    <input type="text" id="pdp_matime">
                                </td>
                                <td >
                                    <input type="text" id="pdp_sbid_lmt_am">
                                </td>
                                <td >
                                    <input type="text" id="pdp_sbid_upr">
                                </td>
                                <td >
                                    <input type="text" id="pdp_mwmnnm">
                                </td>
                            </tr> 
                        </tbody>
                    </table>
                    <table>
                        <colgroup>
                            <col width="200">
                            <col width="*">
                            <col width="200">
                            <col width="*">
                            <col width="200">
                            <col width="*">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">송아지응찰단위금액</th>
                                <td >
                                    <select id="calf_auc_atdr_unt_am">
                                        <option value="1">원</option>
                                        <option value="1000">천원</option>
                                        <option value="10000">만원</option>
                                    </select>
                                </td>
                                <th scope="row">비육우응찰단위금액</th>
                                <td >
                                    <select id="nbfct_auc_atdr_unt_am">
                                        <option value="1">원</option>
                                        <option value="1000">천원</option>
                                        <option value="10000">만원</option>
                                    </select>
                                </td>
                                <th scope="row">번식우응찰단위금액</th>
                                <td >
                                    <select id="ppgcow_auc_atdr_unt_am">
                                        <option value="1">원</option>
                                        <option value="1000">천원</option>
                                        <option value="10000">만원</option>
                                    </select>
                                </td>
                            </tr>                         
                            <tr>
                                <th scope="row">수의사 병원명</th>
                                <td >
                                    <input type="text" id="brkr_name_host" maxlength="30">
                                </td>
                                <th scope="row">친자확인 출하수수료</th>
                                <td >
                                    <input type="text" id="fee_chk_dna_yn_fee" class="number" maxlength="15">
                                </td>
                                <th scope="row">친자확인 판매수수료</th>
                                <td >
                                    <input type="text" id="selfee_chk_dna_yn_fee" class="number" maxlength="15">
                                </td>
                            </tr>                      
                            
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="tab_box clearfix">
                <ul class="tab_list">
                    <li><p class="dot_allow">경매장정보</p></li>
                </ul>
            </div>
            <!-- //tab_box e -->
            <div class="sec_table">
                <div class="grayTable rsp_v">
                    
                    <table>
                        <colgroup>
                            <col width="200">
                            <col width="*">
                            <col width="200">
                            <col width="*">
                        </colgroup>
                        <tbody>                            
                            <tr>
                                <th scope="row">경매장번호</th>
                                <td>
                                    <input type="text" id="na_bzplcno" maxlength="3" >
                                </td>                                
                                <th scope="row">경매장 지역코드</th>
                                <td>
                                    <input type="text" id="na_bzplcloc" maxlength="4">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">경매장명</th>
                                <td>
                                    <input type="text" id="clntnm" maxlength="50" >
                                </td>                                
                                <th scope="row">경매구분</th>
                                <td >
                                    <select id="auc_dsc">
                                        <option value="1">단일</option>
                                        <option value="2">일괄</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">지역순서</th>
                                <td>
                                    <input type="text" id="areaord" maxlength="10">
                                </td>
                                
                                <th scope="row">지역명</th>
                                <td>
                                    <input type="text" id="areanm" maxlength="50">
                                </td>
                            </tr>                            
                            <!-- tr>
                                <th scope="row">위도</th>
                                <td >
                                    <input type="text" id="lat" maxlength="20">
                                </td>                                
                                <th scope="row">경도</th>
                                <td >
                                    <input type="text" id="lng" maxlength="20">
                                </td>
                            </tr-->
                            <tr>
                                <th scope="row">경매여부</th>
                                <td>
                                    <select id="auc_yn">
                                        <option value="1">여</option>
                                        <option value="0">부</option>
                                    </select>
                                </td>                                
                                <th scope="row">전화번호</th>
                                <td>
                                    <input type="text" id="tel_no" maxlength="14">
                                </td>
                            </tr>                            
                            <tr>
                                <th scope="row">비고</th>
                                <td>
                                    <input type="text" id="auc_rmk_cntn" maxlength="50">
                                </td>  
                                <th scope="row">SMS인증사용여부</th>
                                <td>
                                    <select id="sms_auth_yn">
                                        <option value="1">여</option>
                                        <option value="0">부</option>
                                    </select>
                                </td>  
                            </tr>                  
                            <tr>
                                <th scope="row">카카오ID</th>
                                <td >
                                    <input type="text" id="kko_svc_id" maxlength="200">
                                </td>
                                <th scope="row">카카오서비스Key</th>
                                <td >
                                    <input type="text" id="kko_svc_key" maxlength="200">
                                </td>
                            </tr>               
                            <tr>
                                <th scope="row">카카오 영상송출 수</th>
                                <td >
                                    <input type="text" id="kko_svc_cnt" class="number" maxlength="2">
                                </td>
                                <th scope="row">키오스크 사용여부</th>
                                <td >
                                    <select id="kiosk_yn">
                                        <option value="1">여</option>
                                        <option value="0">부</option>
                                    </select>
                                </td>
                            </tr>               
                            <tr>
                                <th scope="row">출하주 정보 수정 제외항목</th>
                                <td colspan = '3'>
                                    <input type="hidden" id="sms_buffer_1" value=""/>
                                    <input type="checkbox" id="buffer_1" class="sms_buffer_1" value="AD"/>
                                    <label for="buffer_1">주소</label>
                                    <input type="checkbox" id="buffer_2" class="sms_buffer_1" value="T"/>
                                    <label for="buffer_2">자택전화번호</label>
                                    <input type="checkbox" id="buffer_3" class="sms_buffer_1" value="H"/>
                                    <label for="buffer_3">휴대전화번호</label>
                                    <input type="checkbox" id="buffer_4" class="sms_buffer_1" value="AC"/>
                                    <label for="buffer_4">계좌번호</label>
                                </td>
                            </tr>   
                        </tbody>
                    </table>
                    
                </div>
            </div> 
        </form>    
        </section>
    </div>
<!-- ./wrapper -->
    <div id="imageView" style="overflow: hidden;-webkit-overflow-scrolling: touch;display:none;position: fixed;top:0;left:0;width:250px;height:250px;border:2px solid;background:white" >
       <img id="preeview-image">
       <button class="tb_btn" onclick="javascript:fn_closeImage();return false;" style="position: absolute;top: 210px; left: 170px;">닫기</button>
    </div>
</body>
</html>