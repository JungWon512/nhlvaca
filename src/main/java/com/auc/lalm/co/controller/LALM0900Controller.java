package com.auc.lalm.co.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Blob;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.Base64Utils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.util.BReqData;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.co.service.LALM0900Service;

@RestController
public class LALM0900Controller {
	
	private static Logger log = LoggerFactory.getLogger(LALM0900Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0900Service lalm0900Service;
		
	@ResponseBody
	@RequestMapping(value="/LALM0900_selList", method=RequestMethod.POST)
	public Map<String, Object> LALM0900_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		List<Map<String, Object>> list = lalm0900Service.LALM0900_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(list); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0900P1_selData", method=RequestMethod.POST)
	public Map<String, Object> LALM0900_selData(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		Map<String, Object> outMap = lalm0900Service.LALM0900P1_selData(map);				
		Map<String, Object> reMap = commonFunc.createResultSetMapData(outMap); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0900P1_insBlbd", method=RequestMethod.POST)
	public Map<String, Object> LALM0900P1_insBlbd(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0900Service.LALM0900P1_insBlbd(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0900P1_updBlbd", method=RequestMethod.POST)
	public Map<String, Object> LALM0900P1_updBlbd(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0900Service.LALM0900P1_updBlbd(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0900P1_delBlbd", method=RequestMethod.POST)
	public Map<String, Object> LALM0900P1_delBlbd(ResolverMap rMap) throws Exception{	
		Map<String, Object> inMap = lalm0900Service.LALM0900P1_delBlbd(convertConfig.conMap(rMap));
		Map<String, Object> reMap = commonFunc.createResultCUD(inMap);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0900P1_insApdfl", method=RequestMethod.POST)
	public Map<String, Object> LALM0900P1_insApdfl(MultipartHttpServletRequest reqeust) throws Exception{	
		MultipartFile mf   = reqeust.getFile("flnm");
		String ss_userid   = reqeust.getParameter("ss_userid");
		String ss_na_bzplc = reqeust.getParameter("ss_na_bzplc");
		String orgFileName = mf.getOriginalFilename().substring(mf.getOriginalFilename().lastIndexOf("\\")+1);
		String xcrnm       = orgFileName.substring(orgFileName.lastIndexOf(".")+1, orgFileName.length());
		long fl_sze        = reqeust.getFile("flnm").getSize();
		
		Map<String, Object> inMap = new HashMap<String, Object>();		
		inMap.put("flnm", orgFileName);
		inMap.put("xcrnm", xcrnm);
		inMap.put("fl_sze", fl_sze);
		inMap.put("fl_cntn", mf.getBytes());
		inMap.put("ss_na_bzplc", ss_na_bzplc);
		inMap.put("ss_userid", ss_userid);
				
		Map<String, Object> map = lalm0900Service.LALM0900P1_insApdfl(inMap);
		Map<String, Object> reMap = commonFunc.createResultSetMapData(map);
		return reMap;	
	}
	
	@ResponseBody
	@RequestMapping(value="/LALM0900_selFileDownload", method=RequestMethod.POST)
	public ResponseEntity<Resource> LALM0900_selFileDownload(@RequestBody BReqData reqData, HttpServletRequest req, HttpServletResponse res) throws Exception{	
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("apdfl_id", reqData.getParamDataVal("apdfl_id"));
		
		Map<String, Object> fileMap = null;
		fileMap = lalm0900Service.LALM0900_selFileDownload(param);
		
		String filename = (String) fileMap.get("FLNM");
		String ext      = (String) fileMap.get("XCRNM");
		
		String fl_sze_st = String.valueOf(fileMap.get("FL_SZE"));
		long   fl_sze   = Long.valueOf(fl_sze_st);
		Blob blob       = (Blob) fileMap.get("FL_CNTN");
		byte[] blobAry  = blob.getBytes(1L, (int) blob.length());
		
		ByteArrayResource resource = new ByteArrayResource(blobAry);
		
		HttpHeaders header = new HttpHeaders();
		
		header.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + URLEncoder.encode(filename, "UTF-8"));
		header.add("Cache-Control", "no-cache, no-store, must-revalidate");
		header.add("pragma", "no-cache");
		header.add("Expires", "0");
		
		return ResponseEntity.ok().headers(header).contentLength(fl_sze)
				.contentType(MediaType.parseMediaType("application/octet-stream")).body(resource);
		
	}
	

}
