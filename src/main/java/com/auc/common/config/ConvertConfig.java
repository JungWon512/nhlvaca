package com.auc.common.config;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import java.util.Set;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.auc.common.util.StringUtils;
import com.auc.common.vo.JwtUser;
import com.auc.common.vo.ResolverMap;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class ConvertConfig {

	private ObjectMapper mapper = new ObjectMapper();

	private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

	private static final String SS_ENO = "ss_eno";
    private static final String SS_USERID = "ss_userid";
    private static final String SS_NA_BZPLC = "ss_na_bzplc";
    private static final String SS_SECURITY = "ss_security";
    private static final String SS_GRP_C = "ss_grp_c";
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

	@SuppressWarnings("unchecked")
	public Map<String, Object> conMap(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		// 개인정보권한 날짜체크
        LocalDateTime nowDate = LocalDateTime.now();
        LocalDateTime aplDate = LocalDateTime.parse(jwtuser.getApl_ed_dtm(), formatter);

        String security = nowDate.isBefore(aplDate) ? "1" : "0";
		
		if(rMap.getMap().isEmpty()) {
			return sessionMap(jwtuser, security);
		}
		
		String data = rMap.get("data").toString();
				
		Map<String, Object> getMap = mapper.readValue(data, HashMap.class);
		
		//모든 맵 안에 session 값을  넣어준다.
		//Object 값이 List면 list안에 ss_eno를 넣어준다.
		List<Map<String, Object>> inList = null;
		Map<String, Object> enMap = null;
		
	    for (Map.Entry<String, Object> entry : getMap.entrySet()) {
	    	//리스트일때
	    	if(entry.getValue() instanceof List) {
	        	inList = (List<Map<String, Object>>) entry.getValue();
	        	int listCnt = 0;
	        	listCnt = inList.size();
	        	Map<String, Object> inMap = null;

	        	for (int i = 0; i < listCnt; i++) {
	        		if(inList.get(i) instanceof Map) {
	        			Map<String, Object> inListMap = inList.get(i);
	        			
	        			inMap = new HashMap<String, Object>();
	        			
	        			for(Map.Entry<String, Object> inEntry : inListMap.entrySet()) {
	        				if(inEntry.getValue() instanceof String) {
	        					inMap.put(inEntry.getKey().toLowerCase(), StringUtils.xxsFilter((String)inEntry.getValue()));
	        				}else {
	        					inMap.put(inEntry.getKey().toLowerCase(), inEntry.getValue());
	        				}
	        			}
		        		//세션값 넣음
	        			sessionMap(inMap, jwtuser, security);

		        		inList.remove(inListMap);
		        		inList.add(i, inMap);
	        		}
				}
	        //맵일때
	        } else if(entry.getValue() instanceof Map) {
	        	enMap = (Map<String, Object>) entry.getValue();	        	
	        	Map<String, Object> inMap = new HashMap<String, Object>();
	        	//키 소문자로 변환
	    	    Set<String> inSet = enMap.keySet();
	    	    Iterator<String> inEt = inSet.iterator();
	    	    while(inEt.hasNext()){
	    	    	String key = inEt.next();
	    	    	if(enMap.get(key) instanceof String) {
	    	    		inMap.put(key.toLowerCase(), StringUtils.xxsFilter((String)enMap.get(key)));
	    	    	}else {
	    	    		inMap.put(key.toLowerCase(), enMap.get(key));
	    	    	}
	    	    }
	    	    //세션값 넣음
				sessionMap(inMap, jwtuser, security);

	    	    getMap.put(entry.getKey(), inMap);
	        }	
	    }

		sessionMap(getMap, jwtuser, security);

	    //키 소문자로 변환
	    Set<String> set = getMap.keySet();
	    Iterator<String> e = set.iterator();

	    while(e.hasNext()){
			String key = e.next();
	    	if(getMap.get(key) instanceof String) {
				map.put(key.toLowerCase(), StringUtils.xxsFilter((String)getMap.get(key)));
	    	}else {
				map.put(key.toLowerCase(), getMap.get(key));
	    	}
	    }
		
		if (!set.contains(SRA_SRS_DSC)
		|| (map.get(SRA_SRS_DSC) == null || "".equals(map.get(SRA_SRS_DSC)))) {
			setSraSrsDsc(map);
		}
		return map;
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> conMapWithoutXxs(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		// 개인정보권한 날짜체크
        LocalDateTime nowDate = LocalDateTime.now();
        LocalDateTime aplDate = LocalDateTime.parse(jwtuser.getApl_ed_dtm(), formatter);

        String security = nowDate.isBefore(aplDate) ? "1" : "0";
		
		if(rMap.getMap().isEmpty()) {
			return sessionMap(jwtuser, security);
		}
		
		String data = rMap.get("data").toString();
				
		Map<String, Object> getMap = mapper.readValue(data, HashMap.class);
		
		//모든 맵 안에 session 값을  넣어준다.
		//Object 값이 List면 list안에 ss_eno를 넣어준다.				
		List<Map<String, Object>> inList = null;
		Map<String, Object> enMap = null;
		
	    for (Map.Entry<String, Object> entry : getMap.entrySet()) {	    
	    	//리스트일때
	    	if(entry.getValue() instanceof List) {
	        	inList = (List<Map<String, Object>>) entry.getValue();
	        	int listCnt = 0;
	        	listCnt = inList.size();
	        	Map<String, Object> inMap = null;
	        		        		        	
	        	for (int i = 0; i < listCnt; i++) {	        		
	        		if(inList.get(i) instanceof Map) {	        			
	        			Map<String, Object> inListMap = inList.get(i);	
	        			
	        			inMap = new HashMap<String, Object>();
	        			
	        			for(Map.Entry<String, Object> inEntry : inListMap.entrySet()) {
	        				inMap.put(inEntry.getKey().toLowerCase(), inEntry.getValue());
	        			}
		        		//세션값 넣음
	        			sessionMap(inMap, jwtuser, security);

		        		inList.remove(inListMap);
		        		inList.add(i, inMap);
	        		}
				}
	        //맵일때
	        }else if(entry.getValue() instanceof Map) {
	        	enMap = (Map<String, Object>) entry.getValue();	        	
	        	Map<String, Object> inMap = new HashMap<String, Object>();
	        	//키 소문자로 변환
	    	    Set<String> inSet = enMap.keySet();
	    	    Iterator<String> inEt = inSet.iterator();
	    	    while(inEt.hasNext()){
	    	    	String key = inEt.next();
	    	    	inMap.put(key.toLowerCase(), enMap.get(key));
	    	    }
	    	    //세션값 넣음
				sessionMap(inMap, jwtuser, security);
	    	    
	    	    getMap.put(entry.getKey(), inMap);
	        }	
	    }	    		
	    
		//세션값 넣음
		sessionMap(getMap, jwtuser, security);

	    //키 소문자로 변환
	    Set<String> set = getMap.keySet();
	    Iterator<String> e = set.iterator();


	    while(e.hasNext()){
	    	String key = e.next();
	    	map.put(key.toLowerCase(), getMap.get(key));
	    }
		
		if (!set.contains(SRA_SRS_DSC)
		|| (map.get(SRA_SRS_DSC) == null || "".equals(map.get(SRA_SRS_DSC)))) {
			setSraSrsDsc(map);
		}
		return map;
	}

	// 로그인한 사용자의 정보를 세션에 담아주는 메소드
	private Map<String, Object> sessionMap(JwtUser jwtuser, String security) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(SS_ENO, jwtuser.getUserEno());
		map.put(SS_USERID, jwtuser.getUsername());
		map.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
		map.put(SS_SECURITY, security);
		map.put(SS_GRP_C, jwtuser.getGrp_c());
		return map;
	}
	
	// 로그인한 사용자의 정보를 세션에 담아주는 메소드
	private void sessionMap(Map<String, Object> map, JwtUser jwtuser, String security) {
		map.put(SS_ENO, jwtuser.getUserEno());
		map.put(SS_USERID, jwtuser.getUsername());
		map.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
		map.put(SS_SECURITY, security);
		map.put(SS_GRP_C, jwtuser.getGrp_c());
	}

	// 경매 대상에 따라 축종 구분을 담아주는 메소드
	private void setSraSrsDsc(Map<String, Object> map) {
        map.entrySet().stream()
            .filter(entry -> entry.getKey().contains(AUC_OBJ_DSC) && entry.getValue() != null && !entry.getValue().toString().isEmpty())
            .findFirst()
            .ifPresent(entry -> {
                String sraSrsDsc = SRA_SRS_DSC_MAP.getOrDefault(entry.getValue().toString(), DEFAULT_SRA_SRS_DSC);
                map.put(SRA_SRS_DSC, sraSrsDsc);
            });
    }

	@SuppressWarnings("unchecked")
	public Map<String, Object> conMapBack(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		String apl_ed_dtm = jwtuser.getApl_ed_dtm();
		String security = jwtuser.getSecurity();
		//개인정보권한 날짜체크
		Date now_date = new Date(System.currentTimeMillis());
		SimpleDateFormat fourteen_format = new SimpleDateFormat("yyyyMMddHHmmss");
		fourteen_format.format(now_date);
		SimpleDateFormat apl_format = new SimpleDateFormat("yyyyMMddHHmmss");
		Date apl_date = apl_format.parse(apl_ed_dtm);
		
		int resultTime = now_date.compareTo(apl_date);

		if(resultTime < 0) {
			security = "1";
		}else {
			security = "0";
		}
		
		if(rMap.getMap().isEmpty()) {
			map.put(SS_ENO,      jwtuser.getUserEno());
			map.put(SS_USERID,   jwtuser.getUsername());
			map.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
			map.put(SS_SECURITY, security);
			map.put(SS_GRP_C   , jwtuser.getGrp_c());
			return map;
		}
		
		String data = rMap.get("data").toString();
				
		Map<String, Object> getMap = mapper.readValue(data, HashMap.class);
		
		//모든 맵 안에 session 값을  넣어준다.
		//Object 값이 List면 list안에 ss_eno를 넣어준다.				
		List<Map<String, Object>> inList = null;
		Map<String, Object> enMap = null;
		
	    for (Map.Entry<String, Object> entry : getMap.entrySet()) {	    
	    	//리스트일때
	    	if(entry.getValue() instanceof List) {
	        	inList = (List<Map<String, Object>>) entry.getValue();
	        	int listCnt = 0;
	        	listCnt = inList.size();
	        	Map<String, Object> inMap = null;
	        		        		        	
	        	for (int i = 0; i < listCnt; i++) {	        		
	        		if(inList.get(i) instanceof Map) {	        			
	        			Map<String, Object> inListMap = inList.get(i);	
	        			
	        			inMap = new HashMap<String, Object>();
	        			
	        			for(Map.Entry<String, Object> inEntry : inListMap.entrySet()) {
	        				if(inEntry.getValue() instanceof String) {
	        					inMap.put(inEntry.getKey().toLowerCase(), StringUtils.xxsFilter((String)inEntry.getValue()));
	        				}else {
	        					inMap.put(inEntry.getKey().toLowerCase(), inEntry.getValue());
	        				}
	        			}
		        		//세션값 넣음
	        			inMap.put(SS_ENO, jwtuser.getUserEno());
	        			inMap.put(SS_USERID, jwtuser.getUsername());
	        			inMap.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
	        			inMap.put(SS_SECURITY, security);
	        			inMap.put(SS_GRP_C   , jwtuser.getGrp_c());

		        		inList.remove(inListMap);
		        		inList.add(i, inMap);
	        		}
				}
	        //맵일때
	        }else if(entry.getValue() instanceof Map) {
	        	enMap = (Map<String, Object>) entry.getValue();	        	
	        	Map<String, Object> inMap = new HashMap<String, Object>();
	        	//키 소문자로 변환
	    	    Set<String> inSet = enMap.keySet();
	    	    Iterator<String> inEt = inSet.iterator();
	    	    while(inEt.hasNext()){
	    	    	String key = inEt.next();
	    	    	if(enMap.get(key) instanceof String) {
	    	    		inMap.put(key.toLowerCase(), StringUtils.xxsFilter((String)enMap.get(key)));
	    	    	}else {
	    	    		inMap.put(key.toLowerCase(), enMap.get(key));
	    	    	}
	    	    }
	    	    //세션값 넣음
	    	    inMap.put(SS_ENO, jwtuser.getUserEno());
	    	    inMap.put(SS_USERID, jwtuser.getUsername());
	    	    inMap.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
	    	    inMap.put(SS_SECURITY, security);
	    	    inMap.put(SS_GRP_C   , jwtuser.getGrp_c());

	    	    getMap.put(entry.getKey(), inMap);
	        }	
	    }	    		
	    
		//세션값 넣음	    
	    getMap.put(SS_ENO, jwtuser.getUserEno());
	    getMap.put(SS_USERID, jwtuser.getUsername());
	    getMap.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
	    getMap.put(SS_SECURITY,  security);
	    getMap.put(SS_GRP_C   , jwtuser.getGrp_c());

		// 기본 축종은 '우'로 설정
		map.put(SRA_SRS_DSC, "01");
		
	    //키 소문자로 변환
	    Set<String> set = getMap.keySet();
	    Iterator<String> e = set.iterator();
		// 경매 대상에 따라 축종 설정
		// 0~4 : 소(01), 5 : 염소(06), 6 : 말(04), 7~9 : 미정
		
	    while(e.hasNext()){
			String key = e.next();
	    	if(getMap.get(key) instanceof String) {
				map.put(key.toLowerCase(), StringUtils.xxsFilter((String)getMap.get(key)));
	    	}else {
				map.put(key.toLowerCase(), getMap.get(key));
	    	}
			// 경매 대상에 따라 축종 설정
			if (key.contains("auc_obj_dsc")) {
				final String value = String.valueOf(getMap.getOrDefault(key, "0"));
				map.put(SRA_SRS_DSC, SRA_SRS_DSC_MAP.get(value));
			}
	    }
		
		return map;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> conMapWithoutXxsBack(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		String apl_ed_dtm = jwtuser.getApl_ed_dtm();
		String security = jwtuser.getSecurity();
		//개인정보권한 날짜체크
		Date now_date = new Date(System.currentTimeMillis());
		SimpleDateFormat fourteen_format = new SimpleDateFormat("yyyyMMddHHmmss");
		fourteen_format.format(now_date);
		SimpleDateFormat apl_format = new SimpleDateFormat("yyyyMMddHHmmss");
		Date apl_date = apl_format.parse(apl_ed_dtm);
		
		int resultTime = now_date.compareTo(apl_date);

		if(resultTime < 0) {
			security = "1";
		}else {
			security = "0";
		}
		
		if(rMap.getMap().isEmpty()) {
			map.put(SS_ENO,      jwtuser.getUserEno());
			map.put(SS_USERID,   jwtuser.getUsername());
			map.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
			map.put(SS_SECURITY, security);
			map.put(SS_GRP_C   , jwtuser.getGrp_c());
			return map;
		}
		
		String data = rMap.get("data").toString();
				
		Map<String, Object> getMap = mapper.readValue(data, HashMap.class);
		
		//모든 맵 안에 session 값을  넣어준다.
		//Object 값이 List면 list안에 ss_eno를 넣어준다.				
		List<Map<String, Object>> inList = null;
		Map<String, Object> enMap = null;
		
	    for (Map.Entry<String, Object> entry : getMap.entrySet()) {	    
	    	//리스트일때
	    	if(entry.getValue() instanceof List) {
	        	inList = (List<Map<String, Object>>) entry.getValue();
	        	int listCnt = 0;
	        	listCnt = inList.size();
	        	Map<String, Object> inMap = null;
	        		        		        	
	        	for (int i = 0; i < listCnt; i++) {	        		
	        		if(inList.get(i) instanceof Map) {	        			
	        			Map<String, Object> inListMap = inList.get(i);	
	        			
	        			inMap = new HashMap<String, Object>();
	        			
	        			for(Map.Entry<String, Object> inEntry : inListMap.entrySet()) {
	        				inMap.put(inEntry.getKey().toLowerCase(), inEntry.getValue());
	        			}
		        		//세션값 넣음
	        			inMap.put(SS_ENO, jwtuser.getUserEno());
	        			inMap.put(SS_USERID, jwtuser.getUsername());
	        			inMap.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
	        			inMap.put(SS_SECURITY, security);
	        			inMap.put(SS_GRP_C   , jwtuser.getGrp_c());

		        		inList.remove(inListMap);
		        		inList.add(i, inMap);
	        		}
				}
	        //맵일때
	        }else if(entry.getValue() instanceof Map) {
	        	enMap = (Map<String, Object>) entry.getValue();	        	
	        	Map<String, Object> inMap = new HashMap<String, Object>();
	        	//키 소문자로 변환
	    	    Set<String> inSet = enMap.keySet();
	    	    Iterator<String> inEt = inSet.iterator();
	    	    while(inEt.hasNext()){
	    	    	String key = inEt.next();
	    	    	inMap.put(key.toLowerCase(), enMap.get(key));
	    	    }
	    	    //세션값 넣음
	    	    inMap.put(SS_ENO, jwtuser.getUserEno());
	    	    inMap.put(SS_USERID, jwtuser.getUsername());
	    	    inMap.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
	    	    inMap.put(SS_SECURITY, security);
	    	    inMap.put(SS_GRP_C   , jwtuser.getGrp_c());
	    	    
	    	    getMap.put(entry.getKey(), inMap);
	        }	
	    }	    		
	    
		//세션값 넣음	    
	    getMap.put(SS_ENO, jwtuser.getUserEno());
	    getMap.put(SS_USERID, jwtuser.getUsername());
	    getMap.put(SS_NA_BZPLC, jwtuser.getNa_bzplc());
	    getMap.put(SS_SECURITY,  security);
	    getMap.put(SS_GRP_C   , jwtuser.getGrp_c());

		// 기본 축종은 '우'로 설정
		map.put(SRA_SRS_DSC, "01");
	    	    
	    //키 소문자로 변환
	    Set<String> set = getMap.keySet();
	    Iterator<String> e = set.iterator();

		// 경매 대상에 따라 축종 설정
		// 0~4 : 소(01), 5 : 염소(06), 6 : 말(04), 7~9 : 미정
		final Map<String, String> sraSrsDscMap = new HashMap<String, String>() {
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

	    while(e.hasNext()){
	    	String key = e.next();
	    	map.put(key.toLowerCase(), getMap.get(key));

			// 경매 대상에 따라 축종 설정
			if (key.toLowerCase().contains("auc_obj_dsc")) {
				final String value = String.valueOf(getMap.getOrDefault(key, "0"));
				map.put(SRA_SRS_DSC, sraSrsDscMap.get(value));
			}
	    }
		
		final String sraSrsDsc = String.valueOf(map.getOrDefault(SRA_SRS_DSC, ""));
		if(sraSrsDsc.isEmpty()) {
			map.put(SRA_SRS_DSC, "01");
		}
		return map;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> conMap(String encStr) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String data =encStr;
				
		Map<String, Object> getMap = mapper.readValue(data, HashMap.class);
		
		//모든 맵 안에 session 값을 넣어준다.
		//Object 값이 List면 list안에 ss_eno를 넣어준다.				
		List<Map<String, Object>> inList = null;

	    for (Map.Entry<String, Object> entry : getMap.entrySet()) {
	    	
	        if(entry.getValue() instanceof List) {
	        	inList = (List<Map<String, Object>>) entry.getValue();
	        }	        
	    }	    		
	    
	    //키 소문자로 변환
	    Set<String> set = getMap.keySet();
	    Iterator<String> e = set.iterator();

	    while(e.hasNext()){
	      String key = e.next();
	      Object value = (Object) getMap.get(key);

	      map.put(key.toLowerCase(), value);
	    }
		
		return map;
	}
	
	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> signInConMap(ResolverMap rMap) throws Exception{
				
		Map<String, Object> map = new HashMap<String, Object>();
		
		String data = rMap.get("data").toString();
				
		Map<String, Object> getMap = mapper.readValue(data, HashMap.class);
			    	    
	    //키 소문자로 변환
	    Set<String> set = getMap.keySet();
	    Iterator<String> e = set.iterator();

	    while(e.hasNext()){
	      String key = e.next();
	      Object value = (Object) getMap.get(key);

	      map.put(key.toLowerCase(), value);
	    }
		
		return map;
	}

	public List<Map<String, Object>> conListMap(ResolverMap rMap) throws Exception {
		List<Map<String, Object>> list = (List<Map<String, Object>>) conMap(rMap).get("data");
		return list;
	}
	
	public Map<String, Object> changeKeyUpper(Map<String, Object> map){
    	Map<String, Object> reMap = new HashMap<String, Object>();
    	 //키 대문자로 변환
	    Set<String> set = map.keySet();
	    Iterator<String> e = set.iterator();
	    while(e.hasNext()){
	        String key = e.next();
	        Object value = (Object) map.get(key);
	        reMap.put(key.toUpperCase(), value);
	    }
    	return reMap;
    }
    
    public Map<String, Object> changeKeyLower(Map<String, Object> map){
    	Map<String, Object> reMap = new HashMap<String, Object>();
    	 //키 대문자로 변환
	    Set<String> set = map.keySet();
	    Iterator<String> e = set.iterator();
	    while(e.hasNext()){
	        String key = e.next();
	        Object value = (Object) map.get(key);
	        reMap.put(key.toLowerCase(), value);
	    }
    	return reMap;
    }

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> conMcaList(Object object) {
		
		List<Map<String, Object>> dataList = null;
		Map<String, Object> chkMap = (Map<String, Object>) object;
		
		if("null".equals(chkMap.get("RPT_DATA"))) {
			dataList = (List<Map<String, Object>>) chkMap.get("RPT_DATA");
		}else {
			dataList = new ArrayList<Map<String, Object>>();
		}
		return dataList;
	}
    
    
	
}
