package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0217Service {

	List<Map<String, Object>> LALM0217_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0217_selQcn(Map<String, Object> map) throws Exception;
		
	List<Map<String, Object>> LALM0217_selAucStn(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0217_insPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0217_updPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0217_delPgm(Map<String, Object> map) throws Exception;

}
