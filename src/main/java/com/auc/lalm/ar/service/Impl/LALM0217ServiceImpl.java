package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0217Service;

@Service("LALM0217Service")
public class LALM0217ServiceImpl implements LALM0217Service{

	@Autowired
	LALM0217Mapper lalm0217Mapper;	

	@Override
	public List<Map<String, Object>> LALM0217_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0217Mapper.LALM0217_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0217_selAucStn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0217Mapper.LALM0217_selAucStn(map);
		return list;
		
	}	
	
	@Override
	public List<Map<String, Object>> LALM0217_selQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0217Mapper.LALM0217_selQcn(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0217_insPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insNum = 0;
		int insLogNum = 0;
		
		insNum = lalm0217Mapper.LALM0217_insPgm(map);		
		reMap.put("updateNum", insNum);
		
		insLogNum = lalm0217Mapper.LALM0217_insLogPgm(map);
		reMap.put("insLogNum", insLogNum);		
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0217_updPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insNum = 0;
		int insLogNum = 0;
		
		insNum = lalm0217Mapper.LALM0217_updPgm(map);		
		reMap.put("updateNum", insNum);
		
		insLogNum = lalm0217Mapper.LALM0217_updLogPgm(map);
		reMap.put("insLogNum", insLogNum);		
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0217_delPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int delNum = 0;	
		int insLogNum = 0;
		delNum = lalm0217Mapper.LALM0217_delPgm(map);		
		reMap.put("updateNum", delNum);
		
		insLogNum = lalm0217Mapper.LALM0217_delLogPgm(map);
		reMap.put("insLogNum", insLogNum);			
		
		return reMap;
	}
	
	
}
