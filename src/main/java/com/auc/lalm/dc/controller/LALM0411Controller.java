package com.auc.lalm.dc.controller;

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
import com.auc.lalm.dc.service.LALM0411Service;
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.main.service.LogService;

@RestController
public class LALM0411Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0411Controller.class);
	
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LogService logService;
	@Autowired
	LALM0899Service lalm0899Service;
	@Autowired
	LALM0411Service lalm0411Service; 
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updMwmn", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updMwmn(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca1300(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updMwmn(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updAucQcn", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updAucQcn(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca1900(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updAucQcn(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updMwmnAdj", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updMwmnAdj(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca2000(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updMwmnAdj(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updMwmnEntr", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updMwmnEntr(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca2700(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updMwmnEntr(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updRkonCm", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updRkonCm(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca3500(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updRkonCm(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_selChkSogCow", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_selChkSogCow(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> chkMap        = lalm0411Service.LALM0411_selChkSogCow(map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(chkMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updSogCow", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updSogCow(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca1600(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.updSogCowLog(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updSogCowFee", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updSogCowFee(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca3900(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updSogCowFee(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updSogCowCalf", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updSogCowCalf(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca3700(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updSogCowCalf(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_updAtdrLog", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_updAtdrLog(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		Map<String, Object> insMap        = lalm0899Service.LALM0899_selMca2100(map);
		List<Map<String, Object>> insList = (List<Map<String, Object>>) insMap.get("RPT_DATA");
		Map<String, Object> inMap         = lalm0411Service.LALM0411_updAtdrLog(insList, map);
		Map<String, Object> reMap         = commonFunc.createResultCUD(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0411_selFhsInfo", method=RequestMethod.POST)
	public Map<String, Object> LALM0411_selFhsInfo(ResolverMap rMap) throws Exception{
		Map<String, Object> map           = convertConfig.conMap(rMap);
		List<Map<String, Object>> list    = lalm0411Service.LALM0411_selFhsInfo(map);
		Map<String, Object> reMap         = commonFunc.createResultSetListData(list);		
		return reMap;
	}
	

}
