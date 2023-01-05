package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0221PService;

@Service("LALM0221PService")
public class LALM0221PServiceImpl implements LALM0221PService{

	@Autowired
	LALM0221PMapper lalm0221PMapper;	

	@Override
	public List<Map<String, Object>> LALM0221P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0221PMapper.LALM0221P_selList(map);
		return list;
		
	}


}
