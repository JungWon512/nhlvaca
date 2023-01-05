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
import com.auc.lalm.ab.service.LALM0311Service;

@RestController
public class LALM0311Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0311Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0311Service lalm0311Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0311_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0311_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0311Service.LALM0311_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0311_selModlList", method=RequestMethod.POST)
	public Map<String, Object> LALM0311_selModlList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0311Service.LALM0311_selModlList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0311_updModlPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0311_updModlPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0311Service.LALM0311_updModlPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0311_updRmkPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0311_updRmkPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0311Service.LALM0311_updRmkPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0311_updPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0311_updPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0311Service.LALM0311_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	

}
