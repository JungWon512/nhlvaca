package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.Impl.LALM0214Mapper;
import com.auc.lalm.co.service.LALM0919Service;

@Service("LALM0919Service")
@SuppressWarnings("unchecked")
public class LALM0919ServiceImpl implements LALM0919Service{

	@Autowired
	LALM0919Mapper lalm0919Mapper;
	
	@Override
	public List<Map<String, Object>> LALM0919_selMhSogCowStaticsList(Map<String, Object> map) throws Exception {
		return lalm0919Mapper.LALM0919_selMhSogCowStaticsList(map);
	}

	@Override
	public List<Map<String, Object>> LALM0919_selMhSogCowRowDataList(Map<String, Object> map) throws Exception {
		return lalm0919Mapper.LALM0919_selMhSogCowRowDataList(map);
	}
	
	@Override
	public List<Map<String, Object>> LALM0919_selCowList(Map<String, Object> map) throws Exception {
		return lalm0919Mapper.LALM0919_selMhSogCowList(map);
	}

	@Deprecated
	@Override
	public List<Map<String, Object>> LALM0919_selMhSogCowCntList(Map<String, Object> map) throws Exception {
		return lalm0919Mapper.LALM0919_selMhSogCowCntList(map);
	}

	@Deprecated
	@Override
	public List<Map<String, Object>> LALM0919_selMhSogCowPriceList(Map<String, Object> map) throws Exception {
		return lalm0919Mapper.LALM0919_selMhSogCowPriceList(map);
	}
}
