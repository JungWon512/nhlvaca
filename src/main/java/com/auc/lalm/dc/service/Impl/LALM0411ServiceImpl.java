package com.auc.lalm.dc.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.dc.service.LALM0411Service;
import com.auc.main.service.LogService;

@Service("LALM0411Service")
public class LALM0411ServiceImpl implements LALM0411Service{

	@Autowired
	LogService logService;
	@Autowired
	LALM0411Mapper lalm0411mapper;
	
	@Override
	public Map<String, Object> LALM0411_updMwmn(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;
		int updateNum = 0;
		Map<String, Object> logMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		for(int i = 0; i < insList.size(); i++) {
			logMap = new HashMap<String, Object>();
			logMap.put("ss_na_bzplc", ss_na_bzplc);
			logMap.put("trmn_amnno", insList.get(i).get("TRMN_AMNNO"));
			logMap.put("ss_userid", ss_userid);
			//중도매인 이력테이블 insert
			insertNum += logService.insMwmnLog(logMap);
			//중도매인 update
			updateNum += lalm0411mapper.LALM0411_updMwmn(logMap);
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_updAucQcn(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			//경매차수정보 update
			updateNum += lalm0411mapper.LALM0411_updAucQcn(updMap);
		}

		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_updMwmnAdj(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			updMap.put("trmn_amnno", insList.get(i).get("TRMN_AMNNO"));
			updMap.put("rv_sqno", insList.get(i).get("RV_SQNO"));
			//경매차수정보 update
			updateNum += lalm0411mapper.LALM0411_updMwmnAdj(updMap);
		}
		
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_updMwmnEntr(List<Map<String, Object>> insList, Map<String, Object> map)	throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			updMap.put("lvst_auc_ptc_mn_no", insList.get(i).get("LVST_AUC_PTC_MN_NO"));
			//경매참가정보 update
			updateNum += lalm0411mapper.LALM0411_updMwmnEntr(updMap);
		}		
		
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_updRkonCm(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			updMap.put("pda_id", insList.get(i).get("PDA_ID"));
			//경매참가정보 update
			updateNum += lalm0411mapper.LALM0411_updRkonCm(updMap);
		}	

		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_selChkSogCow(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap            = new HashMap<String, Object>();
		Map<String, Object>       oslpNoMap  = null;
		List<Map<String, Object>> oslpNoList = null;

		int chkCnt     = 0;
		int updateNum  = 0;
		
		chkCnt = lalm0411mapper.LALM0411_selChkSogCow(map);
		
		if(chkCnt > 0) {
			Map<String, Object> inMap = null;
			int oslpNo_tmp = 0;
			int oslpNo     = 0;
			
			oslpNoMap  = lalm0411mapper.LALM0411_selMaxOslpNo(map);
			oslpNo     = Integer.parseInt(String.valueOf(oslpNoMap.get("V_OSLP_NO")));
			oslpNoList = lalm0411mapper.LALM0411_selOslpNoList(map);
			
			for(int k = 0; k < oslpNoList.size(); k++) {
				inMap = oslpNoList.get(k);
				
				if( oslpNo_tmp < oslpNo) {
					oslpNo_tmp = oslpNo;
				}else {
					inMap.put("v_oslp_no", oslpNo);
					updateNum += lalm0411mapper.LALM0411_updOslpSogCow(inMap);
					updateNum += lalm0411mapper.LALM0411_updOslpFeeImps(inMap);
					updateNum += lalm0411mapper.LALM0411_updOslpMhCalf(inMap);
					updateNum += lalm0411mapper.LALM0411_updOslpAtdrLog(inMap);
					updateNum += lalm0411mapper.LALM0411_updOslpPlaPr(inMap);
				}
				oslpNo++;
			}
		}
		
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> updSogCowLog(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap            = new HashMap<String, Object>();
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		int insertNum  = 0;
		int updateNum  = 0;
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("chg_pgid", "[LALM0411]");
			updMap.put("chg_rmk_cntn", "경매정보전송[출장우]");
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("oslp_no", insList.get(i).get("OSLP_NO"));
			
			//출장우 로그 insert
			insertNum += logService.insSogCowLog(updMap);
			
			updateNum += lalm0411mapper.LALM0411_updSogCow(updMap);
		}		
		
		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_updSogCowFee(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap            = new HashMap<String, Object>();
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		int updateNum  = 0;
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			updMap.put("oslp_no", insList.get(i).get("OSLP_NO"));
			updMap.put("led_sqno", insList.get(i).get("LED_SQNO"));
			updMap.put("fee_rg_sqno", insList.get(i).get("FEE_RG_SQNO"));
			
			//출장우 수수료 update
			updateNum += lalm0411mapper.LALM0411_updSogCowFee(updMap);
		}		
		
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_updSogCowCalf(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap            = new HashMap<String, Object>();
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		int updateNum  = 0;
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			updMap.put("oslp_no", insList.get(i).get("OSLP_NO"));
			updMap.put("rg_sqno", insList.get(i).get("RG_SQNO"));
			
			//출장우 송아지 update
			updateNum += lalm0411mapper.LALM0411_updSogCowCalf(updMap);
		}
		
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0411_updAtdrLog(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception {
		Map<String, Object> reMap            = new HashMap<String, Object>();
		Map<String, Object> updMap = null;
		String ss_userid   = (String) map.get("ss_userid");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		
		int updateNum  = 0;
		
		for(int i = 0; i < insList.size(); i++) {
			updMap = new HashMap<String, Object>();
			updMap.put("ss_na_bzplc", ss_na_bzplc);
			updMap.put("ss_userid", ss_userid);
			updMap.put("auc_obj_dsc", insList.get(i).get("AUC_OBJ_DSC"));
			updMap.put("auc_dt", insList.get(i).get("AUC_DT"));
			updMap.put("oslp_no", insList.get(i).get("OSLP_NO"));
			updMap.put("trmn_amnno", insList.get(i).get("TRMN_AMNNO"));
			updMap.put("lvst_auc_ptc_mn_no", insList.get(i).get("LVST_AUC_PTC_MN_NO"));
			updMap.put("rg_sqno", insList.get(i).get("RG_SQNO"));
			
			//응찰내역 update
			updateNum += lalm0411mapper.LALM0411_updAtdrLog(updMap);
		}
		
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM0411_selFhsInfo(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0411mapper.LALM0411_selFhsInfo(map);
		
		return list;
	}

}
