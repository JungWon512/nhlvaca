package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0222PMapper {

	List<Map<String, Object>> LALM0222P_selTmpIndv(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0222P_selTmpFhs(Map<String, Object> map) throws Exception;
	
	int LALM0222P_insIsMmIndv(Map<String, Object> map) throws Exception;
	
	int LALM0222P_insIsMmFhs(Map<String, Object> map) throws Exception;
	
	int LALM0222P_updIsMmIndv(Map<String, Object> map) throws Exception;
	
	int LALM0222P_updIsMmFhs(Map<String, Object> map) throws Exception;

}
