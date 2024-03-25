package com.auc.lalm.ar.controller;

import java.util.HashMap;
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
import com.auc.lalm.ar.service.LALM0212Service;
import com.auc.lalm.ar.service.LALM0213Service;
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.mca.McaUtil;

@RestController
public class LALM0213Controller {

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0212Service lalm0212Service;
	@Autowired
	LALM0213Service lalm0213Service;
	@Autowired
	McaUtil mcaUtil;
	@Autowired
	LALM0899Service lalm0899Service;

	@ResponseBody
	@RequestMapping(value = "/LALM0213_selList", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_selList(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0213Service.LALM0213_selList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM0213_selSraList", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_selSraList(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0213Service.LALM0213_selSraList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM0213_selBadTrmn", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_selBadTrmn(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0213Service.LALM0213_selBadTrmn(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM0213_selBadCheck", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_selBadCheck(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0213Service.LALM0213_selBadCheck(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM0213_insPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_insPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		List<Map<String, Object>> aucQcnList = lalm0212Service.LALM0212_selAucQcn(map);

		int aucQcn = Integer.parseInt(aucQcnList.get(0).get("CNT").toString());

		if (aucQcn == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "차수정보가 존재하지 않습니다. 확인하세요 !!");
		}
		Map<String, Object> tmpMap = new HashMap<>();
		tmpMap.putAll(map);
		tmpMap.put("lvst_auc_ptc_mn_no", "");
		List<Map<String, Object>> selTrmnAmnNoList = lalm0213Service.LALM0213_selTrmnAmnNo(tmpMap);

		int selTrmnAmnNo = Integer.parseInt(selTrmnAmnNoList.get(0).get("CNT").toString());

		if (selTrmnAmnNo > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "이미 등록된 중도매인 입니다. 확인하세요.");
		}

		List<Map<String, Object>> selAucPtcMnNoList = lalm0213Service.LALM0213_selAucPtcMnNo(map);

		int selAucPtcMnNo = Integer.parseInt(selAucPtcMnNoList.get(0).get("CNT").toString());

		if (selAucPtcMnNo > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "이미 등록된 참여자번호 입니다. 확인하세요.");
		}

		Map<String, Object> inMap = lalm0213Service.LALM0213_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM0213_updPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_updPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		List<Map<String, Object>> aucQcnList = lalm0212Service.LALM0212_selAucQcn(map);

		int aucQcn = Integer.parseInt(aucQcnList.get(0).get("CNT").toString());

		if (aucQcn == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "차수정보가 존재하지 않습니다. 확인하세요 !!");
		}

		List<Map<String, Object>> selTrmnAmnNoList = lalm0213Service.LALM0213_selTrmnAmnNo(map);

		int selTrmnAmnNo = Integer.parseInt(selTrmnAmnNoList.get(0).get("CNT").toString());

		if (selTrmnAmnNo > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "이미 등록된 중도매인 입니다. 확인하세요.");
		}
		Map<String, Object> inMap = lalm0213Service.LALM0213_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM0213_delPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_delPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> SraCount = lalm0213Service.LALM0213_selSraCount(map);

		int qcn = Integer.parseInt(SraCount.get(0).get("CNT").toString());

		if (qcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "낙찰내역이 있는 중도매인은 삭제하실 수 없습니다.");
		}

		Map<String, Object> inMap = lalm0213Service.LALM0213_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM0213_selSmSSend", method = RequestMethod.POST)
	public Map<String, Object> LALM0213_selSmSSend(ResolverMap rMap) throws Exception {
		Map<String, Object> map = convertConfig.conMap(rMap);

		Map<String, Object> mcaMap = null;
		Map<String, Object> reMap = null;

		mcaMap = mcaUtil.tradeMcaMsg((String) map.get("ctgrm_cd"), map);

		reMap = commonFunc.createResultSetMapData(mcaMap);
		return reMap;
	}

}
