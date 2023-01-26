package com.auc.common.config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import com.auc.main.service.CommonService;


@ControllerAdvice
@org.springframework.web.bind.annotation.RestControllerAdvice
public class RestControllerAdvice<T> implements ResponseBodyAdvice<T> {
	private static Logger log = LoggerFactory.getLogger(RestControllerAdvice.class);

    @Autowired
    private CriptoConfig criptoConfig;    
	@Autowired
	CommonService commonService;

	@Override
	public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public T beforeBodyWrite(T body, MethodParameter returnType, MediaType selectedContentType,
			Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request,
			ServerHttpResponse response) {
		if(body instanceof HashMap) {					
			Map<String, Object> temp = (Map<String, Object>) body;
			ServletServerHttpRequest sshr = (ServletServerHttpRequest) request;
			HttpServletRequest hsr = sshr.getServletRequest();
			String uri = hsr.getRequestURI();

            if(uri.lastIndexOf("/LALM") > -1 && !(uri.lastIndexOf("/LALM08") > -1)) {
    			try {
	    			String ip = (hsr.getHeader("X-Forwarded-For") ==  null)?hsr.getRemoteAddr():hsr.getHeader("X-Forwarded-For");
	                String[] arr = uri.split("_");
	                String pgid = arr[0].substring(1);
	                String dataPrcDsc = "";
	                if("sel".equals(arr[1].substring(0,3)) ) {
	                	dataPrcDsc = "S";
	                	String data = hsr.getParameter("data");
	                	String param = "";
	                	if(data != null) {
		        			param = criptoConfig.decrypt(data);	                		
	                	}
	        			
		    			Map<String, Object> inMap = new HashMap<>();
		    			inMap.put("ss_na_bzplc", temp.get("ss_bzplc"));
		    			inMap.put("pgid", pgid);
		    			inMap.put("inq_cn", temp.getOrDefault("dataCnt","0"));
		    			inMap.put("btn_tpc", dataPrcDsc);
		    			inMap.put("ipadr", ip);
		    			inMap.put("srch_cnd_cntrn", (param.length() > 2600 ? param.substring(0, 2600) : param));
		    			inMap.put("apvrqr_rsnctt", "");
		    			inMap.put("ss_userid", temp.get("ss_userid"));
						commonService.Common_insDownloadLog(inMap);
	                }
				} catch (RuntimeException | SQLException e) {
					log.error("ControllerAdvice Log 작업중 에러...",e);
				}	catch (Exception e) {
					log.error("ControllerAdvice Log 작업중 에러...",e);
				}	
            }
			
							
		}		
			
		return body;
	}

}
