package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0222PMapper {

	List<Map<String, Object>> LALM0222P_selTmpIndv(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0222P_selTmpFhs(Map<String, Object> map) throws Exception;
	
	int LALM0222P_insIsMmIndv(Map<String, Object> map) throws Exception;
	
	int LALM0222P_insIsMmFhs(Map<String, Object> map) throws Exception;
	
	int LALM0222P_updIsMmIndv(Map<String, Object> map) throws Exception;
	
	int LALM0222P_updIsMmFhs(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0222P_selBmBzloc(Map<String, Object> demap);


	int LALM0222P_updPostInf(Map<String, Object> map);

	int LALM0222P_insPostInf(Map<String, Object> map);

	int LALM0222P_updSibInf(Map<String, Object> map);

	int LALM0222P_insSibInf(Map<String, Object> map);

	int LALM0222P_delSibInf(Map<String, Object> temp) throws Exception;

	int LALM0222P_delPostInf(Map<String, Object> temp) throws Exception;

	int LALM0222P_delCattleMvInf(Map<String, Object> temp) throws Exception;

	int LALM0222P_insCattleMvInf(Map<String, Object> temp) throws Exception;

	void LALM0222P_delChildbirthInf(Map<String, Object> temp) throws Exception;

	int LALM0222P_insChildbirthInf(Map<String, Object> temp) throws Exception;

	int LALM0222P_delMatingInf(Map<String, Object> tempMap) throws Exception;

	int LALM0222P_insMatingInf(Map<String, Object> bhCrossMap) throws Exception;

}
