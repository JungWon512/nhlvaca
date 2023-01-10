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
import com.auc.lalm.ar.service.LALM0215PService;

@RestController
public class LALM0215PController {
	
	private static Logger log = LoggerFactory.getLogger(LALM0215PController.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0215PService lalm0215PService;
		
	@ResponseBody
	@RequestMapping(value="/LALM0215P_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0215P_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0215PService.LALM0215P_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	
	

}
