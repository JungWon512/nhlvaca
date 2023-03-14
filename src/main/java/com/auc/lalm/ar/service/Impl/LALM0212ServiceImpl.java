package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0212Service;

@Service("LALM0212Service")
public class LALM0212ServiceImpl implements LALM0212Service{

	@Autowired
	LALM0212Mapper lalm0212Mapper;	

	@Override
	public List<Map<String, Object>> LALM0212_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0212Mapper.LALM0212_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0212_selQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0212Mapper.LALM0212_selQcn(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0212_selAucQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		
		if(map.get("auc_date") != null && map.get("auc_dt") == null) {
			map.put("auc_dt", map.get("auc_date"));
		}
		
		list = lalm0212Mapper.LALM0212_selAucQcn(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0212_selmhSogCow(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0212Mapper.LALM0212_selmhSogCow(map);
		return list;
		
	}
	
	@Override
	public Map<String, Object> LALM0212_updDdl(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;

		updateNum = lalm0212Mapper.LALM0212_updDdl(map);		
		reMap.put("updateNum", updateNum);		

		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0212_updCan(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;

		updateNum = lalm0212Mapper.LALM0212_updCan(map);		
		reMap.put("updateNum", updateNum);		

		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0212_insPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insNum = 0;
		int insLogNum = 0;
		int updateNum = 0;
		
		insNum = lalm0212Mapper.LALM0212_insPgm(map);		
		reMap.put("updateNum", insNum);
		
		insLogNum = lalm0212Mapper.LALM0212_insLogPgm(map);
		reMap.put("insLogNum", insLogNum);
		
		updateNum = lalm0212Mapper.LALM0212_updInsPgm(map);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0212_updPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insNum = 0;
		int insLogNum = 0;
		int updateNum = 0;
		
		insNum = lalm0212Mapper.LALM0212_updPgm(map);		
		reMap.put("updateNum", insNum);
		
		insLogNum = lalm0212Mapper.LALM0212_updLogPgm(map);
		reMap.put("insLogNum", insLogNum);
		
		updateNum = lalm0212Mapper.LALM0212_updInsPgm(map);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}
	
	@Override
	public Map<String, Object> LALM0212_delPgm(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int delNum = 0;
		int delLogNum = 0;		
		
		delNum = lalm0212Mapper.LALM0212_delPgm(map);		
		reMap.put("updateNum", delNum);
		
		delLogNum = lalm0212Mapper.LALM0212_delLogPgm(map);
		reMap.put("insLogNum", delLogNum);
		
		return reMap;
	}
	
	@Override
	public List<Map<String, Object>> LALM0212_selMaxQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0212Mapper.LALM0212_selMaxQcn(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0212_selDisabledAucDsc(Map<String, Object> map) throws Exception {
		return lalm0212Mapper.LALM0212_selDisabledAucDsc(map);
	}
	
	@Override
	public Map<String, Object> LALM0212_updCommit(Map<String, Object> map) throws Exception{
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;

		updateNum = lalm0212Mapper.LALM0212_updCommit(map);		
		lalm0212Mapper.LALM0212_updLogPgmSel(map);
		reMap.put("updateNum", updateNum);		

		return reMap;		
	}
	
	@Override
	public Map<String, Object> LALM0212_selAucDsc(Map<String, Object> map) throws Exception{
		return lalm0212Mapper.LALM0212_selAucDsc(map);
		
	}
	
}
