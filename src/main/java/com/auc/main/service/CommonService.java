package com.auc.main.service;

import java.util.List;
import java.util.Map;

public interface CommonService {
	Map<String, Object> Common_selAucDt(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selVet(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selAucQcn(Map<String, Object> map) throws Exception;
	int Common_insFeeImps(List<Map<String, Object>> grd_MhSogCow) throws Exception;
	List<Map<String, Object>> Common_selBack(Map<String, Object> map) throws Exception;
	Map<String, Object> Common_insBack(Map<String, Object> map) throws Exception;
	Map<String, Object> Common_updBack(Map<String, Object> map) throws Exception;
	Map<String, Object> Common_delBack(Map<String, Object> map) throws Exception;
}
