package com.auc.lalm.ab.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ab.service.LALM0324Service;

@Service("LALM0324Service")
public class LALM0324ServiceImpl implements LALM0324Service{
	@Autowired
	LALM0324Mapper lalm0324Mapper;

	@Override
	public List<Map<String, Object>> Lalm0324_selList(Map<String, Object> map) throws Exception{
		//최초 낙,유찰 row 조회후 해당 변겨일시 보다 큰 데이터 조회
		List<Map<String, Object>> reList =  lalm0324Mapper.Lalm0324_selList(map);
		return reList;
	}

}
