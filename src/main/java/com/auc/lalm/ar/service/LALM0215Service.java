package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0215Service {

	List<Map<String, Object>> LALM0215_selList(Map<String, Object> map) throws Exception;
		
	List<Map<String, Object>> LALM0215_selFee(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selStsDsc(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selIndvAmnno(Map<String, Object> map) throws Exception;	
	
	List<Map<String, Object>> LALM0215_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selPrgSq(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selMhCalf(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selTmpAucPrgSq(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selTmpFhsNm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selMacoFee(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selAucPrgSq(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selOslpNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selAucPrg(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selIndvAmnnoPgm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selFhsIdNo(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0215_delPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0215_insPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0215_updPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0215_updAucChange(Map<String, Object> map) throws Exception;

}
