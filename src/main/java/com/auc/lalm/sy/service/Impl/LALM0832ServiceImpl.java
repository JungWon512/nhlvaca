package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.auc.lalm.sy.service.LALM0832Service;

@Service("LALM0832Service")
public class LALM0832ServiceImpl implements LALM0832Service{

	@Autowired
	LALM0832Mapper lalm0832Mapper;	

	@Override
	public List<Map<String, Object>> LALM0832_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0832Mapper.LALM0832_selList(map);
		return list;		
	}

	@Override
	public List<Map<String, Object>> LALM0832_selBtnList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0832Mapper.LALM0832_selBtnList(map);
		return list;		
	}

	@Override
	public Map<String, Object> LALM0832_insPgm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int isertNum = 0;
		//프로그램 DB 저장
		isertNum = lalm0832Mapper.LALM0832_insPgm(map);		
		reMap.put("insertNum", isertNum);
		
		if(isertNum > 0) {			
			Map<String, Object> btnMap = new HashMap<String, Object>();			
			//프로그램 Btn 저장
			for(int k = 0; k < 8; k++) {
				btnMap.clear();
				btnMap.put("pgid", map.get("de_pgid"));
				btnMap.put("btn_c", String.format("%03d", k+1));				
				switch(k+1) {
					case 1 : btnMap.put("btn_tpc", "A"); break;
					case 2 : btnMap.put("btn_tpc", "R"); break;
					case 3 : btnMap.put("btn_tpc", "A"); break;
					case 4 : btnMap.put("btn_tpc", "C"); break;
					case 5 : btnMap.put("btn_tpc", "U"); break;
					case 6 : btnMap.put("btn_tpc", "D"); break;
					case 7 : btnMap.put("btn_tpc", "X"); break;
					case 8 : btnMap.put("btn_tpc", "P"); break;
				}								
				btnMap.put("ss_userid", map.get("ss_userid"));				
				isertNum = lalm0832Mapper.LALM0832_insPgmBtn(btnMap);
			}			
		}		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0832_updPgm(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		//프로그램 DB 저장
		updateNum = lalm0832Mapper.LALM0832_updPgm(map);		
		reMap.put("updateNum", updateNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0832_delPgm(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		//프로그램 DB 저장
		deleteNum = lalm0832Mapper.LALM0832_delPgm(map);		
		reMap.put("deleteNum", deleteNum);		
		if(deleteNum > 0) {			
			deleteNum = lalm0832Mapper.LALM0832_delPgmBtn(map);
		}		
		return reMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> LALM0832_updPgmBtn(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		List<Map<String, Object>> updList = (List<Map<String, Object>>) map.get("data");
		Map<String, Object> inMap = null;
		
		for(int i = 0; i < updList.size(); i++) {
			inMap = updList.get(i);			
			updateNum += lalm0832Mapper.LALM0832_updPgmBtn(inMap);
		}
		
		reMap.put("updateNum", updateNum);
		return reMap;
	}

}
