package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0220Mapper {

	List<Map<String, Object>> LALM0220_selList(Map<String, Object> map) throws Exception;
	
}
