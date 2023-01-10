package com.auc.lalm.bs.controller;

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
import com.auc.lalm.bs.service.LALM0117Service;

@RestController
public class LALM0117Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0117Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0117Service lalm0117Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0117_selDormacPreList", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_selDormacPreList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0117Service.LALM0117_selDormacPreList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0117_selDormacUsrList", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_selDormacUsrList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0117Service.LALM0117_selDormacUsrList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0117_updDormcPreClear", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_updDormcPreClear(ResolverMap rMap) throws Exception{
 		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0117Service.LALM0117_updDormcPreClear(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0117_updDormcUsrClear", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_updDormcUsrClear(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0117Service.LALM0117_updDormcUsrClear(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0117_delDormcSelectUser", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_delDormcSelectUser(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0117Service.LALM0117_delDormcSelectUser(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0117_selSecessionAplyUsrList", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_selSecessionAplyUsrList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0117Service.LALM0117_selSecessionAplyUsrList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0117_delSecApplyUserData", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_delSecApplyUserData(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0117Service.LALM0117_delSecApplyUserData(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0117_sendAlimPreDormcUser", method=RequestMethod.POST)
	public Map<String, Object> LALM0117_sendAlimPreDormcUser(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0117Service.LALM0117_sendAlimPreDormcUser(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
}
