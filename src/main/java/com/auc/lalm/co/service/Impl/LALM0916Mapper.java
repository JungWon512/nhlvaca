package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0916Mapper {

	Map<String, Object> LALM0916_selPw(Map<String, Object> map) throws Exception;

	int LALM0916_updPw(Map<String, Object> map) throws Exception;

}
