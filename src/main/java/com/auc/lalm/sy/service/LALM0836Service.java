package com.auc.lalm.sy.service;

import java.util.List; 
import java.util.Map;

public interface LALM0836Service {


	//	지역 조회 
	List<Map<String, Object>> LALM0836_selBzplcloc() throws Exception;

	//조합조회
	List<Map<String, Object>> LALM0836_selClntnm(Map<String, Object> map) throws Exception;

	// 조합의 전화번호 & 주소 조회
	Map<String, Object> LALM0836_selTelAddress(Map<String, Object> map)throws Exception;

	// 메인테이블, 서브테이블 인서트
	Map<String, Object> LALM0836_insAucDateInfo(Map<String, Object> map)throws Exception;

	// 쿼리그리드 조회 
	List<Map<String, Object>> LALM0836_SelAucInfo(Map<String, Object> map)throws Exception;

	// 경매일자 정보 데이터 조회해오기
	Map<String, Object> LALM0836_selAucDateInfo(Map<String, Object> map)throws Exception;

	// 삭제 버튼
	Map<String, Object> LALM0836_delAucDateInfo(Map<String, Object> map)throws Exception;

	// 삭제 버튼
//	Map<String, Object> LALM0836_selSubTable(Map<String, Object> map)throws Exception;




}
