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
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ls.service.LALM1003Service;

/**
 * 1. Created by : ycsong
 * 2. Created Date : 2024-02-14
 * 3. Description : 출장내역조회 REST API Controller
 * 4. History
 * > 2024-02-14 : 최초 생성
 */
@RestController
public class LALM1003Controller {

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1003Service lsam0202Service;

	@ResponseBody
	@RequestMapping(value = "/LALM1003_selList", method = RequestMethod.POST)
	public Map<String, Object> LALM1003_selList(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		List<Map<String, Object>> aucQcnList = lsam0202Service.LALM1003_selAucQcn(map);

		if (aucQcnList.size() < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "경매차수가 등록되지 않았습니다.");
		}

		// xml 조회
		List<Map<String, Object>> reList = lsam0202Service.LALM1003_selList(map);

		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003_selCalfList", method = RequestMethod.POST)
	public Map<String, Object> LALM1003_selCalfList(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		// xml 조회
		List<Map<String, Object>> reList = lsam0202Service.LALM1003_selCalfList(map);

		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003_insFeeReset", method = RequestMethod.POST)
	public Map<String, Object> LALM1003_insFeeReset(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		Map<String, Object> inMap = lsam0202Service.LALM1003_insFeeReset(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003_selFeeImps", method = RequestMethod.POST)
	public Map<String, Object> LALM1003_selFeeImps(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		// xml 조회
		Map<String, Object> result = lsam0202Service.LALM1003_selFeeImps(map);

		Map<String, Object> reMap = commonFunc.createResultSetMapData(result);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003_delSogCow", method = RequestMethod.POST)
	public Map<String, Object> LALM1003_delSogCow(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		// xml 조회
		int aucTmsCnt = lsam0202Service.LALM1003_selAucTmsCnt(map);

		if (aucTmsCnt > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "경매낙찰된 출장우 또는 경매전송된 출장우가 있는 경우는<br>전체삭제가 불가합니다.");
		}

		Map<String, Object> inMap = lsam0202Service.LALM1003_delSogCow(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003_delCntnDel", method = RequestMethod.POST)
	public Map<String, Object> LALM1003_delCntnDel(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		Map<String, Object> inMap = lsam0202Service.LALM1003_delCntnDel(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003P1_selList", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P1_selList(ResolverMap rMap) throws Exception {
		Map<String, Object> map = convertConfig.conMap(rMap);

		// xml 조회
		List<Map<String, Object>> reList = lsam0202Service.LALM1003P1_selList(map);

		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003P4_selList", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P4_selList(ResolverMap rMap) throws Exception {
		Map<String, Object> map = convertConfig.conMap(rMap);

		// xml 조회
		List<Map<String, Object>> reList = lsam0202Service.LALM1003P4_selList(map);

		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003P2_updCow", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P2_updCow(ResolverMap rMap) throws Exception {

		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lsam0202Service.LALM1003P2_updCow(inList);

		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM1003P4_updCowBun", method = RequestMethod.POST)
	public Map<String, Object> LALM1003P4_updCowBun(ResolverMap rMap) throws Exception {

		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lsam0202Service.LALM1003P4_updCowBun(inList);

		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

}
