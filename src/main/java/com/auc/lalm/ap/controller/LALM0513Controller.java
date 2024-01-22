package com.auc.lalm.ap.controller;

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
import com.auc.lalm.ap.service.LALM0513Service;

@RestController
public class LALM0513Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0513Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0513Service lalm0513Service;
		
	/*
	 * LALM0513_selectList    = 낙찰자정산서 
	 * LALM0513_selectList_2  = 매매대금영수증
	 * LALM0513_selectList_3  = 경매후내역 
	 * LALM0513_selectList_4  = 미수금현황
	 * LALM0513_selectList_5  = 정산내역(농가) 
	 * LALM0513_selectList_6  = 등록우 입금내역
	 * LALM0513_selectList_7  = 운송비내역 
	 * LALM0513_selectList_8  = 경매집계표
	 * LALM0513_selectList_9  = 총판집계표 
	 * LALM0513_selectList_10 = 중도매인 정산내역
	 * LALM0513_selectList_11 = 출하자 정산내역 
	 * LALM0513_selectList_12 = 수의사 지급내
	 * LALM0513_selectList_13 = 경매정보 연계
	 * LALM0513_selectList_14 = 출생신고서
	 * LALM0513_selectList_15 = 수의사 금액 
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0513_selMhFeeImps", method=RequestMethod.POST)
	public Map<String, Object> LALM0513_selMhFeeImps(ResolverMap rMap) throws Exception{				    
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selMhFeeImps(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selMhAucQcn", method=RequestMethod.POST)
	public Map<String, Object> LALM0513_selMhAucQcn(ResolverMap rMap) throws Exception{				    
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selMhAucQcn(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0513_selList(ResolverMap rMap) throws Exception{				    
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_2", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_2(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_2(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_3", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_3(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_3(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_4", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_4(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> sogCow4CntList = lalm0513Service.LALM0513_selMhAucQcn(map);
		
		if(sogCow4CntList.size() == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"미수금현황은 경매차수에 있는 경매대상으로만 조회 가능합니다.");
		}
		
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_4(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_5", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_5(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_5(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selSubList_5", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selSubList_5(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selSubList_5(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_6", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_6(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_6(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_7", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_7(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_7(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selSubList_8", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selSubList_8(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selSubList_8(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_8", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_8(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_8(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_9", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_9(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_9(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_10", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_10(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> mhAucQcnList = lalm0513Service.LALM0513_selMhAucQcn(map);
		
		if(mhAucQcnList.size() == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매차수가 등록되지 않았습니다.");
		}
		
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_10(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_11", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_11(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_11(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_11_print", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_11_print(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_11_print(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_12", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_12(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_12(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_13", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_13(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_13(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_14", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_14(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_14(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_15", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_15(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_15(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0513_selList_11_print2", method=RequestMethod.POST) 
	public Map<String, Object> LALM0513_selList_11_print2(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0513Service.LALM0513_selList_11_print2(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}

}
