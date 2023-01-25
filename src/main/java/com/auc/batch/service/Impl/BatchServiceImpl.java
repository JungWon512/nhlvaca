package com.auc.batch.service.Impl;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.batch.service.BatchService;
import com.auc.common.config.ConvertConfig;
import com.auc.lalm.bs.service.Impl.LALM0117Mapper;
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.lalm.sy.service.Impl.LALM0840Mapper;
import com.auc.mca.AlarmTalkForm;
import com.auc.mca.McaUtil;

@Service("BatchService")
public class BatchServiceImpl implements BatchService{
	private static Logger log = LoggerFactory.getLogger(BatchServiceImpl.class);

	@Autowired
	BatchMapper batchMapper;
	
	@Autowired
	LALM0117Mapper lalm0117Mapper;
	
	@Autowired
	McaUtil mcaUtil;
	
	@Autowired
	AlarmTalkForm alarmForm;
	
	@Autowired
	LALM0899Service lalm0899Service;
	
	@Autowired
	LALM0840Mapper lalm0840Mapper;
	
	@Autowired
	ConvertConfig convertConfig;

	@Override
	public List<Map<String, Object>> selDormaccMmMbintgList(Map<String, Object> map) throws Exception{
		return batchMapper.selDormaccMmMbintgList(map);
	}

	@Override
	public Map<String, Object> insUpdDormUserMasking(Map<String, Object> reVo) throws Exception {
		int insertNum = 0;
		int updateNum = 0;
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("batch_flag", "Y");
		map.put("mb_intg_no", reVo.get("MB_INTG_NO").toString());
		
		insertNum += lalm0117Mapper.LALM0117_insMbintgHistoryData(map);	//회원통합 히스토리 저장하기
		insertNum += batchMapper.insDormUserMbintgData(map);		//회원통합 백업본 저장하기
		updateNum += batchMapper.updDormUserMbintgMasking(map);	//회원통합 원데이터 마스킹하기
		
		if("01".equals(reVo.get("MB_INTG_GB").toString())) {
			insertNum += lalm0117Mapper.LALM0117_insMwmnHistoryData(map);	//중도매인 히스토리 저장하기
			insertNum += batchMapper.insDormUserMwmnData(map);		//중도매인 백업본 저장하기
			updateNum += batchMapper.updDormUserMwmnMasking(map);	//중도매인 원데이터 마스킹하기
		}else {
			insertNum += batchMapper.insDormUserFhsData(map);		//농가 백업본 저장하기
			updateNum += batchMapper.updDormUserFhsMasking(map);	//농가 원데이터 마스킹하기
		}
		
		reMap.put("insertNum", insertNum);	
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> createResultCUDBatch(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		if(map == null) {
			reMap.put("status", 201);
			reMap.put("code", "C001");
			reMap.put("message", "저장된 내역이 없습니다");
		}else {
			//service에서 insertNum, updateNum, deleteNum 값 put 해줌
			if(map.containsKey("insertNum")) {				
				reMap.put("insertNum", map.get("insertNum"));
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("message", "");
			}
			if(map.containsKey("updateNum")) {
				reMap.put("updateNum", map.get("updateNum"));
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("message", "");
			}
			if(map.containsKey("deleteNum")) {
				reMap.put("deleteNum", map.get("deleteNum"));
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("message", "");
			}
	        if(!map.containsKey("insertNum") && !map.containsKey("updateNum") && !map.containsKey("deleteNum")) {
				reMap.put("status", 201);
				reMap.put("code", "C001");
				reMap.put("message", map.getOrDefault("message", "저장된 내역이 없습니다"));
			}
		}
		
		return reMap;
	}

	@Override
	public int getExecBatchCount(Map<String, Object> map) throws Exception {
		String batchCycle = map.get("batch_cycle").toString();
		String termType = batchCycle;
		int termNum = 1;
		
		if(batchCycle.length() > 1) {
			termType = batchCycle.substring(batchCycle.length() - 1, batchCycle.length());		//맨 끝에 한자리
			termNum = Integer.parseInt(batchCycle.substring(0, batchCycle.length() - 1));		//맨 끝에 한자리 앞 숫자
		}
		
		map.put("term_type", termType);
		map.put("term_num", termNum);
		return batchMapper.getExecBatchCount(map);
	}

	@Override
	public int insBeforeBatchLog(Map<String, Object> map) throws Exception {
		map.put("bat_suc_yn", "Y");	//먼저 Y 로 넣어놓고, 성공 실패 여부에 따라 S, F를 업데이트 할 예정
		batchMapper.insBeforeBatchLog(map);
		return (int) map.get("bat_act_seq");
	}

	@Override
	public int updAfterBatchLog(Map<String, Object> reMap) throws Exception {
		return batchMapper.updAfterBatchLog(reMap);
	}
	@Override
	public List<Map<String, Object>> selBzLocAucYn(Map<String, Object> map) throws Exception{
		return batchMapper.selBzLocAucYn(map);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> batchDashBoardFor5400(Map<String, Object> map, Map<String,Object> bzMap) throws Exception{		
		Map<String,Object> reMap = new HashMap<String, Object>();
		StringBuffer error = new StringBuffer();
		int insertNum = 0;
		int deleteNum = 0;
		int failCnt = 0;
		int succCnt = 0; 
		
		//해당 조합의 최대 경매일수 조회(null일시 어떤값부를지는 미정)
		Map<String,Object> tempMap = new HashMap<>();
		tempMap.put("NA_BZPLC", bzMap.get("NA_BZPLC"));
		Map<String,Object> selMaxAucDt = batchMapper.selMaxAucDt(tempMap);
		if(selMaxAucDt != null) tempMap.put("AUC_DT", selMaxAucDt.getOrDefault("AUC_DT","20220101"));
		else tempMap.put("AUC_DT", "20220101");
		
		////대시보드용 경매참가번호 조회
		try {
			Map<String, Object> aucEntrMcaMap = mcaUtil.tradeMcaMsg("5400", tempMap);
			Map<String, Object> aucEntrJson = (Map<String, Object>) aucEntrMcaMap.get("jsonData");
			List<Map<String, Object>> aucEntrRptData = (List<Map<String, Object>>) aucEntrJson.get("RPT_DATA");
			if(aucEntrRptData != null && !aucEntrRptData.isEmpty()) {
				for(Map<String, Object> aucEntrMap:aucEntrRptData) {
					try {
						insertNum += batchMapper.insDashBoardAucEntr(aucEntrMap);
						succCnt++;
					}catch(Exception e) {
						log.error("message", e);
						if("".equals(error.toString())) {
							error.append(this.getExceptionErrorMessage(e));
						}
						failCnt++;
					}
				}
			}
		}catch(Exception e) {
			log.error("message", e);
			if("".equals(error.toString())) {
				error.append(this.getExceptionErrorMessage(e));
			}
			failCnt++;
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("failCnt", failCnt);
		reMap.put("succCnt", succCnt);
		reMap.put("error", error.toString());
		return reMap;
	}

	
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> batchDashBoardFor5200(Map<String, Object> map, Map<String,Object> bzMap) throws Exception{		
		Map<String,Object> reMap = new HashMap<String, Object>();
		StringBuffer error = new StringBuffer();
		int insertNum = 0;
		int deleteNum = 0;
		int failCnt = 0;
		int succCnt = 0; 
		int selCnt = 30;
		
		//해당 조합의 최대 경매일수 조회(null일시 어떤값부를지는 미정)
		Map<String,Object> tempMap = new HashMap<>();
		tempMap.put("NA_BZPLC", bzMap.get("NA_BZPLC"));
		Map<String,Object> selMaxAucDt = batchMapper.selMaxAucDt(tempMap);
		if(selMaxAucDt != null) tempMap.put("AUC_DT", selMaxAucDt.getOrDefault("AUC_DT","20220101"));
		else tempMap.put("AUC_DT", "20220101");
		
		int sogCowMcaIdx = 1;
		int sogCowTotCnt= 0;
		tempMap.put("IN_REC_CN", selCnt+"");
		while(true) {
			try {
				tempMap.put("IN_SQNO", sogCowMcaIdx+"");
				Map<String, Object> sogCowMcaMap = mcaUtil.tradeMcaMsg("5200", tempMap);
				Map<String, Object> sogCowJson = (Map<String, Object>) sogCowMcaMap.get("jsonData");
				List<Map<String, Object>> sogCowRptData = (List<Map<String, Object>>) sogCowJson.get("RPT_DATA");				
				sogCowTotCnt = Integer.valueOf((String)sogCowJson.getOrDefault("IO_ROW_CNT","0"));
				if(sogCowTotCnt == 0 || sogCowRptData == null || sogCowRptData.isEmpty()) { 
					break;
				}else {
					for(Map<String, Object> sogCowMap:sogCowRptData) {
						try {
							insertNum += batchMapper.insDashBoardSogCow(sogCowMap);
							//개체 추가할지 출장우 컬럼추가할지 미정
							insertNum += batchMapper.insDashBoardIndv(sogCowMap);
							succCnt++;
						}catch(Exception e) {
							log.error("message 5200inf Sql error ", e);
							if("".equals(error.toString())) {
								error.append(this.getExceptionErrorMessage(e));
							}
							failCnt++;
						}
					}
				}
			}catch(Exception e) {
				log.error("message 5200 inf error ", e);
				if("".equals(error.toString())) {
					error.append(this.getExceptionErrorMessage(e));
				}
				failCnt++;
				break;
			}
			if(sogCowMcaIdx > sogCowTotCnt) {
				break;				
			}
			sogCowMcaIdx+=selCnt;
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("failCnt", failCnt);
		reMap.put("succCnt", succCnt);
		reMap.put("error", error.toString());
		return reMap;
	}

	
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> batchDashBoardFor5300(Map<String, Object> map, Map<String,Object> bzMap) throws Exception{		
		Map<String,Object> reMap = new HashMap<String, Object>();
		StringBuffer error = new StringBuffer();
		int insertNum = 0;
		int deleteNum = 0;
		int failCnt = 0;
		int succCnt = 0; 
		
		//해당 조합의 최대 경매일수 조회(null일시 어떤값부를지는 미정)
		Map<String,Object> tempMap = new HashMap<>();
		tempMap.put("NA_BZPLC", bzMap.get("NA_BZPLC"));
		Map<String,Object> selMaxAucDt = batchMapper.selMaxAucDt(tempMap);
		if(selMaxAucDt != null) tempMap.put("AUC_DT", selMaxAucDt.getOrDefault("AUC_DT","20220101"));
		else tempMap.put("AUC_DT", "20220101");
						
		//대시보드용 경매차수 조회
		try {		
			Map<String, Object> mcaMap = mcaUtil.tradeMcaMsg("5300", tempMap);
			Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
			List<Map<String, Object>> aucQcnList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");			
			if(aucQcnList != null && !aucQcnList.isEmpty()) {					
				for(Map<String, Object> aucQcnMap: aucQcnList) {
					try {
						//임시로 데이터 경매구분 단일로해서 등록
						insertNum += batchMapper.insDashBoardAucQcn(aucQcnMap);
						succCnt++;
					}catch(Exception e) {
						log.error("message", e);
						if("".equals(error.toString())) {
							error.append(this.getExceptionErrorMessage(e));
						}
						failCnt++;
						throw e;
					}
				}
			}
		}catch(Exception e) {
			log.error("message", e);
			if("".equals(error.toString())) {
				error.append(this.getExceptionErrorMessage(e));
			}
			failCnt++;
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("failCnt", failCnt);
		reMap.put("succCnt", succCnt);
		reMap.put("error", error.toString());
		return reMap;
	}

	/**
	 * 에러메세지 substring 하는 함수
	 * @param e
	 * @return
	 */
	private String getExceptionErrorMessage(Exception e) {
		int errorTxtLen = 0, errorSubstrLen = 500;
		String result = "";
		StringWriter errors = new StringWriter();
		e.printStackTrace(new PrintWriter(errors));
		errorTxtLen = errors.toString().length();

		if(errorTxtLen > errorSubstrLen) {
			result = errors.toString().substring(0, errorSubstrLen);
		}else {
			result = errors.toString();
		}
		return result;
	}

	@Override
	public List<Map<String, Object>> selDormcPreUserMbintgList(Map<String, Object> map) throws Exception{
		return batchMapper.selDormcPreUserMbintgList(map);
	}

	@Override
	public void sendAlarmTalk_DormacPreUser(Map<String, Object> reVo) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();	
		Map<String, Object> msgMap = new HashMap<String, Object>();	
		Map<String, Object> mcaMap = null;
		//휴면예정 대상자 알림톡 발송
		Map<String, Object> tempMap = lalm0899Service.LALM0899_selMca5100AlarmTalkId(map);
		msgMap.put("IO_TGRM_KEY", tempMap.get("IO_TGRM_KEY"));	// IO_TGRM_KEY (SEQ - 전문키 YYMMDD + 연번4자리)
		
		String templateId = "NHKKO00257";
		map.put("code", templateId);
		tempMap = lalm0840Mapper.LALM0840_selInfo(map);
		
		Map<String, Object> sendPhoneInfo = null;
		if("01".equals(reVo.get("MB_INTG_GB"))) {
			sendPhoneInfo = batchMapper.selMaxAucNumPhoneInfo(reVo);		//최신 참여내역의 조합 전화번호 가져오기
		}
		else if("02".equals(reVo.get("MB_INTG_GB"))) {
			sendPhoneInfo = batchMapper.selMaxSogCowPhoneInfo(reVo);		//최신 출하내역의 조합 전화번호 가져오기
		}
		
		//참여 or 출하내역이 없을 경우 
		if(sendPhoneInfo == null) {
			if("01".equals(reVo.get("MB_INTG_GB"))) {
				sendPhoneInfo = batchMapper.selMatchMwmnPhoneInfo(reVo);		//매칭되는 조합의 전화번호 정보를 가지고 오기 
			}
			else if("02".equals(reVo.get("MB_INTG_GB"))) {
				sendPhoneInfo = batchMapper.selMatchFhsPhoneInfo(reVo);		//매칭되는 농가의 전화번호 정보를 가지고 오기
			}
		}
		
		// SMS 로그테이블(TB_LA_IS_MM_SMS) 에 필요한 파라미터
		msgMap.put("MSG_CNTN", alarmForm.makeAlarmMsgCntn(reVo, tempMap.get("TALK_CONTENT").toString()));
		msgMap.put("AUC_OBJ_DSC", "4");	//경매대상구분코드 : 새로운 코드
		msgMap.put("TRMN_AMNNO", sendPhoneInfo.get("TRMN_AMNNO"));		//중도매인 코드 or 출하주 코드
		msgMap.put("DPAMN_DSC", "3");		//출하자, 응찰자 구분 : 새로운 코드
		msgMap.put("SEL_STS_DSC", "00");	//판매상태구분코드 : 새로운 코드
		msgMap.put("RMS_MN_NAME", reVo.get("MB_INTG_NM"));		//수신자명 (중도매인명 or 출하주명)
		msgMap.put("IO_TRMSNM", sendPhoneInfo.get("CLNTNM"));		//발신자명 (조합명)
		msgMap.put("SMS_RMS_MPNO", reVo.get("MB_MPNO"));		// 수신자 전화번호	
		msgMap.put("SMS_TRMS_TELNO", sendPhoneInfo.get("TEL_NO"));	// 발신자 전화번호
		msgMap.put("SS_USERID", "BATCH");
		
		// 인터페이스에 필요한 파라미터
		msgMap.put("KAKAO_MSG_CNTN", alarmForm.getAlarmTalkTemplateToJson(templateId, msgMap));
		msgMap.put("KAKAO_TPL_C", templateId);
		msgMap.put("ADJ_BRC", sendPhoneInfo.get("ADJ_BRC"));			//사무소 코드 
		msgMap.put("RLNO", "BATCH");	// RLNO (사용자 사번)
		msgMap.put("IO_TIT","");		//제목 : 미사용이라 space로 채움
		msgMap.put("IO_DPAMN_MED_ADR", reVo.get("MB_MPNO"));		//수신 휴대폰번호
		msgMap.put("IO_SDMN_MED_ADR", sendPhoneInfo.get("TEL_NO"));			//발신 조합전화번호
		
		// fail-back 필요 파라메터(알람톡 실패시 문자 전송)
		msgMap.put("FBK_UYN", "Y");			//fail-back 사용여부
		msgMap.put("FBK_TIT","");
		msgMap.put("FBK_MSG_DSC","7");	//3:SMS, 7:LMS
		msgMap.put("UMS_FWDG_CNTN", msgMap.getOrDefault("MSG_CNTN","").toString());	// UMS_FWDG_CNTN fail-back 메세지 내용
		msgMap.put("IO_ATGR_ITN_TGRM_LEN", msgMap.getOrDefault("UMS_FWDG_CNTN","").toString().getBytes().length);	// IO_ATGR_ITN_TGRM_LEN (UMS_FWDG_CNTN의 바이트 수)
		
		mcaMap = mcaUtil.tradeMcaMsg("5100", msgMap);
		Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");	
		//전송여부
		msgMap = convertConfig.changeKeyUpper(msgMap);				
		msgMap.put("TMS_YN", dataMap.get("RZTC"));
		msgMap.put("TMS_TYPE", "02");
		
		lalm0899Service.LALM0899_insMca3100(msgMap);
	}

	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> batchDashBoardSave(Map<String, Object> map) throws Exception{
		Map<String,Object> reMap = new HashMap<String, Object>();
		StringBuffer error = new StringBuffer();
		int insertNum = 0;
		int deleteNum = 0;
		int failCnt = 0;
		int succCnt = 0; 
		
		deleteNum += batchMapper.delDashBoardSaveForDay(map);
		insertNum += batchMapper.insDashBoardSaveForDay(map); 
		succCnt++;
		deleteNum += batchMapper.delDashBoardSaveForTop(map);
		insertNum += batchMapper.insDashBoardSaveForTop(map);
		succCnt++;
		deleteNum += batchMapper.delDashBoardSaveForMonth(map);
		insertNum += batchMapper.insDashBoardSaveForMonth(map); 
		succCnt++; 
		//deleteNum += batchMapper.delDashBoardSaveForMkpr(map);
		//insertNum += batchMapper.insDashBoardSaveForMkpr(map); 
		//succCnt++;
		//deleteNum += batchMapper.delDashBoardSaveForAreaAvgMkpr(map);
		//insertNum += batchMapper.insDashBoardSaveForAreaAvgMkpr(map); 
		//succCnt++;
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("failCnt", failCnt);
		reMap.put("succCnt", succCnt);
		reMap.put("error", error.toString());
		return reMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> batchDashBoardBtc(Map<String, Object> map) throws Exception{	
		Map<String,Object> reMap = new HashMap<String, Object>();
		StringBuffer error = new StringBuffer();
		int insertNum = 0;
		int deleteNum = 0;
		int failCnt = 0;
		int succCnt = 0; 
		
		//해당 조합의 최대 경매일수 조회(null일시 어떤값부를지는 미정)
		Map<String,Object> tempMap = new HashMap<>();
		tempMap.put("BTC_DT",LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		//tempMap.put("BTC_DT","20160901");
		tempMap.put("SRA_SRS_DSC", "01");
		
		//대시보드용 경매차수 조회
		Map<String, Object> mcaMap = mcaUtil.tradeMcaMsg("5600", tempMap);
		Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
		List<Map<String, Object>> rpt_data = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
		List<Map<String, Object>> btcList = null;
		deleteNum += batchMapper.delDashBoardBtc(tempMap);
		if(rpt_data != null && !rpt_data.isEmpty()) {
			btcList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
			for(Map<String, Object> btcMap: btcList) {
				try {
					//임시로 데이터 경매구분 단일로해서 등록
					insertNum += batchMapper.insDashBoardBtc(btcMap);
					succCnt++;
				}catch(Exception e) {
					log.error("message", e);
					if("".equals(error.toString())) {
						error.append(this.getExceptionErrorMessage(e));
					}
					failCnt++;
					throw e;
				}
			}
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("failCnt", failCnt);
		reMap.put("succCnt", succCnt);
		reMap.put("error", error.toString());
		return reMap;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> batchDashBoardBtAuc(Map<String, Object> map) throws Exception{		
		Map<String,Object> reMap = new HashMap<String, Object>();
		StringBuffer error = new StringBuffer();
		int insertNum = 0;
		int deleteNum = 0;
		int failCnt = 0;
		int succCnt = 0; 
		
		//해당 조합의 최대 경매일수 조회(null일시 어떤값부를지는 미정)
		Map<String,Object> tempMap = new HashMap<>();
		tempMap.put("AUC_DT",LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
		//tempMap.put("AUC_DT","20160901");
		tempMap.put("SRA_SRS_DSC", "01");

		//대시보드용 경매차수 조회
		Map<String, Object> mcaMap = mcaUtil.tradeMcaMsg("5500", tempMap);
		Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");
		List<Map<String, Object>> rpt_data = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
		List<Map<String, Object>> btcAucList = null;			
		if(rpt_data != null && !rpt_data.isEmpty()) {
			deleteNum += batchMapper.delDashBoardBtcAuc(tempMap);
			btcAucList = (List<Map<String, Object>>) dataMap.get("RPT_DATA");
				
			for(Map<String, Object> btcAucMap: btcAucList) {
				try {
					//임시로 데이터 경매구분 단일로해서 등록
					insertNum += batchMapper.insDashBoardBtcAuc(btcAucMap);
					succCnt++;
				}catch(Exception e) {
					log.error("message", e);
					if("".equals(error.toString())) {
						error.append(this.getExceptionErrorMessage(e));
					}
					failCnt++;
					throw e;
				}
			}
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("deleteNum", deleteNum);
		reMap.put("failCnt", failCnt);
		reMap.put("succCnt", succCnt);
		reMap.put("error", error.toString());
		return reMap;
	}

}
