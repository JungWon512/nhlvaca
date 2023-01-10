package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0834Service;

@Service("LALM0834Service")
public class LALM0834ServiceImpl implements LALM0834Service{
	
	@Autowired
	LALM0834Mapper lalm0834Mapper;

	@Override
	public List<Map<String, Object>> LALM0834_selList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;	
		list = lalm0834Mapper.LALM0834_selList(map);
		return list;
	}

	@Override
	public Map<String, Object> LALM0834_insList(List<Map<String, Object>> list) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int deleteNum = 0;
		int insertNum = 0;		
		Map<String, Object> insMap = null;
		
		//삭제
		for(int k = 0; k < list.size(); k++) {
			insMap = (Map<String, Object>) list.get(k);
			if(!("".equals(insMap.get("grp_c")))) {
				deleteNum = lalm0834Mapper.LALM0834_delList(insMap);
			}
		}
		reMap.put("deleteNum", deleteNum);
		
				
		for(int i = 0; i < list.size(); i++) {
			insMap = (Map<String, Object>) list.get(i);	
			if(!("".equals(insMap.get("grp_c"))) && !("00".equals(insMap.get("menu_id").toString().substring(4,6)))) {				
				for(int k = 0; k < 6; k++) {					
					switch(k+1) {
						case 1 : insMap.put("btn_tpc", "R"); 
						         if(insMap.get("auth_r").equals("1")) {
						        	 insMap.put("auth_yn", "1");
						         }else {
						        	 insMap.put("auth_yn", "0");
						         }
						         break;
						case 2 : insMap.put("btn_tpc", "C");
								 if(insMap.get("auth_c").equals("1")) {
						             insMap.put("auth_yn", "1");
						         }else {
						             insMap.put("auth_yn", "0");
						         }
								 break;
						case 3 : insMap.put("btn_tpc", "U");
						         if(insMap.get("auth_u").equals("1")) {
				                     insMap.put("auth_yn", "1");
				                 }else {
				                     insMap.put("auth_yn", "0");
				                 }
						         break;
						case 4 : insMap.put("btn_tpc", "D");
						         if(insMap.get("auth_d").equals("1")) {
				                     insMap.put("auth_yn", "1");
				                 }else {
				                     insMap.put("auth_yn", "0");
				                 }
						         break;
						case 5 : insMap.put("btn_tpc", "X");
						         if(insMap.get("auth_x").equals("1")) {
				                     insMap.put("auth_yn", "1");
				                 }else {
				                     insMap.put("auth_yn", "0");
				                 }
						         break;
						case 6 : insMap.put("btn_tpc", "P");
						         if(insMap.get("auth_p").equals("1")) {
				                     insMap.put("auth_yn", "1");
				                 }else {
				                     insMap.put("auth_yn", "0");
				                 }
						         break;
					}					
					insertNum = lalm0834Mapper.LALM0834_insList(insMap);
				}
			}
		}			
		reMap.put("insertNum", insertNum);		
		return reMap;
	}	


}
