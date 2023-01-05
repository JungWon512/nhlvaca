package com.auc.lalm.sy.controller;


import java.util.HashMap;
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
import com.auc.lalm.sy.service.LALM0833Service;

@RestController
public class LALM0833Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0833Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0833Service lalm0833Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_selGrpCode", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_selGrpCode(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0833Service.LALM0833_selGrpCode(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_selUsrList", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_selUsrList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0833Service.LALM0833_selUsrList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0833Service.LALM0833_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_insUsr", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_insUsr(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> tempMap   = new HashMap<String, Object>();

		tempMap.put("usrid", map.get("de_usrid"));
		List<Map<String, Object>> selgrpUsrList = lalm0833Service.LALM0833_selList(tempMap);
		
		if(selgrpUsrList != null && selgrpUsrList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"이미 등록된 사용자입니다.");
		}
		Map<String, Object> inMap = lalm0833Service.LALM0833_insUsr(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_updUsr", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_updUsr(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0833Service.LALM0833_updUsr(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_delUsr", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_delUsr(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0833Service.LALM0833_delUsr(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_selGrpList", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_selGrpList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0833Service.LALM0833_selGrpList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_delGrpList", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_delGrpList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0833Service.LALM0833_delGrpList(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0833_updGrpList", method=RequestMethod.POST)
	public Map<String, Object> LALM0833_updGrpList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		System.out.println(rMap.toString());
		Map<String, Object> inMap = lalm0833Service.LALM0833_updGrpList(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	
	
	
	
	
}
