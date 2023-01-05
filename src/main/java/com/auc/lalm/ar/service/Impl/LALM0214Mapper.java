package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0214Mapper {

	List<Map<String, Object>> LALM0214_selList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0214_selList2(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0214_selAucQcn(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0214_selCalfList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0214_selFeeImps(Map<String, Object> map) throws Exception;
	
	int LALM0214_selAucTmsCnt(Map<String, Object> map) throws Exception;
	int LALM0214_delSogCog(Map<String, Object> map) throws Exception;
	int LALM0214_delFeeImps(Map<String, Object> map) throws Exception;
	int LALM0214_delCalf(Map<String, Object> map) throws Exception;
	int LALM0214_delCntnDel(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0214P1_selList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0214P4_selList(Map<String, Object> map) throws Exception;
	int LALM0214P2_updCow(Map<String, Object> map) throws Exception;
	int LALM0214P4_updCowBun(Map<String, Object> map) throws Exception;
	
}
