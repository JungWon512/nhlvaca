package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0117Mapper {

	List<Map<String, Object>> LALM0117_selDormacPreUserList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0117_selDormacPreFhsList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0117_selDormacUserList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0117_selDormacFhsList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0117_selSecessionAplyUsrList(Map<String, Object> map) throws Exception;

	int LALM0117_updDormcPreClear(Map<String, Object> map) throws Exception;

	int LALM0117_insMbintgHistoryData(Map<String, Object> map) throws Exception;
	
	int LALM0117_insMwmnHistoryData(Map<String, Object> map) throws Exception;

	int LALM0117_updDormcUsrClear(Map<String, Object> map) throws Exception;

	int LALM0117_updDormacMwmnClear(Map<String, Object> map) throws Exception;

	int LALM0117_updDormacFhsClear(Map<String, Object> map) throws Exception;

	int LALM0117_delDormacMwmnData(Map<String, Object> map) throws Exception;

	int LALM0117_delDormacFhsData(Map<String, Object> map) throws Exception;

	int LALM0117_delDormacUsrData(Map<String, Object> map) throws Exception;

	int LALM0117_updDormacDelAccYn(Map<String, Object> map) throws Exception;

	int LALM0117_updDormacMwmnDelAccYn(Map<String, Object> map) throws Exception;

	int LALM0117_updDormacFhsDelAccYn(Map<String, Object> map) throws Exception;

	int LALM0117_updSecessionMwmnDelAccYn(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0117_selSecAplyRemainTrmnCnt(Map<String, Object> selMap) throws Exception;

	int LALM0117_delSecessionMbintgDelAccYn(Map<String, Object> map) throws Exception;

	int LALM0117_updSecessionMgrApprYn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0117_sendAlimPreDormcUser(Map<String, Object> map) throws Exception;
	
}
