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
import com.auc.lalm.sy.service.LALM0839Service;

@RestController
public class LALM0839Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0839Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0839Service lalm0839Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0839_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0839_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0839Service.LALM0839_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
}
