package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
		
		return reMap;
	}	

	

	
}
