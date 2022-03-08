package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0114Mapper {

	List<Map<String, Object>> LALM0114_selList(Map<String, Object> map) throws Exception;

	int LALM0114_chk_Indv(Map<String, Object> map) throws Exception;
	
	int LALM0114_insIndv(Map<String, Object> map) throws Exception;
	
	int LALM0114_updIndv(Map<String, Object> map) throws Exception;

	int LALM0114_chk_delIndv(Map<String, Object> map) throws Exception;

	int LALM0114_delIndv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0114_selIndvDetail(Map<String, Object> map) throws Exception;

	

	


}
