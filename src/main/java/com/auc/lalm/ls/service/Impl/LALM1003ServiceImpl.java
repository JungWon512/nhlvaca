package com.auc.lalm.ls.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.ls.service.LALM1003Service;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;

@Service
public class LALM1003ServiceImpl implements LALM1003Service {

	@Autowired
	LogService logService;
	@Autowired
	LALM1003Mapper lalm1003Mapper;
	@Autowired
	CommonService commonService;

	@Override
	public List<Map<String, Object>> LALM1003_selList(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1003Mapper.LALM1003_selList(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM1003_selAucQcn(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1003Mapper.LALM1003_selAucQcn(map);
		return list;
	}

	@Override
	public List<Map<String, Object>> LALM1003_selCalfList(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1003Mapper.LALM1003_selCalfList(map);
		return list;
	}

	@Override
	public int LALM1003_selAucTmsCnt(Map<String, Object> map) throws Exception {

		int iCnt = lalm1003Mapper.LALM1003_selAucTmsCnt(map);
		return iCnt;
	}

	@Override
	public Map<String, Object> LALM1003_insFeeReset(Map<String, Object> map) throws Exception {
		int insertNum = 0;
		// 출장내역 조회
		List<Map<String, Object>> grd_MhSogCow = lalm1003Mapper.LALM1003_selList2(map);

		if (grd_MhSogCow.size() < 1) {
			throw new CusException(ErrorCode.CUSTOM_ERROR, "출장내역이 없습니다.<br>상단의 검색조건을 확인해 주세요.");
		}

		insertNum = commonService.Common_insFeeImps(grd_MhSogCow);

		Map<String, Object> reMap = new HashMap<String, Object>();
		reMap.put("insertNum", insertNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1003_selFeeImps(Map<String, Object> map) throws Exception {

		Map<String, Object> reMap = lalm1003Mapper.LALM1003_selFeeImps(map);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1003_delSogCow(Map<String, Object> map) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();
		int insertNum = 0;
		int deleteNum = 0;
		// 프로그램 DB 저장
		insertNum = logService.insSogCowLog(map);
		reMap.put("insertNum", insertNum);
		deleteNum = deleteNum + lalm1003Mapper.LALM1003_delSogCog(map);
		deleteNum = deleteNum + lalm1003Mapper.LALM1003_delFeeImps(map);
		deleteNum = deleteNum + lalm1003Mapper.LALM1003_delCalf(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM1003_delCntnDel(Map<String, Object> map) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();
		int deleteNum = 0;
		deleteNum = deleteNum + lalm1003Mapper.LALM1003_delCntnDel(map);
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	@Override
	public List<Map<String, Object>> LALM1003P1_selList(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1003Mapper.LALM1003P1_selList(map);
		return list;

	}

	@Override
	public List<Map<String, Object>> LALM1003P4_selList(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;
		list = lalm1003Mapper.LALM1003P4_selList(map);
		return list;

	}

	@Override
	public Map<String, Object> LALM1003P2_updCow(List<Map<String, Object>> inList) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpObject = null;

		int updateNum = 0;

		for (int i = 0; i < inList.size(); i++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>) inList.get(i);

			updateNum += lalm1003Mapper.LALM1003P2_updCow(tmpObject);
			reMap.put("updateNum", updateNum);
		}

		return reMap;
	}

	@Override
	public Map<String, Object> LALM1003P4_updCowBun(List<Map<String, Object>> inList) throws Exception {

		Map<String, Object> reMap = new HashMap<String, Object>();
		Map<String, Object> tmpObject = null;

		int updateNum = 0;

		for (int i = 0; i < inList.size(); i++) {
			tmpObject = null;
			tmpObject = (Map<String, Object>) inList.get(i);

			updateNum += lalm1003Mapper.LALM1003P4_updCowBun(tmpObject);
			reMap.put("updateNum", updateNum);
		}

		return reMap;
	}

}
