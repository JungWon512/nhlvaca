package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0134PService;

@Service("LALM0134PService")
public class LALM0134PServiceImpl implements LALM0134PService{

	@Autowired
	LALM0134PMapper lalm0134PMapper;	

	@Override
	public List<Map<String, Object>> LALM0134P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0134PMapper.LALM0134P_selList(map);
		return list;
		
	}


}
