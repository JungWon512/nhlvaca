package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ap.service.LALM0515Service;

@Service("LALM0515Service")
public class LALM0515ServiceImpl implements LALM0515Service{

	@Autowired
	LALM0515Mapper lalm0515Mapper;	

	@Override
	public List<Map<String, Object>> LALM0515_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0515Mapper.LALM0515_selList(map);
		return list;
	 
	}

}
