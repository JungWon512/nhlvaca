package com.auc.lalm.co.service;

import java.util.List;
import java.util.Map;

public interface LALM0918Service {
	// 노출항목 라디오버튼 조회
	List<Map<String, Object>> LALM0918_selData(Map<String, Object> map) throws Exception;
	// 노출항목 input 조회
	Map<String, Object> LALM0918_selMobileEtc(Map<String, Object> map) throws Exception;
	// 노출항목 update
	Map<String, Object> LALM0918_updData(Map<String, Object> map) throws Exception;

}
