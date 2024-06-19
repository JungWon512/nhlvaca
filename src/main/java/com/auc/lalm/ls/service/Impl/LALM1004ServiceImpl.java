package com.auc.lalm.ls.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ls.service.LALM1004Service;
import com.auc.main.service.LogService;
import com.auc.main.service.Impl.LogMapper;

@Service
@SuppressWarnings({ "unchecked" })
public class LALM1004ServiceImpl implements LALM1004Service {
	
	private static Logger log = LoggerFactory.getLogger(LALM1004ServiceImpl.class);

	@Autowired
	LALM1004Mapper lalm1004Mapper;

	@Autowired
	LogService logService;

	@Autowired
	LogMapper logMapper;

	@Override
	public List<Map<String, Object>> LALM1004_selList(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selList(map);
		return list;

	}
	
	@Override
	public List<Map<String, Object>> LALM1004_selFee(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selFee(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selStsDsc(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selStsDsc(map);
		return list;

	}

	@Override
	public Map<String, Object> LALM1004_insPgm(Map<String, Object> frmMap) throws Exception {

		final Map<String, Object> reMap = new HashMap<String, Object>();

		final Map<String, Object> map = (Map<String, Object>) frmMap.get("frm_mhsogcow");
		final List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>) frmMap.get("grd_mhfee");

		int insertNum = 0;
		int updateNum = 0;

		// 원표번호 셋팅
		final List<Map<String, Object>> list = lalm1004Mapper.LALM1004_selVoslpNo(map);
		final String vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);
		map.put("modl_no", map.get("auc_prg_sq"));

		insertNum = insertNum + lalm1004Mapper.LALM1004_insMmIndv(map);
		map.put("anw_yn ", "9");
		// 개체 정보 업데이트
		insertNum = insertNum + logService.insMmIndvLog(map);

		insertNum = insertNum + lalm1004Mapper.LALM1004_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);

		updateNum = updateNum + lalm1004Mapper.LALM1004_updMmFhs(map);

		for (Map<String, Object> selFee : selFeemapList) {
			selFee.put("ss_na_bzplc", map.get("ss_na_bzplc"));
			selFee.put("auc_obj_dsc", map.get("auc_obj_dsc"));
			selFee.put("auc_dt", map.get("auc_dt"));
			selFee.put("v_oslp_no", vOslpNO);
			insertNum = insertNum + lalm1004Mapper.LALM1004_insMhFeeImps(selFee);
		}

		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		reMap.put("rtnData", vOslpNO);

		return reMap;
	}

	@Override
	public Map<String, Object> LALM1004_updPgm(Map<String, Object> frmMap) throws Exception {

		final Map<String, Object> reMap = new HashMap<String, Object>();

		final Map<String, Object> map = (Map<String, Object>) frmMap.get("frm_mhsogcow");
		final List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>) frmMap.get("grd_mhfee");

		int insertNum = 0;
		int deleteNum = 0;
		int updateNum = 0;

		String beforeAucPrgSq = map.get("hd_auc_prg_sq").toString();
		String afterAucPrgSq = map.get("auc_prg_sq").toString();

		if (!beforeAucPrgSq.equals(afterAucPrgSq)) {
			map.put("modl_no", map.get("auc_prg_sq"));
		}

		final Map<String, Object> cowInfo = lalm1004Mapper.LALM1004_selSogCow(map);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delSogCow(map);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delFeeImps(map);

		if (cowInfo != null) {
			map.put("auc_yn", cowInfo.get("AUC_YN"));
		}

		insertNum = insertNum + lalm1004Mapper.LALM1004_insSogCow(map);

		insertNum = insertNum + logService.insSogCowLog(map);

		updateNum = updateNum + lalm1004Mapper.LALM1004_updMnIndv(map);
		// 개체 정보 업데이트
		insertNum = insertNum + logService.insMmIndvLog(map);

		updateNum = updateNum + lalm1004Mapper.LALM1004_updMmFhs(map);

		for (Map<String, Object> selFee : selFeemapList) {
			selFee.put("ss_na_bzplc", map.get("ss_na_bzplc"));
			selFee.put("auc_obj_dsc", map.get("auc_obj_dsc"));
			selFee.put("auc_dt", map.get("auc_dt"));
			selFee.put("v_oslp_no", map.get("oslp_no"));
			insertNum = insertNum + lalm1004Mapper.LALM1004_insMhFeeImps(selFee);
		}

		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);

		return reMap;
	}

	@Override
	public Map<String, Object> LALM1004_delPgm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();

		int deleteNum = 0;

		deleteNum = deleteNum + logService.insSogCowLog(map);
		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delSogCow(map);
		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delFeeImps(map);
		reMap.put("deleteNum", deleteNum);

		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM1004_selIndvAmnno(Map<String, Object> map) throws Exception {
		return lalm1004Mapper.LALM1004_selIndvAmnno(map);
	}

	@Override
	public List<Map<String, Object>> LALM1004_selAucPrg(Map<String, Object> map) throws Exception {
		return lalm1004Mapper.LALM1004_selAucPrg(map);
	}

}
