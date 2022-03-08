package com.auc.lalm.ar.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.auc.common.vo.ResolverMap;

public interface LALM0214Service {

	List<Map<String, Object>> LALM0214_selList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0214_selAucQcn(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0214_selCalfList(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0214_selFeeImps(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0214_insFeeReset(Map<String, Object> map) throws Exception;
	
	int LALM0214_selAucTmsCnt(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0214_delSogCow(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0214_delCntnDel(Map<String, Object> map) throws Exception;
	

	List<Map<String, Object>> LALM0214P1_selList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> LALM0214P4_selList(Map<String, Object> map) throws Exception;
	Map<String, Object> LALM0214P2_updCow(List<Map<String, Object>> inList) throws Exception;
	Map<String, Object> LALM0214P4_updCowBun(List<Map<String, Object>> inList) throws Exception;
	

}
