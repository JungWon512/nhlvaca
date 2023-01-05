package com.auc.lalm.bs.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.bs.service.LALM0116Service;

@Service("LALM0116Service")
public class LALM0116ServiceImpl implements LALM0116Service{

	@Autowired
	LALM0116Mapper lalm0116Mapper;	

	@Override
	public List<Map<String, Object>> LALM0116_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0116Mapper.LALM0116_selList(map);
		return list;
	 
	}

}
