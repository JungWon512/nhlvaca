package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0314Mapper {

	List<Map<String, Object>> LALM0314_selList_simp(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0314_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow1List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow2List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow3List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow4List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow5List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selAucQcnList(Map<String, Object> map) throws Exception;
	
	int LALM0314_updAucStn(Map<String, Object> map) throws Exception;
	
	int LALM0314_updAucStnLog(Map<String, Object> map) throws Exception;
	
	int LALM0314_updSowCow(Map<String, Object> map) throws Exception;
	
	int LALM0314_updSowCowLog(Map<String, Object> map) throws Exception;
	
}
