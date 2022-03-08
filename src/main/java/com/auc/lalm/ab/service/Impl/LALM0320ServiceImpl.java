package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0320Service;

@Service("LALM0320Service")
public class LALM0320ServiceImpl implements LALM0320Service{

	@Autowired
	LALM0320Mapper lalm0320Mapper;	

	@Override
	public List<Map<String, Object>> LALM0320_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0320Mapper.LALM0320_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0320_selAucIngList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0320Mapper.LALM0320_selAucIngList(map);
		return list;
		
	}	
	
}
