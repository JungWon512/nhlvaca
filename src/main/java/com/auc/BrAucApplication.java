package com.auc;

import javax.servlet.http.HttpSessionListener;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;

@MapperScan(basePackages = "com.auc.**.*Impl")
@SpringBootApplication
public class BrAucApplication extends SpringBootServletInitializer{

	public static void main(String[] args) {
		SpringApplicationBuilder builder = new SpringApplicationBuilder(BrAucApplication.class);
		SpringApplication app = builder.build();
		app.run(args);
			
	}
	
	@Override 
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) 
	{ 
		return builder.sources(BrAucApplication.class); 
	}
	
	@Bean
	public HttpSessionListener httpSessionListener() {
		return new SessionListener();
	} 
}
