package com.auc.lalm.co.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.co.service.LALM0222PService;

@RestController
public class LALM0222PController {
	
	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0222PService lalm0222PService;
		
	@ResponseBody
	@RequestMapping(value="/LALM0222P_updReturnValue", method=RequestMethod.POST)
	public Map<String, Object> LALM0222P_updReturnValue(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0222PService.LALM0222P_updReturnValue(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
		
	}
	
	

}
