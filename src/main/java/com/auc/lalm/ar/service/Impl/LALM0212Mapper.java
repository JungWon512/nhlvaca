package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0212Mapper {

	List<Map<String, Object>> LALM0212_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selQcn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selAucQcn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selmhSogCow(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0212_selMaxQcn(Map<String, Object> map) throws Exception;
	
	int LALM0212_updDdl(Map<String, Object> map) throws Exception;
	
	int LALM0212_updCan(Map<String, Object> map) throws Exception;
	
	int LALM0212_insPgm(Map<String, Object> map) throws Exception;
	
	int LALM0212_insLogPgm(Map<String, Object> map) throws Exception;
	
	int LALM0212_updInsPgm(Map<String, Object> map) throws Exception;
	
	int LALM0212_updPgm(Map<String, Object> map) throws Exception;
	
	int LALM0212_updLogPgm(Map<String, Object> map) throws Exception;
	
	int LALM0212_delPgm(Map<String, Object> map) throws Exception;
	
	int LALM0212_delLogPgm(Map<String, Object> map) throws Exception;

}
