package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0919Mapper {

	List<Map<String, Object>> LALM0919_selMhSogCowCntList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0919_selMhSogCowPriceList(Map<String, Object> map) throws Exception;
	
}
