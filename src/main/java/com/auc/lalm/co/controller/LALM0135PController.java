package com.auc.lalm.co.controller;

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
import com.auc.lalm.co.service.LALM0135PService;

/**
 * 통합회원검색 팝업 컨트롤러
 * @author iShift
 */
@RestController
@SuppressWarnings({"unused"})
public class LALM0135PController {
	
	private static Logger log = LoggerFactory.getLogger(LALM0135PController.class);

	@Autowired
	private ConvertConfig convertConfig;
	
	@Autowired
	private CommonFunc commonFunc;
	
	@Autowired
	private LALM0135PService lalm0135PService;
		
	/**
	 * 통합회원검색
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0135P_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0135P_selList(ResolverMap rMap) throws Exception{
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0135PService.LALM0135P_selList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		return reMap;
	}	

}
