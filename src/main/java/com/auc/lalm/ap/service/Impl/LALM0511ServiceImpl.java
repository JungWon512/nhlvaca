package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ap.service.LALM0511Service;

@Service("LALM0511Service")
public class LALM0511ServiceImpl implements LALM0511Service{

	@Autowired
	LALM0511Mapper lalm0511Mapper;	

	@Override
	public List<Map<String, Object>> LALM0511_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0511Mapper.LALM0511_selList(map);
		return list;
	 
	}

}
