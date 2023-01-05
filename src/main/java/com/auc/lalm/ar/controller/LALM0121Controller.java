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
import com.auc.lalm.ar.service.LALM0121Service;

@RestController
public class LALM0121Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0121Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0121Service lalm0121Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0121_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0121_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0121Service.LALM0121_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0121_selLmtaComboList", method=RequestMethod.POST)
	public Map<String, Object> LALM0121_selLmtaComboList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0121Service.LALM0121_selLmtaComboList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	

	@ResponseBody
	@RequestMapping(value="/LALM0121_insPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0121_insPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		
		List<Map<String, Object>> qcnList = lalm0121Service.LALM0121_selQcn(map);
		
		int qcn = Integer.parseInt(qcnList.get(0).get("CNT").toString());
		
		if(qcn < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"차수정보가 존재하지 않습니다. 확인하세요.!!");
		}
		
		Map<String, Object> inMap = lalm0121Service.LALM0121_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0121_updPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0121_updPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		
		List<Map<String, Object>> qcnList = lalm0121Service.LALM0121_selQcn(map);
		
		int qcn = Integer.parseInt(qcnList.get(0).get("CNT").toString());
		
		if(qcn < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"차수정보가 존재하지 않습니다. 확인하세요.!!");
		}
		
		Map<String, Object> inMap = lalm0121Service.LALM0121_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0121_delPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0121_delPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);		
		Map<String, Object> inMap = lalm0121Service.LALM0121_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}		
	
	
	
	

}
