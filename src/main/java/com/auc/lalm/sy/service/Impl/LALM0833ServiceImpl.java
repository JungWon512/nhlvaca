package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0833Service;
import com.auc.main.service.Impl.LogMapper;

@Service("LALM0833Service")
public class LALM0833ServiceImpl implements LALM0833Service{

	@Autowired
	LALM0833Mapper lalm0833Mapper;	
	@Autowired
	LogMapper logMapper;	
	

	@Override
	public List<Map<String, Object>> LALM0833_selGrpCode(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0833Mapper.LALM0833_selGrpCode(map);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> LALM0833_selList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;		
		list = lalm0833Mapper.LALM0833_selList(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0833_insUsr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		//프로그램 DB 저장
		insertNum = lalm0833Mapper.LALM0833_insUsr(map);
		map.put("wk_grp_c", map.get("de_wk_grp_c"));
		map.put("grp_usrid", map.get("de_usrid"));
		map.put("chg_rmk_cntn", "권한["+map.get("de_wk_grp_c")+"] 사용자 추가");
		logMapper.insGrpUsrLog(map);
		reMap.put("insertNum", insertNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0833_updUsr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		//프로그램 DB 저장
		updateNum = lalm0833Mapper.LALM0833_updUsr(map);
		map.put("wk_grp_c", map.get("de_wk_grp_c"));
		map.put("grp_usrid", map.get("de_usrid"));
		map.put("chg_rmk_cntn", "권한["+map.get("de_wk_grp_c")+"] 사용자 수정");
		logMapper.insGrpUsrLog(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0833_delUsr(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		map.put("wk_grp_c", map.get("de_wk_grp_c"));
		map.put("grp_usrid", map.get("de_usrid"));
		map.put("chg_rmk_cntn", "권한["+map.get("de_wk_grp_c")+"] 사용자 삭제");
		logMapper.insGrpUsrLog(map);
		//프로그램 DB 저장
		deleteNum = lalm0833Mapper.LALM0833_delUsr(map);	
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM0833_selGrpList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0833Mapper.LALM0833_selGrpList(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0833_delGrpList(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;	
		map.put("wk_grp_c", map.get("wk_grp_c"));
		map.put("chg_rmk_cntn", "권한["+map.get("wk_grp_c")+"] 삭제");
		logMapper.insGrpLog(map);
		//프로그램 DB 저장
		deleteNum = lalm0833Mapper.LALM0833_delGrpList(map);			
		reMap.put("deleteNum", deleteNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0833_updGrpList(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		//프로그램 DB 저장
		updateNum = lalm0833Mapper.LALM0833_updGrpList(map);
		map.put("wk_grp_c", map.get("wk_grp_c"));
		map.put("chg_rmk_cntn", "권한["+map.get("wk_grp_c")+"] 추가/수정");
		logMapper.insGrpLog(map);		
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	
	@Override
	public List<Map<String, Object>> LALM0833_selUsrList(Map<String, Object> map) throws Exception{
		List<Map<String, Object>> list = null;		
		list = lalm0833Mapper.LALM0833_selUsrList(map);
		return list;		
	}


}
