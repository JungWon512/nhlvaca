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
import com.auc.lalm.ar.service.LALM0228Service;

@RestController
public class LALM0228Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0228Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0228Service lalm0228Service;
	
	/**
	 * 알람톡 발송 로그 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0228_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0228_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0228Service.LALM0228_selAlarmList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}
}
