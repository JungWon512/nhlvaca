package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1001Service {

	List<Map<String, Object>> LALM1001_selList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1001_insIndv(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1001_updIndv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1001_delIndv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1001_selIndvDetail(Map<String, Object> map) throws Exception;

	

}
