package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0129PService;

@Service("LALM0129PService")
public class LALM0129PServiceImpl implements LALM0129PService{

	@Autowired
	LALM0129PMapper lalm0129PMapper;	

	@Override
	public List<Map<String, Object>> LALM0129P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0129PMapper.LALM0129P_selList(map);
		return list;
		
	}


}
