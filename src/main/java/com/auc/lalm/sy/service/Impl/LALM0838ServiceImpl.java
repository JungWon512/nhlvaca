package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0838Service;

@Service("LALM0838Service")
public class LALM0838ServiceImpl implements LALM0838Service{
	
	@Autowired
	LALM0838Mapper lalm0838Mapper;

	@Override
	public List<Map<String, Object>> LALM0838_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0838Mapper.LALM0838_selList(map);
		return list;
	}
}
