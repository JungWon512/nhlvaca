package com.auc.lalm.ar.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;

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
import com.auc.lalm.ar.service.LALM0214Service;

@RestController
public class LALM0214Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0211Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0214Service lalm0214Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0214_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0214_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		

		List<Map<String, Object>> aucQcnList = lalm0214Service.LALM0214_selAucQcn(map);
				
		if(aucQcnList.size() < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매차수가 등록되지 않았습니다.");
		}
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0214Service.LALM0214_selList(map);
		
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	

	@ResponseBody
	@RequestMapping(value="/LALM0214_selCalfList", method=RequestMethod.POST)
	public Map<String, Object> LALM0214_selCalfList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0214Service.LALM0214_selCalfList(map);
		
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0214_insFeeReset", method=RequestMethod.POST)
	public Map<String, Object> LALM0214_insFeeReset(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0214Service.LALM0214_insFeeReset(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0214_selFeeImps", method=RequestMethod.POST)
	public Map<String, Object> LALM0214_selFeeImps(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		//xml 조회
		Map<String, Object> result = lalm0214Service.LALM0214_selFeeImps(map);
		
		Map<String, Object> reMap = commonFunc.createResultSetMapData(result); 	
		
		return reMap;
	}
	
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0214_delSogCow", method=RequestMethod.POST)
	public Map<String, Object> LALM0214_delSogCow(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		//xml 조회
		int aucTmsCnt = lalm0214Service.LALM0214_selAucTmsCnt(map);
		
		if(aucTmsCnt > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매낙찰된 출장우 또는 경매전송된 출장우가 있는 경우는<br>전체삭제가 불가합니다.");
		}
		
		Map<String, Object> inMap = lalm0214Service.LALM0214_delSogCow(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0214_delCntnDel", method=RequestMethod.POST)
	public Map<String, Object> LALM0214_delCntnDel(ResolverMap rMap) throws Exception{	
		
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		Map<String, Object> inMap = lalm0214Service.LALM0214_delCntnDel(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0214P1_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P1_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0214Service.LALM0214P1_selList(map);
		
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
		
	@ResponseBody
	@RequestMapping(value="/LALM0214P4_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P4_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map = convertConfig.conMap(rMap);	
		
		
		//xml 조회
		List<Map<String, Object>> reList = lalm0214Service.LALM0214P4_selList(map);
		
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0214P2_updCow", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P2_updCow(ResolverMap rMap) throws Exception{				
				
		
		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lalm0214Service.LALM0214P2_updCow(inList);
		
		
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0214P4_updCowBun", method=RequestMethod.POST)
	public Map<String, Object> LALM0214P4_updCowBun(ResolverMap rMap) throws Exception{				
				
		
		List<Map<String, Object>> inList = convertConfig.conListMap(rMap);
		Map<String, Object> inMap = lalm0214Service.LALM0214P4_updCowBun(inList);
		
		
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	
}
