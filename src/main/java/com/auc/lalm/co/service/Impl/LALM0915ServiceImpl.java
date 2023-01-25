package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.co.service.LALM0915Service;

@Service("LALM0915Service")
public class LALM0915ServiceImpl implements LALM0915Service{

	@Autowired
	LALM0915Mapper lalm0915Mapper;

	@Override
	public Map<String, Object> LALM0915_selUsr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		updateNum = lalm0915Mapper.LALM0915_selUsr(map);
		if(updateNum < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"사용자 가입시 등록한 정보와 일치하지 않습니다.");
		}
		reMap.put("updateNum", updateNum);
		return reMap;
	}	
	
	@Override
	public Map<String, Object> LALM0915_selPW(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = lalm0915Mapper.LALM0915_selPW(map);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0915_selJoinBzPlcInfo(Map<String, Object> map) throws Exception {
		return lalm0915Mapper.LALM0915_selJoinBzPlcInfo(map);
	}

}
