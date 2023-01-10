package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0227Service {
	
	// 알림톡 템플릿 리스트 조회
	List<Map<String, Object>> LALM0227_selList(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 상세
	Map<String, Object> LALM0227_selInfo(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 저장
	Map<String, Object> LALM0227_insMsgTalk(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 수정
	Map<String, Object> LALM0227_updMsgTalk(Map<String, Object> map) throws Exception;
	
	// 알림톡 템플릿 삭제
	Map<String, Object> LALM0227_delMsgTalk(Map<String, Object> map) throws Exception;
	
}
