package com.auc.lalm.sy.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.config.ConvertConfig;
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.main.service.CommonService;

@Service("LALM0899Service")
public class LALM0899ServiceImpl implements LALM0899Service{

	private static Logger log = LoggerFactory.getLogger(LALM0899ServiceImpl.class);
	@Autowired
	LALM0899Mapper lalm0899Mapper;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	ConvertConfig convertConfig;

	@Override
	public Map<String, Object> LALM0899_selMca1300(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca1300(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca1600(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca1600(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca1900(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca1900(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca2000(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca2000(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca2100(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca2100(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca2700(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca2700(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3100(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
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
		}else if("2".equals(map.get("obj_gbn")) && "03".equals(map.get("msg_gbn"))) {
			list = lalm0899Mapper.LALM0899_selMca3100_201_Recv(map);
		//구미칠곡
		}else if("1".equals(map.get("obj_gbn")) && "04".equals(map.get("msg_gbn"))) {
			list = lalm0899Mapper.LALM0899_selMca3100_104(map);
		}
		
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3500(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca3500(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3700(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca3700(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3800(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca3800(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3900(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca3900(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca4000(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca4000(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public int LALM0899_selMca1600_ChkAmnno(Map<String, Object> map) throws Exception {
		int chk_amnno = lalm0899Mapper.LALM0899_selMca1600_ChkAmnno(map);
		return chk_amnno;
	}

	@Override
	public int LALM0899_selMca1600_ChkAucObjDsc(Map<String, Object> map) throws Exception {
		int chk_amnno = lalm0899Mapper.LALM0899_selMca1600_ChkAucObjDsc(map);
		return chk_amnno;
	}

	@Override
	public Map<String, Object> LALM0899_selMca1600Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = lalm0899Mapper.LALM0899_selMca1600Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3900Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = lalm0899Mapper.LALM0899_selMca3900Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3700Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = lalm0899Mapper.LALM0899_selMca3700Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public int LALM0899_insMca1200(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;
		int deleteNum = 0;
		int updateNum = 0;
		String fhs_id_no = "";
		int chk_fhsIdNo = 0;
		
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));
						
			fhs_id_no = ((String) inMap.get("FHS_ID_NO")).substring(0, 1);
			//합천축협이 아닐경우 and 정상농가(한우종합)일 경우
//			if(!"T".equals(fhs_id_no) && !"N".equals(fhs_id_no) && "8808990656236".equals(map.get("ss_na_bzplc"))) {
//				deleteNum += lalm0899Mapper.LALM0899_delMca1200(inMap);
//				insertNum += lalm0899Mapper.LALM0899_insMca1200(inMap);
			//합천축협일경우 or 수기농가일경우
//			}else {
			
			//TODO : 농가를 아예 통합회원에서 제거하게 되면 수정 or 제거해야 할 부분
			//농가정보 수신 시, 통합회원정보 생성하기
			Map <String, Object> lowerMap = new HashMap<String, Object>();
			lowerMap =  convertConfig.changeKeyLower(inMap);
			lowerMap.put("mb_intg_gb", "02");
			lowerMap.put("sra_fhs_id_no", inMap.get("FHS_ID_NO"));
			lowerMap.put("ss_eno", inMap.get("ss_userid"));
			commonService.Common_insMbintgInfo(lowerMap);
			
			inMap.put("mb_intg_no", lowerMap.get("mb_intg_no"));
			chk_fhsIdNo = lalm0899Mapper.LALM0899_selMca1200_fhsIdNo(inMap);

			//조합코드, 농가식별코드, 농장관리번호로 조회된 데이터가 있으면 update, 없으면 insert
			if(chk_fhsIdNo > 0) {		
				updateNum += lalm0899Mapper.LALM0899_updMca1200(inMap);
			}else {
				//휴면복구할 데이터가 있는 경우, 농가 INSERT 하지 않아도 됨, 위 메소드 내부에서 처리함
				if ("0".equals(inMap.getOrDefault("cur_dorm_cnt", "0"))) {
					insertNum += lalm0899Mapper.LALM0899_insMca1200_2(inMap);
				}
			}
			
//			}
		}		
		return insertNum;
	}

	@Override
	public int LALM0899_insMca1400(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;		
		int deleteNum = 0;
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));
						
			deleteNum += lalm0899Mapper.LALM0899_delMca1400(inMap);
			insertNum += lalm0899Mapper.LALM0899_insMca1400(inMap);
		}		
		return insertNum;
	}

	@Override
	public int LALM0899_insMca1500(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;		
		int deleteNum = 0;
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));
			
			if(!"".equals(((String)inMap.get("VHC_SHRT_C")).trim())) {
				deleteNum += lalm0899Mapper.LALM0899_delMca1500(inMap);
				insertNum += lalm0899Mapper.LALM0899_insMca1500(inMap);
			}
			
		}		
		return insertNum;
	}

	@Override
	public int LALM0899_insMca3300(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;		
		int deleteNum = 0;
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));	
			
			deleteNum += lalm0899Mapper.LALM0899_delMca3300(inMap);
			insertNum += lalm0899Mapper.LALM0899_insMca3300(inMap);
			
		}		
		return insertNum;
	}

	@Override
	public int LALM0899_insMca1700(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;		
		int deleteNum = 0;
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));	
			
			if(!"".equals(((String)inMap.get("APL_DT")).trim()) &&  !"".equals(((String)inMap.get("AUC_OBJ_DSC")).trim())
			   && !"".equals(((String)inMap.get("FEE_RG_SQNO")).trim())) { 
				
				deleteNum += lalm0899Mapper.LALM0899_delMca1700(inMap);
				insertNum += lalm0899Mapper.LALM0899_insMca1700(inMap);
			}
			
		}		
		return insertNum;
	}

	@Override
	public int LALM0899_insMca1800(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;		
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));
			
			insertNum += lalm0899Mapper.LALM0899_insMca1800(inMap);
			
		}		
		return insertNum;
	}

	@Override
	public int LALM0899_insMca3400(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;		
		int deleteNum = 0;
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));
			
			deleteNum += lalm0899Mapper.LALM0899_delMca3400(inMap);
			insertNum += lalm0899Mapper.LALM0899_insMca3400(inMap);
			
		}		
		return insertNum;
	}

	@Override
	public int LALM0899_insMca2500(List<Map<String, Object>> jsonList, Map<String, Object> map) throws Exception {
		
		Map<String, Object> inMap = null;		
		int insertNum = 0;
		int deleteNum = 0;
		
		for(int i = 0; i < jsonList.size(); i++) {
			inMap = jsonList.get(i);	
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));		
			deleteNum += lalm0899Mapper.LALM0899_delMca2500(inMap);
			insertNum += lalm0899Mapper.LALM0899_insMca2500(inMap);				
		}		
		return insertNum;
	}

	@Override
	public Map<String, Object> LALM0899_selMca1300Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = 0;
		totCnt = lalm0899Mapper.LALM0899_selMca1300Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca1900Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = 0;
		totCnt = lalm0899Mapper.LALM0899_selMca1900Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca2000Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = 0;
		totCnt = lalm0899Mapper.LALM0899_selMca2000Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca2700Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = 0;
		totCnt = lalm0899Mapper.LALM0899_selMca2700Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3500Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = 0;
		totCnt = lalm0899Mapper.LALM0899_selMca3500Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca2100Cnt(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = 0;
		totCnt = lalm0899Mapper.LALM0899_selMca2100Cnt(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca1300Cnt_A(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		int totCnt = 0;
		totCnt = lalm0899Mapper.LALM0899_selMca1300Cnt_A(map);
		reMap.put("totCnt", totCnt);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca1300_A(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = lalm0899Mapper.LALM0899_selMca1300_A(map);
		reMap.put("INQ_CN", ""+list.size());
		reMap.put("RPT_DATA", list);
		return reMap;
	}

	@Override
	public Map<String, Object> LALM0899_selMca3000(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = null;
		reMap = lalm0899Mapper.LALM0899_selMca3000(map);
		return reMap;
	}

	@Override
	public int LALM0899_insMca3100(Map<String, Object> msgMap) throws Exception {
		int msgInsCnt = 0;
		msgInsCnt = lalm0899Mapper.LALM0899_insMca3100(msgMap);
		return msgInsCnt;
	}

	@Override
	public int LALM0899_delMca1800(Map<String, Object> map) throws Exception {
		int deleteNum = 0;
		deleteNum = lalm0899Mapper.LALM0899_delMca1800(map);
		return deleteNum;
	}
	
	@Override
	public int LALM0899_insMca4600(List<Map<String, Object>> list,Map<String, Object> map) throws Exception{		
		int insertNum = 0;
		for(Map<String, Object> inMap : list) {
			inMap.put("ss_na_bzplc", (String)map.get("ss_na_bzplc"));
			inMap.put("ss_userid", (String)map.get("ss_userid"));
						
			lalm0899Mapper.LALM0899_delMca1400(inMap);
			insertNum += lalm0899Mapper.LALM0899_insMca4600(inMap);
		}		
		return insertNum;		
	}

	@Override
	public Map<String, Object> LALM0899_selMca5100AlarmTalkId(Map<String, Object> map) throws Exception {
		Map<String, Object> reMap = new HashMap<String, Object>();
		reMap = lalm0899Mapper.LALM0899_selMca5100AlarmTalkId(map);
		return reMap;
	}
}
