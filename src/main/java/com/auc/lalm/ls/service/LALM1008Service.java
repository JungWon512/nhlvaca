package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1008Service {

	List<Map<String, Object>> LALM1008_selList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1008_updFirstBatPrice(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1008_updBatPrice(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1008_updConti(Map<String, Object> map) throws Exception;

}
