package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1005Mapper {

	List<Map<String, Object>> LALM1005_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1005_selModlList(Map<String, Object> map) throws Exception;
	
	int LALM1005_updRmkPgm(Map<String, Object> map) throws Exception;
	
	int LALM1005_updModlPgm(Map<String, Object> map) throws Exception;
	
	int LALM1005_insLogPgm(Map<String, Object> map) throws Exception;
	
	int LALM1005_updPgm(Map<String, Object> map) throws Exception;

	int LALM1005_updPgmOnlySave(Map<String, Object> tmpObject) throws Exception;

}
