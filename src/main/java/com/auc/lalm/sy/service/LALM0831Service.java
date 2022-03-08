package com.auc.lalm.sy.service;

import java.util.List;
import java.util.Map;

public interface LALM0831Service {

	List<Map<String, Object>> LALM0831_selList() throws Exception;

	Map<String, Object> LALM0831_insMenu(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0831_updMenu(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0831_delMenu(Map<String, Object> map) throws Exception;
	

}
