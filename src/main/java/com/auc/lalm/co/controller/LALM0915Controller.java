package com.auc.lalm.co.controller;

import java.security.SecureRandom;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.config.CriptoConfig;
import com.auc.common.vo.ResolverMap;
import com.auc.lalm.co.service.LALM0915Service;
import com.auc.lalm.sy.service.LALM0899Service;
import com.auc.lalm.sy.service.Impl.LALM0840Mapper;
import com.auc.main.service.MainService;
import com.auc.mca.AlarmTalkForm;
import com.auc.mca.McaUtil;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class LALM0915Controller {

	private static Logger log = LoggerFactory.getLogger(LALM0915Controller.class);

	@Autowired
	ConvertConfig convertConfig;	
	@Autowired
	CriptoConfig criptoConfig;	
	@Autowired
	CommonFunc commonFunc;
	@Autowired
	LALM0915Service lalm0915Service;
	@Autowired
	MainService mainService;
	@Autowired
	McaUtil mcaUtil;
	
	@Autowired
	LALM0899Service lalm0899Service;
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/co/LALM0915_selUsr", method=RequestMethod.POST)
	public Map<String, Object> LALM0915_selUsr(ResolverMap rMap) throws Exception{				
		ObjectMapper mapper = new ObjectMapper();	
		Map<String, Object> map = mapper.readValue(rMap.get("data").toString(), HashMap.class);

		/* 난수발생 */
		Random r = SecureRandom.getInstance("SHA1PRNG");
        r.setSeed(new Date().getTime());        
        String attc_no = ""+ 
        Integer.toHexString(r.nextInt(15)) + 
        Integer.toHexString(r.nextInt(15)) + 
        Integer.toHexString(r.nextInt(15)) + 
        Integer.toHexString(r.nextInt(15)) + 
        Integer.toHexString(r.nextInt(15)) + 
        Integer.toHexString(r.nextInt(15)) + 
        Integer.toHexString(r.nextInt(15)) +
        Integer.toHexString(r.nextInt(15));
        
        map.put("pw",attc_no.toUpperCase());
        
        Map<String, Object> inMap = lalm0915Service.LALM0915_selUsr(map);  
        
        //데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
  		Map<String, Object> reMap = new HashMap<String, Object>();		
  		
  		if(inMap == null) {
			reMap.put("status", 201);
			reMap.put("code", "C001");
			reMap.put("message", "사용자정보를 찾을수 없습니다.");
		}else {
	  		if(inMap.containsKey("updateNum")) {
	  			if((int)inMap.get("updateNum") > 0) {
	  				//SMS 처리
	  				Map<String, Object> mcaInMap = lalm0899Service.LALM0899_selMca3000(map);
	  				String smsContent = "[스마트가축시장] 고객님의 SMS인증을 위한 인증번호는 ["+mcaInMap.get("ATTC_NO")+"]입니다.";
	  				mcaInMap.put("CUS_MPNO", map.get("mpno"));
	  				mcaInMap.put("USRNM", map.get("usrnm"));
	  				mcaInMap.put("MSG_CNTN", smsContent);
	  		        Map<String, Object> mcaMap = mcaUtil.tradeMcaMsg((String)map.get("ctgrm_cd"), mcaInMap);
	  				
	  		        //조회 결과가 0건일 경우 201 리턴
	  		        if(mcaMap == null || mcaMap.isEmpty()) {
	  		        	reMap.put("status", 201);
	  		        	reMap.put("code", "C001");
	  		        	reMap.put("message", "전송 실패 하였습니다.");
	  		        }else if(mcaMap.containsKey("jsonHeader")){
	  		        	if("Error".equals(mcaMap.get("jsonHeader"))) {
	  		        		reMap.put("status", 202);
	  		        		reMap.put("code", "C002");
	  		        		reMap.put("message", "전송 실패 하였습니다.");
	  		        	}else {
	  		        		reMap.put("status", 200);
	  		        		reMap.put("code", "C000");
	  		        		reMap.put("dataCnt", mcaMap.get("dataCnt"));
	  		        		reMap.put("message", "");
	  		        	}
	  		        }else {
	  		        	reMap.put("status", 200);
	  		        	reMap.put("code", "C000");
	  		        	reMap.put("message", "");
	  		        }
				}else {
					reMap.put("status", 201);
					reMap.put("code", "C001");
					reMap.put("message", "사용자정보를 찾을수 없습니다.");
				}
	  		}else {
	  			reMap.put("status", 201);
	  			reMap.put("code", "C001");
	  			reMap.put("message", "사용자정보를 찾을수 없습니다.");
	  		}
		}
  		
  		return reMap;
	}
	
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/co/LALM0915_selPW", method=RequestMethod.POST)
	public Map<String, Object> LALM0915_selPW(ResolverMap rMap) throws Exception{				
		ObjectMapper mapper = new ObjectMapper();	
		Map<String, Object> map = mapper.readValue(rMap.get("data").toString(), HashMap.class);
			
        Map<String, Object> inMap = lalm0915Service.LALM0915_selPW(map);  
        
        //데이터 암호화해서 result 추가, 상태코드 추가, 조회 count 추가
        Map<String, Object> reMap = new HashMap<String, Object>();	
        
        //JSON으로 변경
        JSONObject jsonObject = commonFunc.convertMaptoJson(inMap);
        String encript = criptoConfig.encript(jsonObject.toString());
        //조회 결과가 0건일 경우 201 리턴
        if(inMap == null || inMap.isEmpty()) {
        	reMap.put("status", 201);
        	reMap.put("code", "C001");
        	reMap.put("message", "발송한 인증번호와 일치하지 않습니다.");
        }else {
        	reMap.put("status", 200);
        	reMap.put("code", "C000");
        	reMap.put("message", "");
        }
        reMap.put("data", encript);  		
  		return reMap;
	}
	
	
}