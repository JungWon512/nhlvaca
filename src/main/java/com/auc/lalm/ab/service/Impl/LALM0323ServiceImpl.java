package com.auc.lalm.ab.service.Impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0323Service;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;

@Service("LALM0323Service")
public class LALM0323ServiceImpl implements LALM0323Service{

	@Autowired
	LogService logService;	
	@Autowired
	LALM0323Mapper lalm0323Mapper;
	@Autowired
	CommonService commonService;	
	
	@Override
	public List<Map<String, Object>> LALM0323_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0323Mapper.LALM0323_selList(map);
		return list;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> LALM0323_updBatPrice(Map<String, Object> map) throws Exception {

		Map<String, Object> frmMap = (Map<String, Object>)map.get("frm");
		List<Map<String, Object>> list = (List<Map<String, Object>>)map.get("list");
		Map<String, Object> detailMap = null;
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;	
		int updateNum = 0;
		for(int i = 0; i< list.size();i++) {
			detailMap = (Map<String, Object>)list.get(i);
			detailMap.put("chg_pgid", "[LM0323]");
			detailMap.put("chg_rmk_cntn", "수기낙찰결정[응찰하한가]");
			//프로그램 DB 저장
			insertNum = insertNum + logService.insSogCowLog(detailMap);	
			//하한가 변경
			detailMap.put("am_rto_dsc", frmMap.get("am_rto_dsc"));
			detailMap.put("sbt_am", frmMap.get("sbt_am"));
			detailMap.put("sbt_pmr", frmMap.get("sbt_pmr"));
			
			updateNum = updateNum + lalm0323Mapper.LALM0323_updBatPrice(detailMap);
		}
			

		reMap.put("insertNum", insertNum);	
		reMap.put("updateNum", updateNum);	
		
		
		return reMap;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> LALM0323_updConti(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = (List<Map<String, Object>>)map.get("list");
		Map<String, Object> detailMap = null;
		
		List<Map<String, Object>> grd_MhSogCow = new ArrayList<Map<String, Object>>();
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;	
		int updateNum = 0;
		for(int i = 0; i< list.size();i++) {
			detailMap = (Map<String, Object>)list.get(i);
			detailMap.put("chg_pgid", "[LM0323]");
			detailMap.put("chg_rmk_cntn", "수기낙찰결정[낙찰]");
			//프로그램 DB 저장
			insertNum = insertNum + logService.insSogCowLog(detailMap);	
			//경매데이터 수정(낙찰)
			detailMap.put("sel_sts_dsc", "22");
			updateNum = updateNum + lalm0323Mapper.LALM0323_updConti(detailMap);
			grd_MhSogCow.add(detailMap);
		}
		insertNum = insertNum + commonService.Common_insFeeImps(grd_MhSogCow);
			
		reMap.put("insertNum", insertNum);	
		reMap.put("updateNum", updateNum);
		return reMap;
		
	}
	

	@Override
	public List<Map<String, Object>> LALM0323P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0323Mapper.LALM0323P_selList(map);
		return list;
		
	}


}
