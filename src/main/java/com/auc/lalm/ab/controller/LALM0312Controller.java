package com.auc.lalm.ab.controller;

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
import com.auc.lalm.ab.service.LALM0312Service;

@RestController
public class LALM0312Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0312Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0312Service lalm0312Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0312_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0312_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0312Service.LALM0312_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}		
	
	@ResponseBody
	@RequestMapping(value="/LALM0312_updSogCowSjam", method=RequestMethod.POST)
	public Map<String, Object> LALM0312_updSogCowSjam(ResolverMap rMap) throws Exception{				
				
		
		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lalm0312Service.LALM0312_updSogCowSjam(inList);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}	
	

}
