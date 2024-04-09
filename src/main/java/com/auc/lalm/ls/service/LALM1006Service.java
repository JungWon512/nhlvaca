package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1006Service {

	List<Map<String, Object>> LALM1006_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selSraList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selBadTrmn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selBadCheck(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selTrmnAmnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selAucPtcMnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selSraCount(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1006_insPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1006_updPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1006_delPgm(Map<String, Object> map) throws Exception;

}
