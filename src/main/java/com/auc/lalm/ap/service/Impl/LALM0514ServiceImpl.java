package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ap.service.LALM0514Service;

@Service("LALM0514Service")
public class LALM0514ServiceImpl implements LALM0514Service{

	@Autowired
	LALM0514Mapper lalm0514Mapper;	

	@Override
	public List<Map<String, Object>> LALM0514_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0514Mapper.LALM0514_selList(map);
		return list;
	 
	}

}
