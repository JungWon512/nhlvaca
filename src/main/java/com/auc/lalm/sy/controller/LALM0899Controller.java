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
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.mca.McaUtil;
import com.auc.mca.TradeMcaMsgDataController;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@RestController
public class LALM0899Controller {

	private static Logger log = LoggerFactory.getLogger(LALM0899Controller.class);
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	McaUtil mcaUtil;
	@Autowired
	LALM0899Service lalm0899Service;
	
	@ResponseBody
	@RequestMapping(value="/LALM0899_selIfTotCnt", method=RequestMethod.POST)
	public Map<String, Object> LALM0899_selIfTotCnt(ResolverMap rMap) throws Exception{
		Map<String, Object> map    = convertConfig.conMap(rMap);
		Map<String, Object> reMap  = new HashMap<String, Object>();
		Map<String, Object> selMap = null;
		
		//중도매인정보
		if("1300".equals((String)map.get("ctgrm_cd"))) {
			if(!"A".equals((String)map.get("auc_dt"))) {
				selMap = lalm0899Service.LALM0899_selMca1300Cnt(map);
			}else {
				selMap = lalm0899Service.LALM0899_selMca1300Cnt_A(map);
			}			
		//출장우정보	
		}else if("1600".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca1600Cnt(map);
		//경매차수정보	
		}else if("1900".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca1900Cnt(map);
		//응찰내역정보
		}else if("2100".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca2100Cnt(map);
		//입금내역정보	
		}else if("2000".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca2000Cnt(map);
		//경매참가내역
		}else if("2700".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca2700Cnt(map);
		//참여산정위원
		}else if("3500".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca3500Cnt(map);
		//출장우 송아지정보
		}else if("3700".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca3700Cnt(map);
		//출장우 수수료정보
		}else if("3900".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca3900Cnt(map);
		}
		reMap = commonFunc.createResultSetMapData(selMap); 			
		return reMap;
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/LALM0899_selIfSend", method=RequestMethod.POST)
	public Map<String, Object> LALM0899_selIfSend(ResolverMap rMap) throws Exception{
		Map<String, Object> map    = convertConfig.conMapWithoutXxs(rMap);
		
		Map<String, Object> selMap = null;
		Map<String, Object> mcaMap = null;
		Map<String, Object> reMap  = null;
				
		//농가정보 수신
		if("1200".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_insMca1200(jsonList, map);
			}
		//중도매인정보 전송
		}else if("1300".equals((String)map.get("ctgrm_cd"))) {
			
			if(!"A".equals((String)map.get("auc_dt"))) {
				selMap = lalm0899Service.LALM0899_selMca1300(map);
			}else {
				selMap = lalm0899Service.LALM0899_selMca1300_A(map);
			}
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//개채정보 수신
		}else if("1400".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_insMca1400(jsonList, map);
			}
		//수송자정보 수신
		}else if("1500".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_insMca1500(jsonList, map);
			}
		//KPN정보 수신
		}else if("3300".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_insMca3300(jsonList, map);
			}
		//수수료정보 수신
		}else if("1700".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_insMca1700(jsonList, map);
			}
		//불량거래인정보 수신
		}else if("1800".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_delMca1800(map);
				insertNum = lalm0899Service.LALM0899_insMca1800(jsonList, map);
			}
			
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
			
		//거래처(산정위원_수의사)정보 수신
		}else if("3400".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_insMca3400(jsonList, map);
			}
		//공통코드정보 수신
		}else if("2500".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				insertNum = lalm0899Service.LALM0899_insMca2500(jsonList, map);
			}
		//출장우내역 전송
		}else if("1600".equals((String)map.get("ctgrm_cd"))) {
			//첫전송
			if("1".equals((String)map.get("start"))) {
				int chk_amnno = lalm0899Service.LALM0899_selMca1600_ChkAmnno(map);
				if(chk_amnno > 0) {
					throw new CusException(ErrorCode.CUSTOM_ERROR,"개체관리 내역중 귀표번호가 없는 개체가 있습니다.<br>관리자에게 문의 하세요.");
				}
				int chk_auc = lalm0899Service.LALM0899_selMca1600_ChkAucObjDsc(map);
				if(chk_auc > 0) {
					throw new CusException(ErrorCode.CUSTOM_ERROR,"출장우내역조회 경매대상값이 비어 있습니다.");
				}
				//빈데이터 처음에 한번 보냄
				mcaMap = mcaUtil.tradeMcaMsgTmp((String)map.get("ctgrm_cd"), map);
				
			}else {
				//전체데이터 조회
				selMap = lalm0899Service.LALM0899_selMca1600(map);
				mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			}
			
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
			
		//경매차수정보 전송
		}else if("1900".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca1900(map);
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//입금내역 전송			
		}else if("2000".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca2000(map);
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//응찰로그정보 전송
		}else if("2100".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca2100(map);
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
	    //개체이력정보 수신
		}else if("2200".equals((String)map.get("ctgrm_cd"))) {			
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			dataMap = commonFunc.createResultSetMapData(dataMap); 			
			return dataMap;
		//분만정보 수신
		}else if("2300".equals((String)map.get("ctgrm_cd"))) {				
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			List<Map<String, Object>> rpt_data = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			List<Map<String, Object>> dataList = null;			
			if(rpt_data != null && !rpt_data.isEmpty()) {
				dataList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			}else {
				dataList = new ArrayList<Map<String, Object>>();
			}
			reMap = commonFunc.createResultSetListData(dataList); 			
			return reMap;			
		//교배정보 수신
		}else if("2400".equals((String)map.get("ctgrm_cd"))) {				
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			List<Map<String, Object>> rpt_data = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			List<Map<String, Object>> dataList = null;			
			if(rpt_data != null && !rpt_data.isEmpty()) {
				dataList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			}else {
				dataList = new ArrayList<Map<String, Object>>();
			}			
			reMap = commonFunc.createResultSetListData(dataList);
			return reMap;			
		//거래처정보 수신
		}else if("2600".equals((String)map.get("ctgrm_cd"))) {				
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			List<Map<String, Object>> rpt_data = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			List<Map<String, Object>> dataList = null;			
			if(rpt_data != null && !rpt_data.isEmpty()) {
				dataList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			}else {
				dataList = new ArrayList<Map<String, Object>>();
			}			
			reMap = commonFunc.createResultSetListData(dataList);
			return reMap;			
		//경매참가내역 전송
		}else if("2700".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca2700(map);
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//임신정보KPN 정보
		}else if("2900".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//비밀번호 문자메세지 전송
		}else if("3000".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca3000(map);
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
		//경매내역 문자메세지 전송
		}else if("3100".equals((String)map.get("ctgrm_cd"))) {			
			List<Map<String, Object>> msgList = null;
			Map<String, Object> msgMap = null;
			int msgInsCnt = 0;
			
			msgList = (List<Map<String, Object>>) map.get("rpt_data");
			
			for(int i = 0; i < msgList.size(); i++) {
				msgMap = msgList.get(i);				
				
				mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), msgMap);
				Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");	
				//전송여부
				msgMap = convertConfig.changeKeyUpper(msgMap);				
				msgMap.put("TMS_YN", dataMap.get("RZTC"));
				
				msgInsCnt += lalm0899Service.LALM0899_insMca3100(msgMap);
				
			}			

			Map<String, Object> cntMap = new HashMap<String, Object>();
			cntMap.put("resultCnt", msgInsCnt);
			
			reMap = commonFunc.createResultSetMapData(cntMap);
			return reMap;
			
		//참여산정위원 전송
		}else if("3500".equals((String)map.get("ctgrm_cd"))) {  
			selMap = lalm0899Service.LALM0899_selMca3500(map);
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//중도매인조합원구분 전송
		}else if("3600".equals((String)map.get("ctgrm_cd"))) {  
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//출장우(송아지) 전송
		}else if("3700".equals((String)map.get("ctgrm_cd"))) {
			//첫전송
			if("1".equals((String)map.get("start"))) {
				//빈데이터 처음에 한번 보냄
				mcaMap = mcaUtil.tradeMcaMsgTmp((String)map.get("ctgrm_cd"), map);
			}else {
				selMap = lalm0899Service.LALM0899_selMca3700(map);
				mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			}

			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		//출장우농가(농장) 전송
		}else if("3800".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca3800(map);
			Map<String, Object> dataMap = null;
			if(Integer.parseInt((String)selMap.get("INQ_CN")) > 0) {		
				
				Map<String, Object> tmsMap = new HashMap<String, Object>();
								
				List<Map<String, Object>> tmsList = null; 
				List<Map<String, Object>> tmpList = (List<Map<String, Object>>) selMap.get("RPT_DATA");
					
				int tmsCnt = 19;
				for(int i = 0; i < tmpList.size(); i++) {
					if(i == 0) {
						tmsList = new ArrayList<Map<String, Object>>();
					}					
					tmsList.add(tmpList.get(i));
					
					if(tmsCnt == i || tmpList.size() == (i+1)) {
						tmsMap.put("INQ_CN", ""+tmsList.size());
						tmsMap.put("RPT_DATA", tmsList);
						mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), tmsMap);
						tmsMap.clear();
						tmsList = new ArrayList<Map<String, Object>>();
						tmsCnt = tmsCnt + 20;
					}
				}
				
				dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			}else {
				dataMap = new HashMap<String, Object>();
			}
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
			
		//출장우 수수료내역 전송
		}else if("3900".equals((String)map.get("ctgrm_cd"))) {
			//첫전송
			if("1".equals((String)map.get("start"))) {
				//빈데이터 처음에 한번 보냄
				mcaMap = mcaUtil.tradeMcaMsgTmp((String)map.get("ctgrm_cd"), map);
			}else {
				//전체데이터 조회
				selMap = lalm0899Service.LALM0899_selMca3900(map);
				mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), selMap);
			}

			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		}else if("4000".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca4000(map);
			Map<String, Object> dataMap = null;
			if(Integer.parseInt((String)selMap.get("INQ_CN")) > 0) {		
				
				Map<String, Object> tmsMap = new HashMap<String, Object>();
								
				List<Map<String, Object>> tmsList = null; 
				List<Map<String, Object>> tmpList = (List<Map<String, Object>>) selMap.get("RPT_DATA");
					
				int tmsCnt = 49;
				for(int i = 0; i < tmpList.size(); i++) {
					if(i == 0) {
						tmsList = new ArrayList<Map<String, Object>>();
					}					
					tmsList.add(tmpList.get(i));
					
					if(tmsCnt == i || tmpList.size() == (i+1)) {
						tmsMap.put("INQ_CN", ""+tmsList.size());
						tmsMap.put("RPT_DATA", tmsList);
						mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), tmsMap);
						tmsMap.clear();
						tmsList = new ArrayList<Map<String, Object>>();
						tmsCnt = tmsCnt + 50;
					}
				}
				dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			}else {
				dataMap = new HashMap<String, Object>();
			}
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
			
		//개체이력 농가 조회 수신
		}else if("4100".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			List<Map<String, Object>> rpt_data = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			List<Map<String, Object>> dataList = null;			
			if(rpt_data != null && !rpt_data.isEmpty()) {
				dataList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			}else {
				dataList = new ArrayList<Map<String, Object>>();
			}
			reMap = commonFunc.createResultSetListData(dataList); 			
			return reMap;	
		}else if("4200".equals((String)map.get("ctgrm_cd")) || "4300".equals((String)map.get("ctgrm_cd")) || "4500".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			dataMap = commonFunc.createResultSetMapData(dataMap); 			
			return dataMap;
		}else {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
		}
		
		reMap = commonFunc.createResultSetMapData(mcaMap); 			
		return reMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0899_selRestApi", method=RequestMethod.POST)
    public Map<String, Object> LALM0899_selRestApi(ResolverMap rMap) throws Exception {//IOException, SAXException, ParserConfigurationException
		
		Map<String, Object> map          = convertConfig.conMap(rMap);
		Map<String, Object> nodeMap      = null;
		
		String sendUrl = "http://data.ekape.or.kr/openapi-data/service/user/animalTrace/traceNoSearch";
		sendUrl += "?serviceKey=" + "7vHI8ukF3BjfpQW8MPs9KtxNwzonZYSbYq6MVPIKshJNeQHkLqxsqd1ru5btfLgIFuLRCzCLJDLYkHp%2FvI6y0A%3D%3D";
		sendUrl += "&traceNo=" + map.get("trace_no");//  "002125769192";
		sendUrl += "&optionNo=" + map.get("option_no");//"7"; 브루셀라
		log.debug("sendUrl: " + sendUrl);
		StringBuilder urlBuilder = new StringBuilder(sendUrl);
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = null;
				
		try {
			
			conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(1000);
			conn.setReadTimeout(1000);
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        log.debug("Response code: " + conn.getResponseCode());
	        BufferedReader rd = null;
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <=300 ) {
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			}else {
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
	        
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        log.debug(sb.toString());
	        
	        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance(); 
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder(); 
			
			String parsingUrl = url.toString();
			Document doc = dBuilder.parse(parsingUrl);
			
			// Tree 구조 node 로 변환
			doc.getDocumentElement().normalize();
			
			// root tag 값 확인
			log.debug("Root element : " + doc.getDocumentElement().getNodeName());
			
			// 파싱할 데이터 tag 의 리스트 수
			NodeList nList = doc.getElementsByTagName("item"); // <item> 태그요소
			log.debug("파싱할 리스트 수 : " +  nList.getLength());
	        
			nodeMap = new HashMap<String, Object>();
			
			for(int i = 0; i < nList.getLength(); i++) {
				Node nNode = nList.item(i); // <item> i 의 값을 nNode 에 넣는다.
				//브루셀라
				Element eElement = (Element)nNode;

				nodeMap.put("insepctDt", getTagValue("inspectDt",eElement));					// 브루셀라 검사일
				nodeMap.put("inspectYn", getTagValue("inspectYn",eElement));					// 브루셀라 접종 유무
				nodeMap.put("tbcInspectYmd", getTagValue("tbcInspectYmd",eElement));			// 결핵 검사일
				nodeMap.put("tbcInspectRsltNm", getTagValue("tbcInspectRsltNm",eElement));		// 결핵 검사결과
				nodeMap.put("injectionYmd", getTagValue("injectionYmd",eElement));				// 구제역 백신접종일
				nodeMap.put("vaccineorder", getTagValue("vaccineorder",eElement));				// 구제역 백신접종 차수
				nodeMap.put("injectionDayCnt", getTagValue("injectionDayCnt",eElement));		// 구제역 백신접종경과일
			}
			
		} catch (RuntimeException e) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
        } catch (Exception e) {
        	throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
        } finally {
            if (conn!= null) conn.disconnect();
        }
		
		Map<String, Object> reMap = commonFunc.createResultSetMapData(nodeMap);
        return reMap;
    }
	
    //*tag 값의 정보를 가져오는 메소드
	private static String getTagValue(String tag, Element eElement) {
		String rtnString = "";
		NodeList list = eElement.getChildNodes();
		for (int i = 0; i < list.getLength(); i++) {
			Node node = list.item(i);
			if (tag.equals(node.getNodeName())) {
				return node.getTextContent();
			}
		}
		return rtnString;
	}
	
}
