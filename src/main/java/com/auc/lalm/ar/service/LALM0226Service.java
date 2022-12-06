package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

/**
 * [LALM0226] 출장우 접수 Service
 * @author ishift
 */
public interface LALM0226Service {

	/**
	 * 접수내역 조회
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0226_selList(Map<String, Object> map);

	/**
	 * 접수내역 상세
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0226_selInfo(Map<String, Object> map);
	
	/**
	 * 접수내역 저장
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> LALM0226_insPgm(Map<String, Object> map) throws Exception;

	/**
	 * 접수내역 수정
	 * @param map
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> LALM0226_updPgm(Map<String, Object> map) throws Exception;


}
