package com.auc.lalm.ls.controller;

import java.sql.SQLException;
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
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1004Service lsam0203Service;
	@Autowired
	CommonService commonService;

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selList", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selList(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selFee", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selFee(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selFee(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selStsDsc", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selStsDsc(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selStsDsc(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selGetPpgcowFeeDsc", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selGetPpgcowFeeDsc(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selGetPpgcowFeeDsc(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selPrgSq", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selPrgSq(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selPrgSq(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selMhCalf", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selMhCalf(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selMhCalf(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selOslpNo", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selOslpNo(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		List<Map<String, Object>> selAucPrgSqList = lsam0203Service.LALM1004_selAucPrgSq(map);
		int selAucPrgSq = Integer.parseInt(selAucPrgSqList.get(0).get("C_AUC_PRG_SQ").toString());
		if (selAucPrgSq == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "경매번호가 없습니다.");
		}
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selOslpNo(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selTmpFhsNm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selTmpFhsNm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selMhCalf(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selMacoFee", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selMacoFee(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selMacoFee(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selIndvAmnnoPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selIndvAmnnoPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selIndvAmnnoPgm(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selTmpIndvAmnnoPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selTmpIndvAmnnoPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selTmpIndvAmnnoPgm(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selFhsIdNo", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selFhsIdNo(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selFhsIdNo(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_selTmpAucPrgSq", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selTmpAucPrgSq(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selTmpAucPrgSq(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);

		return reMap;
	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_delPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_delPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);

		List<Map<String, Object>> selAucQcnList = commonService.Common_selAucQcn(map);
		int selAucQcn = Integer.parseInt(selAucQcnList.get(0).get("DDL_YN").toString());
		if (selAucQcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "경매마감 되었습니다.");
		}
		Map<String, Object> inMap = lsam0203Service.LALM1004_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_updAucChange", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_updAucChange(ResolverMap rMap) throws Exception {

		String vAucDt = "";
		String vAucChgDt = "";

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap = (Map<String, Object>) map.get("frm_mhsogcow");

		List<Map<String, Object>> qcnList = commonService.Common_selAucQcn(frmMap);

		if (qcnList.size() == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "경매차수를 먼저 등록하여야 합니다.");
		}

		int qcn = Integer.parseInt(qcnList.get(0).get("DDL_YN").toString());

		if (qcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "경매마감 되었습니다.");
		}

		// 경매일자를 이월일자로 변경
		vAucDt = frmMap.get("auc_dt").toString();
		vAucChgDt = frmMap.get("auc_chg_dt").toString();
		frmMap.put("auc_dt", vAucChgDt);

		List<Map<String, Object>> indvAmnnoList = lsam0203Service.LALM1004_selIndvAmnno(frmMap);

		// 경매일자 원복
		frmMap.put("auc_dt", vAucDt);

		if (indvAmnnoList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "동일한 경매일자에 동일한 귀표번호는 등록할수 없습니다.");
		}

		Map<String, Object> inMap = lsam0203Service.LALM1004_updAucChange(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_insPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_insPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap = (Map<String, Object>) map.get("frm_mhsogcow");

		List<Map<String, Object>> qcnList = lsam0203Service.LALM1004_selAucPrg(frmMap);

		if (qcnList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "중복된 경매번호가 있습니다. 경매번호를 확인 바랍니다.");
		}

		List<Map<String, Object>> indvAmnnoList = lsam0203Service.LALM1004_selIndvAmnno(frmMap);

		if (indvAmnnoList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "동일한 경매일자에 동일한 귀표번호는 등록할수 없습니다.");
		}

		Map<String, Object> inMap = lsam0203Service.LALM1004_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	@ResponseBody
	@RequestMapping(value = "/LALM1004_updPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_updPgm(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap = (Map<String, Object>) map.get("frm_mhsogcow");

		String beforeAucPrgSq = frmMap.get("hd_auc_prg_sq").toString();
		String afterAucPrgSq = frmMap.get("auc_prg_sq").toString();

		if (!beforeAucPrgSq.equals(afterAucPrgSq)) {
			List<Map<String, Object>> qcnList = lsam0203Service.LALM1004_selAucPrg(frmMap);
			if (qcnList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR, "중복된 경매번호가 있습니다. 경매번호를 확인 바랍니다.");
			}
		}

		List<Map<String, Object>> indvAmnnoList = lsam0203Service.LALM1004_selIndvAmnno(frmMap);

		if (indvAmnnoList.size() > 0) {
			if (!frmMap.get("re_indv_no").toString().equals(indvAmnnoList.get(0).get("SRA_INDV_AMNNO").toString())) {
				throw new CusException(ErrorCode.CUSTOM_ERROR, "귀표번호는 수정하실 수 없습니다.");
			}
		}

		Map<String, Object> inMap = lsam0203Service.LALM1004_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);

		return reMap;

	}

	/*
	 * ---------------------------------------------------------- 출장우 이미지 업로드 [s]
	 * ----------------------------------------------------------
	 */
	/**
	 * 경매준비관리 > 출장우 내역등록 > 이미지 탭
	 * 
	 * @param rMap
	 * @return
	 * @throws SQLException
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_selImgList", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_selImgList(ResolverMap rMap) throws Exception {
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lsam0203Service.LALM1004_selImgList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		return reMap;
	}

	/**
	 * 경매준비관리 > 출장우 내역등록 > 이미지 탭 > 출장우 이미지 저장
	 * 
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	// @ResponseBody
	// @RequestMapping(value="/LALM1004_insImgPgm", method=RequestMethod.POST)
	// public Map<String, Object> LALM1004_insImgPgm(ResolverMap rMap) throws
	// Exception{
	// Map<String, Object> map = convertConfig.conMap(rMap);
	// Map<String, Object> inMap = lsam0203Service.LALM1004_insImgPgm(map);
	// Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
	// return reMap;
	// }

	/**
	 * 경매준비관리 > 출장우 내역등록 > 이미지 탭 > 출장우 이미지 저장 (멀티파트)
	 * 
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	// @ResponseBody
	// @RequestMapping(value="/LALM1004_insImgPgm", method=RequestMethod.POST)
	// public Map<String, Object> LALM1004_insImgPgm(MultipartHttpServletRequest
	// request, @RequestParam HashMap<String, Object> params) throws Exception{
	// Map<String, Object> map = new HashMap<>();
	//
	// map.put("na_bzplc", params.get("na_bzplc"));
	// map.put("auc_dt", params.get("auc_dt"));
	// map.put("auc_obj_dsc", params.get("auc_obj_dsc"));
	// map.put("oslp_no", params.get("oslp_no"));
	// map.put("led_sqno", params.get("led_sqno"));
	// map.put("sra_indv_amnno", params.get("sra_indv_amnno"));
	//
	// List<MultipartFile> files = new ArrayList<>();
	//
	// if (!ObjectUtils.isEmpty(request.getFile("file_0"))) {
	// for (int i = 0; i < 8; i++) {
	// if (!ObjectUtils.isEmpty(request.getFile("file_"+i))) {
	// files.add(request.getFile("file_"+i));
	// }
	// }
	// }
	//
	// map.put("files", files);
	//
	// Map<String, Object> inMap = lsam0203Service.LALM1004_insImgPgm(map);
	// Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
	// return reMap;
	// }

	/**
	 * 경매준비관리 > 출장우 내역등록 > 이미지 탭 > 출장우 이미지 삭제
	 * 
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM1004_delImgList", method = RequestMethod.POST)
	public Map<String, Object> LALM1004_delImgList(ResolverMap rMap) throws Exception {

		Map<String, Object> map = convertConfig.conMap(rMap);
		Map<String, Object> tempMap = lsam0203Service.LALM1004_delImgList(map);
		Map<String, Object> reMap = commonFunc.createResultSetMapData(tempMap);

		return reMap;
	}

}
