package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0116Mapper {

	List<Map<String, Object>> LALM0116_selList(Map<String, Object> map) throws Exception;
	
}
