package com.auc.common.config;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
public class DataBaseConfig {
	
<<<<<<< HEAD
 	 @Bean
	 public DataSource dataSource() {
	  return DataSourceBuilder.create()
	     .driverClassName("com.tmax.tibero.jdbc.TbDriver")
	     .url("jdbc:tibero:thin:@115.41.222.25:8629:tibero")
	     .username("lalm")
	     .password("lalm123")
	     .build();
=======
// 	 @Bean
//	 public DataSource dataSource() {
//	  return DataSourceBuilder.create()
//	     .driverClassName("com.tmax.tibero.jdbc.TbDriver")
//	     .url("jdbc:tibero:thin:@192.168.70.60:5550:NHLVADBD")
//	     .username("nhlva")
//	     .password("Nhlva1!")
//	     .build();
//	}
	
	@Bean
	public DataSource dataSource() throws NamingException {
		JndiDataSourceLookup lookup = new JndiDataSourceLookup();
		lookup.setResourceRef(true);
		DataSource ds = lookup.getDataSource("jdbc/nhlva");
		return ds;
>>>>>>> branch 'master' of https://github.com/yuchansong410/nhlvaca.git
	}
 	
 	@Bean
 	public DataSource dataSource() throws NamingException {
 		JndiDataSourceLookup lookup = new JndiDataSourceLookup();
 		lookup.setResourceRef(true);
 		DataSource ds = lookup.getDataSource("jdbc/nhlva");
 		return ds;
 	}
 	
  	@Bean
  	public PlatformTransactionManager txManager() throws Exception {
  		return new DataSourceTransactionManager(dataSource());
  	}

 	
 	
 	
 }
