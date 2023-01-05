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
import com.auc.lalm.bs.service.LALM0118Service;

@RestController
public class LALM0118Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0118Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0118Service lalm0118Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0118_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0118_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0118Service.LALM0118_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0118_selBlackDetail", method=RequestMethod.POST)
	public Map<String, Object> LALM0118_selBlackDetail(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm0118Service.LALM0118_selBlackDetail(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetMapData(selMap);		
		return reMap;
	}	

	@ResponseBody
	@RequestMapping(value="/LALM0118_insBlackList", method=RequestMethod.POST)
	public Map<String, Object> LALM0118_insBlackList(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0118Service.LALM0118_insBlackList(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0118_delBlack", method=RequestMethod.POST)
	public Map<String, Object> LALM0118_delBlack(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0118Service.LALM0118_delBlack(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0118_selBzplcloc", method=RequestMethod.POST)
	public Map<String, Object> LALM0118_selBzplcloc(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		List<Map<String, Object>> bzplcList = lalm0118Service.LALM0118_selBzplcLoc(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(bzplcList);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0118_selClntnm", method=RequestMethod.POST)
	public Map<String, Object> LALM0118_selClntnm(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		List<Map<String, Object>> clntList = lalm0118Service.LALM0118_selClntnm(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(clntList);		
		return reMap;			
	}	
}
