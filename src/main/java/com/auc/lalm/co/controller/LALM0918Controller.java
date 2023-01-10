package com.auc.lalm.co.controller;

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
import com.auc.lalm.co.service.LALM0918Service;

@RestController
public class LALM0918Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0918Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0918Service lalm0918Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0918_selData", method=RequestMethod.POST)
	public Map<String, Object> LALM0918_selData(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> outMap = lalm0918Service.LALM0918_selData(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(outMap); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0918_selMobileEtc", method=RequestMethod.POST)
	public Map<String, Object> LALM0918_selMobileEtc(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		Map<String, Object> outMap = lalm0918Service.LALM0918_selMobileEtc(map);				
		Map<String, Object> reMap = commonFunc.createResultSetMapData(outMap); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0918_updData", method=RequestMethod.POST)
	public Map<String, Object> LALM0918_updData(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0918Service.LALM0918_updData(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
}
