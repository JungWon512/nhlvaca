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
import com.auc.lalm.bs.service.LALM0113Service;

@RestController
public class LALM0113Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0113Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0113Service lalm0113Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0113_selListGrd_MmMwmn", method=RequestMethod.POST)
	public Map<String, Object> LALM0113_selListGrd_MmMwmn(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0113Service.LALM0113_selListGrd_MmMwmn(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0113_selDetail", method=RequestMethod.POST)
	public Map<String, Object> LALM0113_selDetail(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm0113Service.LALM0113_selDetail(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetMapData(selMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0113_insTrmn", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_insRv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0113Service.LALM0113_insTrmn(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0113_updTrmn", method=RequestMethod.POST)
	public Map<String, Object> LALM0113_updTrmn(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0113Service.LALM0113_updTrmn(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0113_delTrmn", method=RequestMethod.POST)
	public Map<String, Object> LALM0113_delTrmn(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0113Service.LALM0113_delTrmn(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	
}
