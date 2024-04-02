package com.auc.common.config;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.auc.common.interceptor.MybatisInterceptor;

@Configuration
@EnableTransactionManagement
public class DataBaseConfig {
	
	@Bean(name = "dataSource")
	@Profile("local")
	 public DataSource dataSourceLocal() {
	  return DataSourceBuilder.create()
	     .driverClassName("net.sf.log4jdbc.sql.jdbcapi.DriverSpy")
	     .url("jdbc:log4jdbc:tibero:thin:@115.41.222.25:8629:tibero")
	     .username("lalm")
	     .password("lalm123")
	     .build();
	}
	
	@Bean(name = "dataSource")
	@Profile({"develop","production"})
	public DataSource dataSource() throws NamingException {
		JndiDataSourceLookup lookup = new JndiDataSourceLookup();
		lookup.setResourceRef(true);
		DataSource ds = lookup.getDataSource("jdbc/nhlva");
		
		return ds;
	}
	
 	@Bean
 	public PlatformTransactionManager txManager(@Qualifier("dataSource") DataSource dataSource) throws Exception {
 		return new DataSourceTransactionManager(dataSource);
 	}
	
}
