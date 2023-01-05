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
import com.auc.lalm.co.service.LALM0126PService;

@RestController
public class LALM0126PController {
	
	private static Logger log = LoggerFactory.getLogger(LALM0126PController.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0126PService lalm0126PService;
	
	@ResponseBody
	@RequestMapping(value="/LALM0126P_selListProv", method=RequestMethod.POST)
	public Map<String, Object> LALM0126P_selListProv(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0126PService.LALM0126P_selListProv(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0126P_selListCcw", method=RequestMethod.POST)
	public Map<String, Object> LALM0126P_selListCcw(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0126PService.LALM0126P_selListCcw(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0126P_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0126P_selList(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0126PService.LALM0126P_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
}
