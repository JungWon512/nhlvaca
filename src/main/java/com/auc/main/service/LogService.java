package com.auc.main.service;

import java.util.Map;

public interface LogService {

	int insUserLog(Map<String, Object> map) throws Exception;
	int insSogCowLog(Map<String, Object> map) throws Exception;
	
	int insMmIndvLog(Map<String, Object> map) throws Exception;

	int insMwmnLog(Map<String, Object> logMap) throws Exception;
}
