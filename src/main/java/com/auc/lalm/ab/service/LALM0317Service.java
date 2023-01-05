package com.auc.lalm.ab.service;

import java.util.List;
import java.util.Map;

public interface LALM0317Service {

	List<Map<String, Object>> LALM0317_selList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0317_updFirstBatPrice(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0317_updBatPrice(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0317_updConti(Map<String, Object> map) throws Exception;

}
