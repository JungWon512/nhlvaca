package com.auc.main.service.Impl;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LogMapper {
	int insUserLog(Map<String, Object> map) throws Exception;
	int insSogCowLog(Map<String, Object> map) throws Exception;
	
	int insMmIndvLog(Map<String, Object> map) throws Exception;

	int insMwmnLog(Map<String, Object> map) throws Exception;
	int insGrpLog(Map<String, Object> map) throws Exception;
	void insGrpUsrLog(Map<String, Object> map) throws Exception;
	
	
}
