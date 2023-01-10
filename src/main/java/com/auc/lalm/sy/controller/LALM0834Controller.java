package com.auc.lalm.sy.controller;

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
import com.auc.lalm.sy.service.LALM0834Service;

@RestController
public class LALM0834Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0834Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0834Service lalm0834Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0834_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0834_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0834Service.LALM0834_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	

	@ResponseBody
	@RequestMapping(value="/LALM0834_insList", method=RequestMethod.POST)
	public Map<String, Object> LALM0834_insList(ResolverMap rMap) throws Exception{	
		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lalm0834Service.LALM0834_insList(inList);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}

	
	
	
	
}
