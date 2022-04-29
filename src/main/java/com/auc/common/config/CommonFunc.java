package com.auc.common.config;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.auc.common.vo.JwtUser;

@Component
public class CommonFunc {
	
	private static Logger log = LoggerFactory.getLogger(CommonFunc.class);
	
	@Autowired
	CriptoConfig criptoConfig;

	public JSONArray convertListMapToJson(List<Map<String, Object>> list) throws JSONException {
		
		JSONArray jsonArray = new JSONArray();		
		if(list != null) {			
			for(Map<String, Object> map : list) {					
				jsonArray.put(convertMaptoJson(map));
			}	
		}
			
		return jsonArray;
	}
	
	public JSONObject convertMaptoJson(Map<String, Object> map) throws JSONException {
		
		JSONObject jsonObject = new JSONObject();	
		if(map != null) {
			for(Entry<String, Object> entry : map.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				jsonObject.put(key, (value ==null)?"":value);		
			}
		}
		
		return jsonObject;
	}
	
    @SuppressWarnings("unchecked")
	public JSONObject convertMaptoArrJson(Map<String, Object> map) throws JSONException {
		
		JSONObject jsonObject = new JSONObject();	
		if(map != null) {
			for(Entry<String, Object> entry : map.entrySet()) {
				String key = entry.getKey();
				List<Map<String, Object>> value = (List<Map<String, Object>>)entry.getValue();
				
				jsonObject.put(key, convertListMapToJson(value));		
			}
		}
		
		return jsonObject;
	}
	
	
	public Map<String, Object> createResultSetListData(List<Map<String, Object>> list) throws Exception{
		
		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		//데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
		Map<String, Object> reMap = new HashMap<String, Object>();		

		//JSON으로 변경
		JSONArray jsonArray = convertListMapToJson(list);
		
		String encript = criptoConfig.encript(jsonArray.toString());	
		
		//조회 결과가 0건일 경우 201 리턴
		if(list.size() < 1) {
			reMap.put("status", 201);
			reMap.put("code", "C001");
			reMap.put("message", "조회된 내역이 없습니다.");
		}else {
			reMap.put("status", 200);
			reMap.put("code", "C000");
			reMap.put("message", "");
		}
		reMap.put("data", encript);
		reMap.put("ss_eno", jwtuser.getUserEno());
		reMap.put("ss_bzplc", jwtuser.getNa_bzplc());
		
		return reMap;	
	}
	
	public Map<String, Object> createResultSetMapData(Map<String, Object> map) throws Exception{

		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		//데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
		Map<String, Object> reMap = new HashMap<String, Object>();		
		
		//JSON으로 변경
		JSONObject jsonObject = convertMaptoJson(map);
		String encript = criptoConfig.encript(jsonObject.toString());	
		//조회 결과가 0건일 경우 201 리턴
		if(map == null || map.isEmpty()) {
			reMap.put("status", 201);
			reMap.put("code", "C001");
			reMap.put("message", "조회된 내역이 없습니다.");
		}else if(map.containsKey("jsonHeader")){
			if("Error".equals(map.get("jsonHeader"))) {
				reMap.put("status", 202);
				reMap.put("code", "C002");
				reMap.put("message", "전송 실패 하였습니다.");
			}else {
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("dataCnt", map.get("dataCnt"));
				reMap.put("message", "");
			}
		}else {
			reMap.put("status", 200);
			reMap.put("code", "C000");
			reMap.put("message", "");
		}		
		reMap.put("data", encript);
		reMap.put("ss_eno", jwtuser.getUserEno());
		reMap.put("ss_bzplc", jwtuser.getNa_bzplc());
		
		return reMap;		
	}
	
	public Map<String, Object> createResultSetJsonData(Map<String, Object> map) throws Exception{

		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		//데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
		Map<String, Object> reMap = new HashMap<String, Object>();		
		
		//JSON으로 변경
		JSONObject jsonObject = convertMaptoArrJson(map);
		String encript = criptoConfig.encript(jsonObject.toString());	
		//조회 결과가 0건일 경우 201 리턴
		if(map == null || map.isEmpty()) {
			reMap.put("status", 201);
			reMap.put("code", "C001");
			reMap.put("message", "조회된 내역이 없습니다.");
		}else if(map.containsKey("jsonHeader")){
			if("Error".equals(map.get("jsonHeader"))) {
				reMap.put("status", 202);
				reMap.put("code", "C002");
				reMap.put("message", "전송 실패 하였습니다.");
			}else {
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("dataCnt", map.get("dataCnt"));
				reMap.put("message", "");
			}
		}else {
			reMap.put("status", 200);
			reMap.put("code", "C000");
			reMap.put("message", "");
		}		
		reMap.put("data", encript);
		reMap.put("ss_eno", jwtuser.getUserEno());
		reMap.put("ss_bzplc", jwtuser.getNa_bzplc());
		
		return reMap;		
	}
	
	public Map<String, Object> createResultCUD(Map<String, Object> map) throws Exception{

		//토큰 사용자 정보 받아오기
		JwtUser jwtuser = (JwtUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		//데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
		Map<String, Object> reMap = new HashMap<String, Object>();		

		//JSON으로 변경
		JSONObject jsonObject = convertMaptoJson(map);		
		String encript = criptoConfig.encript(jsonObject.toString());	
		reMap.put("data", encript);
		reMap.put("ss_eno", jwtuser.getUserEno());
		reMap.put("ss_bzplc", jwtuser.getNa_bzplc());
		
		if(map == null) {
			reMap.put("status", 201);
			reMap.put("code", "C001");
			reMap.put("message", "저장된 내역이 없습니다");
		}else {
			//service에서 insertNum, updateNum, deleteNum 값 put 해줌
			if(map.containsKey("insertNum")) {				
				reMap.put("insertNum", map.get("insertNum"));
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("message", "");
			}
			if(map.containsKey("updateNum")) {
				reMap.put("updateNum", map.get("updateNum"));
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("message", "");
			}
			if(map.containsKey("deleteNum")) {
				reMap.put("deleteNum", map.get("deleteNum"));
				reMap.put("status", 200);
				reMap.put("code", "C000");
				reMap.put("message", "");
			}
	        if(!map.containsKey("insertNum") && !map.containsKey("updateNum") && !map.containsKey("deleteNum")) {
				reMap.put("status", 201);
				reMap.put("code", "C001");
				reMap.put("message", "저장된 내역이 없습니다");
			}
		}
		
		return reMap;
		
	}
	
	
	
	

}
