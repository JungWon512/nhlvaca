package com.auc.lalm.ls.service.Impl;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
	LALM1003P3Mapper lalm1003p3Mapper;

	@Autowired
	LALM1004Mapper lalm1004Mapper;

	@Autowired
	CommonService commonService;
	@Autowired
	ConvertConfig convertConfig;

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
			List<Map<String, Object>> aucPrgList = lalm1004Mapper.LALM1004_selAucPrg(map);
			if (aucPrgList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,
						"중복된 경매번호(" + map.get("auc_prg_sq") + ")가 있습니다. 경매번호를 확인 바랍니다.");
			}
			// 귀표번호 체크
			List<Map<String, Object>> indvAmnnoList = lalm1004Mapper.LALM1004_selIndvAmnno(map);
			if (indvAmnnoList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,
						"동일한 경매일자에 동일한 귀표번호(" + map.get("sra_indv_amnno") + ")는 등록할수 없습니다.");
			}
			list = lalm1004Mapper.LALM1004_selVoslpNo(inMap);
			map.put("oslp_no", list.get(0).get("V_OSLP_NO").toString());
			map.put("modl_no", map.get("auc_prg_sq"));

			map.put("rc_dt", inMap.get("rc_dt"));
			// map.put("sog_na_trpl_c", "");
			map.put("vhc_shrt_c", "");
			map.put("trmn_amnno", "");
			map.put("lvst_auc_ptc_mn_no", "");
			String sraPdRgnnm = splitByte((String) map.get("sra_pd_rgnnm"), 50);
			map.put("sra_pd_rgnnm", sraPdRgnnm);
			// insertNum += lsam0202P3Mapper.LALM1003P3_insSogCow(map);

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

	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM1003P3_insEtc(Map<String, Object> inMap) throws Exception {
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

			List<Map<String, Object>> aucPrgList = lalm1004Mapper.LALM1004_selAucPrg(map);
			if (aucPrgList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,
						"중복된 경매번호(" + map.get("auc_prg_sq") + ")가 있습니다. 경매번호를 확인 바랍니다.");
			}

			list = lalm1004Mapper.LALM1004_selVoslpNo(inMap);
			map.put("oslp_no", list.get(0).get("V_OSLP_NO").toString());
			map.put("modl_no", map.get("auc_prg_sq"));

			map.put("rc_dt", inMap.get("rc_dt"));
			map.put("vhc_shrt_c", "");
			map.put("trmn_amnno", "");
			map.put("lvst_auc_ptc_mn_no", "");
			String sraPdRgnnm = splitByte((String) map.get("sra_pd_rgnnm"), 50);
			map.put("sra_pd_rgnnm", sraPdRgnnm);
			insertNum += lalm1003p3Mapper.LALM1003P3_insEtc(map);

			map.put("chg_pgid", "LALM1003P3");
			map.put("chg_rmk_cntn", "출장내역 일괄등록");
			insertNum += logService.insSogCowLog(map);

			insertNum += lalm1003p3Mapper.LALM1003P3_insIndv(map);

			map.put("chg_pgid", "LALM1003P3");
			map.put("chg_rmk_cntn", "출장내역 일괄등록");
			insertNum += logService.insMmIndvLog(map);
		}

		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		reMap.put("errCnt", errCnt);
		reMap.put("message", sb.toString());

		return reMap;
	}

	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM1003P3_selEtcVaild(Map<String, Object> inMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");

		List<Map<String, Object>> reList = new ArrayList<Map<String, Object>>();

		for (Map<String, Object> map : list) {
			int errCnt = 0;
			Map<String, Object> temp = convertConfig.changeKeyUpper(map);
			temp.put("CHK_VAILD_ERR", "0");
			temp.put("CHK_ERR_SRA_INDV_AMNNO", "0");
			temp.put("CHK_ERR_AUC_PRG_SQ", "0");

			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("auc_dt", inMap.get("auc_dt"));
			map.put("auc_obj_dsc", inMap.get("auc_obj_dsc"));
			map.put("re_indv_no", map.get("sra_indv_amnno"));

			List<Map<String, Object>> aucPrgList = lalm1004Mapper.LALM1004_selAucPrg(map);
			int checkListSize = list.stream()
									.filter(x -> x.get("auc_prg_sq").equals(map.get("auc_prg_sq")))
									.collect(Collectors.toList()).size();
			if (aucPrgList.size() > 0) {
				errCnt++;
				temp.put("CHK_ERR_AUC_PRG_SQ", "1");
			} else if (checkListSize > 1) {
				errCnt++;
				temp.put("CHK_ERR_AUC_PRG_SQ", "1");
			} else {
				temp.put("CHK_ERR_AUC_PRG_SQ", "0");
			}

			Map<String, Object> fhs = lalm1004Mapper.LALM1004_selFtsnm(map);
			if (fhs == null || fhs.isEmpty()) {
				errCnt++;
				temp.put("CHK_ERR_FHS_ID_NO", "1");
			} else {
				temp.put("FHS_ID_NO", fhs.get("FHS_ID_NO"));
				temp.put("FARM_AMNNO", fhs.get("FARM_AMNNO"));
			}

			if (errCnt > 0) temp.put("CHK_VAILD_ERR", "1");
			else temp.put("CHK_VAILD_ERR", "0");

			reList.add(temp);
		}

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
