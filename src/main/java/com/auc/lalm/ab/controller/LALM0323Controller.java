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
import com.auc.lalm.ab.service.LALM0323Service;

@RestController
public class LALM0323Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0323Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0323Service lalm0323Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0323_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0323_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0323Service.LALM0323_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0323_updBatPrice", method=RequestMethod.POST)
	public Map<String, Object> LALM0323_updBatPrice(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0323Service.LALM0323_updBatPrice(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0323_updConti", method=RequestMethod.POST)
	public Map<String, Object> LALM0323_updConti(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0323Service.LALM0323_updConti(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	
		
	@ResponseBody
	@RequestMapping(value="/LALM0323P_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0323P_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0323Service.LALM0323P_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	
	

}
