package com.auc.lalm.ls.controller;

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
import com.auc.lalm.ls.service.LALM1008Service;

@RestController
public class LALM1008Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM1008Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1008Service lalm1008Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM1008_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM1008_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm1008Service.LALM1008_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}

	@ResponseBody
	@RequestMapping(value="/LALM1008_updFirstBatPrice", method=RequestMethod.POST)
	public Map<String, Object> LALM1008_updFirstBatPrice(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm1008Service.LALM1008_updFirstBatPrice(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1008_updBatPrice", method=RequestMethod.POST)
	public Map<String, Object> LALM1008_updBatPrice(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm1008Service.LALM1008_updBatPrice(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1008_updConti", method=RequestMethod.POST)
	public Map<String, Object> LALM1008_updConti(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm1008Service.LALM1008_updConti(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	

}
