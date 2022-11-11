package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0225Service;

@Service
public class LALM0225ServiceImpl implements LALM0225Service{
	
	@Autowired
	private LALM0225Mapper lalm0225Mapper;

	/**
	 * 출장우 접수 리스트
	 */
	@Override
	public List<Map<String, Object>> LALM0225_selList(Map<String, Object> map) {
		return lalm0225Mapper.LALM0225_selList(map);
	}

}
