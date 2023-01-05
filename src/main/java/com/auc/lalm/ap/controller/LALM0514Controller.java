package com.auc.lalm.ap.controller;

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
import com.auc.lalm.ap.service.LALM0514Service;

@RestController
public class LALM0514Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0514Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0514Service lalm0514Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0514_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0514_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0514Service.LALM0514_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	

}
