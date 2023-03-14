package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0214P3Mapper {

	List<Map<String, Object>> lalm0214P3_selFhs(Map<String, Object> map);

	int LALM0214P3_insFhs(Map<String, Object> map);
	
	int LALM0214P3_insSogCow(Map<String, Object> map);
}
