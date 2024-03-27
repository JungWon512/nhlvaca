package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1004Service {

	List<Map<String, Object>> LALM1004_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selFee(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selStsDsc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selIndvAmnno(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selPrgSq(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selMhCalf(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selTmpAucPrgSq(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selTmpFhsNm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selMacoFee(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selAucPrgSq(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selOslpNo(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selAucPrg(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selIndvAmnnoPgm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1004_selFhsIdNo(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_delPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_insPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_updPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1004_updAucChange(Map<String, Object> map) throws Exception;
}
