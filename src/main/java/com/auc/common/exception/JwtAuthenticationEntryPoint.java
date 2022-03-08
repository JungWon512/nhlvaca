package com.auc.common.exception;

import java.io.IOException;
import java.io.Serializable;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestParam;

@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint, Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3705262122886050172L;

	
	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException authException) throws IOException, ServletException {
		// TODO Auto-generated method stub
		String exception = (String)request.getAttribute("exception");
		
		/*토큰이 없을경우*/
		if(exception == null) {
			setResponse(request,response,ErrorCode.NOT_LOGIN);
			return;
		}
		
		/*토큰이 만료된 경우 */
		if(exception.equals(ErrorCode.EXPIERD_TOKEN.getCode())) {
			setResponse(request,response,ErrorCode.EXPIERD_TOKEN);
			return;
		}

		/*토큰이 다를경우 */
		if(exception.equals(ErrorCode.INVALID_TOKEN.getCode())) {
			setResponse(request,response,ErrorCode.INVALID_TOKEN);
			return;
		}

		/*토큰이 아닐경우 */
		if(exception.equals(ErrorCode.UNABLE_TOKEN.getCode())) {
			setResponse(request,response,ErrorCode.UNABLE_TOKEN);
			return;
		}
		
		//response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
		
	}
	
	private void setResponse(HttpServletRequest request, HttpServletResponse response, ErrorCode error) throws IOException {
		response.setContentType("application/json;charset=UTF-8");
		response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
		
		if(error.getCode().equals(ErrorCode.NOT_LOGIN.getCode()) || error.getCode().equals(ErrorCode.UNABLE_TOKEN.getCode())) {
			response.sendRedirect("/error/RuntimeError");
		}else {
			response.getWriter().println("{\"message\" : \"" + error.getMessage()
					+ "\", \"code\" : \"" + error.getCode()
					+ "\", \"status\" : " + error.getStatus()
					+ "}");
		}
	}
}
