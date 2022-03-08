package com.auc.lalm.sy.service;

import java.util.List;
import java.util.Map;

public interface LALM0833Service {

	List<Map<String, Object>> LALM0833_selList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0833_insUsr(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0833_updUsr(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0833_delUsr(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0833_selGrpCode(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0833_selGrpList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0833_delGrpList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0833_updGrpList(Map<String, Object> map) throws Exception;
	

}
