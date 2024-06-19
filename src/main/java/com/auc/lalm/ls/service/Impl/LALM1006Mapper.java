package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1006Mapper {

	List<Map<String, Object>> LALM1006_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selSraList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selBadTrmn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selBadCheck(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selTrmnAmnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selAucPtcMnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1006_selSraCount(Map<String, Object> map) throws Exception;
	
	int LALM1006_updPgm(Map<String, Object> map) throws Exception;
	
	int LALM1006_insPgm(Map<String, Object> map) throws Exception;
	
	int LALM1006_insCalfPgm(Map<String, Object> map) throws Exception;
	
	int LALM1006_insMartPgm(Map<String, Object> map) throws Exception;
	
	int LALM1006_insBreedingPgm(Map<String, Object> map) throws Exception;
	
	int LALM1006_delPgm(Map<String, Object> map) throws Exception;

	int LALM1006_insAllPgm(Map<String, Object> map) throws Exception;

	int LALM1006_delAllPgm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1006_selBadCheckMwmn(Map<String, Object> map);

}
