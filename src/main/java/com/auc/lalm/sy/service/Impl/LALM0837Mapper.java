package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0837Mapper {

	List<Map<String, Object>> LALM0837_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0837_selUsrList(Map<String, Object> map) throws Exception;
	


}
