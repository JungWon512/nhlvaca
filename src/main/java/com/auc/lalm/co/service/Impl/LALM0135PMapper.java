package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0135PMapper {

	/**
	 * 통합회원검색
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> LALM0135P_selList(Map<String, Object> map) throws Exception;
	

}
