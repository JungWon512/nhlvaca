package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.bs.service.LALM0115Service;

@Service("LALM0115Service")
public class LALM0115ServiceImpl implements LALM0115Service{

	@Autowired
	LALM0115Mapper lalm0115Mapper;	

	@Override
	public List<Map<String, Object>> LALM0115_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0115Mapper.LALM0115_selList(map);
		return list;
	 
	}

}
