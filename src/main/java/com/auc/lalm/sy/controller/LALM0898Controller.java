package com.auc.lalm.sy.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.codehaus.jettison.json.JSONTokener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.sy.service.LALM0898Service;
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.mca.McaUtil;
import com.auc.mca.TradeMcaMsgDataController;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@RestController
public class LALM0898Controller {

	private static Logger log = LoggerFactory.getLogger(LALM0898Controller.class);
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0898Service lalm0898Service;

	@ResponseBody
	@RequestMapping(value="/LALM0898_updAucDataInit", method=RequestMethod.POST)
	public Map<String, Object> LALM0898_initAucData(ResolverMap rMap) throws Exception{
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> reMap  = new HashMap<String, Object>();
		reMap = lalm0898Service.LALM0898_initAucData(map);
		return commonFunc.createResultSetMapData(reMap);
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0898_insAucData", method=RequestMethod.POST)
	public Map<String, Object> LALM0898_insAucData(ResolverMap rMap) throws Exception{
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> reMap  = new HashMap<String, Object>();
		int aucCnt = lalm0898Service.LALM0898_selAucData(map);
		if(aucCnt > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"복사할 경매일자의 경매 데이터가 이미 존재합니다.");
		}
		
		reMap = lalm0898Service.LALM0898_insAucData(map);			
		return commonFunc.createResultSetMapData(reMap);
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0898_delAucData", method=RequestMethod.POST)
	public Map<String, Object> LALM0898_delAucData(ResolverMap rMap) throws Exception{
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> reMap  = new HashMap<String, Object>();
		reMap = lalm0898Service.LALM0898_delAucData(map);			
		return commonFunc.createResultSetMapData(reMap);
	}
	
}
