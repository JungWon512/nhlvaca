package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1005Service {

	List<Map<String, Object>> LALM1005_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1005_selModlList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1005_updRmkPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1005_updModlPgm(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1005_updPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1005_updPgmOnlySave(Map<String, Object> map) throws Exception;

}
