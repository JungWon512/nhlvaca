package com.auc.lalm.sy.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.vo.JwtUser;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.main.service.CommonService;
import com.auc.mca.AlarmTalkForm;
import com.auc.mca.McaUtil;
import com.auc.mca.RestApiJsonController;

@RestController
public class LALM0899Controller {

	private static Logger log = LoggerFactory.getLogger(LALM0899Controller.class);
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	CommonService commonService;
	@Autowired
	McaUtil mcaUtil;
	@Autowired
	LALM0899Service lalm0899Service;
	@Autowired
	RestApiJsonController restApiJsonController;
	@Autowired
	AlarmTalkForm alarmTalkForm;
	
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
		}else if("1400".equals((String)map.get("ctgrm_cd")) || "4600".equals((String)map.get("ctgrm_cd")) ) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			List<Map<String, Object>> jsonList = (List<Map<String, Object>>) mcaMap.get("jsonList");
			int insertNum = 0;
			if(jsonList != null && jsonList.size() > 0) {
				if("4600".equals((String)map.get("ctgrm_cd"))) {
					insertNum = lalm0899Service.LALM0899_insMca4600(jsonList, map);					
				}else {
					insertNum = lalm0899Service.LALM0899_insMca1400(jsonList, map);					
				}				
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
		}else if("2200".equals((String)map.get("ctgrm_cd")) || "4700".equals((String)map.get("ctgrm_cd"))) {			
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
				msgMap.put("TMS_TYPE", "01");
				
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
				if(mcaMap != null) {
					dataMap = (Map<String, Object>) mcaMap.get("jsonData");
				}
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

			Map<String, Object> dataMap = (Map<String, Object>)mcaMap.get("jsonData");
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
		}else if("4000".equals((String)map.get("ctgrm_cd"))) {
			selMap = lalm0899Service.LALM0899_selMca4000(map);
			Map<String, Object> dataMap = new HashMap<String, Object>();
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
				if(mcaMap != null) {
					dataMap = (Map<String, Object>) mcaMap.get("jsonData");
				}
			}
			
			reMap = commonFunc.createResultSetMapData(dataMap);
			return reMap;
			
		//개체이력 농가 조회 수신
		}else if("4100".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			if(mcaMap != null) {
				Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
				if(dataMap != null) {
					List<Map<String, Object>> rpt_data = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
					List<Map<String, Object>> dataList = null;			
					if(rpt_data != null && !rpt_data.isEmpty()) {
						dataList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
					}else {
						dataList = new ArrayList<Map<String, Object>>();
					}					
					reMap = commonFunc.createResultSetListData(dataList);
				}
			} 			
			return reMap;	
		}else if("4200".equals((String)map.get("ctgrm_cd")) || "4300".equals((String)map.get("ctgrm_cd")) || "4500".equals((String)map.get("ctgrm_cd"))) {
			mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), map);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			dataMap = commonFunc.createResultSetMapData(dataMap); 			
			return dataMap;
		}else if("4900".equals((String)map.get("ctgrm_cd"))) {
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
		// 카카오 알림톡 전송
		}else if("5100".equals((String)map.get("ctgrm_cd"))) {
			int msgInsCnt = 0;
			List<Map<String, Object>> msgList = (List<Map<String, Object>>) map.get("rpt_data");
			for(int i = 0; i < msgList.size(); i++) {
				Map<String, Object> msgMap = msgList.get(i);
				Map<String, Object> tempMap = lalm0899Service.LALM0899_selMca5100AlarmTalkId(msgMap);
				msgMap.put("KAKAO_MSG_CNTN", alarmTalkForm.getAlarmTalkTemplateToJson((String) msgMap.get("kakao_tpl_c"), msgMap));
				// IO_TGRM_KEY (SEQ - 전문키 YYMMDD + 연번4자리)
				msgMap.put("IO_TGRM_KEY", tempMap.get("IO_TGRM_KEY"));
				// RLNO (사용자 사번)
				msgMap.put("RLNO", map.get("ss_userid"));
				// IO_TIT (타이틀 미사용 "" 고정)
				msgMap.put("IO_TIT","");
				// fail-back 필요 파라메터(알람톡 실패시 LMS로 발송)
				// FBK_TIT (타이틀 미사용 "" 고정)
				msgMap.put("FBK_TIT","");
				// fail-back 사용여부 (Y 고정)
				msgMap.put("FBK_UYN", "Y");
				// fail-back 사용여부 (SMS : 3, LMS : 7)
				msgMap.put("FBK_MSG_DSC","7");
				// IO_ATGR_ITN_TGRM_LEN (UMS_FWDG_CNTN의 바이트 수)
				msgMap.put("IO_ATGR_ITN_TGRM_LEN", msgMap.getOrDefault("ums_fwdg_cntn","").toString().getBytes().length);
				
//				// 다이내믹 링크 생성을 위한 타켓 링크
//				msgMap.put("TARGET_LINK", "");
//				// 다이내믹 링크 단축 URL
//				Map<String, Object> dLinkMap = restApiJsonController.createShortLink(msgMap);
				
				mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), msgMap);
				Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");	
				//전송여부
				msgMap = convertConfig.changeKeyUpper(msgMap);				
				msgMap.put("TMS_YN", dataMap.get("RZTC"));
				msgMap.put("TMS_TYPE", "02");
				
				msgInsCnt += lalm0899Service.LALM0899_insMca3100(msgMap);
			}
			Map<String, Object> cntMap = new HashMap<String, Object>();
			cntMap.put("resultCnt", msgInsCnt);
			reMap = commonFunc.createResultSetMapData(cntMap); 			
			return reMap;
		}else if("5200".equals((String)map.get("ctgrm_cd")) || "5300".equals((String)map.get("ctgrm_cd")) 
				|| "5400".equals((String)map.get("ctgrm_cd")) || "5500".equals((String)map.get("ctgrm_cd")) || "5600".equals((String)map.get("ctgrm_cd"))) {
			//대시보드용
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
		Map<String, Object> nodeMap      = new HashMap<String, Object>();
		
		nodeMap = mcaUtil.getOpenDataApi(map);
		if(nodeMap == null) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
		}
		
		Map<String, Object> reMap = commonFunc.createResultSetMapData(nodeMap); 	
        return reMap;
    }
	@ResponseBody
	@RequestMapping(value="/LALM0899_selRestApiCattleMove", method=RequestMethod.POST)
    public Map<String, Object> LALM0899_selRestApiCattleMove(ResolverMap rMap) throws Exception {//IOException, SAXException, ParserConfigurationException
		
		Map<String, Object> map          = convertConfig.conMap(rMap);
		List<Map<String, Object>> nodeList      = new ArrayList<>();
		//Map<String, Object> nodeMap      = new HashMap<String, Object>();
		
		nodeList = mcaUtil.getOpenDataApiCattleMove(map);
		if(nodeList == null) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"서버 수행중 오류가 발생하였습니다.");
		}
		
		Map<String, Object> reMap = commonFunc.createResultSetListData(nodeList); 	
        return reMap;
    }

	@ResponseBody
	@RequestMapping(value="/LALM0899_selAiakRestApi", method=RequestMethod.POST)
    public Map<String, Object> LALM0899_selAiakRestApi(ResolverMap rMap) throws Exception {//IOException, SAXException, ParserConfigurationException
		
		Map<String, Object> map          = convertConfig.conMap(rMap);
		Map<String, Object> nodeMap      = new HashMap<String, Object>();
		
		String barcode = (String) map.get("sra_indv_amnno");
		nodeMap = commonService.Common_selAiakInfo(barcode);
		
		Map<String, Object> reMap = commonFunc.createResultSetMapData(nodeMap); 	
        return reMap;
    }

	@ResponseBody
	@RequestMapping(value="/LALM0899_selAiakRestApiTest", method=RequestMethod.POST)
    public Map<String, Object> LALM0899_selAiakRestApiTest(ResolverMap rMap) throws Exception {//IOException, SAXException, ParserConfigurationException
		
		Map<String, Object> map          = convertConfig.conMap(rMap);
		Map<String, Object> nodeMap      = new HashMap<String, Object>();
		
		String barcode = (String) map.get("sra_indv_amnno");
		nodeMap = mcaUtil.callApiAiakMap(barcode);
		
		Map<String, Object> reMap = commonFunc.createResultSetMapData(nodeMap); 	
        return reMap;
    }
	
    //*tag 값의 정보를 가져오는 메소드
	private static String getTagValue(String tag, Element eElement) {
		
		NodeList nList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
		Node nValue = (Node)nList.item(0);
		
		if(nValue == null) {
			return null;
		}
		return nValue.getNodeValue();
		
	}
	
}
