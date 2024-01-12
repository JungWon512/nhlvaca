package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0219Service {

	List<Map<String, Object>> LALM0219_selList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0219_updSogCowSq(List<Map<String, Object>> inList) throws Exception;

	Map<String, Object> LALM0219P1_updExcelUpload(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0219_selAucPrg(Map<String, Object> tempMap) throws Exception;
}
