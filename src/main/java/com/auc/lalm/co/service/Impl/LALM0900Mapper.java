package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0900Mapper {

	List<Map<String, Object>> LALM0900_selList(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0900P1_selData(Map<String, Object> map) throws Exception;
	int LALM0900P1_insBlbd(Map<String, Object> map) throws Exception;
	int LALM0900P1_updBlbd(Map<String, Object> map) throws Exception;
	int LALM0900P1_delBlbd(Map<String, Object> map) throws Exception;
	
	int LALM0900P1_insBlbdInqCn(Map<String, Object> map) throws Exception;
	int LALM0900P1_insApdfl(Map<String, Object> inMap) throws Exception;
	String LALM0900P1_selApdfl(Map<String, Object> inMap) throws Exception;
	Map<String, Object> LALM0900_selFileDownload(HashMap<String, Object> paraMap) throws Exception;
	int LALM0900P1_delApdfl(Map<String, Object> map) throws Exception;
	
	
	

	

}
