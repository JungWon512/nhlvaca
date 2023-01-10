package com.auc.lalm.ab.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0312Service;

@Service("LALM0312Service")
public class LALM0312ServiceImpl implements LALM0312Service{

	@Autowired
	LALM0312Mapper lalm0312Mapper;	

	@Override
	public List<Map<String, Object>> LALM0312_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0312Mapper.LALM0312_selList(map);
		return list;
		
	}
		
	
	@Override
	public Map<String, Object> LALM0312_updSogCowSjam(List<Map<String, Object>> inList) throws Exception {
		
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		
		for(int i = 0; i < inList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)inList.get(i);

			updateNum += lalm0312Mapper.LALM0312_updSogCowSjam(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}	
	
}
