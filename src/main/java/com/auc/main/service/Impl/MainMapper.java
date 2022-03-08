package com.auc.main.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MainMapper {

	List<Map<String, Object>> getUserList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectMenuList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectPopupList(Map<String, Object> map) throws Exception;

	int signCheck(Map<String, Object> map) throws Exception;

	String passwordCheck(Map<String, Object> map) throws Exception;

	Map<String, Object> getLoginInfo(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> MainSogYear_selList(Map<String, Object> map) throws Exception;	
	
	List<Map<String, Object>> MainSogQcn_selList(Map<String, Object> map) throws Exception;	
	
	List<Map<String, Object>> MainNotice_selList(Map<String, Object> map) throws Exception;	
	
	Map<String,String> signIn(Map<String, Object> paraMap);
	
	int updPwerr_nt(Map<String, String> map);
	
	int updPwerr_ntInit(Map<String, String> map);
	
	int updNaBzplc(Map<String, Object> map);

	List<Map<String, Object>> selectBtnList(Map<String, Object> map);

	List<Map<String, Object>> selectBtnAuthList(Map<String, Object> map);

	List<Map<String, Object>> selectComboList(Map<String, Object> map);
	
	List<Map<String, Object>> selectWmcListData(Map<String, Object> map);

	List<Map<String, Object>> selectEnvListData(Map<String, Object> map);

	List<Map<String, Object>> selectNaList();
	
	int updatePassword(Map<String, Object> map) throws Exception;

	int selChkPw(String usrid, String user_pw);

	

	
	

}
