package com.auc.main.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommonMapper {
	Map<String, Object> Common_selAucDt(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selVet(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selAucQcn(Map<String, Object> map) throws Exception;
	

	int Common_delFee(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selFee(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selPpgcowFeeDsc(Map<String, Object> map) throws Exception;
	int Common_insFeeImps(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> Common_selBack(Map<String, Object> map) throws Exception;
	int Common_insBack(Map<String, Object> map) throws Exception;
	int Common_updBack(Map<String, Object> map) throws Exception;
	int Common_delBack(Map<String, Object> map) throws Exception;
	
	/* 20221005 jjw 공통 로그추가 */
	int Common_insDownloadLog(Map<String, Object> inMap)  throws Exception;	
	
	// ********************************* 개체 등록/수정 관련 [s] **************************************
	List<Map<String, Object>> common_selAmnno(Map<String, Object> map);
	int common_updMnIndv(Map<String, Object> map) throws Exception;
	int common_insMmIndv(Map<String, Object> map) throws Exception;
	// ********************************* 개체 등록/수정 관련 [e] **************************************
	
	// ****************************** 중도매인, 출하주 통합 관련 [s] **********************************
	/**
	 * 통합회원 테이블(TB_LA_IS_MM_MBINTG)에서 이름, 생년월일, 전화번호로 정보 조회
	 * @param map
	 * @return
	 */
	Map<String, Object> Common_selMbintgInfo(Map<String, Object> map);
	List<Map<String, Object>> Common_selMbintgList(Map<String, Object> map);
	
	/**
	 * 농가정보 테이블(TB_LA_IS_MM_FHS)에서 농가식별번호, 농장관리번호로 정보 조회
	 * @param map
	 * @return
	 */
	Map<String, Object> Common_selFhsMbintgInfo(Map<String, Object> map);
	
	/**
	 * 통합회원 휴면정보 테이블(TB_LA_IS_BK_DORM_MBINTG)에서 이름, 생년월일, 전화번호로 정보 조회
	 * @param map
	 * @return
	 */
	Map<String, Object> Common_selDormMbintgInfo(Map<String, Object> map);
	
	/**
	 * 통합회원 정보 저장
	 * @param map
	 * @return
	 */
	int Common_insMbintgInfo(Map<String, Object> map);
	
	/**
	 * 회원 정보 복구
	 * @param map
	 * @return
	 */
	int Common_resMbintgInfo(Map<String, Object> map);
	
	/**
	 * 통합회원 히스토리 정보 저장
	 * @param map
	 * @return
	 */
	int Common_insMbintgHisInfo(Map<String, Object> map);
	
	/**
	 * 백업 휴면정보 삭제
	 * @param map
	 * @return
	 */
	int Common_delDormMbintgInfo(Map<String, Object> map);

	/**
	 * 중도매인 정보 복구
	 * @param map
	 * @return
	 */
	int Common_resMwmnInfo(Map<String, Object> map);
	
	/**
	 * 중도매인 이력 저장
	 * @param map
	 * @return
	 */
	int Common_insMiMwmnInfo(Map<String, Object> map);
	
	/**
	 * 출하주 정보 복구
	 * @param map
	 * @return
	 */
	int Common_resFhsInfo(Map<String, Object> map);
	

	
	int Common_insAiakPostInfo(Map<String, Object> postMap) throws Exception;
	int Common_insAiakSibInfo(Map<String, Object> postMap) throws Exception;
	int Common_insAiakInfo(Map<String, Object> map) throws Exception;

	int Common_delAiakPostInfo(Map<String, Object> map) throws Exception;
	int Common_delAiakSibInfo(Map<String, Object> map) throws Exception;
	int Common_updIndvSibMatime(Map<String, Object> map) throws Exception;
	int Common_updIndvPostMatime(Map<String, Object> map) throws Exception;
	int Common_insertIndvAiakInfoLog(Map<String, Object> map) throws Exception;
	
}
