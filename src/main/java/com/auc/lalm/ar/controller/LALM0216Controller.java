package com.auc.lalm.ar.controller;

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
import com.auc.lalm.ar.service.LALM0216Service;

@RestController
public class LALM0216Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0216Controller.class);
	
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0216Service lalm0216Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0216_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0216_selList(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		//xml 조회
		
		List<Map<String,Object>> reList = lalm0216Service.LALM0216_selList(map);
		Map<String,Object>reMap = commonFunc.createResultSetListData(reList);
		
	
		
		return reMap;
	}
	
	
	  @ResponseBody
	  @RequestMapping(value="/LALM0216_selList_2", method=RequestMethod.POST)
	  public Map<String, Object> LALM0216_selList_2(ResolverMap rMap) throws
	  Exception{
	  
	  Map<String, Object> map = convertConfig.conMap(rMap); //xml 조회
	  
	  List<Map<String,Object>> reList = lalm0216Service.LALM0216_selList_2(map);
	  Map<String,Object>reMap = commonFunc.createResultSetListData(reList);
	  
	  
	  
	  return reMap; 
	  }
	  
	  @ResponseBody
	  
	  @RequestMapping(value="/LALM0216_selList_3", method=RequestMethod.POST)
	  public Map<String, Object> LALM0216_selList_3(ResolverMap rMap) throws Exception{
	  
	  Map<String, Object> map = convertConfig.conMap(rMap); //xml 조회
	  
	  List<Map<String,Object>> reList =
	  lalm0216Service.LALM0216_selList_3(map); Map<String,Object>reMap =
	  commonFunc.createResultSetListData(reList);
	  
	  
	  
	  return reMap;
	  }
	  
	  @ResponseBody
	  
	  @RequestMapping(value="/LALM0216_selList_4", method=RequestMethod.POST)
	  public Map<String, Object> LALM0216_selList_4(ResolverMap rMap) throws
	  Exception{
	  
	  Map<String, Object> map = convertConfig.conMap(rMap); //xml 조회
	  
	  List<Map<String,Object>> reList =
	  lalm0216Service.LALM0216_selList_4(map); Map<String,Object>reMap =
	  commonFunc.createResultSetListData(reList);
	  
	  
	  
	  return reMap; }
	 
}
