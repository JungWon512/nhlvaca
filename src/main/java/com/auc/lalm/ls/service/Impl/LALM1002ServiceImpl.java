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
	private LALM1002Mapper lalm1002Mapper;

	@Override
	public List<Map<String, Object>> LALM1002_selList(Map<String, Object> map) throws Exception {
		return lalm1002Mapper.LALM1002_selList(map);
	}

	@Override
	public Map<String, Object> LALM1002_selDetail(Map<String, Object> map) throws Exception {
		return lalm1002Mapper.LALM1002_selDetail(map);
	}

	@Override
	public Map<String, Object> LALM1002_insFee(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		final int insertNum = lalm1002Mapper.LALM1002_insFee(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1002_updFee(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		updateNum = lalm1002Mapper.LALM1002_updFee(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1002_delFee(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		// DEL_YN 컬럼 '0'에서 '1'로 update된 것이므로 반환객체에 updateNum 넘겨줌.
		int updateNum = 0;
		updateNum = lalm1002Mapper.LALM1002_delFee(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}
}
