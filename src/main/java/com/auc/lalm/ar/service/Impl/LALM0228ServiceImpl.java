package com.auc.lalm.ar.service.Impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.lalm.ar.service.LALM0228Service;
import com.auc.lalm.sy.service.Impl.LALM0840Mapper;
import com.auc.lalm.sy.service.Impl.LALM0899Mapper;
import com.auc.mca.AlarmTalkForm;

@Service("LALM0228Service")
public class LALM0228ServiceImpl implements LALM0228Service{

	@Autowired
	LALM0899Mapper lalm0899Mapper;
	
	@Autowired
	LALM0840Mapper lalm0840Mapper;
	
	@Autowired
	LALM0228Mapper lalm0228Mapper;
	
	@Autowired
	AlarmTalkForm alarmForm;
	
	@Override
	public List<Map<String, Object>> LALM0228_selAlarmList(Map<String, Object> map) throws Exception {
		int cntSize = 0;
		// 발송대상자 조회
		String templateId = "";
		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> tempMap = new HashMap<>();

		List<Map<String, Object>> cntList  = lalm0228Mapper.LALM0228_selCntList(map);
		cntSize = cntList.size();
		if (cntSize > 0) {
			if("1".equals(map.get("obj_gbn")) && "01".equals(map.get("msg_gbn"))) {
				// 응찰자 경매전
				list = lalm0228Mapper.LALM0228_selList2(map);
				for (Map<String, Object> item : list) {
					item.put("MSG", " 출장우 예정 현황을 ");
					for(Map<String,Object> cntItem:cntList) {
						//Map<String, Object> cntItem = it.next();
						StringBuffer sb = new StringBuffer();
						sb.append("총 "+cntItem.get("TOT_CNT")+"두 (암 "+cntItem.get("SEX_W_CNT")+"두, 수 "+cntItem.get("SEX_M_CNT")+"두)");
						item.put("COW_INFO"+cntSize, sb.toString());
					}
					if(cntSize == 1) {					
						templateId = "NHKKO00249";
					}else if(cntSize == 2) {
						templateId = "NHKKO00250";
					}else if(cntSize == 3) {
						templateId = "NHKKO00251";
					}else {
						templateId = "NHKKO00249";
					}
					map.put("code", templateId);
					tempMap = lalm0840Mapper.LALM0840_selInfo(map);
					
					item.put("MSG_CNTN", alarmForm.makeAlarmMsgCntn(item, tempMap.get("TALK_CONTENT").toString()));	
					item.put("SEND_MSG_CNTN", alarmForm.getAlarmTalkTemplateToJson(templateId, item));
					item.put("KAKAO_TPL_C", templateId);
				}
			} else if("1".equals(map.get("obj_gbn")) && ("05".equals(map.get("msg_gbn")) || "06".equals(map.get("msg_gbn")))){
				list = lalm0228Mapper.LALM0228_selList3(map);
				for (Map<String, Object> item : list) {
					item.put("MSG", " 정산금액을 ");
					item.put("COW_INFO1", "낙찰두수 : "+item.get("TOT_CNT")+"두");
					item.put("COW_INFO2", "총낙찰금액 : "+item.get("TOT_SRA_SBID_AM").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"원");
					item.put("COW_INFO3", "총수수료 : "+item.get("TOT_SRA_TR_FEE").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"원");
					item.put("COW_INFO4", "총납입할 금액 : "+item.get("TOT_AM").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"원");
					item.put("COW_INFO5", "계좌번호 : "+item.get("BANK_NM")+", "+item.get("ACNO"));
					
					if ("05".equals(map.get("msg_gbn"))) {
						templateId = "NHKKO00253";
					} else {
						templateId = "NHKKO00259";
						//버튼 파라메터 
						item.put("BTN_NM", "정산서 보기");
						//[TO-DO] URL 적용..(파라메터 적용)
						item.put("BTN_URL", "");
					}
					map.put("code", templateId);
					tempMap = lalm0840Mapper.LALM0840_selInfo(map);
					
					item.put("MSG_CNTN", alarmForm.makeAlarmMsgCntn(item, tempMap.get("TALK_CONTENT").toString()));	
					item.put("SEND_MSG_CNTN", alarmForm.getAlarmTalkTemplateToJson(templateId, item));
				}
			} else if("2".equals(map.get("obj_gbn")) && "03".equals(map.get("msg_gbn"))){
				list = lalm0228Mapper.LALM0228_selList4(map);
				
				templateId = "NHKKO00259";
				map.put("code", templateId);
				tempMap = lalm0840Mapper.LALM0840_selInfo(map);
				for (Map<String, Object> item : list) {
					//템플릿 파라메터
					item.put("MSG", " 출하주 정산금액을  ");
					item.put("COW_INFO1", "출하두수 : "+item.get("TOT_CNT")+"두(낙찰:"+ item.get("TOT_CNT_NAK")+"두, 유찰:"+item.get("TOT_CNT_YOU")+"두)");
					item.put("COW_INFO2", "총낙찰금액 : "+item.get("TOT_SRA_SBID_AM").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"원");
					item.put("COW_INFO3", "총수수료 : "+item.get("TOT_SRA_TR_FEE").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"원");
					item.put("COW_INFO4", "받으실 금액 : "+item.get("TOT_AM").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"원");
					item.put("COW_INFO5", "계좌번호 : "+item.get("BANK_NM")+", "+item.get("ACNO"));
					
					//버튼 파라메터 
					item.put("BTN_NM", "정산서 보기");
					//[TO-DO] URL 적용..(파라메터 적용)
					item.put("BTN_URL", "");
					
					item.put("MSG_CNTN", alarmForm.makeAlarmMsgCntn(item, tempMap.get("TALK_CONTENT").toString()));	
					item.put("SEND_MSG_CNTN", alarmForm.getAlarmTalkTemplateToJson(templateId, item));
				}
				
			} else {
				list = lalm0228Mapper.LALM0228_selList(map);
				for (Map<String, Object> item : list) {
					//응찰자
					if("1".equals(map.get("obj_gbn"))) {
						if("02".equals(map.get("msg_gbn"))) {
							//경매후 - 낙찰평균
							item.put("MSG", " 낙찰 평균을 ");
							for(Map<String,Object> cntItem:cntList) {
								StringBuffer sb = new StringBuffer();
								sb.append(cntItem.get("AUC_OBJ_DSC_NAME")+" : 총 "+cntItem.get("TOT_CNT")+"두 평균 : "+cntItem.get("AVG_SRA_SBID_AM").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+cntItem.get("UNIT"));
								sb.append(" (암 "+cntItem.get("SEX_W_CNT")+"두 평균 : "+cntItem.get("AVG_SRA_SBID_AM_M").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+cntItem.get("UNIT"));
								sb.append(", 수 "+cntItem.get("SEX_M_CNT")+"두 평균 : "+cntItem.get("AVG_SRA_SBID_AM_W").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+cntItem.get("UNIT")+")");
								item.put("COW_INFO"+cntSize, sb.toString());
							}
							if(cntSize == 1) {
								templateId = "NHKKO00249";	
							}else if(cntSize == 2) {
								templateId = "NHKKO00250";
							}else if(cntSize == 3) {
								templateId = "NHKKO00251";
							}else {
								templateId = "NHKKO00249";	
							}
							
							map.put("code", templateId);
							tempMap = lalm0840Mapper.LALM0840_selInfo(map);
							item.put("MSG_CNTN", alarmForm.makeAlarmMsgCntn(item, tempMap.get("TALK_CONTENT").toString()));	
							item.put("SEND_MSG_CNTN", alarmForm.getAlarmTalkTemplateToJson(templateId, item));
							
						}else if("03".equals(map.get("msg_gbn"))) {
							//경매후 - 최고,최저
							item.put("MSG", " 낙찰 최고,최저 금액을 ");
							for(Map<String,Object> cntItem:cntList) {
								StringBuffer sb = new StringBuffer();
								sb.append(""+cntItem.get("AUC_OBJ_DSC_NAME")+" : ");
								sb.append(" 암 ( 최저 : "+cntItem.get("MIN_SRA_SBID_AM_W").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+cntItem.get("UNIT")+", 최고 : "+cntItem.get("MAX_SRA_SBID_AM_W").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+cntItem.get("UNIT")+")");
								sb.append(" ,수 ( 최저 : "+cntItem.get("MIN_SRA_SBID_AM_M").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+cntItem.get("UNIT")+", 최고 : "+cntItem.get("MAX_SRA_SBID_AM_M").toString().replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+cntItem.get("UNIT")+")");
								item.put("COW_INFO"+cntSize, sb.toString());
							}				
							if(cntSize == 1) {
								templateId = "NHKKO00249";	
							}else if(cntSize == 2) {
								templateId = "NHKKO00250";
							}else if(cntSize == 3) {
								templateId = "NHKKO00251";
							}else{
								templateId = "NHKKO00249";	
							}
							map.put("code", templateId);
							tempMap = lalm0840Mapper.LALM0840_selInfo(map);
							item.put("MSG_CNTN", alarmForm.makeAlarmMsgCntn(item, tempMap.get("TALK_CONTENT").toString()));	
							item.put("SEND_MSG_CNTN", alarmForm.getAlarmTalkTemplateToJson(templateId, item));
						}
					}else {
						if("01".equals(map.get("msg_gbn"))) {
							//경매전 천단위 콤마
							item.put("MSG", " 신청한 예정가를 ");
							item.put("COW_INFO1", "경매번호 : "+item.get("AUC_PRG_SQ")+"번");
							item.put("COW_INFO2", "등록구분 : "+item.get("AUC_OBJ_DSC_NM")+"("+item.get("INDV_SEX_C_NM")+")");
							item.put("COW_INFO3", "개체번호 : "+item.get("SRA_INDV_AMNNO_FORMAT"));
							item.put("COW_INFO4", "예정가 : "+item.get("LOWS_SBID_LMT_AM_FORMAT")+"원");
							templateId = "NHKKO00252";
						}else if("02".equals(map.get("msg_gbn"))) {
							//경매후 - 낙/유찰 전송 천단위 콤마
							item.put("MSG", " 낙찰내역을 ");
							item.put("COW_INFO1", "경매번호 : "+item.get("AUC_PRG_SQ")+"번");
							item.put("COW_INFO2", "등록구분 : "+item.get("AUC_OBJ_DSC_NM")+"("+item.get("INDV_SEX_C_NM")+")");
							item.put("COW_INFO3", "개체번호 : "+item.get("SRA_INDV_AMNNO_FORMAT"));
							item.put("COW_INFO4", "낙찰금액 : "+item.get("SRA_SBID_AM_FORMAT")+"원");
							templateId = "NHKKO00252";
						}
						map.put("code", templateId);
						tempMap = lalm0840Mapper.LALM0840_selInfo(map);
						item.put("MSG_CNTN", alarmForm.makeAlarmMsgCntn(item, tempMap.get("TALK_CONTENT").toString()));	
						item.put("SEND_MSG_CNTN", alarmForm.getAlarmTalkTemplateToJson(templateId, item));
						item.put("KAKAO_TPL_C", templateId);
					}
				}
			}
		}
			
		return list;
	}
}
