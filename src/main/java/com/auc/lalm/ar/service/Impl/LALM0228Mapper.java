package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0228Mapper {

	/**
	 * 알림톡 템플릿 리스트 조회
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0228_selList(Map<String, Object> map);

	List<Map<String, Object>> LALM0228_selList2(Map<String, Object> map);
	
	List<Map<String, Object>> LALM0228_selList3(Map<String, Object> map);
	
	List<Map<String, Object>> LALM0228_selList4(Map<String, Object> map);
	
	List<Map<String, Object>> LALM0228_selCntList(Map<String, Object> map);
}
