package com.auc.lalm.ls.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ls.service.LALM1007Service;


@Service("LALM1007Service")
public class LALM1007ServiceImpl implements LALM1007Service{

	@Autowired
	LALM1007Mapper lalm1007Mapper;

	@Override
	public List<Map<String, Object>> LALM1007_selList_MhAucQcn(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		list = lalm1007Mapper.LALM1007_selList_MhAucQcn(map);
	
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1007_selListTbl_Mmmwmn(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1007Mapper.LALM1007_selListTbl_Mmmwmn(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1007_selListGrd_MhSogCow(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1007Mapper.LALM1007_selListGrd_MhSogCow(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1007_selListGrd_MhSogCowF(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "f");
		
		list = lalm1007Mapper.LALM1007_selListGrd_MhSogCowFm(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1007_selListGrd_MhSogCowM(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "m");
		
		list = lalm1007Mapper.LALM1007_selListGrd_MhSogCowFm(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM1007_selListGrd_MdMwmnAdj(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1007Mapper.LALM1007_selListGrd_MdMwmnAdj(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdj(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm1007Mapper.LALM1007_selListFrm_MdMwmnAdj(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdj_f(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "f");
		
		list = lalm1007Mapper.LALM1007_selListFrm_MdMwmnAdjFm(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM1007_selListFrm_MdMwmnAdj_m(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		
		map.put("fm_gbn", "m");
		
		list = lalm1007Mapper.LALM1007_selListFrm_MdMwmnAdjFm(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM1007_selAucEntr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = null;
		reMap = lalm1007Mapper.LALM1007_selAucEntr(map);
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM1007_updEntrGive(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = lalm1007Mapper.LALM1007_updEntrGive(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM1007_updEntrTake(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = lalm1007Mapper.LALM1007_updEntrTake(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1007_insRv(Map<String, Object> map) throws Exception {
		int rv_sqno = lalm1007Mapper.LALM1007_selRvSqno(map);
		Map<String, Object> reMap = new HashMap<String, Object>();		
		map.put("rv_sqno", rv_sqno);
		int insertNum = 0;
		insertNum = lalm1007Mapper.LALM1007_insRv(map);
		reMap.put("insertNum", insertNum);
		int updateNum = 0;
		updateNum = lalm1007Mapper.LALM1007_updEntr(map);	
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1007_updRv(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		insertNum = lalm1007Mapper.LALM1007_updRv(map);
		reMap.put("insertNum", insertNum);
		int updateNum = 0;
		updateNum = lalm1007Mapper.LALM1007_updEntr(map);	
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1007_delRv(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		deleteNum = lalm1007Mapper.LALM1007_delRv(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1007_selRmkcntn(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = null;
		reMap = lalm1007Mapper.LALM1007_chkRmkcntn(map);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1007_insAdj(Map<String, Object> map) throws Exception {
		
		int v_rv_sqno = lalm1007Mapper.LALM1007_v_rv_sqno(map);
		map.put("rv_sqno", v_rv_sqno);
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		insertNum = lalm1007Mapper.LALM1007_insAdj(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}
	@Override
	public Map<String, Object> LALM1007_updAucEntrDdl(Map<String, Object> map) throws Exception{
				
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = lalm1007Mapper.LALM1007_updAucEntrDdl(map);
		reMap.put("updateNum", updateNum);
		return reMap;
		
	}
	
}
