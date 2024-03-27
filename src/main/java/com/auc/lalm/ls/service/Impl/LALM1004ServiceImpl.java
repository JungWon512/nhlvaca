package com.auc.lalm.ls.service.Impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.SdkClientException;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.AccessControlList;
import com.amazonaws.services.s3.model.AmazonS3Exception;
import com.amazonaws.services.s3.model.BucketCrossOriginConfiguration;
import com.amazonaws.services.s3.model.CORSRule;
import com.amazonaws.services.s3.model.GroupGrantee;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.Permission;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.util.Base64;
import com.auc.common.util.StringUtils;
import com.auc.lalm.ls.service.LALM1004Service;
import com.auc.main.service.LogService;
import com.auc.main.service.Impl.LogMapper;

@Service
@SuppressWarnings({ "unused", "unchecked" })
public class LALM1004ServiceImpl implements LALM1004Service {
	private static Logger log = LoggerFactory.getLogger(LALM1004ServiceImpl.class);

	@Autowired
	LALM1004Mapper lalm1004Mapper;

	@Autowired
	LogService logService;

	@Autowired
	LogMapper logMapper;

	@Override
	public List<Map<String, Object>> LALM1004_selList(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selList(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selIndvAmnnoPgm(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selIndvAmnnoPgm(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selStsDsc(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selStsDsc(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selTmpIndvAmnnoPgm(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selFhsIdNo(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selFhsIdNo(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selGetPpgcowFeeDsc(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selFee(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selFee(map);
		return list;

	}

	@Override
	public Map<String, Object> LALM1004_delPgm(Map<String, Object> map) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();

		int deleteNum = 0;

		deleteNum = deleteNum + logService.insSogCowLog(map);
		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delSogCow(map);
		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delFeeImps(map);
		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delMhCalf(map);
		reMap.put("deleteNum", deleteNum);

		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM1004_selIndvAmnno(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selIndvAmnno(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selPrgSq(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selPrgSq(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selMhCalf(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selMhCalf(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selTmpFhsNm(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selTmpFhsNm(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selMacoFee(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selMacoFee(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selAucPrgSq(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selAucPrgSq(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selOslpNo(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selOslpNo(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selTmpAucPrgSq(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> listTmpAucPrgSq = null;
		List<Map<String, Object>> list = null;
		String tmpAucPrgSqNO = "";

		listTmpAucPrgSq = lalm1004Mapper.LALM1004_selTmpAucObjDsc(map);
		tmpAucPrgSqNO = listTmpAucPrgSq.get(0).get("AUC_OBJ_DSC").toString();

		if (!("0").equals(tmpAucPrgSqNO)) {
			list = lalm1004Mapper.LALM1004_selTmpAucPrgSq(map);
		}

		return list;

	}

	@Override
	public Map<String, Object> LALM1004_updAucChange(Map<String, Object> frmMap) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map = (Map<String, Object>) frmMap.get("frm_mhsogcow");

		List<Map<String, Object>> list = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>) frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>) frmMap.get("grd_mhfee");

		int insertNum = 0;
		int updateNum = 0;
		int deleteNum = 0;
		int aucObjDscCnt = 0;

		String vOslpNO = "";
		String vAucDt = "";
		String tmpOslpno = "";
		String vAucChgDt = "";

		// 경매일자를 이월일자로 변경
		vAucDt = map.get("auc_dt").toString();
		vAucChgDt = map.get("auc_chg_dt").toString();
		tmpOslpno = map.get("oslp_no").toString();
		map.put("auc_chg_dt", vAucChgDt);
		map.put("auc_dt", vAucChgDt);

		// 원표번호 셋팅
		list = lalm1004Mapper.LALM1004_selChgVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);

		insertNum = insertNum + lalm1004Mapper.LALM1004_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);

		// kpn번호 update
		updateNum = updateNum + lalm1004Mapper.LALM1004_updIndvSet(map);

		if (selFeemapList.size() > 0) {
			for (int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", map.get("auc_dt"));
				tmpMap.put("v_oslp_no", vOslpNO);
				tmpMap.put("fee_rg_sqno", selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", selFeemapList.get(i).get("sra_tr_fee"));

				insertNum = insertNum + lalm1004Mapper.LALM1004_insMhFeeImps(tmpMap);
			}
		}

		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());

		if (aucObjDscCnt == 3 && ("3".equals(map.get("ppgcow_fee_dsc")) || "4".equals(map.get("ppgcow_fee_dsc")))) {
			for (int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
				tmpMap.put("ss_userid", map.get("ss_userid"));
				tmpMap.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", map.get("auc_dt"));
				tmpMap.put("v_oslp_no", vOslpNO);
				tmpMap.put("v_rg_sqno", tmpi + 1);
				tmpMap.put("sra_srs_dsc", calfList.get(tmpi).get("sra_srs_dsc"));
				tmpMap.put("sra_indv_amnno", calfList.get(tmpi).get("sra_indv_amnno"));
				tmpMap.put("indv_sex_c", calfList.get(tmpi).get("indv_sex_c"));
				tmpMap.put("cow_sog_wt", calfList.get(tmpi).get("cow_sog_wt"));
				tmpMap.put("birth", calfList.get(tmpi).get("birth"));
				tmpMap.put("kpn_no", calfList.get(tmpi).get("kpn_no"));
				tmpMap.put("del_yn", 0);
				tmpMap.put("tms_yn", 0);

				insertNum = insertNum + lalm1004Mapper.LALM1004_insMhCalf(tmpMap);
			}
		}

		// 경매일자, 원표번호 복구
		map.put("auc_dt", vAucDt);
		map.put("oslp_no", tmpOslpno);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delSogCow(map);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delFeeImps(map);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delMhCalf(map);

		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);

		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM1004_selAucPrg(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1004Mapper.LALM1004_selAucPrg(map);
		return list;

	}

	@Override
	public Map<String, Object> LALM1004_insPgm(Map<String, Object> frmMap) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map = (Map<String, Object>) frmMap.get("frm_mhsogcow");

		List<Map<String, Object>> list = null;
		List<Map<String, Object>> amnnolist = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>) frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>) frmMap.get("grd_mhfee");

		int insertNum = 0;
		int updateNum = 0;
		int aucObjDscCnt = 0;

		String vOslpNO = "";

		// 원표번호 셋팅
		list = lalm1004Mapper.LALM1004_selVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);
		map.put("modl_no", map.get("auc_prg_sq"));

		insertNum = insertNum + lalm1004Mapper.LALM1004_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);

		amnnolist = lalm1004Mapper.LALM1004_selAmnno(map);
		if (amnnolist.size() > 0) {
			updateNum = updateNum + lalm1004Mapper.LALM1004_updMnIndv(map);
			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			insertNum = insertNum + lalm1004Mapper.LALM1004_insMmIndv(map);
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");
			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}

		updateNum = updateNum + lalm1004Mapper.LALM1004_updMmFhs(map);
		if (selFeemapList.size() > 0) {
			for (int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", map.get("auc_dt"));
				tmpMap.put("v_oslp_no", vOslpNO);
				tmpMap.put("fee_rg_sqno", selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", selFeemapList.get(i).get("sra_tr_fee"));
				insertNum = insertNum + lalm1004Mapper.LALM1004_insMhFeeImps(tmpMap);
			}
		}

		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());

		if (aucObjDscCnt == 3 && ("3".equals(map.get("ppgcow_fee_dsc")) || "4".equals(map.get("ppgcow_fee_dsc")))) {
			for (int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				tmpMap = new HashMap<String, Object>();

				tmpMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
				tmpMap.put("ss_userid", map.get("ss_userid"));
				tmpMap.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", map.get("auc_dt"));
				tmpMap.put("v_oslp_no", vOslpNO);
				tmpMap.put("v_rg_sqno", tmpi + 1);
				tmpMap.put("sra_srs_dsc", calfList.get(tmpi).get("sra_srs_dsc"));
				tmpMap.put("sra_indv_amnno", calfList.get(tmpi).get("sra_indv_amnno"));
				tmpMap.put("indv_sex_c", calfList.get(tmpi).get("indv_sex_c"));
				tmpMap.put("cow_sog_wt", calfList.get(tmpi).get("cow_sog_wt"));
				tmpMap.put("birth", calfList.get(tmpi).get("birth"));
				tmpMap.put("kpn_no", calfList.get(tmpi).get("kpn_no"));
				tmpMap.put("del_yn", 0);
				tmpMap.put("tms_yn", 0);

				insertNum = insertNum + lalm1004Mapper.LALM1004_insMhCalf(tmpMap);
			}
		}

		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		reMap.put("rtnData", vOslpNO);

		return reMap;
	}

	@Override
	public Map<String, Object> LALM1004_updPgm(Map<String, Object> frmMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map = (Map<String, Object>) frmMap.get("frm_mhsogcow");

		List<Map<String, Object>> list = null;
		List<Map<String, Object>> amnnolist = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>) frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>) frmMap.get("grd_mhfee");

		int insertNum = 0;
		int deleteNum = 0;
		int updateNum = 0;
		int aucObjDscCnt = 0;

		String beforeAucPrgSq = map.get("hd_auc_prg_sq").toString();
		String afterAucPrgSq = map.get("auc_prg_sq").toString();

		if (!beforeAucPrgSq.equals(afterAucPrgSq)) {
			map.put("modl_no", map.get("auc_prg_sq"));
		}

		Map<String, Object> cowInfo = lalm1004Mapper.LALM1004_selSogCow(map);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delSogCow(map);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delFeeImps(map);

		deleteNum = deleteNum + lalm1004Mapper.LALM1004_delMhCalf(map);
		if (cowInfo != null) {
			map.put("auc_yn", cowInfo.get("AUC_YN"));
		}

		insertNum = insertNum + lalm1004Mapper.LALM1004_insSogCow(map);

		insertNum = insertNum + logService.insSogCowLog(map);

		amnnolist = lalm1004Mapper.LALM1004_selAmnno(map);

		if (amnnolist.size() > 0) {
			updateNum = updateNum + lalm1004Mapper.LALM1004_updMnIndv(map);
			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");

			insertNum = insertNum + lalm1004Mapper.LALM1004_insMmIndv(map);

			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}

		updateNum = updateNum + lalm1004Mapper.LALM1004_updMmFhs(map);

		if (selFeemapList.size() > 0) {
			for (int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", map.get("auc_dt"));
				tmpMap.put("v_oslp_no", map.get("oslp_no"));
				tmpMap.put("fee_rg_sqno", selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", selFeemapList.get(i).get("sra_tr_fee"));

				insertNum = insertNum + lalm1004Mapper.LALM1004_insMhFeeImps(tmpMap);
			}
		}

		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());

		if (aucObjDscCnt == 3 && ("3".equals(map.get("ppgcow_fee_dsc")) || "4".equals(map.get("ppgcow_fee_dsc")))) {
			for (int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				if (!calfList.get(tmpi).get("_status_").equals("-")) {
					tmpMap = new HashMap<String, Object>();
					tmpMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
					tmpMap.put("ss_userid", map.get("ss_userid"));
					tmpMap.put("auc_obj_dsc", map.get("auc_obj_dsc"));
					tmpMap.put("auc_dt", map.get("auc_dt"));
					tmpMap.put("v_oslp_no", map.get("oslp_no"));
					tmpMap.put("v_rg_sqno", tmpi + 1);
					tmpMap.put("sra_srs_dsc", calfList.get(tmpi).get("sra_srs_dsc"));
					tmpMap.put("sra_indv_amnno", calfList.get(tmpi).get("sra_indv_amnno"));
					tmpMap.put("indv_sex_c", calfList.get(tmpi).get("indv_sex_c"));
					tmpMap.put("cow_sog_wt", calfList.get(tmpi).get("cow_sog_wt"));
					tmpMap.put("birth", calfList.get(tmpi).get("birth"));
					tmpMap.put("kpn_no", calfList.get(tmpi).get("kpn_no"));
					tmpMap.put("del_yn", 0);
					tmpMap.put("tms_yn", 0);
					insertNum = insertNum + lalm1004Mapper.LALM1004_insMhCalf(tmpMap);
				}
			}
		}

		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);

		return reMap;
	}
}
