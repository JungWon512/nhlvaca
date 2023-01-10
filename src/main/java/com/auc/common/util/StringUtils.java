package com.auc.common.util;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.Base64Utils;

import com.auc.common.config.RSACriptoConfig;
@Component
public class StringUtils {
	
	private static Logger log = LoggerFactory.getLogger(StringUtils.class);
	
	/**
	 * 문자열 null일때 defaultValue 반환
	 * @param source
	 * @param defaultValue
	 * @return
	 */
	public static String NULL(String source, String defaultValue) {
		if ("null".equals(source))
			return defaultValue;
		return source;
	}
	/**
	 * 문자열 null일때 defaultValue 반환
	 * @param source
	 * @param defaultValue
	 * @return
	 */
	public static String NULL(Object source, String defaultValue) {
		if (null == source || "".equals(source.toString()))
			return defaultValue;
		return source.toString();
	}
	/**
	 * 문자열 null일때 defaultValue 반환
	 * @param source
	 * @return
	 */
	public static String NULL(Object source) {
		if (null == source)
			return "";
		return source.toString();
	}
	/**
	 * null인지 체크
	 * @param source
	 * @return
	 */
	public static boolean isNotEmpty(String source) {
		return ("".equals(NULL(source)) ? false : true);
	}
	
	/**
	 * 변수가 null이거나 빈값 여부
	 * @param {Object} obj : 검사할 값
	 * @return {boolean} true : null 또는 빈값, false : 값 존재
	 */
	public static boolean isEmpty(Object obj) {
		boolean flag = false;
		
		if (obj == null) {
			flag = true;
		} else {
			if (obj.toString().length() < 1)
				flag = true;
		}
		
		return flag;
	}

	/**
	 * LPadding
	 * @return
	 */
	public static String LPadding(String str, char paddChar, int cnt) {
		return String.format("%"+ cnt +"s", str).replace(' ', paddChar);
	} 
	
	/**
	 * LPadding
	 * @return
	 */
	public static String RPadding(String str, char paddChar, int cnt) {
		return String.format("%"+ -cnt +"s", str).replace(' ', paddChar);
	}
	
	
	/**
	 * blobToBytes
	 * Blob를 Byte로 변환
	 * @return byte
	 */
	
	public static byte[] blobToBytes(Blob blob) {
		BufferedInputStream is = null;
		byte[] bytes = null;
		try {
			is = new BufferedInputStream(blob.getBinaryStream());
			bytes = new byte[(int)blob.length()];
			int len = bytes.length;
			int offset = 0;
			int read = 0;
			
			while(offset < len && ( read = is.read(bytes, offset, len - offset)) >= 0) {
				offset += read;
			}
		}catch(RuntimeException | IOException | SQLException e) {
			log.info("동작중 오류가 발생하였습니다.");
		}
		return bytes;
	}
	

	/**
	 * byteToBase64
	 * Byte를 Base64로 변환
	 * @return String
	 */
	public static String byteToBase64(byte[] arr) {
		String result = "";
		try {
			result = Base64Utils.encodeToString(arr);
		}catch(RuntimeException e) {
			log.info("동작중 오류가 발생하였습니다.");
		}
		return result;
	}
	
	/**
	 * xxsFilter
	 * 크로스사이트 스크립트 필터
	 * @return String
	 */
	public static String xxsFilter(String str) {
		String result = "";
		if(str != null && !"".equals(str))result =str;
		result = result.replaceAll("[&]", "&amp;");
		result = result.replaceAll("[#]", "&#35;");
		result = result.replaceAll("[<]", "&lt;");
		result = result.replaceAll("[>]", "&gt;");
		result = result.replaceAll("[(]", "&#40;");
		result = result.replaceAll("[)]", "&#41;");
		result = result.replaceAll("[\"]","&quot;");
		result = result.replaceAll("[']", "&#x27;");
		
		return result;
	}
	
}
