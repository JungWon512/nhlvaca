package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0832Mapper {

	List<Map<String, Object>> LALM0832_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0832_selBtnList(Map<String, Object> map) throws Exception;

	int LALM0832_insPgm(Map<String, Object> map) throws Exception;

	int LALM0832_insPgmBtn(Map<String, Object> btnMap) throws Exception;

	int LALM0832_updPgm(Map<String, Object> map) throws Exception;

	int LALM0832_updPgmBtn(Map<String, Object> map) throws Exception;

	int LALM0832_delPgm(Map<String, Object> map) throws Exception;

	int LALM0832_delPgmBtn(Map<String, Object> map) throws Exception;

	int test1();

	int test2();

	int test3();
	
	

}
