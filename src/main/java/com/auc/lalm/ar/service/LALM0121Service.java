package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0121Service {

	List<Map<String, Object>> LALM0121_selList(Map<String, Object> map) throws Exception;
			
	List<Map<String, Object>> LALM0121_selLmtaComboList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0121_selQcn(Map<String, Object> map) throws Exception;	
	
	Map<String, Object> LALM0121_insPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0121_updPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0121_delPgm(Map<String, Object> map) throws Exception;

}
