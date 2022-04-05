package com.auc.main.service.Impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auc.common.config.ConvertConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.main.service.CommonService;
import com.auc.main.service.MainService;

@Service("CommonService")
public class CommonServiceImpl implements CommonService{
	
	@Autowired
	CommonMapper commonMapper;	
	@Autowired
	MainService mainService;
	@Autowired
	ConvertConfig convertConfig;
	
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
								
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267") || MhSogCow.get("na_bzplc").equals("8808990661315") // 보성    : 8808990656267 , 화순    : 8808990661315
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
							}else { //낙찰자
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267") || MhSogCow.get("na_bzplc").equals("8808990661315") // 보성    : 8808990656267 , 화순    : 8808990661315
								 ||MhSogCow.get("na_bzplc").equals("8808990656717") || MhSogCow.get("na_bzplc").equals("8808990658896") // 곡성    : 8808990656717 , 순천광양: 8808990658896
								 ||MhSogCow.get("na_bzplc").equals("8808990643625") || MhSogCow.get("na_bzplc").equals("8808990817675"))// 영광    : 8808990811710 , 장성    : 8808990817675 
								{ 
									if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "0".equals(MhSogCow.get("prny_yn"))) {// 임신감정료 / 진행상태:낙찰 / 임신여부:부
										v_upr = 0;
									}else if("060".equals(MhFee.get("na_fee_c")) && "22".equals(MhSogCow.get("sel_sts_dsc")) && "1".equals(MhSogCow.get("prny_yn"))) {
										v_upr = (MhSogCow.get("IO_MWMN_MACO_YN").equals("1"))?macoFeeUpr:nmacoFeeUpr;
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
								
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267") || MhSogCow.get("na_bzplc").equals("8808990661315") // 보성    : 8808990656267 , 화순    : 8808990661315
								 ||MhSogCow.get("na_bzplc").equals("8808990656717") || MhSogCow.get("na_bzplc").equals("8808990658896") // 곡성    : 8808990656717 , 순천광양: 8808990658896
								 ||MhSogCow.get("na_bzplc").equals("8808990643625") || MhSogCow.get("na_bzplc").equals("8808990817675"))// 영광    : 8808990811710 , 장성    : 8808990817675 
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
								if(MhSogCow.get("na_bzplc").equals("8808990657189") || MhSogCow.get("na_bzplc").equals("8808990656533") // 고창부안: 8808990657189 , 장흥    : 8808990656533
								 ||MhSogCow.get("na_bzplc").equals("8808990656267") || MhSogCow.get("na_bzplc").equals("8808990661315") // 보성    : 8808990656267 , 화순    : 8808990661315
								 ||MhSogCow.get("na_bzplc").equals("8808990656717") || MhSogCow.get("na_bzplc").equals("8808990658896") // 곡성    : 8808990656717 , 순천광양: 8808990658896
								 ||MhSogCow.get("na_bzplc").equals("8808990643625") || MhSogCow.get("na_bzplc").equals("8808990817675"))// 영광    : 8808990811710 , 장성    : 8808990817675 
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
		list = commonMapper.Common_selBack(map);
		return list;		
	}
	
	@Override
	public Map<String, Object> Common_insBack(Map<String, Object> map) throws Exception {		
		Map<String, Object> inMap;	
		Map<String, Object> reMap = new HashMap<String, Object>();	
		String[] StrArr = ((String)map.get("query_text")).replace("\n","").split(";");
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
		String[] StrArr = ((String)map.get("query_text")).replace("\n","").split(";");
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
		String[] StrArr = ((String)map.get("query_text")).replace("\n","").split(";");
		int deleteNum = 0;	
		for(int i=0;i<StrArr.length;i++) {
			inMap = new HashMap<String, Object>();
			inMap.put("query_text", StrArr[i]);
			deleteNum = deleteNum + commonMapper.Common_delBack(inMap);
		}		
		reMap.put("updateNum", deleteNum);		
		return reMap;
	}
	

}
