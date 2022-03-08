package com.auc.lalm.bs.controller;

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
import com.auc.lalm.bs.service.LALM0111Service;
import com.auc.mca.McaUtil;

@RestController
public class LALM0111Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0111Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0111Service lalm0111Service;
	@Autowired
	McaUtil mcaUtil;
	
	@ResponseBody
	@RequestMapping(value="/LALM0111_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0111_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0111Service.LALM0111_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0111_selDetail", method=RequestMethod.POST)
	public Map<String, Object> LALM0111_selDetail(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm0111Service.LALM0111_selDetail(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetMapData(selMap); 			
		return reMap;
	}	


	@ResponseBody
	@RequestMapping(value="/LALM0111_insFarm", method=RequestMethod.POST)
	public Map<String, Object> LALM0111_insFarm(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0111Service.LALM0111_insFarm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0111_updFarm", method=RequestMethod.POST)
	public Map<String, Object> LALM0111_updFarm(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0111Service.LALM0111_updFarm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0111_updFhsAnw", method=RequestMethod.POST)
	public Map<String, Object> LALM0111_updFhsAnw(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm0111Service.LALM0111_selFhsAnw(map);
		Map<String, Object> mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
		Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
		Map<String, Object> reMap = commonFunc.createResultSetMapData(dataMap);
		return reMap;			
	}

	@ResponseBody
	@RequestMapping(value="/LALM0111_delFhs", method=RequestMethod.POST)
	public Map<String, Object> LALM0111_delFhs(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0111Service.LALM0111_delFhs(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}
	
	
	
	
}
