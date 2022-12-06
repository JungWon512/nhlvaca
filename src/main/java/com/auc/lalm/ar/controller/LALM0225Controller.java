package com.auc.lalm.ar.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ar.service.LALM0225Service;

/**
 * 출장우 접수내역 조회
 * @author ishift
 */
@Controller
public class LALM0225Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0220Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	
	@Autowired
	CommonFunc commonFunc;
	
	@Autowired
	LALM0225Service lalm0225Service;
		
	/**
	 * 출장우 접수 리스트
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0225_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0225_selList(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0225Service.LALM0225_selList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		
		return reMap;
	}

}
