package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0125PService;

@Service("LALM0125PService")
public class LALM0125PServiceImpl implements LALM0125PService{

	@Autowired
	LALM0125PMapper lalm0125PMapper;	

	@Override
	public List<Map<String, Object>> LALM0125P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0125PMapper.LALM0125P_selList(map);
		return list;
		
	}


}
