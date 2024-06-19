package com.auc.lalm.ls.service;

import java.util.Map;

public interface LALM1003P1Service {

	/**
	 * 기타 가축정보 저장
	 * @param map
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> LALM1003P1_insEtc(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1003P1_selEtcVaild(Map<String, Object> map) throws Exception;

}
