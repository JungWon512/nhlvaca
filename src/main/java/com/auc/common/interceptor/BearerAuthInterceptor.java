package com.auc.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.auc.common.config.JwtTokenUtil;

@Component
public class BearerAuthInterceptor implements HandlerInterceptor{
	
	private AuthorizationExtractor authorizationExtractor;
	private JwtTokenUtil jwtTokenUtil;
	
	public BearerAuthInterceptor(AuthorizationExtractor authorizationManager, JwtTokenUtil jwtTokenUtil) {
		this.authorizationExtractor = authorizationManager;
		this.jwtTokenUtil = jwtTokenUtil;		
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
		
		String path = request.getRequestURI();
		//토큰추출
		String token = authorizationExtractor.extract(request, "Bearer");
		
		if("".equals(token)) {
			return true;
		}
		
		//토큰 유효성 체크
		if(jwtTokenUtil.isTokenExpired(token)) {
			throw new IllegalArgumentException("유효하지 않은 토큰");
		}
		
		String name = jwtTokenUtil.getSubject(token);
		
		request.setAttribute("name", name);
		
		return true;
	}

}
