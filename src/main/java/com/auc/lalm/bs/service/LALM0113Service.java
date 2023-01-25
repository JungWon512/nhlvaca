package com.auc.lalm.bs.service;

import java.util.List;
import java.util.Map;

public interface LALM0113Service {

	List<Map<String, Object>> LALM0113_selListGrd_MmMwmn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0113_selListFrm_MmMwmn(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0113_insTrmn(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0113_updTrmn(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0113_delTrmn(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0113_selDetail(Map<String, Object> map) throws Exception;

	/**
	 * 중도매인 통합회원번호 삭제
	 * @param map
	 * @return
	 */
	Map<String, Object> LALM0113_delMbIntgNo(Map<String, Object> map);

}
