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
import com.auc.lalm.ab.service.LALM0313Service;

@RestController
public class LALM0313Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0313Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0313Service lalm0313Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0313_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0313_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0313Service.LALM0313_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0313_insList", method=RequestMethod.POST)
	public Map<String, Object> LALM0313_insList(ResolverMap rMap) throws Exception{	
		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lalm0313Service.LALM0313_insList(inList);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	
}
