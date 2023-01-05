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
import com.auc.lalm.co.service.LALM0913Service;

@RestController
public class LALM0913Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0913Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0913Service lalm0913Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0913_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0913_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> list = lalm0913Service.LALM0913_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(list); 	
		
		return reMap;
	}
		
	@ResponseBody
	@RequestMapping(value="/LALM0913_selUser", method=RequestMethod.POST)
	public Map<String, Object> LALM0913_selUser(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		Map<String, Object> outMap = lalm0913Service.LALM0913_selUser(map);				
		Map<String, Object> reMap = commonFunc.createResultSetMapData(outMap); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0913_insUser", method=RequestMethod.POST)
	public Map<String, Object> LALM0913_insUser(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0913Service.LALM0913_insUser(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0913_updUser", method=RequestMethod.POST)
	public Map<String, Object> LALM0913_updUser(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0913Service.LALM0913_updUser(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0913_delUser", method=RequestMethod.POST)
	public Map<String, Object> LALM0913_delUser(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0913Service.LALM0913_delUser(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	

}
