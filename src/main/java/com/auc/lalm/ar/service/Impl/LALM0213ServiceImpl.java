package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0213Service;

@Service("LALM0213Service")
public class LALM0213ServiceImpl implements LALM0213Service{

	@Autowired
	LALM0213Mapper lalm0213Mapper;	

	@Override
	public List<Map<String, Object>> LALM0213_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0213Mapper.LALM0213_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0213_selSraList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0213Mapper.LALM0213_selSraList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0213_selBadTrmn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0213Mapper.LALM0213_selBadTrmn(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0213_selBadCheck(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0213Mapper.LALM0213_selBadCheck(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0213_selTrmnAmnNo(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0213Mapper.LALM0213_selTrmnAmnNo(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0213_selAucPtcMnNo(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0213Mapper.LALM0213_selAucPtcMnNo(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0213_selSraCount(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0213Mapper.LALM0213_selSraCount(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0213_insPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;
		String hd_auc_obj_dsc = (String)map.get("hd_auc_obj_dsc");
		String cb_auc_obj_dsc1 = (String)map.get("cb_auc_obj_dsc1");
		String cb_auc_obj_dsc2 = (String)map.get("cb_auc_obj_dsc2");
		String cb_auc_obj_dsc3 = (String)map.get("cb_auc_obj_dsc3");
		
		if(("0").equals(hd_auc_obj_dsc)) {
			insertNum = lalm0213Mapper.LALM0213_insPgm(map);
			reMap.put("insertNum", insertNum);
		
		} else if(("1").equals(hd_auc_obj_dsc)) {
			insertNum = lalm0213Mapper.LALM0213_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc2)) {
				int insMartNo = 0;
				insMartNo = lalm0213Mapper.LALM0213_insMartPgm(map);
				reMap.put("insMartNo", insMartNo);
			}
			if(("1").equals(cb_auc_obj_dsc3)) {
				int insBreedingNo = 0;
				insBreedingNo = lalm0213Mapper.LALM0213_insBreedingPgm(map);
				reMap.put("insBreedingNo", insBreedingNo);
			}
			
			
		} else if(("2").equals(hd_auc_obj_dsc)) {
			insertNum = lalm0213Mapper.LALM0213_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc1)) {
				int insCalftNo = 0;
				insCalftNo = lalm0213Mapper.LALM0213_insCalfPgm(map);
				reMap.put("insCalftNo", insCalftNo);
			}
			if(("1").equals(cb_auc_obj_dsc3)) {
				int insBreedingNo = 0;
				insBreedingNo = lalm0213Mapper.LALM0213_insBreedingPgm(map);
				reMap.put("insBreedingNo", insBreedingNo);
			}
			
		} else if(("3").equals(hd_auc_obj_dsc)) {
			insertNum = lalm0213Mapper.LALM0213_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc1)) {
				int insCalftNo = 0;
				insCalftNo = lalm0213Mapper.LALM0213_insCalfPgm(map);
				reMap.put("insCalftNo", insCalftNo);
			}
			if(("1").equals(cb_auc_obj_dsc2)) {
				int insMartNo = 0;
				insMartNo = lalm0213Mapper.LALM0213_insMartPgm(map);
				reMap.put("insMartNo", insMartNo);
			}			
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0213_updPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		
		updateNum = lalm0213Mapper.LALM0213_updPgm(map);		
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0213_delPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		
		deleteNum = lalm0213Mapper.LALM0213_delPgm(map);		
		reMap.put("deleteNum", deleteNum);
		
		return reMap;
	}


}
