package com.auc.lalm.co.service.Impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0126PMapper {

	List<Map<String, Object>> LALM0126P_selListProv(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0126P_selList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> LALM0126P_selListCcw(Map<String, Object> map) throws Exception;

}
