package com.auc.lalm.ls.service.Impl;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.config.ConvertConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.ls.service.LALM1003P3Service;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;

@Service
public class LALM1003P3ServiceImpl implements LALM1003P3Service {
	private static Logger log = LoggerFactory.getLogger(LALM1003P3ServiceImpl.class);
	@Autowired
	LogService logService;
	@Autowired
	LALM1003P3Mapper lsam0202P3Mapper;

	@Autowired
	LALM1004Mapper lsam0203Mapper;

	@Autowired
	CommonService commonService;
	@Autowired
	ConvertConfig convertConfig;

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> LALM1003P3_insFhs(Map<String, Object> params) throws Exception {
		List<Map<String, Object>> reList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> inList = (List<Map<String, Object>>) params.get("excellist");

		for (Map<String, Object> map : inList) {
			List<Map<String, Object>> fhsList = lsam0202P3Mapper.LALM1003P3_selFhs(map);
			if (fhsList == null || fhsList.size() == 0) {
				// 농가 인터페이스
			} else if (fhsList.size() > 1) {
				map.put("ftsnm", "중복농가");
				map.put("fhs_id_no", "");
				map.put("farm_amnno", "");
			} else {
				map.put("ftsnm", fhsList.get(0).get("FTSNM"));
				map.put("fhs_id_no", fhsList.get(0).get("FHS_ID_NO"));
				map.put("farm_amnno", fhsList.get(0).get("FARM_AMNNO"));
			}
			reList.add(map);
		}

		return reList;

	}

	// @SuppressWarnings("unchecked")
	// @Override
	// public Map<String, Object> LALM1003P3_insFhs(Map<String, Object> params)
	// throws Exception{
	// Map<String, Object> reMap = new HashMap<String, Object>();
	// int insertNum = LALM1003P3Mapper.LALM1003P3_insFhs(params);
	// reMap.put("insertNum", insertNum);
	// return reMap;
	//
	// }

	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM1003P3_insSogCow(Map<String, Object> inMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");

		int insertNum = 0;
		int updateNum = 0;
		int errCnt = 0;
		StringBuilder sb = new StringBuilder();
		for (Map<String, Object> map : list) {
			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("auc_dt", inMap.get("auc_dt"));
			map.put("auc_obj_dsc", inMap.get("auc_obj_dsc"));

			map.put("re_indv_no", map.get("sra_indv_amnno"));
			List<Map<String, Object>> aucPrgList = lsam0203Mapper.LALM1004_selAucPrg(map);
			if (aucPrgList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,
						"중복된 경매번호(" + map.get("auc_prg_sq") + ")가 있습니다. 경매번호를 확인 바랍니다.");
			}
			// 귀표번호 체크
			List<Map<String, Object>> indvAmnnoList = lsam0203Mapper.LALM1004_selIndvAmnno(map);
			if (indvAmnnoList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,
						"동일한 경매일자에 동일한 귀표번호(" + map.get("sra_indv_amnno") + ")는 등록할수 없습니다.");
			}
			list = lsam0203Mapper.LALM1004_selVoslpNo(inMap);
			map.put("oslp_no", list.get(0).get("V_OSLP_NO").toString());
			map.put("modl_no", map.get("auc_prg_sq"));

			map.put("rc_dt", inMap.get("rc_dt"));
			// map.put("sog_na_trpl_c", "");
			map.put("vhc_shrt_c", "");
			map.put("trmn_amnno", "");
			map.put("lvst_auc_ptc_mn_no", "");
			String sraPdRgnnm = splitByte((String) map.get("sra_pd_rgnnm"), 50);
			map.put("sra_pd_rgnnm", sraPdRgnnm);
			insertNum += lsam0202P3Mapper.LALM1003P3_insSogCow(map);

			map.put("chg_pgid", "LALM1003P3");
			map.put("chg_rmk_cntn", "출장우 일괄등록");
			insertNum += logService.insSogCowLog(map);
		}

		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		reMap.put("errCnt", errCnt);
		reMap.put("message", sb.toString());

		return reMap;
	}

	@SuppressWarnings({ "unused", "unchecked" })
	@Override
	public Map<String, Object> LALM1003P3_selIndvSync(Map<String, Object> inMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");
		List<Map<String, Object>> reList = new ArrayList<>();

		int insertNum = 0;
		int updateNum = 0;

		for (Map<String, Object> map : list) {
			Map<String, Object> result = new HashMap<String, Object>();
			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("hid_sra_indv_amnno_c", "3");
			map.put("sra_indv_amnno", map.get("sra_indv_amnno"));

			result.put("AUC_OBJ_DSC", map.get("auc_obj_dsc"));
			result.put("AUC_PRG_SQ", map.get("auc_prg_sq"));
			result.put("AUC_OBJ_DSC", map.get("auc_obj_dsc"));
			result.put("TRPCS_PY_YN", map.get("trpcs_py_yn"));
			result.put("SRA_TRPCS", map.get("sra_trpcs"));
			result.put("SRA_PYIVA", map.get("sra_pyiva"));
			result.put("SRA_FED_SPY_AM", map.get("sra_fed_spy_am"));
			result.put("TD_RC_CST", map.get("td_rc_cst"));
			result.put("RMHN_YN", map.get("rmhn_yn"));
			result.put("MT12_OVR_YN", map.get("mt12_ovr_yn"));
			result.put("MT12_OVR_FEE", map.get("mt12_ovr_fee"));
			result.put("PPGCOW_FEE_DSC", map.get("ppgcow_fee_dsc"));
			result.put("AFISM_MOD_DT", map.get("afism_mod_dt"));
			result.put("AFISM_MOD_CTFW_SMT_YN", map.get("afism_mod_ctfw_smt_yn"));
			result.put("MOD_KPN", map.get("mod_kpn"));
			result.put("PRNY_MTCN", map.get("prny_mtcn"));
			result.put("PRNY_JUG_YN", map.get("prny_jug_yn"));
			result.put("PRNY_YN", map.get("prny_yn"));
			result.put("NCSS_JUG_YN", map.get("ncss_jug_yn"));
			result.put("NCSS_YN", map.get("ncss_yn"));
			result.put("RMK_CNTN", map.get("rmk_cntn"));
			result.put("DNA_YN_CHK", map.get("dna_yn_chk"));
			result.put("DNA_YN", map.get("dna_yn"));
			result.put("SRA_INDV_AMNNO", map.get("sra_indv_amnno"));
			result.put("FTSNM", map.get("ftsnm"));

			result.put("CHK_INF_ERR", "0");
			result.put("CHK_VAILD_ERR", "0");
			result.put("CHK_ERR_SRA_INDV_AMNNO", "0");
			result.put("CHK_ERR_AUC_PRG_SQ", "0");
			reList.add(result);
		}

		reMap.put("resultList", reList);
		return reMap;
	}

	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM1003P3_selSogCowVaild(Map<String, Object> inMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");

		int errCnt = 0;
		StringBuilder sb = new StringBuilder();
		List<Map<String, Object>> reList = new ArrayList<Map<String, Object>>();

		for (Map<String, Object> map : list) {
			Map<String, Object> temp = convertConfig.changeKeyUpper(map);
			temp.put("CHK_VAILD_ERR", "0");
			temp.put("CHK_ERR_SRA_INDV_AMNNO", "0");
			temp.put("CHK_ERR_AUC_PRG_SQ", "0");

			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("auc_dt", inMap.get("auc_dt"));
			map.put("auc_obj_dsc", inMap.get("auc_obj_dsc"));
			map.put("re_indv_no", map.get("sra_indv_amnno"));
			if (map.get("sra_indv_amnno") != null && map.get("sra_indv_amnno").toString().length() <= 14) {
				sb.append("<br/>귀표번호(" + map.get("sra_indv_amnno") + ") 자릿수를 확인 바랍니다.");
				errCnt++;
				temp.put("CHK_VAILD_ERR", "1");
				temp.put("CHK_ERR_SRA_INDV_AMNNO", "1");
				// throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된
				// 경매번호("+map.get("auc_prg_sq")+")가 있습니다. 경매번호를 확인 바랍니다.");
			}

			List<Map<String, Object>> aucPrgList = lsam0203Mapper.LALM1004_selAucPrg(map);
			if (aucPrgList.size() > 0) {
				sb.append("<br/>중복된 경매번호(" + map.get("auc_prg_sq") + ")가 있습니다. 경매번호를 확인 바랍니다.");
				errCnt++;
				temp.put("CHK_VAILD_ERR", "1");
				temp.put("CHK_ERR_AUC_PRG_SQ", "1");
				// throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된
				// 경매번호("+map.get("auc_prg_sq")+")가 있습니다. 경매번호를 확인 바랍니다.");
			}
			// 귀표번호 체크
			List<Map<String, Object>> indvAmnnoList = lsam0203Mapper.LALM1004_selIndvAmnno(map);
			if (indvAmnnoList.size() > 0) {
				sb.append("<br/>동일한 경매일자에 동일한 귀표번호(" + map.get("sra_indv_amnno") + ")는 등록할수 없습니다.");
				errCnt++;
				temp.put("CHK_VAILD_ERR", "1");
				temp.put("CHK_ERR_SRA_INDV_AMNNO", "1");
				// throw new CusException(ErrorCode.CUSTOM_ERROR,"동일한 경매일자에 동일한
				// 귀표번호("+map.get("sra_indv_amnno")+")는 등록할수 없습니다.");
			}

			reList.add(temp);
		}

		reMap.put("errCnt", errCnt);
		reMap.put("message", sb.toString());
		reMap.put("resultList", reList);

		return reMap;
	}

	public String splitByte(String inputString, int length) {
		if (inputString == null) {
			inputString = "";
		}
		StringBuilder sb = new StringBuilder();

		try {
			byte[] inputByte = inputString.getBytes("EUC-KR");
			int byteLen = inputByte.length;
			if (byteLen <= length) {
				return inputString;
			} else if (byteLen > length) {
				StringBuilder stringBuilder = new StringBuilder(length);
				int nCnt = 0;
				for (char ch : inputString.toCharArray()) {
					nCnt += String.valueOf(ch).getBytes("EUC-KR").length;
					if (nCnt > length)
						break;
					stringBuilder.append(ch);
				}
				return stringBuilder.toString();
			}
		} catch (UnsupportedEncodingException e) {
			log.error("splitByte");
			return inputString;
		}
		return sb.toString();
	}
}
