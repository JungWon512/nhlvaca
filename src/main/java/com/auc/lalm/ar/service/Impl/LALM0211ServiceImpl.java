package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0211Service;

@Service("LALM0211Service")
public class LALM0211ServiceImpl implements LALM0211Service{

	@Autowired
	LALM0211Mapper lalm0211Mapper;	

	@Override
	public List<Map<String, Object>> LALM0211_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0211Mapper.LALM0211_selList(map);
		return list;
		
	}


}
