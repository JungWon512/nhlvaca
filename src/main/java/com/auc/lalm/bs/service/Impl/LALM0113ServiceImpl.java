package com.auc.lalm.bs.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.auc.lalm.bs.service.LALM0113Service;
import com.auc.main.service.CommonService;

@Service("LALM0113Service")
public class LALM0113ServiceImpl implements LALM0113Service{
	
	@Autowired
	private LALM0113Mapper lalm0113Mapper;
	
	@Autowired
	private CommonService commonService;

	@Override
	public List<Map<String, Object>> LALM0113_selListGrd_MmMwmn(Map<String, Object> map) throws Exception {
		// cus_rlno을 frlno로 왜 업데이트????
		lalm0113Mapper.LALM0113_updCusRlno(map);
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
		final Map<String, Object> reMap = new HashMap<String, Object>();

		// 수기 등록한 농가 중 동일한 이름, 생년월일, 휴대전화번호로 등록된 정보가 있는지 확인
		final Map<String, Object> selMap = lalm0113Mapper.LALM0113_selMwmnInfo(map);
		if (!ObjectUtils.isEmpty(selMap) && !"".equals(selMap.get("TRMN_AMNNO"))) {
			reMap.put("message", "동일한 이름, 생년월일, 휴대전화번호로 등록된 정보가 있습니다.");
			return reMap;
		}

		// 통합회원정보 저장
		if ("".equals(map.get("mb_intg_no"))) {
			map.put("mb_intg_gb", "01");
			commonService.Common_insMbintgInfo(map);
		}

		// 현재 조합에 해당 통합회원번호로 등록된 중도매인 데이터 수가 0이 아닌 경우
		// 이전 단계에서 휴면 정보를 복구하면서 정보가 등록되었으므로 신규 저장을 하지 않는다.
		if (!"0".equals(map.getOrDefault("cur_dorm_cnt", "0"))) {
			reMap.put("updateNum", map.get("updateNum"));
			return reMap;
		}
		
		// 중도매인번호 채번
		int v_trmn_amnno = lalm0113Mapper.LALM0113_vTrmnAmnno(map);
		map.put("v_trmn_amnno", v_trmn_amnno);
		
		int insertNum = lalm0113Mapper.LALM0113_insTrmn(map);
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0113_updTrmn(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		
		int insertNum = lalm0113Mapper.LALM0113_TrmnInsMiMwmn(map);
		reMap.put("insertNum", insertNum);

		if ("".equals(map.get("mb_intg_no"))) {
			map.put("mb_intg_gb", "01");
			commonService.Common_insMbintgInfo(map);
		}

		int updateNum = lalm0113Mapper.LALM0113_updTrmn(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0113_delTrmn(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = lalm0113Mapper.LALM0113_TrmnInsMiMwmn(map);
		reMap.put("insertNum", insertNum);
		int deleteNum = lalm0113Mapper.LALM0113_delTrmn(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0113_selDetail(Map<String, Object> map) throws Exception {
		Map<String, Object> selMap = null;
		selMap = lalm0113Mapper.LALM0113_selDetail(map);
		return selMap;
	}
	
	/**
	 * 중도매인 저장, 수정시 회원통합
	 * @param map
	 * @return
	 */
	public Map<String, Object>LALM0113_updMbIntgNo(Map<String, Object> map) {
		// 모든 조합에서 이름(SRA_MWMNNM), 생년월일(CUS_RLNO), 휴대전화번호(CUS_MPNO)로 통합된 번호가 있는지 체크
		final Map<String, Object> selMap = lalm0113Mapper.LALM0113_selMbIntgInfo(map);

		// 통합된 정보가 있는 경우 통합회원코드만 map에 담아 return
		// TODO ::같은 통합회원번호의 다른 조합 중도매인 정보 + 통합회원 정보를 업데이트 해야할 지?
		if (!ObjectUtils.isEmpty(selMap) &&  !"".equals(selMap.get("MB_INTG_NO"))) {
			map.put("mb_intg_no", selMap.get("MB_INTG_NO"));
			return map;
		}

		// 통합된 정보가 없는 경우 신규 저장
		lalm0113Mapper.LALM0113_insMbIntgInfo(map);

		return map;
	}
	
	/**
	 * 통합회원번호 삭제
	 * @param map
	 * @return
	 */
	public Map<String, Object>LALM0113_delMbIntgNo(Map<String, Object> map) {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = lalm0113Mapper.LALM0113_delMbIntgNo(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

}
