package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ls.service.LALM1009Service;

@Service("LALM1009Service")
public class LALM1009ServiceImpl implements LALM1009Service{
	@Autowired
	LALM1009Mapper lalm1009Mapper;

	@Override
	public List<Map<String, Object>> LALM1009_selList(Map<String, Object> map) throws Exception{
		//최초 낙,유찰 row 조회후 해당 변겨일시 보다 큰 데이터 조회
		List<Map<String, Object>> reList =  lalm1009Mapper.LALM1009_selList(map);
		return reList;
	}

}
