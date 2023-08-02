package com.auc.lalm.ar.service.Impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.ar.service.LALM0225Service;

@Service
@SuppressWarnings("unchecked")
public class LALM0225ServiceImpl implements LALM0225Service{
	
	private static Logger log = LoggerFactory.getLogger(LALM0225Service.class);

	@Autowired
	private LALM0225Mapper lalm0225Mapper;
	@Autowired
	private LALM0226Mapper lalm0226Mapper;

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


	/**
	 * @methodName    : LALM0225P1_updDnaYn
	 * @author        : Jung JungWon
	 * @date          : 2023.07.05
	 * @Comments      : 
	 */
	public List<Map<String, Object>> LALM0225P1_updDnaYn(Map<String, Object> inMap) throws Exception{		
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) inMap.get("list");		
		List<Map<String, Object>> reList = new ArrayList<>();
		StringBuilder sb = new StringBuilder();
		for(Map<String, Object> map : list) {
			Map<String, Object> reMap = new HashMap<>();
			map.put("ss_na_bzplc", inMap.get("ss_na_bzplc"));
			map.put("ss_userid", inMap.get("ss_userid"));
			map.put("re_indv_no", map.get("sra_indv_amnno"));
			
			//귀표번호 없을경우 CHK_VAILD_ERR 1로해서 RETURN
			Map<String, Object> indvChkInfo = lalm0226Mapper.LALM0226_selIndvChk(map);			
			if(indvChkInfo == null) {
				map.put("chk_vaild_err", "1");
			}else {
				lalm0225Mapper.LALM0225P1_updDnaYn(map);
				map.put("chk_vaild_err", "0");			
			}

			Iterator<String> keys = map.keySet().iterator();
			while(keys.hasNext()) {
				String key = keys.next();
				String value = "";
				if(map.get(key) != null) value = map.get(key).toString().trim();
				reMap.put(key.toUpperCase(), value);
			}
			reList.add(reMap);
		}
		
		return reList;
		
	}

}

