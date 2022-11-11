package com.auc.lalm.ar.service.Impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0226Service;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;
import com.auc.main.service.Impl.CommonMapper;

@Service
@SuppressWarnings({"unused", "unchecked"})
public class LALM0226ServiceImpl implements LALM0226Service {
	
	@Autowired
	private LALM0226Mapper lalm0226Mapper;
	
	@Autowired
	private LogService logService;
	
	@Autowired
	private CommonService commonService;

	/**
	 * 접수내역 조회
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> LALM0226_selList(Map<String, Object> map) {
		return lalm0226Mapper.LALM0226_selList(map);
	}
	
	/**
	 * 접수내역 상세
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> LALM0226_selInfo(Map<String, Object> map) {
		return lalm0226Mapper.LALM0226_selInfo(map);
	}
	
	/**
	 * 접수내역 저장
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> LALM0226_insPgm(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap	= new HashMap<String, Object>();
		final Map<String, Object> frmMap	= (Map<String, Object>)map.get("frm_mhsogcow");
		
		int insertNum = 0;	
		int updateNum = 0;
		int aucObjDscCnt = 0;
		
		// 같은 경매날짜에 동일 귀표번호가 있는지 확인
		final Map<String, Object> indvChk = lalm0226Mapper.LALM0226_selIndvChk(frmMap);
		if (indvChk != null) {
			reMap.put("message", "이미 등록된 개체가 있습니다. <br/>[접수일:" + indvChk.get("AUC_RECV_DT") + ", 접수번호:" + indvChk.get("AUC_RECV_NO") + ", 경매일:" + indvChk.get("AUC_DT") + "] ");
			return reMap;
		}
		
		// 접수내역 저장
		insertNum = insertNum + lalm0226Mapper.LALM0226_insCowRecv(frmMap);

		// 개체정보 저장 or 수정 
		commonService.common_updIndvInfo(frmMap);
		
		// 출하주 정보 추가 또는 수정 
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	/**
	 * 접수내역 수정
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> LALM0226_updPgm(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap	= new HashMap<String, Object>();
		final Map<String, Object> frmMap	= (Map<String, Object>)map.get("frm_mhsogcow");
		
		int insertNum = 0;	
		int updateNum = 0;
		int aucObjDscCnt = 0;
		
		// 같은 경매날짜에 동일 귀표번호가 있는지 확인
		final Map<String, Object> indvChk = lalm0226Mapper.LALM0226_selIndvChk(frmMap);
		if (indvChk != null && frmMap.get("auc_dt").equals(indvChk.get("AUC_DT"))) {
			reMap.put("message", "이미 등록된 개체가 있습니다. <br/>[접수일:" + indvChk.get("AUC_RECV_DT") + ", 접수번호:" + indvChk.get("AUC_RECV_NO") + ", 경매일:" + indvChk.get("AUC_DT") + "] ");
			return reMap;
		}
		
		// 접수내역 저장
		updateNum = updateNum + lalm0226Mapper.LALM0226_updCowRecv(frmMap);

		// 개체정보 저장 or 수정 
		commonService.common_updIndvInfo(frmMap);
		
		// 출하주 정보 추가 또는 수정 
		reMap.put("updateNum", updateNum);
		return reMap;
	}
}
