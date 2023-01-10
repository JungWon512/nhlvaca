package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ap.service.LALM0516Service;

@Service("LALM0516Service")
public class LALM0516ServiceImpl implements LALM0516Service{

	@Autowired
	LALM0516Mapper lalm0516Mapper;	

	@Override
	public List<Map<String, Object>> LALM0516_selFhsList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0516Mapper.LALM0516_selFhsList(map);
		return list;
	 
	}
	
	@Override
	public List<Map<String, Object>> LALM0516_selMwmnList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0516Mapper.LALM0516_selMwmnList(map);
		return list;
	 
	}	

}
