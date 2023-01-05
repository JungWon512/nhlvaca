package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0319Mapper {

	List<Map<String, Object>> LALM0319_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0319_sel_entr(Map<String, Object> map) throws Exception;
	

}
