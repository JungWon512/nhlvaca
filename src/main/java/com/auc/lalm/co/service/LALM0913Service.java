package com.auc.lalm.co.service;

import java.util.List;
import java.util.Map;

public interface LALM0913Service {

	List<Map<String, Object>> LALM0913_selList(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0913_selUser(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0913_insUser(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0913_updUser(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0913_delUser(Map<String, Object> map) throws Exception;

}
