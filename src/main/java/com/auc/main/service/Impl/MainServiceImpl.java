package com.auc.main.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.auc.main.service.MainService;

@Service("MainService")
public class MainServiceImpl implements MainService{
	
	@Autowired
	MainMapper mainMapper;	
		
	@Override
	public List<Map<String, Object>> getUserList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;		
		list = mainMapper.getUserList(map);		
		return list;
	}


	@Override
	public List<Map<String, Object>> selectMenuList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;		
		list = mainMapper.selectMenuList(map);		
		return list;
	}
	
	@Override
	public List<Map<String, Object>> selectPopupList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;		
		list = mainMapper.selectPopupList(map);		
		return list;
	}

	@Override
	public Map<String, Object> getLoginInfo(Map<String, Object> map) throws Exception {		
		Map<String, Object> loginMap = mainMapper.getLoginInfo(map);		
		return loginMap;
	}


	@Override
	public List<Map<String, Object>> selectBtnList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;		
		list = mainMapper.selectBtnList(map);
		return list;		
	}


	@Override
	public List<Map<String, Object>> selectBtnAuthList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;			
		list = mainMapper.selectBtnAuthList(map);		
		return list;		
	}
	
	@Override
	public List<Map<String, Object>> selectComboList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;			
		list = mainMapper.selectComboList(map);		
		return list;		
	}
	
	@Override
	public List<Map<String, Object>> selectWmcListData(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;			
		list = mainMapper.selectWmcListData(map);
		return list;		
	}


	@Override
	public List<Map<String, Object>> selectEnvListData(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = null;			
		list = mainMapper.selectEnvListData(map);
		return list;	
	}
	

	@Override
	public List<Map<String, Object>> MainSogYear_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = mainMapper.MainSogYear_selList(map);
		return list;		
	}

	@Override
	public List<Map<String, Object>> MainSogQcn_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = mainMapper.MainSogQcn_selList(map);
		return list;		
	}	
	
	@Override
	public List<Map<String, Object>> MainNotice_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = mainMapper.MainNotice_selList(map);
		return list;		
	}
	

	@Override
	public List<Map<String, Object>> selectNaList() throws Exception {
		List<Map<String, Object>> list = null;		
		list = mainMapper.selectNaList();
		return list;
	}
	
	@Override
	public Map<String, Object> updatePassword(Map<String, Object> map) throws Exception {
		
		Map<String, Object> reMap = new HashMap<String, Object>();		
		int updateNum = 0;
		updateNum = updateNum + mainMapper.updatePassword(map);
		reMap.put("updateNum", updateNum);		
		return reMap;
	}


	@Override
	public List<Map<String, Object>> MainSecApply_selList(Map<String, Object> map) throws Exception {
		return mainMapper.MainSecApply_selList(map);
	}
	
	@Override
	public List<Map<String, Object>> selectNaUserList(Map<String, Object> map) throws Exception{		
		List<Map<String, Object>> list = mainMapper.selectNaUserList(map);
		return list;		
	}

}
