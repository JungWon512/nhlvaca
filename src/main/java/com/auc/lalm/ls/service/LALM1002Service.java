package com.auc.lalm.ls.service;

import java.util.List;
import java.util.Map;

public interface LALM1002Service {

    List<Map<String, Object>> LALM1002_selList(Map<String, Object> map) throws Exception;

    Map<String, Object> LALM1002_insFee(Map<String, Object> map) throws Exception;

    Map<String, Object> LALM1002_selDetail(Map<String, Object> map) throws Exception;

    Map<String, Object> LALM1002_updFee(Map<String, Object> map) throws Exception;
}
