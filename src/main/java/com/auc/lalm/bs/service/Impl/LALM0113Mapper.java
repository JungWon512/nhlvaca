package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0113Mapper {

	int LALM0113_updCusRlno(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0113_selListGrd_MmMwmn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0113_selListFrm_MmMwmn(Map<String, Object> map) throws Exception;

	int LALM0113_vTrmnAmnno(Map<String, Object> map) throws Exception;

	int LALM0113_insTrmn(Map<String, Object> map) throws Exception;

	int LALM0113_TrmnInsMiMwmn(Map<String, Object> map) throws Exception;

	int LALM0113_updTrmn(Map<String, Object> map) throws Exception;

	int LALM0113_delTrmn(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0113_selDetail(Map<String, Object> selMap) throws Exception;

	/**
	 * 이름(SRA_MWMNNM), 생년월일(CUS_RLNO), 휴대전화번호(CUS_MPNO)로 통합회원코드 조회
	 * @param map
	 * @return
	 */
	Map<String, Object> LALM0113_selMwmnMbIntgNo(Map<String, Object> map);

	/**
	 * 동일한 이름, 생년월일, 휴대전화번호로 등록된 정보가 있는지 확인
	 * @param map
	 * @return
	 */
	Map<String, Object> LALM0113_selMwmnInfo(Map<String, Object> map);

	/**
	 * 이름(SRA_MWMNNM), 생년월일(CUS_RLNO), 휴대전화번호(CUS_MPNO)로 통합회원정보 조회
	 * @param map
	 * @return
	 */
	Map<String, Object> LALM0113_selMbIntgInfo(Map<String, Object> map);

	/**
	 * 통합회원정보 저장
	 * @param map
	 */
	void LALM0113_insMbIntgInfo(Map<String, Object> map);
}
