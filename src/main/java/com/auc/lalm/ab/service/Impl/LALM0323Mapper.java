package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0323Mapper {

	List<Map<String, Object>> LALM0323_selList(Map<String, Object> map) throws Exception;
	int LALM0323_updBatPrice(Map<String, Object> map) throws Exception;
	int LALM0323_updConti(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0323P_selList(Map<String, Object> map) throws Exception;
	

}
