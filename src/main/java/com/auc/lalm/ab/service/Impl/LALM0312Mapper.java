package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0312Mapper {

	List<Map<String, Object>> LALM0312_selList(Map<String, Object> map) throws Exception;
	
	int LALM0312_updSogCowSjam(Map<String, Object> map) throws Exception;

}
