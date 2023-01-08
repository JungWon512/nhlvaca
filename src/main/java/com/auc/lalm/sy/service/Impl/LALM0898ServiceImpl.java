package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0898Service;
import com.auc.mca.TradeMcaMsgDataController;

@Service("LALM0898Service")
public class LALM0898ServiceImpl implements LALM0898Service{

	private static Logger log = LoggerFactory.getLogger(LALM0898ServiceImpl.class);
	@Autowired
	LALM0898Mapper lalm0898Mapper;
	
	@Override
	public int LALM0898_selAucData(Map<String, Object> map) throws Exception {
		return lalm0898Mapper.LALM0898_selAucData(map);
	}
	@Override
	public Map<String, Object> LALM0898_insAucData(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = lalm0898Mapper.LALM0898_insAucDataQcn(map);
		insertNum += lalm0898Mapper.LALM0898_insAucDataStn(map);
		insertNum += lalm0898Mapper.LALM0898_insAucDataSogCow(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0898_initAucData(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = lalm0898Mapper.LALM0898_updateAucSogCowInit(map);
		updateNum += lalm0898Mapper.LALM0898_updateAucStnInit(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0898_delAucData(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int deleteNum = lalm0898Mapper.LALM0898_delAucDataQcn(map);
		deleteNum += lalm0898Mapper.LALM0898_delAucDataStn(map);
		deleteNum += lalm0898Mapper.LALM0898_delAucDataSogCow(map);
		if(deleteNum > 0) {
			deleteNum += lalm0898Mapper.LALM0898_delAucDataStnLog(map);
			deleteNum += lalm0898Mapper.LALM0898_delAucDataSogCowLog(map);
			deleteNum += lalm0898Mapper.LALM0898_delAucDataAtdrLog(map);
			deleteNum += lalm0898Mapper.LALM0898_delAucDataAucEntr(map);
			deleteNum += lalm0898Mapper.LALM0898_delAucDataFeeImps(map);			
		}
		
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

}
