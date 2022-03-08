package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.batch.core.repository.support.MapJobRepositoryFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.sy.service.LALM0831Service;

@Service("LALM0831Service")
public class LALM0831ServiceImpl implements LALM0831Service{
	
	@Autowired
	LALM0831Mapper lalm0831Mapper;	

	@Override
	public List<Map<String, Object>> LALM0831_selList() throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0831Mapper.LALM0831_selList();
		return list;
	}

	@Override
	public Map<String, Object> LALM0831_insMenu(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int insertNum = 0;
		
		insertNum = lalm0831Mapper.LALM0831_insMenu(map);
		reMap.put("insertNum", insertNum);		
				
		if(insertNum > 0) {
			//TB_LA_IS_MM_MENU_AUTH - 001, 002 권한 등록
			//001 전체, 002 SY 빼고
			//C D P R U X
			Map<String, Object> authMap = new HashMap<String, Object>();
			
			if(!"00".equals(((String)map.get("menu_id")).substring(4, 6))) {
				for(int j = 0; j < 2; j++) {
					for(int k = 0; k < 6; k++) {
						authMap.clear();
						authMap.put("ss_userid", (String)map.get("ss_userid"));
						authMap.put("menu_id", (String)map.get("menu_id"));
						authMap.put("grp_c", String.format("%03d", j+1));
						
						switch(k+1) {
							case 1 : authMap.put("btn_tpc", "R"); break;
							case 2 : authMap.put("btn_tpc", "C"); break;
							case 3 : authMap.put("btn_tpc", "U"); break;
							case 4 : authMap.put("btn_tpc", "D"); break;
							case 5 : authMap.put("btn_tpc", "X"); break;
							case 6 : authMap.put("btn_tpc", "P"); break;
						}
						//002 - 일반사용자 and 시스템 menu_id like 0008					
						if(j == 1 && ("0008").equals(((String)authMap.get("menu_id")).substring(0, 4))) {
							break;
						}						
						insertNum = lalm0831Mapper.LALM0831_insMenuAuth(authMap);					
					}
				}
			}
		}		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0831_updMenu(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = lalm0831Mapper.LALM0831_updMenu(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0831_delMenu(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int deleteNum = 0;
		deleteNum = lalm0831Mapper.LALM0831_delMenu(map);
		reMap.put("deleteNum", deleteNum);
		if(deleteNum > 0) {
			deleteNum = lalm0831Mapper.LALM0831_delMenuAuth(map);
		}
		return reMap;
	}

}
