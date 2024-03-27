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
	<script src="/js/page/LALM1004.js"></script>
	<body>
	<div class="contents">
		<%@ include file="/WEB-INF/common/menuBtn.jsp" %>
		<!-- content -->
		<section class="content">
			<!-- //tab_box e -->
			<form id="frm_MhSogCow">
			<!-- ------------------------------ 출장 내역 정보 ------------------------------ -->
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
									<col width="100">
									<col width="*">
									<col width="100">
									<col width="*">
									<col width="100">
									<col width="*">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><span class="tb_dot">경매대상</span></th>
										<td>
											<input type="hidden" id="auc_obj_dsc" name="auc_obj_dsc" class="reset_exc" />
											<div class="cellBox" id="rd_auc_obj_dsc" data-class="reset_exc"></div>
										</td>
										<th scope="row"><span>접수일자</span></th>
										<td>
											<div class="cellBox">
												<div class="cell">
													<input type="text" class="date reset_exc" id="rc_dt" maxlength="10" disabled />
												</div>
											</div>
										</td>
										<th scope="row"><span class="tb_dot">경매일자</span></th>
										<td>
											<div class="cellBox">
												<div class="cell">
													<input type="text" class="date popup reset_exc" id="auc_dt" maxlength="10" />
												</div>
											</div>
										</td>
										<th scope="row"><span class="tb_dot">경매차수</span></th>
										<td>
											<input disabled="disabled" type="text" id="ddl_qcn" style="width:100px" class="reset_exc" />
										</td>
										<th scope="row"><span>경매번호</span></th>
										<td>
											<input type="text" id="auc_prg_sq" style="width:100px" disabled />
											<input type="checkbox" id="auto_inc_yn" name="auto_inc_yn" class="no_chg" value="1" checked />
											<label for="auto_inc_yn">자동증가</label>
										</td>
									</tr>
									<tr>
										<th scope="row"><span class="tb_dot">출하자</span></th>
										<td colspan=3>
											<input disabled="disabled" type="hidden" id="farm_amnno" style="width:100px" />
											<input disabled="disabled" type="text" id="fhs_id_no" class="required" alt="출하자" style="width:100px" />
											<input type="text" id="ftsnm" class="required" alt="출하자" style="width:100px; font-weight:bold;" />
											<button type="button" id="pb_ftsnm" class="tb_btn white srch">
												<i class="fa fa-search"></i>
											</button>
											<select id="io_sogmn_maco_yn" style="width:100px">
												<option value="1">조합원</option>
												<option value="0">비조합원</option>
											</select>
											<select id="jrdwo_dsc" style="width:100px"></select>
										</td>
										<th scope="row"><span>주소</span></th>
										<td colspan="2">
											<input disabled="disabled" type="text" id="zip" style="width:100px;" />
											<input disabled="disabled" type="text" id="dongup" style="width: calc(100% - 105px);" />
										</td>
										<td>
											<input disabled="disabled" type="text" id="dongbw" />
										</td>
										<th scope="row"><span>연락처</span></th>
										<td>
											<input disabled="disabled" type="text" id="ohse_telno" />
										</td>
									</tr>
									<tr style="display:none;">
										<th scope="row"><span>생산지역</span></th>
										<td colspan="4">
											<input type="text" id="sra_pd_rgnnm" maxlength="50" />
										</td>
										<th scope="row"><span>생산자</span></th>
										<td>
											<input disabled="disabled" type="text" id="sogmn_c" />
										</td>
										<td>
											<input type="text" id="sra_pdmnm" style="width:110px" />
											<button id="pb_sra_pdmnm" class="tb_btn white srch">
												<i class="fa fa-search"></i>
											</button>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<!-- ------------------------------ 개체 정보 ------------------------------ -->
				<div class="sec_table">
					<div class="grayTable rsp_v">
						<table>
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
								<col width="100">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><span class="tb_dot">성별</span></th>
									<td>
										<select id="indv_sex_c" class="required" alt="성별" style="font-weight:bold;"></select>
									</td>
									<th scope="row"><span>중량</span></th>
									<td>
										<input type="text" class="number" id="cow_sog_wt" maxlength="8" />
									</td>
									<th scope="row"><span>예정가</span></th>
									<td>
										<input type="text" class="number" id="lows_sbid_lmt_am_ex" maxlength="8" style="width: 40%;" />
										<input type="text" disabled="disabled" class="number" id="lows_sbid_lmt_am" style="width: 55%;" />
									</td>
									<th scope="row"><span>50kg 이상</span></th>
									<td>
										<input type="text" class="number" id="sog_hdcn_01" maxlength="8" value="0" />
									</td>
									<th scope="row"><span>20kg 이상</span></th>
									<td>
										<input type="text" class="number" id="sog_hdcn_02" maxlength="8" value="0" />
									</td>
									<th scope="row"><span>20kg 미만</span></th>
									<td>
										<input type="text" class="number" id="sog_hdcn_03" maxlength="8" value="0" />
									</td>
								</tr>
								<tr>
									<th scope="row"><span>등록구분</span></th>
									<td>
										<select id="rg_dsc"></select>
									</td>
									<th scope="row"><span>예방접종일</span></th>
									<td>
										<div class="cellBox">
											<div class="cell">
												<input type="text" class="date" id="vacn_dt" style="font-weight:bold;" />
											</div>
										</div>
									</td>
									<th scope="row"><span>브루셀라</span></th>
									<td colspan="3">
										<div class="cellBox">
											<div class="cell">
												<input type="text" class="date" id="brcl_isp_dt" style="font-weight:bold;" />
											</div>
											<div class="cell" style="padding-left:10px;">
												<input type="checkbox" id="brcl_isp_ctfw_smt_yn" name="brcl_isp_ctfw_smt_yn" class="no_chg" value="0" />
												<label for="brcl_isp_ctfw_smt_yn">검사증 확인</label>
											</div>
											<div class="cell">
												<input type="checkbox" id="mt12_ovr_yn" name="mt12_ovr_yn" class="no_chg" value="0" />
												<label for="mt12_ovr_yn">12개월 이상</label>
											</div>
										</div>
									</td>
									<th scope="row"><span>비고</span></th>
									<td colspan="3">
										<input type="text" id="rmk_cntn">
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
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="250">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
								<col width="100">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><span>예정가변경</span></th>
									<td>
										<input disabled="disabled" type="text" id="lwpr_chg_nt" />
									</td>
									<th scope="row"><span>중도매인</span></th>
									<td>
										<input disabled="disabled" type="text" id="trmn_amnno" style="width: 85px" />
										<input type="text" id="sra_mwmnnm" style="width:90px" />
										<button type="button" id="pb_sra_mwmnnm" class="tb_btn white srch"><i class="fa fa-search"></i></button>
									</td>
									<th scope="row"><span>경매참가번호</span></th>
									<td>
										<input disabled="disabled" type="text" id="lvst_auc_ptc_mn_no" />
									</td>
									<th scope="row"><span>낙찰금액</span></th>
									<td>
										<input type="text" class="number" id="sra_sbid_upr" maxlength="8" />
									</td>
									<td>
										<!-- 낙찰단가 -->
										<input disabled="disabled" type="text" class="number" id="sra_sbid_am" />
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
							<tbody id="hiddenBody" style="display:none">
								<tr>
									<td>
										<input type="hidden" id="oslp_no" alt="접수번호" />
									</td>
									<td>
										<input type="hidden" id="led_sqno" alt="접수일련번호" />
									</td>
									<td>
										<input type="hidden" id="sra_srs_dsc" alt="축종구분" />
									</td>
									<td>
										<input type="hidden" id="fir_lows_sbid_lmt_am" class="number" alt="최초예정가" />
									</td>
									<td>
										<input type="hidden" id="sog_na_trpl_c" alt="출하경제통합거래처코드" />
									</td>
									<td>
										<input type="hidden" id="io_mwmn_maco_yn" alt="중도매인 조합원 구분" />
									</td>
									<td>
										<input type="hidden" id="sra_indv_amnno" alt="개체번호" />
									</td>
									<td>
										<input type="hidden" id="td_rc_cst" alt="당일접수비용" />
									</td>
									<td>
										<input type="hidden" id="chg_pgid" value="[LM1004]" />
									</td>
									<td>
										<input type="hidden" id="chg_rmk_cntn" alt="변경사유" />
									</td>
									<td>
										<input type="hidden" id="chg_del_yn" alt="삭제여부" />
									</td>
									<td>
										<input type="hidden" id="ppgcow_fee_dsc" alt="" />
									</td>
									<td>
										<input type="hidden" id="sra_farm_acno" alt="출하자 계좌번호" />
									</td>
									<td>
										<input type="checkbox" id="fee_chk_yn" name="fee_chk_yn" value="0" alt="출하수수료 수기등록여부" />
										<input disabled="disabled" type="text" id="fee_chk_yn_fee" style="width:120px" value="0" alt="출하수수료 수기입력금액" />
									</td>
									<td>
										<input type="checkbox" id="selfee_chk_yn" name="selfee_chk_yn" value="0" alt="판매수수료 수기등록여부" />
										<input disabled="disabled" type="text" id="selfee_chk_yn_fee" style="width:120px" value="0" alt="판매수수료 수기입력금액" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
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
			<div class="sec_table">
				<div class="grayTable rsp_v">
					<form id="frm_Search" name="frm_Search" autocomplete="off">
						<table>
							<colgroup>
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
									<th scope="row">경매대상구분</th>
									<td>
										<input type="hidden" id="sch_auc_obj_dsc" name="sc_auc_obj_dsc" />
										<div class="cellBox" id="sc_auc_obj_dsc" style="width:40%;">
										</div>
									</td>
									<th scope="row">경매일자</th>
									<td>
										<div class="cellBox">
											<div class="cell">
												<input type="text" class="date" id="sch_auc_dt" maxlength="10" style="width:48.3%;" />
											</div>
										</div>
									</td>
									<th scope="row">출하주</th>
									<td>
										<div class="cellBox v_addr">
											<div class="cell" style="width: 60px;">
												<input type="text" id="sch_fhs_id_no" maxlength="10" readonly="readonly" />
											</div>
											<div class="cell pl2" style="width: 28px;">
												<button id="pb_searchFhs" class="tb_btn white srch" type="button">
													<i class="fa fa-search"></i>
												</button>
											</div>
											<div class="cell">
												<input type="text" id="sch_ftsnm" maxlength="30" />
											</div>
										</div>
									</td>
									<th scope="row">경매번호</th>
									<td>
										<div class="cellBox" >
											<input type="text" name="usrnm" id="usrnm" value="" maxlength="10" />
										</div>
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
				<table id="grd_MhSogCow"></table>
			</div>

			<div class="listTable rsp_v" id="grd_AucQcnGrid">
				<table id="aucQcnGrid" style="width:100%;">
				</table>
			</div>
			
			<div class="listTable rsp_v" id="grd_MhFee">
				<table id="mhFeeGrid" style="width:100%;">
				</table>
			</div>
		</section>
	</div>
	</body>
	</html>