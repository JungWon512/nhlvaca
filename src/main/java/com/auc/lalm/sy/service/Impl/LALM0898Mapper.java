package com.auc.lalm.sy.service.Impl;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LALM0898Mapper {

	int LALM0898_insAucDataQcn(Map<String, Object> map) throws Exception;

	int LALM0898_insAucDataStn(Map<String, Object> map) throws Exception;

	int LALM0898_insAucDataSogCow(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataQcn(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataStn(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataSogCow(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataSogCowLog(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataAtdrLog(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataAucEntr(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataFeeImps(Map<String, Object> map) throws Exception;

	int LALM0898_delAucDataStnLog(Map<String, Object> map) throws Exception;

	int LALM0898_updateAucSogCowInit(Map<String, Object> map) throws Exception;

	int LALM0898_updateAucStnInit(Map<String, Object> map) throws Exception;

	int LALM0898_selAucData(Map<String, Object> map) throws Exception;

}
