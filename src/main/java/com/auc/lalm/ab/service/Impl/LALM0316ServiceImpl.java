package com.auc.lalm.ab.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0316Service;

@Service("LALM0316Service")
public class LALM0316ServiceImpl implements LALM0316Service{

	@Autowired
	LALM0316Mapper lalm0316Mapper;	

	
	@Override
	public List<Map<String, Object>> Lalm0316_selList_MhAucQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0316Mapper.Lalm0316_selList_MhAucQcn(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0316_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0316Mapper.LALM0316_selList(map);
		return list;
		
	}

	@Override
	public List<Map<String, Object>> LALM0316_selList2(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0316Mapper.LALM0316_selList2(map);
		return list;
		
	}

	@Override
	public Map<String, Object> LALM0316_updAtdrLog(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		//프로그램 DB 저장
		updateNum = lalm0316Mapper.LALM0316_updAtdrLog(map);		
		reMap.put("updateNum", updateNum);	
		return reMap;
	}
}
