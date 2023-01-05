package com.auc.lalm.co.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface LALM0900Service {

	List<Map<String, Object>> LALM0900_selList(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0900P1_selData(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0900P1_insBlbd(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0900P1_updBlbd(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0900P1_delBlbd(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0900P1_insApdfl(Map<String, Object> inMap) throws Exception;
	Map<String, Object> LALM0900_selFileDownload(HashMap<String, Object> param) throws Exception;
	

}
