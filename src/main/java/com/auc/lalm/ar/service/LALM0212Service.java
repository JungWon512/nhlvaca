package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0212Service {

	List<Map<String, Object>> LALM0212_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selQcn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selAucQcn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selmhSogCow(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selMaxQcn(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0212_updDdl(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0212_updCan(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0212_insPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0212_updPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0212_delPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0212_updCommit(Map<String, Object> map) throws Exception;

}
