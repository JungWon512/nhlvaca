package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1004Service {

	/**
	 * 출장내역 정보 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> LALM1004_selList(Map<String, Object> map) throws Exception;

	/**
	 * 수수료 정보 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> LALM1004_selFee(Map<String, Object> map) throws Exception;

	/**
	 * 경매내역 저장 전 상태 변경 여부 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> LALM1004_selStsDsc(Map<String, Object> map) throws Exception;

	/**
	 * 개체번호 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> LALM1004_selIndvAmnno(Map<String, Object> map) throws Exception;

	/**
	 * 경매번호 중복 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> LALM1004_selAucPrg(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_delPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_insPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_updPgm(Map<String, Object> map) throws Exception;
}
