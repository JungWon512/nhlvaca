package com.auc.lalm.bs.service;

import java.util.List;
import java.util.Map;

public interface LALM0114Service {

	List<Map<String, Object>> LALM0114_selList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0114_insIndv(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0114_updIndv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0114_delIndv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0114_selIndvDetail(Map<String, Object> map) throws Exception;

	

}
