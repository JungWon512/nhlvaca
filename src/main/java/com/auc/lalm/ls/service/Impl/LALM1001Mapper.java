package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1001Mapper {

	List<Map<String, Object>> LALM1001_selList(Map<String, Object> map) throws Exception;

	int LALM1001_chk_Indv(Map<String, Object> map) throws Exception;
	
	int LALM1001_insIndv(Map<String, Object> map) throws Exception;
	
	int LALM1001_updIndv(Map<String, Object> map) throws Exception;

	int LALM1001_chk_delIndv(Map<String, Object> map) throws Exception;

	int LALM1001_delIndv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1001_selIndvDetail(Map<String, Object> map) throws Exception;

	

	


}
