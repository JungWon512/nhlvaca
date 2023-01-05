package com.auc.lalm.ar.controller;

import java.util.HashMap;
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
import com.auc.lalm.ar.service.LALM0219Service;

@RestController
public class LALM0219Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0219Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0219Service lalm0219Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0219_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0219_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0219Service.LALM0219_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}

	@ResponseBody
	@RequestMapping(value="/LALM0219_updSogCowSq", method=RequestMethod.POST)
	public Map<String, Object> LALM0219_updSogCowSq(ResolverMap rMap) throws Exception{				
				
		
		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lalm0219Service.LALM0219_updSogCowSq(inList);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}	
	


	@ResponseBody
	@RequestMapping(value="/LALM0219P1_updExcelUpload", method=RequestMethod.POST)
	public Map<String, Object> LALM0219P1_updExcelUpload(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> map = convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap = lalm0219Service.LALM0219P1_updExcelUpload(map);
		reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}	
	

}
