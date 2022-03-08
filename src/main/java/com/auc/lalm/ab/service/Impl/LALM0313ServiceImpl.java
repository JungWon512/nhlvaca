package com.auc.lalm.ab.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0313Service;

@Service("LALM0313Service")
public class LALM0313ServiceImpl implements LALM0313Service{

	private static Logger log = LoggerFactory.getLogger(LALM0313ServiceImpl.class);
	
	@Autowired
	LALM0313Mapper lalm0313Mapper;	

	@Override
	public List<Map<String, Object>> LALM0313_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		log.info(map.toString());
		list = lalm0313Mapper.LALM0313_selList(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0313_insList(List<Map<String, Object>> list) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;		
		Map<String, Object> insMap = null;
				
		for(int i = 0; i < list.size(); i++) {
			insMap = (Map<String, Object>) list.get(i);	
	
		insertNum = lalm0313Mapper.LALM0313_insList(insMap);		
		reMap.put("insertNum", insertNum);	
		}
		return reMap;
	}	
	
}
