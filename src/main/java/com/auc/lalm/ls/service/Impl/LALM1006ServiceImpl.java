package com.auc.lalm.ls.service.Impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.auc.lalm.ls.service.LALM1006Service;

@Service("LALM1006Service")
public class LALM1006ServiceImpl implements LALM1006Service{

	@Autowired
	LALM1006Mapper lalm1006Mapper;	

	@Autowired
	LALM1007Mapper lalm1007Mapper;

	@Override
	public List<Map<String, Object>> LALM1006_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selList(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selSraList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selSraList(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selBadTrmn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selBadTrmn(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selBadCheck(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		if(ObjectUtils.isEmpty(map.get("mb_intg_no"))) {
			list = lalm1006Mapper.LALM1006_selBadCheckMwmn(map);
		}else {
			list = lalm1006Mapper.LALM1006_selBadCheck(map);
		}
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selTrmnAmnNo(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selTrmnAmnNo(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selAucPtcMnNo(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selAucPtcMnNo(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1006_selSraCount(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1006Mapper.LALM1006_selSraCount(map);
		return list;
	}
	
	@Override
	public Map<String, Object> LALM1006_insPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;
		/* String hd_auc_obj_dsc = (String)map.get("hd_auc_obj_dsc");
		String cb_auc_obj_dsc1 = (String)map.get("cb_auc_obj_dsc1");
		String cb_auc_obj_dsc2 = (String)map.get("cb_auc_obj_dsc2");
		String cb_auc_obj_dsc3 = (String)map.get("cb_auc_obj_dsc3");
		
		if(("0").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
		
		} else if(("1").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc2)) {
				int insMartNo = 0;
				insMartNo = lalm1006Mapper.LALM1006_insMartPgm(map);
				reMap.put("insMartNo", insMartNo);
			}
			if(("1").equals(cb_auc_obj_dsc3)) {
				int insBreedingNo = 0;
				insBreedingNo = lalm1006Mapper.LALM1006_insBreedingPgm(map);
				reMap.put("insBreedingNo", insBreedingNo);
			}
			
			
		} else if(("2").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc1)) {
				int insCalftNo = 0;
				insCalftNo = lalm1006Mapper.LALM1006_insCalfPgm(map);
				reMap.put("insCalftNo", insCalftNo);
			}
			if(("1").equals(cb_auc_obj_dsc3)) {
				int insBreedingNo = 0;
				insBreedingNo = lalm1006Mapper.LALM1006_insBreedingPgm(map);
				reMap.put("insBreedingNo", insBreedingNo);
			}
			
		} else if(("3").equals(hd_auc_obj_dsc)) {
			insertNum = lalm1006Mapper.LALM1006_insPgm(map);
			reMap.put("insertNum", insertNum);
			
			if(("1").equals(cb_auc_obj_dsc1)) {
				int insCalftNo = 0;
				insCalftNo = lalm1006Mapper.LALM1006_insCalfPgm(map);
				reMap.put("insCalftNo", insCalftNo);
			}
			if(("1").equals(cb_auc_obj_dsc2)) {
				int insMartNo = 0;
				insMartNo = lalm1006Mapper.LALM1006_insMartPgm(map);
				reMap.put("insMartNo", insMartNo);
			}
		}*/
		insertNum = lalm1006Mapper.LALM1006_insAllPgm(map);
		reMap.put("insertNum", insertNum);
		
		// 경매참가번호 정보 등록 후 보증금 입금 여부 등록(염소일 경우에만)
		// if(map.get("hd_auc_obj_dsc").equals("5")) {

		LocalDate today = LocalDate.now();
	
		Map<String, Object> rvMap = new HashMap<String, Object>();

		int v_rv_sqno = lalm1007Mapper.LALM1007_v_rv_sqno(map);

		// 보증금 금액이 0보다 클때만 보증금 입금 내역 등록
		if (!map.get("auc_entr_grn_am").equals("") && !map.get("auc_entr_grn_am").equals("0")) {

			rvMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
			rvMap.put("de_auc_obj_dsc", map.get("hd_auc_obj_dsc"));
			rvMap.put("de_auc_dt", map.get("auc_date"));
			rvMap.put("de_trmn_amnno", map.get("trmn_amnno"));
			rvMap.put("rv_sqno", v_rv_sqno);
			rvMap.put("de_rv_dt", today.format(DateTimeFormatter.ofPattern("YYYYMMdd")));
			rvMap.put("de_sra_rv_tpc", "1");
			rvMap.put("de_sra_rv_am", map.get("auc_entr_grn_am").equals("") ? 0 : map.get("auc_entr_grn_am"));
			rvMap.put("de_rmk_cntn", "보증금입금 처리");
			rvMap.put("ss_userid", map.get("ss_userid"));


			lalm1007Mapper.LALM1007_insRv(rvMap);

		}

		return reMap;
		// } else {
		// 	return reMap;
		// }

	}
	
	@Override
	public Map<String, Object> LALM1006_updPgm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;

		Set<String> keyset = map.keySet();
		for (String key : keyset){
			System.out.println(key + map.get(key));
		}

		updateNum = lalm1006Mapper.LALM1006_updPgm(map);
		reMap.put("updateNum", updateNum);

		// 경매참가번호 정보 수정 후 보증금 입금 여부 등록(염소일 경우에만)
		// if(map.get("hd_auc_obj_dsc").equals("5")) {
		
		Map<String, Object> rvMap = new HashMap<String, Object>();

		rvMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
		rvMap.put("auc_obj_dsc", map.get("hd_auc_obj_dsc"));
		rvMap.put("auc_dt", map.get("auc_date"));
		rvMap.put("trmn_amnno", map.get("trmn_amnno"));

		Map<String, Object> rmkMap = lalm1007Mapper.LALM1007_rvInfo(rvMap);

		LocalDate today = LocalDate.now();

		if(rmkMap != null) {
			Map<String, Object> updMap = new HashMap<String, Object>();

			updMap.put("de_rv_dt", today.format(DateTimeFormatter.ofPattern("YYYYMMdd")));
			updMap.put("de_sra_rv_tpc", "1");
			updMap.put("de_sra_rv_am", map.get("auc_entr_grn_am").equals("") ? 0 : map.get("auc_entr_grn_am"));
			updMap.put("de_rmk_cntn", "보증금입금 처리");
			updMap.put("ss_userid", map.get("ss_userid"));

			updMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
			updMap.put("de_trmn_amnno", map.get("trmn_amnno"));
			updMap.put("de_auc_obj_dsc", map.get("hd_auc_obj_dsc"));
			updMap.put("de_auc_dt", map.get("auc_date"));
			updMap.put("de_rv_sqno", rmkMap.get("RV_SQNO"));

			// 보증금 변경된 금액이 0원일 경우 보증금 입금 내역 삭제 하도록 수정
			if(map.get("auc_entr_grn_am").equals("") || map.get("auc_entr_grn_am").equals("0")) {
				lalm1007Mapper.LALM1007_delRv(updMap);
			} else {
				lalm1007Mapper.LALM1007_updRv(updMap);
			}

		} 
		// 기존에 등록되어있는 보증금 입금 데이터가 없고 보증금 금액이 0원 이상일 경우에는 
		// 보증금 입금 내역 등록 
		else  {
			if (!map.get("auc_entr_grn_am").equals("") && !map.get("auc_entr_grn_am").equals("0")) {
				Map<String, Object> insMap = new HashMap<String, Object>();

				int v_rv_sqno = lalm1007Mapper.LALM1007_v_rv_sqno(map);

				insMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
				insMap.put("de_auc_obj_dsc", map.get("hd_auc_obj_dsc"));
				insMap.put("de_auc_dt", map.get("auc_date"));
				insMap.put("de_trmn_amnno", map.get("trmn_amnno"));
				insMap.put("rv_sqno", v_rv_sqno);
				insMap.put("de_rv_dt", today.format(DateTimeFormatter.ofPattern("YYYYMMdd")));
				insMap.put("de_sra_rv_tpc", "1");
				insMap.put("de_sra_rv_am", map.get("auc_entr_grn_am").equals("") ? 0 : map.get("auc_entr_grn_am"));
				insMap.put("de_rmk_cntn", "보증금입금 처리");
				insMap.put("ss_userid", map.get("ss_userid"));

				lalm1007Mapper.LALM1007_insRv(insMap);
			}
		}

		return reMap;
		// } else {
		// 	return reMap;
		// }
	}
	
	@Override
	public Map<String, Object> LALM1006_delPgm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int deleteNum = 0;
		deleteNum = lalm1006Mapper.LALM1006_delAllPgm(map);

		// 보증금 입금 처리 내역 삭제
		Map<String, Object> rvMap = new HashMap<String, Object>();

		rvMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
		rvMap.put("auc_obj_dsc", map.get("hd_auc_obj_dsc"));
		rvMap.put("auc_dt", map.get("auc_date"));
		rvMap.put("trmn_amnno", map.get("trmn_amnno"));

		Map<String, Object> rmkMap = lalm1007Mapper.LALM1007_rvInfo(rvMap);

		if(rmkMap != null && rmkMap.size() > 0) {

			reMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
			reMap.put("de_trmn_amnno", map.get("trmn_amnno"));
			reMap.put("de_auc_obj_dsc", map.get("hd_auc_obj_dsc"));
			reMap.put("de_auc_dt", map.get("auc_date"));
			reMap.put("de_rv_sqno", rmkMap.get("RV_SQNO"));

			lalm1007Mapper.LALM1007_delRv(reMap);
		}		
		reMap.put("deleteNum", deleteNum);

		return reMap;
	}

}
