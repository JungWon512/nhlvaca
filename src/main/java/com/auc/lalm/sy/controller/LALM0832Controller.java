package com.auc.lalm.sy.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Workbook;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.config.CriptoConfig;
import com.auc.common.exception.ErrorCode;
import com.auc.common.vo.JwtUser;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.sy.service.LALM0832Service;

@RestController
public class LALM0832Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0832Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0832Service lalm0832Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0832_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0832_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0832Service.LALM0832_selList(map);
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0832_selBtnList", method=RequestMethod.POST)
	public Map<String, Object> LALM0832_selBtnList(ResolverMap rMap) throws Exception{
		Map<String, Object> map          = convertConfig.conMap(rMap);	
		List<Map<String, Object>> reList = lalm0832Service.LALM0832_selBtnList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;		
	}	
		
	@ResponseBody
	@RequestMapping(value="/LALM0832_insPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0832_insPgm(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0832Service.LALM0832_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;		
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0832_updPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0832_updPgm(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0832Service.LALM0832_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0832_delPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0832_delPgm(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0832Service.LALM0832_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0832_updPgmBtn", method=RequestMethod.POST)
	public Map<String, Object> LALM0832_updPgmBtn(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0832Service.LALM0832_updPgmBtn(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}

}
