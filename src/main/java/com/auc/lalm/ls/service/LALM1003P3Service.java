package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1003P3Service {

	List<Map<String, Object>> LALM1003P3_insFhs(Map<String, Object> map) throws Exception;
	// Map<String, Object> LALM1003P3_insFhs(Map<String, Object> params) throws
	// Exception;

	Map<String, Object> LALM1003P3_insSogCow(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003P3_selIndvSync(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003P3_selSogCowVaild(Map<String, Object> map) throws Exception;

}
