package com.auc.lalm.co.service;

import java.util.Map;

public interface LALM0912Service {

	Map<String, Object> LALM0912_selData(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0912_insWmc(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0912_updWmc(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0912_delWmc(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM0912_updSealImg(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0912_selSealImg(Map<String, Object> map) throws Exception;

}
