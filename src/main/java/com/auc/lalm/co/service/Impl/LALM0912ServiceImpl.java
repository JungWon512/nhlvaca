package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0912Service;

@Service("LALM0912Service")
public class LALM0912ServiceImpl implements LALM0912Service{

	@Autowired
	LALM0912Mapper lalm0912Mapper;	

	@Override
	public Map<String, Object> LALM0912_selData(Map<String, Object> map) throws Exception {
		
		Map<String, Object> outMap = lalm0912Mapper.LALM0912_selData(map);
		return outMap;
		
	}
	
	@Override
	public Map<String, Object> LALM0912_insWmc(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int insertNum = 0;
		insertNum = insertNum + lalm0912Mapper.LALM0912_insWmc(map);
		insertNum = insertNum + lalm0912Mapper.LALM0912_insEnvEst(map);
		insertNum = insertNum + lalm0912Mapper.LALM0912_insBzloc(map);
		reMap.put("insertNum", insertNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0912_updWmc(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = 0;
		updateNum = updateNum + lalm0912Mapper.LALM0912_updWmc(map);
		updateNum = updateNum + lalm0912Mapper.LALM0912_updEnvEst(map);
		updateNum = updateNum + lalm0912Mapper.LALM0912_updBzloc(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	@Override
	public Map<String, Object> LALM0912_delWmc(Map<String, Object> map) throws Exception {	
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int deleteNum = 0;
		deleteNum = deleteNum + lalm0912Mapper.LALM0912_delWmc(map);
		deleteNum = deleteNum + lalm0912Mapper.LALM0912_delEnvEst(map);
		deleteNum = deleteNum + lalm0912Mapper.LALM0912_delBzloc(map);
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0912_updSealImg(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = 0;
		updateNum = updateNum + lalm0912Mapper.LALM0912_updSealImg(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	
	
	@Override
	public Map<String, Object> LALM0912_selSealImg(Map<String, Object> map) throws Exception {
		
		Map<String, Object> outMap = lalm0912Mapper.LALM0912_selSealImg(map);
		return outMap;
		
	}


}
