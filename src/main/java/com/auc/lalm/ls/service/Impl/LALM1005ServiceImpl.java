package com.auc.lalm.ls.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ls.service.LALM1005Service;

@Service("LALM1005Service")
public class LALM1005ServiceImpl implements LALM1005Service{

	private static Logger log = LoggerFactory.getLogger(LALM1005ServiceImpl.class);
	
	@Autowired
	LALM1005Mapper lalm1005Mapper;	

	@Override
	public List<Map<String, Object>> LALM1005_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm1005Mapper.LALM1005_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM1005_selModlList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm1005Mapper.LALM1005_selModlList(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM1005_updRmkPgm(Map<String, Object> map) throws Exception {

		Object tmpChangeData              = map.get("changedata");
		List<Map<String, Object>> tmpList = (List<Map<String, Object>>)tmpChangeData;
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		
		for(int i = 0; i < tmpList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)tmpList.get(i);

			updateNum += lalm1005Mapper.LALM1005_updRmkPgm(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM1005_updModlPgm(Map<String, Object> map) throws Exception {

		Object tmpChangeData              = map.get("changedata");
		List<Map<String, Object>> tmpList = (List<Map<String, Object>>)tmpChangeData;
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		
		for(int i = 0; i < tmpList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)tmpList.get(i);

			updateNum += lalm1005Mapper.LALM1005_updModlPgm(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM1005_updPgm(Map<String, Object> map) throws Exception {
		
		Object tmpChangeData              = map.get("changedata");
		String calf_auc_atdr_unt_am    	  = map.get("calf_auc_atdr_unt_am").toString();
		String nbfct_auc_atdr_unt_am      = map.get("nbfct_auc_atdr_unt_am").toString();
		String ppgcow_auc_atdr_unt_am     = map.get("ppgcow_auc_atdr_unt_am").toString();
		String auc_obj_dsc     = map.get("auc_obj_dsc").toString();
		List<Map<String, Object>> tmpList = (List<Map<String, Object>>)tmpChangeData;
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		int insLogNum = 0;
		
		for(int i = 0; i < tmpList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)tmpList.get(i);
			tmpObject.put("calf_auc_atdr_unt_am", calf_auc_atdr_unt_am);
			tmpObject.put("nbfct_auc_atdr_unt_am", nbfct_auc_atdr_unt_am);
			tmpObject.put("ppgcow_auc_atdr_unt_am", ppgcow_auc_atdr_unt_am);
			tmpObject.put("auc_obj_dsc", auc_obj_dsc);

			insLogNum += lalm1005Mapper.LALM1005_insLogPgm(tmpObject);
			updateNum += lalm1005Mapper.LALM1005_updPgm(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM1005_updPgmOnlySave(Map<String, Object> map) throws Exception{
		
		Object tmpChangeData              = map.get("changedata");
		String calf_auc_atdr_unt_am    	  = map.get("calf_auc_atdr_unt_am").toString();
		String nbfct_auc_atdr_unt_am      = map.get("nbfct_auc_atdr_unt_am").toString();
		String ppgcow_auc_atdr_unt_am     = map.get("ppgcow_auc_atdr_unt_am").toString();
		String chk_save_type     = map.getOrDefault("chk_save_type","").toString();
		
		List<Map<String, Object>> tmpList = (List<Map<String, Object>>)tmpChangeData;
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		int insLogNum = 0;
		
		for(int i = 0; i < tmpList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)tmpList.get(i);
			
			tmpObject.put("chk_save_type", chk_save_type);
			tmpObject.put("calf_auc_atdr_unt_am", calf_auc_atdr_unt_am);
			tmpObject.put("nbfct_auc_atdr_unt_am", nbfct_auc_atdr_unt_am);
			tmpObject.put("ppgcow_auc_atdr_unt_am", ppgcow_auc_atdr_unt_am);

			insLogNum += lalm1005Mapper.LALM1005_insLogPgm(tmpObject);
			updateNum += lalm1005Mapper.LALM1005_updPgmOnlySave(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;		
	}


}
