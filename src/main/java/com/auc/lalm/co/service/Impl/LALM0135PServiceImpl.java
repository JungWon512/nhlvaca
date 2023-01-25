package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.co.service.LALM0135PService;

@Service("LALM0135PService")
public class LALM0135PServiceImpl implements LALM0135PService{

	@Autowired
	private LALM0135PMapper lalm0135PMapper;

	/**
	 * 통합회원검색
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> LALM0135P_selList(Map<String, Object> map) throws Exception {
		return lalm0135PMapper.LALM0135P_selList(map);
	}


}
