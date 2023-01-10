package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0318Service;

@Service("LALM0318Service")
public class LALM0318ServiceImpl implements LALM0318Service{

	@Autowired
	LALM0318Mapper lalm0318Mapper;	

	@Override
	public List<Map<String, Object>> LALM0318_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0318Mapper.LALM0318_selList(map);
		return list;
		
	}
}
