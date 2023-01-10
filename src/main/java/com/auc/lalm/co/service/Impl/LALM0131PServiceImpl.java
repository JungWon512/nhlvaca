package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0131PService;

@Service("LALM0131PService")
public class LALM0131PServiceImpl implements LALM0131PService{

	@Autowired
	LALM0131PMapper lalm0131PMapper;	

	@Override
	public List<Map<String, Object>> LALM0131P_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0131PMapper.LALM0131P_selList(map);
		return list;
		
	}


}
