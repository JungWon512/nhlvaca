package com.auc.lalm.ab.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0314Service;

@Service("LALM0314Service")
public class LALM0314ServiceImpl implements LALM0314Service{

	private static Logger log = LoggerFactory.getLogger(LALM0314ServiceImpl.class);
	
	@Autowired
	LALM0314Mapper lalm0314Mapper;	

	@Override
	public List<Map<String, Object>> LALM0314_selList_simp(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selList_simp(map);
		return list;
		
	}

	@Override
	public List<Map<String, Object>> LALM0314_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0314_selSogCow1List(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selSogCow1List(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0314_selSogCow2List(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selSogCow2List(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0314_selSogCow3List(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selSogCow3List(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0314_selSogCow4List(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selSogCow4List(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0314_selSogCow5List(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selSogCow5List(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0314_selAucQcnList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm0314Mapper.LALM0314_selAucQcnList(map);
		return list;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> LALM0314_updDdlQcn(Map<String, Object> map) throws Exception {

		Map<String, Object> frmMap = (Map<String, Object>)map.get("frm");
		Map<String, Object> list   = (Map<String, Object>)map.get("list");
		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		
		int updateNum = 0;
		
		list.put("auc_dt", frmMap.get("auc_dt"));
		
		updateNum = updateNum + lalm0314Mapper.LALM0314_updAucStn(list);
		updateNum = updateNum + lalm0314Mapper.LALM0314_updAucStnLog(list);
		updateNum = updateNum + lalm0314Mapper.LALM0314_updSowCow(list);
		updateNum = updateNum + lalm0314Mapper.LALM0314_updSowCowLog(list);
		
		reMap.put("updateNum", updateNum);	
		
		return reMap;
		
	}
	
	
}
