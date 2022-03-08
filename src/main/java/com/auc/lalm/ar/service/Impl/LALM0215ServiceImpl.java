package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0215Service;
import com.auc.main.service.LogService;
import com.auc.main.service.Impl.LogMapper;

@Service("LALM0215Service")
public class LALM0215ServiceImpl implements LALM0215Service{

	@Autowired
	LALM0215Mapper lalm0215Mapper;	
	
	@Autowired
	LogService logService;
	
	@Autowired
	LogMapper logMapper;
	
	@Override
	public List<Map<String, Object>> LALM0215_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selIndvAmnnoPgm(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selIndvAmnnoPgm(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selStsDsc(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selStsDsc(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;	
		list = lalm0215Mapper.LALM0215_selTmpIndvAmnnoPgm(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selFhsIdNo(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selFhsIdNo(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selGetPpgcowFeeDsc(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selFee(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selFee(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0215_delPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int deleteNum = 0;	
		
		deleteNum = deleteNum + logService.insSogCowLog(map);
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delSogCow(map);
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delFeeImps(map);
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delMhCalf(map);
		reMap.put("deleteNum", deleteNum);
		
		return reMap;
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selIndvAmnno(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selIndvAmnno(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selPrgSq(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selPrgSq(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selMhCalf(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selMhCalf(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selTmpFhsNm(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selTmpFhsNm(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selMacoFee(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selMacoFee(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selAucPrgSq(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selAucPrgSq(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selOslpNo(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selOslpNo(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selTmpAucPrgSq(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> listTmpAucPrgSq = null;
		List<Map<String, Object>> list = null;
		String tmpAucPrgSqNO = "";
		
		listTmpAucPrgSq = lalm0215Mapper.LALM0215_selTmpAucObjDsc(map);
		tmpAucPrgSqNO = listTmpAucPrgSq.get(0).get("AUC_OBJ_DSC").toString();
		
		if(!("0").equals(tmpAucPrgSqNO)) {
			list = lalm0215Mapper.LALM0215_selTmpAucPrgSq(map);
		}
		
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0215_updAucChange(Map<String, Object> frmMap) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map  = (Map<String, Object>)frmMap.get("frm_mhsogcow");
		
		List<Map<String, Object>> list = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>)frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>)frmMap.get("grd_mhfee");
		
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		int aucObjDscCnt = 0;
		
		String vOslpNO   = "";
		String vAucDt    = "";
		String tmpOslpno = "";
		String vAucChgDt = "";
		
		// 경매일자를 이월일자로 변경
		vAucDt = map.get("auc_dt").toString();
		vAucChgDt = map.get("auc_chg_dt").toString();
		tmpOslpno = map.get("oslp_no").toString();
		map.put("auc_chg_dt", vAucChgDt);
		map.put("auc_dt", vAucChgDt);
		
		// 원표번호 셋팅
		list = lalm0215Mapper.LALM0215_selChgVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);
		
		
		
		insertNum = insertNum + lalm0215Mapper.LALM0215_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);
		
		// kpn번호 update
		updateNum = updateNum + lalm0215Mapper.LALM0215_updIndvSet(map);
		
		if(selFeemapList.size() > 0) {
			for(int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",	map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc",	map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 		map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 	vOslpNO);
				tmpMap.put("fee_rg_sqno", 	selFeemapList.get(i).get("FEE_RG_SQNO"));
				tmpMap.put("na_fee_c", 		selFeemapList.get(i).get("NA_FEE_C"));
				tmpMap.put("apl_dt", 		selFeemapList.get(i).get("APL_DT"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("FEE_APL_OBJ_C"));
				tmpMap.put("ans_dsc", 		selFeemapList.get(i).get("ANS_DSC"));
				tmpMap.put("sbid_yn", 		selFeemapList.get(i).get("SBID_YN"));
				tmpMap.put("sra_tr_fee", 	selFeemapList.get(i).get("SRA_TR_FEE"));
				
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhFeeImps(tmpMap);
			}
		}
		
		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());
		
		if(aucObjDscCnt == 3) {
			for(int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",		map.get("ss_na_bzplc"));
				tmpMap.put("ss_userid", 		map.get("ss_userid"));
				tmpMap.put("auc_obj_dsc",		map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 			map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 		vOslpNO);
				tmpMap.put("v_rg_sqno", 		tmpi+1);
				tmpMap.put("sra_srs_dsc", 		calfList.get(tmpi).get("SRA_SRS_DSC"));
				tmpMap.put("sra_indv_amnno", 	calfList.get(tmpi).get("SRA_INDV_AMNNO"));
				tmpMap.put("indv_sex_c", 		calfList.get(tmpi).get("INDV_SEX_C"));
				tmpMap.put("cow_sog_wt", 		calfList.get(tmpi).get("COW_SOG_WT"));
				tmpMap.put("birth", 			calfList.get(tmpi).get("BIRTH"));
				tmpMap.put("kpn_no", 			calfList.get(tmpi).get("KPN_NO"));
				tmpMap.put("del_yn", 			0);
				tmpMap.put("tms_yn", 			0);
				
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhCalf(tmpMap);
			}
		}
		
		// 경매일자, 원표번호 복구
		map.put("auc_dt", vAucDt);
		map.put("oslp_no", tmpOslpno);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delSogCow(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delFeeImps(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delMhCalf(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selAucPrg(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selAucPrg(map);
		return list;
		
	}

	@Override
	public Map<String, Object> LALM0215_insPgm(Map<String, Object> frmMap) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map  = (Map<String, Object>)frmMap.get("frm_mhsogcow");
		
		List<Map<String, Object>> list = null;
		List<Map<String, Object>> amnnolist = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>)frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>)frmMap.get("grd_mhfee");
		
		int insertNum = 0;	
		int updateNum = 0;
		int aucObjDscCnt = 0;
		
		String vOslpNO   	= "";
		
		// 원표번호 셋팅
		list = lalm0215Mapper.LALM0215_selVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);
		map.put("modl_no", map.get("auc_prg_sq"));
		
		
		insertNum = insertNum + lalm0215Mapper.LALM0215_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);
		
		
		amnnolist = lalm0215Mapper.LALM0215_selAmnno(map);
		if(amnnolist.size() > 0) {
			updateNum = updateNum + lalm0215Mapper.LALM0215_updMnIndv(map);
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			insertNum = insertNum + lalm0215Mapper.LALM0215_insMmIndv(map);
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}
		
		updateNum = updateNum + lalm0215Mapper.LALM0215_updMmFhs(map);
		if(selFeemapList.size() > 0) {
			for(int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",	map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc",	map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 		map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 	vOslpNO);
				tmpMap.put("fee_rg_sqno", 	selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", 		selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", 		selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", 		selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", 		selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", 	selFeemapList.get(i).get("sra_tr_fee"));
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhFeeImps(tmpMap);
			}
		}
		
		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());
		
		if(aucObjDscCnt == 3) {
			for(int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",		map.get("ss_na_bzplc"));
				tmpMap.put("ss_userid", 		map.get("ss_userid"));
				tmpMap.put("auc_obj_dsc",		map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 			map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 		vOslpNO);
				tmpMap.put("v_rg_sqno", 		tmpi+1);
				tmpMap.put("sra_srs_dsc", 		calfList.get(tmpi).get("SRA_SRS_DSC"));
				tmpMap.put("sra_indv_amnno", 	calfList.get(tmpi).get("SRA_INDV_AMNNO"));
				tmpMap.put("indv_sex_c", 		calfList.get(tmpi).get("INDV_SEX_C"));
				tmpMap.put("cow_sog_wt", 		calfList.get(tmpi).get("COW_SOG_WT"));
				tmpMap.put("birth", 			calfList.get(tmpi).get("BIRTH"));
				tmpMap.put("kpn_no", 			calfList.get(tmpi).get("KPN_NO"));
				tmpMap.put("del_yn", 			0);
				tmpMap.put("tms_yn", 			0);
				
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhCalf(tmpMap);
			}
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0215_updPgm(Map<String, Object> frmMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map  = (Map<String, Object>)frmMap.get("frm_mhsogcow");
		
		List<Map<String, Object>> list = null;
		List<Map<String, Object>> amnnolist = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>)frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>)frmMap.get("grd_mhfee");
		
		int insertNum = 0;
		int deleteNum = 0;
		int updateNum = 0;
		int aucObjDscCnt = 0;
		
		String beforeAucPrgSq 	= map.get("hd_auc_prg_sq").toString();
		String afterAucPrgSq 	= map.get("auc_prg_sq").toString();
		
		if(!beforeAucPrgSq.equals(afterAucPrgSq)) {
			map.put("modl_no", map.get("auc_prg_sq"));
		}
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delSogCow(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delFeeImps(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delMhCalf(map);
		
		insertNum = insertNum + lalm0215Mapper.LALM0215_insSogCow(map);
		
		insertNum = insertNum + logService.insSogCowLog(map);
		
		amnnolist = lalm0215Mapper.LALM0215_selAmnno(map);
		
		if(amnnolist.size() > 0) {
			updateNum = updateNum + lalm0215Mapper.LALM0215_updMnIndv(map);
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");
			
			insertNum = insertNum + lalm0215Mapper.LALM0215_insMmIndv(map);
			
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}
		
		updateNum = updateNum + lalm0215Mapper.LALM0215_updMmFhs(map);
		
		if(selFeemapList.size() > 0) {
			for(int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",	map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc",	map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 		map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 	map.get("oslp_no"));
				tmpMap.put("fee_rg_sqno", 	selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", 		selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", 		selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", 		selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", 		selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", 	selFeemapList.get(i).get("sra_tr_fee"));
				
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhFeeImps(tmpMap);
			}
		}
		
		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());
		
		if(aucObjDscCnt == 3) {
			for(int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				if(!calfList.get(tmpi).get("_status_").equals("-")) {
					tmpMap = new HashMap<String, Object>();
					tmpMap.put("ss_na_bzplc",		map.get("ss_na_bzplc"));
					tmpMap.put("ss_userid", 		map.get("ss_userid"));
					tmpMap.put("auc_obj_dsc",		map.get("auc_obj_dsc"));
					tmpMap.put("auc_dt", 			map.get("auc_dt"));
					tmpMap.put("v_oslp_no", 		map.get("oslp_no"));
					tmpMap.put("v_rg_sqno", 		tmpi+1);
					tmpMap.put("sra_srs_dsc", 		calfList.get(tmpi).get("sra_srs_dsc"));
					tmpMap.put("sra_indv_amnno", 	calfList.get(tmpi).get("sra_indv_amnno"));
					tmpMap.put("indv_sex_c", 		calfList.get(tmpi).get("indv_sex_c"));
					tmpMap.put("cow_sog_wt", 		calfList.get(tmpi).get("cow_sog_wt"));
					tmpMap.put("birth", 			calfList.get(tmpi).get("birth"));
					tmpMap.put("kpn_no", 			calfList.get(tmpi).get("kpn_no"));
					tmpMap.put("del_yn", 			0);
					tmpMap.put("tms_yn", 			0);
					insertNum = insertNum + lalm0215Mapper.LALM0215_insMhCalf(tmpMap);
				}
			}
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}
}
