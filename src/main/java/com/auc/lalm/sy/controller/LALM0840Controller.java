package com.auc.lalm.sy.controller;

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
import com.auc.lalm.sy.service.LALM0840Service;

@RestController
public class LALM0840Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0840Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0840Service LALM0840Service;
	
	/**
	 * 알람톡 리스트 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0840_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0840_selList(ResolverMap rMap) throws Exception{	
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = LALM0840Service.LALM0840_selList(map);				
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
	@RequestMapping(value = "/LALM0840_selInfo", method = RequestMethod.POST)
	public Map<String, Object> LALM0840_selInfo(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= LALM0840Service.LALM0840_selInfo(map);
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
	@RequestMapping(value = "/LALM0840_insMsgTalk", method = RequestMethod.POST)
	public Map<String, Object> LALM0840_insMsgTalk(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= LALM0840Service.LALM0840_insMsgTalk(map);
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
	@RequestMapping(value = "/LALM0840_updMsgTalk", method = RequestMethod.POST)
	public Map<String, Object> LALM0840_updMsgTalk(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= LALM0840Service.LALM0840_updMsgTalk(map);
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
	@RequestMapping(value = "/LALM0840_delMsgTalk", method = RequestMethod.POST)
	public Map<String, Object> LALM0840_delMsgTalk(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= LALM0840Service.LALM0840_delMsgTalk(map);
		Map<String, Object> reMap	= commonFunc.createResultCUD(inMap);
		return reMap;
	}
}
