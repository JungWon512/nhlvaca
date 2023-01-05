package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0121Service;

@Service("LALM0121Service")
public class LALM0121ServiceImpl implements LALM0121Service{

	@Autowired
	LALM0121Mapper lalm0121Mapper;	

	@Override
	public List<Map<String, Object>> LALM0121_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0121Mapper.LALM0121_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0121_selLmtaComboList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0121Mapper.LALM0121_selLmtaComboList(map);
		return list;
		
	}	
	
	@Override
	public List<Map<String, Object>> LALM0121_selQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0121Mapper.LALM0121_selQcn(map);
		return list;
		
	}	
	
	@Override
	public Map<String, Object> LALM0121_insPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insNum = 0;
		
		insNum = lalm0121Mapper.LALM0121_insPgm(map);		
		reMap.put("updateNum", insNum);
				
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0121_updPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insNum = 0;
		
		insNum = lalm0121Mapper.LALM0121_updPgm(map);		
		reMap.put("updateNum", insNum);

		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0121_delPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int delNum = 0;	
		delNum = lalm0121Mapper.LALM0121_delPgm(map);		
		reMap.put("updateNum", delNum);
		
		return reMap;
	}
	
	
}
