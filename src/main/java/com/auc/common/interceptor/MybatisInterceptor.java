package com.auc.common.interceptor;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;

/**
 * MybatisInterceptor
 * 1. Created by : ycsong
 * 2. Created Date : 2024-03-07
 * 3. Description : Mybatis 공통 인자 설정 인터셉터(select, insert, update시)
 * 4. History
 * > 2024-03-07 : 최초 생성
 * 
 * 현재 스마트 가축시장은 한우 경매 전용으로 설계되어 있어 기타 가축이 추가될 경우 리스트 조회에 영향도가 발생함.
 * (동일한 날짜 경매만 아니면 영향도가 줄어들긴 하지만...)
 * 예) 경매대상 구분코드(auc_obj_dsc)가 일괄(0)인 경우 출장 목록이 한우만 조회되어야 하지만 전체 가축이 조회됨.
 * 따라서 목록 조회시 경매대상 구분코드(auc_obj_dsc)에 따라 축종 구분(sra_srs_dsc)을 강제로 넣어줘서 조회하도록 해야함.
 * 
 * 이 로직을 ConvertConfig에서 처리할지 여부를 interceptor에서 처리할지 고민중...
 * ConvertConfig는 Controller에서 Service를 호출하기 전에 실행되고
 * 모든 Parameter의 key를 소문자로 변환, 로그인 사용자 정보를 넣어주는 역할을 하고 있음.
 */
@Intercepts({
    // @Signature(type = Executor.class, method = "update",
    //            args = {MappedStatement.class, Object.class}),
    @Signature(type = Executor.class, method = "query",
               args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class})
})
public class MybatisInterceptor implements Interceptor {

    private static final String SRA_SRS_DSC = "sra_srs_dsc";
    private static final String AUC_OBJ_DSC = "auc_obj_dsc";
	private static final String DEFAULT_SRA_SRS_DSC = "01";
	// 경매 대상에 따라 축종 구분
	private static final Map<String, String> SRA_SRS_DSC_MAP = new HashMap<String, String>() {
		{
			put("0", "01");
			put("1", "01");
			put("2", "01");
			put("3", "01");
			put("4", "01");
			put("5", "06");
			put("6", "04");
			put("7", "01");
			put("8", "01");
			put("9", "01");
		}
	};

    @Override
    @SuppressWarnings("unchecked")
    public Object intercept(Invocation invocation) throws Throwable {
        if(invocation.getArgs().length > 1 && invocation.getArgs()[1] instanceof Map) 
        {
            final Map<String, Object> paramMap = (Map<String, Object>) invocation.getArgs()[1];
            final Set<String> keySet = paramMap.keySet();

            if (!keySet.contains(SRA_SRS_DSC)
            || (paramMap.get(SRA_SRS_DSC) == null || "".equals(paramMap.get(SRA_SRS_DSC)))) {
                setSraSrsDsc(paramMap);
            }
        }
        return invocation.proceed();
    }

    private void setSraSrsDsc(Map<String, Object> map) {
        map.entrySet().stream()
            .filter(entry -> entry.getKey().contains(AUC_OBJ_DSC) && entry.getValue() != null && !entry.getValue().toString().isEmpty())
            .findFirst()
            .ifPresent(entry -> {
                String sraSrsDsc = SRA_SRS_DSC_MAP.getOrDefault(entry.getValue().toString(), DEFAULT_SRA_SRS_DSC);
                map.put(SRA_SRS_DSC, sraSrsDsc);
            });
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }
}