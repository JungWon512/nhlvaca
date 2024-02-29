package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1004Mapper {

	List<Map<String, Object>> LALM1004_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selFee(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selStsDsc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selIndvAmnno(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selVoslpNo(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selPrgSq(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selMhCalf(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selTmpAucObjDsc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selTmpAucPrgSq(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selTmpFhsNm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selMacoFee(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selAucPrgSq(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selOslpNo(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selAucPrg(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selAmnno(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selChgVoslpNo(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selIndvAmnnoPgm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selFhsIdNo(Map<String, Object> map) throws Exception;

	int LALM1004_delSogCow(Map<String, Object> map) throws Exception;

	int LALM1004_delFeeImps(Map<String, Object> map) throws Exception;

	int LALM1004_delMhCalf(Map<String, Object> map) throws Exception;

	int LALM1004_insSogCow(Map<String, Object> map) throws Exception;

	int LALM1004_insMmIndv(Map<String, Object> map) throws Exception;

	int LALM1004_insMhFeeImps(Map<String, Object> map) throws Exception;

	int LALM1004_insMhCalf(Map<String, Object> map) throws Exception;

	int LALM1004_updIndv(Map<String, Object> map) throws Exception;

	int LALM1004_updMnIndv(Map<String, Object> map) throws Exception;

	int LALM1004_updMmFhs(Map<String, Object> map) throws Exception;

	int LALM1004_updIndvSet(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_selSogCow(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selSogCowImg(Map<String, Object> map) throws Exception;

	int LALM1004_insImgPgm(Map<String, Object> res) throws Exception;

	int LALM1004_delImgPgm(Map<String, Object> rMap) throws Exception;

}
