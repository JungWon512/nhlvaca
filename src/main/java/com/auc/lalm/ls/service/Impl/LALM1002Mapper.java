package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1002Mapper {

	List<Map<String, Object>> LALM1002_selList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1002_selDetail(Map<String, Object> map) throws Exception;

	int LALM1002_insFee(Map<String, Object> map) throws Exception;

	int LALM1002_updFee(Map<String, Object> map) throws Exception;

	int LALM1002_delFee(Map<String, Object> map) throws Exception;

}
