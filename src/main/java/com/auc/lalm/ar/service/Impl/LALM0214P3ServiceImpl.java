package com.auc.lalm.ar.service.Impl;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.config.ConvertConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.filter.JwtRequestFilter;
import com.auc.lalm.ar.service.LALM0214P3Service;
import com.auc.lalm.co.service.Impl.LALM0221PMapper;
import com.auc.lalm.co.service.Impl.LALM0222PMapper;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;
import com.auc.mca.McaUtil;

@Service("LALM0214P3Service")
public class LALM0214P3ServiceImpl implements LALM0214P3Service{
	private static Logger log = LoggerFactory.getLogger(LALM0214P3ServiceImpl.class);
	@Autowired
	LogService logService;	
	@Autowired
	LALM0214P3Mapper lalm0214P3Mapper;	

	@Autowired
	LALM0215Mapper lalm0215Mapper;	
	@Autowired
	LALM0221PMapper lalm0221PMapper;	
	@Autowired
	LALM0222PMapper lalm0222PMapper;	
	
	@Autowired
	CommonService commonService;	
	@Autowired
	McaUtil mcaUtil;
	@Autowired
	ConvertConfig convertConfig;

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> LALM0214P3_insFhs(Map<String, Object> params) throws Exception{
		List<Map<String, Object>> reList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> inList = (List<Map<String, Object>>) params.get("excellist");
		
		for(Map<String,Object> map : inList) {
			List<Map<String, Object>> fhsList = lalm0214P3Mapper.lalm0214P3_selFhs(map);
			if(fhsList == null || fhsList.size() == 0) {
				//농가 인터페이스
			}else if(fhsList.size() > 1) {
				map.put("ftsnm", "중복농가");
				map.put("fhs_id_no", "");
				map.put("farm_amnno", "");
			}else {
				map.put("ftsnm", fhsList.get(0).get("FTSNM") );
				map.put("fhs_id_no", fhsList.get(0).get("FHS_ID_NO"));
				map.put("farm_amnno", fhsList.get(0).get("FARM_AMNNO"));
			}
			reList.add(map);
		}
		
		return reList;
				
	}

	//@SuppressWarnings("unchecked")
	//@Override
	//public Map<String, Object> LALM0214P3_insFhs(Map<String, Object> params) throws Exception{
	//	Map<String, Object> reMap = new HashMap<String, Object>();
	//	int insertNum = lalm0214P3Mapper.LALM0214P3_insFhs(params);
	//	reMap.put("insertNum", insertNum);
	//	return reMap;
	//			
	//}
	
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM0214P3_insSogCow(Map<String, Object> inMap) throws Exception{
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");
		
		int insertNum = 0;
		int updateNum = 0;
		int errCnt=0;
		StringBuilder sb = new StringBuilder();
		for(Map<String, Object> map : list) {
			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("auc_dt", inMap.get("auc_dt"));
			map.put("auc_obj_dsc", inMap.get("auc_obj_dsc"));			

			map.put("re_indv_no", map.get("sra_indv_amnno"));
			List<Map<String, Object>> aucPrgList = lalm0215Mapper.LALM0215_selAucPrg(map);			
			if(aucPrgList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된 경매번호("+map.get("auc_prg_sq")+")가 있습니다. 경매번호를 확인 바랍니다.");
			}
			//귀표번호 체크
			List<Map<String, Object>> indvAmnnoList = lalm0215Mapper.LALM0215_selIndvAmnno(map);			
			if(indvAmnnoList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,"동일한 경매일자에 동일한 귀표번호("+map.get("sra_indv_amnno")+")는 등록할수 없습니다.");
			}
			list = lalm0215Mapper.LALM0215_selVoslpNo(inMap);
			map.put("oslp_no", list.get(0).get("V_OSLP_NO").toString());
			map.put("modl_no", map.get("auc_prg_sq"));

			map.put("rc_dt", inMap.get("rc_dt"));			
			//map.put("sog_na_trpl_c", "");
			map.put("vhc_shrt_c", "");
			map.put("trmn_amnno", "");
			map.put("lvst_auc_ptc_mn_no", "");	
			String sraPdRgnnm = splitByte((String)map.get("sra_pd_rgnnm"),50);
			map.put("sra_pd_rgnnm", sraPdRgnnm);
			insertNum += lalm0214P3Mapper.LALM0214P3_insSogCow(map);
			
			map.put("chg_pgid", "LALM0214P3");
			map.put("chg_rmk_cntn", "출장우 일괄등록");
			insertNum += logService.insSogCowLog(map);
		}
		
		
		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		reMap.put("errCnt", errCnt);
		reMap.put("message", sb.toString());
		
		return reMap;
	}
	
	@SuppressWarnings({ "unused", "unchecked" })
	@Override
	public Map<String, Object> LALM0214P3_selIndvSync(Map<String, Object> inMap) throws Exception{
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");
		List<Map<String, Object>> reList = new ArrayList<>();
		
		int insertNum = 0;
		int updateNum = 0;
		
		for(Map<String, Object> map : list) {
			Map<String, Object> result = new HashMap<String, Object>();
			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("hid_sra_indv_amnno_c", "3");
			map.put("sra_indv_amnno", map.get("sra_indv_amnno"));
			
			result.put("AUC_OBJ_DSC", map.get("auc_obj_dsc"));
			result.put("AUC_PRG_SQ", map.get("auc_prg_sq"));
			result.put("AUC_OBJ_DSC", map.get("auc_obj_dsc"));
			result.put("TRPCS_PY_YN", map.get("trpcs_py_yn"));
			result.put("SRA_TRPCS", map.get("sra_trpcs"));
			result.put("SRA_PYIVA", map.get("sra_pyiva"));
			result.put("SRA_FED_SPY_AM", map.get("sra_fed_spy_am"));
			result.put("TD_RC_CST", map.get("td_rc_cst"));
			result.put("RMHN_YN", map.get("rmhn_yn"));
			result.put("MT12_OVR_YN", map.get("mt12_ovr_yn"));
			result.put("MT12_OVR_FEE", map.get("mt12_ovr_fee"));
			result.put("PPGCOW_FEE_DSC", map.get("ppgcow_fee_dsc"));
			result.put("AFISM_MOD_DT", map.get("afism_mod_dt"));
			result.put("AFISM_MOD_CTFW_SMT_YN", map.get("afism_mod_ctfw_smt_yn"));
			result.put("MOD_KPN", map.get("mod_kpn"));
			result.put("PRNY_MTCN", map.get("prny_mtcn"));
			result.put("PRNY_JUG_YN", map.get("prny_jug_yn"));
			result.put("PRNY_YN", map.get("prny_yn"));
			result.put("NCSS_JUG_YN", map.get("ncss_jug_yn"));
			result.put("NCSS_YN", map.get("ncss_yn"));
			result.put("RMK_CNTN", map.get("rmk_cntn"));
			result.put("DNA_YN_CHK", map.get("dna_yn_chk"));
			result.put("DNA_YN", map.get("dna_yn"));
			result.put("SRA_INDV_AMNNO", map.get("sra_indv_amnno"));
			result.put("FTSNM", map.get("ftsnm"));
			
			result.put("CHK_INF_ERR", "0");
			result.put("CHK_VAILD_ERR", "0");
			result.put("CHK_ERR_SRA_INDV_AMNNO", "0");
			result.put("CHK_ERR_AUC_PRG_SQ", "0");
			/* s: 개체정보 / 농가정보 동기화 */
			List<Map<String, Object>> indvList = lalm0221PMapper.LALM0221P_selList(map);
			if(indvList != null && indvList.size() == 1) {
				//개체정보 저장
				result.put("SRA_SRS_DSC", indvList.get(0).get("SRA_SRS_DSC"));
				result.put("SRA_INDV_AMNNO", indvList.get(0).get("SRA_INDV_AMNNO"));
				result.put("FHS_ID_NO", indvList.get(0).get("FHS_ID_NO"));
				result.put("FARM_AMNNO", indvList.get(0).get("FARM_AMNNO"));
				result.put("FTSNM", indvList.get(0).get("FTSNM"));
				result.put("SRA_PDMNM", indvList.get(0).get("FTSNM"));
				result.put("SRA_PD_RGNNM", indvList.get(0).get("DONGUP"));
				result.put("MCOW_SRA_INDV_AMNNO", indvList.get(0).get("MCOW_SRA_INDV_AMNNO"));
				result.put("SOG_NA_TRPL_C", indvList.get(0).get("NA_TRPL_C"));
				
				result.put("CHK_IF_SRA_INDV", "1");
				map.put("fhs_id_no", indvList.get(0).get("FHS_ID_NO"));
				map.put("farm_amnno", indvList.get(0).get("FARM_AMNNO"));
				List<Map<String, Object>> fhsList = lalm0215Mapper.LALM0215_selFhsIdNo(map);
				if(fhsList != null && fhsList.size() == 1) {
					result.put("FHS_ID_NO", fhsList.get(0).get("FHS_ID_NO"));
					result.put("FARM_AMNNO", fhsList.get(0).get("FARM_AMNNO"));
					result.put("FTSNM", fhsList.get(0).get("FTSNM"));
					result.put("CHK_IF_FHS", "1");
					
				}else {
					result.put("FHS_ID_NO", "");
					result.put("FARM_AMNNO", "");
					result.put("FTSNM", map.get("ftsnm"));
					result.put("CHK_IF_FHS", "0");
				}
			}
			else if(indvList == null || indvList.size() < 1){
				//인터페이스 
				try {
					map.put("sra_indv_amnno", map.get("sra_indv_amnno"));
					Map<String, Object> infIndvMap = mcaUtil.tradeMcaMsg("4700", map);
					Map<String, Object> dataMap = (Map<String, Object>) infIndvMap.get("jsonData");
					Map<String, Object> Demap = new HashMap<String, Object>();

					List<Map<String, Object>> infIndvList = null;
					List<Map<String, Object>> fhsList = null;
					
					String tmpZip = "";
					String tmpTelno = "";
					String tmpMpno = "";
					if(dataMap != null) {
						int inqCn = Integer.valueOf((String)dataMap.get("INQ_CN"));
						if(inqCn > 0) {
							Iterator<String> keys = dataMap.keySet().iterator();
							while(keys.hasNext()) {
								String key = keys.next();
								String value = "";
								if(dataMap.get(key) != null) value = dataMap.get(key).toString().trim(); 
								//log.debug("inf 4700 obj : "+key+" : "+value);
								Demap.put(key.toLowerCase(), value);
							}

							if(!Demap.get("sra_farm_fzip").equals("") || !Demap.get("sra_farm_rzip").equals("")) {
								tmpZip = Demap.get("sra_farm_fzip") + "-" + Demap.get("sra_farm_rzip");
							}
							if(!Demap.get("sra_farm_amn_atel").equals("") || !Demap.get("sra_farm_amn_htel").equals("") || !Demap.get("sra_farm_amn_stel").equals("")) {
								tmpTelno = Demap.get("sra_farm_amn_atel") + "-" + Demap.get("sra_farm_amn_htel") + "-" + Demap.get("sra_farm_amn_stel");
							}
							if(!Demap.get("sra_fhs_rep_mpsvno").equals("") || !Demap.get("sra_fhs_rep_mphno").equals("") || !Demap.get("sra_fhs_rep_mpsqno").equals("")) {
								tmpMpno = Demap.get("sra_fhs_rep_mpsvno") + "-" + Demap.get("sra_fhs_rep_mphno") + "-" + Demap.get("sra_fhs_rep_mpsqno");
							}

							Demap.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
							Demap.put("ss_usrid", inMap.get("ss_usrid"));
							Demap.put("zip", tmpZip);
							Demap.put("telno", tmpTelno);
							Demap.put("mpno", tmpMpno);
							
							infIndvList = lalm0222PMapper.LALM0222P_selTmpIndv(Demap);
							fhsList = lalm0222PMapper.LALM0222P_selTmpFhs(Demap);
							
							if(infIndvList.size() == 0) {
								insertNum += lalm0222PMapper.LALM0222P_insIsMmIndv(Demap);
							} else {
								updateNum += lalm0222PMapper.LALM0222P_updIsMmIndv(Demap);
							}
							
							//TODO : 농가를 아예 통합회원에서 제거하게 되면 수정 or 제거해야 할 부분
							// 농가정보 수신 시, 통합회원정보 생성하기
							Demap.put("mb_intg_gb", "02");
							Demap.put("anw_yn", "1");	//한우종합여부 : 1
							Demap.put("sra_fhs_id_no", Demap.get("fhs_id_no"));
							Demap.put("ftsnm", Demap.get("sra_fhsnm"));
							Demap.put("cus_mpno", Demap.get("mpno"));
							commonService.Common_insMbintgInfo(Demap);
							
							if(fhsList.size() == 0) {
								//휴면복구할 데이터가 있는 경우, 농가 INSERT 하지 않아도 됨, 위 메소드 내부에서 처리함
								if ("0".equals(Demap.getOrDefault("cur_dorm_cnt", "0"))) {
									insertNum += lalm0222PMapper.LALM0222P_insIsMmFhs(Demap);					
								}
							}else {				
								Map<String, Object> bzLoc = lalm0222PMapper.LALM0222P_selBmBzloc(Demap);
								if(fhsList.get(0).get("JRDWO_DSC") == null || fhsList.get(0).get("JRDWO_DSC").equals("")) {
									throw new CusException(ErrorCode.CUSTOM_ERROR,"농가의 관내 구분이 없습니다.<br>농가관리에서 관내구분을 설정해 주세요.");
								}
								if(bzLoc.get("SMS_BUFFER_1") != null) Demap.put("buffer_1", bzLoc.get("SMS_BUFFER_1"));
								else Demap.put("buffer_1", "");
								
								Demap.put("maco_yn", fhsList.get(0).get("MACO_YN"));
								Demap.put("jrdwo_dsc", fhsList.get(0).get("JRDWO_DSC"));
								
								updateNum += lalm0222PMapper.LALM0222P_updIsMmFhs(Demap);			
							}

							result.put("SRA_INDV_AMNNO",Demap.get("sra_indv_amnno"));
							result.put("MCOW_SRA_INDV_AMNNO", Demap.get("mcow_sra_indv_eart_no"));
							result.put("CHK_IF_SRA_INDV", "1");
							result.put("CHK_IF_FHS", "1");							
							result.put("SRA_INDV_AMNNO", Demap.get("sra_indv_amnno"));	
							result.put("FTSNM", Demap.get("sra_fhsnm"));	
							result.put("FHS_ID_NO", Demap.get("fhs_id_no"));	
							result.put("FARM_AMNNO", Demap.get("farm_amnno"));	
							result.put("SRA_PDMNM", Demap.get("sra_fhsnm"));	
							result.put("SRA_PD_RGNNM", Demap.get("sra_farm_dongup"));
							result.put("SOG_NA_TRPL_C", Demap.get("na_trpl_c"));
						}else {
							log.debug("개체 인터페이스[4700] 데이터 없음..");
							result.put("CHK_IF_SRA_INDV", "0");		
							result.put("CHK_IF_FHS", "0");							
						}
					}else {
						log.debug("개체 인터페이스[4700] 데이터 없음..");
						result.put("CHK_IF_SRA_INDV", "0");		
						result.put("CHK_IF_FHS", "0");						
					}
								
				}catch(RuntimeException | SQLException e) {
					log.error("개체 인터페이스[4700] 연동중 error..",e);
					result.put("CHK_INF_ERR", "1");
					result.put("CHK_IF_SRA_INDV", "0");		
					result.put("CHK_IF_FHS", "0");
				}catch(Exception e) {
					log.error("개체 인터페이스[4700] 연동중 error..",e);
					result.put("CHK_INF_ERR", "1");
					result.put("CHK_IF_SRA_INDV", "0");		
					result.put("CHK_IF_FHS", "0");
				}
			}
			/*e: 개체정보 / 농가정보 동기화 */

			/* 개체,농가 정보 정상적으로 저장/수정되었을경우에만 적용 */
			if("1".equals(result.get("CHK_IF_FHS")) && "1".equals(result.get("CHK_IF_SRA_INDV"))) {
				/* s: 수정KPN */
				try {
					Map<String, Object> infModKpnMap = mcaUtil.tradeMcaMsg("2900", result);
					Map<String, Object> infModKpnJsonData = (Map<String, Object>) infModKpnMap.get("jsonData");		
					result.put("MOD_KPN_NO", infModKpnJsonData.getOrDefault("SRA_KPN_NO","").toString().trim());					
				}catch (RuntimeException | SQLException e) {
					log.error("수정 KPN[2900] 연동중 error..",e);
					result.put("MOD_KPN_NO", "");
				}catch (Exception e) {
					log.error("수정 KPN[2900] 연동중 error..",e);
					result.put("MOD_KPN_NO", "");
				}
				/* e: 수정KPN */			

				/* s: 분만정보 
				try {
					result.put("MCOW_SRA_INDV_EART_NO", map.get("sra_indv_amnno"));
					Map<String, Object> infBhPturMap = mcaUtil.tradeMcaMsg("2300", result);
					Map<String, Object> infBhPturJsonData = (Map<String, Object>) infBhPturMap.get("jsonData");	
					List<Map<String, Object>> infBhPturRptData = (List<Map<String, Object>>) infBhPturJsonData.get("RPT_DATA");
					if(infBhPturRptData != null && !infBhPturRptData.isEmpty()) {
						Map<String,Object> tempMap = new HashMap<>();
						tempMap.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
						tempMap.put("ss_usrid", inMap.get("ss_usrid"));
						tempMap.put("p_sra_indv_amnno", map.get("sra_indv_amnno"));
						lalm0222PMapper.LALM0222P_delChildbirthInf(tempMap);
						int bhPturIdx = 0;
						for(Map<String, Object> bhPturMap : infBhPturRptData) {
							//tempMap.putAll(bhPturMap);
							bhPturMap = convertConfig.changeKeyLower(bhPturMap);
							bhPturMap.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
							bhPturMap.put("ss_usrid", inMap.get("ss_usrid"));
							bhPturMap.put("p_sra_indv_amnno", map.get("sra_indv_amnno"));
							Iterator<String> keys = bhPturMap.keySet().iterator();
							while(keys.hasNext()) {
								String key = keys.next();
								String value = "";
								if(bhPturMap.get(key) != null) value = bhPturMap.get(key).toString().trim();
								log.debug("분만 정보 : {}", key+" ::: "+value);
								//tempMap.put(key.toLowerCase(), value);
							}
							bhPturMap.put("ptur_sqno", ++bhPturIdx);
							insertNum += lalm0222PMapper.LALM0222P_insChildbirthInf(bhPturMap);				
						}	
					}
					//TO-DO : 분만정보 INSERT
				}catch (RuntimeException | SQLException e) {
					result.put("CHK_VAILD_ERR", "1");
					log.error("분만정보[2300] 연동중 error..",e);
				}catch (Exception e) {
					result.put("CHK_VAILD_ERR", "1");
					log.error("분만정보[2300] 연동중 error..",e);
				}
				 e: 분만정보 */
                
                
				/* s: 교배정보 
				try {
					result.put("MCOW_SRA_INDV_EART_NO", map.get("sra_indv_amnno"));					
					Map<String, Object> infbhCrossMap = mcaUtil.tradeMcaMsg("2400", result);
					Map<String, Object> infbhCrossJsonData = (Map<String, Object>) infbhCrossMap.get("jsonData");	
					List<Map<String, Object>> infbhCrossRptData = (List<Map<String, Object>>) infbhCrossJsonData.get("RPT_DATA");
					if(infbhCrossRptData != null && !infbhCrossRptData.isEmpty()) {
						Map<String,Object> tempMap = new HashMap<>();
						tempMap.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
						tempMap.put("ss_usrid", inMap.get("ss_usrid"));
						tempMap.put("p_sra_indv_amnno", map.get("sra_indv_amnno"));
						lalm0222PMapper.LALM0222P_delMatingInf(tempMap);					
						int bhCrossIdx = 0;
						for(Map<String, Object> bhCrossMap : infbhCrossRptData) {
							bhCrossMap = convertConfig.changeKeyLower(bhCrossMap);
							bhCrossMap.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
							bhCrossMap.put("ss_usrid", inMap.get("ss_usrid"));
							bhCrossMap.put("p_sra_indv_amnno", map.get("sra_indv_amnno"));
							bhCrossMap.put("crsbd_qcn", ++bhCrossIdx);			
							insertNum += lalm0222PMapper.LALM0222P_insMatingInf(bhCrossMap);		
						}	
					}
				}catch (RuntimeException | SQLException e) {
					result.put("CHK_VAILD_ERR", "1");
					log.error("교배정보[2400] 연동중 error..",e);
				}catch (Exception e) {
					result.put("CHK_VAILD_ERR", "1");
					log.error("교배정보[2400] 연동중 error..",e);
				}
				 e: 교배정보 */

				/* s: 후대정보 
				try {
					Map<String, Object> infPostIndvMap = mcaUtil.tradeMcaMsg("4900", result);
					Map<String, Object> infPostIndvJsonData = (Map<String, Object>) infPostIndvMap.get("jsonData");
					List<Map<String, Object>> infPostIndvRptData = (List<Map<String, Object>>) infPostIndvJsonData.get("RPT_DATA");
					if(infPostIndvRptData != null && !infPostIndvRptData.isEmpty()) {
						for(Map<String, Object> indvData : infPostIndvRptData) {
							Map<String, Object> tempMap = new HashMap<String, Object>();
							Iterator<String> keys = indvData.keySet().iterator();
							while(keys.hasNext()) {
								String key = keys.next();
								String value = "";
								if(indvData.get(key) != null) value = indvData.get(key).toString().trim();
								//log.debug("후대 정보 : {}", key+" ::: "+value);
								tempMap.put(key.toLowerCase(), value);
							}
							tempMap.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
							tempMap.put("ss_usrid", inMap.get("ss_usrid"));
							tempMap.put("p_sra_indv_amnno", map.get("sra_indv_amnno"));
							lalm0222PMapper.LALM0222P_delPostInf(tempMap);
							insertNum += lalm0222PMapper.LALM0222P_insPostInf(tempMap);						
						}
					}
				}catch (RuntimeException | SQLException e) {
					log.error("후대정보 [4900] 연동중 error..",e);
				}catch (Exception e) {
					log.error("후대정보 [4900] 연동중 error..",e);
				}
				 e: 후대정보 */

				/* s: 형매정보 
				try {
					Map<String, Object> infSipIndvMap = mcaUtil.tradeMcaMsg("4900", result);
					Map<String, Object> infSipIndvJsonData = (Map<String, Object>) infSipIndvMap.get("jsonData");
					List<Map<String, Object>> infSipIndvRptData = (List<Map<String, Object>>) infSipIndvJsonData.get("RPT_DATA");
					if(infSipIndvRptData != null && !infSipIndvRptData.isEmpty()) {
						for(Map<String, Object> sibIndvData : infSipIndvRptData) {
							Map<String, Object> tempMap = new HashMap<String, Object>();
							Iterator<String> keys = sibIndvData.keySet().iterator();
							while(keys.hasNext()) {
								String key = keys.next();
								String value = "";
								if(sibIndvData.get(key) != null) value = sibIndvData.get(key).toString().trim();
								//log.error("형대 정보 : {}", key+" ::: "+value);
								tempMap.put(key.toLowerCase(), value);
							}
							tempMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
							tempMap.put("ss_usrid", map.get("ss_usrid"));
							tempMap.put("p_sra_indv_amnno", map.get("sra_indv_amnno"));
							lalm0222PMapper.LALM0222P_delSibInf(tempMap);
							insertNum += lalm0222PMapper.LALM0222P_insSibInf(tempMap);						
						}
					}
				}catch (RuntimeException | SQLException e) {
					log.error("형매정보 [4900] 연동중 error..",e);
				}catch (Exception e) {
					log.error("형매정보 [4900] 연동중 error..",e);
				}
				 e: 형매정보 */

				/* s: OPEN API 연동 */

				Map<String, Object> temp = new HashMap<String, Object>();
				temp.put("trace_no", result.get("SRA_INDV_AMNNO"));
				try {
					List<Map<String, Object>> cattleMoveList = mcaUtil.getOpenDataApiCattleMove(temp);
					if(cattleMoveList != null && !cattleMoveList.isEmpty()) {
						if(cattleMoveList != null && !cattleMoveList.isEmpty()) {
							int mvSeq = 0;
							lalm0222PMapper.LALM0222P_delCattleMvInf(map);
							for(Map<String, Object> moveInfo : cattleMoveList) {
								moveInfo.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
								moveInfo.put("ss_usrid", inMap.get("ss_usrid"));
								moveInfo.put("sra_indv_amnno", map.get("sra_indv_amnno"));
								moveInfo.put("mv_seq", ++mvSeq);
								moveInfo = convertConfig.changeKeyLower(moveInfo);
								insertNum += lalm0222PMapper.LALM0222P_insCattleMvInf(moveInfo);				
							}
						}
					}
				}catch (RuntimeException | SQLException e) {
					result.put("CHK_INF_ERR", "1");
					log.error("이동정보 [OPENAPI] 연동중 error..",e);
				}catch (Exception e) {
					result.put("CHK_INF_ERR", "1");
					log.error("이동정보 [OPENAPI] 연동중 error..",e);
				}
				/* e: 이동정보 */
				

				/* s: 브루셀라 연동 */
				try {
					Map<String, Object> infAnimalTraceMap = mcaUtil.getOpenDataApi(temp);    
					if(infAnimalTraceMap != null && !infAnimalTraceMap.isEmpty()) {
			        	String inspectDt = infAnimalTraceMap.getOrDefault("inspectDt","").toString().trim();
						result.put("BRCL_ISP_DT", inspectDt);   
			            // 브루셀라 접종결과 추후 추가 0:수기 1:음성 2:양성 9:미접종 brcl_isp_rzt_c
			        	String inspectYn = infAnimalTraceMap.getOrDefault("inspectYn","").toString().trim();
			            if("음성".equals(inspectYn)) {
			            	//$("#brcl_isp_rzt_c").val("1");  
							result.put("BRCL_ISP_RZT_C", "1");   
			            } else if("양성".equals(inspectYn)) {
							result.put("BRCL_ISP_RZT_C", "2");   
			            } else {
							result.put("BRCL_ISP_RZT_C", "0");   
			            }                    
			        	String tbcInspctYmd = infAnimalTraceMap.getOrDefault("tbcInspctYmd","").toString().trim();
						result.put("BOVINE_DT", tbcInspctYmd);
						
						result.put("BOVINE_RSLTNM", infAnimalTraceMap.getOrDefault("tbcInspctRsltNm","").toString().trim());
						
						//result.put("injectiondayCnt", infAnimalTraceMap.getOrDefault("injectiondayCnt","").toString().trim());
						result.put("VACN_DT", infAnimalTraceMap.getOrDefault("injectionYmd","").toString().trim());
						result.put("VACN_ORDER", infAnimalTraceMap.getOrDefault("vaccineorder","").toString().trim());
					}else {
						result.put("VACN_DT", "");
						result.put("VACN_ORDER", "");
						result.put("BOVINE_DT", "");					
						result.put("BOVINE_RSLTNM", "");
						result.put("BRCL_ISP_RZT_C", "9");  
						result.put("BRCL_ISP_DT", "");					
					}
				}catch (RuntimeException e) {
					result.put("CHK_INF_ERR", "1");
					log.error("브루셀라연동 [OPENAPI] 연동중 error..",e);
				}catch (Exception e) {
					result.put("CHK_INF_ERR", "1");
					log.error("브루셀라연동 [OPENAPI] 연동중 error..",e);
				}
				
				/* e: 브루셀라 연동 */

				/* s: 종축개량 데이터 연동 */
				//부여 : 8808990660127 | 창녕 : 8808990656274 | 진주 : 8808990657240 | 함양산청 : 8808990656410 | 합천 : 8808990656236
				String[] arrNaBzplc = {"8808990660127","8808990656274","8808990657240","8808990656410","8808990656236"};
				try {
					String barcode = (String) result.get("SRA_INDV_AMNNO");
					Map<String,Object> epdMap = commonService.Common_selAiakInfo(barcode);
					/* s: 부여축협일시 EPD값 종개협 연둉 */
					if(Arrays.asList(arrNaBzplc).contains(map.get("ss_na_bzplc")) && !epdMap.isEmpty()){
						int updNum = (int) epdMap.get("updateNum");
						log.debug(epdMap.toString());
						if(updNum > 0) {
							result.put("RE_PRODUCT_1", epdMap.get("EPD_VAL_1").toString().trim());
							result.put("RE_PRODUCT_1_1", epdMap.get("EPD_GRD_1").toString().trim());
							result.put("RE_PRODUCT_2", epdMap.get("EPD_VAL_2").toString().trim());
							result.put("RE_PRODUCT_2_1", epdMap.get("EPD_GRD_2").toString().trim());
							result.put("RE_PRODUCT_3", epdMap.get("EPD_VAL_3").toString().trim());
							result.put("RE_PRODUCT_3_1", epdMap.get("EPD_GRD_3").toString().trim());
							result.put("RE_PRODUCT_4", epdMap.get("EPD_VAL_4").toString().trim());
							result.put("RE_PRODUCT_4_1", epdMap.get("EPD_GRD_4").toString().trim());								
						}					
					}
				}catch (Exception e) {
					log.error("종축개량 데이터 연동중 error..",e);
				}
				/* e: 종축개량 데이터 연동 */

				/* s: 부여축협일시 모개체 EPD값 종개협 연둉 */
				
				if(Arrays.asList(arrNaBzplc).contains(map.get("ss_na_bzplc")) && !"".equals(result.get("MCOW_SRA_INDV_AMNNO"))) {
					try {
						String barcode = (String) result.get("MCOW_SRA_INDV_AMNNO");
						Map<String,Object> mEpdMap = commonService.Common_selAiakInfo(barcode);
						int updNum = (int) mEpdMap.get("updateNum");
						if(!mEpdMap.isEmpty() && updNum > 0) {
							log.debug(mEpdMap.toString());
							result.put("RE_PRODUCT_11", mEpdMap.get("EPD_VAL_1").toString().trim());
							result.put("RE_PRODUCT_11_1", mEpdMap.get("EPD_GRD_1").toString().trim());
							result.put("RE_PRODUCT_12", mEpdMap.get("EPD_VAL_2").toString().trim());
							result.put("RE_PRODUCT_12_1", mEpdMap.get("EPD_GRD_2").toString().trim());
							result.put("RE_PRODUCT_13", mEpdMap.get("EPD_VAL_3").toString().trim());
							result.put("RE_PRODUCT_13_1", mEpdMap.get("EPD_GRD_3").toString().trim());
							result.put("RE_PRODUCT_14", mEpdMap.get("EPD_VAL_4").toString().trim());
							result.put("RE_PRODUCT_14_1", mEpdMap.get("EPD_GRD_4").toString().trim());							
						}
					}catch (Exception e) {
						log.error("모개체 종축개량 데이터 연동중 error..",e);
					}
				}
				/* e: 모개체 종축개량 데이터 연동 */			
			}
			reList.add(result);
		}
		
		reMap.put("resultList", reList);
		return reMap;		
	}


	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM0214P3_selSogCowVaild(Map<String, Object> inMap) throws Exception{
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");
		
		int insertNum = 0;
		int updateNum = 0;
		int errCnt=0;
		StringBuilder sb = new StringBuilder();
		List<Map<String, Object>> reList = new ArrayList<Map<String, Object>>();
		
		for(Map<String, Object> map : list) {
			Map<String,Object> temp = convertConfig.changeKeyUpper(map);
			temp.put("CHK_VAILD_ERR", "0");
			temp.put("CHK_ERR_SRA_INDV_AMNNO", "0");
			temp.put("CHK_ERR_AUC_PRG_SQ", "0");
			
			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("auc_dt", inMap.get("auc_dt"));
			map.put("auc_obj_dsc", inMap.get("auc_obj_dsc"));
			map.put("re_indv_no", map.get("sra_indv_amnno"));
			if(map.get("sra_indv_amnno") !=null && map.get("sra_indv_amnno").toString().length() <= 14) {
				sb.append("<br/>귀표번호("+map.get("sra_indv_amnno")+") 자릿수를 확인 바랍니다.");
				errCnt++;
				temp.put("CHK_VAILD_ERR", "1");
				temp.put("CHK_ERR_SRA_INDV_AMNNO", "1");
				//throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된 경매번호("+map.get("auc_prg_sq")+")가 있습니다. 경매번호를 확인 바랍니다.");
			}
			
			List<Map<String, Object>> aucPrgList = lalm0215Mapper.LALM0215_selAucPrg(map);			
			if(aucPrgList.size() > 0) {
				sb.append("<br/>중복된 경매번호("+map.get("auc_prg_sq")+")가 있습니다. 경매번호를 확인 바랍니다.");
				errCnt++;
				temp.put("CHK_VAILD_ERR", "1");
				temp.put("CHK_ERR_AUC_PRG_SQ", "1");
				//throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된 경매번호("+map.get("auc_prg_sq")+")가 있습니다. 경매번호를 확인 바랍니다.");
			}
			//귀표번호 체크
			List<Map<String, Object>> indvAmnnoList = lalm0215Mapper.LALM0215_selIndvAmnno(map);			
			if(indvAmnnoList.size() > 0) {
				sb.append("<br/>동일한 경매일자에 동일한 귀표번호("+map.get("sra_indv_amnno")+")는 등록할수 없습니다.");
				errCnt++;
				temp.put("CHK_VAILD_ERR", "1");
				temp.put("CHK_ERR_SRA_INDV_AMNNO", "1");
				//throw new CusException(ErrorCode.CUSTOM_ERROR,"동일한 경매일자에 동일한 귀표번호("+map.get("sra_indv_amnno")+")는 등록할수 없습니다.");
			}

			reList.add(temp);
		}
		
		reMap.put("errCnt", errCnt);
		reMap.put("message", sb.toString());
		reMap.put("resultList", reList);
		
		return reMap;
	}

	public String splitByte(String inputString, int length) {
		if(inputString == null) {
			inputString = "";
		}
		StringBuilder sb = new StringBuilder();
		
		try {
			byte[] inputByte=inputString.getBytes("EUC-KR");
			int byteLen = inputByte.length;
			if(byteLen <= length) {
				return inputString;
			}else if(byteLen > length) {
				StringBuilder stringBuilder = new StringBuilder(length);
				int nCnt = 0;
				for(char ch:inputString.toCharArray()){
					nCnt += String.valueOf(ch).getBytes("EUC-KR").length;
					if(nCnt > length) break;
					stringBuilder.append(ch);
				}
				return stringBuilder.toString();
			}
		}catch (UnsupportedEncodingException e) {
			log.error("splitByte");
			return inputString;
		}
		return sb.toString();
	}
}
