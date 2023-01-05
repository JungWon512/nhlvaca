package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0227Mapper {

	/**
	 * 알림톡 템플릿 리스트 조회
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0227_selList(Map<String, Object> map);

	/**
	 * 알림톡 템플릿 상세
	 * @param map
	 * @return
	 */
	Map<String, Object> LALM0227_selInfo(Map<String, Object> map);
	
	/**
	 * 알림톡 템플릿 저장
	 * @param map
	 * @return
	 */
	int LALM0227_insMsgTalk(Map<String, Object> map);

	/**
	 * 알림톡 템플릿 수정
	 * @param frmMap
	 * @return
	 */
	int LALM0227_updMsgTalk(Map<String, Object> map);
	
	/**
	 * 알림톡 템플릿 삭제
	 * @param frmMap
	 * @return
	 */
	int LALM0227_delMsgTalk(Map<String, Object> map);

}
