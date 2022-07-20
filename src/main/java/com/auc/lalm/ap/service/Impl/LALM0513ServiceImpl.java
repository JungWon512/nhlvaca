package com.auc.lalm.ap.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ap.service.LALM0513Service;

@Service("LALM0513Service")
public class LALM0513ServiceImpl implements LALM0513Service{

	@Autowired
	LALM0513Mapper lalm0513Mapper;
	
	
	
	@Override
	public List<Map<String, Object>> LALM0513_selMhFeeImps(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selMhFeeImps(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selMhAucQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selMhAucQcn(map);
		
		if(list.size() == 0) {
			map.put("auc_obj_dsc", "0");
			list = lalm0513Mapper.LALM0513_selMhAucQcn(map);
		}
		
		return list;
		
	}

	@Override
	public List<Map<String, Object>> LALM0513_selList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_2(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_2(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_3(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_3(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_4(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_4(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_5(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_5(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selSubList_5(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selSubList_5(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_6(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_6(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_7(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_7(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_8(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_8(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selSubList_8(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selSubList_8(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_9(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;
		List<Map<String, Object>> mhFeeImpsList = null;
		
		mhFeeImpsList = lalm0513Mapper.LALM0513_selMhFeeImps(map);
		
		if(mhFeeImpsList.get(0) != null) {
			map.put("fhs_sra_ubd_fee", mhFeeImpsList.get(0).get("FHS_SRA_UBD_FEE"));
		} else {
			map.put("fhs_sra_ubd_fee", "0");
		}
		
		list = lalm0513Mapper.LALM0513_selList_9(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_10(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_10(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_11(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_11(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_11_print(Map<String, Object> map) throws Exception {

		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_11_print(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_12(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_12(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_13(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_13(map);
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_14(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		
		String tmpFeeAplObjC = map.get("fee_apl_obj_c").toString();
		
		if(tmpFeeAplObjC.equals("1")) {
			list = lalm0513Mapper.LALM0513_selList_14_IsMmFhs(map);
		} else if(tmpFeeAplObjC.equals("2")) {
			list = lalm0513Mapper.LALM0513_selList_14_IsMmMwmn(map);
		}
		
		return list;
		
	}
	
	@Override
	public List<Map<String, Object>> LALM0513_selList_15(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = lalm0513Mapper.LALM0513_selList_15(map);
		return list;
		
	}


}
