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
import com.auc.lalm.ar.service.LALM0212Service;

@RestController
public class LALM0212Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0212Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0212Service lalm0212Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0212_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0212_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0212Service.LALM0212_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0212_updDdl", method=RequestMethod.POST)
	public Map<String, Object> LALM0212_updDdl(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);		
		Map<String, Object> inMap = lalm0212Service.LALM0212_updDdl(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0212_updCan", method=RequestMethod.POST)
	public Map<String, Object> LALM0212_updCan(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);	
		Map<String, Object> inMap = lalm0212Service.LALM0212_updCan(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0212_insPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0212_insPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		
		List<Map<String, Object>> qcnList = lalm0212Service.LALM0212_selQcn(map);
		
		int qcn = Integer.parseInt(qcnList.get(0).get("CNT").toString());
		
		if(qcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"해당 경매일자에 차수가 이미 등록되어있습니다. 확인하세요.");
		}
		
		List<Map<String, Object>> aucQcnList = lalm0212Service.LALM0212_selAucQcn(map);
		
		int aucQcn = Integer.parseInt(aucQcnList.get(0).get("CNT").toString());
		
		if(aucQcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"해당 경매일자에 차수가 이미 등록되어있습니다. 확인하세요.");
		}
		
		Map<String, Object> inMap = lalm0212Service.LALM0212_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0212_updPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0212_updPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   = convertConfig.conMap(rMap);
		
		List<Map<String, Object>> qcnList = lalm0212Service.LALM0212_selQcn(map);
		
		int qcn = Integer.parseInt(qcnList.get(0).get("CNT").toString());
		
		if(qcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"해당 경매일자에 차수가 이미 등록되어있습니다. 확인하세요.");
		}
		
		Map<String, Object> inMap = lalm0212Service.LALM0212_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0212_delPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0212_delPgm(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = convertConfig.conMap(rMap);		

		List<Map<String, Object>> selmhSogCowList = lalm0212Service.LALM0212_selmhSogCow(map);
		
		int selmhSogCow = Integer.parseInt(selmhSogCowList.get(0).get("CNT").toString());
		
		if(selmhSogCow > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"삭제할 차수정보로 이미 출장우 내역이 존재합니다. 삭제할 수 없습니다.");
		}
		
		Map<String, Object> inMap = lalm0212Service.LALM0212_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0212_selMaxQcn", method=RequestMethod.POST)
	public Map<String, Object> LALM0212_selMaxQcn(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		
		List<Map<String, Object>> qcnList = lalm0212Service.LALM0212_selQcn(map);
		
		int qcn = Integer.parseInt(qcnList.get(0).get("CNT").toString());
		
		if(qcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"해당 경매일자에 차수가 이미 등록되어있습니다. 확인하세요.");
		}
		
		List<Map<String, Object>> aucQcnList = lalm0212Service.LALM0212_selAucQcn(map);
		
		int aucQcn = Integer.parseInt(aucQcnList.get(0).get("CNT").toString());
		
		if(aucQcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"해당 경매일자에 차수가 이미 등록되어있습니다. 확인하세요.");
		}
		
		List<Map<String, Object>> reList = lalm0212Service.LALM0212_selMaxQcn(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	

}
