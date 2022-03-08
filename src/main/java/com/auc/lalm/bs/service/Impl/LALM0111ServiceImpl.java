package com.auc.lalm.bs.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.bs.service.LALM0111Service;


@Service("LALM0111Service")
public class LALM0111ServiceImpl implements LALM0111Service{
	
	@Autowired
	LALM0111Mapper lalm0111Mapper;

	@Override
	public List<Map<String, Object>> LALM0111_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0111Mapper.LALM0111_selList(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0111_insFarm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;
		insertNum = lalm0111Mapper.LALM0111_insFarm(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0111_updFarm(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		updateNum = lalm0111Mapper.LALM0111_updFarm(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0111_selFhsAnw(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0111Mapper.LALM0111_selFhsAnw(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0111_delFhs(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		int chk_cow = lalm0111Mapper.LALM0111_selChkFhsCow(map);		
		if(chk_cow > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"출장우에 등록된 농가는 삭제하실수 없습니다.");
		}
		
		int deleteNum = 0;
		deleteNum = lalm0111Mapper.LALM0111_delFhs(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0111_selDetail(Map<String, Object> map) throws Exception {
		Map<String, Object> selMap = null;
		selMap = lalm0111Mapper.LALM0111_selDetail(map);
		return selMap;
	}

	

}
