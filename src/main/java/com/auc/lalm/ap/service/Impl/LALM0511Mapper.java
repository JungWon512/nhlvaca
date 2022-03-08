package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0511Mapper {

	List<Map<String, Object>> LALM0511_selList(Map<String, Object> map) throws Exception;
	
}
