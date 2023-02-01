package com.auc.lalm.bs.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.bs.service.LALM0111Service;
import com.auc.main.service.CommonService;


@Service("LALM0111Service")
public class LALM0111ServiceImpl implements LALM0111Service{
	
	@Autowired
	private LALM0111Mapper lalm0111Mapper;
	
	@Autowired
	private CommonService commonService;

	@Override
	public List<Map<String, Object>> LALM0111_selList(Map<String, Object> map) throws Exception {
		return lalm0111Mapper.LALM0111_selList(map);
	}

	@Override
	public Map<String, Object> LALM0111_insFarm(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		// 동일한 이름, 생년월일, 휴대전화번호로 등록된 정보가 있는지 확인
		final Map<String, Object> selMap = lalm0111Mapper.LALM0111_selFhsInfo(map);
		if (!ObjectUtils.isEmpty(selMap) && !"".equals(selMap.get("FHS_ID_NO"))) {
			reMap.put("message", "동일한 이름, 생년월일, 휴대전화번호로 등록된 정보가 있습니다.");
			return reMap;
		}
		
		// 통합회원정보 저장
		map.put("mb_intg_gb", "02");
		commonService.Common_insMbintgInfo(map);

		//휴면복구할 데이터가 있는 경우, 농가 INSERT 하지 않아도 됨, 위 메소드 내부에서 처리함
		if (!"0".equals(map.getOrDefault("cur_dorm_cnt", "0"))) {
			reMap.put("updateNum", map.get("updateNum"));
			return reMap;
		}
		int insertNum  = lalm0111Mapper.LALM0111_insFarm(map);
		
		reMap.put("sraFhsIdNo", map.get("sra_fhs_id_no"));
		reMap.put("farmAmnno", map.get("farm_amnno"));
		reMap.put("ftsnm", map.get("ftsnm"));
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0111_updFarm(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		int updateNum = 0;
		// 통합회원정보 저장
		map.put("mb_intg_gb", "02");
		commonService.Common_insMbintgInfo(map);

		updateNum = lalm0111Mapper.LALM0111_updFarm(map);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0111_selFhsAnw(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0111Mapper.LALM0111_selFhsAnw(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override 
	public Map<String, Object> LALM0111_delFhs(Map<String, Object> map) throws Exception {
		final Map<String, Object> reMap = new HashMap<String, Object>();
		
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
