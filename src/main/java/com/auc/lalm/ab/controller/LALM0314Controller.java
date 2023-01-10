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
import com.auc.lalm.ab.service.LALM0314Service;

@RestController
public class LALM0314Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0314Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0314Service lalm0314Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0314_selList_simp", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selList_simp(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selList_simp(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_selSogCow1List", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selSogCow1List(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selSogCow1List(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_selSogCow2List", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selSogCow2List(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selSogCow2List(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_selSogCow3List", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selSogCow3List(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selSogCow3List(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_selSogCow4List", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selSogCow4List(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selSogCow4List(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_selSogCow5List", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selSogCow5List(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selSogCow5List(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_selAucQcnList", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_selAucQcnList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0314Service.LALM0314_selAucQcnList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0314_updDdlQcn", method=RequestMethod.POST)
	public Map<String, Object> LALM0314_updDdlQcn(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		Map<String, Object> inMap = lalm0314Service.LALM0314_updDdlQcn(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	
}
