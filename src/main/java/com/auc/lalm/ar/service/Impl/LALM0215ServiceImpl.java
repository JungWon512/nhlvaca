package com.auc.lalm.ar.service.Impl;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import com.auc.lalm.ar.service.LALM0215Service;
import com.auc.main.service.LogService;
import com.auc.main.service.Impl.LogMapper;

@Service("LALM0215Service")
@SuppressWarnings({"unused", "unchecked"})
public class LALM0215ServiceImpl implements LALM0215Service{

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
	LALM0215Mapper lalm0215Mapper;	
	
	@Autowired
	LogService logService;
	
	@Autowired
	LogMapper logMapper;
	
	@Override
	public List<Map<String, Object>> LALM0215_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selIndvAmnnoPgm(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selIndvAmnnoPgm(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selStsDsc(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selStsDsc(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selTmpIndvAmnnoPgm(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;	
		list = lalm0215Mapper.LALM0215_selTmpIndvAmnnoPgm(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selFhsIdNo(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selFhsIdNo(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selGetPpgcowFeeDsc(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selGetPpgcowFeeDsc(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selFee(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selFee(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0215_delPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int deleteNum = 0;	
		
		deleteNum = deleteNum + logService.insSogCowLog(map);
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delSogCow(map);
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delFeeImps(map);
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delMhCalf(map);
		reMap.put("deleteNum", deleteNum);
		
		return reMap;
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selIndvAmnno(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selIndvAmnno(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selPrgSq(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selPrgSq(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selMhCalf(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selMhCalf(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selTmpFhsNm(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selTmpFhsNm(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selMacoFee(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selMacoFee(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selAucPrgSq(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selAucPrgSq(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selOslpNo(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selOslpNo(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selTmpAucPrgSq(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> listTmpAucPrgSq = null;
		List<Map<String, Object>> list = null;
		String tmpAucPrgSqNO = "";
		
		listTmpAucPrgSq = lalm0215Mapper.LALM0215_selTmpAucObjDsc(map);
		tmpAucPrgSqNO = listTmpAucPrgSq.get(0).get("AUC_OBJ_DSC").toString();
		
		if(!("0").equals(tmpAucPrgSqNO)) {
			list = lalm0215Mapper.LALM0215_selTmpAucPrgSq(map);
		}
		
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0215_updAucChange(Map<String, Object> frmMap) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map  = (Map<String, Object>)frmMap.get("frm_mhsogcow");
		
		List<Map<String, Object>> list = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>)frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>)frmMap.get("grd_mhfee");
		
		int insertNum = 0;	
		int updateNum = 0;
		int deleteNum = 0;
		int aucObjDscCnt = 0;
		
		String vOslpNO   = "";
		String vAucDt    = "";
		String tmpOslpno = "";
		String vAucChgDt = "";
		
		// 경매일자를 이월일자로 변경
		vAucDt = map.get("auc_dt").toString();
		vAucChgDt = map.get("auc_chg_dt").toString();
		tmpOslpno = map.get("oslp_no").toString();
		map.put("auc_chg_dt", vAucChgDt);
		map.put("auc_dt", vAucChgDt);
		
		// 원표번호 셋팅
		list = lalm0215Mapper.LALM0215_selChgVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);
		
		
		
		insertNum = insertNum + lalm0215Mapper.LALM0215_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);
		
		// kpn번호 update
		updateNum = updateNum + lalm0215Mapper.LALM0215_updIndvSet(map);
		
		if(selFeemapList.size() > 0) {
			for(int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",	map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc",	map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 		map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 	vOslpNO);
				tmpMap.put("fee_rg_sqno", 	selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", 		selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", 		selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", 		selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", 		selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", 	selFeemapList.get(i).get("sra_tr_fee"));
				
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhFeeImps(tmpMap);
			}
		}
		
		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());
		
		if(aucObjDscCnt == 3 && ("3".equals(map.get("ppgcow_fee_dsc")) || "4".equals(map.get("ppgcow_fee_dsc")))) {
			for(int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",		map.get("ss_na_bzplc"));
				tmpMap.put("ss_userid", 		map.get("ss_userid"));
				tmpMap.put("auc_obj_dsc",		map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 			map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 		vOslpNO);
				tmpMap.put("v_rg_sqno", 		tmpi+1);
				tmpMap.put("sra_srs_dsc", 		calfList.get(tmpi).get("sra_srs_dsc"));
				tmpMap.put("sra_indv_amnno", 	calfList.get(tmpi).get("sra_indv_amnno"));
				tmpMap.put("indv_sex_c", 		calfList.get(tmpi).get("indv_sex_c"));
				tmpMap.put("cow_sog_wt", 		calfList.get(tmpi).get("cow_sog_wt"));
				tmpMap.put("birth", 			calfList.get(tmpi).get("birth"));
				tmpMap.put("kpn_no", 			calfList.get(tmpi).get("kpn_no"));
				tmpMap.put("del_yn", 			0);
				tmpMap.put("tms_yn", 			0);
				
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhCalf(tmpMap);
			}
		}
		
		// 경매일자, 원표번호 복구
		map.put("auc_dt", vAucDt);
		map.put("oslp_no", tmpOslpno);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delSogCow(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delFeeImps(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delMhCalf(map);
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}
	
	@Override
	public List<Map<String, Object>> LALM0215_selAucPrg(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215Mapper.LALM0215_selAucPrg(map);
		return list;
		
	}

	@Override
	public Map<String, Object> LALM0215_insPgm(Map<String, Object> frmMap) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map  = (Map<String, Object>)frmMap.get("frm_mhsogcow");
		
		List<Map<String, Object>> list = null;
		List<Map<String, Object>> amnnolist = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>)frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>)frmMap.get("grd_mhfee");
		
		int insertNum = 0;	
		int updateNum = 0;
		int aucObjDscCnt = 0;
		
		String vOslpNO	= "";
		
		// 원표번호 셋팅
		list = lalm0215Mapper.LALM0215_selVoslpNo(map);
		vOslpNO = list.get(0).get("V_OSLP_NO").toString();
		map.put("oslp_no", vOslpNO);
		map.put("modl_no", map.get("auc_prg_sq"));
		
		
		insertNum = insertNum + lalm0215Mapper.LALM0215_insSogCow(map);
		insertNum = insertNum + logService.insSogCowLog(map);
		
		
		amnnolist = lalm0215Mapper.LALM0215_selAmnno(map);
		if(amnnolist.size() > 0) {
			updateNum = updateNum + lalm0215Mapper.LALM0215_updMnIndv(map);
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			insertNum = insertNum + lalm0215Mapper.LALM0215_insMmIndv(map);
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}
		
		updateNum = updateNum + lalm0215Mapper.LALM0215_updMmFhs(map);
		if(selFeemapList.size() > 0) {
			for(int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",	map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc",	map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 		map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 	vOslpNO);
				tmpMap.put("fee_rg_sqno", 	selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", 		selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", 		selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", 		selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", 		selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", 	selFeemapList.get(i).get("sra_tr_fee"));
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhFeeImps(tmpMap);
			}
		}
		
		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());
		
		if(aucObjDscCnt == 3 && ("3".equals(map.get("ppgcow_fee_dsc")) || "4".equals(map.get("ppgcow_fee_dsc")))) {
			for(int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				tmpMap = new HashMap<String, Object>();

				tmpMap.put("ss_na_bzplc",		map.get("ss_na_bzplc"));
				tmpMap.put("ss_userid", 		map.get("ss_userid"));
				tmpMap.put("auc_obj_dsc",		map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 			map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 		vOslpNO);
				tmpMap.put("v_rg_sqno", 		tmpi+1);
				tmpMap.put("sra_srs_dsc", 		calfList.get(tmpi).get("sra_srs_dsc"));
				tmpMap.put("sra_indv_amnno", 	calfList.get(tmpi).get("sra_indv_amnno"));
				tmpMap.put("indv_sex_c", 		calfList.get(tmpi).get("indv_sex_c"));
				tmpMap.put("cow_sog_wt", 		calfList.get(tmpi).get("cow_sog_wt"));
				tmpMap.put("birth", 			calfList.get(tmpi).get("birth"));
				tmpMap.put("kpn_no", 			calfList.get(tmpi).get("kpn_no"));
				tmpMap.put("del_yn", 			0);
				tmpMap.put("tms_yn", 			0);

				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhCalf(tmpMap);
			}
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		reMap.put("rtnData", vOslpNO);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0215_updPgm(Map<String, Object> frmMap) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> map  = (Map<String, Object>)frmMap.get("frm_mhsogcow");
		
		List<Map<String, Object>> list = null;
		List<Map<String, Object>> amnnolist = null;
		List<Map<String, Object>> calfList = (List<Map<String, Object>>)frmMap.get("calfgrid");
		List<Map<String, Object>> selFeemapList = (List<Map<String, Object>>)frmMap.get("grd_mhfee");
		
		int insertNum = 0;
		int deleteNum = 0;
		int updateNum = 0;
		int aucObjDscCnt = 0;
		
		String beforeAucPrgSq 	= map.get("hd_auc_prg_sq").toString();
		String afterAucPrgSq 	= map.get("auc_prg_sq").toString();
		
		if(!beforeAucPrgSq.equals(afterAucPrgSq)) {
			map.put("modl_no", map.get("auc_prg_sq"));
		}

		Map<String, Object> cowInfo = lalm0215Mapper.LALM0215_selSogCow(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delSogCow(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delFeeImps(map);
		
		deleteNum = deleteNum + lalm0215Mapper.LALM0215_delMhCalf(map);
		if(cowInfo != null) {
			map.put("auc_yn", cowInfo.get("AUC_YN"));			
		}		
		
		insertNum = insertNum + lalm0215Mapper.LALM0215_insSogCow(map);
		
		insertNum = insertNum + logService.insSogCowLog(map);
		
		amnnolist = lalm0215Mapper.LALM0215_selAmnno(map);
		
		if(amnnolist.size() > 0) {
			updateNum = updateNum + lalm0215Mapper.LALM0215_updMnIndv(map);
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		} else {
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");
			
			insertNum = insertNum + lalm0215Mapper.LALM0215_insMmIndv(map);
			
			//개체 정보 업데이트
			insertNum = insertNum + logService.insMmIndvLog(map);
		}
		
		updateNum = updateNum + lalm0215Mapper.LALM0215_updMmFhs(map);
		
		if(selFeemapList.size() > 0) {
			for(int i = 0; i < selFeemapList.size(); i++) {
				tmpMap = new HashMap<String, Object>();
				tmpMap.put("ss_na_bzplc",	map.get("ss_na_bzplc"));
				tmpMap.put("auc_obj_dsc",	map.get("auc_obj_dsc"));
				tmpMap.put("auc_dt", 		map.get("auc_dt"));
				tmpMap.put("v_oslp_no", 	map.get("oslp_no"));
				tmpMap.put("fee_rg_sqno", 	selFeemapList.get(i).get("fee_rg_sqno"));
				tmpMap.put("na_fee_c", 		selFeemapList.get(i).get("na_fee_c"));
				tmpMap.put("apl_dt", 		selFeemapList.get(i).get("apl_dt"));
				tmpMap.put("fee_apl_obj_c", selFeemapList.get(i).get("fee_apl_obj_c"));
				tmpMap.put("ans_dsc", 		selFeemapList.get(i).get("ans_dsc"));
				tmpMap.put("sbid_yn", 		selFeemapList.get(i).get("sbid_yn"));
				tmpMap.put("sra_tr_fee", 	selFeemapList.get(i).get("sra_tr_fee"));
				
				insertNum = insertNum + lalm0215Mapper.LALM0215_insMhFeeImps(tmpMap);
			}
		}
		
		aucObjDscCnt = Integer.parseInt(map.get("auc_obj_dsc").toString());
		
		if(aucObjDscCnt == 3 && ("3".equals(map.get("ppgcow_fee_dsc")) || "4".equals(map.get("ppgcow_fee_dsc")))) {
			for(int tmpi = 0; tmpi < calfList.size(); tmpi++) {
				if(!calfList.get(tmpi).get("_status_").equals("-")) {
					tmpMap = new HashMap<String, Object>();
					tmpMap.put("ss_na_bzplc",		map.get("ss_na_bzplc"));
					tmpMap.put("ss_userid", 		map.get("ss_userid"));
					tmpMap.put("auc_obj_dsc",		map.get("auc_obj_dsc"));
					tmpMap.put("auc_dt", 			map.get("auc_dt"));
					tmpMap.put("v_oslp_no", 		map.get("oslp_no"));
					tmpMap.put("v_rg_sqno", 		tmpi+1);
					tmpMap.put("sra_srs_dsc", 		calfList.get(tmpi).get("sra_srs_dsc"));
					tmpMap.put("sra_indv_amnno", 	calfList.get(tmpi).get("sra_indv_amnno"));
					tmpMap.put("indv_sex_c", 		calfList.get(tmpi).get("indv_sex_c"));
					tmpMap.put("cow_sog_wt", 		calfList.get(tmpi).get("cow_sog_wt"));
					tmpMap.put("birth", 			calfList.get(tmpi).get("birth"));
					tmpMap.put("kpn_no", 			calfList.get(tmpi).get("kpn_no"));
					tmpMap.put("del_yn", 			0);
					tmpMap.put("tms_yn", 			0);
					insertNum = insertNum + lalm0215Mapper.LALM0215_insMhCalf(tmpMap);
				}
			}
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}
    
	public List<Map<String, Object>> LALM0215_selImgList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> reList = new ArrayList<>();
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("na_bzplc", param.get("na_bzplc"));
		paramMap.put("sra_indv_amnno", param.get("sra_indv_amnno"));
		paramMap.put("auc_obj_dsc", param.get("auc_obj_dsc"));
		paramMap.put("auc_dt", param.get("auc_dt"));
		paramMap.put("oslp_no", param.get("oslp_no"));
		paramMap.put("led_sqno", param.get("led_sqno"));
		reList = lalm0215Mapper.LALM0215_selSogCowImg(paramMap);

		return reList;
	}
	
	/**
	 * MultipartFile 이미지 네이버 클라우드 업로드 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM0215_insImgList(Map<String, Object> paramMap) {
		final Map<String, Object> reMap = new HashMap<>();
		try {
			// S3 client
			final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
													 .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
													 .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
													 .build();
			
			// ACL 설정 : 파일마다 읽기 권한을 설정
			final AccessControlList accessControlList = new AccessControlList();
			accessControlList.grantPermission(GroupGrantee.AllUsers, Permission.Read);
			
			// CORS 설정 : 이미지 업로드 페이지에서 이미지 url로 fetch 후 canvas 형태로 append 하는 형식이기 때문에 CORS 세팅이 필요
			final List<CORSRule.AllowedMethods> methodRule = Arrays.asList(CORSRule.AllowedMethods.PUT, CORSRule.AllowedMethods.GET, CORSRule.AllowedMethods.POST);
			final CORSRule rule = new CORSRule().withId("CORSRule")
												.withAllowedMethods(methodRule)
												.withAllowedHeaders(Arrays.asList(new String[] { "*" }))
												.withAllowedOrigins(Arrays.asList(new String[] { "*" }))
												.withMaxAgeSeconds(3000);
	
			final List<CORSRule> rules = Arrays.asList(rule);
	
			s3.setBucketCrossOriginConfiguration(bucketName, new BucketCrossOriginConfiguration().withRules(rules));
			
			final String folderName = paramMap.get("na_bzplc") + "/" + paramMap.get("sra_indv_amnno") + "/";
			List<MultipartFile> files = (List<MultipartFile>)paramMap.get("files");
			
			for (MultipartFile file : files) {
				// upload parameter file
				String objectName = UUID.randomUUID().toString() + ".png";
				
				ObjectMetadata objectMetadata = new ObjectMetadata();
				objectMetadata.setContentType(MediaType.IMAGE_PNG_VALUE);
				objectMetadata.setContentLength(file.getBytes().length);
				PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, folderName + objectName, file.getInputStream(), objectMetadata);
				putObjectRequest.setAccessControlList(accessControlList);
				
				s3.putObject(putObjectRequest);
			}

//			this.LALM0215_selImgList(reMap);
		}
		catch (AmazonS3Exception e) {
			e.printStackTrace();
		}
		catch(SdkClientException e) {
			e.printStackTrace();
		}
		catch(IOException e) {
			e.printStackTrace();
		}
		
		return reMap;
	}
	
	
	public Map<String, Object> LALM0215_delImgList(Map<String, Object> map) {
		Map<String, Object> reMap = new HashMap<>();
		final AmazonS3 s3 = AmazonS3ClientBuilder.standard()
												 .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endPoint, regionName))
												 .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(accessKey, secretKey)))
												 .build();

		String key = map.get("imgid").toString();
		try {
			s3.deleteObject(bucketName, key);
		
		} catch (AmazonS3Exception e) {
		    e.printStackTrace();
		} catch(SdkClientException e) {
		    e.printStackTrace();
		}
		
		return reMap;
	}
	
	/**
	 * Base64 인코딩 이미지 클라우드 업로드
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
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
		
		// CORS 설정 : 이미지 업로드 페이지에서 이미지 url로 fetch 후 canvas 형태로 append 하는 형식이기 때문에 CORS 세팅이 필요
		final List<CORSRule.AllowedMethods> methodRule = Arrays.asList(CORSRule.AllowedMethods.PUT, CORSRule.AllowedMethods.GET, CORSRule.AllowedMethods.POST);
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
		
		final List<String> files = (List<String>)map.get("files");
		
		if (ObjectUtils.isEmpty(files)) return null;
		
		for (String file : files) {
			boolean isSuccess = true;
			String fileNm = "";

			// origin 파일이 없는 경우 or 값이 data:image로 시작하지 않는 경우 pass
			if (ObjectUtils.isEmpty(file)
			|| !file.startsWith("data:image")) continue;

			fileNm = UUID.randomUUID().toString();

			String[] base64Arr = file.split(",");
			byte[] imgByte = Base64.decode(base64Arr[1]);
			InputStream bis = new ByteArrayInputStream(imgByte);

			ObjectMetadata bjectMetadata = new ObjectMetadata();
			bjectMetadata.setContentLength(imgByte.length);
			bjectMetadata.setContentType(MediaType.IMAGE_PNG_VALUE);
			PutObjectRequest oriPutObjectRequest = new PutObjectRequest(bucketName, filePath + fileNm + fileExtNm, bis, bjectMetadata);

			try {
				oriPutObjectRequest.setAccessControlList(accessControlList);
				s3.putObject(oriPutObjectRequest);
			}
			catch (AmazonS3Exception e) {
				e.printStackTrace();
				isSuccess = false;
			}
			catch(SdkClientException e) {
				e.printStackTrace();
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
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> LALM0215_insImgPgm(Map<String, Object> rMap) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		// 클라우드 업로드 후 성공한 리스트 가져오기
		final List<Map<String, Object>> resList = this.imgUploadPrc(rMap);
		int insertNum = 0;
		int imgSqno = 1;
		if (ObjectUtils.isEmpty(resList)) {
			reMap.put("inserNum", insertNum);
			return reMap;
		}
		
		lalm0215Mapper.LALM0215_delImgPgm(rMap);
		for (Map<String, Object> res : resList) {
			res.put("ss_eno", rMap.get("ss_eno"));
			res.put("img_sqno", imgSqno++);
			insertNum += lalm0215Mapper.LALM0215_insImgPgm(res);
		}
		
		reMap.put("insertNum", insertNum);
		return reMap;
	}
}
