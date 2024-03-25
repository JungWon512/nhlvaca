package com.auc.batch;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.auc.batch.controller.BatchController;
import com.auc.common.vo.ResolverMap;

@Component
public class TaskBatch {

	private static Logger log = LoggerFactory.getLogger(TaskBatch.class);

	@Autowired 
	BatchController batchController;
	
	@Value("${server.type}")
	private String serverType;
	
	private boolean isProdServerType() {
		boolean isProdFlag = false;
		if("production".equals(serverType)) {
			isProdFlag = true;
		}
		return isProdFlag; 
	}
	
	/**
	 * 회원 휴면처리 : 매일 새벽 1시 30분
	 */
	@Scheduled(cron = "0 30 1 * * *")
	public void batch_BJ_LM_0040() {
		ResolverMap rMap = new ResolverMap();
		Map<String, Object> request = new HashMap<String, Object>();
		
		try {
			//운영서버에서만 실행되게끔 처리
			if(!this.isProdServerType()) {
				return ;
			}
		
			batchController.batch_BJ_LM_0040(request, rMap);
			
		}
		catch (RuntimeException e) {
			log.error("TaskBatch.batch_BJ_LM_0040 : {} ", e);
		}
		catch (Exception e) {
			log.error("TaskBatch.batch_BJ_LM_0040 : {} ", e);
		}
	}

	
	/**
	 * 대시보드 데이터 수신
	 */
	@Scheduled(cron = "0 0 2 * * *")
	public void batch_BJ_LM_0010() {
		ResolverMap rMap = new ResolverMap();
		Map<String, Object> request = new HashMap<String, Object>();
		
		try {
			//운영서버에서만 실행되게끔 처리
			if(!this.isProdServerType()) {
				return ;
			}
		
			batchController.commonBatch("BJ-LM-0010",request, rMap);
			
		}
		catch (RuntimeException e) {
			log.error("TaskBatch.batch_BJ_LM_0010 : {} ", e);
		}
		catch (Exception e) {
			log.error("TaskBatch.batch_BJ_LM_0010 : {} ", e);
		}
	}

	
	/**
	 * 대시보드 통계 저장
	 */
	@Scheduled(cron = "0 0 3 * * *")
	public void batch_BJ_LM_0011() {
		ResolverMap rMap = new ResolverMap();
		Map<String, Object> request = new HashMap<String, Object>();
		
		try {
			//운영서버에서만 실행되게끔 처리
			if(!this.isProdServerType()) {
				return ;
			}
		
			batchController.commonBatch("BJ-LM-0011",request, rMap);
			
		}
		catch (RuntimeException e) {
			log.error("TaskBatch.batch_BJ_LM_0011 : {} ", e);
		}
		catch (Exception e) {
			log.error("TaskBatch.batch_BJ_LM_0011 : {} ", e);
		}
	}

	/**
	 * 휴면예정자 알림톡 발송 : 매일 오전 8시 30분
	 */
	@Scheduled(cron = "0 30 8 * * *")
	public void batch_BJ_LM_0020() {
		ResolverMap rMap = new ResolverMap();
		Map<String, Object> request = new HashMap<String, Object>();
		
		try {
			//운영서버에서만 실행되게끔 처리
			if(!this.isProdServerType()) {
				return ;
			}
		
			batchController.batch_BJ_LM_0020(request, rMap);
			
		}
		catch (RuntimeException e) {
			log.error("TaskBatch.batch_BJ_LM_0020 : {} ", e);
		}
		catch (Exception e) {
			log.error("TaskBatch.batch_BJ_LM_0020 : {} ", e);
		}
	}
	/**
	 * 3대혈통/본개체 종개협 연동 : 매일 새벽 2시 30분
	 */
	@Scheduled(cron = "0 30 2 * * *")
	public void batch_BJ_LM_0050() {
		ResolverMap rMap = new ResolverMap();
		Map<String, Object> request = new HashMap<String, Object>();
		
		try {
			//운영서버에서만 실행되게끔 처리
			if(!this.isProdServerType()) {
				return ;
			}
		
			batchController.commonBatch("BJ-LM-0050",request, rMap);
			
		}
		catch (RuntimeException e) {
			log.error("TaskBatch.batch_BJ_LM_0040 : {} ", e);
		}
		catch (Exception e) {
			log.error("TaskBatch.batch_BJ_LM_0040 : {} ", e);
		}
	}
}
