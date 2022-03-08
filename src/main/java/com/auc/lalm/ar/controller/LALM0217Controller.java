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
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ar.service.LALM0217Service;

@RestController
public class LALM0217Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0217Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0217Service lalm0217Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0217_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0217_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0217Service.LALM0217_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0217_selAucStn", method=RequestMethod.POST)
	public Map<String, Object> LALM0217_selAucStn(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		List<Map<String, Object>> reList = lalm0217Service.LALM0217_selAucStn(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	

	@ResponseBody
	@RequestMapping(value="/LALM0217_insPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0217_insPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		
		List<Map<String, Object>> qcnList = lalm0217Service.LALM0217_selQcn(map);
		
		int qcn = Integer.parseInt(qcnList.get(0).get("CNT").toString());
		
		if(qcn < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매차수 정보가 존재하지 않습니다. 확인하세요 !!.");
		}
		
		Map<String, Object> inMap = lalm0217Service.LALM0217_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0217_updPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0217_updPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);		
		Map<String, Object> inMap = lalm0217Service.LALM0217_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0217_delPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0217_delPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);		
		Map<String, Object> inMap = lalm0217Service.LALM0217_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}		
	
	
	
	

}
