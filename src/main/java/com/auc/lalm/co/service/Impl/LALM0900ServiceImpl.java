package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0900Service;

@Service("LALM0900Service")
public class LALM0900ServiceImpl implements LALM0900Service{

	@Autowired
	LALM0900Mapper lalm0900Mapper;	

	@Override
	public List<Map<String, Object>> LALM0900_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = lalm0900Mapper.LALM0900_selList(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0900P1_selData(Map<String, Object> map) throws Exception {
		if(map.containsKey("inq_cn_yn") && "1".equals(map.get("inq_cn_yn"))) {
			lalm0900Mapper.LALM0900P1_insBlbdInqCn(map);
		}
		Map<String, Object> outMap = lalm0900Mapper.LALM0900P1_selData(map);
		return outMap;
		
	}
	
	@Override
	public Map<String, Object> LALM0900P1_insBlbd(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int insertNum = 0;
		insertNum = insertNum + lalm0900Mapper.LALM0900P1_insBlbd(map);
		reMap.put("insertNum", insertNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0900P1_updBlbd(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = 0;
		updateNum = updateNum + lalm0900Mapper.LALM0900P1_updBlbd(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	@Override
	public Map<String, Object> LALM0900P1_delBlbd(Map<String, Object> map) throws Exception {	
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int deleteNum = 0;
		deleteNum = deleteNum + lalm0900Mapper.LALM0900P1_delBlbd(map);
		deleteNum = deleteNum + lalm0900Mapper.LALM0900P1_delApdfl(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0900P1_insApdfl(Map<String, Object> inMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		String apdfl_id = lalm0900Mapper.LALM0900P1_selApdfl(inMap);
		inMap.put("apdfl_id", apdfl_id);		
		int insertNum = 0;
		insertNum = lalm0900Mapper.LALM0900P1_insApdfl(inMap); 		
		reMap.put("apdfl_id", apdfl_id);	
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0900_selFileDownload(HashMap<String, Object> paraMap) throws Exception {
		Map<String, Object> reMap = null;
		reMap = lalm0900Mapper.LALM0900_selFileDownload(paraMap);
		return reMap;
	}
	
	


}
