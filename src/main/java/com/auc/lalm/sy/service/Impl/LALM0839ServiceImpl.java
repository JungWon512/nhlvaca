package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0839Service;

@Service("LALM0839Service")
public class LALM0839ServiceImpl implements LALM0839Service{
	
	@Autowired
	LALM0839Mapper lalm0839Mapper;

	@Override
	public List<Map<String, Object>> LALM0839_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0839Mapper.LALM0839_selList(map);
		return list;
	}
}
