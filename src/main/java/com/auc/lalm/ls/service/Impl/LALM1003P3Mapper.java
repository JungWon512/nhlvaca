package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1003P3Mapper {

	List<Map<String, Object>> LALM1003P3_selFhs(Map<String, Object> map);

	int LALM1003P3_insFhs(Map<String, Object> map);

	int LALM1003P3_insSogCow(Map<String, Object> map);
}
