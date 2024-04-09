package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1007Mapper {

	List<Map<String, Object>> Lalm1007_selList_MhAucQcn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1007_selListTbl_Mmmwmn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdj(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdjFm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListGrd_MhSogCow(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM1007_selListGrd_MhSogCowFm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM1007_selListGrd_MdMwmnAdj(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_selAucEntr(Map<String, Object> map) throws Exception;

	int LALM1007_updEntrGive(Map<String, Object> map) throws Exception;

	int LALM1007_updEntrTake(Map<String, Object> map) throws Exception;

	int LALM1007_selRvSqno(Map<String, Object> map) throws Exception;

	int LALM1007_insRv(Map<String, Object> map) throws Exception;

	int LALM1007_updRv(Map<String, Object> map) throws Exception;

	int LALM1007_updEntr(Map<String, Object> map) throws Exception;

	int LALM1007_delRv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM1007_chkRmkcntn(Map<String, Object> map) throws Exception;

	int LALM1007_v_rv_sqno(Map<String, Object> map) throws Exception;

	int LALM1007_insAdj(Map<String, Object> map) throws Exception;

	/**
	 * @methodName    : LALM1007_updAucEntrDdl
	 * @author        : Jung JungWon
	 * @date          : 2023.08.11
	 * @Comments      : 
	 */
	int LALM1007_updAucEntrDdl(Map<String, Object> map) throws Exception;

	

}
