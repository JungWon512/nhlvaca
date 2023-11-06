package com.auc.mca;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.auc.common.util.StringUtils;

@Controller
public class TradeMcaMsgDataController {

	private static Logger log = LoggerFactory.getLogger(TradeMcaMsgDataController.class);
	@Autowired
    RestApiJsonController rest;
	
	public Map<String, Object> tradeMcaMsg(String ctgrm_cd, Map<String, Object> paraMap) throws Exception{
		
		log.info(" ################# TradeMcaMsgDataController :tradeMcaMsg() START #################");
		
		Map<String, Object> sb = new HashMap<String, Object>();
		
//		String in_sqno = "1";//시작번호
//      String in_rec_cn = "1";//조회건수
        
        SimpleDateFormat dd = new SimpleDateFormat("yyyyMMdd");
        Date now = new Date();
        String time =  dd.format(now);//현재날짜
        
        StringBuffer data = new StringBuffer();
        
        //전문 중 data 내용 만들기
        //농가정보 수신
        if("1200".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""    + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"), 4) + "\"");
            data.append(",\"NA_BZPLC\":\""  + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
            data.append(",\"INQ_ST_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
            data.append(",\"INQ_ED_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        //중도매인정보 전송
        }else if("1300".equals(ctgrm_cd)){
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{");
	        	data.append("\"NA_BZPLC\":\""           + padLeftBlank((String)inMap.get("NA_BZPLC"), 13)           + "\"");
	            data.append(",\"TRMN_AMNNO\":\""         + padLeftBlank(String.valueOf(inMap.get("TRMN_AMNNO")), 8) + "\"");
	            data.append(",\"MWMN_NA_TRPL_C\":\""     + padLeftBlank((String)inMap.get("MWMN_NA_TRPL_C"),13)     + "\"");
	            data.append(",\"SRA_MWMNNM\":\""         + padLeftBlank((String)inMap.get("SRA_MWMNNM"),50)         + "\"");
	            data.append(",\"FRLNO\":\""              + padLeftBlank((String)inMap.get("FRLNO"),6)               + "\"");
	            data.append(",\"ZIP\":\""                + padLeftBlank((String)inMap.get("ZIP"),6)                 + "\"");
	            data.append(",\"DONGUP\":\""             + padLeftBlank((String)inMap.get("DONGUP"),80)             + "\"");
	            data.append(",\"DONGBW\":\""             + padLeftBlank((String)inMap.get("DONGBW"),100)            + "\"");
	            data.append(",\"OHSE_TELNO\":\""         + padLeftBlank((String)inMap.get("OHSE_TELNO"),14)         + "\"");
	            data.append(",\"CUS_MPNO\":\""           + padLeftBlank((String)inMap.get("CUS_MPNO"),14)           + "\"");
	            data.append(",\"MACO_YN\":\""            + padLeftBlank((String)inMap.get("MACO_YN"),1)             + "\"");
	            data.append(",\"JRDWO_DSC\":\""          + padLeftBlank((String)inMap.get("JRDWO_DSC"),1)           + "\"");
	            data.append(",\"PSN_INF_OFR_AGR_YN\":\"" + padLeftBlank((String)inMap.get("PSN_INF_OFR_AGR_YN"),1)  + "\"");
	            data.append(",\"DEL_YN\":\""             + padLeftBlank((String)inMap.get("DEL_YN"),1)              + "\"");
	            //20221118 스마트가축시장 고도화 inf 항목 추가
	            data.append(",\"MB_INTG_NO\":\""          + padLeftBlank(""+inMap.get("MB_INTG_NO"),8)              + "\"");
	            //20230816 축산경제통합 CUS_RLNO 누락으로 인한 항목추가
	            data.append(",\"CUS_RLNO\":\""          + padLeftBlank(""+inMap.get("CUS_RLNO2"),13)              + "\"");
	            if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
            data.append("]");
        //개체정보 수신
        }else if("1400".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""             + padLeftZero((String)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\""          + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
            data.append(",\"NA_BZPLC\":\""           + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
            data.append(",\"INQ_ST_DT\":\""          + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
            data.append(",\"INQ_ED_DT\":\""          + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        //수송자정보
        }else if("1500".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""             + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\""          + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
            data.append(",\"NA_BZPLC\":\""           + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
        //출장우정보
        }else if("1600".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
    			    			
        	    data.append("{");        	    
        	    data.append("\"NA_BZPLC\":\""               + padLeftBlank((String)inMap.get("NA_BZPLC"),13)                       + "\"");
            	data.append(",\"AUC_OBJ_DSC\":\""           + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1)                     + "\"");
            	data.append(",\"AUC_DT\":\""                + padLeftBlank((String)inMap.get("AUC_DT"),8)                          + "\"");
            	data.append(",\"OSLP_NO\":\""               + padLeftBlank(String.valueOf((String)inMap.get("OSLP_NO")),10)        + "\"");
            	data.append(",\"LED_SQNO\":\""              + padLeftBlank((String)inMap.get("LED_SQNO"),5)                        + "\"");
            	data.append(",\"FHS_ID_NO\":\""             + padLeftBlank((String)inMap.get("FHS_ID_NO"),10)                      + "\"");
            	data.append(",\"FARM_AMNNO\":\""            + padLeftBlank(String.valueOf((String)inMap.get("FARM_AMNNO")),8)      + "\"");
            	data.append(",\"SOG_NA_TRPL_C\":\""         + padLeftBlank((String)inMap.get("SOG_NA_TRPL_C"),13)                  + "\"");
            	data.append(",\"VHC_SHRT_C\":\""            + padLeftBlank((String)inMap.get("VHC_SHRT_C"),6)                      + "\"");
            	data.append(",\"RC_DT\":\""                 + padLeftBlank((String)inMap.get("RC_DT"),8)                           + "\"");
            	data.append(",\"TRMN_AMNNO\":\""            + padLeftBlank((String)inMap.get("TRMN_AMNNO"),8)      + "\"");
            	data.append(",\"LVST_AUC_PTC_MN_NO\":\""    + padLeftBlank((String)inMap.get("LVST_AUC_PTC_MN_NO"),13)             + "\"");
            	data.append(",\"SRA_SRS_DSC\":\""           + padLeftBlank((String)inMap.get("SRA_SRS_DSC"),2)                     + "\"");
            	data.append(",\"SRA_INDV_AMNNO\":\""        + padLeftBlank(String.valueOf((String)inMap.get("SRA_INDV_AMNNO")),20) + "\"");
            	data.append(",\"COW_SOG_WT\":\""            + padLeftZero((String)inMap.get("COW_SOG_WT"),15)            + "\"");
            	data.append(",\"FIR_LOWS_SBID_LMT_AM\":\""  + padLeftZero((String)inMap.get("FIR_LOWS_SBID_LMT_AM"),15)  + "\"");
            	data.append(",\"LOWS_SBID_LMT_AM\":\""      + padLeftZero((String)inMap.get("LOWS_SBID_LMT_AM"),15)      + "\"");
            	data.append(",\"SRA_SBID_UPR\":\""          + padLeftZero((String)inMap.get("SRA_SBID_UPR"),15)          + "\"");
            	data.append(",\"SRA_SBID_AM\":\""           + padLeftZero((String)inMap.get("SRA_SBID_AM"),15)           + "\"");
            	data.append(",\"SEL_STS_DSC\":\""           + padLeftBlank((String)inMap.get("SEL_STS_DSC"),2)           + "\"");
            	data.append(",\"BRCL_ISP_CTFW_SMT_YN\":\""  + padLeftBlank((String)inMap.get("BRCL_ISP_CTFW_SMT_YN"),1)  + "\"");
            	data.append(",\"BRCL_ISP_DT\":\""           + padLeftBlank((String)inMap.get("BRCL_ISP_DT"),8)           + "\"");
            	data.append(",\"LWPR_CHG_NT\":\""           + padLeftZero((String)inMap.get("LWPR_CHG_NT"),15)           + "\"");
            	data.append(",\"VACN_DT\":\""               + padLeftBlank((String)inMap.get("VACN_DT"),8)               + "\"");
            	data.append(",\"LVST_MKT_TRPL_AMNNO\":\""   + padLeftBlank((String)inMap.get("LVST_MKT_TRPL_AMNNO"),8)   + "\"");
            	data.append(",\"MT12_OVR_YN\":\""           + padLeftBlank((String)inMap.get("MT12_OVR_YN"),1)           + "\"");
            	data.append(",\"PPGCOW_FEE_DSC\":\""        + padLeftBlank((String)inMap.get("PPGCOW_FEE_DSC"),1)        + "\"");
            	data.append(",\"PRNY_JUG_YN\":\""           + padLeftBlank((String)inMap.get("PRNY_JUG_YN"),1)           + "\"");
            	data.append(",\"PRNY_YN\":\""               + padLeftBlank((String)inMap.get("PRNY_YN"),1)               + "\"");
            	data.append(",\"NCSS_JUG_YN\":\""           + padLeftBlank((String)inMap.get("NCSS_JUG_YN"),1)           + "\"");
            	data.append(",\"NCSS_YN\":\""               + padLeftBlank((String)inMap.get("NCSS_YN"),1)               + "\"");
            	data.append(",\"TRPCS_PY_YN\":\""           + padLeftBlank((String)inMap.get("TRPCS_PY_YN"),1)           + "\"");
            	data.append(",\"SRA_TRPCS\":\""             + padLeftZero((String)inMap.get("SRA_TRPCS"),15)             + "\"");
            	data.append(",\"SRA_PYIVA\":\""             + padLeftZero((String)inMap.get("SRA_PYIVA"),15)             + "\"");
            	data.append(",\"SRA_FED_SPY_AM\":\""        + padLeftZero((String)inMap.get("SRA_FED_SPY_AM"),15)        + "\"");
            	data.append(",\"TD_RC_CST\":\""             + padLeftZero((String)inMap.get("TD_RC_CST"),15)             + "\"");
            	data.append(",\"MT12_OVR_FEE\":\""          + padLeftZero((String)inMap.get("MT12_OVR_FEE"),15)          + "\"");
            	data.append(",\"AFISM_MOD_DT\":\""          + padLeftBlank((String)inMap.get("AFISM_MOD_DT"),8)          + "\"");
            	data.append(",\"PRNY_MTCN\":\""             + padLeftZero((String)inMap.get("PRNY_MTCN"),15)             + "\"");
            	data.append(",\"AFISM_MOD_CTFW_SMT_YN\":\"" + padLeftBlank((String)inMap.get("AFISM_MOD_CTFW_SMT_YN"),1) + "\"");
            	data.append(",\"RMHN_YN\":\""               + padLeftBlank((String)inMap.get("RMHN_YN"),1)               + "\"");
            	data.append(",\"SRA_PDMNM\":\""             + padLeftBlank((String)inMap.get("SRA_PDMNM"),50)            + "\"");
            	data.append(",\"SRA_PD_RGNNM\":\""          + padLeftBlank((String)inMap.get("SRA_PD_RGNNM"),50)         + "\"");
            	data.append(",\"RMK_CNTN\":\""              + padLeftBlank((String)inMap.get("RMK_CNTN"),200)            + "\"");
            	data.append(",\"AUC_PRG_SQ\":\""            + padLeftZero((String)inMap.get("AUC_PRG_SQ"),7)             + "\"");
            	data.append(",\"NA_CRC_CAN_DSC\":\""        + padLeftBlank((String)inMap.get("NA_CRC_CAN_DSC"),1)        + "\"");
            	data.append(",\"SOGMN_RMT_DRUP_YN\":\""     + padLeftBlank((String)inMap.get("SOGMN_RMT_DRUP_YN"),1)     + "\"");
            	data.append(",\"BF_SOGMN_RMT_DRUP_YN\":\""  + padLeftBlank((String)inMap.get("BF_SOGMN_RMT_DRUP_YN"),1)  + "\"");
            	data.append(",\"SOGMN_C\":\""               + padLeftBlank((String)inMap.get("SOGMN_C"),20)              + "\"");
            	data.append(",\"FSRG_DTM\":\""              + padLeftBlank((String)inMap.get("FSRG_DTM"),14)             + "\"");
            	data.append(",\"FSRGMN_ENO\":\""            + padLeftBlank((String)inMap.get("FSRGMN_ENO"),9)            + "\"");
            	data.append(",\"LSCHG_DTM\":\""             + padLeftBlank((String)inMap.get("LSCHG_DTM"),14)            + "\"");
            	data.append(",\"LS_CMENO\":\""              + padLeftBlank((String)inMap.get("LS_CMENO"),9)              + "\"");
            	//20221118 스마트가축시장 고도화 inf 항목 추가
            	data.append(",\"BDLN_VAL\":\""              + padLeftBlank(""+(BigDecimal)inMap.get("BDLN_VAL"),8)              + "\"");
            	data.append(",\"BDHT_VAL\":\""              + padLeftBlank(""+(BigDecimal)inMap.get("BDHT_VAL"),8)              + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //수수료정보
        }else if("1700".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""    + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
            data.append(",\"NA_BZPLC\":\""  + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
            data.append(",\"INQ_ST_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
            data.append(",\"INQ_ED_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        //불량거래인정보
        }else if("1800".equals(ctgrm_cd)) {
            data.append("\"NA_BZPLC\":\""   + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
            data.append(",\"INQ_ST_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
            data.append(",\"INQ_ED_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        //경매차수정보
        }else if("1900".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{"); 
        	    data.append("\"NA_BZPLC\":\""      + padLeftBlank((String)inMap.get("NA_BZPLC"),13)    + "\"");
            	data.append(",\"AUC_OBJ_DSC\":\""  + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1)  + "\"");
            	data.append(",\"AUC_DT\":\""       + padLeftBlank((String)inMap.get("AUC_DT"),8)       + "\"");
            	data.append(",\"QCN\":\""          + padLeftBlank((String)inMap.get("QCN"),9)          + "\"");
            	data.append(",\"BASE_LMT_AM\":\""  + padLeftZero((String)inMap.get("BASE_LMT_AM"),15)  + "\"");
            	data.append(",\"CUT_AM\":\""       + padLeftZero((String)inMap.get("CUT_AM"),15)       + "\"");
            	data.append(",\"SGNO_PRC_DSC\":\"" + padLeftBlank((String)inMap.get("SGNO_PRC_DSC"),1) + "\"");
            	data.append(",\"DDL_YN\":\""       + padLeftBlank((String)inMap.get("DDL_YN"),1)       + "\"");
            	data.append(",\"DEL_YN\":\""       + padLeftBlank((String)inMap.get("DEL_YN"),1)       + "\"");
            	data.append(",\"TT_SCR\":\""       + padLeftZero((String)inMap.get("TT_SCR"),7)        + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //중도매인입금정보
        }else if("2000".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{"); 
        	    data.append("\"NA_BZPLC\":\""     + padLeftBlank((String)inMap.get("NA_BZPLC"),13)   + "\"");
            	data.append(",\"TRMN_AMNNO\":\""  + padLeftZero((String)inMap.get("TRMN_AMNNO"),8)  + "\"");
            	data.append(",\"AUC_OBJ_DSC\":\"" + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1) + "\"");
            	data.append(",\"AUC_DT\":\""      + padLeftBlank((String)inMap.get("AUC_DT"),8)      + "\"");
            	data.append(",\"RV_SQNO\":\""     + padLeftBlank((String)inMap.get("RV_SQNO"),5)     + "\"");
            	data.append(",\"RV_DT\":\""       + padLeftBlank((String)inMap.get("RV_DT"),8)       + "\"");
            	data.append(",\"SRA_RV_TPC\":\""  + padLeftBlank((String)inMap.get("SRA_RV_TPC"),1)  + "\"");
            	data.append(",\"SRA_RV_AM\":\""   + padLeftZero((String)inMap.get("SRA_RV_AM"),15)   + "\"");
            	data.append(",\"RMK_CNTN\":\""    + padLeftBlank((String)inMap.get("RMK_CNTN"),200)  + "\"");
            	data.append(",\"DEL_YN\":\""      + padLeftBlank((String)inMap.get("DEL_YN"),1)      + "\"");
            	data.append(",\"FSRG_DTM\":\""    + padLeftBlank((String)inMap.get("FSRG_DTM"),14)   + "\"");
            	data.append(",\"FSRGMN_ENO\":\""  + padLeftBlank((String)inMap.get("FSRGMN_ENO"),9)  + "\"");
            	data.append(",\"LSCHG_DTM\":\""   + padLeftBlank((String)inMap.get("LSCHG_DTM"),14)  + "\"");
            	data.append(",\"LS_CMENO\":\""    + padLeftBlank((String)inMap.get("LS_CMENO"),9)    + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //응찰로그정보
        }else if("2100".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{");
        	    data.append("\"NA_BZPLC\":\""            + padLeftBlank((String)inMap.get("NA_BZPLC"),13)           + "\"");
            	data.append(",\"AUC_OBJ_DSC\":\""        + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1)         + "\"");
            	data.append(",\"AUC_DT\":\""             + padLeftBlank((String)inMap.get("AUC_DT"),8)              + "\"");
            	data.append(",\"OSLP_NO\":\""            + padLeftBlank((String)inMap.get("OSLP_NO"),10)            + "\"");
            	data.append(",\"TRMN_AMNNO\":\""         + padLeftBlank((String)inMap.get("TRMN_AMNNO"),8)          + "\"");
            	data.append(",\"LVST_AUC_PTC_MN_NO\":\"" + padLeftBlank((String)inMap.get("LVST_AUC_PTC_MN_NO"),13) + "\"");
            	data.append(",\"RG_SQNO\":\""            + padLeftBlank((String)inMap.get("RG_SQNO"),10)            + "\"");
            	data.append(",\"ATDR_AM\":\""            + padLeftBlank((String)inMap.get("ATDR_AM"),15)            + "\"");
            	data.append(",\"RMK_CNTN\":\""           + padLeftBlank((String)inMap.get("RMK_CNTN"),200)          + "\"");
            	data.append(",\"ATDR_DTM\":\""           + padLeftBlank((String)inMap.get("ATDR_DTM"),14)           + "\"");
            	data.append(",\"MMO_INP_YN\":\""         + padLeftBlank((String)inMap.get("MMO_INP_YN"),1)          + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //개체이력정보
        }else if("2200".equals(ctgrm_cd)) {
        	data.append("\"SRA_INDV_AMNNO\":\"" + padLeftBlank((String)paraMap.get("SRA_INDV_AMNNO"),20) + "\"");
        //분만정보
        }else if("2300".equals(ctgrm_cd)) {
        	data.append("\"MCOW_SRA_INDV_EART_NO\":\"" + padLeftBlank((String)paraMap.get("MCOW_SRA_INDV_EART_NO"),20) + "\"");
        //교배정보
        }else if("2400".equals(ctgrm_cd)) {
        	data.append("\"MCOW_SRA_INDV_EART_NO\":\"" + padLeftBlank((String)paraMap.get("MCOW_SRA_INDV_EART_NO"),20) + "\"");
        //공통코드정보
        }else if("2500".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""    + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
        	data.append(",\"NA_BZPLC\":\""  + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
        	data.append(",\"INQ_ST_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
        	data.append(",\"INQ_ED_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        //경제통합거래처정보 
        }else if("2600".equals(ctgrm_cd)) {
        	data.append("\"NA_BZPLC\":\""  + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
        	data.append(",\"na_trpl_c\":\""    + padLeftBlank((String)paraMap.get("NA_TRPL_C"),13)  + "\"");
        	data.append(",\"clntnm\":\"" + padLeftBlank((String)paraMap.get("CLNTNM"),50) + "\"");        	
        //경매참가번호정보 
        }else if("2700".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{");
            	data.append("\"NA_BZPLC\":\""            + padLeftBlank((String)inMap.get("NA_BZPLC"),13)           + "\"");
            	data.append(",\"AUC_DT\":\""             + padLeftBlank((String)inMap.get("AUC_DT"),8)              + "\"");
            	data.append(",\"AUC_OBJ_DSC\":\""        + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1)         + "\"");
            	data.append(",\"LVST_AUC_PTC_MN_NO\":\"" + padLeftBlank((String)inMap.get("LVST_AUC_PTC_MN_NO"),13) + "\"");
            	data.append(",\"TRMN_AMNNO\":\""         + padLeftZero((String)inMap.get("TRMN_AMNNO"),8)          + "\"");
            	data.append(",\"TR_DFN_YN\":\""          + padLeftBlank((String)inMap.get("TR_DFN_YN"),1)           + "\"");
            	data.append(",\"AUC_ENTR_GRN_AM\":\""    + padLeftZero((String)inMap.get("AUC_ENTR_GRN_AM"),15)     + "\"");
            	data.append(",\"RTRN_YN\":\""            + padLeftBlank((String)inMap.get("RTRN_YN"),1)             + "\"");
            	data.append(",\"DEL_YN\":\""             + padLeftBlank((String)inMap.get("DEL_YN"),1)              + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //회원정보
        }else if("2800".equals(ctgrm_cd)) {
        	data.append("\"NA_BZPLC\":\"" +  padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
        	data.append(",\"ENO\":\""     +  padLeftBlank((String)paraMap.get("ENO"),9) + "\"");
        //인공수정KPN정보
        }else if("2900".equals(ctgrm_cd)) {
            data.append("\"SRA_INDV_AMNNO\":\"" + padLeftBlank((String)paraMap.get("SRA_INDV_AMNNO"),20) + "\"");
        //비밀번호초기화인증정보
        }else if("3000".equals(ctgrm_cd)) {
        	data.append("\"NA_BZPLC\":\"" + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
        	data.append(",\"MPNO\":\""    + padLeftBlank((String)paraMap.get("MPNO"),11)  + "\"");
        	data.append(",\"USRNM\":\""   + padLeftBlank((String)paraMap.get("USRNM"),20) + "\"");
        	data.append(",\"PW\":\""      + padLeftBlank((String)paraMap.get("PW"),8)     + "\"");
        //문자정보
        }else if("3100".equals(ctgrm_cd)) {        	
        	data.append("\"INQ_CN\":" + 1 + "");
        	data.append(",\"RPT_DATA\":[");
    	    data.append("{");
    	    data.append("\"NA_BZPLC\":\"" + padLeftBlank((String)paraMap.get("NA_BZPLC"),13)   + "\"");
        	data.append(",\"MPNO\":\""     + padLeftBlank((String)paraMap.get("CUS_MPNO"),11)  + "\"");
        	data.append(",\"USRNM\":\""    + padLeftBlank((String)paraMap.get("USRNM"),20)     + "\"");
        	data.append(",\"MSG_CNTN\":\"" + padLeftBlank((String)paraMap.get("MSG_CNTN"),4000) + "\"");
        	data.append("}");	
    		data.append("]");
        	
        //주소정보
        }else if("3200".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""    + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
        	data.append(",\"PROVNM\":\""     + padLeftBlank((String)paraMap.get("PROVNM"),50)     + "\"");
        	data.append(",\"CCWNM\":\""      + padLeftBlank((String)paraMap.get("CCWNM"),50)      + "\"");
        	data.append(",\"ADR_RODNM\":\""  + padLeftBlank((String)paraMap.get("ADR_RODNM"),80)  + "\"");
        	data.append(",\"TTVNM\":\""      + padLeftBlank((String)paraMap.get("TTVNM"),50)      + "\"");
        	data.append(",\"ADR_BLDNM1\":\"" + padLeftBlank((String)paraMap.get("ADR_BLDNM1"),50) + "\"");
        //KPN정보
        }else if("3300".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""    + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
        	data.append(",\"NA_BZPLC\":\""    + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
        	data.append(",\"INQ_ST_DT\":\""  + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
        	data.append(",\"INQ_ED_DT\":\""  + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        //거래처(산정위원_수의사)정보
        }else if("3400".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""    + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
        	data.append(",\"NA_BZPLC\":\""    + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
        	data.append(",\"INQ_ST_DT\":\""  + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
        	data.append(",\"INQ_ED_DT\":\""  + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        //참여산정위원정보
        }else if("3500".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{");
	        	data.append("\"NA_BZPLC\":\""             + padLeftBlank((String)inMap.get("NA_BZPLC"),13)           + "\"");
	        	data.append(",\"AUC_OBJ_DSC\":\""         + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1)         + "\"");
	        	data.append(",\"AUC_DT\":\""              + padLeftBlank((String)inMap.get("AUC_DT"),8)              + "\"");
	        	data.append(",\"PDA_ID\":\""              + padLeftBlank((String)inMap.get("PDA_ID"),40)             + "\"");
	        	data.append(",\"LVST_MKT_TRPL_AMNNO\":\"" + padLeftZero((String)inMap.get("LVST_MKT_TRPL_AMNNO"),8) + "\"");
	        	data.append(",\"RMK_CNTN\":\""            + padLeftBlank((String)inMap.get("RMK_CNTN"),200)          + "\"");
	        	data.append(",\"TMS_YN\":\""              + padLeftBlank((String)inMap.get("TMS_YN"),1)              + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //중도매인조합원여부정보
        }else if("3600".equals(ctgrm_cd)) {
        	data.append("\"NA_BZPLC\":\""             + padLeftBlank((String)paraMap.get("NA_BZPLC"),13)            + "\"");
        	data.append(",\"MWMN_NA_TRPL_C\":\""      + padLeftBlank((String)paraMap.get("MWMN_NA_TRPL_C"),13)      + "\"");
        //출장우송아지내역정보
        }else if("3700".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{");
            	data.append("\"NA_BZPLC\":\""        + padLeftBlank((String)inMap.get("NA_BZPLC"),13)       + "\"");
            	data.append(",\"AUC_OBJ_DSC\":\""    + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1)     + "\"");
            	data.append(",\"AUC_DT\":\""         + padLeftBlank((String)inMap.get("AUC_DT"),8)          + "\"");
            	data.append(",\"OSLP_NO\":\""        + padLeftZero((String)inMap.get("OSLP_NO"),10)        + "\"");
            	data.append(",\"RG_SQNO\":\""        + padLeftZero((String)inMap.get("RG_SQNO"),10)        + "\"");
            	data.append(",\"SRA_SRS_DSC\":\""    + padLeftBlank((String)inMap.get("SRA_SRS_DSC"),2)     + "\"");
            	data.append(",\"SRA_INDV_AMNNO\":\"" + padLeftBlank((String)inMap.get("SRA_INDV_AMNNO"),20) + "\"");
            	data.append(",\"INDV_SEX_C\":\""     + padLeftBlank((String)inMap.get("INDV_SEX_C"),1)      + "\"");
            	data.append(",\"COW_SOG_WT\":\""     + padLeftZero((String)inMap.get("COW_SOG_WT"),15)     + "\"");
            	data.append(",\"BIRTH\":\""          + padLeftBlank((String)inMap.get("BIRTH"),8)           + "\"");
            	data.append(",\"KPN_NO\":\""         + padLeftBlank((String)inMap.get("KPN_NO"),9)          + "\"");
            	data.append(",\"FSRG_DTM\":\""       + padLeftBlank((String)inMap.get("FSRG_DTM"),14)       + "\"");
            	data.append(",\"FSRGMN_ENO\":\""     + padLeftBlank((String)inMap.get("FSRGMN_ENO"),9)      + "\"");
            	data.append(",\"LSCHG_DTM\":\""      + padLeftBlank((String)inMap.get("LSCHG_DTM"),14)      + "\"");
            	data.append(",\"LS_CMENO\":\""       + padLeftBlank((String)inMap.get("LS_CMENO"),9)        + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //출장우농가(농장)정보
        }else if("3800".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
    			
    			String sraFarmAcno = (String)inMap.get("SRA_FARM_ACNO");
    			if(sraFarmAcno != null) {
    				sraFarmAcno = sraFarmAcno.replaceAll("-", "");
    			}
        	    data.append("{");
        	    data.append("\"NA_BZPLC\":\""            + padLeftBlank((String)inMap.get("NA_BZPLC"),13)          + "\"");
            	data.append(",\"FHS_ID_NO\":\""          + padLeftBlank((String)inMap.get("FHS_ID_NO"),10)         + "\"");
            	data.append(",\"FARM_AMNNO\":\""         + padLeftZero((String)inMap.get("FARM_AMNNO"),8)         + "\"");
            	data.append(",\"FARM_ID_NO\":\""         + padLeftBlank((String)inMap.get("FARM_ID_NO"),10)        + "\"");
            	data.append(",\"NA_TRPL_C\":\""          + padLeftBlank((String)inMap.get("NA_TRPL_C"),13)         + "\"");
            	data.append(",\"SRA_FHSNM\":\""          + padLeftBlank((String)inMap.get("SRA_FHSNM"),50)         + "\"");
            	data.append(",\"SRA_FHS_FZIP\":\""       + padLeftBlank((String)inMap.get("SRA_FHS_FZIP"),3)       + "\"");
            	data.append(",\"SRA_FHS_RZIP\":\""       + padLeftBlank((String)inMap.get("SRA_FHS_RZIP"),3)       + "\"");
            	data.append(",\"SRA_FHS_DONGUP\":\""     + padLeftBlank((String)inMap.get("SRA_FHS_DONGUP"),80)    + "\"");
            	data.append(",\"SRA_FHS_DONGBW\":\""     + padLeftBlank((String)inMap.get("SRA_FHS_DONGBW"),100)   + "\"");
            	data.append(",\"SRA_FHS_ATEL\":\""       + padLeftBlank((String)inMap.get("SRA_FHS_ATEL"),4)       + "\"");
            	data.append(",\"SRA_FHS_HTEL\":\""       + padLeftBlank((String)inMap.get("SRA_FHS_HTEL"),4)       + "\"");
            	data.append(",\"SRA_FHS_STEL\":\""       + padLeftBlank((String)inMap.get("SRA_FHS_STEL"),4)       + "\"");
            	data.append(",\"SRA_FHS_REP_MPSVNO\":\"" + padLeftBlank((String)inMap.get("SRA_FHS_REP_MPSVNO"),4) + "\"");
            	data.append(",\"SRA_FHS_REP_MPHNO\":\""  + padLeftBlank((String)inMap.get("SRA_FHS_REP_MPHNO"),4)  + "\"");
            	data.append(",\"SRA_FHS_REP_MPSQNO\":\"" + padLeftBlank((String)inMap.get("SRA_FHS_REP_MPSQNO"),4) + "\"");
            	data.append(",\"RMK_CNTN\":\""           + padLeftBlank((String)inMap.get("RMK_CNTN"),200)         + "\"");
            	data.append(",\"FSRG_DTM\":\""           + padLeftBlank((String)inMap.get("FSRG_DTM"),14)          + "\"");
            	data.append(",\"FSRGMN_ENO\":\""         + padLeftBlank((String)inMap.get("FSRGMN_ENO"),9)         + "\"");
            	data.append(",\"LSCHG_DTM\":\""          + padLeftBlank((String)inMap.get("LSCHG_DTM"),14)         + "\"");
            	data.append(",\"LS_CMENO\":\""           + padLeftBlank((String)inMap.get("LS_CMENO"),15)           + "\"");
            	data.append(",\"MACO_YN\":\""            + padLeftBlank((String)inMap.get("MACO_YN"),1)            + "\"");
            	data.append(",\"BRC\":\""                + padLeftBlank((String)inMap.get("BRC"),6)                + "\"");
            	data.append(",\"SRA_FARM_ACNO\":\""      + padLeftBlank(sraFarmAcno,25)     + "\"");
        	    
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //출장우수수료정보
        }else if("3900".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{");
            	data.append("\"NA_BZPLC\":\""       + padLeftBlank((String)inMap.get("NA_BZPLC"),13)     + "\"");
            	data.append(",\"AUC_OBJ_DSC\":\""   + padLeftBlank((String)inMap.get("AUC_OBJ_DSC"),1)   + "\"");
            	data.append(",\"AUC_DT\":\""        + padLeftBlank((String)inMap.get("AUC_DT"),8)        + "\"");
            	data.append(",\"OSLP_NO\":\""       + padLeftZero((String)inMap.get("OSLP_NO"),10)      + "\"");
            	data.append(",\"LED_SQNO\":\""      + padLeftZero((String)inMap.get("LED_SQNO"),5)      + "\"");
            	data.append(",\"FEE_RG_SQNO\":\""   + padLeftZero((String)inMap.get("FEE_RG_SQNO"),10)  + "\"");
            	data.append(",\"FEE_APL_OBJ_C\":\"" + padLeftBlank((String)inMap.get("FEE_APL_OBJ_C"),1) + "\"");
            	data.append(",\"ANS_DSC\":\""       + padLeftBlank((String)inMap.get("ANS_DSC"),1)       + "\"");
            	data.append(",\"SBID_YN\":\""       + padLeftBlank((String)inMap.get("SBID_YN"),1)       + "\"");
            	data.append(",\"SRA_TR_FEE\":\""    + padLeftZero((String)inMap.get("SRA_TR_FEE"),15)    + "\"");
            	data.append(",\"APL_DT\":\""        + padLeftBlank((String)inMap.get("APL_DT"),8)        + "\"");
            	data.append(",\"NA_FEE_C\":\""      + padLeftBlank((String)inMap.get("NA_FEE_C"),3)      + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //출장우수기개체등록정보
        }else if("4000".equals(ctgrm_cd)) {
        	List<Map<String, Object>> mwmnList = (List) paraMap.get("RPT_DATA");
        	data.append("\"INQ_CN\":" + (String)paraMap.get("INQ_CN") + "");
        	data.append(",\"RPT_DATA\":[");
    		for(int k = 0; k < mwmnList.size(); k++) {
    			Map<String, Object> inMap = mwmnList.get(k);
        	    data.append("{");
        	    data.append("\"NA_BZPLC\":\""                + padLeftBlank((String)inMap.get("NA_BZPLC"),13)              + "\"");
            	data.append(",\"SRA_INDV_AMNNO\":\""         + padLeftBlank((String)inMap.get("SRA_INDV_AMNNO"),20)        + "\"");
            	data.append(",\"SRA_INDV_EART_NO\":\""       + padLeftBlank((String)inMap.get("SRA_INDV_EART_NO"),15)      + "\"");
            	data.append(",\"SRA_INDV_SRCH_EART_NO\":\""  + padLeftBlank((String)inMap.get("SRA_INDV_SRCH_EART_NO"),9)  + "\"");
            	data.append(",\"SRA_INDV_EXST_EART_NO\":\""  + padLeftBlank((String)inMap.get("SRA_INDV_EXST_EART_NO"),9)  + "\"");
            	data.append(",\"SRA_SRS_DSC\":\""            + padLeftBlank((String)inMap.get("SRA_SRS_DSC"),2)            + "\"");
            	data.append(",\"FHS_ID_NO\":\""              + padLeftBlank((String)inMap.get("FHS_ID_NO"),10)             + "\"");
            	data.append(",\"FARM_AMNNO\":\""             + padLeftZero((String)inMap.get("FARM_AMNNO"),8)             + "\"");
            	data.append(",\"SRA_INDV_OWNRNM\":\""        + padLeftBlank((String)inMap.get("SRA_INDV_OWNRNM"),20)       + "\"");
            	data.append(",\"BIRTH\":\""                  + padLeftBlank((String)inMap.get("BIRTH"),8)                  + "\"");
            	data.append(",\"SRA_INDV_BRDSRA_RG_DSC\":\"" + padLeftBlank((String)inMap.get("SRA_INDV_BRDSRA_RG_DSC"),2) + "\"");
            	data.append(",\"KPN_NO\":\""                 + padLeftBlank((String)inMap.get("KPN_NO"),9)                 + "\"");
            	data.append(",\"INDV_SEX_C\":\""             + padLeftBlank((String)inMap.get("INDV_SEX_C"),1)             + "\"");
            	data.append(",\"MCOW_SRA_INDV_EART_NO\":\""  + padLeftBlank((String)inMap.get("MCOW_SRA_INDV_EART_NO"),15) + "\"");
            	data.append(",\"SRA_INDV_MOTHR_MATIME\":\""  + padLeftZero((String)inMap.get("SRA_INDV_MOTHR_MATIME"),15) + "\"");
            	data.append(",\"SRA_INDV_PASG_QCN\":\""      + padLeftZero((String)inMap.get("SRA_INDV_PASG_QCN"),9)      + "\"");
            	data.append(",\"INDV_ID_NO\":\""             + padLeftBlank((String)inMap.get("INDV_ID_NO"),20)            + "\"");
            	data.append(",\"SRA_INDV_BRDSRA_RG_NO\":\""  + padLeftBlank((String)inMap.get("SRA_INDV_BRDSRA_RG_NO"),20) + "\"");
            	data.append(",\"RG_DSC\":\""                 + padLeftBlank((String)inMap.get("RG_DSC"),2)                 + "\"");
            	data.append(",\"SRA_INDV_DSC\":\""           + padLeftBlank((String)inMap.get("SRA_INDV_DSC"),5)           + "\"");
            	data.append(",\"FSRG_DTM\":\""               + padLeftBlank((String)inMap.get("FSRG_DTM"),14)              + "\"");
            	data.append(",\"FSRGMN_ENO\":\""             + padLeftBlank((String)inMap.get("FSRGMN_ENO"),9)             + "\"");
            	data.append(",\"FSRGMN_NA_BZPLC\":\""        + padLeftBlank((String)inMap.get("FSRGMN_NA_BZPLC"),13)       + "\"");
            	data.append(",\"LSCHG_DTM\":\""              + padLeftBlank((String)inMap.get("LSCHG_DTM"),14)             + "\"");
            	data.append(",\"LS_CMENO\":\""               + padLeftBlank((String)inMap.get("LS_CMENO"),9)               + "\"");
            	data.append(",\"LSCGMN_NA_BZPLC\":\""        + padLeftBlank((String)inMap.get("LSCGMN_NA_BZPLC"),13)       + "\"");
        	    if(k+1 == mwmnList.size()) {
	            	data.append("}");	
	            }else {
	            	data.append("},");
	            }
    		}
    		data.append("]");
        //출장우송아지내역정보
        }else if("4100".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""     + padLeftZero(""+(int)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\""  + padLeftZero((String)paraMap.get("IN_REC_CN"),4)  + "\"");
        	data.append(",\"FHS_ID_NO\":\""  + padLeftBlank((String)paraMap.get("FHS_ID_NO"),10) + "\"");
        	data.append(",\"FARM_AMNNO\":\"" + padLeftZero((String)paraMap.get("FARM_AMNNO"),8) + "\"");
        	data.append(",\"SRA_FHSNM\":\""  + padLeftBlank((String)paraMap.get("SRA_FHSNM"),50) + "\"");
        //개체유전체분석(친자확인) 수신
        }else if("4200".equals(ctgrm_cd)) {
        	data.append("\"RC_NA_TRPL_C\":\"" + padLeftBlank((String)paraMap.get("RC_NA_TRPL_C"),13)    + "\"");
            data.append(",\"INDV_ID_NO\":\""  + padLeftBlank((String)paraMap.get("INDV_ID_NO"),15)  + "\"");
        //개체친자여부수신
        }else if("4300".equals(ctgrm_cd)) {
        	data.append("\"RC_NA_TRPL_C\":\"" + padLeftBlank((String)paraMap.get("RC_NA_TRPL_C"),13)    + "\"");
            data.append(",\"INDV_ID_NO\":\""  + padLeftBlank((String)paraMap.get("INDV_ID_NO"),15)  + "\"");
        }else if("4500".equals(ctgrm_cd)) {
        	data.append("\"NA_BZPLC\":\"" + padLeftBlank((String)paraMap.get("NA_BZPLC"),13)    + "\"");
        }else if("4600".equals(ctgrm_cd)) {
        	data.append("\"IN_SQNO\":\""    + padLeftZero(""+(String)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"), 4) + "\"");
            data.append(",\"NA_BZPLC\":\""  + padLeftBlank((String)paraMap.get("NA_BZPLC"),13) + "\"");
            data.append(",\"INQ_ST_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ST_DT"),8) + "\"");
            data.append(",\"INQ_ED_DT\":\"" + padLeftBlank((String)paraMap.get("INQ_ED_DT"),8) + "\"");
        }else if("4700".equals(ctgrm_cd) || "4900".equals(ctgrm_cd)) {
        	data.append("\"SRA_INDV_AMNNO\":\"" + padLeftBlank((String)paraMap.get("SRA_INDV_AMNNO"),20)    + "\"");
        }else if("5100".equals(ctgrm_cd)) {
        	data.append("\"IO_TGRM_KEY\":\""    + padLeftBlank(""+(String)paraMap.get("IO_TGRM_KEY"),10)    + "\"");
            data.append(",\"ADJ_BRC\":\"" + padLeftBlank((String)paraMap.get("ADJ_BRC"), 6) + "\"");
            data.append(",\"RLNO\":\"" + padLeftBlank((String)paraMap.get("RLNO"), 13) + "\"");
            data.append(",\"IO_DPAMN_MED_ADR\":\"" + padLeftBlank((String)paraMap.get("IO_DPAMN_MED_ADR"), 80) + "\"");
            data.append(",\"IO_SDMN_MED_ADR\":\"" + padLeftBlank((String)paraMap.get("IO_SDMN_MED_ADR"), 80) + "\"");
            data.append(",\"IO_TIT\":\"" + padLeftBlank((String)paraMap.get("IO_TIT"), 40) + "\"");
            data.append(",\"KAKAO_TPL_C\":\"" + padLeftBlank((String)paraMap.get("KAKAO_TPL_C"), 30) + "\"");
            data.append(",\"KAKAO_MSG_CNTN\":\"" + padLeftBlank((String)paraMap.get("KAKAO_MSG_CNTN"), 4000)  + "\"");
            data.append(",\"FBK_UYN\":\"" + padLeftBlank((String)paraMap.get("FBK_UYN"), 1) + "\"");
            data.append(",\"FBK_MSG_DSC\":\"" + padLeftBlank((String)paraMap.get("FBK_MSG_DSC"), 1) + "\"");
            data.append(",\"FBK_TIT\":\"" + padLeftBlank((String)paraMap.get("FBK_TIT"), 20) + "\"");
            data.append(",\"IO_ATGR_ITN_TGRM_LEN\":\"" + padLeftBlank(paraMap.get("IO_ATGR_ITN_TGRM_LEN").toString(), 4) + "\"");
            data.append(",\"UMS_FWDG_CNTN\":\"" + padLeftBlank(paraMap.get("UMS_FWDG_CNTN").toString(), 4000) + "\"");
        }else if("5200".equals(ctgrm_cd)) {
        	data.append("\"NA_BZPLC\":\""    + padLeftBlank(""+(String)paraMap.get("NA_BZPLC"),13)    + "\"");
            data.append(",\"AUC_DT\":\"" + padLeftBlank((String)paraMap.get("AUC_DT"), 8) + "\"");
        	data.append(",\"IN_SQNO\":\""    + padLeftZero(""+(String)paraMap.get("IN_SQNO"),7)    + "\"");
            data.append(",\"IN_REC_CN\":\"" + padLeftZero((String)paraMap.get("IN_REC_CN"), 4) + "\"");
        }else if("5300".equals(ctgrm_cd) || "5400".equals(ctgrm_cd)) {
        	data.append("\"NA_BZPLC\":\""    + padLeftBlank(""+(String)paraMap.get("NA_BZPLC"),13)    + "\"");
            data.append(",\"AUC_DT\":\"" + padLeftBlank((String)paraMap.get("AUC_DT"), 8) + "\"");
        }else if("5500".equals(ctgrm_cd)) {
        	data.append("\"AUC_DT\":\""    + padLeftBlank(""+(String)paraMap.get("AUC_DT"),8)    + "\"");
            data.append(",\"SRA_SRS_DSC\":\"" + padLeftBlank("01", 2) + "\"");	//01 : 한우
        }else if("5600".equals(ctgrm_cd)) {
        	data.append("\"BTC_DT\":\""    + padLeftBlank(""+(String)paraMap.get("BTC_DT"),8)    + "\"");
            data.append(",\"SRA_SRS_DSC\":\"" + padLeftBlank("01", 2) + "\"");	//01 : 한우
        }
        
        int io_all_yn = 0;
        
        if(paraMap.containsKey("IO_ALL_YN")) {
        	if("1".equals((String)paraMap.get("IO_ALL_YN"))) {
        		io_all_yn = 1;
        	}
        }
        
        sb = rest.mcaSendMsg(ctgrm_cd, io_all_yn, "0200", data.toString());        
        log.info(sb.toString());
		return sb;
	}
	
	
	//공백
	public String padLeftBlank(String inputString, int length) throws UnsupportedEncodingException {
		if(inputString == null) {
			inputString = "";
		}
		byte[] inputByte=inputString.getBytes("EUC-KR");
			
		int byteLen = inputByte.length;
		if(byteLen == length) {
			return inputString;
		}else if(byteLen > length) {
			StringBuilder stringBuilder = new StringBuilder(length);
			int nCnt = 0;
			for(char ch:inputString.toCharArray()){
				nCnt += String.valueOf(ch).getBytes("EUC-KR").length;
				if(nCnt > length) break;
				stringBuilder.append(ch);
			}
			return stringBuilder.toString();
		}
		StringBuilder sb = new StringBuilder();
		sb.append(inputString);
		while(sb.toString().getBytes("EUC-KR").length < length) {
			sb.append(" ");
		}
		return sb.toString();
	}
	//공백 제로
	public String padLeftZero(String inputString, int length) throws UnsupportedEncodingException {		
		if(inputString == null) {
			inputString = "";
		}		
		byte[] inputByte=inputString.getBytes("EUC-KR");
			
		int byteLen = inputByte.length;
		if(byteLen == length) {
			return inputString;
		}else if(byteLen > length) {
			StringBuilder stringBuilder = new StringBuilder(length);
			int nCnt = 0;
			for(char ch:inputString.toCharArray()){
				nCnt += String.valueOf(ch).getBytes("EUC-KR").length;
				if(nCnt > length) break;
				stringBuilder.append(ch);
			}
			return stringBuilder.toString();
		}		
		StringBuilder sb = new StringBuilder();		
		//while(sb.length() < length - inputString.length()) {
		while(sb.toString().getBytes("EUC-KR").length < length - byteLen) {
			sb.append("0");
		}
		sb.append(inputString);
		return sb.toString();
	}


	public Map<String, Object> tradeMcaMsgTmp(String ctgrm_cd, Map<String, Object> paraMap) throws Exception {
		log.info(" ################# TradeMcaMsgDataController :tradeMcaMsgTmp() START #################");
		
		Map<String, Object> sb = new HashMap<String, Object>();
		
//		String in_sqno = "1";//시작번호
//      String in_rec_cn = "1";//조회건수
        
        SimpleDateFormat dd = new SimpleDateFormat("yyyyMMdd");
        Date now = new Date();
        String time =  dd.format(now);//현재날짜
        
        StringBuffer data = new StringBuffer();
        
        if("1600".equals(ctgrm_cd)) {
        	data.append("\"INQ_CN\":" + 1 + "");
        	data.append(",\"RPT_DATA\":[");
    	    data.append("{");        	    
    	    data.append("\"NA_BZPLC\":\""               + padLeftBlank((String)paraMap.get("ss_na_bzplc"),13)  + "\"");
        	data.append(",\"AUC_OBJ_DSC\":\""           + padLeftBlank("",1)   + "\"");
        	data.append(",\"AUC_DT\":\""                + padLeftBlank((String)paraMap.get("auc_dt"), 8)   + "\"");
        	data.append(",\"OSLP_NO\":\""               + padLeftBlank("0",10) + "\"");
        	data.append(",\"LED_SQNO\":\""              + padLeftBlank("",5)   + "\"");
        	data.append(",\"FHS_ID_NO\":\""             + padLeftBlank("",10)  + "\"");
        	data.append(",\"FARM_AMNNO\":\""            + padLeftBlank("",8)   + "\"");
        	data.append(",\"SOG_NA_TRPL_C\":\""         + padLeftBlank("",13)  + "\"");
        	data.append(",\"VHC_SHRT_C\":\""            + padLeftBlank("",6)   + "\"");
        	data.append(",\"RC_DT\":\""                 + padLeftBlank("",8)   + "\"");
        	data.append(",\"TRMN_AMNNO\":\""            + padLeftBlank("",8)   + "\"");
        	data.append(",\"LVST_AUC_PTC_MN_NO\":\""    + padLeftBlank("",13)  + "\"");
        	data.append(",\"SRA_SRS_DSC\":\""           + padLeftBlank("",2)   + "\"");
        	data.append(",\"SRA_INDV_AMNNO\":\""        + padLeftBlank("",20)  + "\"");
        	data.append(",\"COW_SOG_WT\":\""            + padLeftZero("",15)   + "\"");
        	data.append(",\"FIR_LOWS_SBID_LMT_AM\":\""  + padLeftZero("",15)   + "\"");
        	data.append(",\"LOWS_SBID_LMT_AM\":\""      + padLeftZero("",15)   + "\"");
        	data.append(",\"SRA_SBID_UPR\":\""          + padLeftZero("",15)   + "\"");
        	data.append(",\"SRA_SBID_AM\":\""           + padLeftZero("",15)   + "\"");
        	data.append(",\"SEL_STS_DSC\":\""           + padLeftBlank("",2)   + "\"");
        	data.append(",\"BRCL_ISP_CTFW_SMT_YN\":\""  + padLeftBlank("",1)   + "\"");
        	data.append(",\"BRCL_ISP_DT\":\""           + padLeftBlank("",8)   + "\"");
        	data.append(",\"LWPR_CHG_NT\":\""           + padLeftZero("",15)   + "\"");
        	data.append(",\"VACN_DT\":\""               + padLeftBlank("",8)   + "\"");
        	data.append(",\"LVST_MKT_TRPL_AMNNO\":\""   + padLeftBlank("",8)   + "\"");
        	data.append(",\"MT12_OVR_YN\":\""           + padLeftBlank("",1)   + "\"");
        	data.append(",\"PPGCOW_FEE_DSC\":\""        + padLeftBlank("",1)   + "\"");
        	data.append(",\"PRNY_JUG_YN\":\""           + padLeftBlank("",1)   + "\"");
        	data.append(",\"PRNY_YN\":\""               + padLeftBlank("",1)   + "\"");
        	data.append(",\"NCSS_JUG_YN\":\""           + padLeftBlank("",1)   + "\"");
        	data.append(",\"NCSS_YN\":\""               + padLeftBlank("",1)   + "\"");
        	data.append(",\"TRPCS_PY_YN\":\""           + padLeftBlank("",1)   + "\"");
        	data.append(",\"SRA_TRPCS\":\""             + padLeftZero("",15)   + "\"");
        	data.append(",\"SRA_PYIVA\":\""             + padLeftZero("",15)   + "\"");
        	data.append(",\"SRA_FED_SPY_AM\":\""        + padLeftZero("",15)   + "\"");
        	data.append(",\"TD_RC_CST\":\""             + padLeftZero("",15)   + "\"");
        	data.append(",\"MT12_OVR_FEE\":\""          + padLeftZero("",15)   + "\"");
        	data.append(",\"AFISM_MOD_DT\":\""          + padLeftBlank("",8)   + "\"");
        	data.append(",\"PRNY_MTCN\":\""             + padLeftZero("",15)   + "\"");
        	data.append(",\"AFISM_MOD_CTFW_SMT_YN\":\"" + padLeftBlank("",1)   + "\"");
        	data.append(",\"RMHN_YN\":\""               + padLeftBlank("",1)   + "\"");
        	data.append(",\"SRA_PDMNM\":\""             + padLeftBlank("",50)  + "\"");
        	data.append(",\"SRA_PD_RGNNM\":\""          + padLeftBlank("",50)  + "\"");
        	data.append(",\"RMK_CNTN\":\""              + padLeftBlank("",200) + "\"");
        	data.append(",\"AUC_PRG_SQ\":\""            + padLeftZero("",7)    + "\"");
        	data.append(",\"NA_CRC_CAN_DSC\":\""        + padLeftBlank("",1)   + "\"");
        	data.append(",\"SOGMN_RMT_DRUP_YN\":\""     + padLeftBlank("",1)   + "\"");
        	data.append(",\"BF_SOGMN_RMT_DRUP_YN\":\""  + padLeftBlank("",1)   + "\"");
        	data.append(",\"SOGMN_C\":\""               + padLeftBlank("",20)  + "\"");
        	data.append(",\"FSRG_DTM\":\""              + padLeftBlank("",14)  + "\"");
        	data.append(",\"FSRGMN_ENO\":\""            + padLeftBlank("",9)   + "\"");
        	data.append(",\"LSCHG_DTM\":\""             + padLeftBlank("",14)  + "\"");
        	data.append(",\"LS_CMENO\":\""              + padLeftBlank("",9)   + "\"");
        	//20221118 스마트가축시장 고도화 inf 항목 추가
        	data.append(",\"BDLN_VAL\":\""              + padLeftBlank("",8) + "\"");
        	data.append(",\"BDHT_VAL\":\""              + padLeftBlank("",8) + "\"");
        	data.append("}");       
    		data.append("]");
        }else if("3700".equals(ctgrm_cd)) {
        	data.append("\"INQ_CN\":" + 1 + "");
        	data.append(",\"RPT_DATA\":[");
    	    data.append("{");
        	data.append("\"NA_BZPLC\":\""        + padLeftBlank((String)paraMap.get("ss_na_bzplc"),13)       + "\"");
        	data.append(",\"AUC_OBJ_DSC\":\""    + padLeftBlank("",1)     + "\"");
        	data.append(",\"AUC_DT\":\""         + padLeftBlank((String)paraMap.get("auc_dt"),8)          + "\"");
        	data.append(",\"OSLP_NO\":\""        + padLeftZero("0",10)   + "\"");
        	data.append(",\"RG_SQNO\":\""        + padLeftZero("",10)    + "\"");
        	data.append(",\"SRA_SRS_DSC\":\""    + padLeftBlank("",2)     + "\"");
        	data.append(",\"SRA_INDV_AMNNO\":\"" + padLeftBlank("",20)    + "\"");
        	data.append(",\"INDV_SEX_C\":\""     + padLeftBlank("",1)     + "\"");
        	data.append(",\"COW_SOG_WT\":\""     + padLeftZero("",15)    + "\"");
        	data.append(",\"BIRTH\":\""          + padLeftBlank("",8)     + "\"");
        	data.append(",\"KPN_NO\":\""         + padLeftBlank("",9)     + "\"");
        	data.append(",\"FSRG_DTM\":\""       + padLeftBlank("",14)    + "\"");
        	data.append(",\"FSRGMN_ENO\":\""     + padLeftBlank("",9)     + "\"");
        	data.append(",\"LSCHG_DTM\":\""      + padLeftBlank("",14)    + "\"");
        	data.append(",\"LS_CMENO\":\""       + padLeftBlank("",9)     + "\"");
    	   	data.append("}");
    		data.append("]");
        }else if("3900".equals(ctgrm_cd)) {
        	data.append("\"INQ_CN\":" + 1 + "");
        	data.append(",\"RPT_DATA\":[");
    	    data.append("{");
        	data.append("\"NA_BZPLC\":\""       + padLeftBlank((String)paraMap.get("ss_na_bzplc"),13)     + "\"");
        	data.append(",\"AUC_OBJ_DSC\":\""   + padLeftBlank("",1)   + "\"");
        	data.append(",\"AUC_DT\":\""        + padLeftBlank((String)paraMap.get("auc_dt"),8)        + "\"");
        	data.append(",\"OSLP_NO\":\""       + padLeftZero("0",10)  + "\"");
        	data.append(",\"LED_SQNO\":\""      + padLeftZero("",5)   + "\"");
        	data.append(",\"FEE_RG_SQNO\":\""   + padLeftZero("",10)  + "\"");
        	data.append(",\"FEE_APL_OBJ_C\":\"" + padLeftBlank("",1)   + "\"");
        	data.append(",\"ANS_DSC\":\""       + padLeftBlank("",1)   + "\"");
        	data.append(",\"SBID_YN\":\""       + padLeftBlank("",1)   + "\"");
        	data.append(",\"SRA_TR_FEE\":\""    + padLeftZero("",15)   + "\"");
        	data.append(",\"APL_DT\":\""        + padLeftBlank("",8)   + "\"");
        	data.append(",\"NA_FEE_C\":\""      + padLeftBlank("",3)   + "\"");
            data.append("}");	
    		data.append("]");
        }
        
        int oi_all_yn = 0;
        
        sb = rest.mcaSendMsg(ctgrm_cd, oi_all_yn, "0200", data.toString());        
        log.info(sb.toString());
		return sb;
	}
	
}
