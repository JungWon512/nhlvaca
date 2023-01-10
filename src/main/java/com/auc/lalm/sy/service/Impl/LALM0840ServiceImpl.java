package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0840Service;

@Service("LALM0840Service")
public class LALM0840ServiceImpl implements LALM0840Service{

	@Autowired
	LALM0840Mapper LALM0840Mapper;
	
	@Override
	public List<Map<String, Object>> LALM0840_selList(Map<String, Object> map) throws Exception {
		return LALM0840Mapper.LALM0840_selList(map);
	}

	@Override
	public Map<String, Object> LALM0840_selInfo(Map<String, Object> map) throws Exception {
		return LALM0840Mapper.LALM0840_selInfo(map);
	}

	@Override
	public Map<String, Object> LALM0840_insMsgTalk(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		
		insertNum = insertNum + LALM0840Mapper.LALM0840_insMsgTalk(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0840_updMsgTalk(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
			
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		
		insertNum = insertNum + LALM0840Mapper.LALM0840_updMsgTalk(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
			
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0840_delMsgTalk(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		
		insertNum = insertNum + LALM0840Mapper.LALM0840_delMsgTalk(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
			
		return reMap;
	}	

}
