package com.auc.lalm.sy.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.codehaus.jettison.json.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.config.CriptoConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.sy.service.LALM0831Service;

@RestController
public class LALM0831Controller {

	private static Logger log = LoggerFactory.getLogger(LALM0831Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0831Service lalm0831Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0831_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0831_selList(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map          = convertConfig.conMap(rMap);						
		List<Map<String, Object>> reList = lalm0831Service.LALM0831_selList();		
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0831_insMenu", method=RequestMethod.POST)
	public Map<String, Object> LALM0831_insMenu(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0831Service.LALM0831_insMenu(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0831_updMenu", method=RequestMethod.POST)
	public Map<String, Object> LALM0831_updMenu(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0831Service.LALM0831_updMenu(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0831_delMenu", method=RequestMethod.POST)
	public Map<String, Object> LALM0831_delMenu(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0831Service.LALM0831_delMenu(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;
	}	
	
	
	
}
