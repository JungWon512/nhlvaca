package com.auc.main.service.Impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.auc.common.config.ConvertConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.util.StringUtils;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.co.service.Impl.LALM0222PServiceImpl;
import com.auc.main.service.CommonService;
import com.auc.main.service.LogService;
import com.auc.main.service.MainService;
import com.auc.mca.McaUtil;

@Service("CommonService")
public class CommonServiceImpl implements CommonService{

	private static Logger log = LoggerFactory.getLogger(CommonServiceImpl.class);
	@Autowired
	CommonMapper commonMapper;	
	@Autowired
	MainService mainService;
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	private LogService logService;
	@Autowired
	private McaUtil mcaUtil;
	
	@Override
	public Map<String, Object> Common_selAucDt(Map<String, Object> map) throws Exception {
		
		Map<String, Object> result = commonMapper.Common_selAucDt(map);		
		return result;		
	}
	
	@Override
	public List<Map<String, Object>> Common_selVet(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> result = commonMapper.Common_selVet(map);		
		return result;		
	}	
	
	@Override
	public List<Map<String, Object>> Common_selAucQcn(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> list = null;		
		list = commonMapper.Common_selAucQcn(map);
		return list;		
	}
	
	@Override
	public int Common_insFeeImps(List<Map<String, Object>> grd_MhSogCow) throws Exception {
		int insertNum = 0;
		
		//환경정보조회
		List<Map<String, Object>> emvlist = mainService.selectEnvListData(convertConfig.conMap(new ResolverMap()));
		
		for(int i=0;i<grd_MhSogCow.size();i++) {			
						
			Map<String, Object> MhSogCow = convertConfig.changeKeyLower((Map<String, Object>)grd_MhSogCow.get(i));
			
			//기존수수료 삭제
			commonMapper.Common_delFee(MhSogCow);

			//수수료 기준정보 조회		
			List<Map<String, Object>> grd_MhFee = commonMapper.Common_selFee(MhSogCow);
			
			long bloodAm = 0;
			long sraSbidAm = 0;
			long feeChkYnFee = 0;
			long selfeeChkYnFee = 0;
			long mt12OvrFee = 0;
			
			try {
				bloodAm = (MhSogCow.get("blood_am") == null)?0:((BigDecimal)MhSogCow.get("blood_am")).longValue();
				sraSbidAm = ((BigDecimal)MhSogCow.get("sra_sbid_am") == null)?0:((BigDecimal)MhSogCow.get("sra_sbid_am")).longValue();
				feeChkYnFee = (MhSogCow.get("fee_chk_yn_fee") == null)?0:((BigDecimal)MhSogCow.get("fee_chk_yn_fee")).longValue();
				selfeeChkYnFee = (MhSogCow.get("selfee_chk_yn_fee") == null)?0:((BigDecimal)MhSogCow.get("selfee_chk_yn_fee")).longValue();
				mt12OvrFee = (MhSogCow.get("mt12_ovr_fee") == null)?0:((BigDecimal)MhSogCow.get("mt12_ovr_fee")).longValue();
			}catch (java.lang.ClassCastException e) {
				bloodAm = (MhSogCow.get("blood_am") == null || "".equals(MhSogCow.get("blood_am")))?0:Long.parseLong(MhSogCow.get("blood_am").toString());
				sraSbidAm = (MhSogCow.get("sra_sbid_am") == null || "".equals(MhSogCow.get("sra_sbid_am")))?0:Long.parseLong(MhSogCow.get("sra_sbid_am").toString());
				feeChkYnFee = (MhSogCow.get("fee_chk_yn_fee") == null || "".equals(MhSogCow.get("fee_chk_yn_fee")))?0:Long.parseLong(MhSogCow.get("fee_chk_yn_fee").toString());
				selfeeChkYnFee = (MhSogCow.get("selfee_chk_yn_fee") == null || "".equals(MhSogCow.get("selfee_chk_yn_fee")))?0:Long.parseLong(MhSogCow.get("selfee_chk_yn_fee").toString());
				mt12OvrFee = (MhSogCow.get("mt12_ovr_fee") == null || "".equals(MhSogCow.get("mt12_ovr_fee")))?0:Long.parseLong(MhSogCow.get("mt12_ovr_fee").toString());
			}
			
			for(int j=0;j<grd_MhFee.size();j++) {

				Map<String, Object> MhFee = convertConfig.changeKeyLower((Map<String, Object>)grd_MhFee.get(j));
				
				if(!MhFee.get("auc_obj_dsc").equals(MhSogCow.get("auc_obj_dsc"))) {
					continue;
				}
				
				long macoFeeUpr = (MhFee.get("maco_fee_upr") == null)?0:((BigDecimal)MhFee.get("maco_fee_upr")).longValue();
				long nmacoFeeUpr = (MhFee.get("nmaco_fee_upr") == null)?0:((BigDecimal)MhFee.get("nmaco_fee_upr")).longValue();
				
				
				double sra_tr_fee = 0;
				double v_upr = 0;
				
				if("010".equals(MhFee.get("na_fee_c")) || "011".equals(MhFee.get("na_fee_c"))) {
					if(MhSogCow.get("ppgcow_fee_dsc").equals(MhFee.get("ppgcow_fee_dsc"))) {
						if("1".equals(MhFee.get("am_rto_dsc"))) {//금액
							
							if("1".equals(MhFee.get("fee_apl_obj_c"))) {//출하자
								v_upr = ("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
							}else { //낙찰자
								v_upr = ("1".equals(MhSogCow.get("io_mwmn_maco_yn")))?(macoFeeUpr + bloodAm):(nmacoFeeUpr + bloodAm);
							}
						
							if(("1".equals(MhFee.get("sbid_yn")) && "22".equals(MhSogCow.get("sel_sts_dsc")))
							|| ("0".equals(MhFee.get("sbid_yn")) && !"22".equals(MhSogCow.get("sel_sts_dsc")))) {	// 낙찰, 불락	
								
								sra_tr_fee =  v_upr;
							
								//사료미사용수수료 수수료추가
								if("010".equals(MhFee.get("na_fee_c")) && "0".equals(MhSogCow.get("sra_fed_spy_yn"))) {
									sra_tr_fee = sra_tr_fee + ((BigDecimal)emvlist.get(0).get("SRA_FED_SPY_YN_FEE")).longValue();
								}
								
								// ★2. 합천축협 친자확인 수수료
		                        // 2016.09.05 친자확인여부 수수료추가
		                        // 2016.11.02 친자확인여부 수수료추가 1차수정으로로 원복
		                        // 2017.01.06 합천사료사용 여: 친자감별수수료(0) 부: 친자감별수수료(10000)
								if(MhSogCow.get("na_bzplc").equals("8808990656236")) { // 합천: 8808990656236
									if("010".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("dna_yn_chk"))) {
										if("".equals(MhSogCow.get("sra_fed_spy_yn")) || "0".equals(MhSogCow.get("sra_fed_spy_yn"))) {
											sra_tr_fee = sra_tr_fee + ((BigDecimal)emvlist.get(0).get("FEE_CHK_DNA_YN_FEE")).longValue();// 출하수수료 + 친자검사여부 출하수수료(10000원)
										}
									}
									if("011".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("dna_yn_chk")) && "1".equals(MhSogCow.get("dna_yn"))) {
										sra_tr_fee = sra_tr_fee + ((BigDecimal)emvlist.get(0).get("SELFEE_CHK_DNA_YN_FEE")).longValue(); // 판매수수료 + 친자검사여부 판매수수료(5000원)
									}
								}
								
								// ★3. 영주축협 수수료 2017.04.14
								if(MhSogCow.get("na_bzplc").equals("8808990687094")) {  // 영주: 8808990687094
									if("010".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("dna_yn_chk"))) {
										sra_tr_fee = sra_tr_fee + ((BigDecimal)emvlist.get(0).get("FEE_CHK_DNA_YN_FEE")).longValue();// 출하수수료 + 친자검사여부 출하수수료(10000원)
									}
									// 12개월이상수수료 / 친자검사여부판매수수료 2017.06.20
									if("011".equals(MhFee.get("na_fee_c"))) {
										if("1".equals(MhSogCow.get("mt12_ovr_yn"))) { 
											sra_tr_fee = sra_tr_fee + mt12OvrFee; // 판매수수료 + 12개월이상 수수료 (5000원)
										}else if("1".equals(MhSogCow.get("dna_yn_chk"))) {
											sra_tr_fee = sra_tr_fee + ((BigDecimal)emvlist.get(0).get("SELFEE_CHK_DNA_YN_FEE")).longValue(); // 판매수수료 + 친자검사여부 판매수수료(5000원)
										}								
									}
								}
								
								// ★4. 청양축협 수수료 2020.11.09
								if(MhSogCow.get("na_bzplc").equals("8808990657646")) {   // ★청양: 8808990657646
									
									if("011".equals(MhFee.get("na_fee_c"))) {
										if("1".equals(MhSogCow.get("mt12_ovr_yn"))) {
											sra_tr_fee = sra_tr_fee + mt12OvrFee; // 판매수수료 + 12개월이상 수수료
										}								
									}
								}
								
								// 구미축협
								if(MhSogCow.get("na_bzplc").equals("8808990657615")) {  // ★구미: 8808990657615
									if("010".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("dna_yn_chk"))) {
										sra_tr_fee = sra_tr_fee + ((BigDecimal)emvlist.get(0).get("FEE_CHK_DNA_YN_FEE")).longValue();// 출하수수료 + 친자검사여부 출하수수료
									}
									if("011".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("dna_yn_chk"))) {
										sra_tr_fee = sra_tr_fee + ((BigDecimal)emvlist.get(0).get("SELFEE_CHK_DNA_YN_FEE")).longValue(); // 판매수수료 + 친자검사여부 판매수수료
									}
								}
								
								// 출하/판매수수료 수기등록
								if("010".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("fee_chk_yn"))) {
									sra_tr_fee =  feeChkYnFee; // 출하수수료 수기등록
								}else if("011".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("selfee_chk_yn"))) {
									sra_tr_fee =  selfeeChkYnFee;  // 판매수수료 수기등록
								}
							}
						}else {   // 율
							if("1".equals(MhFee.get("fee_apl_obj_c"))) {//출하자
								v_upr = (("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr) * sraSbidAm / 100;
							}else { //낙찰자
								v_upr = (("1".equals(MhSogCow.get("io_mwmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr) * sraSbidAm / 100;
							}
							
						
							if("1".equals(MhFee.get("sbid_yn")) && "22".equals(MhSogCow.get("sel_sts_dsc"))) {	// 낙찰	
								
								if("1".equals(MhFee.get("sgno_prc_dsc"))) {
									sra_tr_fee = Math.floor(v_upr);
								}else if("2".equals(MhFee.get("sgno_prc_dsc"))) {
									sra_tr_fee = Math.ceil(v_upr);
								}else {
									sra_tr_fee = Math.round(v_upr);
								}
								
								// ★ 춘천축협료
								if(MhSogCow.get("na_bzplc").equals("8808990656229")) {  // 1000단위미만 버림  춘천축협: 8808990656229
									if("010".equals(MhFee.get("na_fee_c"))) {
										sra_tr_fee = Math.floor(sra_tr_fee / 1000) * 1000;
									}
								}
								
								
								// 출하/판매수수료 수기등록
								if("010".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("fee_chk_yn"))) {
									sra_tr_fee =  feeChkYnFee; // 출하수수료 수기등록
								}else if("011".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("selfee_chk_yn"))) {
									sra_tr_fee =  selfeeChkYnFee;  // 판매수수료 수기등록
								}
							}
						}
					}
				}else {
					String v_ppgcow_fee_dsc = "";
					if(MhSogCow.get("ppgcow_fee_dsc").equals(MhFee.get("ppgcow_fee_dsc"))) {
						v_ppgcow_fee_dsc = (String)MhSogCow.get("ppgcow_fee_dsc");
					}else {
						Map<String, Object> in_ppgcow_fee_dsc = new HashMap<String, Object>();
						in_ppgcow_fee_dsc.put("na_bzplc", MhSogCow.get("na_bzplc"));
						in_ppgcow_fee_dsc.put("auc_obj_dsc", MhSogCow.get("auc_obj_dsc"));
						in_ppgcow_fee_dsc.put("auc_dt", MhSogCow.get("auc_dt"));
						in_ppgcow_fee_dsc.put("na_fee_c", MhFee.get("na_fee_c"));
						in_ppgcow_fee_dsc.put("ppgcow_fee_dsc", MhSogCow.get("ppgcow_fee_dsc"));
						
						List<Map<String, Object>> out_ppgcow_fee_dsc = commonMapper.Common_selPpgcowFeeDsc(in_ppgcow_fee_dsc);
						
						if(out_ppgcow_fee_dsc.size() == 0) {
							if("5".equals(MhFee.get("ppgcow_fee_dsc"))) {
								v_ppgcow_fee_dsc = "5";
							}else {
								v_ppgcow_fee_dsc = "-1";
							}
						}else {
							v_ppgcow_fee_dsc = "-1";
						}
					}
					if(MhFee.get("ppgcow_fee_dsc").equals(v_ppgcow_fee_dsc)) {
						if("1".equals(MhFee.get("am_rto_dsc"))) {//금액
							
							if("1".equals(MhFee.get("fee_apl_obj_c"))) {//출하자
								// 2023.12.06 : 화순축협 제거
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267") // 보성    : 8808990656267
								 ||MhSogCow.get("na_bzplc").equals("8808990656717") || MhSogCow.get("na_bzplc").equals("8808990658896") // 곡성    : 8808990656717 , 순천광양: 8808990658896
								 ||MhSogCow.get("na_bzplc").equals("8808990811710") || MhSogCow.get("na_bzplc").equals("8808990817675"))// 영광    : 8808990811710 , 장성    : 8808990817675 
								{ 
									if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("prny_yn"))) {// 임신감정료 / 진행상태:낙찰 / 임신여부:여
										v_upr = 0;
									}else if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "0".equals(MhSogCow.get("prny_yn"))) {
										v_upr = ("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
									}else {
										if(MhSogCow.get("na_bzplc").equals("8808990656267") || MhSogCow.get("na_bzplc").equals("8808990656533") // 보성: 8808990656267 , 장흥: 8808990656533 , 영광: 8808990811710 , 장성: 8808990817675
										 ||MhSogCow.get("na_bzplc").equals("8808990811710") || MhSogCow.get("na_bzplc").equals("8808990817675")) {
											// 괴사감정을하고 괴사여부가 체크되면 출하자한테 수수료 부과
                                            if ("050".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("ncss_jug_yn")) && "1".equals(MhSogCow.get("ncss_yn"))) {
                                            	v_upr = (MhSogCow.get("io_sogmn_maco_yn").equals("1"))?macoFeeUpr:nmacoFeeUpr;
                                            }else if ("050".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "0".equals(MhSogCow.get("ncss_jug_yn")) && "0".equals(MhSogCow.get("ncss_yn"))) {
                                                v_upr = 0;
                                            }else if ("050".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("ncss_jug_yn")) && "0".equals(MhSogCow.get("ncss_yn"))) {
                                                v_upr = 0;
                                            }else{
                                            	v_upr = ("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
                                            }
										}else {
											v_upr = ("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
										}
									}
								}else {
									v_upr = ("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
								}
							}else { 
								//낙찰자 
								// 2023.12.06 : 화순축협 제거
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267")  // 보성    : 8808990656267
								 ||MhSogCow.get("na_bzplc").equals("8808990656717") || MhSogCow.get("na_bzplc").equals("8808990658896") // 곡성    : 8808990656717 , 순천광양: 8808990658896
								 ||MhSogCow.get("na_bzplc").equals("8808990811710") || MhSogCow.get("na_bzplc").equals("8808990817675"))// 영광    : 8808990811710 , 장성    : 8808990817675 
								{ 
									if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "0".equals(MhSogCow.get("prny_yn"))) {// 임신감정료 / 진행상태:낙찰 / 임신여부:부
										v_upr = 0;
									}else if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("prny_yn"))) {
										v_upr = ("1".equals(MhSogCow.get("IO_MWMN_MACO_YN")))?macoFeeUpr:nmacoFeeUpr;
									}else {
										if(MhSogCow.get("na_bzplc").equals("8808990656267") || MhSogCow.get("na_bzplc").equals("8808990656533") // 보성: 8808990656267 , 장흥: 8808990656533 , 영광: 8808990811710 , 장성: 8808990817675
										 ||MhSogCow.get("na_bzplc").equals("8808990811710") || MhSogCow.get("na_bzplc").equals("8808990817675")) {
											//괴사감정을하고 괴사여부가 체크가 안되면 낙찰자한테 수수료 부과
                                            if ("050".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("ncss_jug_yn")) && "0".equals(MhSogCow.get("ncss_yn"))) {
                                            	v_upr = (MhSogCow.get("io_mwmn_maco_yn").equals("1"))?macoFeeUpr:nmacoFeeUpr;
                                            }else if ("050".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("ncss_jug_yn")) && "1".equals(MhSogCow.get("ncss_yn"))) {
                                                v_upr = 0;
                                            }else if ("050".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "0".equals(MhSogCow.get("ncss_jug_yn")) && "0".equals(MhSogCow.get("ncss_yn"))) {
                                                v_upr = 0;
                                            }else{
                                            	v_upr = ("1".equals(MhSogCow.get("io_mwmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
                                            }
										}else {
											v_upr = ("1".equals(MhSogCow.get("io_mwmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
										}
									}
								}else {
									v_upr = ("1".equals(MhSogCow.get("io_mwmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr;
								}
							}
							if (("1".equals(MhFee.get("sbid_yn")) && "22".equals(MhSogCow.get("sel_sts_dsc"))) 
								||("0".equals(MhFee.get("sbid_yn")) && !"22".equals(MhSogCow.get("sel_sts_dsc")))) {  //낙찰, 불락
								sra_tr_fee = v_upr;
							}
							if ("11".equals(MhSogCow.get("sel_sts_dsc"))) {  //송장등록
								sra_tr_fee = 0;
							}
						}else {   // 율
							if("1".equals(MhFee.get("fee_apl_obj_c"))) {//출하자

								// 2023.12.06 : 화순축협 제거
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267") // 보성    : 8808990656267
								 ||MhSogCow.get("na_bzplc").equals("8808990656717") || MhSogCow.get("na_bzplc").equals("8808990658896") // 곡성    : 8808990656717 , 순천광양: 8808990658896
								 ||MhSogCow.get("na_bzplc").equals("8808990811710") || MhSogCow.get("na_bzplc").equals("8808990817675"))// 영광    : 8808990811710 , 장성    : 8808990817675 
								{ 
									if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("prny_yn"))) {// 임신감정료 / 진행상태:낙찰 / 임신여부:여
										v_upr = 0;
									}else if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "0".equals(MhSogCow.get("prny_yn"))) {
										v_upr = (("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr) * sraSbidAm / 100;
									}else {
										v_upr = (("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr) * sraSbidAm / 100;
									}
								}else {
									v_upr = (("1".equals(MhSogCow.get("io_sogmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr) * sraSbidAm / 100;
								}
							}else { //낙찰자
								// 2023.12.06 : 화순축협 제거
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267")  // 보성    : 8808990656267 
								 ||MhSogCow.get("na_bzplc").equals("8808990656717") || MhSogCow.get("na_bzplc").equals("8808990658896") // 곡성    : 8808990656717 , 순천광양: 8808990658896
								 ||MhSogCow.get("na_bzplc").equals("8808990811710") || MhSogCow.get("na_bzplc").equals("8808990817675"))// 영광    : 8808990811710 , 장성    : 8808990817675 
								{ 
									if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc"))&& "0".equals(MhSogCow.get("prny_yn"))) {// 임신감정료 / 진행상태:낙찰 / 임신여부:부
										v_upr = 0;
									}else  {
										v_upr = (("1".equals(MhSogCow.get("io_mwmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr) * sraSbidAm / 100;
									}
								}else {
									v_upr = (("1".equals(MhSogCow.get("io_mwmn_maco_yn")))?macoFeeUpr:nmacoFeeUpr) * sraSbidAm / 100;
								}
							}
							if ("1".equals(MhFee.get("sbid_yn")) && "22".equals(MhSogCow.get("sel_sts_dsc"))) {  //낙찰
								if("1".equals(MhSogCow.get("sgno_prc_dsc"))) {
									sra_tr_fee = Math.floor(v_upr);
								}else if("2".equals(MhSogCow.get("sgno_prc_dsc"))) {
									sra_tr_fee = Math.ceil(v_upr);
								}else {
									sra_tr_fee = Math.round(v_upr);
								}								
							}						
						}
						
						if ("050".equals(MhFee.get("na_fee_c")) && "0".equals(MhSogCow.get("ncss_jug_yn"))) sra_tr_fee = 0;  // 괴사감정료
                        if ("060".equals(MhFee.get("na_fee_c")) && "0".equals(MhSogCow.get("prny_jug_yn"))) sra_tr_fee = 0;  // 임심감정료
                        if ("110".equals(MhFee.get("na_fee_c")) && "0".equals(MhSogCow.get("rmhn_yn"))) sra_tr_fee = 0;  // 제각수수료
                        if ("040".equals(MhFee.get("na_fee_c")) && "1".equals(MhSogCow.get("trpcs_py_yn"))) sra_tr_fee = 0;  // 운송비

                        // 사고적립금 백운학일때 사고적립금 0 적용 - 청도축협
                        if (MhSogCow.get("na_bzplc").equals("8808990656571")){  // ★청도: 8808990656571
                            if ("030".equals(MhFee.get("na_fee_c")) && "백운학".equals(MhSogCow.get("sra_pdmnm"))){
                                sra_tr_fee = 0;   // 사고적립금 0 입력
                            }
                        }
					}
				}
				
				Map<String, Object> in_fee_imps = new HashMap<String, Object>();
				in_fee_imps.put("na_bzplc",        MhSogCow.get("na_bzplc"));
				in_fee_imps.put("auc_obj_dsc",     MhSogCow.get("auc_obj_dsc"));
				in_fee_imps.put("auc_dt",          MhSogCow.get("auc_dt"));
				in_fee_imps.put("oslp_no",         MhSogCow.get("oslp_no"));

				in_fee_imps.put("fee_rg_sqno",     MhFee.get("fee_rg_sqno"));
				in_fee_imps.put("na_fee_c",        MhFee.get("na_fee_c"));
				in_fee_imps.put("apl_dt",          MhFee.get("apl_dt"));
				in_fee_imps.put("fee_apl_obj_c",   MhFee.get("fee_apl_obj_c"));
				in_fee_imps.put("ans_dsc",         MhFee.get("ans_dsc"));
				in_fee_imps.put("sbid_yn",         MhFee.get("sbid_yn"));
				in_fee_imps.put("sra_tr_fee",      sra_tr_fee);
				
				insertNum = commonMapper.Common_insFeeImps(in_fee_imps);				
				
			}
			
		}
		return insertNum;
		
	}
	
	@Override
	public List<Map<String, Object>> Common_selBack(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> list = null;
		String queryTxt = (String)map.get("query_text");
		if(!queryTxt.toUpperCase().contains("WHERE")) throw new CusException(ErrorCode.CUSTOM_ERROR, "WHERE절 누락.");
		list = commonMapper.Common_selBack(map);
		return list;		
	}
	
	@Override
	public Map<String, Object> Common_insBack(Map<String, Object> map) throws Exception {		
		Map<String, Object> inMap;	
		Map<String, Object> reMap = new HashMap<String, Object>();	
		String queryTxt = (String)map.get("query_text");
		//if(!queryTxt.toUpperCase().contains("WHERE")) throw new CusException(ErrorCode.CUSTOM_ERROR, "WHERE절 누락.");
		String[] StrArr = queryTxt.replace("\n","").split(";");
		int insertNum = 0;	
		for(int i=0;i<StrArr.length;i++) {
			inMap = new HashMap<String, Object>();
			inMap.put("query_text", StrArr[i]);
			insertNum = insertNum + commonMapper.Common_insBack(inMap);
		}
		reMap.put("insertNum", insertNum);		
		return reMap;
	}
	@Override
	public Map<String, Object> Common_updBack(Map<String, Object> map) throws Exception {		
		Map<String, Object> inMap;	
		Map<String, Object> reMap = new HashMap<String, Object>();	
		String queryTxt = (String)map.get("query_text");
		if(!queryTxt.toUpperCase().contains("WHERE")) throw new CusException(ErrorCode.CUSTOM_ERROR, "WHERE절 누락.");
		String[] StrArr = queryTxt.replace("\n","").split(";");
		int updateNum = 0;	
		for(int i=0;i<StrArr.length;i++) {
			inMap = new HashMap<String, Object>();
			inMap.put("query_text", StrArr[i]);
			updateNum = updateNum + commonMapper.Common_updBack(inMap);
		}		
		reMap.put("updateNum", updateNum);		
		return reMap;
	}
	@Override
	public Map<String, Object> Common_delBack(Map<String, Object> map) throws Exception {		
		Map<String, Object> inMap;
		Map<String, Object> reMap = new HashMap<String, Object>();		
		String queryTxt = (String)map.get("query_text");
		if(!queryTxt.toUpperCase().contains("WHERE")) throw new CusException(ErrorCode.CUSTOM_ERROR, "WHERE절 누락.");
		String[] StrArr = queryTxt.replace("\n","").split(";");
		int deleteNum = 0;	
		for(int i=0;i<StrArr.length;i++) {
			inMap = new HashMap<String, Object>();
			inMap.put("query_text", StrArr[i]);
			deleteNum = deleteNum + commonMapper.Common_delBack(inMap);
		}		
		reMap.put("updateNum", deleteNum);		
		return reMap;
	}

	@Override
	public Map<String, Object> common_updIndvInfo(Map<String, Object> map) throws Exception {
		
		final Map<String, Object> reMap = new HashMap<String, Object>();

		// 조합에 등록된 개체가 있으면 수정 없는 경우 저장
		final List<Map<String, Object>> amnnolist = commonMapper.common_selAmnno(map);
		if(amnnolist.size() > 0) {
			//개체 정보 업데이트
			commonMapper.common_updMnIndv(map);
			// 로그 저장
			logService.insMmIndvLog(map);
		}
		else {
			commonMapper.common_insMmIndv(map);
			map.put("sra_srs_dsc ", "01");
			map.put("anw_yn ", "9");
			//개체 정보 업데이트
			logService.insMmIndvLog(map);
		}
		return reMap;
	}

	@Override
	public Map<String, Object> Common_insDownloadLog(Map<String, Object> map) throws Exception{
		Map<String, Object> reMap = new HashMap<String, Object>();
		int insNum = 0;
		insNum = insNum + commonMapper.Common_insDownloadLog(map);
		reMap.put("updateNum", insNum);
		return reMap;
	}
	
	/********************************************************************* 통합회원 관련 [s] *********************************************************************/
	
	/**
	 * 통합회원 신규 등록
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> Common_insMbintgInfo(Map<String, Object> map) throws Exception{
		// 통합회원 테이블에서 이름, 생년월일, 전화번호로 정보 조회
		// 단, 한우종합에서 등록한 농가(anw_yn값이 1)는 농가식별번호(FHS_ID_NO)로 통합회원정보 조회 
		//final Map<String, Object> info = "1".equals(map.get("anw_yn")) ? commonMapper.Common_selFhsMbintgInfo(map) : commonMapper.Common_selMbintgInfo(map);
		//final Map<String, Object> info = commonMapper.Common_selMbintgInfo(map);
		List<Map<String, Object>> list = commonMapper.Common_selMbintgList(map);
		if(!list.isEmpty()) {
			final Map<String, Object> info = list.get(0);
			// 통합 정보가 있는 경우 통합회원번호 리턴
			if (!ObjectUtils.isEmpty(info) && !ObjectUtils.isEmpty(info.get("MB_INTG_NO"))) {
				map.put("mb_intg_no", info.get("MB_INTG_NO"));
				return map;
			}				
		}
		
		// 이름 / 생년월일 / 휴대전화번호 중 1개라도 없으면 통합을 진행하지 않음
		String userName = "02".equals(map.get("mb_intg_gb")) ? map.getOrDefault("ftsnm", "").toString() : map.getOrDefault("sra_mwmnnm", "").toString();
		String birth = "02".equals(map.get("mb_intg_gb")) ? map.getOrDefault("birth", "").toString() : map.getOrDefault("cus_rlno", "").toString();	
		String cus_mpno = map.getOrDefault("cus_mpno", "").toString();
		
		if((StringUtils.isEmpty(userName.trim()) || StringUtils.isEmpty(birth.trim()) || StringUtils.isEmpty(cus_mpno.trim()))) {
			return map;
		}
		
		// 조회된 통합회원 정보가 없는 경우, 휴면 회원 백업 테이블에서 한 번 더 조회
		final Map<String, Object> dormInfo = commonMapper.Common_selDormMbintgInfo(map);

		// 백업 테이블에도 정보가 없는 경우 통합회원 신규 저장
		if (ObjectUtils.isEmpty(dormInfo)) {
			// 통합회원 원장 테이블 저장
			commonMapper.Common_insMbintgInfo(map);
			// 통합회원 히스토리 저장
			commonMapper.Common_insMbintgHisInfo(map);

			return map;
		}

		// 휴면 백업 정보에 있는 통합회원번호
		map.put("mb_intg_no", dormInfo.get("MB_INTG_NO"));
		// 현재 조합에 해당 통합회원번호로 등록된 중도매인, 출하주 데이터 수
		// - 데이터가 없는 경우에만 중도매인, 출하주를 신규 저장
		// - 데이터가 있는 경우에는 중도매인, 출하주 휴면 정보 처리 과정에서 기존 데이터를 복구시키기 때문에 신규 저장이 필요 없음
		//   > 한 조합에 동일한 중도매인 등록을 막기 위함
		map.put("cur_dorm_cnt", dormInfo.get("CUR_DORM_CNT"));
		
		// 휴면정보 복구
		commonMapper.Common_resMbintgInfo(map);

		// 통합회원정보 이력 저장
		commonMapper.Common_insMbintgHisInfo(map);
		
		// 통합회원 휴면 정보 삭제
		commonMapper.Common_delDormMbintgInfo(map);

		// 중도매인
		int updateNum = 0;
		if ("01".equals(map.get("mb_intg_gb"))) {
			// 중도매인 정보 복구
			updateNum += commonMapper.Common_resMwmnInfo(map);
			
			// 중도매인 이력 저장
			commonMapper.Common_insMiMwmnInfo(map);
		}
		// 출하주
		else {
		// 출하주 정보 복구
			updateNum += commonMapper.Common_resFhsInfo(map);
		}

		map.put("updateNum", updateNum);			
		
		return map;
	}
	/********************************************************************* 통합회원 관련 [e] *********************************************************************/

	public Map<String, Object> Common_selAiakInfo(String barcode) throws Exception{
		Map<String,Object> reMap = new HashMap<>();
		int updateNum = 0;
		if(barcode != null && barcode.length() == 15) {
			barcode = barcode.substring(3);
		}
		reMap = mcaUtil.callApiAiakMap(barcode);
		if(reMap != null && !reMap.isEmpty()) {
			updateNum += this.Common_insAiakInfo(reMap);			
		}
		reMap.put("updateNum", updateNum);
		return reMap;
	}
	
	private int Common_insAiakInfo(Map<String, Object> map) throws Exception{
		int insertNum = 0;
		insertNum += commonMapper.Common_insAiakInfo(map);

		List<Map<String, Object>> postData = (List<Map<String, Object>>) map.get("postInfo");
		for(Map<String, Object> postMap: postData) {
			insertNum += commonMapper.Common_insAiakPostInfo(postMap);			
		}

		List<Map<String, Object>> sibData = (List<Map<String, Object>>) map.get("sibInfo");
		for(Map<String, Object> sibMap: sibData) {
			insertNum += commonMapper.Common_insAiakSibInfo(sibMap);			
		}
		commonMapper.Common_updIndvSibMatime(map);
		commonMapper.Common_updIndvPostMatime(map);
		
		return insertNum;
	}
}
