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
import com.auc.lalm.co.service.LALM0221PService;

@RestController
public class LALM0221PController {
	
	private static Logger log = LoggerFactory.getLogger(LALM0221PController.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0221PService lalm0221PService;
		
	@ResponseBody
	@RequestMapping(value="/LALM0221P_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0221P_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0221PService.LALM0221P_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	
	

}
