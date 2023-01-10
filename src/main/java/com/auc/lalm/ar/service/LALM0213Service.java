package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0213Service {

	List<Map<String, Object>> LALM0213_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selSraList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selBadTrmn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selBadCheck(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selTrmnAmnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selAucPtcMnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selSraCount(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0213_insPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0213_updPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0213_delPgm(Map<String, Object> map) throws Exception;

}
