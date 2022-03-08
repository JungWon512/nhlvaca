package com.auc.lalm.ab.service;

import java.util.List;
import java.util.Map;

public interface LALM0311Service {

	List<Map<String, Object>> LALM0311_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0311_selModlList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0311_updRmkPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0311_updModlPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0311_updPgm(Map<String, Object> map) throws Exception;

}
