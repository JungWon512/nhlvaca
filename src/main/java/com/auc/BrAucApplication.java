package com.auc;

import javax.servlet.http.HttpSessionListener;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;

@MapperScan(basePackages = "com.auc.**.*Impl")
@SpringBootApplication
@EnableScheduling
public class BrAucApplication{

	public static void main(String[] args) {
		SpringApplication.run(BrAucApplication.class, args);
	}
	
	@Bean
	public HttpSessionListener httpSessionListener() {
		return new SessionListener();
	} 
}
