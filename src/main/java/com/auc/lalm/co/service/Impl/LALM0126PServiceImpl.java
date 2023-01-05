package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0125PService;
import com.auc.lalm.co.service.LALM0126PService;

@Service("LALM0126PService")
public class LALM0126PServiceImpl implements LALM0126PService{

	@Autowired
	LALM0126PMapper lalm0126PMapper;

	@Override
	public List<Map<String, Object>> LALM0126P_selListProv(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0126PMapper.LALM0126P_selListProv(map);
		return list;
	}	

	@Override
	public List<Map<String, Object>> LALM0126P_selListCcw(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0126PMapper.LALM0126P_selListCcw(map);
		return list;
	}	

	@Override
	public List<Map<String, Object>> LALM0126P_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0126PMapper.LALM0126P_selList(map);
		return list;
	}




}
