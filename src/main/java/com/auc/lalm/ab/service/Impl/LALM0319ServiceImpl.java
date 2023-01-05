package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0319Service;

@Service("LALM0319Service")
public class LALM0319ServiceImpl implements LALM0319Service{

	@Autowired
	LALM0319Mapper lalm0319Mapper;	

	@Override
	public List<Map<String, Object>> LALM0319_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0319Mapper.LALM0319_selList(map);
		return list;
		
	}
	@Override
	public List<Map<String, Object>> LALM0319_sel_entr(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0319Mapper.LALM0319_sel_entr(map);
		return list;
		
	}
}
