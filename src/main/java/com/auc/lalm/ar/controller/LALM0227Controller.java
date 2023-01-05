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
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ar.service.LALM0227Service;

@RestController
public class LALM0227Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0227Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0227Service lalm0227Service;
	
	/**
	 * 알람톡 리스트 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0227_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0227_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0227Service.LALM0227_selList(map);				
		Map<String, Object> reMap        = commonFunc.createResultSetListData(reList); 			
		return reMap;
	}	
	
	/**
	 * 알람톡 상세
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM0227_selInfo", method = RequestMethod.POST)
	public Map<String, Object> LALM0227_selInfo(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= lalm0227Service.LALM0227_selInfo(map);
		Map<String, Object> reMap	= commonFunc.createResultSetMapData(inMap);
		return reMap;
	}
	
	/**
	 * 알람톡 저장
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM0227_insMsgTalk", method = RequestMethod.POST)
	public Map<String, Object> LALM0227_insMsgTalk(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= lalm0227Service.LALM0227_insMsgTalk(map);
		Map<String, Object> reMap	= commonFunc.createResultCUD(inMap);
		return reMap;
	}
	
	/**
	 * 알람톡 수정
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM0227_updMsgTalk", method = RequestMethod.POST)
	public Map<String, Object> LALM0227_updMsgTalk(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= lalm0227Service.LALM0227_updMsgTalk(map);
		Map<String, Object> reMap	= commonFunc.createResultCUD(inMap);
		return reMap;
	}
	
	/**
	 * 알람톡 삭제
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM0227_delMsgTalk", method = RequestMethod.POST)
	public Map<String, Object> LALM0227_delMsgTalk(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= lalm0227Service.LALM0227_delMsgTalk(map);
		Map<String, Object> reMap	= commonFunc.createResultCUD(inMap);
		return reMap;
	}
}
