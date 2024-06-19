package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0225Mapper {

	/**
	 * 출장우 접수 리스트
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0225_selList(Map<String, Object> map);

	/**
	 * 경매차수 조회
	 * @param map
	 * @return
	 */
	Map<String, Object> LALM0225_selAucQcn(Map<String, Object> map);
	
	/**
	 * 출장우 등록
	 * @param map
	 * @return
	 */
	int LALM0225_insSogCow(Map<String, Object> map);

	/**
	 * 출장우 삭제
	 * @param map
	 * @return
	 */
	int LALM0225_delSogCow(Map<String, Object> map);

	/** 출장우 친자검사일치 수정
	 * @methodName    : LALM0225P1_updDnaYn
	 * @author        : Jung JungWon
	 * @date          : 2023.07.05
	 * @Comments      : 
	 */
	int LALM0225P1_updDnaYn(Map<String, Object> map);

	Map<String, Object> LALM0225_selIndvChk(Map<String, Object> map);


}
