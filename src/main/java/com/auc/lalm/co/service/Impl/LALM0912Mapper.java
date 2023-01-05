package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0912Mapper {

	Map<String, Object> LALM0912_selData(Map<String, Object> map) throws Exception;
	int LALM0912_insWmc(Map<String, Object> map) throws Exception;
	int LALM0912_updWmc(Map<String, Object> map) throws Exception;
	int LALM0912_delWmc(Map<String, Object> map) throws Exception;
	
	int LALM0912_insEnvEst(Map<String, Object> map) throws Exception;
	int LALM0912_updEnvEst(Map<String, Object> map) throws Exception;
	int LALM0912_delEnvEst(Map<String, Object> map) throws Exception;
	

	int LALM0912_insBzloc(Map<String, Object> map) throws Exception;
	int LALM0912_updBzloc(Map<String, Object> map) throws Exception;
	int LALM0912_delBzloc(Map<String, Object> map) throws Exception;
	

	int LALM0912_updSealImg(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0912_selSealImg(Map<String, Object> map) throws Exception;
	

}
