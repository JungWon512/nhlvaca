package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0316Mapper {

	List<Map<String, Object>> Lalm0316_selList_MhAucQcn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0316_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0316_selList2(Map<String, Object> map) throws Exception;
	
	int LALM0316_updAtdrLog(Map<String, Object> map) throws Exception;	

}
