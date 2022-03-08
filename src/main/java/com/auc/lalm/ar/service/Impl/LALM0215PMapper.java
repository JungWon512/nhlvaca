package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0215PMapper {

	List<Map<String, Object>> LALM0215P_selList(Map<String, Object> map) throws Exception;
	

}
