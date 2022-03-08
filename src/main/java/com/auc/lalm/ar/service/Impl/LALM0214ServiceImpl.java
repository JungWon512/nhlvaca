package com.auc.lalm.ar.service.Impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.ar.controller.LALM0211Controller;
import com.auc.lalm.ar.service.LALM0214Service;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;

@Service("LALM0214Service")
public class LALM0214ServiceImpl implements LALM0214Service{
	private static Logger log = LoggerFactory.getLogger(LALM0214ServiceImpl.class);

	@Autowired
	LogService logService;	
	@Autowired
	LALM0214Mapper lalm0214Mapper;	
	@Autowired
	CommonService commonService;	
		
	

	@Override
	public List<Map<String, Object>> LALM0214_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0214Mapper.LALM0214_selList(map);
		return list;		
	}
	
	
	@Override
	public List<Map<String, Object>> LALM0214_selAucQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0214Mapper.LALM0214_selAucQcn(map);
		return list;		
	}
	
	
	@Override
	public List<Map<String, Object>> LALM0214_selCalfList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0214Mapper.LALM0214_selCalfList(map);
		return list;		
	}
	
	
	@Override
	public int LALM0214_selAucTmsCnt(Map<String, Object> map) throws Exception {
		
		int iCnt = lalm0214Mapper.LALM0214_selAucTmsCnt(map);
		return iCnt;		
	}
	
	
	@Override
	public Map<String, Object> LALM0214_insFeeReset(Map<String, Object> map) throws Exception {
		int insertNum = 0;	
		//출장우 내역조회
		List<Map<String, Object>> grd_MhSogCow = lalm0214Mapper.LALM0214_selList2(map);
		
		if(grd_MhSogCow.size() < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"출장우가 없습니다.<br>상단의 검색조건을 확인해 주세요.");
		}	
		
		insertNum = commonService.Common_insFeeImps(grd_MhSogCow);
		
		
		
				
		Map<String, Object> reMap = new HashMap<String, Object>();
		reMap.put("insertNum", insertNum);			
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0214_selFeeImps(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = lalm0214Mapper.LALM0214_selFeeImps(map);
		return reMap;		
	}
	
	
	
	
	@Override
	public Map<String, Object> LALM0214_delSogCow(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;	
		int deleteNum = 0;	
		int updateNum = 0;
		//프로그램 DB 저장
		insertNum = logService.insSogCowLog(map);	
		reMap.put("insertNum", insertNum);	
		deleteNum = deleteNum + lalm0214Mapper.LALM0214_delSogCog(map);
		deleteNum = deleteNum + lalm0214Mapper.LALM0214_delFeeImps(map);
		deleteNum = deleteNum + lalm0214Mapper.LALM0214_delCalf(map);
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0214_delCntnDel(Map<String, Object> map) throws Exception{
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;	
		deleteNum = deleteNum + lalm0214Mapper.LALM0214_delCntnDel(map);
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}
	
	@Override
	public List<Map<String, Object>> LALM0214P1_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0214Mapper.LALM0214P1_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0214P4_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0214Mapper.LALM0214P4_selList(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0214P2_updCow(List<Map<String, Object>> inList) throws Exception {
		
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		
		for(int i = 0; i < inList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)inList.get(i);

			updateNum += lalm0214Mapper.LALM0214P2_updCow(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0214P4_updCowBun(List<Map<String, Object>> inList) throws Exception {
		
		Map<String, Object> reMap         = new HashMap<String, Object>();
		Map<String, Object> tmpObject     = null;
		
		int updateNum = 0;
		
		for(int i = 0; i < inList.size(); i ++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>)inList.get(i);

			updateNum += lalm0214Mapper.LALM0214P4_updCowBun(tmpObject);		
			reMap.put("updateNum", updateNum);
		}
		
		return reMap;
	}
	


}
