package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0213Mapper {

	List<Map<String, Object>> LALM0213_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selSraList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selBadTrmn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selBadCheck(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selTrmnAmnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selAucPtcMnNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0213_selSraCount(Map<String, Object> map) throws Exception;
	
	int LALM0213_updPgm(Map<String, Object> map) throws Exception;
	
	int LALM0213_insPgm(Map<String, Object> map) throws Exception;
	
	int LALM0213_insCalfPgm(Map<String, Object> map) throws Exception;
	
	int LALM0213_insMartPgm(Map<String, Object> map) throws Exception;
	
	int LALM0213_insBreedingPgm(Map<String, Object> map) throws Exception;
	
	int LALM0213_delPgm(Map<String, Object> map) throws Exception;

	int LALM0213_insAllPgm(Map<String, Object> map) throws Exception;

	int LALM0213_delAllPgm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0213_selBadCheckMwmn(Map<String, Object> map);

}
