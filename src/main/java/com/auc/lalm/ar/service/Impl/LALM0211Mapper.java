package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0211Mapper {

	List<Map<String, Object>> LALM0211_selList(Map<String, Object> map) throws Exception;
	

}
