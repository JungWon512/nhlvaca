package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0899Mapper {

	List<Map<String, Object>> LALM0899_selMca1300(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca1600(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca1900(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca2000(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca2100(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca2700(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_101(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_102(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_103(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_201(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_202(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_104(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_201_9008(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3500(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3700(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3800(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3900(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0899_selMca4000(Map<String, Object> map) throws Exception;

	int LALM0899_selMca1600_ChkAmnno(Map<String, Object> map) throws Exception;

	int LALM0899_selMca1600_ChkAucObjDsc(Map<String, Object> map) throws Exception;

	int LALM0899_selMca1600Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca3900Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca3700Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca1300Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca1900Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca2000Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca2700Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca3500Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_delMca1200(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca1200(Map<String, Object> inMap) throws Exception;

	int LALM0899_selMca1200_fhsIdNo(Map<String, Object> inMap) throws Exception;

	int LALM0899_updMca1200(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca1200_2(Map<String, Object> inMap) throws Exception;

	int LALM0899_delMca1400(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca1400(Map<String, Object> inMap) throws Exception;

	int LALM0899_delMca1500(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca1500(Map<String, Object> inMap) throws Exception;

	int LALM0899_delMca3300(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca3300(Map<String, Object> inMap) throws Exception;

	int LALM0899_delMca1700(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca1700(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca1800(Map<String, Object> inMap) throws Exception;

	int LALM0899_delMca3400(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca3400(Map<String, Object> inMap) throws Exception;

	int LALM0899_selMca2100Cnt(Map<String, Object> map) throws Exception;

	int LALM0899_selMca1300Cnt_A(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca1300_A(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0899_selMca3000(Map<String, Object> map) throws Exception;

	int LALM0899_insMca3100(Map<String, Object> msgMap) throws Exception;

	int LALM0899_delMca2500(Map<String, Object> inMap) throws Exception;

	int LALM0899_insMca2500(Map<String, Object> inMap) throws Exception;

	int LALM0899_delMca1800(Map<String, Object> map) throws Exception;

	int LALM0899_insMca4600(Map<String, Object> inMap) throws Exception;

	Map<String, Object> LALM0899_selMca5100AlarmTalkId(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0899_selMca3100_201_Recv(Map<String, Object> map) throws Exception;

	/**
	 * @methodName    : LALM0899_selMca3100_201_Rmk
	 * @author        : Jung JungWon
	 * @date          : 2023.08.24
	 * @Comments      : 
	 */
	List<Map<String, Object>> LALM0899_selMca3100_201_Rmk(Map<String, Object> map) throws Exception;
}
