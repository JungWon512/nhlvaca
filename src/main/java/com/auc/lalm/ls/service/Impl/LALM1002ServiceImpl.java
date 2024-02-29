package com.auc.lalm.ls.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ls.service.LALM1002Service;

@Service
public class LALM1002ServiceImpl implements LALM1002Service {

	@Autowired
	private LALM1002Mapper lsam0103Mapper;

	@Override
	public List<Map<String, Object>> LALM1002_selList(Map<String, Object> map) throws Exception {
		return lsam0103Mapper.LALM1002_selList(map);
	}

	@Override
	public Map<String, Object> LALM1002_insFee(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		final int insertNum = lsam0103Mapper.LALM1002_insFee(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1002_selDetail(Map<String, Object> map) throws Exception {
		return lsam0103Mapper.LALM1002_selDetail(map);
	}

}
