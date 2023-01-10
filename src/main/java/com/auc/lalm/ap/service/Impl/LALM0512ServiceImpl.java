package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ap.service.LALM0512Service;

@Service("LALM0512Service")
public class LALM0512ServiceImpl implements LALM0512Service{

	@Autowired
	LALM0512Mapper lalm0512Mapper;	

	@Override
	public List<Map<String, Object>> LALM0512_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0512Mapper.LALM0512_selList(map);
		return list;
	 
	}

}
