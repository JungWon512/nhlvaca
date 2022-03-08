package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0516Mapper {

	List<Map<String, Object>> LALM0516_selFhsList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0516_selMwmnList(Map<String, Object> map) throws Exception;
	
}
