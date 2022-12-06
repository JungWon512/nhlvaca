package com.auc.main.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommonMapper {
	Map<String, Object> Common_selAucDt(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selVet(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selAucQcn(Map<String, Object> map) throws Exception;
	

	int Common_delFee(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selFee(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selPpgcowFeeDsc(Map<String, Object> map) throws Exception;
	int Common_insFeeImps(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selBack(Map<String, Object> map) throws Exception;
	int Common_insBack(Map<String, Object> map) throws Exception;
	int Common_updBack(Map<String, Object> map) throws Exception;
	int Common_delBack(Map<String, Object> map) throws Exception;
	
	/* 20221005 jjw 공통 로그추가 */
	int Common_insDownloadLog(Map<String, Object> inMap)  throws Exception;	
	
	// **************************** 개체 등록/수정 관련 [s] **************************************
	List<Map<String, Object>> common_selAmnno(Map<String, Object> map);
	int common_updMnIndv(Map<String, Object> map) throws Exception;
	int common_insMmIndv(Map<String, Object> map) throws Exception;
	// **************************** 개체 등록/수정 관련 [e] **************************************
	
	
}
