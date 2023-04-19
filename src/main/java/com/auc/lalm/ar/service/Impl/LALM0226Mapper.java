package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0226Mapper {

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
	 * 지정한 경매일자에 등록된 동일한 개체가 있는지 확인
	 * @param frmMap
	 * @return
	 */
	Map<String, Object> LALM0226_selIndvChk(Map<String, Object> frmMap);
	
	/**
	 * 접수내역 저장
	 * @param map
	 * @return
	 */
	int LALM0226_insCowRecv(Map<String, Object> map);

	/**
	 * 접수내역 수정
	 * @param frmMap
	 * @return
	 */
	int LALM0226_updCowRecv(Map<String, Object> frmMap);

	/**
	 * @methodName    : LALM0226_delCowRecv
	 * @author        : Jung JungWon
	 * @date          : 2023.04.12
	 * @Comments      : 
	 */
	int LALM0226_delCowRecv(Map<String, Object> frmMap);

}
