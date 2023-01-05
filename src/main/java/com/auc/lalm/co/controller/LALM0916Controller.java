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
import com.auc.lalm.co.service.LALM0916Service;

@RestController
public class LALM0916Controller {
	
	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0916Service lalm0916Service;
	
	
		
	@ResponseBody
	@RequestMapping(value="/LALM0916_selPw", method=RequestMethod.POST)
	public Map<String, Object> LALM0916_selPw(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		Map<String, Object> outMap = lalm0916Service.LALM0916_selPw(map);				
		Map<String, Object> reMap = commonFunc.createResultSetMapData(outMap); 	
		
		return reMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0916_updPw", method=RequestMethod.POST)
	public Map<String, Object> LALM0916_updPw(ResolverMap rMap) throws Exception{	
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0916Service.LALM0916_updPw(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	

}
