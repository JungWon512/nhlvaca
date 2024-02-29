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

	@Value("${bucket.endPoint}")
	private String endPoint;

	@Value("${bucket.regionName}")
	private String regionName;

	@Value("${bucket.accessKey}")
	private String accessKey;

	@Value("${bucket.secretKey}")
	private String secretKey;

	@Value("${bucket.bucketName}")
	private String bucketName;

	@Autowired
	LALM1004Mapper lsam0203Mapper;

	@Autowired
	LogService logService;

	@Autowired
	LogMapper logMapper;

	@Override
	public List<Map<String, Object>> LALM1004_selList(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selList(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selIndvAmnnoPgm(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selIndvAmnnoPgm(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selStsDsc(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selStsDsc(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selTmpIndvAmnnoPgm(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selFhsIdNo(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selFhsIdNo(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selGetPpgcowFeeDsc(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selFee(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selFee(map);
		return list;

	}

	@Override
	public Map<String, Object> LALM1004_delPgm(Map<String, Object> map) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();

		int deleteNum = 0;

		deleteNum = deleteNum + logService.insSogCowLog(map);
		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delSogCow(map);
		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delFeeImps(map);
		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delMhCalf(map);
		reMap.put("deleteNum", deleteNum);

		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM1004_selIndvAmnno(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selIndvAmnno(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selPrgSq(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selPrgSq(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selMhCalf(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selMhCalf(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selTmpFhsNm(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selTmpFhsNm(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selMacoFee(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selMacoFee(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selAucPrgSq(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selAucPrgSq(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selOslpNo(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selOslpNo(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1004_selTmpAucPrgSq(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> listTmpAucPrgSq = null;
		List<Map<String, Object>> list = null;
		String tmpAucPrgSqNO = "";

		listTmpAucPrgSq = lsam0203Mapper.LALM1004_selTmpAucObjDsc(map);
		tmpAucPrgSqNO = listTmpAucPrgSq.get(0).get("AUC_OBJ_DSC").toString();

		if (!("0").equals(tmpAucPrgSqNO)) {
			list = lsam0203Mapper.LALM1004_selTmpAucPrgSq(map);
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
		list = lsam0203Mapper.LALM1004_selChgVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);

		insertNum = insertNum + lsam0203Mapper.LALM1004_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);

		// kpn번호 update
		updateNum = updateNum + lsam0203Mapper.LALM1004_updIndvSet(map);

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

				insertNum = insertNum + lsam0203Mapper.LALM1004_insMhFeeImps(tmpMap);
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

				insertNum = insertNum + lsam0203Mapper.LALM1004_insMhCalf(tmpMap);
			}
		}

		// 경매일자, 원표번호 복구
		map.put("auc_dt", vAucDt);
		map.put("oslp_no", tmpOslpno);

		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delSogCow(map);

		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delFeeImps(map);

		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delMhCalf(map);

		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);

		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM1004_selAucPrg(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lsam0203Mapper.LALM1004_selAucPrg(map);
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
		list = lsam0203Mapper.LALM1004_selVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);
		map.put("modl_no", map.get("auc_prg_sq"));

		insertNum = insertNum + lsam0203Mapper.LALM1004_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);

		amnnolist = lsam0203Mapper.LALM1004_selAmnno(map);
		if (amnnolist.size() > 0) {
			updateNum = updateNum + lsam0203Mapper.LALM1004_updMnIndv(map);
			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			insertNum = insertNum + lsam0203Mapper.LALM1004_insMmIndv(map);
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");
			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}

		updateNum = updateNum + lsam0203Mapper.LALM1004_updMmFhs(map);
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
				insertNum = insertNum + lsam0203Mapper.LALM1004_insMhFeeImps(tmpMap);
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

				insertNum = insertNum + lsam0203Mapper.LALM1004_insMhCalf(tmpMap);
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

		Map<String, Object> cowInfo = lsam0203Mapper.LALM1004_selSogCow(map);

		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delSogCow(map);

		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delFeeImps(map);

		deleteNum = deleteNum + lsam0203Mapper.LALM1004_delMhCalf(map);
		if (cowInfo != null) {
			map.put("auc_yn", cowInfo.get("AUC_YN"));
		}

		insertNum = insertNum + lsam0203Mapper.LALM1004_insSogCow(map);

		insertNum = insertNum + logService.insSogCowLog(map);

		amnnolist = lsam0203Mapper.LALM1004_selAmnno(map);

		if (amnnolist.size() > 0) {
			updateNum = updateNum + lsam0203Mapper.LALM1004_updMnIndv(map);
			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");

			insertNum = insertNum + lsam0203Mapper.LALM1004_insMmIndv(map);

			// 개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}

		updateNum = updateNum + lsam0203Mapper.LALM1004_updMmFhs(map);

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

				insertNum = insertNum + lsam0203Mapper.LALM1004_insMhFeeImps(tmpMap);
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
					insertNum = insertNum + lsam0203Mapper.LALM1004_insMhCalf(tmpMap);
				}
			}
		}

		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);

		return reMap;
	}

	public List<Map<String, Object>> LALM1004_selImgList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> reList = new ArrayList<>();

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("na_bzplc", param.get("na_bzplc"));
		paramMap.put("sra_indv_amnno", param.get("sra_indv_amnno"));
		paramMap.put("auc_obj_dsc", param.get("auc_obj_dsc"));
		paramMap.put("auc_dt", param.get("auc_dt"));
		paramMap.put("oslp_no", param.get("oslp_no"));
		paramMap.put("led_sqno", param.get("led_sqno"));
		paramMap.put("imgDomain", endPoint + "/" + bucketName + "/");
		reList = lsam0203Mapper.LALM1004_selSogCowImg(paramMap);

		if (reList.size() > 0) {
			for (Map<String, Object> map : reList) {
				String url = map.get("FILE_URL").toString();
				InputStream inputStream = null;
				ByteArrayOutputStream byteOutStream = null;
				URL oUrl = new URL(url);
				try {
					int len = 0;
					File file = new File(url);
					inputStream = oUrl.openStream();
					byteOutStream = new ByteArrayOutputStream();

					byte[] buf = new byte[1024];

					while ((len = inputStream.read(buf)) != -1) {
						byteOutStream.write(buf, 0, len);
					}

					byte[] fileArray = byteOutStream.toByteArray();

					String encodeFile = StringUtils.byteToBase64(fileArray);

					map.put("ENCODE_FILE", "data:image/png;base64," + encodeFile);
				} catch (RuntimeException | IOException re) {
					log.error("e : LALM1004_selImgList : ", re);
				} finally {
					if (inputStream != null)
						inputStream.close();
					if (byteOutStream != null)
						byteOutStream.close();
				}
			}
			;
		}

		return reList;
	}

	public Map<String, Object> LALM1004_delImgList(Map<String, Object> map) {
		Map<String, Object> reMap = new HashMap<>();
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
				.withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
				.withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
				.build();

		String key = map.get("imgid").toString();
		try {
			s3.deleteObject(bucketName, key);

		} catch (AmazonS3Exception e) {
			log.error("e : LALM1004_delImgList : ", e);
		} catch (SdkClientException e) {
			log.error("e : LALM1004_delImgList : ", e);
		}

		return reMap;
	}

	/**
	 * Base64 인코딩 이미지 클라우드 업로드
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> imgUploadPrc(Map<String, Object> map) {
		final List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();

		// S3 client
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
				.withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
				.withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
				.build();

		// ACL 설정 : 파일마다 읽기 권한을 설정
		final AccessControlList accessControlList = new AccessControlList();
		accessControlList.grantPermission(GroupGrantee.AllUsers, Permission.Read);

		// CORS 설정 : 이미지 업로드 페이지에서 이미지 url로 fetch 후 canvas 형태로 append 하는 형식이기 때문에 CORS
		// 세팅이 필요
		final List<CORSRule.AllowedMethods> methodRule = Arrays.asList(CORSRule.AllowedMethods.PUT,
				CORSRule.AllowedMethods.GET, CORSRule.AllowedMethods.POST);
		final CORSRule rule = new CORSRule().withId("CORSRule")
				.withAllowedMethods(methodRule)
				.withAllowedHeaders(Arrays.asList(new String[] { "*" }))
				.withAllowedOrigins(Arrays.asList(new String[] { "*" }))
				.withMaxAgeSeconds(3000);

		final List<CORSRule> rules = Arrays.asList(rule);

		s3.setBucketCrossOriginConfiguration(bucketName, new BucketCrossOriginConfiguration().withRules(rules));

		final String naBzplc = map.get("na_bzplc").toString();
		final String aucDt = map.get("auc_dt").toString();
		final String sraIndvAmnno = map.get("sra_indv_amnno").toString();
		final String filePath = naBzplc + "/" + sraIndvAmnno + "/";
		final String fileExtNm = ".png";

		// base64형태로 처리
		final List<String> files = (List<String>) map.get("files");

		if (ObjectUtils.isEmpty(files))
			return null;

		for (String file : files) {
			boolean isSuccess = true;
			String fileNm = "";

			// origin 파일이 없는 경우 or 값이 data:image로 시작하지 않는 경우 pass
			if (ObjectUtils.isEmpty(file)
					|| !file.startsWith("data:image"))
				continue;

			fileNm = UUID.randomUUID().toString();

			String[] base64Arr = file.split(",");
			byte[] imgByte = Base64.decode(base64Arr[1]);
			InputStream bis = new ByteArrayInputStream(imgByte);

			ObjectMetadata bjectMetadata = new ObjectMetadata();
			bjectMetadata.setContentLength(imgByte.length);
			bjectMetadata.setContentType(MediaType.IMAGE_PNG_VALUE);
			PutObjectRequest oriPutObjectRequest = new PutObjectRequest(bucketName, filePath + fileNm + fileExtNm, bis,
					bjectMetadata);

			try {
				oriPutObjectRequest.setAccessControlList(accessControlList);
				s3.putObject(oriPutObjectRequest);
			} catch (AmazonS3Exception e) {
				log.error("e : imgUploadPrc : ", e);
				isSuccess = false;
			} catch (SdkClientException e) {
				log.error("e : imgUploadPrc : ", e);
				isSuccess = false;
			}

			if (isSuccess) {
				Map<String, Object> rtn = new HashMap<String, Object>();
				rtn.put("na_bzplc", naBzplc);
				rtn.put("auc_dt", aucDt);
				rtn.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				rtn.put("oslp_no", map.get("oslp_no"));
				rtn.put("led_sqno", map.get("led_sqno"));
				rtn.put("sra_indv_amnno", sraIndvAmnno);
				rtn.put("file_path", filePath);
				rtn.put("file_nm", fileNm);
				rtn.put("file_ext_nm", fileExtNm);
				rtnList.add(rtn);
			}
		}

		return rtnList;
	}

	/**
	 * Multipart 이미지 클라우드 업로드
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> imgUploadPrcMultipart(Map<String, Object> map) {
		final List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();

		// S3 client
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
				.withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
				.withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
				.build();

		// ACL 설정 : 파일마다 읽기 권한을 설정
		final AccessControlList accessControlList = new AccessControlList();
		accessControlList.grantPermission(GroupGrantee.AllUsers, Permission.Read);

		// CORS 설정 : 이미지 업로드 페이지에서 이미지 url로 fetch 후 canvas 형태로 append 하는 형식이기 때문에 CORS
		// 세팅이 필요
		final List<CORSRule.AllowedMethods> methodRule = Arrays.asList(CORSRule.AllowedMethods.PUT,
				CORSRule.AllowedMethods.GET, CORSRule.AllowedMethods.POST);
		final CORSRule rule = new CORSRule().withId("CORSRule")
				.withAllowedMethods(methodRule)
				.withAllowedHeaders(Arrays.asList(new String[] { "*" }))
				.withAllowedOrigins(Arrays.asList(new String[] { "*" }))
				.withMaxAgeSeconds(3000);

		final List<CORSRule> rules = Arrays.asList(rule);

		s3.setBucketCrossOriginConfiguration(bucketName, new BucketCrossOriginConfiguration().withRules(rules));

		final String naBzplc = map.get("na_bzplc").toString();
		final String aucDt = map.get("auc_dt").toString();
		final String sraIndvAmnno = map.get("sra_indv_amnno").toString();
		final String filePath = naBzplc + "/" + sraIndvAmnno + "/";
		final String fileExtNm = ".png";

		// multipart형태로 처리
		final List<MultipartFile> files = (List<MultipartFile>) map.get("uploadImg");

		if (ObjectUtils.isEmpty(files))
			return null;

		for (MultipartFile file : files) {
			boolean isSuccess = true;
			String fileNm = "";

			// origin 파일이 없는 경우 or 값이 data:image로 시작하지 않는 경우 pass
			if (ObjectUtils.isEmpty(file))
				continue;

			fileNm = UUID.randomUUID().toString();

			try {
				ObjectMetadata bjectMetadata = new ObjectMetadata();
				bjectMetadata.setContentLength(file.getBytes().length);
				bjectMetadata.setContentType(MediaType.IMAGE_PNG_VALUE);
				PutObjectRequest oriPutObjectRequest = new PutObjectRequest(bucketName, filePath + fileNm + fileExtNm,
						file.getInputStream(), bjectMetadata);

				oriPutObjectRequest.setAccessControlList(accessControlList);
				s3.putObject(oriPutObjectRequest);
			} catch (IOException e) {
				log.error("e : imgUploadPrcMultipart : ", e);
				isSuccess = false;
			} catch (AmazonS3Exception e) {
				log.error("e : imgUploadPrcMultipart : ", e);
				isSuccess = false;
			} catch (SdkClientException e) {
				log.error("e : imgUploadPrcMultipart : ", e);
				isSuccess = false;
			}

			if (isSuccess) {
				Map<String, Object> rtn = new HashMap<String, Object>();
				rtn.put("na_bzplc", naBzplc);
				rtn.put("auc_dt", aucDt);
				rtn.put("auc_obj_dsc", map.get("auc_obj_dsc"));
				rtn.put("oslp_no", map.get("oslp_no"));
				rtn.put("led_sqno", map.get("led_sqno"));
				rtn.put("sra_indv_amnno", sraIndvAmnno);
				rtn.put("file_path", filePath);
				rtn.put("file_nm", fileNm);
				rtn.put("file_ext_nm", fileExtNm);
				rtnList.add(rtn);
			}
		}

		return rtnList;
	}

	/**
	 * 출장우 이미지 저장
	 * 
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> LALM1004_insImgPgm(Map<String, Object> rMap) throws Exception {
		int insertNum = 0;
		int updateNum = 0;
		final Map<String, Object> reMap = new HashMap<String, Object>();
		// 파일이 없을시 db delete
		// final List<String> files = (List<String>)rMap.get("files");
		final List<MultipartFile> files = (List<MultipartFile>) rMap.get("files");
		if (ObjectUtils.isEmpty(files)) {
			updateNum += lsam0203Mapper.LALM1004_delImgPgm(rMap);
			reMap.put("updateNum", updateNum);
			return reMap;
		}

		// 클라우드 업로드 후 성공한 리스트 가져오기
		// final List<Map<String, Object>> resList = this.imgUploadPrc(rMap);
		final List<Map<String, Object>> resList = this.imgUploadPrcMultipart(rMap);
		int imgSqno = 1;
		if (ObjectUtils.isEmpty(resList)) {
			reMap.put("inserNum", insertNum);
			return reMap;
		}

		lsam0203Mapper.LALM1004_delImgPgm(rMap);
		for (Map<String, Object> res : resList) {
			res.put("ss_eno", rMap.get("ss_eno"));
			res.put("img_sqno", imgSqno++);
			insertNum += lsam0203Mapper.LALM1004_insImgPgm(res);
		}

		reMap.put("insertNum", insertNum);
		return reMap;
	}
}
