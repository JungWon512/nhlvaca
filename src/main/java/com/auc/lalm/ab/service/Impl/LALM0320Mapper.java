package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0320Mapper {

	List<Map<String, Object>> LALM0320_selList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0320_selAucIngList(Map<String, Object> map) throws Exception;
		
}
