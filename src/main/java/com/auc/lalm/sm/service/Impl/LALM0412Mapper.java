package com.auc.lalm.sm.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0412Mapper {

	List<Map<String, Object>> Lalm0412_selList_MhAucQcn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0412_selListTbl_Mmmwmn(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0412_selListFrm_MdMwmnAdj(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0412_selListFrm_MdMwmnAdjFm(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0412_selListGrd_MhSogCow(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> LALM0412_selListGrd_MhSogCowFm(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0412_selListGrd_MdMwmnAdj(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0412_selAucEntr(Map<String, Object> map) throws Exception;

	int LALM0412_updEntrGive(Map<String, Object> map) throws Exception;

	int LALM0412_updEntrTake(Map<String, Object> map) throws Exception;

	int LALM0412_selRvSqno(Map<String, Object> map) throws Exception;

	int LALM0412_insRv(Map<String, Object> map) throws Exception;

	int LALM0412_updRv(Map<String, Object> map) throws Exception;

	int LALM0412_updEntr(Map<String, Object> map) throws Exception;

	int LALM0412_delRv(Map<String, Object> map) throws Exception;

	Map<String, Object> LALM0412_chkRmkcntn(Map<String, Object> map) throws Exception;

	int LALM0412_v_rv_sqno(Map<String, Object> map) throws Exception;

	int LALM0412_insAdj(Map<String, Object> map) throws Exception;

	/**
	 * @methodName    : LALM0412_updAucEntrDdl
	 * @author        : Jung JungWon
	 * @date          : 2023.08.11
	 * @Comments      : 
	 */
	int LALM0412_updAucEntrDdl(Map<String, Object> map) throws Exception;

	

}
