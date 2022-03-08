package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0913Service;

@Service("LALM0913Service")
public class LALM0913ServiceImpl implements LALM0913Service{

	@Autowired
	LALM0913Mapper lalm0913Mapper;
	
    public List<Map<String, Object>> LALM0913_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = lalm0913Mapper.LALM0913_selList(map);
		return list;
		
	}

	@Override
	public Map<String, Object> LALM0913_selUser(Map<String, Object> map) throws Exception {
		
		Map<String, Object> outMap = lalm0913Mapper.LALM0913_selUser(map);
		return outMap;
		
	}
	
	@Override
	public Map<String, Object> LALM0913_insUser(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int insertNum = lalm0913Mapper.LALM0913_insUser(map);
		reMap.put("insertNum", insertNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0913_updUser(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = lalm0913Mapper.LALM0913_updUser(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	@Override
	public Map<String, Object> LALM0913_delUser(Map<String, Object> map) throws Exception {	
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int deleteNum = lalm0913Mapper.LALM0913_delUser(map);
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}


}
