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
import com.auc.lalm.sy.service.LALM0834Service;
import com.auc.lalm.sy.service.LALM0838Service;
import com.auc.main.service.MainService;

@RestController
public class LALM0838Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0838Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0838Service lalm0838Service;
	@Autowired
	MainService mainService;	
	
	@ResponseBody
	@RequestMapping(value="/LALM0838_selNaList", method=RequestMethod.POST)
	public Map<String, Object> LALM0838_selNaList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> naList = mainService.selectNaList();
		Map<String, Object> reMap        = commonFunc.createResultSetListData(naList); 			
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0838_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0834_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0838Service.LALM0838_selList(map);
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
}
