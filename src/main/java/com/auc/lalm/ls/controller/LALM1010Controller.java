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
import com.auc.lalm.ls.service.LALM1010Service;

@RestController
public class LALM1010Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM1010Controller.class);
	
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1010Service lalm1010Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM1010_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM1010_selList(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		//xml 조회
		
		List<Map<String,Object>> reList = lalm1010Service.LALM1010_selList(map);
		Map<String,Object>reMap = commonFunc.createResultSetListData(reList);
		
	
		
		return reMap;
	}
	
	
	  @ResponseBody
	  @RequestMapping(value="/LALM1010_selList_2", method=RequestMethod.POST)
	  public Map<String, Object> LALM1010_selList_2(ResolverMap rMap) throws
	  Exception{
	  
	  Map<String, Object> map = convertConfig.conMap(rMap); //xml 조회
	  
	  List<Map<String,Object>> reList = lalm1010Service.LALM1010_selList_2(map);
	  Map<String,Object>reMap = commonFunc.createResultSetListData(reList);
	  
	  
	  
	  return reMap; 
	  }
	  
	  @ResponseBody
	  
	  @RequestMapping(value="/LALM1010_selList_3", method=RequestMethod.POST)
	  public Map<String, Object> LALM1010_selList_3(ResolverMap rMap) throws Exception{
	  
	  Map<String, Object> map = convertConfig.conMap(rMap); //xml 조회
	  
	  List<Map<String,Object>> reList =
	  lalm1010Service.LALM1010_selList_3(map); Map<String,Object>reMap =
	  commonFunc.createResultSetListData(reList);
	  
	  
	  
	  return reMap;
	  }
	  
	  @ResponseBody
	  
	  @RequestMapping(value="/LALM1010_selList_4", method=RequestMethod.POST)
	  public Map<String, Object> LALM1010_selList_4(ResolverMap rMap) throws
	  Exception{
	  
	  Map<String, Object> map = convertConfig.conMap(rMap); //xml 조회
	  
	  List<Map<String,Object>> reList =
	  lalm1010Service.LALM1010_selList_4(map); Map<String,Object>reMap =
	  commonFunc.createResultSetListData(reList);
	  
	  
	  
	  return reMap; }
	 
}
