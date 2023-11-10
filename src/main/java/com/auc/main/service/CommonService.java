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

	Map<String, Object> Common_insDownloadLog(Map<String, Object> map) throws Exception;
	
	// 개체정보 저장 or 수정
	Map<String, Object> common_updIndvInfo(Map<String, Object> map) throws Exception;
	
	
	/********************************************************************* 통합회원 관련 [s] *********************************************************************/

	/**
	 * 통합회원 신규 등록
	 * @param map
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> Common_insMbintgInfo(Map<String, Object> map) throws Exception;
	
	/********************************************************************* 통합회원 관련 [e] *********************************************************************/
	Map<String, Object> Common_selAiakInfo(String barcode) throws Exception;
}
