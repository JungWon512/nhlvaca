package com.auc;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@MapperScan(basePackages = "com.auc.**.*Impl")
@SpringBootApplication
public class BrAucApplication extends SpringBootServletInitializer{

	public static void main(String[] args) {
		SpringApplication.run(BrAucApplication.class, args);
			
	}
	
	@Override 
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) 
	{ return builder.sources(BrAucApplication.class); }
}
