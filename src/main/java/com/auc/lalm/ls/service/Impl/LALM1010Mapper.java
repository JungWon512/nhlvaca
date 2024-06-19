package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
@Mapper
public interface LALM1010Mapper {

	List<Map<String, Object>> LALM1010_selList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM1010_selList_2(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM1010_selList_3(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM1010_selList_4(Map<String, Object> map) throws Exception;
}
