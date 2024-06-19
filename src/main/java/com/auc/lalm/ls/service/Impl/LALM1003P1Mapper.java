package com.auc.lalm.ls.service.Impl;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM1003P1Mapper {
	int LALM1003P1_insEtc(Map<String, Object> map);

	int LALM1003P1_insIndv(Map<String, Object> map);
}
