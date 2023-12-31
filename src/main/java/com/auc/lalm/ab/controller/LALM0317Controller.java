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
import com.auc.lalm.ab.service.LALM0317Service;

@RestController
public class LALM0317Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0317Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0317Service lalm0317Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0317_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0317_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0317Service.LALM0317_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}

	@ResponseBody
	@RequestMapping(value="/LALM0317_updFirstBatPrice", method=RequestMethod.POST)
	public Map<String, Object> LALM0317_updFirstBatPrice(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0317Service.LALM0317_updFirstBatPrice(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0317_updBatPrice", method=RequestMethod.POST)
	public Map<String, Object> LALM0317_updBatPrice(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0317Service.LALM0317_updBatPrice(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0317_updConti", method=RequestMethod.POST)
	public Map<String, Object> LALM0317_updConti(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0317Service.LALM0317_updConti(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	

}
