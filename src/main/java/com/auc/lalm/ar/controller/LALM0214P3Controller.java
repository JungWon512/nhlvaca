package com.auc.lalm.ar.controller;

import java.util.List;
import java.util.Map;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ar.service.LALM0214P3Service;

@RestController
public class LALM0214P3Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0214P3Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0214P3Service lalm0214P3Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0214P3_insFhs", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P3Service(ResolverMap rMap) throws Exception{				

		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//Map<String, Object> inMap = lalm0214P3Service.LALM0214P3_insFhs(map);
		//Map<String, Object> reMap = commonFunc.createResultSetMapData(inMap);
		
		//return reMap;
		return null;
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0214P3_insSogCow", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P3_insSogCow(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   	= convertConfig.conMapWithoutXxs(rMap);
		
		Map<String, Object> inMap = lalm0214P3Service.LALM0214P3_insSogCow(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;
		
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/LALM0214P3_selSogCowVaild", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P3_selSogCowVaild(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   	= convertConfig.conMapWithoutXxs(rMap);
		
		Map<String, Object> inMap = lalm0214P3Service.LALM0214P3_selSogCowVaild(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData((List<Map<String, Object>>)inMap.get("resultList"));
		
		return reMap;
		
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/LALM0214P3_selIndvSync", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P3_selIndvSync(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   	= convertConfig.conMapWithoutXxs(rMap);
		
		Map<String, Object> inMap = lalm0214P3Service.LALM0214P3_selIndvSync(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData((List<Map<String, Object>>)inMap.get("resultList"));
		
		return reMap;
		
	}
	
	
}
