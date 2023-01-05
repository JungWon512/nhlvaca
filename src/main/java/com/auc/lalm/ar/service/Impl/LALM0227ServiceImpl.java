package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0227Service;

@Service("LALM0227Service")
public class LALM0227ServiceImpl implements LALM0227Service{

	@Autowired
	LALM0227Mapper lalm0227Mapper;
	
	@Override
	public List<Map<String, Object>> LALM0227_selList(Map<String, Object> map) throws Exception {
		return lalm0227Mapper.LALM0227_selList(map);
	}

	@Override
	public Map<String, Object> LALM0227_selInfo(Map<String, Object> map) throws Exception {
		return lalm0227Mapper.LALM0227_selInfo(map);
	}

	@Override
	public Map<String, Object> LALM0227_insMsgTalk(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		
		insertNum = insertNum + lalm0227Mapper.LALM0227_insMsgTalk(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0227_updMsgTalk(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
			
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		
		insertNum = insertNum + lalm0227Mapper.LALM0227_updMsgTalk(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
			
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0227_delMsgTalk(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		
		insertNum = insertNum + lalm0227Mapper.LALM0227_delMsgTalk(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
			
		return reMap;
	}	

}
