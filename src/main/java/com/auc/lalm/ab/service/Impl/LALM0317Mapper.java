package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0317Mapper {

	List<Map<String, Object>> LALM0317_selList(Map<String, Object> map) throws Exception;
	
	int LALM0317_updFirstBatPrice(Map<String, Object> map) throws Exception;
	
	int LALM0317_updBatPrice(Map<String, Object> map) throws Exception;
	
	int LALM0317_updConti(Map<String, Object> map) throws Exception;

}
