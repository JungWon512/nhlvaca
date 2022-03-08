package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0111Mapper {

	List<Map<String, Object>> LALM0111_selList(Map<String, Object> map) throws Exception;

	int LALM0111_insFarm(Map<String, Object> map) throws Exception;

	int LALM0111_updFarm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0111_selFhsAnw(Map<String, Object> map) throws Exception;

	int LALM0111_selChkFhsCow(Map<String, Object> map) throws Exception;

	int LALM0111_delFhs(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0111_selDetail(Map<String, Object> map) throws Exception;


}
