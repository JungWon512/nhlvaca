package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1004Mapper {

	List<Map<String, Object>> LALM1004_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selFee(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selStsDsc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selIndvAmnno(Map<String, Object> map) throws Exception;

	int LALM1004_insSogCow(Map<String, Object> map) throws Exception;

	int LALM1004_insMmIndv(Map<String, Object> map) throws Exception;

	int LALM1004_insMhFeeImps(Map<String, Object> map) throws Exception;

	int LALM1004_updIndv(Map<String, Object> map) throws Exception;

	int LALM1004_updMnIndv(Map<String, Object> map) throws Exception;

	int LALM1004_updMmFhs(Map<String, Object> map) throws Exception;

	int LALM1004_delSogCow(Map<String, Object> map) throws Exception;

	int LALM1004_delFeeImps(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1004_selVoslpNo(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selAucPrg(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_selFtsnm(Map<String, Object> map) throws Exception;


	Map<String, Object> LALM1004_selSogCow(Map<String, Object> map) throws Exception;
}
