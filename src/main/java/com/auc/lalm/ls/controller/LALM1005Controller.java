package com.auc.lalm.ls.controller;

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
import com.auc.lalm.ls.service.LALM1005Service;

@RestController
public class LALM1005Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM1005Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1005Service lalm1005Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM1005_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM1005_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm1005Service.LALM1005_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1005_selModlList", method=RequestMethod.POST)
	public Map<String, Object> LALM1005_selModlList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm1005Service.LALM1005_selModlList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1005_updModlPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM1005_updModlPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1005Service.LALM1005_updModlPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1005_updRmkPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM1005_updRmkPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1005Service.LALM1005_updRmkPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1005_updPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM1005_updPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1005Service.LALM1005_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1005_updPgmOnlySave", method=RequestMethod.POST)
	public Map<String, Object> LALM1005_updPgmOnlySave(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1005Service.LALM1005_updPgmOnlySave(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	

}
