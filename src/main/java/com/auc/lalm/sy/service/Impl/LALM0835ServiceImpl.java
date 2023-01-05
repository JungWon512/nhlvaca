package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0835Service;

@Service("LALM0835Service")
public class LALM0835ServiceImpl implements LALM0835Service{
	
	@Autowired
	LALM0835Mapper lalm0835Mapper;

	@Override
	public List<Map<String, Object>> LALM0835_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0835Mapper.LALM0835_selList(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0835_selList2(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0835Mapper.LALM0835_selList2(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0835_selList3(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0835Mapper.LALM0835_selList3(map);
		return list;
	}
	


}
