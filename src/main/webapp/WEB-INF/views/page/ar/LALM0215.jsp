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
	var pageInfos = setDecryptData('${pageInfo}');
</script>
<script src="/js/page/LALM0215.js"></script>
<body>
    <div class="contents">
        <%@ include file="/WEB-INF/common/menuBtn.jsp" %>

        <!-- content -->
        <section class="content">
			<div class="tab_box clearfix line">
				<ul class="tab_list fl_L">
					<li><a href="#tab1" id="pb_tab1" class="on">출장우정보</a></li>
					<li><a href="#tab2" id="pb_tab2" style="display:none;">송아지정보</a></li>
					<li><a href="#tab3" id="pb_tab3">이미지</a></li>
				</ul>
                              
                <div class="fl_R" id="tab1_text"><!--  //버튼 모두 우측정렬 -->   
                    <label id="msg_Sbid" style="font-size:15px;color: blue;font: message-box;">※ 관외 개체의 경우 귀표번호 12자리를 입력한 후 엔터를 치시거나 개체이력조회 버튼을 클릭하세요.</label>
                    <input type="checkbox" id=chk_continue name="chk_continue" value="0"> <label id="msg_Sbid1" style="font-size:5px;color: red;font: message-box;">수수료미적용 연속등록</label>
                    <input type="checkbox" id="chk_continue1" name="chk_continue1" value="0"> <label id="msg_Sbid2" style="font-size:5px;color: red;font: message-box;">출하수수료 연속등록</label> 
                    <label id="msg_Sbid3" style="font-size:5px;color: red;font: message-box;">(단위)</label>
                </div>
                
                <div class="fl_R" id="tab2_text" style="display:none;"><!--  //버튼 모두 좌측정렬 -->   
                    <button class="tb_btn" id="pb_plusRow">행추가</button>
                    <button class="tb_btn" id="pb_minusRow">행삭제</button>
                </div>
                
                <div class="fl_R" id="tab3_text">
                    <label id="msg_Sbid" style="color: red;font: message-box;">이미지는 최대 8장입니다.</label>
                </div>
			</div>
             
            <!-- //tab_box e -->
            <form id="frm_MhSogCow">
            
            	<!-- ------------------------------ 출장우 정보 탭 ------------------------------ -->
            	<!-- ------------------------------ 출장우 정보 ------------------------------ -->
           	<div id="tab1" class="tab_content">
           		<div class="sec_table">
            		<div class="sec_table">
            			<div class="grayTable rsp_v">
            				<table>
            					<colgroup>
		                            <col width="100">
		                            <col width="*">
		                            <col width="100">
		                            <col width="*">
		                            <col width="130">
		                            <col width="120">
		                            <col width="*">
		                            <col width="*">
		                            <col width="150">
		                            <col width="150">
		                            <col width="150">
		                        </colgroup>
		                        <tbody>
		                        	<tr>
		                                <th scope="row"><span class="tb_dot">경매대상</span></th>
		                                <td colspan=2>
		                                    <div class="cellBox" id="rd_auc_obj_dsc"></div>
                                    		<input type="hidden" id="auc_obj_dsc" name="auc_obj_dsc">
		                                </td>
		                                <th scope="row"><span class="tb_dot">경매일자</span></th>
		                                <td colspan=2>
		                                    <div class="cellBox">
		                                        <div class="cell"><input type="text" class="date popup" id="auc_dt" maxlength="10"></div>                                        
		                                    </div>
		                                </td>
		                                <th scope="row"><span class="tb_dot">경매차수</span></th>
		                                <td>
		                                	<input disabled="disabled" type="text" id="ddl_qcn" style="width:100px">
		                                </td>
		                                <th scope="row"><span>경매번호</span></th>
		                                <td>
		                                    <input type="text" id="auc_prg_sq" style="width:100px">
		                                    <input type="hidden" id="hd_auc_prg_sq" style="width:100px">
		                                    <input type="checkbox" id="chack_on" name="chack_on" class="no_chg" value="0" />                                                        
		                                </td>
		                                <td>
		                                	<button class="tb_btn" id="pb_auc_prg_sq" value="경매번호조회">경매번호조회</button>
		                                </td>
		                            </tr>
		                            
		                            <tr>
		                            	<th scope="row"><span>접수일자</span></th>
		                            	<td>
		                                    <div class="cellBox">
		                                        <div class="cell"><input type="text" class="date" id="rc_dt" maxlength="10"></div>                                        
		                                    </div>
		                                </td>
		                                <th scope="row"><span class="tb_dot">귀표번호</span></th>
		                                <td colspan=2>
		                                	<input disabled="disabled" type="text" id="hed_indv_no" style="width:70px">
		                            		<input type="text" id="sra_indv_amnno" class="popup" style="width:150px"  maxlength="12">
		                            		<button id="pb_sra_indv_amnno" class="tb_btn white srch"><i class="fa fa-search"></i></button>
		                            	</td>
		                            	<td>
		                                	<button class="tb_btn" id="pb_IndvHst" value="개체이력조회">개체이력조회</button>
		                                	<input type="checkbox" id="chk_AucNoChg" name="chk_AucNoChg" value="0">
		                                	<button class="tb_btn" id="pb_Indvfhs" value="등록">등록</button>
		                                </td>
		                                <th scope="row"><span>경매번호기준</span></th>
		                                <td>
		                            		<input type="radio" id="rd_gvno_bascd_0"  name="rd_gvno_bascd" value="0" checked> 순번 &nbsp;
		                                    <input type="radio" id="rd_gvno_bascd_1"  name="rd_gvno_bascd" value="1"> 짝수 &nbsp;
		                                    <input type="radio" id="rd_gvno_bascd_2"  name="rd_gvno_bascd" value="2"> 홀수 &nbsp;
		                                    <input type="hidden" id="gvno_bascd" name="gvno_bascd">                                                   
		                                </td>
		                                <th scope="row"><span>개체이월</span></th>
		                                <td>
		                                    <div class="cellBox">
		                                        <div class="cell"><input type="text" class="date" id="auc_chg_dt"></div>                                        
		                                    </div>
		                                </td>
		                                <td>
		                                	<button class="tb_btn" id="pb_AucChange" value="개체이월">개체이월</button>
		                                </td>
		                            </tr>
		                            
		                            <tr>
		                            	<th scope="row"><span>출하주</span></th>
		                            	<td colspan=3>
		                            		<input disabled="disabled" type="text" id="fhs_id_no" style="width:100px">
		                            		<span> - </span>
		                            		<input disabled="disabled" type="text" id="farm_amnno" style="width:100px">
		                            		<input type="text" id="ftsnm" style="width:100px; font-weight:bold;">
		                            		<button id="pb_ftsnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
		                                    <select id="io_sogmn_maco_yn" style="width:100px">
		                                    	<option value="1">조합원</option>
		                                    	<option value="0">비조합원</option>		                                    	
		                                    </select>
		                                </td>
		                            	<th scope="row"><span>주소</span></th>
		                            	<td colspan=2>
		                            		<input disabled="disabled" type="text" id="zip">
		                            	</td>
		                            	<td colspan=2>
		                            		<input disabled="disabled" type="text" id="dongup">
		                            	</td>
		                            	<td colspan=2>
		                            		<input disabled="disabled" type="text" id="dongbw">
		                            	</td>
		                            </tr>
		                            
		                            <tr>
		                            	<th scope="row"><span>연락처</span></th>
		                            	<td>
		                            		<input disabled="disabled" type="text" id="ohse_telno">
		                            	</td>
		                            	<th scope="row"><span>생산지역</span></th>
		                            	<td colspan=5>
		                            		<input type="text" id="sra_pd_rgnnm"  maxlength="50"/>
		                            	</td>
		                            	<th scope="row"><span>생산자</span></th>
		                            	<td>
		                            		<input disabled="disabled" type="text" id="sogmn_c">
		                            	</td>
		                            	<td>
		                            		<input type="text" id="sra_pdmnm" style="width:110px">
		                            		<button id="pb_sra_pdmnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
		                            	</td>
		                            </tr>
		                            
		                            <tr>
		                            	<th scope="row"><span>수송자</span></th>
		                            	<td>
		                            		<input disabled="disabled" type="text" id="vhc_shrt_c">
		                            	</td>
		                            	<td colspan=2>
		                            		<input type="text" id="vhc_drv_caffnm" style="width:150px">
		                            		<button id="pb_vhc_drv_caffnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
		                            	</td>
		                            	<th scope="row"><span>자가운송여부</span></th>
		                            	<td colspan=3>
		                            		<input type="checkbox" id="trpcs_py_yn" class="checked" name="trpcs_py_yn" value="1" checked="checked" />
                                    		<label id="trpcs_py_yn_text" for="trpcs_py_yn"> 여</label>
		                            	</td>
		                            	<th scope="row"><span>거치대번호</span></th>
		                                <td colspan=2>
		                                    <input disabled="disabled" type="text" id="modl_no" style="width:100px">                                                        
		                                </td>
		                            </tr>
		                            
		                            <tr>
		                            	<th scope="row"><span>추가운송비</span></th>
		                            	<td>
		                            		<input type="text" class="number" id="sra_trpcs" maxlength="8">
		                            	</td>
		                            	<th scope="row"><span>출자금</span></th>
		                            	<td>
		                            		<input type="text" class="number" id="sra_pyiva" maxlength="8">
		                            	</td>
		                            	<th scope="row"><span>사료대금(공제금)</span></th>
		                            	<td colspan=2>
		                            		<input type="text" class="number" id="sra_fed_spy_am" maxlength="8">
		                            	</td>
		                            	<th scope="row"><span>당일접수비</span></th>
		                            	<td>
		                            		<input type="text" class="number" id="td_rc_cst" maxlength="8">
		                            	</td>
		                            	<th scope="row"><span>사료사용여부</span></th>
		                            	<td>
		                            		<input type="checkbox" id="sra_fed_spy_yn" name="sra_fed_spy_yn" value="0">
                                    		<label id="sra_fed_spy_yn_text" for="sra_fed_spy_yn"> 부</label>
		                            		<input type="text" disabled="disabled" class="number"id="sra_fed_spy_yn_fee" style="width:80px">
		                            	</td>
		                            </tr>
		                        </tbody>
            				</table>
            			</div>
            		</div>
            	</div>
            	
            	<div class="tab_box clearfix">
					<p>※등록되지 않은 개체의 경우 하단의 개체정보를 입력하신 후 저장하시기 바랍니다.</p>
	            </div>
	            
	            <!-- ------------------------------ 개체 정보 ------------------------------ -->
	            <div class="sec_table">
	            	<div class="grayTable rsp_v">
	            		<table>
	            			<colgroup>
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                        </colgroup>
	                        <tbody>
	                        	<tr>
	                            	<th scope="row"><span>개체성별코드</span></th>
	                            	<td>
	                                    <select id="indv_sex_c"  style="font-weight:bold;"></select>
	                                </td>
	                            	<th scope="row"><span>생년월일</span></th>
	                            	<td>
	                            		<div class="cellBox">
	                                        <div class="cell"><input type="text" class="date" id="birth"></div>                                        
	                                    </div>
	                            	</td>
	                            	<th scope="row"><span>개체관리번호</span></th>
	                            	<td>
	                            		<input type="text" id="indv_id_no">
	                            	</td>
	                            	<th scope="row"><span>등록번호</span></th>
	                            	<td>
	                            		<input type="text" style="text-align:right;"  id="sra_indv_brdsra_rg_no">
	                            	</td>
	                            	<th scope="row"><span>등록구분</span></th>
	                            	<td>
	                            		<select id="rg_dsc"></select>
	                            	</td>
	                            </tr>
	                            
	                            <tr>
	                            	<th scope="row"><span>KPN번호</span></th>
	                            	<td>
	                                    <input type="text" id="kpn_no" style="font-weight:bold;">
	                                </td>
	                            	<th scope="row"><span>어미구분</span></th>
	                            	<td>
	                            		<select id="mcow_dsc"></select>
	                            	</td>
	                            	<th scope="row"><span>어미귀표번호</span></th>
	                            	<td>
	                            		<input type="text" id="mcow_sra_indv_amnno">
	                            	</td>
	                            	<th scope="row"><span>어미산차</span></th>
	                            	<td>
	                            		<input type="text" style="text-align:right;" id="matime" value="0">
	                            	</td>
	                            	<th scope="row"><span>계대</span></th>
	                            	<td>
	                            		<input type="text" style="text-align:right;" id="sra_indv_pasg_qcn" value="0">
	                            	</td>
	                            </tr>
	                            
	                            <tr>
	                            	<th scope="row"><span>브랜드명</span></th>
	                            	<td colspan=7>
	                                    <input disabled="disabled" type="text" id="brandnm" style="width:250px">
	                                </td>
	                            	<th scope="row"><span>송아지혈통수수료</span></th>
	                            	<td>
	                            		<input disabled="disabled" type="text" id="blood_am">
	                            	</td>
	                            </tr>
	                            
	                        </tbody>
	            		</table>
	            	</div>
	            </div>
	            
	            <!-- ------------------------------ 중도매인 정보 ------------------------------ -->
	            <div class="sec_table">
	            	<div class="grayTable rsp_v">
	            		<table>
	            			<colgroup>
	                            <col width="*">
	                            <col width="100">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                            <col width="*">
	                        </colgroup>
	                        <tbody>
	                        	<tr>
	                            	<th scope="row"><span>중도매인</span></th>
	                            	<td>
	                                    <input disabled="disabled" type="text" id="trmn_amnno">
	                                </td>
	                                <td>
	                            		<input type="text" id="sra_mwmnnm" style="width:100px">
	                            		<button id="pb_sra_mwmnnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
	                            	</td>
	                            	<th scope="row"><span>경매참가번호</span></th>
	                            	<td>
	                                    <input disabled="disabled" type="text" id="lvst_auc_ptc_mn_no">
	                                </td>
	                                <th scope="row"><span>낙찰금액</span></th>
	                                <td>
	                            		<input type="text" class="number" id="sra_sbid_upr" maxlength="8">
	                            	</td>
	                            	<td>
	                                    <input disabled="disabled" type="text" class="number" id="sra_sbid_am">
	                                </td>
	                                <th scope="row"><span>진행상태</span></th>
	                                <td>
	                            		<select id="sel_sts_dsc"></select>
	                            	</td>
	                            </tr>
	                        </tbody>
	            		</table>
	            	</div>
	            </div>
	            
	            <!-- ------------------------------ 접종 정보 ------------------------------ -->
				<div class="sec_table" style="border: solid 2px #ff3859;padding: 5px;">
					<div class="grayTable rsp_v">
						<table>
							<colgroup>
							    <col width="120">
							    <col width="*">
							    <col width="120">
							    <col width="*">
							    <col width="120">
							    <col width="*">
							    <col width="120">
							    <col width="*">
							    <col width="120">
							    <col width="*">
							</colgroup>
							<tbody> 
	                            <tr>
	                            	<th scope="row"><span>브루셀라검사일</span></th>
	                            	<td>
	                            		<div class="cellBox">
	                                        <div class="cell"><input type="text" class="date" id="brcl_isp_dt" style="font-weight:bold;"></div>                                        
	                                    </div>
	                            	</td>
	                            	<th scope="row" colspan=><span>브루셀라<br/>검사증제출여부</span></th>
	                            	<td>
	                            		<input type="checkbox" id="brcl_isp_ctfw_smt_yn" name="brcl_isp_ctfw_smt_yn" value="0">
	                            		<label id="brcl_isp_ctfw_smt_yn_text" for="brcl_isp_ctfw_smt_yn"> 부</label>
	                            		<input type="hidden" class="number" id="brcl_isp_rzt_c" maxlength="1">
	                            	</td>
	                            	<th scope="row" colspan=1><span>구제역<br/>접종차수</span></th>
	                            	<td>
                           				<input type="text" id="vacn_order" name="vacn_order" value=""></input>
	                            	</td>
	                            	<th scope="row" colspan=1><span>구제역<br/>예방접종일</span></th>
	                            	<td>
	                            		<div class="cellBox">
	                                        <div class="cell"><input type="text" class="date" id="vacn_dt" style="font-weight:bold;"></div>                                        
	                                    </div>
	                            	</td>
	                        		<th scope="row"><span>우결핵<br/>검사일</span></th>
	                        		<td>
	                            		<div class="cellBox">
	                                        <div class="cell"><input type="text" class="date" id="bovine_dt"></div>                                        
	                                    </div>
	                            	</td>
	                            	<td>
                           				<input type="text" id="bovine_rsltnm" name="bovine_rsltnm" value=""></input>
	                            	</td>
	                            </tr>
							</tbody>
						</table>
					</div>
				</div>
	            <!-- ------------------------------ 기타정보 ------------------------------ -->
	            <div class="sec_table">
	            	<div class="grayTable rsp_v">
	            		<table>
	                        <colgroup>
	                            <col width="120">
	                            <col width="120">
	                            <col width="130">
	                            <col width="80">
	                            <col width="80">
	                            <col width="110">
	                            <col width="120">
	                            <col width="80">
	                            <col width="100">
	                            <col width="100">
	                            <col width="80">
	                            <col width="100">
	                            <col width="100">
	                            <col width="80">
	                            <col width="100">
	                            <col width="100">
	                            <col width="40">
	                        </colgroup>
	                        <tbody>
	                        	<tr>
	                            	<th scope="row"><span>중량</span></th>
	                            	<td>
	                                    <input type="text" class="number" id="cow_sog_wt" maxlength="8">
	                                </td>
	                            	<th scope="row"><span>예정가</span></th>
	                            	<td colspan=1>
	                            		<input type="text" class="number" id="lows_sbid_lmt_am_ex" maxlength="8">
	                            	</td>
	                            	<td colspan=1>
	                            		<input type="text" disabled="disabled" class="number" id="lows_sbid_lmt_am">
	                            	</td>
	                            	<th scope="row" colspan=1><span>예정가<br/>변경횟수</span></th>
	                            	<td colspan=3>
	                            		<input disabled="disabled" type="text" id="lwpr_chg_nt">
	                            	</td>
	                            	<th scope="row"><span>체장</span></th>
	                            	<td colspan=2>
	                            		<input type="text" class="number" id="bdln_val">
	                            	</td>
	                            	<th scope="row"><span>체고</span></th>
	                            	<td colspan=2>
	                            		<input type="text" class="number" id="bdht_val">
	                            	</td>
	                            	<td colspan=3></td>
	                            </tr>
	                            	                        
	                        	<tr>
	                            	<th scope="row"><span>제각여부</span></th>
	                            	<td>
	                            		<input type="checkbox" id="rmhn_yn" name="rmhn_yn" value="0">
	                            		<label id="rmhn_yn_text" for="rmhn_yn"> 부</label>
	                            	</td>
	                            	<th scope="row"><span>난소적출여부</span></th>
	                            	<td colspan='2'>
	                            		<input type="checkbox" id="spay_yn" name="spay_yn" value="0">
	                            		<label id="spay_yn_text" for="spay_yn"> 부</label>
	                            	</td>
	                            	<th scope="row"><span>친자확인결과</span></th>
	                            	<td colspan='3'>
	                            		<select id="dna_yn">
	                                    	<option value="3">정보없음</option>
	                                    	<option value="1">일치</option>
	                                    	<option value="2">완전불일치</option>
	                                    	<option value="4">부불일치</option>
	                                    	<option value="5">모불일치</option>
	                                    	<option value="6">부or모불일치</option>
	                            		</select>
	                            	</td>
	                            	<th scope="row"><span>친자<br/>검사여부</span></th>
	                            	<td colspan='2'>
	                            		<input type="checkbox" id="dna_yn_chk" name="dna_yn_chk" value="0">
	                            		<label id="dna_yn_chk_text" for="dna_yn_chk"> 부</label>
	                            	</td>
	                            	<th scope="row" colspan=1><span>수의사</span></th>
	                            	<td colspan=2>
	                            		<select id="lvst_mkt_trpl_amnno"></select>
	                            	</td>
	                            	<td colspan=3></td>
	                            </tr>	        
	                            
	                            <tr>
	                            	<th scope="row"><span>비고</span></th>
	                            	<td colspan=4>
	                            		<input type="text" id="rmk_cntn">
	                            	</td>
	                            	<th scope="row" colspan=1><span>출하수수료<br> 수기등록</span></th>
	                            	<td colspan=3>
	                            		<input type="checkbox" id="fee_chk_yn" name="fee_chk_yn" value="0">
	                            		<label id="fee_chk_yn_text" for="fee_chk_yn"> 부</label>
	                            		<input disabled="disabled" type="text" id="fee_chk_yn_fee" style="width:120px" value="0">
	                            	</td>
	                            	<th scope="row" colspan=1><span>판매수수료<br> 수기등록</span></th>
	                            	<td colspan=2>
	                            		<input type="checkbox" id="selfee_chk_yn" name="selfee_chk_yn" value="0">
	                            		<label id="selfee_chk_yn_text" for="selfee_chk_yn"> 부</label>
	                            		<input disabled="disabled" type="text" id="selfee_chk_yn_fee" style="width:120px" value="0">
	                            	</td>
	                            	<th scope="row" colspan="1"><span>구분</span></th>
	                            	<td colspan="2">
	                            		<select id="case_cow">
	                            			<option value="1" selected="selected">등록</option>
	                            			<option value="2">일반</option>
	                            			<option value="3">으뜸</option>
	                            			<option value="4">친자</option>
	                            		</select>
	                            	</td>
	                            </tr>
	                        </tbody>
	                        <tbody id="firstBody">
	                        	<tr>
                            		<th scope="row"><span>임신구분</span></th>
                            		<td>
	                            		<select id="ppgcow_fee_dsc"></select>
	                            	</td>
	                            	<th scope="row"><span>인공수정일자</span></th>
	                            	<td colspan=2>
	                            		<div class="cellBox">
	                                        <div class="cell"><input type="text" class="date" id="afism_mod_dt"></div>                                        
	                                    </div>
	                            	</td>
	                            	<th scope="row" colspan="1"><span>인공수정증명서<br/>제출여부</span></th>
	                            	<td colspan="1">
	                            		<input type="checkbox" id="afism_mod_ctfw_smt_yn" name="afism_mod_ctfw_smt_yn" value="0">
	                            		<label id="afism_mod_ctfw_smt_yn_text" for="afism_mod_ctfw_smt_yn"> 부</label>
	                            	</td>
	                            	<th scope="row" colspan=2><span>수정KPN</span></th>
	                            	<td colspan=2>
	                            		<input type="text" id="mod_kpn_no" maxlength="9">
	                            	</td>
	                            	<th scope="row" colspan=2><span>분만예정일</span></th>
	                            	<td colspan=2>
	                            		<input disabled="disabled" type="text" class="date" id="ptur_pla_dt" maxlength="10">
	                            	</td>
                           		</tr>
                           		
                           		<tr>
                            		<th scope="row"><span>임신개월수</span></th>
                            		<td>
	                            		<input type="text" class="number" id="prny_mtcn" maxlength="2">
	                            	</td>
	                            	<th scope="row"><span>임신감정여부</span></th>
	                            	<td colspan="2">
	                            		<input type="checkbox" id="prny_jug_yn" name="prny_jug_yn" value="0">
	                            		<label id="prny_jug_yn_text" for="prny_jug_yn"> 부</label>
	                            	</td>
	                            	<th scope="row"><span>임신여부</span></th>
	                            	<td colspan="1">
	                            		<input type="checkbox" id="prny_yn" name="prny_yn" value="0">
	                            		<label id="prny_yn_text" for="prny_yn"> 부</label>
	                            	</td>
	                            	<th scope="row" colspan=2><span>괴사감정여부</span></th>
	                            	<td colspan=2>
	                            		<input type="checkbox" id="ncss_jug_yn" name="ncss_jug_yn" value="0">
	                            		<label id="ncss_jug_yn_text" for="ncss_jug_yn"> 부</label>
	                            	</td>
	                            	<th scope="row" colspan=2><span>괴사여부</span></th>
	                            	<td colspan=2>
	                            		<input type="checkbox" id="ncss_yn" name="ncss_yn" value="0">
	                            		<label id="ncss_yn_text" for="ncss_yn"> 부</label>
	                            	</td>
                           		</tr>
	                        </tbody>
	                        
	                        <tbody id="secondBody">
	                        	<tr>
	                        		<th scope="row"><span>12개월이상여부</span></th>
	                        		<td>
	                            		<input type="checkbox" id="mt12_ovr_yn" name="mt12_ovr_yn" value="0">
	                            		<label id="mt12_ovr_yn_text" for="ncss_yn"> 부</label>
	                            	</td>
	                        		<th scope="row"><span>12개월이상수수료</span></th>
	                        		<td colspan=3>
	                            		<input type="text" class="number" id="mt12_ovr_fee" maxlength="8">
	                            	</td>
	                            	<td colspan=12></td>
	                        	</tr>
	                        </tbody>
	                        
	                        <tbody id="thirdBody">
	                        	<tr>
	                        		<th scope="row"><span>고능력 여부</span></th>
	                        		<td>
	                            		<input type="checkbox" id="epd_yn" name="epd_yn" value="0">
	                            		<label id="epd_yn_text" for="ncss_yn"> 부</label>
	                            	</td>
	                        		<th scope="row"><span>유전능력(EPD)</span></th>
	                        		<th scope="row"><span>냉도체중</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_1" style="width:100px">
	                            		<select id="re_product_1_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                        		<th scope="row"><span>배최장근단면적</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_2" style="width:100px">
	                            		<select id="re_product_2_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                        		<th scope="row"><span>등지방두께</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_3" style="width:100px">
	                            		<select id="re_product_3_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                        		<th scope="row"><span>근내지방도</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_4" style="width:100px">
	                            		<select id="re_product_4_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                            	<td colspan=3></td>
	                        	</tr>
	                        	
	                        	<tr>
	                        		<th scope="row"><span>전이용사료여부</span></th>
	                        		<td>
	                        			<input type="checkbox" id="fed_spy_yn" name="epd_yn" value="0">
	                            		<label id="fed_spy_yn_text" for="ncss_yn"> 부</label>
	                        		</td>
	                        		<th scope="row"><span>유전능력(모개체)</span></th>
	                        		<th scope="row"><span>냉도체중</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_11" style="width:100px">
	                            		<select id="re_product_11_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                        		<th scope="row"><span>배최장근단면적</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_12" style="width:100px">
	                            		<select id="re_product_12_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                        		<th scope="row"><span>등지방두께</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_13" style="width:100px">
	                            		<select id="re_product_13_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                        		<th scope="row"><span>근내지방도</span></th>
	                        		<td colspan=2>
	                            		<input type="text" class="minusnumber" id="re_product_14" style="width:100px">
	                            		<select id="re_product_14_1" style="width:50px">
	                            			<option value="" selected></option>
	                                    	<option value="A">A</option>
	                                    	<option value="B">B</option>
	                                    	<option value="C">C</option>
	                                    	<option value="D">D</option>		                                    	
	                            		</select>
	                            	</td>
	                            	<td colspan=3></td>
	                        	</tr>
	                        </tbody>
	                        
	                        <tbody id="hiddenBody" style="display:none">
	                        	<tr>
		                        	<td>
		                        		<input type="hidden" id="oslp_no">
		                        	</td>
		                        	<td>
		                        		<input type="hidden" id="led_sqno">
		                        	</td>
		                        	<td>
		                        		<input type="hidden" id="sra_srs_dsc">
		                        	</td>
		                        	<td>
		                        		<input type="hidden" id="fir_lows_sbid_lmt_am" class="number">
		                        	</td>
		                        	<td>
		                        		<input type="hidden" id="sog_na_trpl_c">
		                        	</td>
		                        	<td>
		                        		<input type="hidden" id="io_mwmn_maco_yn">
		                        	</td>
		                        	<td>
		                        		<input type="hidden" id="tmp_hd_na_fee_c">
		                        	</td>
		                        	<td>
			            				<input type="hidden" id="re_indv_no">
			            			</td>
			            			<td>
			            				<input type="hidden" id="chg_pgid">
			            			</td>
			            			<td>
			            				<input type="hidden" id="chg_rmk_cntn">
			            			</td>
			            			<td>
			            				<input type="hidden" id="chg_del_yn">
			            			</td>
			            			<td>
			            				<input type="hidden" id="pda_id">
			            			</td>
			            			<td>
			            				<input type="hidden" id="sra_farm_acno">
			            			</td>
		                        </tr>
	                        </tbody>
	            		</table>
	            	</div>
	            </div>
	        </div>
	        <div id="tab2" class="tab_content">
	        	<table id="calfGrid" style="width:1807px;">
                </table>
	        </div>
	        <div id="tab3" class="tab_content">
				<jsp:include page="/WEB-INF/views/page/ar/LALM0215_IMG.jsp" flush="true" />
	        </div>
            </form>
            
            <form id="frm_emp" style="display:none;">
            	<div>
            		<table>
            			<tr>
	            			<td>
	            				<input type="hidden" id="emp_auc_prg_sq">
	            				<input type="hidden" id="emp_sra_indv_amnno">
	            			</td>
	            		</tr>
            		</table>
            	</div>
            </form>
            
            <form id="frm_Hdn" style="display:none">
            	<div>
            		<table>
            			<tr>
	            			<td>
	            				<input type="hidden" id="hdn_auc_dt">
	            				<input type="hidden" id="hdn_auc_obj_dsc">
	            				<input type="hidden" id="hdn_oslp_no">
	            			</td>
	            		</tr>
            		</table>
            	</div>
            </form>
            
            <div class="listTable rsp_v" id="grd_AucQcnGrid" style="display:none">
                <table id="aucQcnGrid" style="width:100%;">
                </table>
            </div>
            
            <div class="listTable rsp_v" id="grd_MhFee" style="display:none">
                <table id="mhFeeGrid" style="width:100%;">
                </table>
            </div>
            
		</section>
	</div>
</body>
</html>