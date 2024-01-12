package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0219Mapper {

	List<Map<String, Object>> LALM0219_selList(Map<String, Object> map) throws Exception;
	
	int LALM0219_updSogCowSq(Map<String, Object> map) throws Exception;

	int LALM0219P1_updExcelUpload(Map<String, Object> tmp) throws Exception;

	Map<String, Object> LALM0219_selAucPrg(Map<String, Object> map) throws Exception;

}
