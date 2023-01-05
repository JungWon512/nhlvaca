package com.auc.lalm.bs.service;

import java.util.List;
import java.util.Map;

public interface LALM0118Service {

	List<Map<String, Object>> LALM0118_selList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0118_selBlackDetail(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0118_insBlackList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0118_delBlack(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0118_selBzplcLoc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0118_selClntnm(Map<String, Object> map) throws Exception;
}
