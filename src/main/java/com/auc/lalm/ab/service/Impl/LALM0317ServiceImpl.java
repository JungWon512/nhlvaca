package com.auc.lalm.ab.service.Impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0317Service;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;

@Service("LALM0317Service")
public class LALM0317ServiceImpl implements LALM0317Service{

	@Autowired
	LogService logService;	
	@Autowired
	LALM0317Mapper lalm0317Mapper;
	@Autowired
	CommonService commonService;
	
	@Override
	public List<Map<String, Object>> LALM0317_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0317Mapper.LALM0317_selList(map);
		return list;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> LALM0317_updFirstBatPrice(Map<String, Object> map) throws Exception {

		Map<String, Object> frmMap = (Map<String, Object>)map.get("frm");
		List<Map<String, Object>> list = (List<Map<String, Object>>)map.get("list");
		Map<String, Object> detailMap = null;
		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		
		int insertNum = 0;	
		int updateNum = 0;
		
		for(int i = 0; i< list.size();i++) {
			detailMap = (Map<String, Object>)list.get(i);
			detailMap.put("chg_pgid", "[LM0317]");
			detailMap.put("chg_rmk_cntn", "예정가 변경[복구]");
			//프로그램 DB 저장
			insertNum = insertNum + logService.insSogCowLog(detailMap);	
			//예정가 변경
			detailMap.put("am_rto_dsc", frmMap.get("am_rto_dsc"));
			detailMap.put("sbt_am", frmMap.get("sbt_am"));
			detailMap.put("sbt_pmr", frmMap.get("sbt_pmr"));
			
			updateNum = updateNum + lalm0317Mapper.LALM0317_updBatPrice(detailMap);
		}

		reMap.put("insertNum", insertNum);	
		reMap.put("updateNum", updateNum);	
		
		
		return reMap;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> LALM0317_updBatPrice(Map<String, Object> map) throws Exception {

		Map<String, Object> frmMap = (Map<String, Object>)map.get("frm");
		List<Map<String, Object>> list = (List<Map<String, Object>>)map.get("list");
		Map<String, Object> detailMap = null;
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;	
		int updateNum = 0;
		for(int i = 0; i< list.size();i++) {
			detailMap = (Map<String, Object>)list.get(i);
			detailMap.put("chg_pgid", "[LM0317]");
			detailMap.put("chg_rmk_cntn", "예정가 변경[변경]");
			//프로그램 DB 저장
			insertNum = insertNum + logService.insSogCowLog(detailMap);	
			//예정가 변경
			detailMap.put("am_rto_dsc", frmMap.get("am_rto_dsc"));
			detailMap.put("sbt_am", frmMap.get("sbt_am"));
			detailMap.put("sbt_pmr", frmMap.get("sbt_pmr"));
			
			updateNum = updateNum + lalm0317Mapper.LALM0317_updBatPrice(detailMap);
		}
			

		reMap.put("insertNum", insertNum);	
		reMap.put("updateNum", updateNum);	
		
		
		return reMap;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> LALM0317_updConti(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = (List<Map<String, Object>>)map.get("list");
		Map<String, Object> detailMap = null;
		
		List<Map<String, Object>> grd_MhSogCow = new ArrayList<Map<String, Object>>();
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;	
		int updateNum = 0;
		for(int i = 0; i< list.size();i++) {
			detailMap = (Map<String, Object>)list.get(i);
			detailMap.put("chg_pgid", "[LM0317]");			
			detailMap.put("chg_rmk_cntn", "경매내역변경[저장] "+detailMap.get("chg_rmk_cntn"));
			//경매데이터 수정(낙찰)
			updateNum = updateNum + lalm0317Mapper.LALM0317_updConti(detailMap);
			//출장우 log 저장
			insertNum = insertNum + logService.insSogCowLog(detailMap);
			grd_MhSogCow.add(detailMap);
		}
		insertNum = insertNum + commonService.Common_insFeeImps(grd_MhSogCow);
			
		reMap.put("insertNum", insertNum);	
		reMap.put("updateNum", updateNum);
		return reMap;
		
	}

}
