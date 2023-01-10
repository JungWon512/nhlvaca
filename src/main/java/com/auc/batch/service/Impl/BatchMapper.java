package com.auc.batch.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BatchMapper {

	List<Map<String, Object>> selDormaccMmMbintgList(Map<String, Object> map) throws Exception;

	int insDormUserMbintgData(Map<String, Object> map) throws Exception;

	int updDormUserMbintgMasking(Map<String, Object> map) throws Exception;

	int insDormUserMwmnData(Map<String, Object> map) throws Exception;

	int updDormUserMwmnMasking(Map<String, Object> map) throws Exception;

	int insDormUserFhsData(Map<String, Object> map) throws Exception;

	int updDormUserFhsMasking(Map<String, Object> map) throws Exception;

	int getExecBatchCount(Map<String, Object> pMap) throws Exception;

	int insBeforeBatchLog(Map<String, Object> map) throws Exception;

	int updAfterBatchLog(Map<String, Object> reMap) throws Exception;

	List<Map<String, Object>> selBzLocAucYn(Map<String, Object> map) throws Exception;

	Map<String, Object> selMaxAucDt(Map<String, Object> bzMap) throws Exception;

	int insDashBoardSogCow(Map<String, Object> sogCowMap) throws Exception;

	int insDashBoardAucEntr(Map<String, Object> aucEntrMap) throws Exception;

	int insDashBoardAucQcn(Map<String, Object> aucQcnMap) throws Exception;

	int insDashBoardIndv(Map<String, Object> sogCowMap) throws Exception;
	
	List<Map<String, Object>> selDormcPreUserMbintgList(Map<String, Object> map) throws Exception;

	Map<String, Object> selMaxAucNumPhoneInfo(Map<String, Object> reVo) throws Exception;

	Map<String, Object> selMaxSogCowPhoneInfo(Map<String, Object> reVo) throws Exception;

	int delDashBoardSaveForDay(Map<String, Object> bzMap) throws Exception;

	int insDashBoardSaveForDay(Map<String, Object> bzMap) throws Exception;

	int insDashBoardBtcAuc(Map<String, Object> map) throws Exception;
	int insDashBoardBtc(Map<String, Object> map) throws Exception;

	int delDashBoardBtc(Map<String, Object> btcMap) throws Exception;

	int delDashBoardBtcAuc(Map<String, Object> tempMap) throws Exception;

	int delDashBoardSaveForTop(Map<String, Object> bzMap) throws Exception;
	int insDashBoardSaveForTop(Map<String, Object> bzMap) throws Exception;

	int delDashBoardSaveForMkpr(Map<String, Object> map) throws Exception;

	int insDashBoardSaveForMkpr(Map<String, Object> map) throws Exception;

	int delDashBoardSaveForAreaAvgMkpr(Map<String, Object> map) throws Exception;

	int insDashBoardSaveForAreaAvgMkpr(Map<String, Object> map) throws Exception;

	Map<String, Object> selMatchMwmnPhoneInfo(Map<String, Object> reVo) throws Exception;

	Map<String, Object> selMatchFhsPhoneInfo(Map<String, Object> reVo) throws Exception;
}
