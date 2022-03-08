package com.auc.common.filter;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.auc.common.config.JwtTokenUtil;
import com.auc.common.config.RSACriptoConfig;
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
	
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException, SqlSessionException {

		final String requestTokenHeader = request.getHeader("Authorization");
				
        String username = null;
        String jwtToken = null;
               
        Claims claims = null;
        
        // JWT Token is in the form "Bearer token". Remove Bearer word and get
        // only the Token
        if (requestTokenHeader != null && requestTokenHeader.startsWith("Bearer ")) {
            jwtToken = requestTokenHeader.substring(7);
            
            try {
                claims   = jwtTokenUtil.getAllClaimsFromTokenClaim(jwtToken);
                username = jwtTokenUtil.getUsernameFromToken(jwtToken) + "|" + claims.get("na_bzplc");
                
            } catch (IllegalArgumentException e) {
            	log.info("Unable to get JWT Token");
            	request.setAttribute("exception", ErrorCode.UNABLE_TOKEN.getCode());
            } catch (ExpiredJwtException e) {
            	log.info("JWT Token has expired");
            	request.setAttribute("exception", ErrorCode.EXPIERD_TOKEN.getCode());
            } catch (JwtException e) {
            	log.info("invalid token");
            	request.setAttribute("exception", ErrorCode.INVALID_TOKEN.getCode());            	
            }
        } else {
//        	log.warn("JWT Token does not begin with Bearer String");
        }

        // Once we get the token validate it.
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            UserDetails userDetails = this.jwtUserDetailsService.loadUserByUsername(username);

            if (jwtTokenUtil.validateToken(jwtToken, userDetails)) {
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(
                		new JwtUser(claims), null, userDetails.getAuthorities());
                usernamePasswordAuthenticationToken
                    .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
            String uri = request.getRequestURI();
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
