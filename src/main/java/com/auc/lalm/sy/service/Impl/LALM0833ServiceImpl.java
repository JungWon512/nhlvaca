package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0833Service;

@Service("LALM0833Service")
public class LALM0833ServiceImpl implements LALM0833Service{
	
	@Autowired
	LALM0833Mapper lalm0833Mapper;	
	

	@Override
	public List<Map<String, Object>> LALM0833_selGrpCode(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0833Mapper.LALM0833_selGrpCode(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0833_selList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;		
		list = lalm0833Mapper.LALM0833_selList(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0833_insUsr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		//프로그램 DB 저장
		insertNum = lalm0833Mapper.LALM0833_insUsr(map);		
		reMap.put("insertNum", insertNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0833_updUsr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		//프로그램 DB 저장
		updateNum = lalm0833Mapper.LALM0833_updUsr(map);		
		reMap.put("updateNum", updateNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0833_delUsr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		//프로그램 DB 저장
		deleteNum = lalm0833Mapper.LALM0833_delUsr(map);		
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM0833_selGrpList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0833Mapper.LALM0833_selGrpList(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0833_delGrpList(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		//프로그램 DB 저장
		deleteNum = lalm0833Mapper.LALM0833_delGrpList(map);		
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0833_updGrpList(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		//프로그램 DB 저장
		System.out.println(map.toString());
		updateNum = lalm0833Mapper.LALM0833_updGrpList(map);		
		reMap.put("updateNum", updateNum);		
		return reMap;
	}


}
