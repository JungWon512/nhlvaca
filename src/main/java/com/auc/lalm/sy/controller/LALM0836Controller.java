package com.auc.lalm.sy.controller;

import java.util.List; 
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.sy.service.LALM0836Service;

@RestController
public class LALM0836Controller {

	 private static Logger log = LoggerFactory.getLogger(LALM0836Controller.class);
	 
		@Autowired
		ConvertConfig convertConfig;
		@Autowired
		CommonFunc commonFunc;
		@Autowired
		LALM0836Service lalm0836Service;

		@ResponseBody
		@RequestMapping(value="/LALM0836_selBzplcloc", method=RequestMethod.POST)
		public Map<String, Object> LALM0836_selBzplcloc (ResolverMap rMap) throws Exception {
			Map<String, Object> map           = convertConfig.conMap(rMap);
			List<Map<String, Object>> reList = lalm0836Service.LALM0836_selBzplcloc();
			Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
			return reMap;
		}
		
		@ResponseBody
		@RequestMapping(value="LALM0836_selClntnm", method=RequestMethod.POST)
		public Map<String, Object> LALM0836_selClntnm(ResolverMap rMap ) throws Exception{
			Map<String, Object> map           = convertConfig.conMap(rMap);
			List<Map<String, Object>> reList = lalm0836Service.LALM0836_selClntnm(map);
			Map<String, Object> reMap  = commonFunc.createResultSetListData(reList); 	
			return reMap;
			
		}
		
		@ResponseBody
		@RequestMapping(value="LALM0836_selTelAddress", method=RequestMethod.POST)
		public Map<String, Object> LALM0836_selTelAddress(ResolverMap rMap) throws Exception{
			Map<String, Object> map           = convertConfig.conMap(rMap);
			Map<String, Object>inMap = lalm0836Service.LALM0836_selTelAddress(map);
			Map<String, Object> reMap  = commonFunc.createResultSetMapData(inMap); 	 
			return reMap;
			
		}
		
		@ResponseBody
		@RequestMapping(value="LALM0836_insAucDateInfo", method = RequestMethod.POST)
		public Map<String, Object> LALM0836_insAucDateInfo(ResolverMap rMap) throws Exception {
			Map<String, Object> map           = convertConfig.conMap(rMap);
			Map<String, Object> inMap = lalm0836Service.LALM0836_insAucDateInfo(map); // mainTable
			Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
			return reMap;
		}
		
		@ResponseBody
		@RequestMapping(value="LALM0836_SelAucInfo", method=RequestMethod.POST)
		public Map<String, Object> LALM0836_SelAucInfo(ResolverMap rMap) throws Exception {		
			Map<String, Object> map = convertConfig.conMap(rMap);		
			List<Map<String, Object>> reList = lalm0836Service.LALM0836_SelAucInfo(map);
			Map<String, Object> reMap = commonFunc.createResultSetListData(reList);	
			return reMap; 
		
		}
		
		@ResponseBody
		@RequestMapping(value="LALM0836_selAucDateInfo", method=RequestMethod.POST)
		public Map<String, Object> LALM0836_selAucDateInfo (ResolverMap rMap) throws Exception {
			Map<String, Object> map = convertConfig.conMap(rMap);		
			Map<String, Object> inMap = lalm0836Service.LALM0836_selAucDateInfo(map);
			Map<String, Object> reMap = commonFunc.createResultSetMapData(inMap);
			return reMap;
		}
	 
		@ResponseBody
		@RequestMapping(value="LALM0836_delAucDateInfo", method = RequestMethod.POST)
		public Map<String, Object> LALM0836_delAucDateInfo (ResolverMap rMap) throws	Exception {
			Map<String, Object> map = convertConfig.conMap(rMap);		
			Map<String, Object> inMap = lalm0836Service.LALM0836_delAucDateInfo(map);
			Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
			return reMap; 
		}
	 
}
