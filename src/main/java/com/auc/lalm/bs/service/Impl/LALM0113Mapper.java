package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0113Mapper {

	int LALM0113_updCusRlno(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0113_selListGrd_MmMwmn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0113_selListFrm_MmMwmn(Map<String, Object> map) throws Exception;

	int LALM0113_vTrmnAmnno(Map<String, Object> map) throws Exception;

	int LALM0113_insTrmn(Map<String, Object> map) throws Exception;

	int LALM0113_TrmnInsMiMwmn(Map<String, Object> map) throws Exception;

	int LALM0113_updTrmn(Map<String, Object> map) throws Exception;

	int LALM0113_delTrmn(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0113_selDetail(Map<String, Object> selMap) throws Exception;

	
	
}
