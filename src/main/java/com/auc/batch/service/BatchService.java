package com.auc.batch.service;

import java.util.List;
import java.util.Map;

public interface BatchService {

	List<Map<String, Object>> selDormaccMmMbintgList(Map<String, Object> map) throws Exception;

	Map<String, Object> insUpdDormUserMasking(Map<String, Object> reVo) throws Exception;

	Map<String, Object> createResultCUDBatch(Map<String, Object> inMap) throws Exception;

	int getExecBatchCount(Map<String, Object> map) throws Exception;

	int insBeforeBatchLog(Map<String, Object> map) throws Exception;

	int updAfterBatchLog(Map<String, Object> reMap) throws Exception;

	List<Map<String, Object>> selBzLocAucYn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> selDormcPreUserMbintgList(Map<String, Object> map) throws Exception;

	Map<String, Object> sendAlarmTalk_DormacPreUser(Map<String, Object> reVo) throws Exception;

	Map<String, Object> batchDashBoardSave(Map<String, Object> map) throws Exception;

	Map<String, Object> batchDashBoardBtc(Map<String, Object> map) throws Exception;
	Map<String, Object> batchDashBoardBtAuc(Map<String, Object> map) throws Exception;

	Map<String, Object> batchDashBoardFor5200(Map<String, Object> map, Map<String,Object> bizMap) throws Exception;
	Map<String, Object> batchDashBoardFor5300(Map<String, Object> map, Map<String,Object> bizMap) throws Exception;
	Map<String, Object> batchDashBoardFor5400(Map<String, Object> map, Map<String,Object> bizMap) throws Exception;
}
