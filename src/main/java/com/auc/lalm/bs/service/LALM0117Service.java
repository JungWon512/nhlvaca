package com.auc.lalm.bs.service;

import java.util.List;
import java.util.Map;

public interface LALM0117Service {

	List<Map<String, Object>> LALM0117_selDormacPreList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0117_selDormacUsrList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0117_updDormcPreClear(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0117_updDormcUsrClear(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0117_delDormcSelectUser(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0117_selSecessionAplyUsrList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0117_delSecApplyUserData(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0117_sendAlimPreDormcUser(Map<String, Object> map) throws Exception;
}
