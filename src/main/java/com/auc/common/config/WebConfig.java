package com.auc.common.config;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.auc.common.interceptor.AucArgumentResolver;
import com.auc.common.interceptor.BearerAuthInterceptor;
import com.auc.common.interceptor.LoginInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
	private static Logger log = LoggerFactory.getLogger(WebConfig.class);
	
	@Autowired
	BearerAuthInterceptor bearerAuthInterceptor;
	
	@Autowired
	LoginInterceptor loginInterceptor;

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		
//		registry.addInterceptor(bearerAuthInterceptor).excludePathPatterns("/authenticate")
//											          .excludePathPatterns("/")
//											          .addPathPatterns("/*");
		
//		registry.addInterceptor(loginInterceptor).excludePathPatterns("/authenticate")
//												 .excludePathPatterns("/getLogin")
//		                                         .excludePathPatterns("/selectMenuList")
//		                                         .addPathPatterns("/*");
		
	}
	

	@Bean
	public AucArgumentResolver aucArgumentResolver() {
		return new AucArgumentResolver();
	}
	
	@Bean
	public MappingJackson2JsonView jsonView() {
		return new MappingJackson2JsonView();
	}
	
	
	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
		argumentResolvers.add(aucArgumentResolver());	    
	}	
	
	@Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://127.0.0.1:8080");
    }
	
	

}
