package com.auc.lalm.ls.controller;

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
import com.auc.lalm.ls.service.LALM1007Service;

@RestController
public class LALM1007Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM1007Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM1007Service lalm1007Service;
	
	
	
	@ResponseBody
	@RequestMapping(value="/Lalm1007_selList_MhAucQcn", method=RequestMethod.POST)
	public Map<String, Object> Lalm1007_selList_MhAucQcn(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.Lalm1007_selList_MhAucQcn(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListTbl_Mmmwmn", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListTbl_Mmmwmn(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListTbl_Mmmwmn(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListGrd_MhSogCow", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListGrd_MhSogCow(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListGrd_MhSogCow(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListGrd_MhSogCowF", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListGrd_MhSogCowF(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListGrd_MhSogCowF(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListGrd_MhSogCowM", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListGrd_MhSogCowM(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListGrd_MhSogCowM(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListGrd_MdMwmnAdj", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListGrd_MdMwmnAdj(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListGrd_MdMwmnAdj(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListFrm_MdMwmnAdj", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListFrm_MdMwmnAdj(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListFrm_MdMwmnAdj(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListFrm_MdMwmnAdj_f", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListFrm_MdMwmnAdj_f(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListFrm_MdMwmnAdj_f(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selListFrm_MdMwmnAdj_m", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selListFrm_MdMwmnAdj_m(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm1007Service.LALM1007_selListFrm_MdMwmnAdj_m(map);				
		Map<String, Object> reMap  = commonFunc.createResultSetListData(reList);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selAucEntr", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selAucEntr(ResolverMap rMap) throws Exception{	
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> selMap = lalm1007Service.LALM1007_selAucEntr(map);
		Map<String, Object> reMap  = commonFunc.createResultSetMapData(selMap);		
		return reMap;		
	}		
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_updEntrGive", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_updEntrGive(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_updEntrGive(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_updEntrTake", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_updEntrTake(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_updEntrTake(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;			
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_insRv", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_insRv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_insRv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_updRv", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_updRv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_updRv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_delRv", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_delRv(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_delRv(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_selRmkcntn", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_selRmkcntn(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_selRmkcntn(map);
		Map<String, Object> reMap = commonFunc.createResultSetMapData(inMap);		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_insAdj", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_insAdj(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_insAdj(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/LALM1007_updAucEntrDdl", method=RequestMethod.POST)
	public Map<String, Object> LALM1007_updAucEntrDdl(ResolverMap rMap) throws Exception{
		Map<String, Object> map   = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm1007Service.LALM1007_updAucEntrDdl(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);		
		return reMap;
	}	

}
