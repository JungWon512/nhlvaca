package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0834Mapper {

	List<Map<String, Object>> LALM0834_selList(Map<String, Object> map) throws Exception;
	
	int LALM0834_delList(Map<String, Object> map) throws Exception;
	
	int LALM0834_insList(Map<String, Object> map) throws Exception;

//	int LALM0833_insUsr(Map<String, Object> map) throws Exception;
//
//	int LALM0833_updUsr(Map<String, Object> map) throws Exception;
//
//	int LALM0833_delUsr(Map<String, Object> map) throws Exception;

}
