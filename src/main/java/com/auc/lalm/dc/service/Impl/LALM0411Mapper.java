package com.auc.lalm.dc.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0411Mapper {

	int LALM0411_updMwmn(Map<String, Object> map) throws Exception;

	int LALM0411_updAucQcn(Map<String, Object> updMap) throws Exception;

	int LALM0411_updMwmnAdj(Map<String, Object> updMap) throws Exception;

	int LALM0411_updMwmnEntr(Map<String, Object> updMap) throws Exception;

	int LALM0411_updRkonCm(Map<String, Object> updMap) throws Exception;

	int LALM0411_selChkSogCow(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_selMaxOslpNo(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0411_selOslpNoList(Map<String, Object> map) throws Exception;

	int LALM0411_updOslpSogCow(Map<String, Object> inMap) throws Exception;

	int LALM0411_updOslpFeeImps(Map<String, Object> inMap) throws Exception;

	int LALM0411_updOslpMhCalf(Map<String, Object> inMap) throws Exception;

	int LALM0411_updOslpAtdrLog(Map<String, Object> inMap) throws Exception;

	int LALM0411_updOslpPlaPr(Map<String, Object> inMap) throws Exception;

	int LALM0411_updSogCow(Map<String, Object> updMap) throws Exception;

	int LALM0411_updSogCowFee(Map<String, Object> updMap) throws Exception;

	int LALM0411_updSogCowCalf(Map<String, Object> updMap) throws Exception;

	int LALM0411_updAtdrLog(Map<String, Object> updMap) throws Exception;

	List<Map<String, Object>> LALM0411_selFhsInfo(Map<String, Object> map) throws Exception;

}
  