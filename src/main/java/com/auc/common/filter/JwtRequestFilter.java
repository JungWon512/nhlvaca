package com.auc.common.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSessionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.auc.common.config.CookieUtil;
import com.auc.common.config.CriptoConfig;
import com.auc.common.config.JwtTokenUtil;
import com.auc.common.vo.JwtUser;
import com.auc.main.service.LogService;
import com.auc.main.service.Impl.JwtUserDetailsService;
import com.auc.common.exception.ErrorCode;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;

@Component
public class JwtRequestFilter extends OncePerRequestFilter{
	
	private static Logger log = LoggerFactory.getLogger(JwtRequestFilter.class);
	
	@Autowired
    private JwtUserDetailsService jwtUserDetailsService;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;    
    @Autowired
    LogService logService;
    @Autowired
    CookieUtil cookieUtil;
    @Autowired
    CriptoConfig criptoConfig;    
    
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException, SqlSessionException {

		final String requestTokenHeader = request.getHeader("Authorization");
				
        String username = null;
        String accessToken = null;
               
        Claims claims = null;
        Claims refresh_claims = null;
        HttpSession session = request.getSession();
        String uri = request.getRequestURI();
		String refresh_token = "";
		//log.info("URI : "+ uri);
		
		if(session != null) {
			refresh_token = (String)session.getAttribute("token");
			//리프레쉬 토큰의 경우 복호화하여 쿠키에 저장
			if(refresh_token== null || refresh_token.isEmpty()) refresh_token = criptoConfig.decrypt(cookieUtil.getCookieValue(request, "refresh_token"));
		}
        // JWT Token is in the form "Bearer token". Remove Bearer word and get
        // only the Token
		if(refresh_token == null || "".equals(refresh_token)) {
    		//세션 리프레쉬토큰 없을경우 부적합한 사용자 안내
			log.info("JWT Session Refresh Token is None");
			request.setAttribute("exception", ErrorCode.EXPIERD_SESSION.getCode());            		
    	}else if (requestTokenHeader != null && requestTokenHeader.startsWith("Bearer ")) {
            accessToken = requestTokenHeader.substring(7);
            try { 
            	if(jwtTokenUtil.isTokenExpired(accessToken)) {
            		log.info("JWT Session Access Token is expired..");
        			Map<String, Object> tempMap = new HashMap<String, Object>();        
		            refresh_claims   = jwtTokenUtil.getAllClaimsFromTokenClaim(refresh_token);
        			tempMap.put("refresh_token",refresh_token);
        			tempMap.put("na_bzplc",refresh_claims.get("na_bzplc"));
        			Map<String, String> map = jwtUserDetailsService.signIn(tempMap);			            
		            /* 관리자 권한일시 중복로그인 제어 */			
					//리프레쉬 토큰 DB조회후 세션 토큰값과 비교해서 일치한지 비교(DB값이 없을경우 부적합한 사용자로 안내) 
					if("001".equals(refresh_claims.get("grp_c"))
							&& (map == null || "".equals(map.getOrDefault("TOKEN","")) || !refresh_token.equals(map.getOrDefault("TOKEN","")))
					) {
						username = null;
						log.info("JWT Refresh Token is Invalid");
						request.setAttribute("exception", ErrorCode.INVALID_TOKEN.getCode());
					}else if(jwtTokenUtil.isTokenExpired(refresh_token)) {
						//리프레쉬 토큰 만료시 만료된 사용자로 안내
						username = null;
						log.info("JWT Refresh Token has expired");
						request.setAttribute("exception", ErrorCode.EXPIERD_TOKEN.getCode());
					}else {
						//엑세스 토큰만 만료시 리프레쉬토큰,엑세스토큰 신규생성하여 토큰 갱신
			            log.info("JWT Access Token new Generate");
		            	/* s: 신규 엑세스토큰/리프레시토큰 생성*/
			            String tokenName = map.getOrDefault("USRID","")+"|"+map.getOrDefault("NA_BZPLC","");
			            
			            JwtUser detail= (JwtUser) jwtUserDetailsService.loadUserByUsername(tokenName);
			        	detail.setApl_ed_dtm((String)refresh_claims.get("apl_ed_dtm"));        	
						detail.setSecurity((String)refresh_claims.get("security"));
			            
						String newToken =  jwtTokenUtil.generateToken(detail);
			            String newRtoken =  jwtTokenUtil.generateTokenRefresh(detail);
			            
			            Map<String,Object> temp = new HashMap<String, Object>();
			            temp.put("refresh_token", refresh_token);
			            temp.put("refresh_new_token", newRtoken);
			            temp.put("usrid", map.getOrDefault("USRID",""));
			            jwtUserDetailsService.updRefreshToken(temp);
			            session.setAttribute("token",newRtoken);
						
						/* e: 신규 엑세스 토큰/리프레시 토큰 생성*/
 			            //신규 엑세스토큰/리프레시토큰 생성 시 토큰 validate 체크를 위한 값 저장(claims,username)
						accessToken = newToken;
						refresh_token = newRtoken;
		                claims   = jwtTokenUtil.getAllClaimsFromTokenClaim(accessToken);
		                username = jwtTokenUtil.getUsernameFromToken(accessToken) + "|" + claims.get("na_bzplc");

						//refresh_claims   = jwtTokenUtil.getAllClaimsFromTokenClaim(newRtoken);
						//log.info("jwt Access new Token Expiration Date : "+claims.getExpiration());
						//log.info("jwt Refresh new Token Expiration Date : "+refresh_claims.getExpiration());           
					}
            	}else {
            		/* 관리자 권한일시
            		 * 엑세스 토큰만 만료되지 않았을 경우 세션,DB간 리프레쉬토큰 비교후 불일치시 부적합 사용자 안내 
            		 */
        			Map<String, Object> tempMap = new HashMap<String, Object>();
        			tempMap.put("refresh_token",refresh_token);
        			refresh_claims   = jwtTokenUtil.getAllClaimsFromTokenClaim(refresh_token);
        			tempMap.put("na_bzplc",refresh_claims.get("na_bzplc"));
        			Map<String, String> map = jwtUserDetailsService.signIn(tempMap);
        			
					//리프레쉬 토큰 조회후 토크값이 상이하거나 없으면면 부적합한 사용자로 안내
					if("001".equals(refresh_claims.get("grp_c")) && (map == null || "".equals(map.get("TOKEN")) 
							|| !refresh_token.equals(map.get("TOKEN")))
					){
						username = null;
						log.info("JWT Refresh Token is Invalid");
						request.setAttribute("exception", ErrorCode.INVALID_TOKEN.getCode());						
					}else {
						//기존 엑세스토큰 미만료시 토큰 validate 체크를 위한 값 저장(claims,username)
	                    claims   = jwtTokenUtil.getAllClaimsFromTokenClaim(accessToken);
	                    username = jwtTokenUtil.getUsernameFromToken(accessToken) + "|" + claims.get("na_bzplc");
					}
            	}
            	//엑세스/리프레쉬 토큰 갱신을 위한 쿠키저장(쿠키로 저장후 응답 후 쿠기의 토큰값 localStorage에 저장
            	response.addCookie(cookieUtil.createCookie("token", accessToken));
        		//리프레쉬 토큰의 경우 암화하하여 쿠키에 저장
            	response.addCookie(cookieUtil.createCookie("refresh_token", criptoConfig.encript(refresh_token)));
            } catch (IllegalArgumentException e) {
            	log.info("Unable to get JWT Token");
            	request.setAttribute("exception", ErrorCode.UNABLE_TOKEN.getCode());
            } catch (ExpiredJwtException e) {
            	log.info("JWT Token has expired");
            	request.setAttribute("exception", ErrorCode.EXPIERD_TOKEN.getCode());
            } catch (JwtException e) {
            	log.info("invalid token");
            	request.setAttribute("exception", ErrorCode.INVALID_TOKEN.getCode());            	
            }catch (Exception ex) {
				log.info("JwtToken SQL Error",ex);
				request.setAttribute("exception", ErrorCode.INVALID_TOKEN.getCode());
			}
        } else {
//        	log.warn("JWT Token does not begin with Bearer String");
        }

        // Once we get the token validate it.
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
        	//claims
            UserDetails userDetails = this.jwtUserDetailsService.loadUserByUsername(username);
            if (jwtTokenUtil.validateToken(accessToken, userDetails)) {
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = 
                		new UsernamePasswordAuthenticationToken(new JwtUser(claims), null, userDetails.getAuthorities());
                usernamePasswordAuthenticationToken
                    .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
            if(uri.lastIndexOf("/LALM") > -1) {
            	Map<String, Object> map = new HashMap<String, Object>();
                String ip = (request.getHeader("X-Forwarded-For") ==  null)?request.getRemoteAddr():request.getHeader("X-Forwarded-For");
                String[] arr = uri.split("_");
                String pgid = arr[0].substring(1);
                String dataPrcDsc = "";
                if("ins".equals(arr[1].substring(0,3)) ) {
                	dataPrcDsc = "I";
                }else if("upd".equals(arr[1].substring(0,3)) ) {
                	dataPrcDsc = "U";
                }else if("del".equals(arr[1].substring(0,3)) ) {
                	dataPrcDsc = "D";
                }else if("sel".equals(arr[1].substring(0,3)) ) {
                	dataPrcDsc = "S";
                }
                                
        		map.put("na_bzplc",(String)claims.get("na_bzplc"));
        	    map.put("usrid", (String)claims.get("userId"));
        		map.put("url_nm",  uri);
        		map.put("ipadr",  ip);
        		map.put("pgid",  pgid);
        		map.put("data_prc_dsc", dataPrcDsc);
        		
        		insFilterLog(map);     
            }
        }
		filterChain.doFilter(request, response);
	}
	
	
	public void insFilterLog(Map<String, Object> map) {
		try {
			logService.insUserLog(map);
		} catch (ServletException | RuntimeException e1 ) {
			log.info("동작중 오류가 발생하였습니다.");
		} catch (Exception e) {
			log.info("동작중 오류가 발생하였습니다.");
		}
	}
	
	
	
	
}
