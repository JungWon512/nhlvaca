package com.auc.lalm.ab.service;

import java.util.List;
import java.util.Map;

public interface LALM0314Service {

	List<Map<String, Object>> LALM0314_selList_simp(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0314_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow1List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow2List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow3List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow4List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selSogCow5List(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0314_selAucQcnList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0314_updDdlQcn(Map<String, Object> map) throws Exception;
	
}
