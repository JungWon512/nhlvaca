package com.auc.lalm.ab.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0321Service;

@Service("LALM0321Service")
public class LALM0321ServiceImpl implements LALM0321Service{

	@Autowired
	LALM0321Mapper lalm0321Mapper;	

	@Override
	public List<Map<String, Object>> LALM0321_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0321Mapper.LALM0321_selList(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0321_updSogCowSjamr(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insNum = 0;
		
		insNum = lalm0321Mapper.LALM0321_updSogCowSjamr(map);		
		reMap.put("updateNum", insNum);	
		
		return reMap;
	}	


}
