package com.auc.lalm.ab.controller;

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
import com.auc.lalm.ab.service.LALM0316Service;


@RestController
public class LALM0316Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0316Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0316Service lalm0316Service;
	
//	@ResponseBody
//	@RequestMapping(value="/Lalm0316_selList_mh_sog_cow", method=RequestMethod.POST)
//	public Map<String, Object> Lalm0316_selList_mh_sog_cow(ResolverMap rMap) throws Exception{				
//		
//		Map<String, Object> map = convertConfig.conMap(rMap);
//		
//		//xml 조회
//		List<Map<String, Object>> reList = lalm0316Service.Lalm0316_selList_mh_sog_cow(map);				
//		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
//		
//		return reMap;
//	}	
		
	@ResponseBody
	@RequestMapping(value="/Lalm0316_selList_MhAucQcn", method=RequestMethod.POST)
	public Map<String, Object> Lalm0316_selList_MhAucQcn(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0316Service.Lalm0316_selList_MhAucQcn(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	@ResponseBody
	@RequestMapping(value="/LALM0316_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0316_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0316Service.LALM0316_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	@ResponseBody
	@RequestMapping(value="/LALM0316_selList2", method=RequestMethod.POST)
	public Map<String, Object> LALM0316_selList2(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0316Service.LALM0316_selList2(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0316_updAtdrLog", method=RequestMethod.POST)
	public Map<String, Object> LALM0316_updAtdrLog(ResolverMap rMap) throws Exception{	
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0316Service.LALM0316_updAtdrLog(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}		
	

}
