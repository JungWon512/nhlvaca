package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0217Mapper {

	List<Map<String, Object>> LALM0217_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0217_selQcn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0217_selAucStn(Map<String, Object> map) throws Exception;
	
	
	int LALM0217_insPgm(Map<String, Object> map) throws Exception;

	int LALM0217_insLogPgm(Map<String, Object> map) throws Exception;	

	int LALM0217_updPgm(Map<String, Object> map) throws Exception;
	
	int LALM0217_updLogPgm(Map<String, Object> map) throws Exception;

	int LALM0217_delPgm(Map<String, Object> map) throws Exception;	
	
	int LALM0217_delLogPgm(Map<String, Object> map) throws Exception;		
	
}
