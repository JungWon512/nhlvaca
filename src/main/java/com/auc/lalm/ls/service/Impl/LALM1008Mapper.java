package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1008Mapper {

	List<Map<String, Object>> LALM1008_selList(Map<String, Object> map) throws Exception;
	
	int LALM1008_updFirstBatPrice(Map<String, Object> map) throws Exception;
	
	int LALM1008_updBatPrice(Map<String, Object> map) throws Exception;
	
	int LALM1008_updConti(Map<String, Object> map) throws Exception;

}
