package com.auc.lalm.ls.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ls.service.LALM1003P3Service;

/**
 * 1. Created by : ycsong
 * 2. Created Date : 2024-02-14
 * 3. Description : 엑셀업로드 REST API Controller
 * 4. History
 * > 2024-02-14 : 최초 생성
 */
@RestController
public class LALM1003P3Controller {

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1003P3Service lsam0202P3Service;

	@ResponseBody
	@RequestMapping(value = "/LALM1003P3_insFhs", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P3Service(ResolverMap rMap) throws Exception {
		// Map<String, Object> map = convertConfig.conMap(rMap);
		// Map<String, Object> inMap = LALM1003P3Service.LALM1003P3_insFhs(map);
		// Map<String, Object> reMap = commonFunc.createResultSetMapData(inMap);
		// return reMap;
		return null;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003P3_insSogCow", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P3_insSogCow(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);

		Map<String, Object> inMap = lsam0202P3Service.LALM1003P3_insSogCow(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/LALM1003P3_selSogCowVaild", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P3_selSogCowVaild(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);

		Map<String, Object> inMap = lsam0202P3Service.LALM1003P3_selSogCowVaild(map);
		Map<String, Object> reMap = commonFunc
				.createResultSetListData((List<Map<String, Object>>) inMap.get("resultList"));

		return reMap;

	}

	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/LALM1003P3_selIndvSync", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P3_selIndvSync(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);

		Map<String, Object> inMap = lsam0202P3Service.LALM1003P3_selIndvSync(map);
		Map<String, Object> reMap = commonFunc
				.createResultSetListData((List<Map<String, Object>>) inMap.get("resultList"));

		return reMap;

	}

}
