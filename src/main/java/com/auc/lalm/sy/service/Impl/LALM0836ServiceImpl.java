package com.auc.lalm.sy.service.Impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List ;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.lalm.sy.service.LALM0836Service;

@Service("LALM08TESTService")
public class LALM0836ServiceImpl implements LALM0836Service {

	@Autowired
	LALM0836Mapper lalm0836Mapper;

	
	//	지역 조회
	@Override
	public List<Map<String, Object>> LALM0836_selBzplcloc() throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0836Mapper.LALM0836_selBzplcloc();
		return list;
	}

	// 조합조회
	@Override
	public List<Map<String, Object>> LALM0836_selClntnm(Map<String, Object> map)throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0836Mapper.LALM0836_selClntnm(map);
		return list;
	}

	// 조합의 전화번호 & 주소 조회
	@Override
	public Map<String, Object> LALM0836_selTelAddress(Map<String, Object> map) throws Exception{
		Map<String, Object> inMap = null;
		inMap = lalm0836Mapper.LALM0836_selTelAddress(map);
		return inMap;
	}

	// 저장버튼 클릭시 
	@Override
	public Map<String, Object> LALM0836_insAucDateInfo(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		int deleteMainTable = 0;
		int deleteSubTable = 0;
		int mainTable = 0;
		int subTable = 0;
		
		
		// DELETE
		deleteMainTable =  lalm0836Mapper.LALM0836_delMainTable(map);
		deleteSubTable =  lalm0836Mapper.LALM0836_delSubTable(map);
		reMap.put("deleteMainTable", deleteMainTable);
		reMap.put("deleteSubTable", deleteSubTable);
		
		String scheDt = (String) map.get("sche_dt_gb");
		
		// 문자열 배열로 바꾸기 sche_dt : "0,13,0,11"
		String str1 = (String) map.get("sche_dt");
		String[] arr1 = str1.split(",");  
		String str2 = (String) map.get("sche_week");
		String[] arr2 = str2.split(",");  
		
		mainTable = lalm0836Mapper.LALM0836_insMainTable(map);
		reMap.put("mainTable", mainTable);
		
		
		if( scheDt.equals("1")) { // 지정일자
			for (int i =0 ; i< arr1.length; i++) { 
				if(!"0".equals(arr1[i])) {
					map.put("sche_dt", arr1[i]); 
					// 서브 테이블 삽입
					subTable = lalm0836Mapper.LALM0836_insSubTable(map);
					reMap.put("subTable", subTable);
				}
			}
		}else { // 지정요일 
			// 서브 테이블 삽입
			for (int i =0 ; i< arr2.length; i++) { 
				if(!"0".equals(arr2[i])) {
					map.put("sche_week", arr2[i]); 
					// 서브 테이블 삽입
					subTable = lalm0836Mapper.LALM0836_insSubTable(map);
					reMap.put("subTable", subTable);
				}
			}
		}
		
		reMap.put("insertNum", subTable);
		return reMap;
	}

	
	// 그리드 조회
	@Override
	public List<Map<String, Object>> LALM0836_SelAucInfo(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = lalm0836Mapper.LALM0836_SelAucInfo(map);
		return list;
	}

	// 경매일자 정보 데이터 조회해오기
	@Override
	public Map<String, Object> LALM0836_selAucDateInfo(Map<String, Object> map) {
		Map<String, Object> inMap = null;
		inMap = lalm0836Mapper.LALM0836_selAucDateInfo(map);
		return inMap;
	}

	// 데이터 삭제 버튼
	@Override
	public Map<String, Object> LALM0836_delAucDateInfo(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> selSubTable = null;
		int deleteMainTable = 0;
		int deleteSubTable = 0;
		int deleteNum = 0;
		
		// 서브테이블 삭제
		deleteSubTable =  lalm0836Mapper.LALM0836_delSubTable(map); 
		reMap.put("deleteSubTable", deleteSubTable);
		
		// na_bzplc 조합번호로 서브테이블 조회
		selSubTable =  lalm0836Mapper.LALM0836_selSubTable(map); 
		
		//서브테이블 조회가 0이면 -> 메인테이블 삭제삭제
		if( selSubTable.isEmpty() ) { 
			deleteMainTable =  lalm0836Mapper.LALM0836_delMainTable(map);
			reMap.put("deleteMainTable", deleteMainTable);
		}
	
		reMap.put("deleteNum", deleteNum);
		return reMap;
	}

	
	
	
}
