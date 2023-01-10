package com.auc.lalm.bs.service;

import java.util.List;
import java.util.Map;

public interface LALM0111Service {

	List<Map<String, Object>> LALM0111_selList(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0111_insFarm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0111_updFarm(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0111_selFhsAnw(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0111_delFhs(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0111_selDetail(Map<String, Object> map) throws Exception;

}
