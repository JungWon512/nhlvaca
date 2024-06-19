package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1009Mapper {

	List<Map<String, Object>> LALM1009_selList(Map<String, Object> map) throws Exception;

}
