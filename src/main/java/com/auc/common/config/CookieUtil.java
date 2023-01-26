package com.auc.common.config;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

@Component
public class CookieUtil {
	
	/**
	 * 쿠키 생성
	 * @param cookieName
	 * @param value
	 * @return
	 */
	public Cookie createCookie(String cookieName, String value) {
		value = value.replaceAll("\r", "").replaceAll("\n", "");
		Cookie cookie = new Cookie(cookieName, value);
//		cookie.setHttpOnly(true);
		cookie.setMaxAge(60*60*24);
		cookie.setSecure(true);
		cookie.setPath("/");
		return cookie;
	}
	public Cookie createCookie(String cookieName, String value,int age) {
		Cookie cookie = new Cookie(cookieName, value);
		cookie.setMaxAge(age);
		cookie.setSecure(true);
		cookie.setPath("/");
		return cookie;
	}
	public void createCookie(String cookieName, String value,HttpServletResponse response) {
		Cookie cookie = createCookie(cookieName,value);
		response.addCookie(cookie);
	}
	public void createCookie(String cookieName, String value,int age,HttpServletResponse response) {
		Cookie cookie = createCookie(cookieName,value,age);
		response.addCookie(cookie);
	}
	
	/**
	 * 쿠키 정보 가져오기
	 * @param req
	 * @param cookieName
	 * @return
	 */
	public Cookie getCookie(HttpServletRequest req, String cookieName){
		try {
			final Cookie[] cookies = req.getCookies();
			if(cookies==null) return null;
			for(Cookie cookie : cookies){
				if(cookie.getName().equals(cookieName)) {
					return cookie;
				}
			}
		}catch (RuntimeException re) {
			return null;
		}
		return null;
	}
	
	/**
	 * 쿠키 값 가져오기
	 * @param req
	 * @param cookieName
	 * @return
	 */
	public String getCookieValue(HttpServletRequest req, String cookieName) {
		try {
			if (this.getCookie(req, cookieName) == null) {
				return "";
			}
			else {
				return this.getCookie(req, cookieName).getValue();
			}
		}catch (RuntimeException re) {
			return "";
		}
	}
	
	/**
	 * 쿠키 삭제
	 * @param req
	 * @param cookieName
	 * @return
	 */
	public Cookie deleteCookie(HttpServletRequest req, String cookieName) {
		Cookie cookie = new Cookie(cookieName, null);
		cookie.setMaxAge(0);
		cookie.setPath("/");
		return cookie;
	}

}
