package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0215Mapper {

	List<Map<String, Object>> LALM0215_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selFee(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selStsDsc(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selIndvAmnno(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selVoslpNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selPrgSq(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selMhCalf(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selTmpAucObjDsc(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selTmpAucPrgSq(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selTmpFhsNm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selMacoFee(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selAucPrgSq(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selOslpNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selAucPrg(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selAmnno(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selChgVoslpNo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selIndvAmnnoPgm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0215_selFhsIdNo(Map<String, Object> map) throws Exception;
	
	int LALM0215_delSogCow(Map<String, Object> map) throws Exception;
	
	int LALM0215_delFeeImps(Map<String, Object> map) throws Exception;
	
	int LALM0215_delMhCalf(Map<String, Object> map) throws Exception;
	
	int LALM0215_insSogCow(Map<String, Object> map) throws Exception;
	
	int LALM0215_insMmIndv(Map<String, Object> map) throws Exception;
	
	int LALM0215_insMhFeeImps(Map<String, Object> map) throws Exception;
	
	int LALM0215_insMhCalf(Map<String, Object> map) throws Exception;
	
	int LALM0215_updIndv(Map<String, Object> map) throws Exception;
	
	int LALM0215_updMnIndv(Map<String, Object> map) throws Exception;
	
	int LALM0215_updMmFhs(Map<String, Object> map) throws Exception;
	
	int LALM0215_updIndvSet(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0215_selSogCow(Map<String, Object> map) throws Exception;
	

}
