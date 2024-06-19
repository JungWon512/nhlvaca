package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1003Mapper {

	List<Map<String, Object>> LALM1003_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003_selList2(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003_selAucQcn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003_selCalfList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003_selFeeImps(Map<String, Object> map) throws Exception;

	int LALM1003_selAucTmsCnt(Map<String, Object> map) throws Exception;

	int LALM1003_delSogCog(Map<String, Object> map) throws Exception;

	int LALM1003_delFeeImps(Map<String, Object> map) throws Exception;

	int LALM1003_delCalf(Map<String, Object> map) throws Exception;

	int LALM1003_delCntnDel(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003P1_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1003P4_selList(Map<String, Object> map) throws Exception;

	int LALM1003P2_updCow(Map<String, Object> map) throws Exception;

	int LALM1003P4_updCowBun(Map<String, Object> map) throws Exception;

}
