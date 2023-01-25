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
import com.auc.lalm.co.service.LALM0919Service;

@RestController
public class LALM0919Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0919Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0919Service lalm0919Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0919_selMhSogCowStaticsList", method=RequestMethod.POST)
	public Map<String, Object> LALM0919_selMhSogCowStaticsList(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> outMap = lalm0919Service.LALM0919_selMhSogCowStaticsList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(outMap); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0919_selMhSogCowRowDataList", method=RequestMethod.POST)
	public Map<String, Object> LALM0919_selMhSogCowRowDataList(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> outMap = lalm0919Service.LALM0919_selMhSogCowRowDataList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(outMap); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0919_selCowList", method=RequestMethod.POST)
	public Map<String, Object> LALM0919_selCowList(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> outMap = lalm0919Service.LALM0919_selCowList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(outMap); 	
		
		return reMap;
	}
	
	@Deprecated
	@ResponseBody
	@RequestMapping(value="/LALM0919_selMhSogCowCntList", method=RequestMethod.POST)
	public Map<String, Object> LALM0919_selMhSogCowCntList(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> outMap = lalm0919Service.LALM0919_selMhSogCowCntList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(outMap); 	
		
		return reMap;
	}
	
	@Deprecated
	@ResponseBody
	@RequestMapping(value="/LALM0919_selMhSogCowPriceList", method=RequestMethod.POST)
	public Map<String, Object> LALM0919_selMhSogCowPriceList(ResolverMap rMap) throws Exception{				
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> outMap = lalm0919Service.LALM0919_selMhSogCowPriceList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(outMap); 	
		
		return reMap;
	}
	
}
