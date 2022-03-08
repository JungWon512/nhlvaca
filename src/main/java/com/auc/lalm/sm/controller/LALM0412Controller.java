package com.auc.lalm.sm.controller;

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
import com.auc.lalm.sm.service.LALM0412Service;

@RestController
public class LALM0412Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0412Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0412Service lalm0412Service;
	
	
	
	@ResponseBody
	@RequestMapping(value="/Lalm0412_selList_MhAucQcn", method=RequestMethod.POST)
	public Map<String, Object> Lalm0412_selList_MhAucQcn(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.Lalm0412_selList_MhAucQcn(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListTbl_Mmmwmn", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListTbl_Mmmwmn(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListTbl_Mmmwmn(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListGrd_MhSogCow", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListGrd_MhSogCow(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListGrd_MhSogCow(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListGrd_MhSogCowF", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListGrd_MhSogCowF(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListGrd_MhSogCowF(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListGrd_MhSogCowM", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListGrd_MhSogCowM(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListGrd_MhSogCowM(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListGrd_MdMwmnAdj", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListGrd_MdMwmnAdj(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListGrd_MdMwmnAdj(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListFrm_MdMwmnAdj", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListFrm_MdMwmnAdj(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListFrm_MdMwmnAdj(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListFrm_MdMwmnAdj_f", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListFrm_MdMwmnAdj_f(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListFrm_MdMwmnAdj_f(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selListFrm_MdMwmnAdj_m", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selListFrm_MdMwmnAdj_m(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0412Service.LALM0412_selListFrm_MdMwmnAdj_m(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selAucEntr", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selAucEntr(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm0412Service.LALM0412_selAucEntr(map);
		Map<String, Object> reMap  = commonFunc.createResultSetMapData(selMap);		
		return reMap;		
	}		
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_updEntrGive", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_updEntrGive(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0412Service.LALM0412_updEntrGive(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_updEntrTake", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_updEntrTake(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0412Service.LALM0412_updEntrTake(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_insRv", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_insRv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0412Service.LALM0412_insRv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_updRv", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_updRv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0412Service.LALM0412_updRv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_delRv", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_delRv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0412Service.LALM0412_delRv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_selRmkcntn", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_selRmkcntn(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0412Service.LALM0412_selRmkcntn(map);
		Map<String, Object> reMap = commonFunc.createResultSetMapData(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0412_insAdj", method=RequestMethod.POST)
	public Map<String, Object> LALM0412_insAdj(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0412Service.LALM0412_insAdj(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	

}
