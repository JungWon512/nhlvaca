package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1007Service {
	

	List<Map<String, Object>> LALM1007_selList_MhAucQcn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1007_selListTbl_Mmmwmn(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListGrd_MhSogCow(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListGrd_MhSogCowF(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListGrd_MhSogCowM(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListGrd_MdMwmnAdj(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdj(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdj_f(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdj_m(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_selAucEntr(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_updEntrGive(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_updEntrTake(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_insRv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_updRv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_delRv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_selRmkcntn(Map<String, Object> map) throws Exception;
	
	Map<String, Object> LALM1007_insAdj(Map<String, Object> map) throws Exception;

	/**
	 * @methodName    : LALM1007_updAucEntrDdl
	 * @author        : Jung JungWon
	 * @date          : 2023.08.11
	 * @Comments      : 
	 */
	Map<String, Object> LALM1007_updAucEntrDdl(Map<String, Object> map) throws Exception;

	
	

}
