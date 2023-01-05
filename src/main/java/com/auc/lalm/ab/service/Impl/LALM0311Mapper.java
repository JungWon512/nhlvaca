package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0311Mapper {

	List<Map<String, Object>> LALM0311_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0311_selModlList(Map<String, Object> map) throws Exception;
	
	int LALM0311_updRmkPgm(Map<String, Object> map) throws Exception;
	
	int LALM0311_updModlPgm(Map<String, Object> map) throws Exception;
	
	int LALM0311_insLogPgm(Map<String, Object> map) throws Exception;
	
	int LALM0311_updPgm(Map<String, Object> map) throws Exception;

}
