package com.auc.lalm.bs.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.bs.service.LALM0114Service;
import com.auc.main.service.CommonService;
import com.auc.mca.McaUtil;


@Service("LALM0114Service")
public class LALM0114ServiceImpl implements LALM0114Service{
	private static Logger log = LoggerFactory.getLogger(LALM0114ServiceImpl.class);
	
	@Autowired
	LALM0114Mapper lalm0114Mapper;
	@Autowired
	CommonService commonService;
	@Autowired
	McaUtil mcaUtil;

	@Override
	public List<Map<String, Object>> LALM0114_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;
		list = lalm0114Mapper.LALM0114_selList(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0114_insIndv(Map<String, Object> map) throws Exception {
		
		Map<String, Object> mcaMap  = mcaUtil.tradeMcaMsg("4700", map);
		Map<String, Object> dataMap = (Map<String, Object>) mcaMap.get("jsonData");		
		//double inq_cn_d = (double) dataMap.get("INQ_CN");
		double inq_cn_d = Double.valueOf(dataMap.getOrDefault("INQ_CN","0").toString());
		int inq_cn = (int) Math.round(inq_cn_d);
		
		//한우종합 개체정보 확인
		if(inq_cn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"한우종합에 이미 등록된 개체입니다. 개체이력조회를 하시기 바랍니다.");
		}
		
		//개체기본 체크
		int chk_Indv = 0;
		chk_Indv = lalm0114Mapper.LALM0114_chk_Indv(map);
		if(chk_Indv > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"등록된 개체체번호입니다.");
		}
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		insertNum = lalm0114Mapper.LALM0114_insIndv(map);	
		reMap.put("updateNum", insertNum);
		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0114_updIndv(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = lalm0114Mapper.LALM0114_updIndv(map);	
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0114_delIndv(Map<String, Object> map) throws Exception {
		
		int chk_cow = lalm0114Mapper.LALM0114_chk_delIndv(map);
		
		if(chk_cow > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"출장우에 등록된 개체는 삭제하실수없습니다.");
		}
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		deleteNum = lalm0114Mapper.LALM0114_delIndv(map);	
		reMap.put("updateNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0114_selIndvDetail(Map<String, Object> map) throws Exception {
		Map<String, Object> selMap = null;
		selMap = lalm0114Mapper.LALM0114_selIndvDetail(map);
		return selMap;
	}



}
