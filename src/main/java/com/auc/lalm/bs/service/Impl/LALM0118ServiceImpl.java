package com.auc.lalm.bs.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.bs.service.LALM0118Service;

@Service("LALM0118Service")
public class LALM0118ServiceImpl implements LALM0118Service{

	@Autowired
	LALM0118Mapper lalm0118Mapper;	

	@Override
	public List<Map<String, Object>> LALM0118_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0118Mapper.LALM0118_selList(map);
		return list;
	 
	}

	@Override
	public Map<String, Object> LALM0118_selBlackDetail(Map<String, Object> map) throws Exception {
		Map<String, Object> selMap = null;
		selMap = lalm0118Mapper.LALM0118_selBlackDetail(map);
		return selMap;
	}

	@Override
	public Map<String, Object> LALM0118_insBlackList(Map<String, Object> map) throws Exception {
		int reg_seq = this.regSeqParamTransformNum(map.get("reg_seq").toString());
		int updInsNum = 0;
		Map<String, Object> reMap = new HashMap<String, Object>();		
		
		if(reg_seq > 0) {
			//update
			map.put("reg_seq", reg_seq);
			updInsNum = lalm0118Mapper.LALM0118_updBlack(map);	
			reMap.put("updateNum", updInsNum);
		}else {
			//insert
			updInsNum = lalm0118Mapper.LALM0118_insBlack(map);	
			reMap.put("insertNum", updInsNum);
		}
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0118_delBlack(Map<String, Object> map) throws Exception {
		int reg_seq = this.regSeqParamTransformNum(map.get("reg_seq").toString());
		int deleteNum = 0;
		Map<String, Object> reMap = new HashMap<String, Object>();		
		
		if(reg_seq <= 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "현재 선택하신 데이터는 아직 미등록된 데이터 입니다.<br/>확인 부탁드립니다.");
		}else {
			map.put("reg_seq", reg_seq);
			deleteNum = lalm0118Mapper.LALM0118_delBlack(map);
			reMap.put("deleteNum", deleteNum);
		}
		
		return reMap;
	}

	private int regSeqParamTransformNum(String seqno) {
		int reg_seq = 0;
		if(seqno == null || "".equals(seqno)) {
			reg_seq = 0;
		}else {
			reg_seq = Integer.parseInt(seqno);
		}
		return reg_seq;
	}

	@Override
	public List<Map<String, Object>> LALM0118_selBzplcLoc(Map<String, Object> map) throws Exception {
		return lalm0118Mapper.LALM0118_selBzplcLoc(map);
	}

	@Override
	public List<Map<String, Object>> LALM0118_selClntnm(Map<String, Object> map) throws Exception {
		return lalm0118Mapper.LALM0118_selClntnm(map);
	}
}
