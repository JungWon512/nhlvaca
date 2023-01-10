package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0118Mapper {

	List<Map<String, Object>> LALM0118_selList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0118_selBlackDetail(Map<String, Object> map) throws Exception;

	int LALM0118_chk_Black(Map<String, Object> map) throws Exception;

	int LALM0118_updBlack(Map<String, Object> map) throws Exception;

	int LALM0118_insBlack(Map<String, Object> map) throws Exception;
	
	int LALM0118_delBlack(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0118_selBzplcLoc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0118_selClntnm(Map<String, Object> map) throws Exception;
}
