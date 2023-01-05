package com.auc.main.service;

import java.util.List;
import java.util.Map;

public interface MainService {

	List<Map<String, Object>> getUserList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectMenuList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectPopupList(Map<String, Object> map) throws Exception;

	Map<String, Object> getLoginInfo(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectBtnList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectBtnAuthList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectComboList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> selectWmcListData(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectEnvListData(Map<String, Object> map) throws Exception;
	
	Map<String, Object> updatePassword(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> MainSogYear_selList(Map<String, Object> map) throws Exception;	
	
	List<Map<String, Object>> MainSogQcn_selList(Map<String, Object> map) throws Exception;	
	
	List<Map<String, Object>> MainNotice_selList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> selectNaList() throws Exception;

	List<Map<String, Object>> selectNaUserList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> MainSecApply_selList(Map<String, Object> map) throws Exception;
	
	

}
