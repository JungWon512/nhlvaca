package com.auc.lalm.sy.controller;

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
import com.auc.lalm.sy.service.LALM0837Service;

@RestController
public class LALM0837Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0837Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0837Service lalm0837Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0837_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0834_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0837Service.LALM0837_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0837_selUsrList", method=RequestMethod.POST)
	public Map<String, Object> LALM0837_selUsrList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0837Service.LALM0837_selUsrList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
}
