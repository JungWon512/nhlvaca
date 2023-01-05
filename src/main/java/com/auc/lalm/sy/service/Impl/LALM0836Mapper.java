package com.auc.lalm.sy.service.Impl;

import java.util.List; 
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0836Mapper {
	
	// 지역 조회
	List<Map<String, Object>> LALM0836_selBzplcloc();

	//조합조회 
	List<Map<String, Object>> LALM0836_selClntnm(Map<String, Object> map);

	// // 조합의 전화번호 & 주소 조회
	Map<String, Object> LALM0836_selTelAddress(Map<String, Object> map);

	// 메인테이블 삭제
	int LALM0836_delMainTable(Map<String, Object> map);

	//  서브테이블 삭제
	int LALM0836_delSubTable(Map<String, Object> map);

	// 메인테이블 삽입
	int LALM0836_insMainTable(Map<String, Object> map);

	// 서브테이블 인서트
	int LALM0836_insSubTable(Map<String, Object> map);

	// 그리드 조회
	List<Map<String, Object>> LALM0836_SelAucInfo(Map<String, Object> map);

	// 경매일자 정보 데이터 조회해오기
	Map<String, Object> LALM0836_selAucDateInfo(Map<String, Object> map);

	// 삭제 버튼
	int LALM0836_delAucDateInfo(Map<String, Object> map);

	// 서브테이블 행 조회 
	List<Map<String, Object>> LALM0836_selSubTable(Map<String, Object> map);


	
	
	
}
