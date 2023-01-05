package com.auc.lalm.co.service.Impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0919Service;

@Service("LALM0919Service")
@SuppressWarnings("unchecked")
public class LALM0919ServiceImpl implements LALM0919Service{

	@Autowired
	LALM0919Mapper lalm0919Mapper;	

	@Override
	public List<Map<String, Object>> LALM0919_selMhSogCowCntList(Map<String, Object> map) throws Exception {
		return lalm0919Mapper.LALM0919_selMhSogCowCntList(map);
	}

	@Override
	public List<Map<String, Object>> LALM0919_selMhSogCowPriceList(Map<String, Object> map) throws Exception {
		return lalm0919Mapper.LALM0919_selMhSogCowPriceList(map);
	}

}
