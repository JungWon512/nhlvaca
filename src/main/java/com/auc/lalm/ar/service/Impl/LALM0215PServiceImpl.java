package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0215PService;

@Service("LALM0215PService")
public class LALM0215PServiceImpl implements LALM0215PService{

	@Autowired
	LALM0215PMapper lalm0215PMapper;	

	@Override
	public List<Map<String, Object>> LALM0215P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0215PMapper.LALM0215P_selList(map);
		return list;
		
	}


}
