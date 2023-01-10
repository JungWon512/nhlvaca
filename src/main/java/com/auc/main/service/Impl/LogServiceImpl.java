package com.auc.main.service.Impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.main.service.LogService;

@Service("LogService")
public class LogServiceImpl implements LogService{
	
	@Autowired
	LogMapper logMapper;
	
	@Override
	public int insUserLog(Map<String, Object> map) throws Exception {
		
		int InsertCnt =logMapper.insUserLog(map);		
		return InsertCnt;
		
	}
		
	
	@Override
	public int insSogCowLog(Map<String, Object> map) throws Exception {
		
		int InsertCnt =logMapper.insSogCowLog(map);		
		return InsertCnt;
		
	}
	
	@Override
	public int insMmIndvLog(Map<String, Object> map) throws Exception {
		
		int InsertCnt =logMapper.insMmIndvLog(map);		
		return InsertCnt;
		
	}

	@Override
	public int insMwmnLog(Map<String, Object> map) throws Exception {
		
		int InsertCnt =logMapper.insMwmnLog(map);		
		return InsertCnt;
		
	}

}
