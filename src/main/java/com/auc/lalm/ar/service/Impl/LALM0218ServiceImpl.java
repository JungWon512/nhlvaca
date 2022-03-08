package com.auc.lalm.ar.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0218Service;
import com.auc.lalm.sy.service.Impl.LALM0899Mapper;

@Service("LALM0218Service")
public class LALM0218ServiceImpl implements LALM0218Service{

	@Autowired
	LALM0218Mapper lalm0218Mapper;
	@Autowired
	LALM0899Mapper lalm0899Mapper;
	
	@Override
	public List<Map<String, Object>> LALM0218_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		
		//응찰자 경매전
		if("1".equals(map.get("obj_gbn")) && "01".equals(map.get("msg_gbn"))){
			list = lalm0899Mapper.LALM0899_selMca3100_101(map);
		//응찰자 경매후 - 낙찰평균
		}else if("1".equals(map.get("obj_gbn")) && "02".equals(map.get("msg_gbn"))) {
			list = lalm0899Mapper.LALM0899_selMca3100_102(map);
		//응찰자 경매후 - 최고/최저
		}else if("1".equals(map.get("obj_gbn")) && "03".equals(map.get("msg_gbn"))) {
			list = lalm0899Mapper.LALM0899_selMca3100_103(map);
	    //출하자 경매전
		}else if("2".equals(map.get("obj_gbn")) && "01".equals(map.get("msg_gbn"))) {
			if(!"8808990659008".equals(map.get("ss_na_bzplc"))) {
				list = lalm0899Mapper.LALM0899_selMca3100_201(map);
			}else {
				list = lalm0899Mapper.LALM0899_selMca3100_201_9008(map);
			}
		//출하자 경매후
		}else if("2".equals(map.get("obj_gbn")) && "02".equals(map.get("msg_gbn"))) {
			list = lalm0899Mapper.LALM0899_selMca3100_202(map);
		//구미칠곡
		}else if("1".equals(map.get("obj_gbn")) && "04".equals(map.get("msg_gbn"))) {
			list = lalm0899Mapper.LALM0899_selMca3100_104(map);
		}
		
		return list;
	}	

}
