package com.auc.lalm.ls.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ls.service.LALM1002Service;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * 1. Created by : ycsong
 * 2. Created Date : 2024-02-14
 * 3. Description : 수수료 조회 REST API Controller
 * 4. History
 * > 2024-02-14 : 최초 생성
 */
@RestController
public class LALM1002Controller {

	@Autowired
	private ConvertConfig convertConfig;

	@Autowired
	private CommonFunc commonFunc;

	@Autowired
	private LALM1002Service lalm1002Service;

	@PostMapping(value = "/LALM1002_selList")
	public Map<String, Object> LALM1002_selList(ResolverMap rMap) throws Exception {
		final Map<String, Object> map = convertConfig.conMap(rMap);
		final List<Map<String, Object>> reList = lalm1002Service.LALM1002_selList(map);
		final Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		return reMap;
	}

	@PostMapping(value = "/LALM1002_selDetail")
	public Map<String, Object> LALM1002_selDetail(ResolverMap rMap) throws Exception {
		Map<String, Object> map = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm1002Service.LALM1002_selDetail(map);
		Map<String, Object> reMap = commonFunc.createResultSetMapData(selMap);
		return reMap;
	}

	@PostMapping(value = "/LALM1002_insFee")
	public Map<String, Object> LALM1002_insFee(ResolverMap rMap) throws Exception {
		final Map<String, Object> map = convertConfig.conMap(rMap);
		final Map<String, Object> inMap = lalm1002Service.LALM1002_insFee(map);
		final Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;
	}

	@PostMapping(value = "/LALM1002_updFee")
	public Map<String, Object> LALM1002_updFee(ResolverMap rMap) throws Exception {
		final Map<String, Object> map = convertConfig.conMap(rMap);
		final Map<String, Object> inMap = lalm1002Service.LALM1002_updFee(map);
		final Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;
	}

	@PostMapping(value = "/LALM1002_delFee")
	public Map<String, Object> LALM1002_delFee(ResolverMap rMap) throws Exception {
		final Map<String, Object> map = convertConfig.conMap(rMap);
		final Map<String, Object> inMap = lalm1002Service.LALM1002_delFee(map);
		final Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;
	}

}
