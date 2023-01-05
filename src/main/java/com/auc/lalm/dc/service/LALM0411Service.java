package com.auc.lalm.dc.service;

import java.util.List;
import java.util.Map;

public interface LALM0411Service {

	Map<String, Object> LALM0411_updMwmn(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_updAucQcn(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_updMwmnAdj(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_updMwmnEntr(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_updRkonCm(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_selChkSogCow(Map<String, Object> map) throws Exception;

	Map<String, Object> updSogCowLog(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_updSogCowFee(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_updSogCowCalf(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0411_updAtdrLog(List<Map<String, Object>> insList, Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0411_selFhsInfo(Map<String, Object> map) throws Exception;

}
