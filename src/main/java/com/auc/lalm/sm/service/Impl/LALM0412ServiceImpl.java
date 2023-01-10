package com.auc.lalm.sm.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sm.service.LALM0412Service;


@Service("LALM0412Service")
public class LALM0412ServiceImpl implements LALM0412Service{

	@Autowired
	LALM0412Mapper lalm0412Mapper;

	@Override
	public List<Map<String, Object>> Lalm0412_selList_MhAucQcn(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		list = lalm0412Mapper.Lalm0412_selList_MhAucQcn(map);
	
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0412_selListTbl_Mmmwmn(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0412Mapper.LALM0412_selListTbl_Mmmwmn(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0412_selListGrd_MhSogCow(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0412Mapper.LALM0412_selListGrd_MhSogCow(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0412_selListGrd_MhSogCowF(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "f");
		
		list = lalm0412Mapper.LALM0412_selListGrd_MhSogCowFm(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0412_selListGrd_MhSogCowM(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "m");
		
		list = lalm0412Mapper.LALM0412_selListGrd_MhSogCowFm(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM0412_selListGrd_MdMwmnAdj(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0412Mapper.LALM0412_selListGrd_MdMwmnAdj(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM0412_selListFrm_MdMwmnAdj(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0412Mapper.LALM0412_selListFrm_MdMwmnAdj(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0412_selListFrm_MdMwmnAdj_f(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "f");
		
		list = lalm0412Mapper.LALM0412_selListFrm_MdMwmnAdjFm(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0412_selListFrm_MdMwmnAdj_m(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "m");
		
		list = lalm0412Mapper.LALM0412_selListFrm_MdMwmnAdjFm(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0412_selAucEntr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = null;
		reMap = lalm0412Mapper.LALM0412_selAucEntr(map);
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0412_updEntrGive(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = lalm0412Mapper.LALM0412_updEntrGive(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0412_updEntrTake(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = lalm0412Mapper.LALM0412_updEntrTake(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0412_insRv(Map<String, Object> map) throws Exception {
		int rv_sqno = lalm0412Mapper.LALM0412_selRvSqno(map);
		Map<String, Object> reMap = new HashMap<String, Object>();		
		map.put("rv_sqno", rv_sqno);
		int insertNum = 0;
		insertNum = lalm0412Mapper.LALM0412_insRv(map);
		reMap.put("insertNum", insertNum);
		int updateNum = 0;
		updateNum = lalm0412Mapper.LALM0412_updEntr(map);	
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0412_updRv(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		insertNum = lalm0412Mapper.LALM0412_updRv(map);
		reMap.put("insertNum", insertNum);
		int updateNum = 0;
		updateNum = lalm0412Mapper.LALM0412_updEntr(map);	
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0412_delRv(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		deleteNum = lalm0412Mapper.LALM0412_delRv(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0412_selRmkcntn(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = null;
		reMap = lalm0412Mapper.LALM0412_chkRmkcntn(map);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0412_insAdj(Map<String, Object> map) throws Exception {
		
		int v_rv_sqno = lalm0412Mapper.LALM0412_v_rv_sqno(map);
		map.put("rv_sqno", v_rv_sqno);
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		insertNum = lalm0412Mapper.LALM0412_insAdj(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}
	
}
