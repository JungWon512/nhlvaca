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
import com.auc.lalm.ls.service.LALM1004Service;
import com.auc.main.service.CommonService;

/**
 * 1. Created by : ycsong
 * 2. Created Date : 2024-02-14
 * 3. Description : 출장내역 등록 REST API Controller
 * 4. History
 * > 2024-02-14 : 최초 생성
 */
@RestController
@SuppressWarnings("unchecked")
public class LALM1004Controller {

	@Autowired
	private ConvertConfig convertConfig;
	@Autowired
	private CommonFunc commonFunc;
	@Autowired
	private LALM1004Service lalm1004Service;
	@Autowired
	private CommonService commonService;

	/**
	 * 출장내역 정보 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_selList", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selList(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1004Service.LALM1004_selList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	/**
	 * 수수료 정보 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_selFee", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selFee(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1004Service.LALM1004_selFee(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	/**
	 * 경매내역 저장 전 상태 변경 여부 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_selStsDsc", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selStsDsc(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1004Service.LALM1004_selStsDsc(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	/**
	 * 경매내역 저장
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_insPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_insPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap = (Map<String, Object>) map.get("frm_mhsogcow");

		List<Map<String, Object>> qcnList = lalm1004Service.LALM1004_selAucPrg(frmMap);

		if (qcnList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "중복된 경매번호가 있습니다. 경매번호를 확인 바랍니다.");
		}

		List<Map<String, Object>> indvAmnnoList = lalm1004Service.LALM1004_selIndvAmnno(frmMap);

		if (indvAmnnoList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "동일한 경매일자에 동일한 개체번호는 등록할수 없습니다.");
		}

		Map<String, Object> inMap = lalm1004Service.LALM1004_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	/**
	 * 경매내역 수정
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_updPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_updPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap = (Map<String, Object>) map.get("frm_mhsogcow");

		String beforeAucPrgSq = frmMap.getOrDefault("hd_auc_prg_sq", "").toString();
		String afterAucPrgSq = frmMap.getOrDefault("auc_prg_sq", "").toString();

		if (!beforeAucPrgSq.equals(afterAucPrgSq)) {
			List<Map<String, Object>> qcnList = lalm1004Service.LALM1004_selAucPrg(frmMap);
			if (qcnList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR, "중복된 경매번호가 있습니다. 경매번호를 확인 바랍니다.");
			}
		}

		List<Map<String, Object>> indvAmnnoList = lalm1004Service.LALM1004_selIndvAmnno(frmMap);

		if (indvAmnnoList.size() > 0) {
			if (!frmMap.get("re_indv_no").toString().equals(indvAmnnoList.get(0).get("SRA_INDV_AMNNO").toString())) {
				throw new CusException(ErrorCode.CUSTOM_ERROR, "개체번호는 수정하실 수 없습니다.");
			}
		}

		Map<String, Object> inMap = lalm1004Service.LALM1004_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	/**
	 * 경매내역 삭제
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_delPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_delPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		List<Map<String, Object>> selAucQcnList = commonService.Common_selAucQcn(map);
		int selAucQcn = Integer.parseInt(selAucQcnList.get(0).get("DDL_YN").toString());
		if (selAucQcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "경매마감 되었습니다.");
		}
		Map<String, Object> inMap = lalm1004Service.LALM1004_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;

	}

}
