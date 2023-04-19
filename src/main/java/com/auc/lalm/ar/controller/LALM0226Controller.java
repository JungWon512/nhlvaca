package com.auc.lalm.ar.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ar.service.LALM0226Service;

/**
 * [LALM0226] 출장우 접수 Controller
 * @author ishift
 */
@Controller
@SuppressWarnings({"unused"})
public class LALM0226Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0220Controller.class);

	@Autowired
	ConvertConfig convertConfig;
	
	@Autowired
	CommonFunc commonFunc;
	
	@Autowired
	LALM0226Service lalm0226Service;
		
	/**
	 * 출장우 접수 화면에서 접수내역 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0226_selInfo", method=RequestMethod.POST)
	public Map<String, Object> LALM0226_selInfo(ResolverMap rMap) throws Exception {
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0226Service.LALM0226_selInfo(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		
		return reMap;
	}
	
	/**
	 * 출장우 접수 화면에서 접수내역 조회
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0226_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0226_selList(ResolverMap rMap) throws Exception {
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0226Service.LALM0226_selList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		
		return reMap;
	}

	/**
	 * 출장우 접수 내용 저장
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM0226_insPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM0226_insPgm(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= lalm0226Service.LALM0226_insPgm(map);
		Map<String, Object> reMap	= commonFunc.createResultCUD(inMap);
		return reMap;
	}
	
	/**
	 * 출장우 접수 내용 수정
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM0226_updPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM0226_updPgm(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= lalm0226Service.LALM0226_updPgm(map);
		Map<String, Object> reMap	= commonFunc.createResultCUD(inMap);
		return reMap;
	}
	
	/**
	 * 출장우 접수 내용 삭제
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/LALM0226_delPgm", method = RequestMethod.POST)
	public Map<String, Object> LALM0226_delPgm(ResolverMap rMap) throws Exception {
		Map<String, Object> map		= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> inMap	= lalm0226Service.LALM0226_delPgm(map);
		Map<String, Object> reMap	= commonFunc.createResultCUD(inMap);
		return reMap;
	}
	
	/**
	 * 출장우 접수 내용 귀표 중복체크
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0226_selIndvChk", method=RequestMethod.POST)
	public Map<String, Object> LALM0226_selIndvChk(ResolverMap rMap) throws Exception {
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		Map<String, Object> reInfo = lalm0226Service.LALM0226_selIndvChk(map);
		Map<String, Object> reMap = commonFunc.createResultSetMapData(reInfo);
		
		return reMap;
	}
	
	
}
