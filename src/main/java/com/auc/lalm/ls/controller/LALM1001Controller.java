package com.auc.lalm.ls.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ls.service.LALM1001Service;

@RestController
public class LALM1001Controller {
	
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1001Service lalm0114Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM1001_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM1001_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0114Service.LALM1001_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1001_selIndvDetail", method=RequestMethod.POST)
	public Map<String, Object> LALM1001_selIndvDetail(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm0114Service.LALM1001_selIndvDetail(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetMapData(selMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1001_insIndv", method=RequestMethod.POST)
	public Map<String, Object> LALM1001_insIndv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0114Service.LALM1001_insIndv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1001_updIndv", method=RequestMethod.POST)
	public Map<String, Object> LALM1001_updIndv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0114Service.LALM1001_updIndv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1001_delIndv", method=RequestMethod.POST)
	public Map<String, Object> LALM1001_delIndv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0114Service.LALM1001_delIndv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
}
