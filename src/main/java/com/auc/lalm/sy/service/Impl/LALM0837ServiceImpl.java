package com.auc.lalm.sy.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0837Service;

@Service("LALM0837Service")
public class LALM0837ServiceImpl implements LALM0837Service{
	
	@Autowired
	LALM0837Mapper lalm0837Mapper;

	@Override
	public List<Map<String, Object>> LALM0837_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0837Mapper.LALM0837_selList(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM0837_selUsrList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0837Mapper.LALM0837_selUsrList(map);
		return list;
	}
}
