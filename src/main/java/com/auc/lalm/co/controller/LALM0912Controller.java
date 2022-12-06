package com.auc.lalm.co.controller;

import java.sql.Blob;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.util.StringUtils;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.co.service.LALM0912Service;

@SuppressWarnings({"unused"})
@RestController
public class LALM0912Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0912Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0912Service lalm0912Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0912_selData", method=RequestMethod.POST)
	public Map<String, Object> LALM0912_selData(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		Map<String, Object> outMap = lalm0912Service.LALM0912_selData(map);				
		Map<String, Object> reMap = commonFunc.createResultSetMapData(outMap); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0912_insWmc", method=RequestMethod.POST)
	public Map<String, Object> LALM0912_insWmc(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0912Service.LALM0912_insWmc(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0912_updWmc", method=RequestMethod.POST)
	public Map<String, Object> LALM0912_updWmc(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0912Service.LALM0912_updWmc(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0912_delWmc", method=RequestMethod.POST)
	public Map<String, Object> LALM0912_delWmc(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0912Service.LALM0912_delWmc(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody   
	@RequestMapping(value="/LALM0912_updSealImg", method=RequestMethod.POST)
	public Map<String, Object> LALM0912_updSealImg(MultipartHttpServletRequest reqeust) throws Exception{				
		
		MultipartFile mf = reqeust.getFile("seal_img_flnm");
		
		String na_bzplc = reqeust.getParameter("na_bzplc");
		
		String orgFileName = mf.getOriginalFilename().substring(mf.getOriginalFilename().lastIndexOf("\\")+1);
		
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("na_bzplc", na_bzplc);
		inMap.put("seal_img_flnm", orgFileName);
		inMap.put("seal_img_cntn", mf.getBytes());
				
		Map<String, Object> map = lalm0912Service.LALM0912_updSealImg(inMap);
		Map<String, Object> reMap = commonFunc.createResultCUD(map);
		return reMap;	
	}
	
	
	@ResponseBody
	@RequestMapping(value="/LALM0912_selSealImg", method=RequestMethod.POST)
	public String LALM0912_selSealImg(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		Map<String, Object> outMap = lalm0912Service.LALM0912_selSealImg(map);
		byte arr[] = StringUtils.blobToBytes((Blob)outMap.get("SEAL_IMG_CNTN"));
		if( arr != null && arr.length > 0) {
			String base64Encode = "data:image/png;base64," + StringUtils.byteToBase64(arr);
			return base64Encode;
		}else {
			
			return "";
		}
	}
	
	

}
