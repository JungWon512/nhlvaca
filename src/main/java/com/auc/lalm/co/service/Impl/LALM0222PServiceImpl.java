package com.auc.lalm.co.service.Impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.co.service.LALM0222PService;

@Service("LALM0222PService")
public class LALM0222PServiceImpl implements LALM0222PService{

	@Autowired
	LALM0222PMapper lalm0222PMapper;	

	@Override
	public List<Map<String, Object>> LALM0222P_updReturnValue(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> Demap = new HashMap<String, Object>();
		List<Map<String, Object>> indvList = null;
		List<Map<String, Object>> fhsList = null;
		List<Map<String, Object>> list = new ArrayList<>();
		
		int insertNum = 0;
		int updateNum = 0;
		
		String tmpZip = "";
		String tmpTelno = "";
		String tmpMpno = "";
		
		Iterator<String> keys = map.keySet().iterator();
		
		while(keys.hasNext()) {
			String key = keys.next();
			Demap.put(key, map.get(key).toString().trim());
		}
		
		if(!Demap.get("sra_farm_fzip").equals("") || !Demap.get("sra_farm_rzip").equals("")) {
			tmpZip = Demap.get("sra_farm_fzip") + "-" + Demap.get("sra_farm_rzip");
		}
		if(!Demap.get("sra_farm_amn_atel").equals("") || !Demap.get("sra_farm_amn_htel").equals("") || !Demap.get("sra_farm_amn_stel").equals("")) {
			tmpTelno = Demap.get("sra_farm_amn_atel") + "-" + Demap.get("sra_farm_amn_htel") + "-" + Demap.get("sra_farm_amn_stel");
		}
		// TODO :: 축경통에 농가 휴대전화 번호가 없는 경우 농가 관리에서 휴대전화를 입력해도 개체정보 조회시(LALM0222P) 축경통게 등록된 정보로 덮어 씌우기 때문에 덮어 씌우지 않도록 수정필요
		if(!Demap.get("sra_fhs_rep_mpsvno").equals("") || !Demap.get("sra_fhs_rep_mphno").equals("") || !Demap.get("sra_fhs_rep_mpsqno").equals("")) {
			tmpMpno = Demap.get("sra_fhs_rep_mpsvno") + "-" + Demap.get("sra_fhs_rep_mphno") + "-" + Demap.get("sra_fhs_rep_mpsqno");
		}
		
		Demap.put("zip", tmpZip);
		Demap.put("telno", tmpTelno);
		Demap.put("mpno", tmpMpno);
		
		indvList = lalm0222PMapper.LALM0222P_selTmpIndv(Demap);
		fhsList = lalm0222PMapper.LALM0222P_selTmpFhs(Demap);
		
		if(indvList.size() == 0) {
			insertNum = lalm0222PMapper.LALM0222P_insIsMmIndv(Demap);
		} else {
			updateNum = lalm0222PMapper.LALM0222P_updIsMmIndv(Demap);
		}
		
		if(fhsList.size() == 0) {
			insertNum = lalm0222PMapper.LALM0222P_insIsMmFhs(Demap);
			reMap.put("MACO_YN", "0");
			reMap.put("DEL_YN", "0");
			reMap.put("JRDWO_DSC", "2");
			reMap.put("SRA_FARM_ACNO", "");
			
		} else if(!Demap.get("ss_na_bzplc").equals("8808990687094")){ //20220329 jjw 영주축협 농가 update 제외 
			
			if(fhsList.get(0).get("JRDWO_DSC") == null || fhsList.get(0).get("JRDWO_DSC").equals("")) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,"농가의 관내 구분이 없습니다.<br>농가관리에서 관내구분을 설정해 주세요.");
			}
			
			Demap.put("maco_yn", fhsList.get(0).get("MACO_YN"));
			Demap.put("jrdwo_dsc", fhsList.get(0).get("JRDWO_DSC"));
			
			reMap.put("MACO_YN",       fhsList.get(0).get("MACO_YN"));
			reMap.put("DEL_YN",        fhsList.get(0).get("DEL_YN"));
			reMap.put("JRDWO_DSC",     fhsList.get(0).get("JRDWO_DSC"));
			reMap.put("SRA_FARM_ACNO", fhsList.get(0).get("SRA_FARM_ACNO"));
			
			updateNum = lalm0222PMapper.LALM0222P_updIsMmFhs(Demap);			
		}else {
			updateNum = 1;
		}
		
		if(insertNum > 0) {
			reMap.put("insertNum", insertNum);
		}
		
		if(updateNum > 0) {
			reMap.put("updateNum", updateNum);
		}
		
		reMap.put("SRA_SRS_DSC",Demap.get("sra_srs_dsc"));
		reMap.put("SRA_INDV_AMNNO",Demap.get("sra_indv_amnno"));
		reMap.put("FHS_ID_NO",Demap.get("fhs_id_no"));
		reMap.put("FARM_AMNNO",Demap.get("farm_amnno"));
		reMap.put("BIRTH",Demap.get("sra_indv_birth"));
		reMap.put("MCOW_DSC",Demap.get("sra_indv_mcow_brdsra_rg_dsc"));
		reMap.put("KPN_NO",Demap.get("sra_indv_kpn_no"));
		reMap.put("INDV_SEX_C",Demap.get("indv_sex_c"));
		reMap.put("MCOW_SRA_INDV_AMNNO",Demap.get("mcow_sra_indv_eart_no"));
		reMap.put("MATIME",Demap.get("sra_indv_mothr_matime"));
		reMap.put("INDV_ID_NO",Demap.get("krbf_iprv_rg_no"));
		reMap.put("SRA_INDV_BRDSRA_RG_NO",Demap.get("sra_indv_brdsra_rg_no"));
		reMap.put("RG_DSC",Demap.get("sra_indv_brdsra_rg_dsc"));
		reMap.put("SRA_INDV_PASG_QCN",Demap.get("sra_indv_pasg_qcn"));
		reMap.put("FHS_ID_NO",Demap.get("fhs_id_no"));
		reMap.put("FARM_AMNNO",Demap.get("farm_amnno"));
		reMap.put("FARM_ID_NO",Demap.get("farm_id_no"));
		reMap.put("NA_TRPL_C",Demap.get("na_trpl_c"));
		reMap.put("FTSNM",Demap.get("sra_fhsnm"));
		reMap.put("ZIP", Demap.get("zip").toString().replace("-", ""));
		reMap.put("DONGUP",Demap.get("sra_farm_dongup"));
		reMap.put("DONGBW",Demap.get("sra_farm_dongbw"));
		reMap.put("OHSE_TELNO",Demap.get("telno"));
		reMap.put("CUS_MPNO",Demap.get("mpno"));
		reMap.put("RMK_CNTN",Demap.get("rmk_cntn"));
		reMap.put("KPN_NO",Demap.get("sra_kpn_no"));
		
		list.add(0, reMap);
		
		return list;
	}


}
