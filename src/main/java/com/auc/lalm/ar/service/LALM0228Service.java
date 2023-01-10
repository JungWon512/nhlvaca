package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

public interface LALM0228Service {
	
	// 알림톡 발송 대상자 조회
	List<Map<String, Object>> LALM0228_selAlarmList(Map<String, Object> map) throws Exception;
	
}
