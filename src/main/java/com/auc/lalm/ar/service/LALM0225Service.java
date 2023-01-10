package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0225Service {

	/**
	 * 출장우 접수 리스트
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0225_selList(Map<String, Object> map);

	/**
	 * 출장우 접수 -> 출장우 등록 전환
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> LALM0225_insSogCow(Map<String, Object> map) throws Exception;

}
