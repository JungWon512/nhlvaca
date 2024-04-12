package com.auc.lalm.ls.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.auc.lalm.ls.service.LALM1006Service;

@Service("LALM1006Service")
public class LALM1006ServiceImpl implements LALM1006Service{

	@Autowired
	LALM1006Mapper lalm1006Mapper;	

	@Override
	public List<Map<String, Object>> LALM1006_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selList(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selSraList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selSraList(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selBadTrmn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selBadTrmn(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selBadCheck(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		if(ObjectUtils.isEmpty(map.get("mb_intg_no"))) {
			list = lalm1006Mapper.LALM1006_selBadCheckMwmn(map);
		}else {
			list = lalm1006Mapper.LALM1006_selBadCheck(map);
		}
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selTrmnAmnNo(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selTrmnAmnNo(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selAucPtcMnNo(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selAucPtcMnNo(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selSraCount(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selSraCount(map);
		return list;
	}
	
	@Override
	public Map<String, Object> LALM1006_insPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;
		/* String hd_auc_obj_dsc = (String)map.get("hd_auc_obj_dsc");
		String cb_auc_obj_dsc1 = (String)map.get("cb_auc_obj_dsc1");
		String cb_auc_obj_dsc2 = (String)map.get("cb_auc_obj_dsc2");
		String cb_auc_obj_dsc3 = (String)map.get("cb_auc_obj_dsc3");
		
		if(("0").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
		
		} else if(("1").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc2)) {
				int insMartNo = 0;
				insMartNo = lalm1006Mapper.LALM1006_insMartPgm(map);
				reMap.put("insMartNo", insMartNo);
			}
			if(("1").equals(cb_auc_obj_dsc3)) {
				int insBreedingNo = 0;
				insBreedingNo = lalm1006Mapper.LALM1006_insBreedingPgm(map);
				reMap.put("insBreedingNo", insBreedingNo);
			}
			
			
		} else if(("2").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc1)) {
				int insCalftNo = 0;
				insCalftNo = lalm1006Mapper.LALM1006_insCalfPgm(map);
				reMap.put("insCalftNo", insCalftNo);
			}
			if(("1").equals(cb_auc_obj_dsc3)) {
				int insBreedingNo = 0;
				insBreedingNo = lalm1006Mapper.LALM1006_insBreedingPgm(map);
				reMap.put("insBreedingNo", insBreedingNo);
			}
			
		} else if(("3").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc1)) {
				int insCalftNo = 0;
				insCalftNo = lalm1006Mapper.LALM1006_insCalfPgm(map);
				reMap.put("insCalftNo", insCalftNo);
			}
			if(("1").equals(cb_auc_obj_dsc2)) {
				int insMartNo = 0;
				insMartNo = lalm1006Mapper.LALM1006_insMartPgm(map);
				reMap.put("insMartNo", insMartNo);
			}
		}*/
		insertNum = lalm1006Mapper.LALM1006_insAllPgm(map);
		reMap.put("insertNum", insertNum);
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM1006_updPgm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		updateNum = lalm1006Mapper.LALM1006_updPgm(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM1006_delPgm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int deleteNum = 0;
		deleteNum = lalm1006Mapper.LALM1006_delAllPgm(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

}
