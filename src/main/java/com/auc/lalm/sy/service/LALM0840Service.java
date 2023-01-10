package com.auc.lalm.sy.service;

import java.util.List;
import java.util.Map;

public interface LALM0840Service {
	
	// 알림톡 템플릿 리스트 조회
	List<Map<String, Object>> LALM0840_selList(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 상세
	Map<String, Object> LALM0840_selInfo(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 저장
	Map<String, Object> LALM0840_insMsgTalk(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 수정
	Map<String, Object> LALM0840_updMsgTalk(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 삭제
	Map<String, Object> LALM0840_delMsgTalk(Map<String, Object> map) throws Exception;
	
}
