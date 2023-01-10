package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0128PService;

@Service("LALM0128PService")
public class LALM0128PServiceImpl implements LALM0128PService{

	@Autowired
	LALM0128PMapper lalm0128PMapper;	

	@Override
	public List<Map<String, Object>> LALM0128P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0128PMapper.LALM0128P_selList(map);
		return list;
		
	}


}
