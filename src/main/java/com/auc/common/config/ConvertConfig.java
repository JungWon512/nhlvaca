package com.auc.common.config;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
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
		
	ObjectMapper mapper = new ObjectMapper();
			
	@SuppressWarnings("unchecked")
	public Map<String, Object> conMap(ResolverMap rMap) throws Exception{
		
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
			map.put("ss_eno",      jwtuser.getUserEno());
			map.put("ss_userid",   jwtuser.getUsername());
			map.put("ss_na_bzplc", jwtuser.getNa_bzplc());
			map.put("ss_security", security);
			map.put("ss_grp_c"   , jwtuser.getGrp_c());
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
	        			inMap.put("ss_eno", jwtuser.getUserEno());
	        			inMap.put("ss_userid", jwtuser.getUsername());
	        			inMap.put("ss_na_bzplc", jwtuser.getNa_bzplc());
	        			inMap.put("ss_security", security);
	        			inMap.put("ss_grp_c"   , jwtuser.getGrp_c());

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
	    	    inMap.put("ss_eno", jwtuser.getUserEno());
	    	    inMap.put("ss_userid", jwtuser.getUsername());
	    	    inMap.put("ss_na_bzplc", jwtuser.getNa_bzplc());
	    	    inMap.put("ss_security", security);
	    	    inMap.put("ss_grp_c"   , jwtuser.getGrp_c());
	    	    
	    	    getMap.put(entry.getKey(), inMap);
	        }	
	    }	    		
	    
		//세션값 넣음	    
	    getMap.put("ss_eno", jwtuser.getUserEno());
	    getMap.put("ss_userid", jwtuser.getUsername());
	    getMap.put("ss_na_bzplc", jwtuser.getNa_bzplc());
	    getMap.put("ss_security",  security);
	    getMap.put("ss_grp_c"   , jwtuser.getGrp_c());
	    	    
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
		
		return map;
	}
	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> conMapWithoutXxs(ResolverMap rMap) throws Exception{
		
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
			map.put("ss_eno",      jwtuser.getUserEno());
			map.put("ss_userid",   jwtuser.getUsername());
			map.put("ss_na_bzplc", jwtuser.getNa_bzplc());
			map.put("ss_security", security);
			map.put("ss_grp_c"   , jwtuser.getGrp_c());
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
	        			inMap.put("ss_eno", jwtuser.getUserEno());
	        			inMap.put("ss_userid", jwtuser.getUsername());
	        			inMap.put("ss_na_bzplc", jwtuser.getNa_bzplc());
	        			inMap.put("ss_security", security);
	        			inMap.put("ss_grp_c"   , jwtuser.getGrp_c());

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
	    	    inMap.put("ss_eno", jwtuser.getUserEno());
	    	    inMap.put("ss_userid", jwtuser.getUsername());
	    	    inMap.put("ss_na_bzplc", jwtuser.getNa_bzplc());
	    	    inMap.put("ss_security", security);
	    	    inMap.put("ss_grp_c"   , jwtuser.getGrp_c());
	    	    
	    	    getMap.put(entry.getKey(), inMap);
	        }	
	    }	    		
	    
		//세션값 넣음	    
	    getMap.put("ss_eno", jwtuser.getUserEno());
	    getMap.put("ss_userid", jwtuser.getUsername());
	    getMap.put("ss_na_bzplc", jwtuser.getNa_bzplc());
	    getMap.put("ss_security",  security);
	    getMap.put("ss_grp_c"   , jwtuser.getGrp_c());
	    	    
	    //키 소문자로 변환
	    Set<String> set = getMap.keySet();
	    Iterator<String> e = set.iterator();

	    while(e.hasNext()){
	    	String key = e.next();
	    	map.put(key.toLowerCase(), getMap.get(key));
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
