package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0321Mapper {

	List<Map<String, Object>> LALM0321_selList(Map<String, Object> map) throws Exception;
	
	int LALM0321_updSogCowSjamr(Map<String, Object> map) throws Exception;	
	

}
