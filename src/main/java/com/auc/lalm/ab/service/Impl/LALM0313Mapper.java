package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0313Mapper {

	List<Map<String, Object>> LALM0313_selList(Map<String, Object> map) throws Exception;

	int LALM0313_insList(Map<String, Object> map) throws Exception;
	
}
