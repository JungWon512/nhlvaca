package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0214P3Service {

	List<Map<String, Object>> LALM0214P3_insFhs(Map<String, Object> map) throws Exception;
	//Map<String, Object> LALM0214P3_insFhs(Map<String, Object> params) throws Exception;

	Map<String, Object> LALM0214P3_insSogCow(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0214P3_selIndvSync(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0214P3_selSogCowVaild(Map<String, Object> map) throws Exception;

}
