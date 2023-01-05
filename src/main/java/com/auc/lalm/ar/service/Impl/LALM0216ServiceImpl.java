package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0216Service;

@Service("LALM0216Service")
public class LALM0216ServiceImpl implements LALM0216Service{

	
	  @Autowired
	  LALM0216Mapper lalm0216Mapper;
	  
	  @Override
	  public List<Map<String, Object>> LALM0216_selList(Map<String,Object> map) throws Exception { 
		  
		
		  List<Map<String,Object>> list =null;
		  list = lalm0216Mapper.LALM0216_selList(map);
		 
		 return list;
	  
	  }
	  @Override
	  public List<Map<String, Object>> LALM0216_selList_2(Map<String,Object> map) throws Exception { 
		  
		  
		  List<Map<String,Object>> list =null;
		  list = lalm0216Mapper.LALM0216_selList_2(map);
		
		 return list;
	  
	  }
	  @Override
	  public List<Map<String, Object>> LALM0216_selList_3(Map<String,Object> map) throws Exception { 
		  
		  
		  List<Map<String,Object>> list =null;
		  list = lalm0216Mapper.LALM0216_selList_3(map);
		
		 return list;
	  
	  }
	  @Override
	  public List<Map<String, Object>> LALM0216_selList_4(Map<String,Object> map) throws Exception { 
		  
		  
		  List<Map<String,Object>> list =null;
		  list = lalm0216Mapper.LALM0216_selList_4(map);
		
		 return list;
	  
	  }
}
