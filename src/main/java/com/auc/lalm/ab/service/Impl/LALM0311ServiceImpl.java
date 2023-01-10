package com.auc.lalm.ab.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0311Service;

@Service("LALM0311Service")
public class LALM0311ServiceImpl implements LALM0311Service{

	private static Logger log = LoggerFactory.getLogger(LALM0311ServiceImpl.class);
	
	@Autowired
	LALM0311Mapper lalm0311Mapper;	

	@Override
	public List<Map<String, Object>> LALM0311_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0311Mapper.LALM0311_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0311_selModlList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0311Mapper.LALM0311_selModlList(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0311_updRmkPgm(Map<String, Object> map) throws Exception {

		Object tmpChangeData              = map.get("changedata");
		List<Map<String, Object>> tmpList = (List<Map<String, Object>>)tmpChangeData;
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		
		for(int i = 0; i < tmpList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)tmpList.get(i);

			updateNum += lalm0311Mapper.LALM0311_updRmkPgm(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0311_updModlPgm(Map<String, Object> map) throws Exception {

		Object tmpChangeData              = map.get("changedata");
		List<Map<String, Object>> tmpList = (List<Map<String, Object>>)tmpChangeData;
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		
		for(int i = 0; i < tmpList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)tmpList.get(i);

			updateNum += lalm0311Mapper.LALM0311_updModlPgm(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0311_updPgm(Map<String, Object> map) throws Exception {
		
		Object tmpChangeData              = map.get("changedata");
		String calf_auc_atdr_unt_am    	  = map.get("calf_auc_atdr_unt_am").toString();
		String nbfct_auc_atdr_unt_am      = map.get("nbfct_auc_atdr_unt_am").toString();
		String ppgcow_auc_atdr_unt_am     = map.get("ppgcow_auc_atdr_unt_am").toString();
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

			insLogNum += lalm0311Mapper.LALM0311_insLogPgm(tmpObject);
			updateNum += lalm0311Mapper.LALM0311_updPgm(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0311_updPgmOnlySave(Map<String, Object> map) throws Exception{
		
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

			insLogNum += lalm0311Mapper.LALM0311_insLogPgm(tmpObject);
			updateNum += lalm0311Mapper.LALM0311_updPgmOnlySave(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;		
	}


}
