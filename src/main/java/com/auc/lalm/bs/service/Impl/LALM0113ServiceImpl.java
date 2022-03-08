package com.auc.lalm.bs.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.bs.service.LALM0113Service;

@Service("LALM0113Service")
public class LALM0113ServiceImpl implements LALM0113Service{
	
	@Autowired
	LALM0113Mapper lalm0113Mapper;

	@Override
	public List<Map<String, Object>> LALM0113_selListGrd_MmMwmn(Map<String, Object> map) throws Exception {
		
		int updateCusRlno = lalm0113Mapper.LALM0113_updCusRlno(map);
		
		List<Map<String, Object>> list = null;
		list = lalm0113Mapper.LALM0113_selListGrd_MmMwmn(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM0113_selListFrm_MmMwmn(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0113Mapper.LALM0113_selListFrm_MmMwmn(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0113_insTrmn(Map<String, Object> map) throws Exception {
		int v_trmn_amnno = lalm0113Mapper.LALM0113_vTrmnAmnno(map);
		Map<String, Object> reMap = new HashMap<String, Object>();		
		map.put("v_trmn_amnno", v_trmn_amnno);
		int insertNum = 0;
		insertNum = lalm0113Mapper.LALM0113_insTrmn(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0113_updTrmn(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();	
		int insertNum = 0;
		insertNum = lalm0113Mapper.LALM0113_TrmnInsMiMwmn(map);
		reMap.put("insertNum", insertNum);
		int updateNum = 0;
		updateNum = lalm0113Mapper.LALM0113_updTrmn(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0113_delTrmn(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;
		insertNum = lalm0113Mapper.LALM0113_TrmnInsMiMwmn(map);
		reMap.put("insertNum", insertNum);
		int deleteNum = 0;
		deleteNum = lalm0113Mapper.LALM0113_delTrmn(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0113_selDetail(Map<String, Object> map) throws Exception {
		Map<String, Object> selMap = null;
		selMap = lalm0113Mapper.LALM0113_selDetail(map);
		return selMap;
	}

}
