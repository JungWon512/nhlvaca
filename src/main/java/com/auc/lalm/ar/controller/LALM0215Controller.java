package com.auc.lalm.ar.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.ar.service.LALM0215Service;
import com.auc.main.service.CommonService;

@RestController
@SuppressWarnings("unchecked")
public class LALM0215Controller {

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0215Service lalm0215Service;
	@Autowired
	CommonService commonService;
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
		
		
	@ResponseBody
	@RequestMapping(value="/LALM0215_selFee", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selFee(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selFee(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selStsDsc", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selStsDsc(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selStsDsc(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selGetPpgcowFeeDsc", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selGetPpgcowFeeDsc(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selGetPpgcowFeeDsc(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selPrgSq", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selPrgSq(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selPrgSq(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selMhCalf", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selMhCalf(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selMhCalf(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selOslpNo", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selOslpNo(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		

		List<Map<String, Object>> selAucPrgSqList = lalm0215Service.LALM0215_selAucPrgSq(map);
		int selAucPrgSq = Integer.parseInt(selAucPrgSqList.get(0).get("C_AUC_PRG_SQ").toString());
		if(selAucPrgSq == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매번호가 없습니다.");
		}
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selOslpNo(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selTmpFhsNm", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selTmpFhsNm(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selMhCalf(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selMacoFee", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selMacoFee(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selMacoFee(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selIndvAmnnoPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selIndvAmnnoPgm(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selIndvAmnnoPgm(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selTmpIndvAmnnoPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selTmpIndvAmnnoPgm(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selTmpIndvAmnnoPgm(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selFhsIdNo", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selFhsIdNo(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selFhsIdNo(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_selTmpAucPrgSq", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selTmpAucPrgSq(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selTmpAucPrgSq(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_delPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_delPgm(ResolverMap rMap) throws Exception{
		
		Map<String, Object> map = convertConfig.conMap(rMap);		

		List<Map<String, Object>> selAucQcnList = commonService.Common_selAucQcn(map);
		int selAucQcn = Integer.parseInt(selAucQcnList.get(0).get("DDL_YN").toString());
		if(selAucQcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매마감 되었습니다.");
		}
		Map<String, Object> inMap = lalm0215Service.LALM0215_delPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_updAucChange", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_updAucChange(ResolverMap rMap) throws Exception{				
				
		String vAucDt    = "";
		String vAucChgDt = "";
		
		Map<String, Object> map   = convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap  = (Map<String, Object>)map.get("frm_mhsogcow");
		
		List<Map<String, Object>> qcnList = commonService.Common_selAucQcn(frmMap);
		
		if(qcnList.size() == 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매차수를 먼저 등록하여야 합니다.");
		}
		
		int qcn = Integer.parseInt(qcnList.get(0).get("DDL_YN").toString());
		
		if(qcn > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"경매마감 되었습니다.");
		}
		
		// 경매일자를 이월일자로 변경
		vAucDt = frmMap.get("auc_dt").toString();
		vAucChgDt = frmMap.get("auc_chg_dt").toString();
		frmMap.put("auc_dt", vAucChgDt);
		
		List<Map<String, Object>> indvAmnnoList = lalm0215Service.LALM0215_selIndvAmnno(frmMap);
		
		// 경매일자 원복
		frmMap.put("auc_dt", vAucDt);
		
		if(indvAmnnoList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"동일한 경매일자에 동일한 귀표번호는 등록할수 없습니다.");
		}
		
		Map<String, Object> inMap = lalm0215Service.LALM0215_updAucChange(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;	
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_insPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_insPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   	= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap  = (Map<String, Object>)map.get("frm_mhsogcow");
		
		List<Map<String, Object>> qcnList = lalm0215Service.LALM0215_selAucPrg(frmMap);
		
		if(qcnList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된 경매번호가 있습니다. 경매번호를 확인 바랍니다.");
		}
		
		List<Map<String, Object>> indvAmnnoList = lalm0215Service.LALM0215_selIndvAmnno(frmMap);
		
		if(indvAmnnoList.size() > 0) {
			throw new CusException(ErrorCode.CUSTOM_ERROR,"동일한 경매일자에 동일한 귀표번호는 등록할수 없습니다.");
		}
		
		Map<String, Object> inMap = lalm0215Service.LALM0215_insPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;
		
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0215_updPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_updPgm(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map   	= convertConfig.conMapWithoutXxs(rMap);
		Map<String, Object> frmMap  = (Map<String, Object>)map.get("frm_mhsogcow");
		
		String beforeAucPrgSq 	= frmMap.get("hd_auc_prg_sq").toString();
		String afterAucPrgSq 	= frmMap.get("auc_prg_sq").toString();
		
		if(!beforeAucPrgSq.equals(afterAucPrgSq)) {
			List<Map<String, Object>> qcnList = lalm0215Service.LALM0215_selAucPrg(frmMap);
			if(qcnList.size() > 0) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,"중복된 경매번호가 있습니다. 경매번호를 확인 바랍니다.");
			}
		}
		
		List<Map<String, Object>> indvAmnnoList = lalm0215Service.LALM0215_selIndvAmnno(frmMap);
		
		if(indvAmnnoList.size() > 0) {
			if(!frmMap.get("re_indv_no").toString().equals(indvAmnnoList.get(0).get("SRA_INDV_AMNNO").toString())) {
				throw new CusException(ErrorCode.CUSTOM_ERROR,"귀표번호는 수정하실 수 없습니다.");
			}
		}
		
		Map<String, Object> inMap = lalm0215Service.LALM0215_updPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		
		return reMap;
		
	}
	
	/* ---------------------------------------------------------- 출장우 이미지 업로드 [s] ---------------------------------------------------------- */
	/**
	 * 경매준비관리 > 출장우 내역등록 > 이미지 탭
	 * @param rMap
	 * @return
	 * @throws SQLException 
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0215_selImgList", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_selImgList(ResolverMap rMap) throws Exception{
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = lalm0215Service.LALM0215_selImgList(map);
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList);
		return reMap;
	}
	
	/**
	 * 경매준비관리 > 출장우 내역등록 > 이미지 탭 > 출장우 이미지 저장
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0215_insImgPgm", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_insImgPgm(ResolverMap rMap) throws Exception{
		Map<String, Object> map = convertConfig.conMap(rMap);
		Map<String, Object> inMap = lalm0215Service.LALM0215_insImgPgm(map);
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;
	}
	
	/**
	 * 경매준비관리 > 출장우 내역등록 > 이미지 탭 > 출장우 이미지 삭제
	 * @param rMap
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/LALM0215_delImgList", method=RequestMethod.POST)
	public Map<String, Object> LALM0215_delImgList(ResolverMap rMap) throws Exception{

		Map<String, Object> map = convertConfig.conMap(rMap);	
		Map<String, Object> tempMap = lalm0215Service.LALM0215_delImgList(map);
		Map<String, Object> reMap = commonFunc.createResultSetMapData(tempMap);

		return reMap;
	}

}
