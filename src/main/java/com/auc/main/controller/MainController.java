package com.auc.main.controller;

import java.awt.Color;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.sql.Blob;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.config.CriptoConfig;
import com.auc.common.config.JwtTokenUtil;
import com.auc.common.config.RSACriptoConfig;
import com.auc.common.util.BReqData;
import com.auc.common.util.StringUtils;
import com.auc.common.vo.JwtUser;
import com.auc.common.vo.ResolverMap;
import com.auc.main.service.MainService;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@CrossOrigin
public class MainController {
	
	private static Logger log = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	MainService mainService;	
	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CriptoConfig criptoConfig;	
	@Autowired
	CommonFunc commonFunc;		
	@Autowired
	JwtTokenUtil jwtTokenUtil;
	@Autowired
	RSACriptoConfig rsaCriptoConfig;
	
	@Value("${cript.key}")
    private String key;
	@Value("${cript.iv}")
    private String iv;
	
		
	@ResponseBody
	@RequestMapping(value="/selectBaseInfo", method=RequestMethod.POST)
	public Map<String, Object> selectBaseInfo(ResolverMap rMap) throws Exception{				
				
		Map<String, Object> map = convertConfig.conMap(rMap);
		Map<String, Object> outMap = new HashMap<String, Object>();
		
		//메뉴리스트
		outMap.put("menuList", mainService.selectMenuList(map));
		//팝업화면리스트
		outMap.put("popupList", mainService.selectPopupList(map));
		//화면버튼리스트
		outMap.put("btnList", mainService.selectBtnList(map));
		//메뉴권한 리스트
		outMap.put("authList", mainService.selectBtnAuthList(map));
		//공통코드 리스트
		outMap.put("comboList", mainService.selectComboList(map));
		
		Map<String, Object> reMap = commonFunc.createResultSetJsonData(outMap); 				
		return reMap;
	}
	
	
	
	@ResponseBody
	@RequestMapping(value="/selectWmcListData", method=RequestMethod.POST)
	public Map<String, Object> selectWmcListData(ResolverMap rMap) throws Exception{
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = mainService.selectWmcListData(map);
		
		if(reList != null && reList.size() > 0 ) {
		
			Map<String, Object> outMap = reList.get(0);
			
			if(((Blob)outMap.get("SEAL_IMG_CNTN")) != null){
				byte arr[] = StringUtils.blobToBytes((Blob)outMap.get("SEAL_IMG_CNTN"));
	
				if(arr != null && arr.length > 0) {
					outMap.put("SEAL_IMG_CNTN", StringUtils.byteToBase64(arr));
				}else {
					outMap.put("SEAL_IMG_CNTN", "");
				}		
			}else {
				outMap.put("SEAL_IMG_CNTN", "");
			}
			
			reList.remove(0);
			reList.add(outMap);
			
		}
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 				
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/selectEnvListData", method=RequestMethod.POST)
	public Map<String, Object> selectEnvListData(ResolverMap rMap) throws Exception{
		Map<String, Object> map = convertConfig.conMap(rMap);
		List<Map<String, Object>> reList = mainService.selectEnvListData(map);			
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 				
		return reMap;
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/co/updatePassword", method=RequestMethod.POST)
	public Map<String, Object> updatePassword(ResolverMap rMap) throws Exception{	
		ObjectMapper mapper = new ObjectMapper();	
		Map<String, Object> getMap = mapper.readValue(rMap.get("data").toString(), HashMap.class);
		Map<String, Object> inMap = mainService.updatePassword(getMap);
		
		//데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
		Map<String, Object> reMap = new HashMap<String, Object>();		

		//JSON으로 변경
		JSONObject jsonObject = commonFunc.convertMaptoJson(inMap);		
		String encript = criptoConfig.encript(jsonObject.toString());	
		reMap.put("data", encript);
		if(inMap == null) {
			reMap.put("status", 201);
			reMap.put("code", "C001");
			reMap.put("message", "변경된 내역이 없습니다.");
		}else {
			if(inMap.containsKey("updateNum")) {
				if((int)inMap.get("updateNum") > 0) {
					reMap.put("updateNum", inMap.get("updateNum"));
					reMap.put("status", 200);
					reMap.put("code", "C000");
					reMap.put("message", "");
				}else {
					reMap.put("status", 201);
					reMap.put("code", "C001");
					reMap.put("message", "인증 절차중 문제가 발생하였습니다.<br>제인증 부탁드립니다.");
				}
			}else {			
				reMap.put("status", 201);
				reMap.put("code", "C001");
				reMap.put("message", "변경된 내역이 없습니다");
			}
		}
		reMap.put("data", encript);
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/MainSogYear_selList", method=RequestMethod.POST)
	public Map<String, Object> MainSogYear_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = mainService.MainSogYear_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/MainSogQcn_selList", method=RequestMethod.POST)
	public Map<String, Object> MainSogQcn_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);		
		List<Map<String, Object>> reList = mainService.MainSogQcn_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/MainNotice_selList", method=RequestMethod.POST)
	public Map<String, Object> MainSogAm_selList(ResolverMap rMap) throws Exception{				
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		
		//xml 조회
		List<Map<String, Object>> reList = mainService.MainNotice_selList(map);				
		Map<String, Object> reMap = commonFunc.createResultSetListData(reList); 	
		
		return reMap;
	}	
	
	@ResponseBody
	@RequestMapping(value="/co/getRSAKey", method=RequestMethod.POST)
	public Map<String, Object> getRSAKey(HttpServletRequest req, HttpServletResponse resp) throws Exception{

		Map<String, Object> reMap = new HashMap<String, Object>();
		
		//RSA 키 생성
		KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
		generator.initialize(2048);
		KeyPair keyPair = generator.generateKeyPair();
		KeyFactory keyFactory = KeyFactory.getInstance("RSA");
		
		PublicKey publicKey   = keyPair.getPublic();
		PrivateKey privateKey = keyPair.getPrivate();
		
		RSAPublicKeySpec publicSpec = (RSAPublicKeySpec)keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
 		
		String publicKeyModulus  = publicSpec.getModulus().toString(16);
		String publicKeyExponent = publicSpec.getPublicExponent().toString(16);

		reMap.put("RSAKey", new String(rsaCriptoConfig.byteArrayToHex(privateKey.getEncoded())));
		reMap.put("RSAModulus", publicKeyModulus);
		reMap.put("RSAExponent", publicKeyExponent);
		
		return reMap;
	}		
	
				
	@RequestMapping(value="/", method=RequestMethod.GET)
	public ModelAndView login(HttpServletRequest req, HttpServletResponse resp) throws Exception{

		ModelAndView mv = new ModelAndView();
		
		mv.addObject("key", key);
		mv.addObject("iv", iv);
		
		mv.setViewName("login");
		return mv;
	}		
	   
	@RequestMapping(value="/index", method=RequestMethod.GET)
	public ModelAndView index(HttpServletRequest req, HttpServletResponse resp) throws Exception{
		ModelAndView mv = new ModelAndView();
		//사업장코드, 사업장명 조회
		List<Map<String, Object>> naList = mainService.selectNaList();
		JSONArray jsonNaList = commonFunc.convertListMapToJson(naList);		
		mv.addObject("naList", jsonNaList);		
		mv.setViewName("index");				
		return mv;
	}	
		
	@RequestMapping(value={"/main","/page/**"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView page(@RequestParam Map<String, Object> map, HttpServletResponse resp) throws Exception{
		ModelAndView mv = new ModelAndView();
		if(null == map.get("data") || "".equals(map.get("data"))) {
			resp.sendRedirect("/error/RuntimeError");
		}
		mv.addObject("pageInfo", map.get("data"));
		return mv;
	}
		
}
