package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0225Service;

@Service
@SuppressWarnings("unchecked")
public class LALM0225ServiceImpl implements LALM0225Service{
	
	private static Logger log = LoggerFactory.getLogger(LALM0225Service.class);
	
	@Autowired
	private LALM0225Mapper lalm0225Mapper;

	/**
	 * 출장우 접수 리스트
	 */
	@Override
	public List<Map<String, Object>> LALM0225_selList(Map<String, Object> map) {
		return lalm0225Mapper.LALM0225_selList(map);
	}
	
	/**
	 * 출장우 접수 -> 출장우 등록 전환
	 * @param map
	 * @return
	 */
	@Override
	public Map<String, Object> LALM0225_insSogCow(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap	= new HashMap<String, Object>();
		final Map<String, Object> frmMap	= (Map<String, Object>)map.get("frm_search");
		
		int insertNum = 0;
		
		Iterator<String> keys = frmMap.keySet().iterator();
		while(keys.hasNext()) {
			String key = keys.next();
			log.debug("{} : {}", key, map.getOrDefault(key, "").toString().trim());
		}
		
		// 해당일자에 생성된 경매일자가 있는지 체크
		final Map<String, Object> qcnChk = lalm0225Mapper.LALM0225_selAucQcn(frmMap);
		if (qcnChk == null) {
			reMap.put("message", "경매 차수를 등록하세요");
			return reMap;
		}
		
		// 기존 출장우 삭제
		lalm0225Mapper.LALM0225_delSogCow(frmMap);
		
		// 출장우 등록 전환
		insertNum = insertNum + lalm0225Mapper.LALM0225_insSogCow(frmMap);
		
		reMap.put("insertNum", insertNum);
		return reMap;
	}

}

