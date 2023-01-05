package com.auc.lalm.bs.controller;

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
import com.auc.lalm.bs.service.LALM0114Service;

@RestController
public class LALM0114Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0114Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0114Service lalm0114Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0114_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0114_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0114Service.LALM0114_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0114_selIndvDetail", method=RequestMethod.POST)
	public Map<String, Object> LALM0114_selIndvDetail(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm0114Service.LALM0114_selIndvDetail(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetMapData(selMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0114_insIndv", method=RequestMethod.POST)
	public Map<String, Object> LALM0114_insIndv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0114Service.LALM0114_insIndv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0114_updIndv", method=RequestMethod.POST)
	public Map<String, Object> LALM0114_updIndv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0114Service.LALM0114_updIndv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0114_delIndv", method=RequestMethod.POST)
	public Map<String, Object> LALM0114_delIndv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0114Service.LALM0114_delIndv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
}
