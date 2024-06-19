package com.auc.batch.controller;

import java.io.StringWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.auc.batch.service.BatchService;
import com.auc.common.util.StringUtils;
import com.auc.common.vo.ResolverMap;
import com.auc.mca.McaUtil;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 배치 메소드명 : batch_BJ_LM_{배치아이디넘버값}  으로 선언하기
 * 배치 job id : BJ-LM-0000 형태
 * 수동 수행 파라미터 : exec_flag=Y
 * [LALM0839] 배치로그 관리 메뉴에서 실패한 배치 로그에 대한 재실행 가능함 
 */

@RestController
public class BatchController {

	private static Logger log = LoggerFactory.getLogger(BatchController.class);
	
	ObjectMapper mapper = new ObjectMapper();
	
	@Autowired 
	BatchService batchService;
	
	@Autowired 
	McaUtil mcaUtil;
	
	@Value("${server.type}")
	private String serverType;
	
	@Value("${admin.sms}")
	private String adminSms;

	/**
	 * 외부 API실행용 BATCH
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/api/batch/{pathNm}")
	public Map<String, Object> apiBatch(@PathVariable String pathNm, @RequestParam(required=false) Map<String, Object> request, ResolverMap rMap){
		Map<String, Object> reMap = new HashMap<String, Object>();
		//String pathNm = (String)rMap.get("pathNm");
		switch (pathNm) {
		case "BJ-LM-0010":
			reMap = this.batch_BJ_LM_0010(request, rMap);			
			break;
		case "BJ-LM-0011":
			reMap = this.batch_BJ_LM_0011(request, rMap);			
			break;
		case "BJ-LM-0020":
			reMap = this.batch_BJ_LM_0020(request, rMap);			
			break;
		case "BJ-LM-0040":
			reMap = this.batch_BJ_LM_0040(request, rMap);			
			break;
		}
		return reMap;		
	}
	
	/**
	 * 중도매인, 출하주(농가) 휴면처리
	 * 회원통합테이블의 휴면예정일자가 어제인 것 휴면 처리하기 (익일 새벽에 배치 실행하기 때문에)
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/batch/batch_BJ_LM_0040")
	public Map<String, Object> batch_BJ_LM_0040(@RequestParam(required=false) Map<String, Object> request, ResolverMap rMap){	
		int allCnt = 0, succCnt = 0, failCnt = 0; 
		int execCount = 0, batActSeq = 0, updateNum = 0;
		String exec_flag = "", bat_act_dt = "";
		StringBuffer error = new StringBuffer();
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> paramSet = this.getParameterReqMap(request, rMap);
		
		try {
			map.put("batch_job_id", "BJ-LM-0040");		//BJ-LM-0040 : 회원 휴면처리
			map.put("batch_cycle", "D");		//D : 하루 주기
			
			execCount = batchService.getExecBatchCount(map);	//지정된 횟수 초과 실행 체크
			
			if(!paramSet.isEmpty()) {
				exec_flag = paramSet.get("exec_flag") != null ? paramSet.get("exec_flag").toString() : "";
				bat_act_dt = paramSet.get("bat_act_dt") != null ? paramSet.get("bat_act_dt").toString() : "";
				
				//휴면회원 로직만 하루 전날로 셋팅하기 
				if(!"".equals(bat_act_dt)) {
					SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
					Date date = formatter.parse(bat_act_dt);
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(date);
					calendar.add(Calendar.DATE, -1);
					bat_act_dt = formatter.format(calendar.getTime());
				}
				
				map.put("bat_act_dt", bat_act_dt);
			}
			
			if(!"".equals(exec_flag) && "Y".equals(exec_flag)) {		//수동 실행 플래그가 Y인 경우 수행횟수 0으로 체크
				execCount = 0;
			}
			
			batActSeq = batchService.insBeforeBatchLog(map);		//로그 INSERT
			
			if(execCount == 0) {
				List<Map<String, Object>> reList = batchService.selDormaccMmMbintgList(map);
				allCnt = reList == null ? 0 : reList.size();
				if(allCnt > 0) {
					for(Map<String, Object> reVo : reList) {
						Map<String, Object> inMap;
						try {
							inMap = batchService.insUpdDormUserMasking(reVo);
							reMap = batchService.createResultCUDBatch(inMap);
							succCnt++;
						}
						catch(RuntimeException | SQLException e) {
							log.error("BatchController.batch_BJ_LM_0040 : {} ", e);
							if("".equals(error.toString())) {
								error.append(this.getExceptionErrorMessage(e));
							}
							failCnt++;
						}
						catch(Exception e) {
							log.error("BatchController.batch_BJ_LM_0040 : {} ", e);
							if("".equals(error.toString())) {
								error.append(this.getExceptionErrorMessage(e));
							}
							failCnt++;
						}
					}
				}
			}
			else{
				reMap.put("status", 201);
				reMap.put("code", "C001");
				error.append("지정된 횟수 초과 실행");
				failCnt++;
			}
		}
		catch(RuntimeException | SQLException e) {
			log.error("BatchController.batch_BJ_LM_0040 : {} ", e);
			error.append(this.getExceptionErrorMessage(e));
			reMap.put("status", 201);
			reMap.put("code", "C001");
		}
		catch(Exception e) {
			log.error("BatchController.batch_BJ_LM_0040 : {} ", e);
			error.append(this.getExceptionErrorMessage(e));
			reMap.put("status", 201);
			reMap.put("code", "C001");
		}
		finally {
			reMap.put("batch_job_id", map.get("batch_job_id"));
			reMap.put("batch_cycle", map.get("batch_cycle"));
			reMap.put("bat_act_seq", batActSeq);
			reMap.put("bat_suc_yn", (failCnt <= 0) ? "S" : "F");
			reMap.put("message", this.setBatchResultMessage(allCnt, succCnt, failCnt, error.toString()));
			
			try {
				updateNum = batchService.updAfterBatchLog(reMap);
				reMap.put("updateNum", updateNum);
				
				if(failCnt > 0) {
					this.sendSmsBatchFail(reMap);
				}
			}
			catch (RuntimeException | SQLException e) {
				log.error("BatchController.batch_BJ_LM_0040 > finally : {} ", e);
			}
			catch (Exception e) {
				log.error("BatchController.batch_BJ_LM_0040 > finally  : {} ", e);
			}
		}
		
		return reMap;
	}
	/**
	 * 휴면예정 대상자 알림톡 발송 배치
	 * 회원통합테이블의 휴면예정일자가 오늘로부터 30일 이전인 데이터
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping("/batch/batch_BJ_LM_0020")
	public Map<String, Object> batch_BJ_LM_0020(@RequestParam(required=false) Map<String, Object> request, ResolverMap rMap){	
		int allCnt = 0, succCnt = 0, failCnt = 0; 
		int execCount = 0, batActSeq = 0, updateNum = 0;
		String exec_flag = "", bat_act_dt = "";
		StringBuffer error = new StringBuffer();
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> paramSet = this.getParameterReqMap(request, rMap);
		
		try {
			map.put("batch_job_id", "BJ-LM-0020");		//BJ-LM-0020 : 휴면 대상자 알림톡 발송
			map.put("batch_cycle", "D");		//D : 하루 주기
			
			execCount = batchService.getExecBatchCount(map);	//지정된 횟수 초과 실행 체크
			
			if(!paramSet.isEmpty()) {
				exec_flag = paramSet.get("exec_flag") != null ? paramSet.get("exec_flag").toString() : "";
				bat_act_dt = paramSet.get("bat_act_dt") != null ? paramSet.get("bat_act_dt").toString() : "";
				map.put("bat_act_dt", bat_act_dt);
			}
			
			if(!"".equals(exec_flag) && "Y".equals(exec_flag)) {		//수동 실행 플래그가 Y인 경우 수행횟수 0으로 체크
				execCount = 0;
			}
			
			batActSeq = batchService.insBeforeBatchLog(map);		//로그 INSERT
			
			if(execCount == 0) {
				List<Map<String, Object>> reList = batchService.selDormcPreUserMbintgList(map);
				allCnt = reList == null ? 0 : reList.size();
				if(allCnt > 0) {
					for(Map<String, Object> reVo : reList) {
						try {
							reVo.put("batchFlag", "Y");
							Map<String, Object> resultMap = batchService.sendAlarmTalk_DormacPreUser(reVo);
							succCnt++;
						}
						catch(RuntimeException | SQLException e) {
							log.error("BatchController.batch_BJ_LM_0020 : {} ", e);
							if("".equals(error.toString())) {
								error.append(this.getExceptionErrorMessage(e));
							}
							failCnt++;
						}
						catch(Exception e) {
							log.error("BatchController.batch_BJ_LM_0020 : {} ", e);
							if("".equals(error.toString())) {
								error.append(this.getExceptionErrorMessage(e));
							}
							failCnt++;
						}
					}
				}
			}
			else{
				reMap.put("status", 201);
				reMap.put("code", "C001");
				error.append("지정된 횟수 초과 실행");
				failCnt++;
			}
		}
		catch(RuntimeException | SQLException e) {
			log.error("BatchController.batch_BJ_LM_0020 : {} ", e);
			error.append(this.getExceptionErrorMessage(e));
			reMap.put("status", 201);
			reMap.put("code", "C001");
		}
		catch(Exception e) {
			log.error("BatchController.batch_BJ_LM_0020 : {} ", e);
			error.append(this.getExceptionErrorMessage(e));
			reMap.put("status", 201);
			reMap.put("code", "C001");
		}
		finally {
			reMap.put("batch_job_id", map.get("batch_job_id"));
			reMap.put("batch_cycle", map.get("batch_cycle"));
			reMap.put("bat_act_seq", batActSeq);
			reMap.put("bat_suc_yn", (failCnt <= 0) ? "S" : "F");
			reMap.put("message", this.setBatchResultMessage(allCnt, succCnt, failCnt, error.toString()));
			
			try {
				updateNum = batchService.updAfterBatchLog(reMap);
				reMap.put("updateNum", updateNum);
				
				if(failCnt > 0) {
					this.sendSmsBatchFail(reMap);
				}
			}
			catch (RuntimeException | SQLException e) {
				log.error("BatchController.batch_BJ_LM_0020 > finally : {} ", e);
			}
			catch (Exception e) {
				log.error("BatchController.batch_BJ_LM_0020 > finally  : {} ", e);
			}
		}
		
		return reMap;
	}
	//----------------------------------------[s 공통 메소드]-------------------------------------------//
	
	/**
	 * 배치 실패 시, 담당자에게 문자 전송 : 축경통 인터페이스 통해서 보내는 문자 확인 필요
	 * @param reMap
	 * @throws Exception 
	 */
	private void sendSmsBatchFail(Map<String, Object> reMap) throws Exception {
		//추후 NA_BZPLC 가 확정되면 주석 해제할 예정
		if(!"local".equals(serverType)) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("NA_BZPLC", "8808990499055");
			map.put("CUS_MPNO", adminSms);
			map.put("USRNM", "담당자");
			map.put("MSG_CNTN", "[스마트가축시장-배치에러] "+reMap.get("batch_job_id") +" 배치에 에러 "+ reMap.get("failCnt") +" 건 발생하였습니다. 확인 부탁드립니다.");
			mcaUtil.tradeMcaMsg("3100", map);
		}
	}

	/**
	 * 배치 결과 메세지 toString
	 * @param allCnt
	 * @param succCnt
	 * @param failCnt
	 * @param errMsg
	 * @return
	 */
	private String setBatchResultMessage(int allCnt, int succCnt, int failCnt, String errMsg) {
		StringBuffer sb = new StringBuffer();
		sb.append("allCnt : ").append(allCnt).append(", succCnt : ").append(succCnt).append(", failCnt : ").append(failCnt);
		
		if(!"".equals(errMsg)) {
			//BAT_RST_MSG 컬럼 사이즈 2,000 => cnt 정보 + 에러 메세지 최대 (1,900bytes)
			sb.append(", errorMsg : " + errMsg.substring(0, errMsg.length() > 1900 ? 1900 : errMsg.length()));
		}
		return sb.toString();
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
		errorTxtLen = errors.toString().length();

		if(errorTxtLen > errorSubstrLen) {
			result = errors.toString().substring(0, errorSubstrLen);
		}else {
			result = errors.toString();
		}
		return result;
	}

	/**
	 * parameter 들어오는 값 셋팅해주기
	 * @param request : URL에 직접 파라미터 넣어서 테스트 하는 경우(주로 개발할 때)
	 * @param rMap : 배치로그 관리에서 실패한 배치 재실행 하는 경우(운영 시 필요하면)
	 * @return
	 */
	private Map<String, Object> getParameterReqMap(Map<String, Object> request, ResolverMap rMap) {
		String exec_flag = "";
		String bat_act_dt = "";
		Map<String, Object> param;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			param = this.conMap(rMap);

			//배치로그 관리 페이지에서 재실행 했을 경우
			if(!param.isEmpty()) {
				exec_flag = param.get("exec_flag").toString();
				bat_act_dt = param.get("bat_act_dt").toString();
			}
			
			//URL에 직접 파라미터 호출할 경우
			if(!request.isEmpty()) {
				if(request.get("exec_flag") != null) {
					exec_flag = request.get("exec_flag").toString();
				}
				
				if(request.get("bat_act_dt") != null) {
					bat_act_dt = request.get("bat_act_dt").toString();
				}
			}
			
			resultMap.put("exec_flag", exec_flag);
			resultMap.put("bat_act_dt", bat_act_dt);
			
		}
		catch (RuntimeException e) {
			log.error("BatchController.getParameterReqMap : {} ", e);
		}
		catch (Exception e) {
			log.error("BatchController.getParameterReqMap : {} ", e);
		}
		
		return resultMap;
	}

	/**
	 * ResolverMap 파라미터 Map 형태로 변환하는 메소드
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> conMap(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		String data = (rMap == null || rMap.get("data") == null) ? "" : rMap.get("data").toString();
		
		if(data != null && !"".equals(data)) {
			Map<String, Object> getMap = mapper.readValue(data, HashMap.class);
			
			List<Map<String, Object>> inList = null;
			Map<String, Object> enMap = null;
			
			for (Map.Entry<String, Object> entry : getMap.entrySet()) {	    
				//리스트일때
				if(entry.getValue() instanceof List) {
					inList = (List<Map<String, Object>>) entry.getValue();
					int listCnt = 0;
					listCnt = inList.size();
					Map<String, Object> inMap = null;
					
					for (int i = 0; i < listCnt; i++) {	        		
						if(inList.get(i) instanceof Map) {	        			
							Map<String, Object> inListMap = inList.get(i);	
							
							inMap = new HashMap<String, Object>();
							
							for(Map.Entry<String, Object> inEntry : inListMap.entrySet()) {
								if(inEntry.getValue() instanceof String) {
									inMap.put(inEntry.getKey().toLowerCase(), StringUtils.xxsFilter((String)inEntry.getValue()));
								}else {
									inMap.put(inEntry.getKey().toLowerCase(), inEntry.getValue());
								}
							}
							
							inList.remove(inListMap);
							inList.add(i, inMap);
						}
					}
					//맵일때
				}else if(entry.getValue() instanceof Map) {
					enMap = (Map<String, Object>) entry.getValue();	        	
					Map<String, Object> inMap = new HashMap<String, Object>();
					//키 소문자로 변환
					Set<String> inSet = enMap.keySet();
					Iterator<String> inEt = inSet.iterator();
					while(inEt.hasNext()){
						String key = inEt.next();
						if(enMap.get(key) instanceof String) {
							inMap.put(key.toLowerCase(), StringUtils.xxsFilter((String)enMap.get(key)));
						}else {
							inMap.put(key.toLowerCase(), enMap.get(key));
						}
					}
					
					getMap.put(entry.getKey(), inMap);
				}	
			}	    		
			
			//키 소문자로 변환
			Set<String> set = getMap.keySet();
			Iterator<String> e = set.iterator();
			
			while(e.hasNext()){
				String key = e.next();
				if(getMap.get(key) instanceof String) {
					map.put(key.toLowerCase(), StringUtils.xxsFilter((String)getMap.get(key)));
				}else {
					map.put(key.toLowerCase(), getMap.get(key));
				}
			}
		}
		
		return map;
	}

	//----------------------------------------[e 공통 메소드]-------------------------------------------//

	@RequestMapping("/batch/batch_BJ_LM_0010")
	public Map<String, Object> batch_BJ_LM_0010(@RequestParam(required=false) Map<String, Object> request, ResolverMap rMap) {
		return this.commonBatch("BJ-LM-0010",request, rMap);
	}
	@RequestMapping("/batch/batch_BJ_LM_0011")
	public Map<String, Object> batch_BJ_LM_0011(@RequestParam(required=false) Map<String, Object> request, ResolverMap rMap) {
		return this.commonBatch("BJ-LM-0011",request, rMap);
	}
	
	
	public Map<String, Object> commonBatch(String jobName,Map<String, Object> request, ResolverMap rMap) {	
		int allCnt = 0, succCnt = 0, failCnt = 0; 
		int execCount = 0, batActSeq = 0, updateNum = 0;
		String exec_flag = "", bat_act_dt = "";
		StringBuffer error = new StringBuffer();
		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> tempMap = new HashMap<String, Object>();
		Map<String, Object> paramSet = this.getParameterReqMap(request, rMap);
		
		try {
			map.put("batch_job_id", jobName);		//BJ-LM-0010 : 대시보드 수신
			map.put("batch_cycle", "D");		//D : 하루 주기
			
			execCount = batchService.getExecBatchCount(map);	//지정된 횟수 초과 실행 체크
			
			if(!paramSet.isEmpty()) {
				exec_flag = paramSet.get("exec_flag") != null ? paramSet.get("exec_flag").toString() : "";
				bat_act_dt = paramSet.get("bat_act_dt") != null ? paramSet.get("bat_act_dt").toString() : "";
				map.put("bat_act_dt", bat_act_dt);
			}
			
			if(!"".equals(exec_flag) && "Y".equals(exec_flag)) {		//수동 실행 플래그가 Y인 경우 수행횟수 0으로 체크
				execCount = 0;
			}
			
			batActSeq = batchService.insBeforeBatchLog(map);		//로그 INSERT
			
			if(execCount == 0) {
				List<Map<String,Object>> bizList =null;
				switch (jobName) {
				case "BJ-LM-0010":
					/* TB_LA_IS_BM_BZLOC AUC_YN이 N인항목만 조회(현재 서비스하지않는 조합 조회)
					 * 조합별 개별 TRANSACTION 체크를 위해 조합조회 후 각 조합 별로 INTERFACE 
					 */
					map.put("aucYn", "N");
					bizList = batchService.selBzLocAucYn(map);
					
					for(Map<String,Object> bizMap : bizList) {
						log.debug("S : BJ0010 : "+bizMap.get("NA_BZPLC"));
						tempMap = batchService.batchDashBoardFor5300(map,bizMap);//경매차수
						failCnt += (int) tempMap.get("failCnt");
						succCnt += (int) tempMap.get("succCnt");
						
						tempMap = batchService.batchDashBoardFor5200(map,bizMap);//출장우
						failCnt += (int) tempMap.get("failCnt");
						succCnt += (int) tempMap.get("succCnt");
						
						tempMap = batchService.batchDashBoardFor5400(map,bizMap);//접수번호
						failCnt += (int) tempMap.get("failCnt");
						succCnt += (int) tempMap.get("succCnt");

						log.debug("E : BJ0010 : "+bizMap.get("NA_BZPLC"));
					}
					
					break;
				case "BJ-LM-0011":
					tempMap = batchService.batchDashBoardSave(map);
					failCnt += (int) tempMap.get("failCnt");
					succCnt += (int) tempMap.get("succCnt");
					error.append(tempMap.get("error"));	

					map.put("BTC_DT", rMap.get("BTC_DT"));
					map.put("AUC_DT", rMap.get("BTC_DT"));
					tempMap = batchService.batchDashBoardBtc(map);
					failCnt += (int) tempMap.get("failCnt");
					succCnt += (int) tempMap.get("succCnt");
					error.append(tempMap.get("error"));
					tempMap = batchService.batchDashBoardBtAuc(map);
					failCnt += (int) tempMap.get("failCnt");
					succCnt += (int) tempMap.get("succCnt");
					error.append(tempMap.get("error"));
					break;
				}
			}
			else{
				reMap.put("status", 201);
				reMap.put("code", "C001");
				error.append("지정된 횟수 초과 실행");
				failCnt++;
			}
		}
		catch(RuntimeException | SQLException e) {
			log.error("BatchController.commonBatch : {} ", e);
			error.append(this.getExceptionErrorMessage(e));
			reMap.put("status", 201);
			reMap.put("code", "C001");
		}
		catch(Exception e) {
			log.error("BatchController.commonBatch : {} ", e);
			error.append(this.getExceptionErrorMessage(e));
			reMap.put("status", 201);
			reMap.put("code", "C001");
		}
		finally {
			reMap.put("batch_job_id", map.get("batch_job_id"));
			reMap.put("batch_cycle", map.get("batch_cycle"));
			reMap.put("bat_act_seq", batActSeq);
			reMap.put("bat_suc_yn", (failCnt <= 0) ? "S" : "F");
			reMap.put("message", this.setBatchResultMessage(allCnt, succCnt, failCnt, error.toString()));
			
			try {
				updateNum = batchService.updAfterBatchLog(reMap);
				reMap.put("updateNum", updateNum);
				
				if(failCnt > 0) {
					reMap.put("failCnt", failCnt);
					this.sendSmsBatchFail(reMap);
				}
			}
			catch (RuntimeException | SQLException e) {
				log.error("BatchController.commonBatch > finally : {} ", e);
			}
			catch (Exception e) {
				log.error("BatchController.commonBatch > finally : {} ", e);
			}
		}
		
		return reMap;
	}
}
