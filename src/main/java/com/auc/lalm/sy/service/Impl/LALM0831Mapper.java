package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0831Mapper {

	List<Map<String, Object>> LALM0831_selList() throws Exception;

	int LALM0831_insMenu(Map<String, Object> map) throws Exception;

	int LALM0831_updMenu(Map<String, Object> map) throws Exception;

	int LALM0831_delMenu(Map<String, Object> map) throws Exception;

	int LALM0831_insMenuAuth(Map<String, Object> authMap) throws Exception;

	int LALM0831_delMenuAuth(Map<String, Object> map) throws Exception;

}
