package com.auc.lalm.ls.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ls.service.LALM1010Service;

@Service("LALM1010Service")
public class LALM1010ServiceImpl implements LALM1010Service{

	
	  @Autowired
	  LALM1010Mapper lalm1010Mapper;
	  
	  @Override
	  public List<Map<String, Object>> LALM1010_selList(Map<String,Object> map) throws Exception { 
		  
		
		  List<Map<String,Object>> list =null;
		  list = lalm1010Mapper.LALM1010_selList(map);
		 
		 return list;
	  
	  }
	  @Override
	  public List<Map<String, Object>> LALM1010_selList_2(Map<String,Object> map) throws Exception { 
		  
		  
		  List<Map<String,Object>> list =null;
		  list = lalm1010Mapper.LALM1010_selList_2(map);
		
		 return list;
	  
	  }
	  @Override
	  public List<Map<String, Object>> LALM1010_selList_3(Map<String,Object> map) throws Exception { 
		  
		  
		  List<Map<String,Object>> list =null;
		  list = lalm1010Mapper.LALM1010_selList_3(map);
		
		 return list;
	  
	  }
	  @Override
	  public List<Map<String, Object>> LALM1010_selList_4(Map<String,Object> map) throws Exception { 
		  
		  
		  List<Map<String,Object>> list =null;
		  list = lalm1010Mapper.LALM1010_selList_4(map);
		
		 return list;
	  
	  }
}
