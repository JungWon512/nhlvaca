package com.auc.main.controller;

import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.type.filter.RegexPatternTypeFilter;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.auc.common.config.CommonFunc;
import com.auc.common.config.ConvertConfig;
import com.auc.common.config.CookieUtil;
import com.auc.common.config.CriptoConfig;
import com.auc.common.config.JwtTokenUtil;
import com.auc.common.config.RSACriptoConfig;
import com.auc.common.exception.CusException;
import com.auc.common.exception.ErrorCode;
import com.auc.common.util.StringUtils;
import com.auc.common.vo.JwtRequest;
import com.auc.common.vo.JwtResponse;
import com.auc.common.vo.ResolverMap;
import com.auc.common.vo.JwtUser;
import com.auc.common.vo.LoginUser;
import com.auc.main.service.LogService;
import com.auc.main.service.MainService;
import com.auc.main.service.Impl.JwtUserDetailsService;
import com.auc.mca.McaUtil;

@RestController
@CrossOrigin
public class JwtAuthenticationController {
	
	private static Logger log = LoggerFactory.getLogger(JwtAuthenticationController.class);
	
	@Autowired
    private AuthenticationManager authenticationManager;
	@Autowired
	private JwtTokenUtil jwtTokenUtil;
	@Autowired
    private JwtUserDetailsService userDetailsService;	
	@Autowired
	CriptoConfig criptoConfig;
	@Autowired
	CookieUtil cookieUtil;
	@Autowired
	CommonFunc commonFunc;	
	@Autowired
	ConvertConfig convertConfig;
	@Autowired
	MainService mainService;
	@Autowired
	PasswordEncoder passwordEncoder;
	@Autowired
	RSACriptoConfig rsaCriptoConfig;
	@Autowired
	LogService logService;
	@Autowired
	McaUtil mcaUtil;
	@Value("${spring.profiles.service-name:nhlva}")
	private String serviceName;

	@Value("${cript.key}")
    private String key;
	@Value("${cript.iv}")
    private String iv;
		
	@RequestMapping(value="/signIn", method=RequestMethod.POST)
	public ResponseEntity<?> signIn(ResolverMap rMap, HttpServletRequest req, HttpServletResponse resp) throws Exception{
		
		HttpSession session = req.getSession();				
		Map<String, Object> map = rMap.getMap();
		PrivateKey privateKey = rsaCriptoConfig.StringToPrivateKey(map.get("RSAKey").toString());				
		map.put("user_id", rsaCriptoConfig.decryptRsa(privateKey, (String)map.get("user_id")));
		map.put("user_pw", rsaCriptoConfig.decryptRsa(privateKey, (String)map.get("user_pw")));
		map.put("na_bzplc", rsaCriptoConfig.decryptRsa(privateKey, (String)map.get("na_bzplc")));
		
		int result = 0;    	    	    	
    	Map<String, String> loginMap = userDetailsService.signIn(map);
		

        String ip = (req.getHeader("X-Forwarded-For") ==  null)?req.getRemoteAddr():req.getHeader("X-Forwarded-For");
    	//사용자 없음
    	if(loginMap.size() == 0) {
    		throw new CusException(ErrorCode.CUSTOM_ERROR, "사용자 정보를 찾을수 없습니다.");
    	}    	    	
	
    	//패스워드 비밀번호 5회 이상 틀림
    	if(Integer.parseInt(String.valueOf(loginMap.get("PWERR_NT"))) >= 5) {
    		throw new CusException(ErrorCode.CUSTOM_ERROR, "5회 이상의 비밀번호 입력 오류로 인하여 계정이 잠긴 상태입니다.<br>SMS를 통하여 인증완료 후 비밀번호를 변경하시기 바랍니다.");
    	}    	
		
    	//패스워드 일치 확인
    	int chkPw = 0;
		Map<String, Object> tempMap = new HashMap<String, Object>();
		tempMap.put("usrid", loginMap.get("USRID"));
		tempMap.put("user_pw", map.get("user_pw"));
		tempMap.put("na_bzplc", loginMap.get("NA_BZPLC"));
    	//chkPw = userDetailsService.selChkPw(tempMap);
    	chkPw = userDetailsService.selChkPw((String)loginMap.get("USRID"), (String)map.get("user_pw"));

	
    	if(chkPw > 0) {
			result = 1;	
		}else {			
			if(!"admin".equals((String)loginMap.get("USRID"))) {
				int updPwerrCnt = userDetailsService.updPwerr_nt(loginMap);
			}
//			throw new CusException(ErrorCode.CUSTOM_ERROR, "비밀번호를 다시 확인하세요.");
			throw new CusException(ErrorCode.CUSTOM_ERROR, "로그인 아이디와 비밀번호를 확인하세요.");
		}
		if(result == 1) {			
			//로그인 성공 시 security 인터페이스 해서 값 받음

			Map<String, Object> secMap = new HashMap<String, Object>();
			String apl_ed_dtm = "";
			
			//관리자 제외
			if(!"001".equals(loginMap.get("GRP_C")) && !"tibero".equals(serviceName)) {
				secMap.put("eno", loginMap.get("USRID"));
				secMap.put("na_bzplc", loginMap.get("NA_BZPLC"));
				Map<String, Object> secreMap = (Map<String, Object>) mcaUtil.tradeMcaMsg("2800", secMap).get("jsonData");
				
				//재직여부가 1이 아니면 로그인하면안됨				
				if(!"1".equals(secreMap.get("HDOF_YN"))) {
					//로그인하면 안됨
			        Map<String, Object> logMap = new HashMap<String, Object>();
			        logMap.put("na_bzplc", loginMap.get("NA_BZPLC"));
			        logMap.put("usrid", loginMap.get("USRID"));
			        logMap.put("url_nm", "/signIn");
			        logMap.put("pgid",   "퇴직자 접속시도");
			        logMap.put("ipadr",  ip);
			        logMap.put("data_prc_dsc", "D");			        
			        logService.insUserLog(logMap);
					throw new CusException(ErrorCode.CUSTOM_ERROR, "퇴직자입니다.");
//					return ResponseEntity.ok(null);
				}
				
				apl_ed_dtm = ((String)secreMap.get("APL_ED_DTM")).trim();
				
			}
			
			String security = "0";

	    	String jwtStr = map.get("user_id") + "|" + loginMap.get("NA_BZPLC");
			JwtRequest authenticationRequest = new JwtRequest();
	    	authenticationRequest.setUsername(jwtStr);
	    	authenticationRequest.setPassword((String) map.get("user_id"));
	    	
	    	authenticate(authenticationRequest.getUsername(), authenticationRequest.getPassword());	    
	    		    	
	        final JwtUser userDetails = (JwtUser) userDetailsService.loadUserByUsername(authenticationRequest.getUsername());

	        userDetails.setApl_ed_dtm("".equals(apl_ed_dtm) ? "19000101120000" : apl_ed_dtm);
	        userDetails.setSecurity(security);
	        final String token = jwtTokenUtil.generateToken(userDetails);
	        final String refreshToken = jwtTokenUtil.generateTokenRefresh(userDetails);
	        
	        loginMap.put("refresh_token", refreshToken);
	        //userDetailsService.updRefreshToken(loginMap);
			
			/* 로그인 성공 시 비밀번호 틀린 횟수 초기화
	        * + 리프레쉬토큰 db저장
	        */
			int udpPwerrInit = userDetailsService.updPwerr_ntInit(loginMap);
	        cookieUtil.createCookie("refresh_token", criptoConfig.encript(refreshToken),60*60*2);
	        cookieUtil.createCookie("token", token,60*30,resp);
            session.setAttribute("token", refreshToken);
	        //로그인 로그 입력
	        Map<String, Object> logMap = new HashMap<String, Object>();
	        logMap.put("na_bzplc", loginMap.get("NA_BZPLC"));
	        logMap.put("usrid", loginMap.get("USRID"));
	        logMap.put("url_nm", "/signIn");
	        logMap.put("pgid",   "LOGIN");
	        logMap.put("ipadr",  ip);
	        logMap.put("data_prc_dsc", "S");
	        
	        logService.insUserLog(logMap);
	        
	        //정상 200 리턴
	        return ResponseEntity.ok(new JwtResponse(token, 200, key, iv, userDetails.getUsername(), userDetails.getUserEno(), userDetails.getNa_bzplc(), 
	        		                                 userDetails.getSecurity(), userDetails.getNa_bzplnm(), userDetails.getUserCusName(), userDetails.getGrp_c(),
	        		                                 userDetails.getStrg_dt(), userDetails.getStrg_yn()));
		}else {
			return ResponseEntity.ok(null);
		}
	}
	
	
	@RequestMapping(value="/relogin", method=RequestMethod.POST)
	public ResponseEntity<?> relogin(ResolverMap rMap, HttpServletRequest req, HttpServletResponse resp) throws Exception{
		
		Map<String, Object> map = convertConfig.conMap(rMap);
		//사업장변경
		userDetailsService.updNaBzplc(map);
    	Map<String, String> loginMap = userDetailsService.signIn(map);
		
	
		String jwtStr = map.get("user_id") + "|" + loginMap.get("NA_BZPLC");
		JwtRequest authenticationRequest = new JwtRequest();
		authenticationRequest.setUsername(jwtStr);
		authenticationRequest.setPassword((String) map.get("user_id"));
		
		authenticate(authenticationRequest.getUsername(), authenticationRequest.getPassword());	    
			    	
	    final JwtUser userDetails = (JwtUser) userDetailsService.loadUserByUsername(authenticationRequest.getUsername());
	    
	    userDetails.setApl_ed_dtm("19000101120000");
	    userDetails.setSecurity("0");
	    final String token = jwtTokenUtil.generateToken(userDetails);
        final String refreshToken = jwtTokenUtil.generateTokenRefresh(userDetails);
        loginMap.put("refresh_token", refreshToken);
		int udpPwerrInit = userDetailsService.updPwerr_ntInit(loginMap);
		
        req.getSession(true).setAttribute("token", refreshToken);
        cookieUtil.createCookie("refresh_token", criptoConfig.encript("newRtoken"),60*60*2,resp);
        cookieUtil.createCookie("token", token ,60*30,resp);
	     
	    String ip = (req.getHeader("X-Forwarded-For") ==  null)?req.getRemoteAddr():req.getHeader("X-Forwarded-For");
	    
	    //로그인 로그 입력
	    Map<String, Object> logMap = new HashMap<String, Object>();
	    logMap.put("na_bzplc", loginMap.get("NA_BZPLC"));
	    logMap.put("usrid", loginMap.get("USRID"));
	    logMap.put("url_nm", "/relogin");
	    logMap.put("pgid",   "RELOGIN");
	    logMap.put("ipadr",  ip);
	    logMap.put("data_prc_dsc", "S");
	    
	    logService.insUserLog(logMap);
	    
	    //정상 200 리턴
	    return ResponseEntity.ok(new JwtResponse(token, 200, key, iv, userDetails.getUsername(), userDetails.getUserEno(), userDetails.getNa_bzplc(), 
	    		                                                      userDetails.getSecurity(), userDetails.getNa_bzplnm(), userDetails.getUserCusName(), userDetails.getGrp_c(),
	    		                                                      userDetails.getStrg_dt(), userDetails.getStrg_yn()));
		
	}
	
	@ResponseBody
	@RequestMapping(value="/userLogout", method=RequestMethod.POST)
	public Map<String, Object> logout(HttpServletRequest req, HttpServletResponse resp) throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", "logOut");
		HttpSession session = req.getSession();
		String token = (String)session.getAttribute("token");
		if(StringUtils.isNotEmpty(token)) {
	        Map<String,Object> temp = new HashMap<String, Object>();
	        temp.put("refresh_token", token);
	        Map<String, String> userMap = userDetailsService.signIn(temp);
	        if(token.equals(userMap.getOrDefault("TOKEN",""))) {
		        temp.put("refresh_new_token", "");
		        temp.put("usrid", jwtTokenUtil.getAllClaimsFromTokenClaim(token).get("userId"));
		        userDetailsService.updRefreshToken(temp);				        	
	        }			
		}
		session.setAttribute("token", "");
		session.invalidate();
		
		JSONObject reJson = commonFunc.convertMaptoJson(resultMap);
		String encript = criptoConfig.encript(reJson.toString());
		Map<String, Object> reMap = new HashMap<String, Object>();
		reMap.put("data", encript);
		return reMap;		
	}
	
    private void authenticate(String username, String password) throws Exception {   
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
        } catch (DisabledException e) {
            throw new Exception("USER_DISABLED", e);
        } catch (BadCredentialsException e) {
            throw new Exception("INVALID_CREDENTIALS", e);
        }
    }
}
