package com.auc.main.service.Impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.auc.common.vo.JwtUser;

@Service
public class JwtUserDetailsService implements UserDetailsService{
	
	@Autowired
	MainMapper mainMapper;
	@Autowired
	PasswordEncoder passwordEncoder;
	   
	@Value("${spring.profiles.service-name:nhlva}")
	private String serviceName;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		String user_id = username.substring(0, username.lastIndexOf("|"));
		String na_bzplc = username.substring(username.lastIndexOf("|")+1 , username.length());
        Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("user_id", user_id);
		paraMap.put("na_bzplc", na_bzplc);
	    Map<String, String> selMap = null;	        
		selMap = mainMapper.signIn(paraMap);
		if (selMap.get("USRID").equals(user_id)) { 
		    return new JwtUser((String)selMap.get("USRID"), passwordEncoder.encode((String)selMap.get("USRID")), (String)selMap.get("ENO"), 
		    		           (String)selMap.get("USRNM"), (String)selMap.get("NA_BZPLC"), (String)selMap.get("NA_BZPLNM"), (String)selMap.get("GRP_C"),
		    		           (String)selMap.get("STRG_DT"), selMap.getOrDefault("STRG_YN", "1"));
	    } else { 
	        throw new UsernameNotFoundException("User not found with username: " + username);
	    }
    }			
	  
	public Map<String, String> signIn(Map<String, Object> signMap) throws Exception{						
	    Map<String, String> selMap = null;						
	    selMap = mainMapper.signIn(signMap);	
	    if(selMap == null)selMap = new HashMap<String, String>(); 
	    return selMap;	
    }
	  
	public int updPwerr_nt(Map<String, String> map) {
	    int updPw = 0;
	    updPw = mainMapper.updPwerr_nt(map);
		return updPw;
	}

	public int updPwerr_ntInit(Map<String, String> map) {
	    int updPw = 0;
	    updPw = mainMapper.updPwerr_ntInit(map);
		return updPw;
	}
	
	public int updNaBzplc(Map<String, Object> map) {
	    int updNaBzplc = 0;
	    updNaBzplc = mainMapper.updNaBzplc(map);
		return updNaBzplc;
	}

	public int selChkPw(String usrid, String user_pw) {
		int chkPw = 0;
		if ("tibero".equals(serviceName)) {
			Map<String, Object> pwMap = mainMapper.selChkPwTibero(usrid, user_pw);
			if (passwordEncoder.matches(user_pw, pwMap.getOrDefault("PW", "").toString())) return 1;
		}
		else {
			chkPw = mainMapper.selChkPw(usrid, user_pw);
		}
		return chkPw;
	}

	public int updRefreshToken(Map<String, Object> map) throws Exception {
	    return mainMapper.updRefreshToken(map);
	}

	public int delUser(Map<String, String> loginMap) {
	    return mainMapper.delUser(loginMap);
	}

	public int selChkPw(Map<String, Object> map) {
		int chkPw = 0;
		chkPw = mainMapper.selChkPw(map);
		return chkPw;
	}


}
