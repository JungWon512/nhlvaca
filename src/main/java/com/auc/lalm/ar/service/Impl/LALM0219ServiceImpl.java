package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.ar.service.LALM0219Service;
import com.auc.main.service.LogService;
import com.auc.main.service.Impl.LogMapper;

@Service("LALM0219Service")
public class LALM0219ServiceImpl implements LALM0219Service{

	@Autowired
	LALM0219Mapper lalm0219Mapper;
	
	@Autowired
	LogService logService;
	
	@Autowired
	LogMapper logMapper;

	@Override
	public List<Map<String, Object>> LALM0219_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0219Mapper.LALM0219_selList(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0219_updSogCowSq(List<Map<String, Object>> inList) throws Exception {
		
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int insertNum = 0;
		int updateNum = 0;
		
		for(int i = 0; i < inList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)inList.get(i);
			
			if(tmpObject.get("ss_na_bzplc").equals("8808990659008")) {
				tmpObject.put("chg_pgid", "[LM0311]");
				tmpObject.put("chg_rmk_cntn", "경매번호");
				insertNum = insertNum + logService.insSogCowLog(tmpObject);
			}
			
			updateNum += lalm0219Mapper.LALM0219_updSogCowSq(tmpObject);
			
			reMap.put("updateNum", updateNum);
		}
		
		for(Map<String, Object> tempMap : inList) {
			Map<String, Object> aucPrgMap = this.LALM0219_selAucPrg(tempMap);
			int cnt = Integer.valueOf(String.valueOf(aucPrgMap.get("C_AUC_PRG_SQ")));
			if(cnt > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된 경매번호["+tempMap.get("auc_prg_sq")+"]가 있습니다. 경매번호를 확인 바랍니다.");				
			}			
		}
		
		return reMap;
	}	


	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> LALM0219P1_updExcelUpload(Map<String, Object> map) throws Exception{
		Map<String, Object> reMap         = new HashMap<String, Object>();		
		int updateNum = 0;
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("grid_data");
		String aucDt = (String) map.get("auc_dt");
		String ss_na_bzplc = (String) map.get("ss_na_bzplc");
		final Map<String, String> aucObjDscMap = new HashMap<String, String>() {
			{
				put("송아지", "1");
				put("비육우", "2");
				put("번식우", "3");
				put("염소", "5");
				put("말", "6");
			}
		};
		
		
		for(Map<String, Object> tmp : list) {
			String auc_obj_dsc = (String) tmp.get("auc_obj_dsc");
			tmp.put("ss_na_bzplc", ss_na_bzplc);
			tmp.put("auc_dt", aucDt);
			tmp.put("auc_obj_dsc", aucObjDscMap.get(auc_obj_dsc));
			
			updateNum += lalm0219Mapper.LALM0219P1_updExcelUpload(tmp);
		}
		reMap.put("updateNum", updateNum);
		
		return reMap;
		
	}

	@Override
	public Map<String, Object> LALM0219_selAucPrg(Map<String, Object> map) throws Exception{
		return lalm0219Mapper.LALM0219_selAucPrg(map);
	}
}
