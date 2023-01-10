package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0915Mapper {

	int LALM0915_selUsr(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0915_selPW(Map<String, Object> map) throws Exception;
	
}
