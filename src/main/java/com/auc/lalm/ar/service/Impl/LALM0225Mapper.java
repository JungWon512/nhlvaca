package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0225Mapper {

	/**
	 * 출장우 접수 리스트
	 * @param map
	 * @return
	 */
	List<Map<String, Object>> LALM0225_selList(Map<String, Object> map);

}
