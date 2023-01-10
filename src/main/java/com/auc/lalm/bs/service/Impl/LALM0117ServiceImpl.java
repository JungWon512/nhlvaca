package com.auc.lalm.bs.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.batch.service.BatchService;
import com.auc.lalm.bs.service.LALM0117Service;

@Service("LALM0117Service")
public class LALM0117ServiceImpl implements LALM0117Service{

	@Autowired
	LALM0117Mapper lalm0117Mapper;
	
	@Autowired
	BatchService batchService;	

	/**
	 * 휴면대상 목록 조회
	 * 휴면대상 : 휴면되기 전 30일 이내 (휴면예정일자 기준 DORMDUE_DT)
	 */
	@Override
	public List<Map<String, Object>> LALM0117_selDormacPreList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		
		switch(map.get("mbintg_gubun").toString()) {	//검색 구분코드 
		case "01" : 	//중도매인 : 01 인 경우
			list = lalm0117Mapper.LALM0117_selDormacPreUserList(map);
			break;
		case "02":	//출하주(농가) : 02 인 경우
			list = lalm0117Mapper.LALM0117_selDormacPreFhsList(map);
			break;
		}
		
		return list;
	}

	/**
	 * 휴면회원 목록 조회
	 * 휴면처리가 이미 된 중도매인&출하주 => 휴면 백업 테이블에서 가지고 오기
	 */
	@Override
	public List<Map<String, Object>> LALM0117_selDormacUsrList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		
		switch(map.get("mbintg_gubun").toString()) {		//검색 구분코드
		case "01" : 	//중도매인 : 01 인 경우
			list = lalm0117Mapper.LALM0117_selDormacUserList(map);
			break;
		case "02":	//출하주(농가) : 02 인 경우
			list = lalm0117Mapper.LALM0117_selDormacFhsList(map);
			break;
		}
		
		return list;
	}

	/**
	 * [휴면대상 해제] 버튼 클릭 시, 
	 * 휴면예정일자를 오늘부터 1년 후 날짜로 업데이트 하기
	 */
	@Override
	public Map<String, Object> LALM0117_updDormcPreClear(Map<String, Object> map) throws Exception {
		int updateNum = 0;
		int insertNum = 0;
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		//MBINTGHIS로 백업본 INSERT 하기
		insertNum = lalm0117Mapper.LALM0117_insMbintgHistoryData(map);
		reMap.put("insertNum", insertNum);
		
		//update
		updateNum = lalm0117Mapper.LALM0117_updDormcPreClear(map);	
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	/**
	 * 휴면회원 해제
	 * 이력 저장, 마스킹 했던 정보 다시 업데이트, 백업 데이터 삭제 
	 */
	@Override
	public Map<String, Object> LALM0117_updDormcUsrClear(Map<String, Object> map) throws Exception {
		int insertNum = 0;
		int updateNum = 0;
		int deleteNum = 0;
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		insertNum = this.LALM0117_insDormClearBackupData(map);
		reMap.put("insertNum", insertNum);
		
		updateNum = this.LALM0117_updDormClearBackupData(map);
		reMap.put("updateNum", updateNum);
		
		deleteNum = this.LALM0117_delDormClearBackupData(map);
		reMap.put("deleteNum", deleteNum);
		
		return reMap;
	}

	/**
	 * 휴면회원 해제 시, 테이블 이력 저장해야 하는 대상 저장하기
	 * 회원통합, 중도매인 이력 테이블 (농가는 이력테이블 없음)
	 * @param map
	 * @return
	 */
	private int LALM0117_insDormClearBackupData(Map<String, Object> map) {
		int insertNum = 0;
		try {
			//MBINTGHIS로 백업본 INSERT 하기
			insertNum = lalm0117Mapper.LALM0117_insMbintgHistoryData(map);
			
			//중도매인 이력 테이블에 현재 상태 insert 하기
			if("01".equals(map.get("mbintg_gubun").toString())) {
				insertNum = lalm0117Mapper.LALM0117_insMwmnHistoryData(map);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return insertNum;
	}
	
	/**
	 * 휴면회원 해제 시, 정보 업데이트 해야하는 대상 update
	 * 회원통합 테이블, 중도매인 or 출하주 테이블 
	 * @param map
	 * @return
	 */
	private int LALM0117_updDormClearBackupData(Map<String, Object> map) {
		int updateNum = 0;
		//통합회원 백업데이터를 통합회원 테이블로 update
		try {
			updateNum = lalm0117Mapper.LALM0117_updDormcUsrClear(map);
			
			//구분에 따라 백업데이터 update 하기
			switch(map.get("mbintg_gubun").toString()) {	//검색 구분코드 
			case "01" : 	//중도매인 : 01 인 경우
				updateNum = lalm0117Mapper.LALM0117_updDormacMwmnClear(map);
				break;
			case "02":	//출하주(농가) : 02 인 경우
				updateNum = lalm0117Mapper.LALM0117_updDormacFhsClear(map);
				break;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return updateNum;
	}
	
	/**
	 * 휴면회원 해제 시, 백업 데이터 삭제하기
	 * 회원통합 백업 테이블, 중도매인 or 출하주 백업 테이블 
	 * @param map
	 * @return
	 */
	private int LALM0117_delDormClearBackupData(Map<String, Object> map) {
		int deleteNum = 0;
		try {
			deleteNum = lalm0117Mapper.LALM0117_delDormacUsrData(map);
			
			//구분에 따라 백업데이터 삭제하기
			switch(map.get("mbintg_gubun").toString()) {	//검색 구분코드 
			case "01" : 	//중도매인 : 01 인 경우
				deleteNum = lalm0117Mapper.LALM0117_delDormacMwmnData(map);
				break;
			case "02":	//출하주(농가) : 02 인 경우
				deleteNum = lalm0117Mapper.LALM0117_delDormacFhsData(map);
				break;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return deleteNum;
	}

	/**
	 * [선택삭제] 버튼 클릭 시, 휴면하면서 백업한 데이터를 삭제하고 
	 * 통합회원 계정삭제여부를 Y로 업데이트 하기
	 */
	@Override
	public Map<String, Object> LALM0117_delDormcSelectUser(Map<String, Object> map) throws Exception {
		int deleteNum = 0;
		int insertNum = 0;
		int updateNum = 0;
		Map<String, Object> reMap = new HashMap<String, Object>();
		
		//map.put("selUserDelete", "Y");		//TODO : 계정삭제 시, 농가 휴면백업 데이터를 삭제하면 안되는건지 (확인 필요) 
		insertNum = this.LALM0117_insDormClearBackupData(map);
		reMap.put("insertNum", insertNum);
		
		deleteNum = this.LALM0117_delDormClearBackupData(map);
		reMap.put("deleteNum", deleteNum);
		
		updateNum = this.LALM0117_updDormDelAccYnData(map);
		reMap.put("updateNum", updateNum);
		
		return reMap;
	}

	/**
	 * 계정 삭제여부 업데이트 하는 메소드
	 * 회원통합테이블, 중도매인 계정삭제여부 컬럼 업데이트
	 * TODO : 농가 테이블은 축경통에서 내려받는 정보라서 삭제처리는 확인해봐야 함
	 * @param map
	 * @return
	 */
	private int LALM0117_updDormDelAccYnData(Map<String, Object> map) {
		int updateNum = 0;
		try {
			updateNum = lalm0117Mapper.LALM0117_updDormacDelAccYn(map);
			
			if("01".equals(map.get("mbintg_gubun").toString())) {
				updateNum = lalm0117Mapper.LALM0117_updDormacMwmnDelAccYn(map);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return updateNum;
	}
	
	/**
	 * 이용해지신청회원 목록 조회
	 * 가축시장 [나의정보] 에서 이용해지 신청 가능 
	 */
	@Override
	public List<Map<String, Object>> LALM0117_selSecessionAplyUsrList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0117Mapper.LALM0117_selSecessionAplyUsrList(map);
		return list;
	}

	/**
	 * [이용해지 처리] 버튼 클릭 시, 
	 * 조합 데이터 삭제여부 업데이트 및 마스킹 처리
	 * 조합별로 이용해지 시키되, 마지막 남은 조합이 없을 경우 통합회원 테이블 데이터도 삭제여부 업데이트
	 */
	@Override
	public Map<String, Object> LALM0117_delSecApplyUserData(Map<String, Object> map) throws Exception {
		int insertNum = 0;
		int updateNum = 0;
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> trmnlist = (List<Map<String, Object>>) map.get("trmn_amnno_list");
		map.put("sec_apply", "Y");
		
		for(Map<String, Object> trmnVo : trmnlist) {
			map.put("trmn_amnno", trmnVo.get("trmn_amnno"));	
			map.put("mb_intg_no", trmnVo.get("mb_intg_no"));	
			insertNum = lalm0117Mapper.LALM0117_insMwmnHistoryData(map);	//중도매인 이력 테이블 저장
			updateNum = lalm0117Mapper.LALM0117_updSecessionMwmnDelAccYn(map);		//중도매인 테이블 데이터 삭제 & 마스킹

			//통합회원번호가 있는 경우에만
			if(!"".equals(trmnVo.get("mb_intg_no"))) {
				Map<String, Object> haveCntInfo = lalm0117Mapper.LALM0117_selSecAplyRemainTrmnCnt(map);
				
				int n_all_cnt = Integer.parseInt(haveCntInfo.get("N_ALL_CNT").toString());
				int n_del_cnt = Integer.parseInt(haveCntInfo.get("N_DEL_CNT").toString());
				if(n_all_cnt == n_del_cnt) {	//중도매인이 모두 삭제되면, 통합계정도 삭제하기 
					insertNum = lalm0117Mapper.LALM0117_insMbintgHistoryData(map);
					updateNum = lalm0117Mapper.LALM0117_delSecessionMbintgDelAccYn(map);
				}
			}
				
			//탈퇴신청 테이블에 관리자승인여부 업데이트 
			updateNum = lalm0117Mapper.LALM0117_updSecessionMgrApprYn(map);
		}
		
		reMap.put("insertNum", insertNum);
		reMap.put("updateNum", updateNum);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0117_sendAlimPreDormcUser(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> reList = lalm0117Mapper.LALM0117_sendAlimPreDormcUser(map);
		int allCnt = reList == null ? 0 : reList.size();
		if(allCnt > 0) {
			for(Map<String, Object> reVo : reList) {
				batchService.sendAlarmTalk_DormacPreUser(reVo);
			}
		}
		return null;
	}
	
	
}
