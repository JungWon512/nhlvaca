package com.auc.lalm.sy.service;

import java.util.List;
import java.util.Map;

public interface LALM0832Service {

	List<Map<String, Object>> LALM0832_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0832_selBtnList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0832_insPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0832_updPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0832_delPgm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0832_updPgmBtn(Map<String, Object> map) throws Exception;
	

}
