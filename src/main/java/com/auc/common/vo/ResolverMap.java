package com.auc.common.vo;

import java.util.HashMap;
import java.util.Map;

public class ResolverMap {

	Map<String, Object> map = new HashMap<String, Object>();
	
	public Map<String, Object> getMap(){return this.map;}
	
	public Object get(String key){ return map.get(key); } 
	public void put(String key, String value){ map.put(key, value); }
	public String toString() { return map.toString();}
}
