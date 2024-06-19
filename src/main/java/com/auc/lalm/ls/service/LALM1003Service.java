package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1003Service {

	List<Map<String, Object>> LALM1003_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003_selAucQcn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003_selCalfList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003_selFeeImps(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003_insFeeReset(Map<String, Object> map) throws Exception;

	int LALM1003_selAucTmsCnt(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003_delSogCow(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003_delCntnDel(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003P1_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003P4_selList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003P2_updCow(List<Map<String, Object>> inList) throws Exception;

	Map<String, Object> LALM1003P4_updCowBun(List<Map<String, Object>> inList) throws Exception;

}
