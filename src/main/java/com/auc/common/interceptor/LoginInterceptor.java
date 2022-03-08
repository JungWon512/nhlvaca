package com.auc.common.interceptor;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.auc.common.vo.JwtUser;
import com.auc.common.vo.LoginUser;


@Component
public class LoginInterceptor implements HandlerInterceptor{
	
	private static Logger log = LoggerFactory.getLogger(LoginInterceptor.class);
	
	@Resource
	LoginUser loginUser;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws IOException {
						
		String path = request.getRequestURI();

		log.info(path);
		
		log.info(loginUser.getId());
		
		//중복로그인 처리if(!jwtuser.getUsername().equals("")) {
		if(path.equals("/") && loginUser.getId() != null){
	    	response.sendRedirect("/index");
	    	return false;
		}
				
		//토큰 사용자 정보 받아오기
		//jwtUser jwtuser = null;
		
//		Object obj = SecurityContextHolder.getContext().getAuthentication();
//		
//		if( obj != null) {
//			jwtuser = (jwtUser)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//		}		
		
		//중복로그인 처리if(!jwtuser.getUsername().equals("")) {
//		if(path.equals("/") && obj != null){
//	    	response.sendRedirect("/index");
//	    	return false;
//		}
		
		return true;
		
	}
		
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
	                       ModelAndView modelAndView) throws Exception {
		
	        // TODO Auto-generated method stub
    }
 
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        // TODO Auto-generated method stub
    }



}
