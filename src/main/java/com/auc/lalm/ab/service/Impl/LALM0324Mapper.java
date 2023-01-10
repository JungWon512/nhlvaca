package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0324Mapper {

	List<Map<String, Object>> Lalm0324_selList(Map<String, Object> map) throws Exception;

}
