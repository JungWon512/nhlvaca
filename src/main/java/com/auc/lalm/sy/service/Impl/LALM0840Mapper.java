package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0840Mapper {

	/**
	 * 알림톡 템플릿 리스트 조회
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0840_selList(Map<String, Object> map);

	/**
	 * 알림톡 템플릿 상세
	 * @param map
	 * @return
	 */
	Map<String, Object> LALM0840_selInfo(Map<String, Object> map);
	
	/**
	 * 알림톡 템플릿 저장
	 * @param map
	 * @return
	 */
	int LALM0840_insMsgTalk(Map<String, Object> map);

	/**
	 * 알림톡 템플릿 수정
	 * @param frmMap
	 * @return
	 */
	int LALM0840_updMsgTalk(Map<String, Object> map);
	
	/**
	 * 알림톡 템플릿 삭제
	 * @param frmMap
	 * @return
	 */
	int LALM0840_delMsgTalk(Map<String, Object> map);

}
