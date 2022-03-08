package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0916Service;

@Service("LALM0916Service")
public class LALM0916ServiceImpl implements LALM0916Service{

	@Autowired
	LALM0916Mapper lalm0916Mapper;

	@Override
	public Map<String, Object> LALM0916_selPw(Map<String, Object> map) throws Exception {
				
		Map<String, Object> outMap = lalm0916Mapper.LALM0916_selPw(map);
		return outMap;
		
	}
	@Override
	public Map<String, Object> LALM0916_updPw(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = updateNum + lalm0916Mapper.LALM0916_updPw(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}


}
