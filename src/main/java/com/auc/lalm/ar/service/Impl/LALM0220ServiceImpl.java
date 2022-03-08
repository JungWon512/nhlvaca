package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0220Service;

@Service("LALM0220Service")
public class LALM0220ServiceImpl implements LALM0220Service{

	@Autowired
	LALM0220Mapper lalm0220Mapper;	

	@Override
	public List<Map<String, Object>> LALM0220_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0220Mapper.LALM0220_selList(map);
		return list;
	 
	}

}
