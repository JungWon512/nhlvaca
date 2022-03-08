package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0127PService;

@Service("LALM0127PService")
public class LALM0127PServiceImpl implements LALM0127PService{

	@Autowired
	LALM0127PMapper lalm0127PMapper;

	@Override
	public List<Map<String, Object>> LALM0127P_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0127PMapper.LALM0127P_selList(map);
		return list;
	}	



}
