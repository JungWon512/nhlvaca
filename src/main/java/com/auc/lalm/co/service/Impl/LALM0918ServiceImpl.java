package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0918Service;

@Service("LALM0918Service")
@SuppressWarnings("unchecked")
public class LALM0918ServiceImpl implements LALM0918Service{

	@Autowired
	LALM0918Mapper lalm0918Mapper;
	
	@Autowired
	LALM0912Mapper lalm0912Mapper;	

	@Override
	public List<Map<String, Object>> LALM0918_selData(Map<String, Object> map) throws Exception {
		return lalm0918Mapper.LALM0918_selData(map);
	}
	
	@Override
	public Map<String, Object> LALM0918_selMobileEtc(Map<String, Object> map) throws Exception {
		return lalm0912Mapper.LALM0912_selData(map);
	}
	
	@Override
	public Map<String, Object> LALM0918_updData(Map<String, Object> map) throws Exception {		
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int updateNum = 0;
		
		Iterator<?> iterator = map.entrySet().iterator();
		
		while(iterator.hasNext()) {
			Map<String, Object> tmpMap = new HashMap<String, Object>();
			Entry<String, Object> entry = (Entry<String, Object>) iterator.next();
			
			if (entry.getKey().contains("tab_")) {
				//map을 파라미터로 넣는 작업
				tmpMap.put("ss_na_bzplc", map.get("ss_na_bzplc"));
				tmpMap.put("screen_cd", entry.getKey().replace("tab_","").split("_")[0]); 
				tmpMap.put("item_cd", entry.getKey().replace("tab_","").split("_")[1]); 
				tmpMap.put("visib_yn", (String) entry.getValue()); 
				tmpMap.put("ss_userid", map.get("ss_userid"));				

				updateNum += updateNum + lalm0918Mapper.LALM0918_updData(tmpMap);
			}
		}
		
		// 모바일 간편항목 update
		updateNum += lalm0918Mapper.LALM0918_updMobileEtc(map);
		
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
}
