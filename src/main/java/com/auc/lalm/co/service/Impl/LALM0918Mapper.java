package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0918Mapper {
	// 노출항목 라디오버튼 조회
	List<Map<String, Object>> LALM0918_selData(Map<String, Object> map) throws Exception;
	// 노출항목 update
	int LALM0918_updData(Map<String, Object> map) throws Exception;
	// 간편비고항목 update
	int LALM0918_updMobileEtc(Map<String, Object> map) throws Exception;
	
}
